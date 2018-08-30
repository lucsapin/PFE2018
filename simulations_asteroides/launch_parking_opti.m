% Script pour lancer les optimisations return
addpath('tools/');
UC = get_Univers_Constants();
Sansmax = true;
if Sansmax
  repOutput = ['results/total_impulse_L2/without_g_assist/'];
else
  repOutput = ['results/total_impulse_L2/gravity_assist/'];
end

if (~exist(repOutput,'dir'))
  error('Wrong result directory name!');
end

for numAsteroid=1:10
  file2load = [repOutput 'asteroid_no_' int2str(numAsteroid)];
  if (exist([file2load '.mat'],'file')==2)
    load(file2load);
    nbOpti = length(allResults);
    for numOptiTotal=1:min(10,nbOpti)
      parking_impulse_optimization(numAsteroid, numOptiTotal, Sansmax);
    end
  clear allResults;
  end

end
