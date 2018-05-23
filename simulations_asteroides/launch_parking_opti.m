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
  file2load = [repOutput 'asteroid_no_' int2str(numAsteroid)];
  if (exist([file2load '.mat'],'file')==2)
  load(file2load);
  nbOpti = length(allResults);
  for numOptiReturn=1:min(20,nbOpti)
    parking_impulse_optimization(numAsteroid, numOptiReturn, Sansmax);
  end
  clear allResults;
  end

end
