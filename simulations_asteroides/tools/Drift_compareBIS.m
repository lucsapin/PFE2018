function [T_CR3BP_in_EMB, Q_EMB_SUN, Q_CR3BP_in_EMB] = Drift_compareBIS(t0, dt, q0_SUN_AU)

format long;

% On compare les dynamiques 3 corps perturbes 3BP avec 3 corps 3B et 4B
% Attention :
%   les dynamiques 3BP et 3B sont dans le repere tournant centre EMB
%   le 4B est dans le repere inertiel centre EMB
%   q0 est dans le repere inertiel centre soleil
%

% ----------------------------------------------------------------------------------------------------
DC          = get_Display_Constants(); % Display constants
UC          = get_Univers_Constants(); % Univers constants


Isp     = 375/UC.time_syst;
g0      = 9.80665*1e-3*(UC.time_syst)^2/UC.LD;
Tmax    = 50*1e-3*(UC.time_syst)^2/UC.LD;

%

% On transforme q0 dans les 2 referentiels
[q0_CR3BP,~,~,~,thetaS0]    = Helio2CR3BP(q0_SUN_AU, t0);       % q en LD/d
% q0_EMB_LD_old               = CR3BP2EMB(q0_CR3BP,t0);

fprintf('q0_CR3BP = \n'); disp(q0_CR3BP);

% On definit les parametres d'integration
Nstep       = 100;
Times       = linspace(t0,t0+dt,Nstep);
OptionsOde  = odeset('AbsTol',1.e-12,'RelTol',1.e-12);



% Quelques parametres
xG_EMB0_AU  = UC.xG_EMB0;
xG_EMB0_LD  = xG_EMB0_AU; xG_EMB0_LD(1)  = xG_EMB0_LD(1)*UC.AU/UC.LD;
L_EMB0_LD   = drift_L(t0, xG_EMB0_LD, UC.mu0SunLD);
L_EMB0_AU   = drift_L(t0, xG_EMB0_AU, UC.mu0SunAU);

% q0_EMB_LD
qS              = -Gauss2Cart(UC.mu0SunAU, [xG_EMB0_AU(1:5); L_EMB0_AU]); % Dans le repere inertiel centre EMB
q0_EMB_AU       = q0_SUN_AU + qS(1:6);
q0_EMB_LD       = q0_EMB_AU*UC.AU/UC.LD;

% diff_q0         = q0_EMB_LD_old - q0_EMB_LD;


% Dans le repere centre soleil et en AU
qL0_EMB_LD      = [q0_EMB_LD; L_EMB0_LD];
[~, Q_EMB_LD]   = ode45(@(t,x) rhs_4B_EMB_LD(t, x), Times, qL0_EMB_LD, OptionsOde); Q_EMB_LD = Q_EMB_LD';
L_EMB       = Q_EMB_LD(7,:);
Q_EMB_SUN   = zeros(3, Nstep);
for i = 1:Nstep
    qS              = -Gauss2Cart(UC.mu0SunLD, [xG_EMB0_LD(1:5); L_EMB(i)]); % Dans le repere inertiel centre EMB
    Q_EMB_SUN(:,i)  = Q_EMB_LD(1:3,i) - qS(1:3);
    Q_EMB_SUN(:,i)  = Q_EMB_SUN(:,i)*UC.LD/UC.AU;
end



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
% Dynamique des 3 corps perturbe
%
odefun          = @(t,x) rhs_CR3BP(t, x, muCR3BP, muSun, rhoS, thetaS0, omegaS, 3);
[~, Q_CR3BP]    = ode45(odefun, T_CR3BP, q0_CR3BP, OptionsOde);
Q_CR3BP         = Q_CR3BP';

%
% Change of coordinates from CR3BP to EMB for comparison
Q_CR3BP_in_EMB = Q_CR3BP;
T_CR3BP_in_EMB = T_CR3BP*UC.time_syst/UC.jour;
T_CR3BP_in_EMB = t0 + T_CR3BP_in_EMB;
for i = 1:length(T_CR3BP)
    Q_CR3BP_in_EMB(:,i) = CR3BP2EMB(Q_CR3BP(:,i), T_CR3BP_in_EMB(i));
end

% Q_CR3BP_in_EMB_3 = Q_CR3BP_in_EMB(:,end);

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

    end

return


% ----------------------------------------------------------------------------------------------------
function qLdot = rhs_4B_EMB_LD(t, qL)
    % dans ref inertiel centre EMB
    % Be careful, the dynamics is not autonomous!!

    UC          = get_Univers_Constants(); % Univers constants

    mu0_Sun     = UC.mu0SunLD;
    mu0_Earth   = UC.mu0EarthLD;
    mu0_Moon    = UC.mu0MoonLD;

    xG_EMB0_AU  = UC.xG_EMB0;
    xG_EMB0_LD  = xG_EMB0_AU; xG_EMB0_LD(1)  = xG_EMB0_LD(1)*UC.AU/UC.LD;
    xG_EMB      = xG_EMB0_LD;

    %
    r           = qL(1:3);
    v           = qL(4:6);
    L_EMB       = qL(7);
    Ldot        = rhsLGauss(t,L_EMB,xG_EMB,mu0_Sun);
    qS          = -Gauss2Cart(mu0_Sun, [xG_EMB(1:5); L_EMB]); % Dans le repere inertiel centre EMB en LD

    % Moon and Earth position
    [qM,qE,~]     = get_Moon_Earth_L2_State_Cart_LD(t); % Dans ref centre EMB en AU
%    qM          = qM*UC.AU/UC.LD;
%    qE          = qE*UC.AU/UC.LD;

    rSun        = sqrt((r(1)-qS(1))^2 + (r(2)-qS(2))^2 + (r(3)-qS(3))^2);
    rE          = sqrt((r(1)-qE(1))^2 + (r(2)-qE(2))^2 + (r(3)-qE(3))^2);
    rM          = sqrt((r(1)-qM(1))^2 + (r(2)-qM(2))^2 + (r(3)-qM(3))^2);

    % Dynamics
    qLdot       = zeros(7,1);
    qLdot(1:3)  = v;
    qLdot(4:6)  =   - mu0_Sun*(r-qS(1:3))/rSun^3 - mu0_Earth*(r-qE(1:3))/rE^3 - mu0_Moon*(r-qM(1:3))/rM^3 ...
                    - (mu0_Sun/(mu0_Earth+mu0_Moon))* ...
                    (   ...
                            mu0_Earth*(qS(1:3)-qE(1:3))/norm(qS(1:3)-qE(1:3))^3 ...
                        +   mu0_Moon *(qS(1:3)-qM(1:3))/norm(qS(1:3)-qM(1:3))^3 ...
                    );
    qLdot(7)    = Ldot;

return
