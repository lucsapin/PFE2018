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

Isp     = 375/UC.time_syst; fprintf('Isp = %f \n', Isp);
g0      = 9.80665*1e-3*(UC.time_syst)^2/UC.LD; fprintf('g0 = %f \n', g0);
Tmax    = 50*1e-3*(UC.time_syst)^2/UC.LD; fprintf('Tmax = %f \n\n', Tmax);

doPlot3B_Pert           = true;

% ----------------------------------------------------------------------------------------------------
% User Parameters
case_2_study = 10;

switch case_2_study
    case 1
        numAsteroid         = 1;        % Numero of the asteroid
    case 2
        numAsteroid         = 2;
    case 3
        numAsteroid         = 3;
    case 4
        numAsteroid         = 4;
    case 5
        numAsteroid         = 5;
    case 6
        numAsteroid         = 6;
    case 7
        numAsteroid         = 7;
    case 8
        numAsteroid         = 8;
    case 9
        numAsteroid         = 9;
    case 10
        numAsteroid         = 10;
    otherwise
        error('No such case to study!');
end

if numAsteroid==1
    m0 = 1000; % kg
else
    m0 = 500;  % kg
end
TmaxN               = 50;       % Newton
dist                = 0.01;     % We propagate the trajectory to the distance dist (in AU) of EMB
numOpti             = 1;        % Numero of optimization for this asteroid

% ----------------------------------------------------------------------------------------------------
% Definition of all the parameters

% La figure pour l'affichage des trajectoires a comparer
hFigTraj = figure(1);
the_legend  = {};

typeSimu = 'total';
% Computation of trajectories for each destination
disp('EMB Computation');
[T_CR3BP_in_EMB, Q_EMB_SUN_EMB, Q_CR3BP_in_EMB_EMB, color_EMB, LW_EMB, hFigSpace, qM, qE, qL2, tfEMB, t0_day_EMB] = propagateCompare('EMB', typeSimu, numAsteroid, numOpti, dist, true, false, TmaxN, m0);

disp('L2 Computation');
[             ~, Q_EMB_SUN_L2, Q_CR3BP_in_EMB_L2,  color_L2,  LW_L2, ~, ~, ~, ~, tfL2, t0_day_L2] = propagateCompare('L2', typeSimu, numAsteroid, numOpti, dist, false, false, TmaxN, m0);

figure(hFigSpace.figure);
subplot(hFigSpace.subplot{:});
plot3(Q_EMB_SUN_EMB(1,:), Q_EMB_SUN_EMB(2,:), Q_EMB_SUN_EMB(3,:), 'Color', DC.bleu, 'LineWidth', DC.LW); hold on;
plot3(Q_EMB_SUN_L2(1,:), Q_EMB_SUN_L2(2,:), Q_EMB_SUN_L2(3,:), 'Color', DC.rouge, 'LineWidth', DC.LW); hold on;
figure(hFigTraj);

% Compute Earth Moon and L2 states from EMB inertial frame to EMB rotating frame in LD
[qMHill_EMB, qEHill_EMB, qL2Hill_EMB] = get_Moon_Earth_L2_State_Cart_LD(t0_day_EMB); % EMB inertial frame

qEarth_SUN = [Q_EMB_SUN_EMB(:, end); zeros(3,1)]*UC.AU/UC.LD + qE;
[qEarth_CR3BP,~, ~, ~, ~] = Helio2CR3BP(qEarth_SUN, tfEMB);
[qEarthHill_CR3BP,~, ~, ~, ~] = Helio2CR3BP([Q_EMB_SUN_EMB(:, end); zeros(3,1)]*UC.AU/UC.LD + qEHill_EMB, t0_day_EMB);

qMoon_SUN = [Q_EMB_SUN_EMB(:, end); zeros(3,1)]*UC.AU/UC.LD + qM;
[qMoon_CR3BP,~, ~, ~, ~] = Helio2CR3BP(qMoon_SUN, tfEMB);
[qMoonHill_CR3BP,~, ~, ~, ~] = Helio2CR3BP([Q_EMB_SUN_EMB(:, end); zeros(3,1)]*UC.AU/UC.LD + qMHill_EMB, t0_day_EMB);

qL2_SUN = [Q_EMB_SUN_EMB(:, end); zeros(3,1)]*UC.AU/UC.LD + qL2;
[qL2_CR3BP,~, ~, ~, ~] = Helio2CR3BP(qL2_SUN, tfEMB);
[qL2Hill_CR3BP,~, ~, ~, ~] = Helio2CR3BP([Q_EMB_SUN_EMB(:, end); zeros(3,1)]*UC.AU/UC.LD + qL2Hill_EMB, t0_day_EMB);


if (doPlot3B_Pert)
    subplot(3,2,1);
    plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB_EMB(1,:), color_EMB, 'LineWidth', LW_EMB); hold on;
    plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB_L2(1,:), color_L2, 'LineWidth', LW_L2); ylabel('q_1');
    subplot(3,2,3);
    plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB_EMB(2,:), color_EMB, 'LineWidth', LW_EMB); hold on;
    plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB_L2(2,:), color_L2, 'LineWidth', LW_L2); ylabel('q_2');
    subplot(3,2,5);
    plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB_EMB(3,:), color_EMB, 'LineWidth', LW_EMB); hold on;
    plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB_L2(3,:), color_L2, 'LineWidth', LW_L2); ylabel('q_3');
    subplot(3,2,2);
    plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB_EMB(4,:), color_EMB, 'LineWidth', LW_EMB); hold on;
    plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB_L2(4,:), color_L2, 'LineWidth', LW_L2); ylabel('q_4');
    subplot(3,2,4);
    plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB_EMB(5,:), color_EMB, 'LineWidth', LW_EMB); hold on;
    plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB_L2(5,:), color_L2, 'LineWidth', LW_L2); ylabel('q_5');
    subplot(3,2,6);
    plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB_EMB(6,:), color_EMB, 'LineWidth', LW_EMB); hold on;
    plot(T_CR3BP_in_EMB, Q_CR3BP_in_EMB_L2(6,:), color_L2, 'LineWidth', LW_L2); ylabel('q_6');
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
plot(Q_CR3BP_in_EMB_EMB(2,:), Q_CR3BP_in_EMB_EMB(1,:), color_EMB, 'LineWidth', LW_EMB); hold on;
plot(Q_CR3BP_in_EMB_L2(2,:), Q_CR3BP_in_EMB_L2(1,:), color_L2, 'LineWidth', LW_L2); hold on;
plot(Q_CR3BP_in_EMB_EMB(2,1), Q_CR3BP_in_EMB_EMB(1,1), 'o'); hold on;
plot(Q_CR3BP_in_EMB_L2(2,1), Q_CR3BP_in_EMB_L2(1,1), 'o');
% plot(qEarthHill_CR3BP(2), qEarthHill_CR3BP(1), '+'); hold on;
% plot(qMoonHill_CR3BP(2), qMoonHill_CR3BP(1), '+'); hold on;
% plot(qL2Hill_CR3BP(2), qL2Hill_CR3BP(1), '+');
ylabel('q_2=f(q_1)');
