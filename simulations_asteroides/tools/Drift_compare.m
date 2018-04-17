function Drift_compare(t0, dt, q0_SUN_AU, hFigSpace)

format long;

% On compare les dynamiques 3 corps perturbes 3BP avec 3 corps 3B et 4B
% Attention :
%   les dynamiques 3BP et 3B sont dans le repere tournant centre EMB
%   le 4B est dans le repere inertiel centre EMB
%   q0 est dans le repere inertiel centre soleil
%

%
doPlot3B                = false;
doPlot3B_Pert           = true;
doPlot3B_Pert_Thomas    = false;
doPlot4B                = false;

% ----------------------------------------------------------------------------------------------------
DC          = get_Display_Constants(); % Display constants
UC          = get_Univers_Constants(); % Univers constants


Isp     = 375/UC.time_syst; fprintf('Isp = %f \n', Isp);
g0      = 9.80665*1e-3*(UC.time_syst)^2/UC.LD; fprintf('g0 = %f \n', g0);
Tmax    = 50*1e-3*(UC.time_syst)^2/UC.LD; fprintf('Tmax = %f \n', Tmax);

%

% On transforme q0 dans les 2 referentiels
[q0_CR3BP,~,~,~,thetaS0]    = Helio2CR3BP(q0_SUN_AU, t0);       % q en LD/d
% q0_EMB_LD_old               = CR3BP2EMB(q0_CR3BP,t0);

fprintf('q0_CR3BP = \n'); disp(q0_CR3BP);

% On definit les parametres d'integration
Nstep       = 100;
Times       = linspace(t0,t0+dt,Nstep);
OptionsOde  = odeset('AbsTol',1.e-12,'RelTol',1.e-12);

% La figure pour l'affichage des trajectoires a comparer
hFigTraj = figure;
the_legend  = {};

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

% -------------------------------------------------------------------------------------------------
% On integre avec la dynamique 4 corps (dans le ref inertiel centre Soleil en LD)
qL0_SUN_LD      = [q0_SUN_AU*UC.AU/UC.LD; L_EMB0_LD];
[~, Q_SUN_LD]   = ode45(@(t,x) rhs_4B_Sun_LD(t, x), Times, qL0_SUN_LD, OptionsOde); Q_SUN_LD = Q_SUN_LD';

% On revient dans le repere centre EMB
L_EMB = Q_SUN_LD(7,:);
for i = 1:Nstep
    qS              = -Gauss2Cart(UC.mu0SunLD, [xG_EMB0_LD(1:5); L_EMB(i)]); % Dans le repere inertiel centre EMB
    Q_SUN_LD(1:6,i) = Q_SUN_LD(1:6,i) + qS(1:6);
end

% q0_SUN_LD_aux = Q_SUN_LD(1:6,1);

if (doPlot4B)
    color   = 'r';
    LW      = 1.5;
    subplot(3,2,1); plot(Times, Q_SUN_LD(1,:), color, 'LineWidth', LW); ylabel('q_1'); hold on;
    subplot(3,2,3); plot(Times, Q_SUN_LD(2,:), color, 'LineWidth', LW); ylabel('q_2'); hold on;
    subplot(3,2,5); plot(Times, Q_SUN_LD(3,:), color, 'LineWidth', LW); ylabel('q_3'); hold on;
    subplot(3,2,2); plot(Times, Q_SUN_LD(4,:), color, 'LineWidth', LW); ylabel('q_4'); hold on;
    subplot(3,2,4); plot(Times, Q_SUN_LD(5,:), color, 'LineWidth', LW); ylabel('q_5'); hold on;
    subplot(3,2,6); plot(Times, Q_SUN_LD(6,:), color, 'LineWidth', LW); ylabel('q_6'); hold on;
    the_legend{1} = 'SUN\_LD';
end

% -------------------------------------------------------------------------------------------------
% On integre avec la dynamique 4 corps (dans le ref inertiel centre Soleil en AU)
qL0_SUN_AU      = [q0_SUN_AU; L_EMB0_AU];
[~, Q_SUN_AU]   = ode45(@(t,x) rhs_4B_Sun_AU(t, x), Times, qL0_SUN_AU, OptionsOde); Q_SUN_AU = Q_SUN_AU';

