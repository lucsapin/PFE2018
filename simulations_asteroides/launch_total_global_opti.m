% Script pour lancer les optimisations aller
destination = 'L2';
repOutput = ['results/outbound_impulse_' destination '/'];
if(~exist(repOutput,'dir')); error('Wrong result directory name!'); end

for numAsteroid=1:4258

    file2load = [repOutput 'asteroid_no_' int2str(numAsteroid)];
    if(exist([file2load '.mat'],'file')==2)
        load(file2load);
        nbOpti = length(allResults);

        fprintf('numAsteroid = %d \n', numAsteroid);
        numOptiOutbound = 1;
        total_impulse_optimization_global(numAsteroid, numOptiOutbound, destination);

        clear allResults;
    end

end
