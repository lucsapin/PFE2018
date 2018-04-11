close all;

set(0,  'defaultaxesfontsize'   ,  16     , ...
    'DefaultTextVerticalAlignment'  , 'bottom', ...
    'DefaultTextHorizontalAlignment', 'left'  , ...
    'DefaultTextFontSize'           ,  16     , ...
    'DefaultFigureWindowStyle','docked');

format shortE;
addpath('tools/');

numAsteroid = 1;
numOpti     = 1;
% display_total_impulse_optimization(numAsteroid,numOpti)
% display_return_impulse_optimization(numAsteroid, numOpti)

check_return_aligned_EMB_L2(numAsteroid, numOpti)
% check_outbound_aligned_EMB_L2(numAsteroid, numOpti)