function Drift_compare(t0, dt, q0)

format long;

% On compare les dynamiques 3 corps perturbes 3BP avec 3 corps 3B et 4B
% Attention :
%   les dynamiques 3BP et 3B sont dans le repere tournant centre EMB
%   le 4B est dans le repere inertiel centre EMB
%   q0 est dans le repere inertiel centre soleil
%

%
doPlot3B                = true
doPlot3B_Pert           = true
doPlot3B_Pert_Thomas    = true

% Univers constants
UC          = get_Univers_Constants();

% On transforme q0 dans les 2 referentiels
[q0_CR3BP,~,~,~,thetaS0]    = Helio2CR3BP(q0, t0);       % q en LD/d
q0_EMB                      = CR3BP2EMB(q0_CR3BP,t0);

% On definit les parametres d'integration
Nstep       = 100;
OptionsOde  = odeset('AbsTol',1.e-12,'RelTol',1.e-12);

% -------------------------------------------------------------------------------------------------
% On integre avec la dynamique 4 corps (dans le ref inertiel centre en EMB)
%xOrb_epoch_t0_EMB   = get_EMB_init_Orbital_elements();
%xC_EMB              = get_Current_State_Cart(xOrb_epoch_t0_EMB, t0);
%xG_EMB              = Cart2Gauss(UC.mu0SunAU, xC_EMB);
%xG_EMB(1)           = xG_EMB(1)*UC.AU/UC.LD;
xG_EMB0     = UC.xG_EMB0;
xG_EMB0(1)  = xG_EMB0(1)*UC.AU/UC.LD;
L_EMB0      = drift_L(t0, xG_EMB0, UC.mu0SunLD);
qL0_EMB     = [q0_EMB; L_EMB0];

odefun      = @(t,x) rhs_SEM_EMB(t, x, UC.mu0SunLD, UC.mu0EarthLD, UC.mu0MoonLD, xG_EMB0);
T_EMB       = linspace(t0,t0+dt,Nstep);

[~, Q_EMB]  = ode45(odefun, T_EMB, qL0_EMB, OptionsOde);
Q_EMB       = Q_EMB';

% on affiche la trajectoire
%
hFigTraj = figure('Units', 'normalized');
set(hFigTraj, 'OuterPosition', [ 0.5   0.0   0.49   0.9 ]);

color   = 'b';
LW      = 1.5;
subplot(3,2,1); plot(T_EMB, Q_EMB(1,:), color, 'LineWidth', LW); ylabel('q_1'); hold on;
subplot(3,2,3); plot(T_EMB, Q_EMB(2,:), color, 'LineWidth', LW); ylabel('q_2'); hold on;
subplot(3,2,5); plot(T_EMB, Q_EMB(3,:), color, 'LineWidth', LW); ylabel('q_3'); hold on;
subplot(3,2,2); plot(T_EMB, Q_EMB(4,:), color, 'LineWidth', LW); ylabel('q_4'); hold on;
subplot(3,2,4); plot(T_EMB, Q_EMB(5,:), color, 'LineWidth', LW); ylabel('q_5'); hold on;
subplot(3,2,6); plot(T_EMB, Q_EMB(6,:), color, 'LineWidth', LW); ylabel('q_6'); hold on;

the_legend{1} = 'EMB';

% -------------------------------------------------------------------------------------------------
% -------------------------------------------------------------------------------------------------
% Dynamique des 3 corps : initialisation
%
muSun       = UC.mu0SunLD/(UC.mu0EarthLD+UC.mu0MoonLD);
muCR3BP     = UC.mu0MoonLD/(UC.mu0EarthLD+UC.mu0MoonLD);
rhoS        = UC.AU/UC.LD;
omegaS      = (-(UC.speedMoon+UC.NoeudMoonDot)+2*pi/UC.Period_EMB)/UC.jour*UC.time_syst;
dt_CR3BP    = dt*UC.jour/UC.time_syst;
%t0_CR3BP    = t0*UC.jour/UC.time_syst;
%T_CR3BP     = linspace(t0_CR3BP,t0_CR3BP+dt_CR3BP,Nstep);
T_CR3BP     = linspace(0.0, dt_CR3BP, Nstep);
% q0_CR3BP = [1.155681950839609; zeros(5,1)]; % Lagrange L2
% q0_CR3BP = [1.119353017735519 0 0.011933614199998 0 0.179037935127886 0]'; % Halo-L2