% On revient dans le repere centre EMB et en LD
L_EMB       = Q_SUN_AU(7,:);
Q_SUN_LD    = zeros(6,Nstep);
for i = 1:Nstep
    qS              = -Gauss2Cart(UC.mu0SunAU, [xG_EMB0_AU(1:5); L_EMB(i)]); % Dans le repere inertiel centre EMB
    Q_SUN_LD(:,i)   = Q_SUN_AU(1:6,i) + qS(1:6);
    Q_SUN_LD(:,i)   = Q_SUN_LD(:,i)*UC.AU/UC.LD;
end

% q0_SUN_AU_aux = Q_SUN_LD(1:6,1);

if (doPlot4B)
    color   = 'k--';
    LW      = 1.5;
    subplot(3,2,1); plot(Times, Q_SUN_LD(1,:), color, 'LineWidth', LW); ylabel('q_1'); hold on;
    subplot(3,2,3); plot(Times, Q_SUN_LD(2,:), color, 'LineWidth', LW); ylabel('q_2'); hold on;
    subplot(3,2,5); plot(Times, Q_SUN_LD(3,:), color, 'LineWidth', LW); ylabel('q_3'); hold on;
    subplot(3,2,2); plot(Times, Q_SUN_LD(4,:), color, 'LineWidth', LW); ylabel('q_4'); hold on;
    subplot(3,2,4); plot(Times, Q_SUN_LD(5,:), color, 'LineWidth', LW); ylabel('q_5'); hold on;
    subplot(3,2,6); plot(Times, Q_SUN_LD(6,:), color, 'LineWidth', LW); ylabel('q_6'); hold on;
    the_legend{end+1} = 'SUN\_AU';
end

% -------------------------------------------------------------------------------------------------
% On integre avec la dynamique 4 corps (dans le ref inertiel centre en EMB en LD)
%xOrb_epoch_t0_EMB   = get_EMB_init_Orbital_elements();
%xC_EMB              = get_Current_State_Cart(xOrb_epoch_t0_EMB, t0);
%xG_EMB              = Cart2Gauss(UC.mu0SunAU, xC_EMB);
%xG_EMB(1)           = xG_EMB(1)*UC.AU/UC.LD;
qL0_EMB_LD      = [q0_EMB_LD; L_EMB0_LD];
[~, Q_EMB_LD]   = ode45(@(t,x) rhs_4B_EMB_LD(t, x), Times, qL0_EMB_LD, OptionsOde); Q_EMB_LD = Q_EMB_LD';

% q0_EMB_LD_aux = Q_EMB_LD(1:6,1);

if doPlot4B
    color   = 'b';
    LW      = 1.5;
    subplot(3,2,1); plot(Times, Q_EMB_LD(1,:), color, 'LineWidth', LW); ylabel('q_1'); hold on;
    subplot(3,2,3); plot(Times, Q_EMB_LD(2,:), color, 'LineWidth', LW); ylabel('q_2'); hold on;
    subplot(3,2,5); plot(Times, Q_EMB_LD(3,:), color, 'LineWidth', LW); ylabel('q_3'); hold on;
    subplot(3,2,2); plot(Times, Q_EMB_LD(4,:), color, 'LineWidth', LW); ylabel('q_4'); hold on;
    subplot(3,2,4); plot(Times, Q_EMB_LD(5,:), color, 'LineWidth', LW); ylabel('q_5'); hold on;
    subplot(3,2,6); plot(Times, Q_EMB_LD(6,:), color, 'LineWidth', LW); ylabel('q_6'); hold on;
    the_legend{end+1} = 'EMB\_LD';
end



% Dans le repere centre soleil et en AU
L_EMB       = Q_EMB_LD(7,:);
Q_EMB_SUN   = zeros(3, Nstep);
for i = 1:Nstep
    qS              = -Gauss2Cart(UC.mu0SunLD, [xG_EMB0_LD(1:5); L_EMB(i)]); % Dans le repere inertiel centre EMB
    Q_EMB_SUN(:,i)  = Q_EMB_LD(1:3,i) - qS(1:3);
    Q_EMB_SUN(:,i)  = Q_EMB_SUN(:,i)*UC.LD/UC.AU;
