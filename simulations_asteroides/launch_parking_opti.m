% Script pour lancer les optimisations return
addpath('tools/');
UC = get_Univers_Constants();

repOutput = ['results/return_impulse_L2/'];

if (~exist(repOutput,'dir'))
  error('Wrong result directory name!');
end

for numAsteroid=1:10
  file2load = [repOutput 'asteroid_no_' int2str(numAsteroid)];
  if (exist([file2load '.mat'],'file')==2)
    load(file2load);
    nbOpti = length(allResults);
    for numOptiReturn=1:min(20,nbOpti)
      parking_impulse_optimization(numAsteroid, numOptiReturn);
    end
  clear allResults;
  end

end