% -------------------------------------------------------------------------------------------------
% Dynamique des 3 corps perturbe a Thomas
%
odefun          = @(t,x) rhs_CR3BP(t, x, muCR3BP, muSun, rhoS, thetaS0, omegaS, 2);
[~, Q_CR3BP]    = ode45(odefun, T_CR3BP, q0_CR3BP, OptionsOde);
Q_CR3BP         = Q_CR3BP';

% on affiche la trajectoire
%
% Change of coordinates from CR3BP to EMB for comparison
Q_CR3BP_in_EMB = Q_CR3BP;
T_CR3BP_in_EMB = T_CR3BP*UC.time_syst/UC.jour;
T_CR3BP_in_EMB = t0 + T_CR3BP_in_EMB;
for i = 1:length(T_CR3BP),
    Q_CR3BP_in_EMB(:,i) = CR3BP2EMB(Q_CR3BP(:,i), T_CR3BP_in_EMB(i));
end

Q_CR3BP_in_EMB_2 = Q_CR3BP_in_EMB(:,end)

color   = 'b--';
LW      = 1.5;
if(doPlot3B_Pert_Thomas)
subplot(3,2,1); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(1,:), color, 'LineWidth', LW); ylabel('q_1');
subplot(3,2,3); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(2,:), color, 'LineWidth', LW); ylabel('q_2');
subplot(3,2,5); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(3,:), color, 'LineWidth', LW); ylabel('q_3');
subplot(3,2,2); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(4,:), color, 'LineWidth', LW); ylabel('q_4');
subplot(3,2,4); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(5,:), color, 'LineWidth', LW); ylabel('q_5');
subplot(3,2,6); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(6,:), color, 'LineWidth', LW); ylabel('q_6');
the_legend{end+1} = 'CR3BP\_Pert\_Thomas';
end;

% -------------------------------------------------------------------------------------------------
% Dynamique des 3 corps non perturbe
%
odefun      = @(t,x) rhs_CR3BP(t, x, muCR3BP, muSun, rhoS, thetaS0, omegaS, 1);
[~, Q_CR3BP]= ode45(odefun, T_CR3BP, q0_CR3BP, OptionsOde);
Q_CR3BP     = Q_CR3BP';

% on affiche la trajectoire
%
% Change of coordinates from CR3BP to EMB for comparison
Q_CR3BP_in_EMB = Q_CR3BP;
T_CR3BP_in_EMB = T_CR3BP*UC.time_syst/UC.jour;
T_CR3BP_in_EMB = t0 + T_CR3BP_in_EMB;
for i = 1:length(T_CR3BP),
    Q_CR3BP_in_EMB(:,i) = CR3BP2EMB(Q_CR3BP(:,i), T_CR3BP_in_EMB(i));
end

Q_CR3BP_in_EMB_1 = Q_CR3BP_in_EMB(:,end)

color   = 'r';
LW      = 1.5;
if(doPlot3B)
subplot(3,2,1); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(1,:), color, 'LineWidth', LW); ylabel('q_1');
subplot(3,2,3); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(2,:), color, 'LineWidth', LW); ylabel('q_2');
subplot(3,2,5); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(3,:), color, 'LineWidth', LW); ylabel('q_3');
subplot(3,2,2); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(4,:), color, 'LineWidth', LW); ylabel('q_4');
subplot(3,2,4); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(5,:), color, 'LineWidth', LW); ylabel('q_5');
subplot(3,2,6); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(6,:), color, 'LineWidth', LW); ylabel('q_6');
the_legend{end+1} = 'CR3BP\_No\_Pert';
end;

% -------------------------------------------------------------------------------------------------
% Dynamique des 3 corps perturbe
%
odefun          = @(t,x) rhs_CR3BP(t, x, muCR3BP, muSun, rhoS, thetaS0, omegaS, 3);
[~, Q_CR3BP]    = ode45(odefun, T_CR3BP, q0_CR3BP, OptionsOde);
Q_CR3BP         = Q_CR3BP';

% on affiche la trajectoire
%
% Change of coordinates from CR3BP to EMB for comparison
Q_CR3BP_in_EMB = Q_CR3BP;
T_CR3BP_in_EMB = T_CR3BP*UC.time_syst/UC.jour;
T_CR3BP_in_EMB = t0 + T_CR3BP_in_EMB;
for i = 1:length(T_CR3BP),
    Q_CR3BP_in_EMB(:,i) = CR3BP2EMB(Q_CR3BP(:,i), T_CR3BP_in_EMB(i));
end

