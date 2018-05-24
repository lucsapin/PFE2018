% Script pour lancer les optimisations aller
departure = 'L2';

repOutput = ['results/return_impulse_' departure '/'];


if(~exist(repOutput,'dir')); error('Wrong result directory name!'); end

for numAsteroid=1:10

    file2load = [repOutput 'asteroid_no_' int2str(numAsteroid)];
    if (exist([file2load '.mat'],'file')==2)
        load(file2load);
        nbOpti = length(allResults);
        for numOptiReturn=1:min(20,nbOpti)
            outbound_impulse_optimization(numAsteroid, numOptiReturn, departure);
        end
        clear allResults;
    end

end
