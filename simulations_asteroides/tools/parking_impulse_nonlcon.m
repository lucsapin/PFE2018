function [cin, ceq, delta_Vf_p_L2] = parking_impulse_nonlcon(Xsol, xOrb_epoch_t0_Ast, q0_SUN_AU, t0_p, ratio)

  UC          = get_Univers_Constants(); % Univers constants

  %
  icur        = 1;
  dt1_p       = Xsol(icur)           ; icur = icur + 1; % time of the second boost
  dtf_p       = Xsol(icur)           ; icur = icur + 1; % final time when we meet the EMB
  delta_V0_p  = Xsol(icur:icur+3-1)/ratio  ; icur = icur + 3; % first boost at time t0_p
  delta_V1_p  = Xsol(icur:icur+3-1)/ratio  ; icur = icur + 3; % second boost at time t0_p + dt1_p
  delta_Vf_p  = Xsol(icur:icur+3-1)/ratio  ; icur = icur + 3; % last boost at time t0_p + dt1_p + dtf_p

  % Dynamique : 3BP TOUT SE FAIT DANS LE REPERE TOURNANT !!!!
  % Conversion dans repère tournant :
  [q0_CR3BP,~,~,~,thetaS0]    = Helio2CR3BP(q0_SUN_AU, t0_p);
  % Quelques paramètres
  muSun       = UC.mu0SunLD/(UC.mu0EarthLD+UC.mu0MoonLD);
  muCR3BP     = UC.mu0MoonLD/(UC.mu0EarthLD+UC.mu0MoonLD);
  rhoS        = UC.AU/UC.LD;
  omegaS      = (-(UC.speedMoon+UC.NoeudMoonDot)+2*pi/UC.Period_EMB)/UC.jour*UC.time_syst;
  % Paramètres d'intégration
  OptionsOde  = odeset('AbsTol',1.e-6,'RelTol',1.e-6);
  odefun      = @(t,x) rhs_BP(t, x, muCR3BP, muSun, rhoS, thetaS0, omegaS, 3);

  % state of the spacecraft at t0_p
  q0        = q0_CR3BP(:);
  % first boost
  q0(4:6)   = q0(4:6) + delta_V0_p(:);

  % State at t0_p + dt1_p
  [times, states_q_L] = ode45(odefun, [t0_p t0_p+dt1_p], q0, OptionsOde);
  states_q_L1 = transpose(states_q_L);

  % Second boost !
  q1          = states_q_L1(1:6,end);
  q1(4:6)     = q1(4:6) + delta_V1_p(:);

  [times, states_q_L] = ode45(odefun, [t0_p+dt1_p t0_p+dt1_p+dtf_p], q1, OptionsOde);
  states_q_L2 = transpose(states_q_L);

  % State at t0 + dt1_p + dtf_p
  qf          = states_q_L2(1:6,end);


  % ------------------------------------------------------------------------------
  % Constraint: qf = state of the EMB at time t0_p + dt1_p + dtf_p
  % EMB's state at time t0_p + dt1_p + dtf_p
  xOrb_epoch_t0_EMB   = get_EMB_init_Orbital_elements();
  final_state_EMB     = get_Current_State_Cart(xOrb_epoch_t0_EMB, t0_p + dt1_p + dtf_p);

  % Moon's & L2's state in EMB frame, LD
  [qM, ~, qL2_EMB_LD] = get_Moon_Earth_L2_State_Cart_LD(t0_p + dt1_p + dtf_p);
  % EMB's state in SUN frame, AU
  qEMB_SUN_AU = final_state_EMB(:);
  % L2's state in SUN frame, AU
  qL2_SUN_AU = qEMB_SUN_AU(:) + qL2_EMB_LD(:)*UC.LD/UC.AU;

  % Convert qf from Rotating Frame to Heliocentric Frame
  % First : from Rotating frame to EMB frame (LD)
  qf          = CR3BP2EMB(qf, t0_p + dt1_p + dtf_p);
  % Finally : from EMB frame (LD) to Heliocentric Frame (AU)
  qf          = qEMB_SUN_AU(:) + qf(:)*UC.LD/UC.AU;

  % Final boost for L2
  % delta_Vf_p_L2 - (qL2_SUN_AU(4:6) - qf(4:6));

  % ------------------------------------------------------------------------------
  % Constraint: start from the Moon orbital plane
  % final velocity in EMB centric inertial

  % L2's velocity in Hélio Inertial
  vf_L2 = delta_Vf_p; % *UC.AU/UC.LD; WHY LD ???

  % Normal to Moon's orbital plane in EMB centric
  normal = cross(qM(1:3),qM(4:6));

  % ------------------------------------------------------------------------------
  ceq     = [qf(1:3) - qL2_SUN_AU(1:3); vf_L2'*normal; qf(4:6) + delta_Vf_p - qL2_SUN_AU(4:6)];
  cin     = [];


  function qdot = rhs_BP(t, q, mu, muSun, rhoS, thetaS0, omegaS, choix)

      q1          = q(1);
      q2          = q(2);
      q3          = q(3);
      q4          = q(4);
      q5          = q(5);

      r1          = sqrt((q1+mu)^2+q2^2+q3^2);
      r2          = sqrt((q1-1+mu)^2+q2^2+q3^2);

      thetaS      = thetaS0 + omegaS*t;
      rS          = sqrt((q1-rhoS*cos(thetaS))^2+(q2-rhoS*sin(thetaS))^2+q3^2);

      qdot        = zeros(6,1);
      qdot(1:3)   = q(4:6);

      cSun = 1.0;

      if(choix==1) % eq 3 corps pas perturbe

          qdot(4) =  2*q5 + q1 - (1-mu)*(q1+mu)/r1^3 - mu*(q1-1+mu)/r2^3;
          qdot(5) = -2*q4 + q2 - (1-mu)*q2/r1^3 - mu*q2/r2^3;
          qdot(6) =            - (1-mu)*q3/r1^3 - mu*q3/r2^3;

      elseif(choix==2) % eq 2 : 3 corps perturbe et modifie par Thomas

          qdot(4) =  2*q5 + q1 - (1-mu)*(q1+mu)/r1^3  - mu*(q1-1+mu)/r2^3 - cSun*(q1-rhoS*cos(thetaS))*muSun/rS^3;
          qdot(5) = -2*q4 + q2 - (1-mu)*q2/r1^3       - mu*q2/r2^3        - cSun*(q2-rhoS*sin(thetaS))*muSun/rS^3;
          qdot(6) =            - (1-mu)*q3/r1^3       - mu*q3/r2^3        - cSun*q3*muSun/rS^3;

      elseif(choix==3) % eq 3 : 3 corps perturbe

          qdot(4) =  2*q5 + q1 - (1-mu)*(q1+mu)/r1^3  - mu*(q1-1+mu)/r2^3 - cSun*(q1-rhoS*cos(thetaS))*muSun/rS^3 - cSun*muSun*cos(thetaS)/rhoS^2;
          qdot(5) = -2*q4 + q2 - (1-mu)*q2/r1^3       - mu*q2/r2^3        - cSun*(q2-rhoS*sin(thetaS))*muSun/rS^3 - cSun*muSun*sin(thetaS)/rhoS^2;
          qdot(6) =            - (1-mu)*q3/r1^3       - mu*q3/r2^3        - cSun*q3*muSun/rS^3;

      % elseif(choix==4) % 2 corps Terre
      %
      %     qdot(4) =  2*q5 + q1 - q1/r1^3;
      %     qdot(5) = -2*q4 + q2 - q2/r1^3;
      %     qdot(6) =            - q3/r1^3;
      %
      % elseif (choix==5) % 2 corps Lune
      %
      %     qdot(4) =  2*q5 + q1 - q1/r2^3;
      %     qdot(5) = -2*q4 + q2 - q2/r2^3;
      %     qdot(6) =            - q3/r2^3;

      end

  return

  return