Q_CR3BP_in_EMB_3 = Q_CR3BP_in_EMB(:,end)

color   = 'r--';
LW      = 1.5;
if(doPlot3B_Pert)
subplot(3,2,1); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(1,:), color, 'LineWidth', LW); ylabel('q_1');
subplot(3,2,3); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(2,:), color, 'LineWidth', LW); ylabel('q_2');
subplot(3,2,5); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(3,:), color, 'LineWidth', LW); ylabel('q_3');
subplot(3,2,2); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(4,:), color, 'LineWidth', LW); ylabel('q_4');
subplot(3,2,4); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(5,:), color, 'LineWidth', LW); ylabel('q_5');
subplot(3,2,6); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(6,:), color, 'LineWidth', LW); ylabel('q_6');
the_legend{end+1} = 'CR3BP\_Pert';
end;

subplot(3,2,1); legend(the_legend{:}, 'Location', 'NorthWest');
subplot(3,2,3);
subplot(3,2,5);
subplot(3,2,2);
subplot(3,2,4);
subplot(3,2,6);

return

% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------
function qdot = rhs_CR3BP(t,q,mu,muSun,rhoS,thetaS0,omegaS,choix)

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

    if(choix==1) % eq 3 corps pas perturbé

        qdot(4) =  2*q5 + q1 - (1-mu)*(q1+mu)/r1^3 - mu*(q1-1+mu)/r2^3;
        qdot(5) = -2*q4 + q2 - (1-mu)*q2/r1^3 - mu*q2/r2^3;
        qdot(6) = -(1-mu)*q3/r1^3 - mu*q3/r2^3;

    elseif(choix==3) % eq 3 : 3 corps perturbé

        qdot(4) =  2*q5 + q1 - (1-mu)*(q1+mu)/r1^3  - mu*(q1-1+mu)/r2^3 - cSun*(q1-rhoS*cos(thetaS))*muSun/rS^3 - cSun*muSun*cos(thetaS)/rhoS^2;
        qdot(5) = -2*q4 + q2 - (1-mu)*q2/r1^3       - mu*q2/r2^3        - cSun*(q2-rhoS*sin(thetaS))*muSun/rS^3 - cSun*muSun*sin(thetaS)/rhoS^2;
        qdot(6) =            - (1-mu)*q3/r1^3       - mu*q3/r2^3        - cSun*q3*muSun/rS^3;

    elseif(choix==2) % eq 2 : 3 corps perturbé et modifié par Thomas

        qdot(4) =  2*q5 + q1 - (1-mu)*(q1+mu)/r1^3  - mu*(q1-1+mu)/r2^3 - cSun*(q1-rhoS*cos(thetaS))*muSun/rS^3;
        qdot(5) = -2*q4 + q2 - (1-mu)*q2/r1^3       - mu*q2/r2^3        - cSun*(q2-rhoS*sin(thetaS))*muSun/rS^3;
        qdot(6) =            - (1-mu)*q3/r1^3       - mu*q3/r2^3        - cSun*q3*muSun/rS^3;

    end;

return

% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------
function qLdot = rhs_SEM_EMB(t, qL, mu0_Sun, mu0_Earth, mu0_Moon, xG_EMB)
    % Be careful, the dynamics is not autonomous!!

    %
    r           = qL(1:3);
    v           = qL(4:6);
    L_EMB       = qL(7);
    Ldot        = rhsLGauss(t,L_EMB,xG_EMB,mu0_Sun);
    qSun        = -Gauss2Cart(mu0_Sun, [xG_EMB(1:5); L_EMB]); % Dans le repere inertiel centre EMB

    % Moon and Earth position
    [qM,qE]     = get_Moon_Earth_State_Cart(t); % Dans ref centre EMB

    rSun        = sqrt((r(1)-qSun(1))^2 + (r(2)-qSun(2))^2 + (r(3)-qSun(3))^2);
    rE          = sqrt((r(1)-qE(1))^2 + (r(2)-qE(2))^2 + (r(3)-qE(3))^2);
    rM          = sqrt((r(1)-qM(1))^2 + (r(2)-qM(2))^2 + (r(3)-qM(3))^2);

    % Dynamics
    qLdot       = zeros(7,1);
    qLdot(1:3)  = v;
    qLdot(4:6)  = -mu0_Sun*(r-qSun(1:3))/rSun^3 - mu0_Earth*(r-qE(1:3))/rE^3 - mu0_Moon*(r-qM(1:3))/rM^3;
    qLdot(7)    = Ldot;

return