end
figure(hFigSpace.figure);
subplot(hFigSpace.subplot{:});
plot3(Q_EMB_SUN(1,:), Q_EMB_SUN(2,:), Q_EMB_SUN(3,:), 'Color', DC.bleu, 'LineWidth', DC.LW); hold on;
figure(hFigTraj);

% -------------------------------------------------------------------------------------------------
% On integre avec la dynamique 4 corps (dans le ref inertiel centre en EMB en AU)
qL0_EMB_AU      = [q0_EMB_LD*UC.LD/UC.AU; L_EMB0_AU];
[~, Q_EMB_AU]   = ode45(@(t,x) rhs_4B_EMB_AU(t, x), Times, qL0_EMB_AU, OptionsOde); Q_EMB_AU = Q_EMB_AU';

% On revient en LD
Q_EMB_LD        = [];
Q_EMB_LD(1:6,:) = Q_EMB_AU(1:6,:)*UC.AU/UC.LD;

% q0_EMB_AU_aux = Q_EMB_LD(1:6,1);

if doPlot4B
    color   = 'g--';
    LW      = 1.5;
    subplot(3,2,1); plot(Times, Q_EMB_LD(1,:), color, 'LineWidth', LW); ylabel('q_1'); hold on;
    subplot(3,2,3); plot(Times, Q_EMB_LD(2,:), color, 'LineWidth', LW); ylabel('q_2'); hold on;
    subplot(3,2,5); plot(Times, Q_EMB_LD(3,:), color, 'LineWidth', LW); ylabel('q_3'); hold on;
    subplot(3,2,2); plot(Times, Q_EMB_LD(4,:), color, 'LineWidth', LW); ylabel('q_4'); hold on;
    subplot(3,2,4); plot(Times, Q_EMB_LD(5,:), color, 'LineWidth', LW); ylabel('q_5'); hold on;
    subplot(3,2,6); plot(Times, Q_EMB_LD(6,:), color, 'LineWidth', LW); ylabel('q_6'); hold on;
    the_legend{end+1} = 'EMB\_AU';
end

% diff_SUN_EMB_LD = q0_SUN_LD_aux - q0_EMB_LD_aux;
% diff_SUN_EMB_AU = q0_SUN_AU_aux - q0_EMB_AU_aux;
% diff_EMB_LD_AU  = q0_EMB_LD_aux - q0_EMB_AU_aux;
% diff_SUN_LD_AU  = q0_SUN_LD_aux - q0_SUN_AU_aux;


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

fprintf('muCR3BP = %f \n', muCR3BP);
fprintf('muSun = %f \n', muSun);
fprintf('rhoS = %f \n', rhoS);
fprintf('thetaS0 = %f \n', thetaS0);
fprintf('omegaS = %f \n', omegaS);

tf_guess = dt_CR3BP; fprintf('tf_guess = %f \n', tf_guess);

odefun          = @(t,x) rhs_CR3BP(t, x, muCR3BP, muSun, rhoS, thetaS0, omegaS, 2);
[~, Q_CR3BP]    = ode45(odefun, T_CR3BP, q0_CR3BP, OptionsOde);
Q_CR3BP         = Q_CR3BP';

% on affiche la trajectoire
%
% Change of coordinates from CR3BP to EMB for comparison
Q_CR3BP_in_EMB = Q_CR3BP;
T_CR3BP_in_EMB = T_CR3BP*UC.time_syst/UC.jour;
T_CR3BP_in_EMB = t0 + T_CR3BP_in_EMB;
for i = 1:length(T_CR3BP)
    Q_CR3BP_in_EMB(:,i) = CR3BP2EMB(Q_CR3BP(:,i), T_CR3BP_in_EMB(i));
end

% Q_CR3BP_in_EMB_2 = Q_CR3BP_in_EMB(:,end);


