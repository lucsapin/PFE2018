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

disp('------------------------------------------------------------------------');
propagation = '4B'

choix = 3; dynamic = '3B Perturbated';
disp(['Propagate Compare : ' dynamic]);
[resDrift3BP, pointMinDistL23BP4B] = propagateDrift(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, SansmaxL2, choix, propagation);

fprintf('\n');
choix = 4; dynamic = '2B Earth';
disp(['Propagate Compare : ' dynamic]);
[resDrift2BE, pointMinDistL22BE4B] = propagateDrift(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, SansmaxL2, choix, propagation);

fprintf('\n');
choix = 5; dynamic = '2B Moon';
disp(['Propagate Compare : ' dynamic]);
[resDrift2BM, pointMinDistL22BM4B] = propagateDrift(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, SansmaxL2, choix, propagation);

disp('------------------------------------------------------------------------');

% ----------------------------------------------------------------------------------------------------
% Affectation des résultats
T_CR3BP4B       = resDrift3BP.T_CR3BP; % vecteur de temps
Q_CR3BP4B   = resDrift3BP.Q_CR3BP; % trajectory in rotating frame
Q_CR3BP2BE4B    = resDrift2BE.Q_CR3BP; % trajectory in rotating frame
Q_CR3BP2BM4B    = resDrift2BM.Q_CR3BP; % trajectory in rotating frame

disp('------------------------------------------------------------------------');
propagation = '2B'

choix = 3; dynamic = '3B Perturbated';
disp(['Propagate Compare : ' dynamic]);
[resDrift3BP, pointMinDistL23BP2B] = propagateDrift(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, SansmaxL2, choix, propagation);

fprintf('\n');
choix = 4; dynamic = '2B Earth';
disp(['Propagate Compare : ' dynamic]);
[resDrift2BE, pointMinDistL22BE2B]  = propagateDrift(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, SansmaxL2, choix, propagation);

fprintf('\n');
choix = 5; dynamic = '2B Moon';
disp(['Propagate Compare : ' dynamic]);
[resDrift2BM, pointMinDistL22BM2B]  = propagateDrift(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, SansmaxL2, choix, propagation);

disp('------------------------------------------------------------------------');

% ----------------------------------------------------------------------------------------------------
% Affectation des résultats
T_CR3BP2B       = resDrift3BP.T_CR3BP; % vecteur de temps
Q_CR3BP2B   = resDrift3BP.Q_CR3BP; % trajectory in rotating frame
Q_CR3BP2BE2B    = resDrift2BE.Q_CR3BP; % trajectory in rotating frame
Q_CR3BP2BM2B    = resDrift2BM.Q_CR3BP; % trajectory in rotating frame
% ----------------------------------------------------------------------------------------------------
% Plot results
figure;
display_Moon(); hold on;
display_Earth(); hold on;
display_L2(); hold on;

plot3(Q_CR3BP4B(1,:), Q_CR3BP4B(2,:), Q_CR3BP4B(3,:), 'r', 'LineWidth', DC.LW); hold on;
plot3(Q_CR3BP2BE4B(1,:), Q_CR3BP2BE4B(2,:), Q_CR3BP2BE4B(3,:), 'b', 'LineWidth', DC.LW); hold on;
plot3(Q_CR3BP2BM4B(1,:), Q_CR3BP2BM4B(2,:), Q_CR3BP2BM4B(3,:), 'm', 'LineWidth', DC.LW); hold on;

plot3(Q_CR3BP2B(1,:), Q_CR3BP2B(2,:), Q_CR3BP2B(3,:), 'r--', 'LineWidth', DC.LW); hold on;
plot3(Q_CR3BP2BE2B(1,:), Q_CR3BP2BE2B(2,:), Q_CR3BP2BE2B(3,:), 'b--', 'LineWidth', DC.LW); hold on;
plot3(Q_CR3BP2BM2B(1,:), Q_CR3BP2BM2B(2,:), Q_CR3BP2BM2B(3,:), 'm--', 'LineWidth', DC.LW); hold on;


plot3(pointMinDistL23BP4B(1), pointMinDistL23BP4B(2), pointMinDistL23BP4B(3), 'o'); hold on;
plot3(pointMinDistL22BE4B(1), pointMinDistL22BE4B(2), pointMinDistL22BE4B(3), 'o'); hold on;
plot3(pointMinDistL22BM4B(1), pointMinDistL22BM4B(2), pointMinDistL22BM4B(3), 'o'); hold on;

plot3(pointMinDistL23BP2B(1), pointMinDistL23BP2B(2), pointMinDistL23BP2B(3), 'o'); hold on;
plot3(pointMinDistL22BE2B(1), pointMinDistL22BE2B(2), pointMinDistL22BE2B(3), 'o'); hold on;
plot3(pointMinDistL22BM2B(1), pointMinDistL22BM2B(2), pointMinDistL22BM2B(3), 'o');

legend('Moon', 'Earth', 'L2', '4B + 3BP', '4B + 2BEarth', '4B + 2BMoon', '2B + 3BP', '2B + 2BEarth', '2B + 2BMoon');
title('Compare Dynamics : 2B or 4B before Hill then 3BP or 2B')
xlabel('q_1');
ylabel('q_2');
zlabel('q_3');
view(0,90);
