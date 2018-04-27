% Script pour lancer les optimisations aller
destination = 'L2';
Sansmax = true;

if Sansmax
    repOutput = ['results/outbound_impulse_' destination '_Sansmax/'];  
else
    repOutput = ['results/outbound_impulse_' destination '/'];
end

if(~exist(repOutput,'dir')); error('Wrong result directory name!'); end

for numAsteroid=1:10

    file2load = [repOutput 'asteroid_no_' int2str(numAsteroid)];
    if(exist([file2load '.mat'],'file')==2)
        load(file2load);
        nbOpti = length(allResults);
        for numOptiOutbound=1:min(5,nbOpti)

            fprintf('\nnumAsteroid = %d \n', numAsteroid);
            fprintf('numOptiOutbound = %d \n\n', numOptiOutbound);
            total_impulse_optimization(numAsteroid, numOptiOutbound, destination, Sansmax);

        end
        clear allResults;
    end

end
