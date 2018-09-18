close all;
clear all;
set(0,  'defaultaxesfontsize'   ,  16     , ...
    'DefaultTextVerticalAlignment'  , 'bottom', ...
    'DefaultTextHorizontalAlignment', 'left'  , ...
    'DefaultTextFontSize'           ,  16     , ...
    'DefaultFigureWindowStyle','docked');

axisColor = 'k--';

addpath('tools');

DC = get_Display_Constants();

%% Comparaison entre L2 sans max, L2 avec max et EMB avec max
typeSimu = 'outbound';
Sansmax = true;
nbAst = 1;
delta_VOutbound_L2 = zeros(4, nbAst);
delta_VReturn_L2   = zeros(4, nbAst);
for i=1:10
  [delta_VOutbound_L2(:, i), delta_VReturn_L2(:, i), t0Outbound_L2(i), tfOutbound_L2(i), t0Return_L2(i), tfReturn_L2(i)] = getResults(i, 'L2', typeSimu, Sansmax);
  % [delta_VOutbound_L2_max(i), delta_VReturn_L2_max(i), t0Outbound_L2_max(i), tfOutbound_L2_max(i), t0Return_L2_max(i), tfReturn_L2_max(i)] = getResults(i, 'L2', typeSimu, ~Sansmax);
end
% [delta_VOutbound_EMB, delta_VReturn_EMB, t0Outbound_EMB, tfOutbound_EMB, t0Return_EMB, tfReturn_EMB] = getResults('EMB', typeSimu, Sansmax);
% [delta_VOutbound_EMB_max, delta_VReturn_EMB_max, t0Outbound_EMB_max, tfOutbound_EMB_max, t0Return_EMB_max, tfReturn_EMB_max] = getResults('EMB', typeSimu, ~Sansmax);

%% Comparaison resultats BOCOP entre L2 et EMB
% for i=1:10
  % [~, iterationsL2(i), objectiveL2(i), constraintsL2(i)] = loadResultsBocop('L2', i, 50, 350, );
% end
% [~, iterationsEMB, objectiveEMB, constraintsEMB] = loadResultsBocop('EMB');


%% Figures

% Plot opti results
abscisse = linspace(1,10,10);
figure;
plot(delta_VOutbound_L2, 'r+', 'LineWidth', DC.LW); hold on;
% plot(delta_VOutbound_L2_max, 'b+', 'LineWidth', DC.LW); hold on;
% plot(delta_VOutbound_EMB, 'g+'); hold on; plot(delta_VOutbound_EMB_max, 'm+'); hold on;
plot(delta_VReturn_L2, 'ro', 'LineWidth', DC.LW); hold on;
% plot(delta_VReturn_L2_max, 'bo', 'LineWidth', DC.LW); hold on;
% plot(delta_VReturn_EMB, 'go'); hold on; plot(delta_VReturn_EMB_max, 'mo');
% legend('Outbound L2', 'Outbound L2 max', 'Return L2', 'Return L2 max');
legend('Outbound L2', 'Return L2');

title('criterion = f(Asteroid)');

figure;
plot(t0Outbound_L2, 'r+', 'LineWidth', DC.LW); hold on;
% plot(t0Outbound_L2_max, 'b+', 'LineWidth', DC.LW); hold on;
% plot(t0Outbound_EMB, 'g+'); hold on; plot(t0Outbound_EMB_max, 'm+'); hold on;
plot(t0Return_L2, 'ro', 'LineWidth', DC.LW); hold on;
% plot(t0Return_L2_max, 'bo', 'LineWidth', DC.LW); hold on;
% plot(t0Return_EMB, 'go'); hold on; plot(t0Return_EMB_max, 'mo');
legend('Outbound L2', 'Return L2'); title(['t0 = f(Asteroid)']);

figure;
plot(tfOutbound_L2, 'r+', 'LineWidth', DC.LW); hold on;
% plot(tfOutbound_L2_max, 'b+', 'LineWidth', DC.LW); hold on;
% plot(tfOutbound_EMB, 'g+'); hold on; plot(tfOutbound_EMB_max, 'm+'); hold on;
plot(tfReturn_L2, 'ro', 'LineWidth', DC.LW); hold on;
% plot(tfReturn_L2_max, 'bo', 'LineWidth', DC.LW); hold on;
% plot(tfReturn_EMB, 'go'); hold on; plot(tfReturn_EMB_max, 'mo');
legend('Outbound L2', 'Return L2'); title(['tf = f(Asteroid)']);

% Plot bocop results

% figure;
% % scatter(abscisse, iterationsEMB); hold on;
% scatter(abscisse, iterationsL2);
% legend('Iterations L2'); title('Bocop results : iterations');
%
% figure;
% % scatter(abscisse, objectiveEMB); hold on;
% scatter(abscisse, objectiveL2);
% legend('Objective L2'); title('Bocop results : objective');
%
% figure;
% % scatter(abscisse, constraintsEMB); hold on;
% scatter(abscisse, constraintsL2);
% legend('Constraints L2'); title('Bocop results : constraints');
