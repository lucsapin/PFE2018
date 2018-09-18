% Display settings
set(0,  'defaultaxesfontsize'   ,  25     , ...
    'DefaultTextVerticalAlignment'  , 'bottom', ...
    'DefaultTextHorizontalAlignment', 'left'  , ...
    'DefaultTextFontSize'           ,  25     , ...
    'DefaultFigureWindowStyle','docked');

destination = 'L2';
TmaxN = 1000;
m0    = 350;
beta  = 0.278;

addpath('tools/');

UC    = get_Univers_Constants(); % Univers constants
DC    = get_Display_Constants(); % Display constants

[status, iterations, objective4, constraints, zB4, optimvarsB4] = loadResultsBocop(destination, 4, TmaxN, m0, beta);
[status, iterations, objective3, constraints, zB3, optimvarsB3] = loadResultsBocop(destination, 3, TmaxN, m0, beta);
[status, iterations, objective1, constraints, zB1, optimvarsB1] = loadResultsBocop(destination, 1, TmaxN, m0, beta);
[status, iterations, objective6, constraints, zB6, optimvarsB6] = loadResultsBocop(destination, 6, TmaxN, m0, beta);
[status, iterations, objective8, constraints, zB8, optimvarsB8] = loadResultsBocop(destination, 8, TmaxN, m0, beta);
[status, iterations, objective9, constraints, zB9, optimvarsB9] = loadResultsBocop(destination, 9, TmaxN, m0, beta);


norm_somme_dV_parking4 = norm((optimvarsB4(3:5)+optimvarsB4(6:8)+optimvarsB4(9:11))/UC.LD*UC.time_syst) % en km/s
norm_somme_dV_parking3 = norm((optimvarsB3(3:5)+optimvarsB3(6:8)+optimvarsB3(9:11))/UC.LD*UC.time_syst)
norm_somme_dV_parking1 = norm((optimvarsB1(3:5)+optimvarsB1(6:8)+optimvarsB1(9:11))/UC.LD*UC.time_syst)
norm_somme_dV_parking6 = norm((optimvarsB6(3:5)+optimvarsB6(6:8)+optimvarsB6(9:11))/UC.LD*UC.time_syst)
norm_somme_dV_parking8 = norm((optimvarsB8(3:5)+optimvarsB8(6:8)+optimvarsB8(9:11))/UC.LD*UC.time_syst)
norm_somme_dV_parking9 = norm((optimvarsB9(3:5)+optimvarsB9(6:8)+optimvarsB9(9:11))/UC.LD*UC.time_syst)

temps1 = optimvarsB1(1:2)*UC.time_syst/UC.jour

objective1

ast1_delta_V1 = optimvarsB1(3:5)/UC.LD*UC.time_syst
ast1_delta_V2 = optimvarsB1(6:8)/UC.LD*UC.time_syst
ast1_delta_V3 = optimvarsB1(9:11)/UC.LD*UC.time_syst

plot = 0;
if plot
  figure;
  display_Moon(); hold on;
  display_Earth(); hold on;
  display_L2(); hold on;

  plot3(zB4(1,:), zB4(2,:), zB4(3,:), 'LineWidth', DC.LW);
  plot3(zB3(1,:), zB3(2,:), zB3(3,:), 'LineWidth', DC.LW);
  plot3(zB1(1,:), zB1(2,:), zB1(3,:), 'LineWidth', DC.LW);
  plot3(zB6(1,:), zB6(2,:), zB6(3,:), 'LineWidth', DC.LW);
  plot3(zB8(1,:), zB8(2,:), zB8(3,:), 'LineWidth', DC.LW);
  plot3(zB9(1,:), zB9(2,:), zB9(3,:), 'LineWidth', DC.LW);

  % draw Hill's sphere (on the (q_1, q_2) plan)
  % viscircles([0 0], dist*UC.AU/UC.LD, 'Color', 'g');

  legend('Moon', 'Earth', 'L2', 'ast 4', 'ast 3', 'ast 1', 'ast 6', 'ast 8', 'ast 9');
  title('Example of 6 bocop solutions');

  xlabel('q_1');
  ylabel('q_2');
  zlabel('q_3');
  view(0, 90);
end