if (doPlot3B_Pert_Thomas)
    color = 'y';
    LW      = 1.5;
    subplot(3,2,1); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(1,:), color, 'LineWidth', LW); ylabel('q_1');
    subplot(3,2,3); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(2,:), color, 'LineWidth', LW); ylabel('q_2');
    subplot(3,2,5); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(3,:), color, 'LineWidth', LW); ylabel('q_3');
    subplot(3,2,2); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(4,:), color, 'LineWidth', LW); ylabel('q_4');
    subplot(3,2,4); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(5,:), color, 'LineWidth', LW); ylabel('q_5');
    subplot(3,2,6); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(6,:), color, 'LineWidth', LW); ylabel('q_6');
    the_legend{end+1} = 'CR3BP\_Pert\_Thomas';
end

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
for i = 1:length(T_CR3BP)
    Q_CR3BP_in_EMB(:,i) = CR3BP2EMB(Q_CR3BP(:,i), T_CR3BP_in_EMB(i));
end

% Q_CR3BP_in_EMB_1 = Q_CR3BP_in_EMB(:,end);


if (doPlot3B)
    color   = 'g';
    LW      = 1.5;
    subplot(3,2,1); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(1,:), color, 'LineWidth', LW); ylabel('q_1');
    subplot(3,2,3); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(2,:), color, 'LineWidth', LW); ylabel('q_2');
    subplot(3,2,5); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(3,:), color, 'LineWidth', LW); ylabel('q_3');
    subplot(3,2,2); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(4,:), color, 'LineWidth', LW); ylabel('q_4');
    subplot(3,2,4); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(5,:), color, 'LineWidth', LW); ylabel('q_5');
    subplot(3,2,6); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(6,:), color, 'LineWidth', LW); ylabel('q_6');
    the_legend{end+1} = 'CR3BP\_No\_Pert';
end

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
for i = 1:length(T_CR3BP)
    Q_CR3BP_in_EMB(:,i) = CR3BP2EMB(Q_CR3BP(:,i), T_CR3BP_in_EMB(i));
end

% Q_CR3BP_in_EMB_3 = Q_CR3BP_in_EMB(:,end);


if(doPlot3B_Pert)
    color   = 'm--';
    LW      = 1.5;
    subplot(3,2,1); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(1,:), color, 'LineWidth', LW); ylabel('q_1');
    subplot(3,2,3); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(2,:), color, 'LineWidth', LW); ylabel('q_2');
    subplot(3,2,5); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(3,:), color, 'LineWidth', LW); ylabel('q_3');
    subplot(3,2,2); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(4,:), color, 'LineWidth', LW); ylabel('q_4');
    subplot(3,2,4); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(5,:), color, 'LineWidth', LW); ylabel('q_5');
    subplot(3,2,6); plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB(6,:), color, 'LineWidth', LW); ylabel('q_6');
    the_legend{end+1} = 'CR3BP\_Pert';
end

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

    end

return

% ----------------------------------------------------------------------------------------------------
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

% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------
function qLdot = rhs_4B_EMB_AU(t, qL)
    % dans ref inertiel centre EMB
    % Be careful, the dynamics is not autonomous!!

    UC          = get_Univers_Constants(); % Univers constants

    mu0_Sun     = UC.mu0SunAU;
    mu0_Earth   = UC.mu0EarthAU;
    mu0_Moon    = UC.mu0MoonAU;

    xG_EMB0_AU  = UC.xG_EMB0;
    xG_EMB      = xG_EMB0_AU;

    %
    r           = qL(1:3);
    v           = qL(4:6);
    L_EMB       = qL(7);
    Ldot        = rhsLGauss(t,L_EMB,xG_EMB,mu0_Sun);
    qS          = -Gauss2Cart(mu0_Sun, [xG_EMB(1:5); L_EMB]); % Dans le repere inertiel centre EMB

    % Moon and Earth position
    [qM,qE, ~]     = get_Moon_Earth_L2_State_Cart_LD(t); % Dans ref centre EMB en AU
    qM          = qM*UC.LD/UC.AU;
    qE          = qE*UC.LD/UC.AU;

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

% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------
function qLdot = rhs_4B_Sun_LD(t, qL)
    % dans ref inertiel centre soleil
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
    qS          = -Gauss2Cart(mu0_Sun, [xG_EMB(1:5); L_EMB]); % Dans le repere inertiel centre EMB

    % Moon and Earth position
    [qM, qE, ~]     = get_Moon_Earth_L2_State_Cart_LD(t);  % Dans ref centre EMB en AU
