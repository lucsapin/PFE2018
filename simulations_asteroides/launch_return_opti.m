% Script pour lancer les optimisations return
destination = 'EMB';
Sansmax = true;

if Sansmax
    repOutput = ['results/return_impulse_' destination '_Sansmax/'];  
else
    repOutput = ['results/return_impulse_' destination '/'];
end
if(~exist(repOutput,'dir')); error('Wrong result directory name!'); end

for numAsteroid=1:10
    for tour_init=1:19
        return_impulse_optimization(numAsteroid, tour_init, destination, Sansmax);
    end
end
