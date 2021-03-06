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

SansmaxEMB = false;
SansmaxL2 = false;

typeSimu = 'total';
propagation = '2B';
choixDyn = 3; dynamic = '3B Perturbated';
choixDyn = 6; dynamic = '2 Body Sun';

% ----------------------------------------------------------------------------------------------------
% Computation of trajectories for each destination
disp('------------------------------------------------------------------------');
destination = 'EMB';
disp(['Propagate Compare : ' dynamic]);
[resDrift_EMB, resFig_EMB, resB_EMB, resP2H_EMB, pointMinDistL2_EMB] = get_all_traj(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, SansmaxL2, choixDyn);

fprintf('\n');
destination = 'L2';
disp(['Propagate Compare : ' dynamic]);
[resDrift_L2,  resFig_L2,  resB_L2,  resP2H_L2,  pointMinDistL2_L2]  = get_all_traj(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, SansmaxL2, choixDyn);

disp('------------------------------------------------------------------------');

% ----------------------------------------------------------------------------------------------------
% Affectation des résultats
T_CR3BP       = resDrift_EMB.T_CR3BP; % vecteur de temps
%
states_EMB    = resP2H_EMB.states;
statesqL1_EMB = resP2H_EMB.states_q_L1;
statesqL2_EMB = resP2H_EMB.states_q_L2;
Q_EMB_SUN_EMB = resDrift_EMB.Q_EMB_SUN; % trajectory in Heliocentric frame
Q_CR3BP_EMB   = resDrift_EMB.Q_CR3BP; % trajectory in rotating frame
zB_EMB        = resB_EMB.zB; % trajectory in rotating frame
%
states_L2     = resP2H_L2.states;
statesqL1_L2  = resP2H_L2.states_q_L1;
statesqL2_L2  = resP2H_L2.states_q_L2;
Q_EMB_SUN_L2  = resDrift_L2.Q_EMB_SUN; % trajectory in Heliocentric frame
Q_CR3BP_L2    = resDrift_L2.Q_CR3BP; % trajectory in rotating frame
zB_L2         = resB_L2.zB; % trajectory in rotating frame

% ----------------------------------------------------------------------------------------------------
% Affectation figure & couleur & type trajectoires
%
color_EMB = resFig_EMB.color;
LW_EMB    = resFig_EMB.LW;
%
color_L2  = resFig_L2.color;
LW_L2     = resFig_L2.LW;

figure;
the_legend  = {};
subplot(3,2,1);
plot(T_CR3BP, Q_CR3BP_EMB(1,:), 'r', 'LineWidth', LW_EMB); hold on;
plot(T_CR3BP, Q_CR3BP_L2(1,:), color_L2, 'LineWidth', LW_L2); ylabel('q_1');

subplot(3,2,3);
plot(T_CR3BP, Q_CR3BP_EMB(2,:), 'r', 'LineWidth', LW_EMB); hold on;
plot(T_CR3BP, Q_CR3BP_L2(2,:), color_L2, 'LineWidth', LW_L2); ylabel('q_2');

subplot(3,2,5);
plot(T_CR3BP, Q_CR3BP_EMB(3,:), 'r', 'LineWidth', LW_EMB); hold on;
plot(T_CR3BP, Q_CR3BP_L2(3,:), color_L2, 'LineWidth', LW_L2); ylabel('q_3');

subplot(3,2,2);
plot(T_CR3BP, Q_CR3BP_EMB(4,:), 'r', 'LineWidth', LW_EMB); hold on;
plot(T_CR3BP, Q_CR3BP_L2(4,:), color_L2, 'LineWidth', LW_L2); ylabel('q_4');

subplot(3,2,4);
plot(T_CR3BP, Q_CR3BP_EMB(5,:), 'r', 'LineWidth', LW_EMB); hold on;
plot(T_CR3BP, Q_CR3BP_L2(5,:), color_L2, 'LineWidth', LW_L2); ylabel('q_5');

subplot(3,2,6);
plot(T_CR3BP, Q_CR3BP_EMB(6,:), 'r', 'LineWidth', LW_EMB); hold on;
plot(T_CR3BP, Q_CR3BP_L2(6,:), color_L2, 'LineWidth', LW_L2); ylabel('q_6');

the_legend{end+1} = 'CR3BP\_Pert\_EMB'; the_legend{end+1} = 'CR3BP\_Pert\_L2';

subplot(3,2,1); legend(the_legend{:}, 'Location', 'NorthWest');
subplot(3,2,3);
subplot(3,2,5);
subplot(3,2,2);
subplot(3,2,4);
subplot(3,2,6);

figure;
display_Moon(); hold on;
display_Earth(); hold on;
display_L2(); hold on;

plot3(zB_L2(1,:), zB_L2(2,:), zB_L2(3,:), '-'); hold on;
plot3(zB_EMB(1,:), zB_EMB(2,:), zB_EMB(3,:),'-'); hold on;

plot3(Q_CR3BP_EMB(1,:), Q_CR3BP_EMB(2,:), Q_CR3BP_EMB(3,:), color_EMB, 'LineWidth', LW_EMB); hold on;
plot3(Q_CR3BP_L2(1,:), Q_CR3BP_L2(2,:), Q_CR3BP_L2(3,:), color_L2, 'LineWidth', LW_L2); hold on;

plot3(pointMinDistL2_EMB(1), pointMinDistL2_EMB(2), pointMinDistL2_EMB(3), 'o'); hold on;
plot3(pointMinDistL2_L2(1), pointMinDistL2_L2(2), pointMinDistL2_L2(3), 'o');

xlabel('q_1');
ylabel('q_2');
zlabel('q_3');
view(0,90);
legend('Moon', 'Earth', 'L2', 'zB L2', 'zB EMB', 'EMB', 'L2', 'minPoint');
title(['Propagate2Hill : ' propagation ' ; Then : ' dynamic]);
