% Script pour lancer les optimisations aller
destination = 'L2';
repOutput = ['results/outbound_impulse_' destination '/'];
if(~exist(repOutput,'dir')); error('Wrong result directory name!'); end

for numAsteroid=6:6

    file2load = [repOutput 'asteroid_no_' int2str(numAsteroid)];
    if(exist([file2load '.mat'],'file')==2)
        load(file2load);
        nbOpti = length(allResults);
        for numOptiOutbound=1:min(5,nbOpti)

            fprintf('\nnumAsteroid = %d \n', numAsteroid);
            fprintf('numOptiOutbound = %d \n\n', numOptiOutbound);
            total_impulse_optimization(numAsteroid, numOptiOutbound, destination);

        end
        clear allResults;
    end

end
