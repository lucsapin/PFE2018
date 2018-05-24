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

destination = 'L2';
typeSimu = 'return';
propagation = '2B';

% ----------------------------------------------------------------------------------------------------
% Computation of trajectories for each destination
% ------------------ Get trajectory with Hill''s sphere ------------------

choix = 3; dynamic1 = '3B Perturbated'; traj1 = dynamic1;
[resDrift_3BP, ~, ~, resP2H, pointMinDistL2_3BP] = get_all_traj(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, choix);
% [resDrift_3BP, resP2H, pointMinDistL2_3BP] = get_CR3BP_traj(destination, typeSimu, numAsteroid, numOpti, dist, choix);

choix = 4; dynamic2 = '2B Sun'; traj2 = dynamic2;
[resDrift_2BS, ~, ~, ~, pointMinDistL2_2BS] = get_all_traj(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, choix);
% [resDrift_2BS, ~, pointMinDistL2_2BS]  = get_CR3BP_traj(destination, typeSimu, numAsteroid, numOpti, dist, choix);

choix = 6; dynamic3 = '2B Ad Hoc'; traj3 = dynamic3;
[resDrift_AH, ~, ~, ~, pointMinDistL2_AH] = get_all_traj(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, choix);
% [resDrift_AH, ~, pointMinDistL2_AH] = get_CR3BP_traj(destination, typeSimu, numAsteroid, numOpti, dist, choix);

% ----------------------------------------------------------------------------------------------------
% Affectation des résultats
T_CR3BP       = resDrift_3BP.T_CR3BP; % vecteur de temps

Q_CR3BP       = resDrift_3BP.Q_CR3BP; % trajectory in rotating frame
Q_CR3BP_2BS   = resDrift_2BS.Q_CR3BP; % trajectory in rotating frame
Q_CR3BP_AH    = resDrift_AH.Q_CR3BP; % trajectory in rotating frame

times_out     = resP2H.times;
Q_P2H     = resP2H.traj_out;

% COnvert in Rotating FRAME
for i=1:size(times_out, 2)
  [Q_P2H(1:6, i), ~, ~, ~, ~]  = Helio2CR3BP(Q_P2H(1:6,i), times_out(i));
end

% ----------------- Get trajectory without Hill''s sphere -----------------
[statesOpti, traj_out, q0, q1, t0_r, dt1_r] = propagate2L2(destination, typeSimu, numAsteroid, numOpti);

q1_CR3BP    = Helio2CR3BP(q1, t0_r+dt1_r);

% ----------------------------------------------------------------------------------------------------
% Plot results
figure;
display_Moon(); hold on;
display_Earth(); hold on;
display_L2(); hold on;
display_asteroid(Helio2CR3BP(q0, t0_r), 'propagate');
legend('Moon', 'Earth', 'L2', 'Asteroid');
% draw Hill's sphere (on the (q_1, q_2) plan)
viscircles([0 0], dist*UC.AU/UC.LD, 'Color', 'g');
% xlim(dist*[-1 1]*UC.AU/UC.LD);
% ylim(dist*[-1 1]*UC.AU/UC.LD);
% zlim(dist*[-1 1]*UC.AU/UC.LD);
xlabel('q_1');
ylabel('q_2');
zlabel('q_3');
view(0, 90);

figure;
display_Moon(); hold on;
display_Earth(); hold on;
display_L2(); hold on;

plot3(Q_P2H(1,:), Q_P2H(2,:), Q_P2H(3,:), 'r', 'LineWidth', DC.LW); hold on;
% plot3(Q_P2H_2B(1,:), Q_P2H_2B(2,:), Q_P2H_2B(3,:), 'r', 'LineWidth', DC.LW); hold on;
% plot3(Q_P2H_AH(1,:), Q_P2H_AH(2,:), Q_P2H_AH(3,:), 'r', 'LineWidth', DC.LW); hold on;

plot3(Q_CR3BP(1,:), Q_CR3BP(2,:), Q_CR3BP(3,:), 'r', 'LineWidth', DC.LW); hold on;
plot3(Q_CR3BP_2BS(1,:), Q_CR3BP_2BS(2,:), Q_CR3BP_2BS(3,:), 'm', 'LineWidth', DC.LW); hold on;
plot3(Q_CR3BP_AH(1,:), Q_CR3BP_AH(2,:), Q_CR3BP_AH(3,:), 'b--', 'LineWidth', DC.LW); % hold on;

