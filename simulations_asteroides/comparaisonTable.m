addpath('tools');



delta_V_EMB = zeros(1, 10);
nbOpti_EMB = zeros(1, 10);
delta_V_L2 = zeros(1, 10);
nbOpti_L2 = zeros(1, 10);

t0_EMB = zeros(1, 10);
t0_L2 = zeros(1, 10);

dt1_EMB = zeros(1, 10);
dt1_L2 = zeros(1, 10);

dtf_EMB = zeros(1, 10);
dtf_L2 = zeros(1, 10);

typeSimu = 'return';
for numAst=1:10
    [delta_V_EMB(numAst), nbOpti_EMB(numAst), t0_EMB(numAst), dt1_EMB(numAst), dtf_EMB(numAst)] = storeResults('EMB', typeSimu, numAst);
    [delta_V_L2(numAst), nbOpti_L2(numAst), t0_L2(numAst), dt1_L2(numAst), dtf_L2(numAst)] = storeResults('L2', typeSimu, numAst);
end

abscisse = linspace(1, 10, 10);
figure;
scatter(abscisse, delta_V_EMB); hold on; scatter(abscisse, delta_V_L2);
legend('EMB', 'L2');
title([typeSimu ' : \Delta V = f(Asteroid)']);
figure;
scatter(abscisse, nbOpti_EMB); hold on; scatter(abscisse, nbOpti_L2);
legend('EMB', 'L2');
title([typeSimu ' : nbOpti = f(Asteroid)']);
figure;
scatter(abscisse, t0_EMB); hold on; scatter(abscisse, t0_L2);
legend('EMB', 'L2');
title([typeSimu ' : t0 = f(Asteroid)']);
figure;
scatter(abscisse, dt1_EMB); hold on; scatter(abscisse, dt1_L2);
legend('EMB', 'L2');
title([typeSimu ' : dt1 = f(Asteroid)']);
figure;
scatter(abscisse, dtf_EMB); hold on; scatter(abscisse, dtf_L2);
legend('EMB', 'L2');
title([typeSimu ' : dtf = f(Asteroid)']);
