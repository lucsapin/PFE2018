function outputOptimization = loadFile(destination, typeSimu, numAsteroid, numOpti, Sansmax)
% Inputs :
%   - destination : 'L2' or 'EMB'
%   - typeSimu : 'total' or 'outbound' or 'return'
%   - numAsteroid : number of the asteroid
%   - numOpti : the number of the optimization
%   - Sansmax : boolean, indicates if we consider the threshold of Moon's
%               attraction for the last boost or not.
% Output :
%   - outputOptimization : loaded file result
if Sansmax
  dirLoad = ['results/' typeSimu '_impulse_' destination '/without_g_assist/' ];
else
  dirLoad = ['results/' typeSimu '_impulse_' destination '/gravity_assist/' ];
end

if(~exist(dirLoad,'dir')); error('Wrong directory name!'); end

file2load = [dirLoad 'asteroid_no_' int2str(numAsteroid)];
if(exist([file2load '.mat'],'file')~=2)
    error(['there is no ' typeSimu ' impulse optimization done for asteroid number ' int2str(numAsteroid)]);
end

load(file2load);
nbOpti              = length(allResults);
if(numOpti>nbOpti)
    error(['numOpti should be less than ' int2str(nbOpti)]);
end
outputOptimization  = allResults{numOpti};

return
