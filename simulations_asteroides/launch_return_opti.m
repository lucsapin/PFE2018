% Script pour lancer les optimisations return
destination = 'L2';
repOutput = ['results/return_impulse_' destination '/'];
if(~exist(repOutput,'dir')); error('Wrong result directory name!'); end

for numAsteroid=1:1
    for tour_init=1:19
        return_impulse_optimization(numAsteroid, tour_init, destination);
    end
end
