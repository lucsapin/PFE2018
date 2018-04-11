% Script pour lancer les optimisations aller
destination = 'L2';
repOutput = ['results/outbound_impulse_' destination '/'];
if(~exist(repOutput,'dir')); error('Wrong result directory name!'); end

repOutputReturn = 'results/return_impulse_L2/';
if(~exist(repOutputReturn,'dir')); error('Wrong result directory name!'); end

command = ['ls ' repOutputReturn];
[status, cmdout] = system(command);
matResults = strsplit(cmdout);

numAstList = [];
for i=1:length(matResults)-1
    namesplit = strsplit(cell2mat(matResults(i)), '_');
    endname = split(namesplit(end), '.');
    numAst = str2double(cell2mat(endname(1)));
    numAstList = [numAstList numAst];
end

maxAsteroid = max(numAstList)