% Script pour lancer les optimisations aller
destination = 'L2';
Sansmax = true;

if Sansmax
    repOutput = ['results/return_impulse_' destination '_Sansmax/'];
else
    repOutput = ['results/return_impulse_' destination '/'];
end

if(~exist(repOutput,'dir')); error('Wrong result directory name!'); end

for numAsteroid=1:10

    file2load = [repOutput 'asteroid_no_' int2str(numAsteroid)];
    if (exist([file2load '.mat'],'file')==2)
        load(file2load);
        nbOpti = length(allResults);
        for numOptiReturn=1:min(20,nbOpti)
            outbound_impulse_optimization(numAsteroid, numOptiReturn, destination, Sansmax);
        end
        clear allResults;
    end

end