%    qM          = qM*UC.AU/UC.LD;
%    qE          = qE*UC.AU/UC.LD;

    % Replace the position in the frame centered in the Sun
    qS(1:3)     = qS(1:3) - qS(1:3);
    qM(1:3)     = qM(1:3) - qS(1:3);
    qE(1:3)     = qE(1:3) - qS(1:3);
%     qL2(1:3)    = qL2(1:3) - qS(1:3);

    rSun        = sqrt((r(1)-qS(1))^2 + (r(2)-qS(2))^2 + (r(3)-qS(3))^2);
    rE          = sqrt((r(1)-qE(1))^2 + (r(2)-qE(2))^2 + (r(3)-qE(3))^2);
    rM          = sqrt((r(1)-qM(1))^2 + (r(2)-qM(2))^2 + (r(3)-qM(3))^2);
%     rL2         = sqrt((r(1)-qL2(1))^2 + (r(2)-qL2(2))^2 + (r(3)-qL2(3))^2);

    % Dynamics
    qLdot       = zeros(7,1);
    qLdot(1:3)  = v;
    qLdot(4:6)  = - mu0_Sun*(r-qS(1:3))/rSun^3 - mu0_Earth*(r-qE(1:3))/rE^3 - mu0_Moon*(r-qM(1:3))/rM^3; % ...
                  % + mu0_Earth*(qS(1:3)-qE(1:3))/norm(qS(1:3)-qE(1:3))^3 + mu0_Moon*(qS(1:3)-qM(1:3))/norm(qS(1:3)-qM(1:3))^3 ;
    qLdot(7)    = Ldot;

return

% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------
function qLdot = rhs_4B_Sun_AU(t, qL)
    % dans ref inertiel centre soleil
    % Be careful, the dynamics is not autonomous!!

    UC          = get_Univers_Constants(); % Univers constants

    mu0_Sun     = UC.mu0SunAU;
    mu0_Earth   = UC.mu0EarthAU;
    mu0_Moon    = UC.mu0MoonAU;

    xG_EMB0_AU  = UC.xG_EMB0;
    xG_EMB      = xG_EMB0_AU;

    %
    r           = qL(1:3);
    v           = qL(4:6);
    L_EMB       = qL(7);
    Ldot        = rhsLGauss(t,L_EMB,xG_EMB,mu0_Sun);
    qS          = -Gauss2Cart(mu0_Sun, [xG_EMB(1:5); L_EMB]); % Dans le repere inertiel centre EMB

    % Moon and Earth position
    [qM, qE, ~]     = get_Moon_Earth_L2_State_Cart_LD(t);  % Dans ref centre EMB
    qM          = qM*UC.LD/UC.AU;
    qE          = qE*UC.LD/UC.AU;
%     qL2         = qL2*UC.LD/UC.AU;

    % Replace the position in the frame centered in the Sun
    qS(1:3)     = qS(1:3) - qS(1:3);
    qM(1:3)     = qM(1:3) - qS(1:3);
    qE(1:3)     = qE(1:3) - qS(1:3);
%     qL2(1:3)    = qL2(1:3) - qS(1:3);

    rSun        = sqrt((r(1)-qS(1))^2 + (r(2)-qS(2))^2 + (r(3)-qS(3))^2);
    rE          = sqrt((r(1)-qE(1))^2 + (r(2)-qE(2))^2 + (r(3)-qE(3))^2);
    rM          = sqrt((r(1)-qM(1))^2 + (r(2)-qM(2))^2 + (r(3)-qM(3))^2);

    % Dynamics
    qLdot       = zeros(7,1);
    qLdot(1:3)  = v;
    qLdot(4:6)  = - mu0_Sun*(r-qS(1:3))/rSun^3 - mu0_Earth*(r-qE(1:3))/rE^3 - mu0_Moon*(r-qM(1:3))/rM^3; % ...
                   % + mu0_Earth*(qS(1:3)-qE(1:3))/norm(qS(1:3)-qE(1:3))^3 + mu0_Moon*(qS(1:3)-qM(1:3))/norm(qS(1:3)-qM(1:3))^3 ;
    qLdot(7)    = Ldot;

return
