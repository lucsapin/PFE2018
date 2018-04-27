close all;
set(0,  'defaultaxesfontsize'   ,  16     , ...
    'DefaultTextVerticalAlignment'  , 'bottom', ...
    'DefaultTextHorizontalAlignment', 'left'  , ...
    'DefaultTextFontSize'           ,  16     , ...
    'DefaultFigureWindowStyle','docked');

axisColor = 'k--';

addpath('tools');


%% Comparaison entre L2 sans max, L2 avec max et EMB avec max
typeSimu = 'outbound';
Sansmax = true;
[delta_VOutbound_L2, delta_VReturn_L2, t0Outbound_L2, tfOutbound_L2, t0Return_L2, tfReturn_L2] = getResults('L2', typeSimu, Sansmax);
[delta_VOutbound_L2_max, delta_VReturn_L2_max, t0Outbound_L2_max, tfOutbound_L2_max, t0Return_L2_max, tfReturn_L2_max] = getResults('L2', typeSimu, ~Sansmax);

[delta_VOutbound_EMB, delta_VReturn_EMB, t0Outbound_EMB, tfOutbound_EMB, t0Return_EMB, tfReturn_EMB] = getResults('EMB', typeSimu, Sansmax);
[delta_VOutbound_EMB_max, delta_VReturn_EMB_max, t0Outbound_EMB_max, tfOutbound_EMB_max, t0Return_EMB_max, tfReturn_EMB_max] = getResults('EMB', typeSimu, ~Sansmax);

%% Comparaison resultats BOCOP entre L2 et EMB
[~, iterationsL2, objectiveL2, constraintsL2] = loadResultsBocop('L2');
[~, iterationsEMB, objectiveEMB, constraintsEMB] = loadResultsBocop('EMB');


%% Figures

% Plot opti results
abscisse = linspace(1,10,10);
figure;
plot(delta_VOutbound_L2, 'r+'); hold on; plot(delta_VOutbound_L2_max, 'b+'); hold on;
plot(delta_VOutbound_EMB, 'g+'); hold on; plot(delta_VOutbound_EMB_max, 'm+'); hold on;
plot(delta_VReturn_L2, 'ro'); hold on; plot(delta_VReturn_L2_max, 'bo'); hold on;
plot(delta_VReturn_EMB, 'go'); hold on; plot(delta_VReturn_EMB_max, 'mo');
legend('Outbound L2', 'Outbound L2 max', 'Outbound EMB', 'Outbound EMB max', 'Return L2', 'Return L2 max', 'Return EMB', 'Return EMB max'); title(['\Delta V = f(Asteroid)']);

figure;
plot(t0Outbound_L2, 'r+'); hold on; plot(t0Outbound_L2_max, 'b+'); hold on;
plot(t0Outbound_EMB, 'g+'); hold on; plot(t0Outbound_EMB_max, 'm+'); hold on;
plot(t0Return_L2, 'ro'); hold on; plot(t0Return_L2_max, 'bo'); hold on;
plot(t0Return_EMB, 'go'); hold on; plot(t0Return_EMB_max, 'mo');
legend('Outbound L2', 'Outbound L2 max', 'Outbound EMB', 'Outbound EMB max', 'Return L2', 'Return L2 max', 'Return EMB', 'Return EMB max'); title(['t0 = f(Asteroid)']);

figure;
plot(tfOutbound_L2, 'r+'); hold on; plot(tfOutbound_L2_max, 'b+'); hold on;
plot(tfOutbound_EMB, 'g+'); hold on; plot(tfOutbound_EMB_max, 'm+'); hold on;
plot(tfReturn_L2, 'ro'); hold on; plot(tfReturn_L2_max, 'bo'); hold on;
plot(tfReturn_EMB, 'go'); hold on; plot(tfReturn_EMB_max, 'mo');
legend('Outbound L2', 'Outbound L2 max', 'Outbound EMB', 'Outbound EMB max', 'Return L2', 'Return L2 max', 'Return EMB', 'Return EMB max'); title(['tf = f(Asteroid)']);

% Plot bocop results

figure;
scatter(abscisse, iterationsEMB); hold on; scatter(abscisse, iterationsL2);
legend('EMB', 'L2'); title('Bocop results : iterations');

figure;
scatter(abscisse, objectiveEMB); hold on; scatter(abscisse, objectiveL2);
legend('EMB', 'L2'); title('Bocop results : objective');

figure;
scatter(abscisse, constraintsEMB); hold on; scatter(abscisse, constraintsL2);
legend('EMB', 'L2'); title('Bocop results : constraints');
