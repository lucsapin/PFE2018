% Script pour lancer les optimisations return
destination = 'L2';
Sansmax = true;

if Sansmax
  repOutput = ['results/return_impulse_' destination '/without_g_assist/'];
else
  repOutput = ['results/return_impulse_' destination '/gravity_assist/'];
end

if(~exist(repOutput,'dir')); error('Wrong result directory name!'); end

for numAsteroid=24:50
    for tour_init=1:19
        return_impulse_optimization(numAsteroid, tour_init, destination, Sansmax);
    end
end
