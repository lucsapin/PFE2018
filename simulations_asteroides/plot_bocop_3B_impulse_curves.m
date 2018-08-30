destination = 'L2';
TmaxN = 1000;
m0    = 350;
beta  = 0.278;

DC    = get_Display_Constants(); % Display constants

[status, iterations, objective, constraints, zB4] = loadResultsBocop(destination, 4, TmaxN, m0, beta);
[status, iterations, objective, constraints, zB3] = loadResultsBocop(destination, 3, TmaxN, m0, beta);
[status, iterations, objective, constraints, zB1] = loadResultsBocop(destination, 1, TmaxN, m0, beta);
[status, iterations, objective, constraints, zB6] = loadResultsBocop(destination, 6, TmaxN, m0, beta);
[status, iterations, objective, constraints, zB8] = loadResultsBocop(destination, 8, TmaxN, m0, beta);
[status, iterations, objective, constraints, zB9] = loadResultsBocop(destination, 9, TmaxN, m0, beta);

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
