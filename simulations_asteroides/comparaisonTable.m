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
[delta_VL2_Sansmax, nbOptiL2_Sansmax, t0L2_Sansmax, dt1L2_Sansmax, dtfL2_Sansmax] = getResults('L2', typeSimu, Sansmax);
[delta_VL2_max, nbOptiL2_max, t0L2_max, dt1L2_max, dtfL2_max] = getResults('L2', typeSimu, ~Sansmax);
[delta_VEMB_Sansmax, nbOptiEMB_Sansmax, t0EMB_Sansmax, dt1EMB_Sansmax, dtfEMB_Sansmax] = getResults('EMB', typeSimu, Sansmax);
[delta_VEMB_max, nbOptiEMB_max, t0EMB_max, dt1EMB_max, dtfEMB_max] = getResults('EMB', typeSimu, ~Sansmax);

%% Comparaison resultats BOCOP entre L2 et EMB
[~, iterationsL2, objectiveL2, constraintsL2] = loadResultsBocop('L2');
[~, iterationsEMB, objectiveEMB, constraintsEMB] = loadResultsBocop('EMB');


%% Figures

% Plot opti results

figure;
scatter(abscisse, delta_VL2_Sansmax); hold on; scatter(abscisse, delta_VL2_max); hold on; 
scatter(abscisse, delta_VEMB_Sansmax); hold on; scatter(abscisse, delta_VEMB_max);
legend('L2 without max', 'L2 with max', 'EMB without max', 'EMB with max'); title([typeSimu ' : \Delta V = f(Asteroid)']);

figure;
scatter(abscisse, nbOptiL2_Sansmax); hold on; scatter(abscisse, nbOptiL2_max); hold on;
scatter(abscisse, nbOptiEMB_Sansmax); hold on; scatter(abscisse, nbOptiEMB_max);
legend('L2 without max', 'L2 with max', 'EMB without max', 'EMB with max'); title([typeSimu ' : nbOpti = f(Asteroid)']);

figure;
scatter(abscisse, t0L2_Sansmax); hold on; scatter(abscisse, t0L2_max); hold on;
scatter(abscisse, t0EMB_Sansmax); hold on; scatter(abscisse, t0EMB_max);
legend('L2 without max', 'L2 with max', 'EMB without max', 'EMB with max'); title([typeSimu ' : t0 = f(Asteroid)']);

figure;
scatter(abscisse, dt1L2_Sansmax); hold on; scatter(abscisse, dt1L2_max); hold on;
scatter(abscisse, dt1EMB_Sansmax); hold on; scatter(abscisse, dt1EMB_max);
legend('L2 without max', 'L2 with max', 'EMB without max', 'EMB with max'); title([typeSimu ' : dt1 = f(Asteroid)']);

figure;
scatter(abscisse, dtfL2_Sansmax); hold on; scatter(abscisse, dtfL2_max); hold on;
scatter(abscisse, dtfEMB_Sansmax); hold on; scatter(abscisse, dt1EMB_max);
legend('L2 without max', 'L2 with max', 'EMB without max', 'EMB with max'); title([typeSimu ' : dtf = f(Asteroid)']);

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
