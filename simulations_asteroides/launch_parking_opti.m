% Script pour lancer les optimisations return
addpath('tools/');
UC = get_Univers_Constants();
Sansmax = false;

if Sansmax
    repOutput = ['results/parking_impulse_Sansmax/'];
else
    repOutput = ['results/parking_impulse/'];
end
if(~exist(repOutput,'dir')); error('Wrong result directory name!'); end

for numAsteroid=1:10
    for tour_init=1:19
      numAsteroid
      tour_init
      parking_impulse_optimization(numAsteroid, tour_init, Sansmax);
    end
end
