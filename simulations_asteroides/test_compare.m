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
% User Parameters
numAsteroid         = 1;
TmaxN               = 50;       % Newton
dist                = 0.01;     % We propagate the trajectory to the distance dist (in AU) of EMB
numOpti             = 1;        % Numero of optimization for this asteroid
m0 = 1000; % kg

% ----------------------------------------------------------------------------------------------------
% Definition of all the parameters

% La figure pour l'affichage des trajectoires a comparer
hFigTraj = figure(1);
the_legend  = {};
typeSimu = 'total';

% Computation of trajectories for each destination
disp('------------------------------------------------------------------------');

disp('Propagate Compare : target EMB');
[T_CR3BP, Q_EMB_SUN_EMB, Q_CR3BP_EMB, color_EMB, LW_EMB, hFigSpace, zB_EMB, optimvarsB_EMB] = propagateCompare('EMB', typeSimu, numAsteroid, numOpti, dist, true, false, TmaxN, m0);
fprintf('optimvarsB = %f \n\n', optimvarsB_EMB);

disp('Propagate Compare : target L2');
[             ~, Q_EMB_SUN_L2, Q_CR3BP_L2,  color_L2,  LW_L2, ~, zB_L2, optimvarsB_L2] = propagateCompare('L2', typeSimu, numAsteroid, numOpti, dist, false, false, TmaxN, m0);
fprintf('optimvarsB = %f \n\n', optimvarsB_L2);

disp('------------------------------------------------------------------------');


figure(hFigSpace.figure);
subplot(hFigSpace.subplot{:});
plot3(Q_EMB_SUN_EMB(1,:), Q_EMB_SUN_EMB(2,:), Q_EMB_SUN_EMB(3,:), 'Color', DC.bleu, 'LineWidth', DC.LW); hold on;
plot3(Q_EMB_SUN_L2(1,:), Q_EMB_SUN_L2(2,:), Q_EMB_SUN_L2(3,:), 'Color', DC.rouge, 'LineWidth', DC.LW); hold on;
figure(hFigTraj);


if (doPlot3B_Pert)
    subplot(3,2,1);
    plot(T_CR3BP, Q_CR3BP_EMB(1,:), color_EMB, 'LineWidth', LW_EMB); hold on;
    plot(T_CR3BP, Q_CR3BP_L2(1,:), color_L2, 'LineWidth', LW_L2); ylabel('q_1');
    subplot(3,2,3);
    plot(T_CR3BP, Q_CR3BP_EMB(2,:), color_EMB, 'LineWidth', LW_EMB); hold on;
    plot(T_CR3BP, Q_CR3BP_L2(2,:), color_L2, 'LineWidth', LW_L2); ylabel('q_2');
    subplot(3,2,5);
    plot(T_CR3BP, Q_CR3BP_EMB(3,:), color_EMB, 'LineWidth', LW_EMB); hold on;
    plot(T_CR3BP, Q_CR3BP_L2(3,:), color_L2, 'LineWidth', LW_L2); ylabel('q_3');
    subplot(3,2,2);
    plot(T_CR3BP, Q_CR3BP_EMB(4,:), color_EMB, 'LineWidth', LW_EMB); hold on;
    plot(T_CR3BP, Q_CR3BP_L2(4,:), color_L2, 'LineWidth', LW_L2); ylabel('q_4');
    subplot(3,2,4);
    plot(T_CR3BP, Q_CR3BP_EMB(5,:), color_EMB, 'LineWidth', LW_EMB); hold on;
    plot(T_CR3BP, Q_CR3BP_L2(5,:), color_L2, 'LineWidth', LW_L2); ylabel('q_5');
    subplot(3,2,6);
    plot(T_CR3BP, Q_CR3BP_EMB(6,:), color_EMB, 'LineWidth', LW_EMB); hold on;
    plot(T_CR3BP, Q_CR3BP_L2(6,:), color_L2, 'LineWidth', LW_L2); ylabel('q_6');
    the_legend{end+1} = 'CR3BP\_Pert\_EMB';
    the_legend{end+1} = 'CR3BP\_Pert\_L2';
end

subplot(3,2,1); legend(the_legend{:}, 'Location', 'NorthWest');
subplot(3,2,3);
subplot(3,2,5);
subplot(3,2,2);
subplot(3,2,4);
subplot(3,2,6);

figure;
display_Moon();
display_Earth();
display_L2();
plot3(zB_L2(1,:), zB_L2(2,:), zB_L2(3,:)); hold on;
plot3(zB_EMB(1,:), zB_EMB(2,:), zB_EMB(3,:)); hold on;
plot3(Q_CR3BP_EMB(1,:), Q_CR3BP_EMB(2,:), Q_CR3BP_EMB(3,:), color_EMB, 'LineWidth', LW_EMB); hold on;
plot3(Q_CR3BP_L2(1,:), Q_CR3BP_L2(2,:), Q_CR3BP_L2(3,:), color_L2, 'LineWidth', LW_L2);
% plot(Q_CR3BP_EMB(2,1), Q_CR3BP_EMB(1,1), 'o'); hold on;
% plot(Q_CR3BP_L2(2,1), Q_CR3BP_L2(1,1), 'o'); % hold on;
% plot(qEarthHill_CR3BP(2), qEarthHill_CR3BP(1), '+'); hold on;
% plot(qMoonHill_CR3BP(2), qMoonHill_CR3BP(1), '+'); hold on;
% plot(qL2Hill_CR3BP(2), qL2Hill_CR3BP(1), '+');
xlabel('q_1');
ylabel('q_2');
zlabel('q_3');
view(0,90);
