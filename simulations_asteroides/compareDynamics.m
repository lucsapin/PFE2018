% Comparaison des simulations entre L2 et EMB
%
clear all;
close all;
% ----------------------------------------------------------------------------------------------------
% Display settings
set(0,  'defaultaxesfontsize'   ,  16     , ...
    'DefaultTextVerticalAlignment'  , 'bottom', ...
    'DefaultTextHorizontalAlignment', 'left'  , ...
    'DefaultTextFontSize'           ,  16     , ...
    'DefaultFigureWindowStyle','docked');

axisColor = 'k--';

format long;

% ----------------------------------------------------------------------------------------------------
% Directories with matlab auxiliary functions
%
addpath('tools/');
addpath('bocop/libBocop2/');
addpath('bocop/');
addpath('hampath/libhampath3Mex/');

% ----------------------------------------------------------------------------------------------------
DC          = get_Display_Constants(); % Display constants
UC          = get_Univers_Constants(); % Univers constants

Isp     = 375/UC.time_syst;
g0      = 9.80665*1e-3*(UC.time_syst)^2/UC.LD;
Tmax    = 50*1e-3*(UC.time_syst)^2/UC.LD;

doPlot3B_Pert           = true;

% ----------------------------------------------------------------------------------------------------
% Definition of all the parameters
numAsteroid         = 1;
TmaxN               = 50;       % Newton
dist                = 0.01;     % We propagate the trajectory to the distance dist (in AU) of EMB
numOpti             = 1;        % Numero of optimization for this asteroid
m0                  = 500; % kg


SansmaxL2 = false;
destination = 'L2';
typeSimu = 'total';

% ----------------------------------------------------------------------------------------------------
% Computation of trajectories for each destination

% disp('------------------------------------------------------------------------');

% choix = 3; dynamic11 = '3B Perturbated'; traj11 = [propagation1 '+' dynamic11];
% disp(['Propagate Compare : ' dynamic11]);
% [resDrift_3BP, pointMinDistL2_3BP4B] = computeCR3BP(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, SansmaxL2, choix, propagation1);
%
% fprintf('\n');
% choix = 6; dynamic12 = '2B Sun'; traj12 = [propagation1 '+' dynamic12];
% disp(['Propagate Compare : ' dynamic12]);
% [resDrift_2BS, pointMinDistL2_2BS4B] = computeCR3BP(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, SansmaxL2, choix, propagation1);
%
% fprintf('\n');
% choix = 7; dynamic13 = '2B Ad Hoc'; traj13 = [propagation1 '+' dynamic13];
% disp(['Propagate Compare : ' dynamic13]);
% [resDrift_2BAH, pointMinDistL2_2BAH4B] = computeCR3BP(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, SansmaxL2, choix, propagation1);
%
% disp('------------------------------------------------------------------------');

% ----------------------------------------------------------------------------------------------------
% Affectation des résultats
% T_CR3BP_4B       = resDrift_3BP.T_CR3BP; % vecteur de temps
%
% Q_CR3BP_4B       = resDrift_3BP.Q_CR3BP; % trajectory in rotating frame
% Q_CR3BP_2BS4B    = resDrift_2BS.Q_CR3BP; % trajectory in rotating frame
% Q_CR3BP_2BAH4B   = resDrift_2BAH.Q_CR3BP; % trajectory in rotating frame

% q0_SUN_AU3BP4B  = resDrift_3BP.q0_SUN_AU;
% q0_SUN_AU2BS4B  = resDrift_2BS.q0_SUN_AU;
% q0_SUN_AU2BAH4B  = resDrift_2BAH.q0_SUN_AU;

% ----------------------------------------------------------------------------------------------------
% Computation of trajectories for each destination
disp('------------------------------------------------------------------------');
propagation = '2B';

choix = 3; dynamic1 = '3B Perturbated'; traj1 = dynamic1;
disp(['Propagate Compare : ' dynamic1]);
[resDrift_3BP, pointMinDistL2_3BP2B] = get_CR3BP_traj(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, SansmaxL2, choix);

fprintf('\n');
choix = 4; dynamic2 = '2B Sun'; traj2 = dynamic2;
disp(['Propagate Compare : ' dynamic2]);
[resDrift_2BS, pointMinDistL2_2BS2B]  = get_CR3BP_traj(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, SansmaxL2, choix);

fprintf('\n');
choix = 6; dynamic3 = '2B Ad Hoc'; traj3 = dynamic3;
disp(['Propagate Compare : ' dynamic3]);
[resDrift_2BAH, pointMinDistL2_2BAH2B] = get_CR3BP_traj(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, SansmaxL2, choix);

disp('------------------------------------------------------------------------');

% ----------------------------------------------------------------------------------------------------
% Affectation des résultats
T_CR3BP_2B       = resDrift_3BP.T_CR3BP; % vecteur de temps

Q_CR3BP_2B       = resDrift_3BP.Q_CR3BP; % trajectory in rotating frame
Q_CR3BP_2BS2B    = resDrift_2BS.Q_CR3BP; % trajectory in rotating frame
Q_CR3BP_2BAH2B    = resDrift_2BAH.Q_CR3BP; % trajectory in rotating frame

norm(Q_CR3BP_2BAH2B(1:3, end))
muCR3BP = UC.mu0MoonLD/(UC.mu0EarthLD+UC.mu0MoonLD);
position_Terre = [-muCR3BP; 0.0; 0.0];
norm(position_Terre)

% ----------------------------------------------------------------------------------------------------
% Plot results
figure;
display_Moon(); hold on;
display_Earth(); hold on;
display_L2(); hold on;

% plot3(Q_CR3BP_4B(1,:), Q_CR3BP_4B(2,:), Q_CR3BP_4B(3,:), 'r', 'LineWidth', DC.LW); hold on;
% plot3(Q_CR3BP_2BS4B(1,:), Q_CR3BP_2BS4B(2,:), Q_CR3BP_2BS4B(3,:), 'm', 'LineWidth', DC.LW); hold on;
% plot3(Q_CR3BP_2BAH4B(1,:), Q_CR3BP_2BAH4B(2,:), Q_CR3BP_2BAH4B(3,:), 'b', 'LineWidth', DC.LW); hold on;

plot3(Q_CR3BP_2B(1,:), Q_CR3BP_2B(2,:), Q_CR3BP_2B(3,:), 'r--', 'LineWidth', DC.LW); hold on;
plot3(Q_CR3BP_2BS2B(1,:), Q_CR3BP_2BS2B(2,:), Q_CR3BP_2BS2B(3,:), 'm--', 'LineWidth', DC.LW); hold on;
plot3(Q_CR3BP_2BAH2B(1,:), Q_CR3BP_2BAH2B(2,:), Q_CR3BP_2BAH2B(3,:), 'b--', 'LineWidth', DC.LW); % hold on;


legend('Moon', 'Earth', 'L2', traj1, traj2, traj3);
title('Compare Dynamics : 2B before Hill then 3BP or 2B');
% xlim(dist*[-1 1]*UC.AU/UC.LD);
% ylim(dist*[-1 1]*UC.AU/UC.LD);
% zlim(dist*[-1 1]*UC.AU/UC.LD);
xlabel('q_1');
ylabel('q_2');
zlabel('q_3');
view(0,90);