% draw Hill's sphere (on the (q_1, q_2) plan)
viscircles([0 0], dist*UC.AU/UC.LD, 'Color', 'g');

legend('Moon', 'Earth', 'L2', traj1, traj2, traj3);
title('Compare Dynamics : 2B before Hill then 3BP or 2B');

xlabel('q_1');
ylabel('q_2');
zlabel('q_3');
view(0, 90);

figure;
the_legend  = {};
subplot(3,2,1);
plot(T_CR3BP, Q_CR3BP(1, :), 'r', 'LineWidth', DC.LW); hold on;
plot(T_CR3BP, Q_CR3BP_2BS(1, :), 'm', 'LineWidth', DC.LW); hold on;
plot(T_CR3BP, Q_CR3BP_AH(1, :), 'b--', 'LineWidth', DC.LW); ylabel('q_1');

subplot(3,2,3);
plot(T_CR3BP, Q_CR3BP(2, :), 'r', 'LineWidth', DC.LW); hold on;
plot(T_CR3BP, Q_CR3BP_2BS(2, :), 'm', 'LineWidth', DC.LW); hold on;
plot(T_CR3BP, Q_CR3BP_AH(2, :), 'b--', 'LineWidth', DC.LW); ylabel('q_2');

subplot(3,2,5);
plot(T_CR3BP, Q_CR3BP(3, :), 'r', 'LineWidth', DC.LW); hold on;
plot(T_CR3BP, Q_CR3BP_2BS(3, :), 'm', 'LineWidth', DC.LW); hold on;
plot(T_CR3BP, Q_CR3BP_AH(3, :), 'b--', 'LineWidth', DC.LW); ylabel('q_3');

subplot(3,2,2);
plot(T_CR3BP, Q_CR3BP(4, :), 'r', 'LineWidth', DC.LW); hold on;
plot(T_CR3BP, Q_CR3BP_2BS(4, :), 'm', 'LineWidth', DC.LW); hold on;
plot(T_CR3BP, Q_CR3BP_AH(4, :), 'b--', 'LineWidth', DC.LW); ylabel('q_4');

subplot(3,2,4);
plot(T_CR3BP, Q_CR3BP(5, :), 'r', 'LineWidth', DC.LW); hold on;
plot(T_CR3BP, Q_CR3BP_2BS(5, :), 'm', 'LineWidth', DC.LW); hold on;
plot(T_CR3BP, Q_CR3BP_AH(5, :), 'b--', 'LineWidth', DC.LW); ylabel('q_5');

subplot(3,2,6);
plot(T_CR3BP, Q_CR3BP(6, :), 'r', 'LineWidth', DC.LW); hold on;
plot(T_CR3BP, Q_CR3BP_2BS(6, :), 'm', 'LineWidth', DC.LW); hold on;
plot(T_CR3BP, Q_CR3BP_AH(6, :), 'b--', 'LineWidth', DC.LW); ylabel('q_6');

the_legend{end+1} = 'CR3BP'; the_legend{end+1} = '2B Sun'; the_legend{end+1} = '2B Ad Hoc';

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
display_asteroid(Helio2CR3BP(q0, t0_r), 'propagate'); hold on;

plot3(traj_out(1,:), traj_out(2,:), traj_out(3,:), 'r', 'LineWidth', DC.LW); traj = 'Spacecraft trajectory';
plot3(statesOpti(1,:), statesOpti(2,:), statesOpti(3,:), 'b', 'LineWidth', DC.LW); trajComp = 'Opti Spacecraft trajectory';
plot3(q1_CR3BP(1), q1_CR3BP(2), q1_CR3BP(3), 'mo');

legend('Moon', 'Earth', 'L2', 'Asteroid', traj, trajComp, 'Second boost');
title('Propagate from Asteroid to L2 without Hill''s sphere');
xlabel('q_1');
ylabel('q_2');
zlabel('q_3');
view(0,90);
