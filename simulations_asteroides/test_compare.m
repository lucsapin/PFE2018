% Comparaison des simulations entre L2 et EMB
% ----------------------------------------------------------------------------------------------------


% ----------------------------------------------------------------------------------------------------
% Display settings
%
close all;
set(0,  'defaultaxesfontsize'   ,  16     , ...
    'DefaultTextVerticalAlignment'  , 'bottom', ...
    'DefaultTextHorizontalAlignment', 'left'  , ...
    'DefaultTextFontSize'           ,  16     , ...
    'DefaultFigureWindowStyle','docked');

axisColor = 'k--';

format long;

% ----------------------------------------------------------------------------------------------------
% Directories with matlab auxiliary functions
%
addpath('tools/');
addpath('bocop/libBocop2/');
addpath('bocop/');
addpath('hampath/libhampath3Mex/');

% ----------------------------------------------------------------------------------------------------
DC          = get_Display_Constants(); % Display constants
UC          = get_Univers_Constants(); % Univers constants

% ----------------------------------------------------------------------------------------------------
% User Parameters
case_2_study = 1;

switch case_2_study

    case 1

        numAsteroid         = 1;        % Numero of the asteroid
        numOpti             = 1;        % Numero of optimization for this asteroid
        dist                = 0.01;     % We propagate the trajectory to the distance dist (in AU) of EMB
        m0                  = 1000;      % kg
        TmaxN               = 50;       % Newton

    case 2

        numAsteroid         = 2;        % Numero of the asteroid
        numOpti             = 1;        % Numero of optimization for this asteroid
        dist                = 0.01;     % We propagate the trajectory to the distance dist (in AU) of EMB
        m0                  = 500;      % kg
        TmaxN               = 50;       % Newton

    otherwise

        error('No such case to study!');

end

% ----------------------------------------------------------------------------------------------------
% Definition of all the parameters
%
dirLoadL2 = ['results/total_impulse_L2/'];
dirLoadEMB = ['results/total_impulse_EMB/'];
if(~exist(dirLoadL2,'dir')); error('Wrong directory name!'); end
if(~exist(dirLoadEMB,'dir')); error('Wrong directory name!'); end

file2load = [dirLoad 'asteroid_no_' int2str(numAsteroid)];
if(exist([file2load '.mat'],'file')~=2)
    error(['there is no total impulse optimization done for asteroid number ' int2str(numAsteroid)]);
end

load(file2load);
nbOpti              = length(allResults);
if(numOpti>nbOpti)
    error(['numOpti should be less than ' int2str(nbOpti)]);
end
outputOptimization  = allResults{numOpti};

% Get initial condition
[times_out, traj_out, time_Hill, state_Hill, xC_EMB_HIll, ~, hFigSpace] = propagate2Hill(outputOptimization, dist); % The solution is given in HELIO frame

t0_day      = time_Hill;                % the initial time in Day
q0_SUN_AU   = state_Hill(1:6);          % q0 in HELIO frame in AU unit
t0_r        = outputOptimization.t0_r;
dt1_r       = outputOptimization.dt1_r;
dtf_r       = outputOptimization.dtf_r;
tf          = t0_r + dt1_r + dtf_r;
tf_guess    = tf-times_out(end);         % Remaining time to reach EMB in Day

% Drift compare
Drift_compare(t0_day, dtf_r, q0_SUN_AU, hFigSpace)

dv0_r_KM_S  = outputOptimization.dV0_r/UC.jour*UC.AU; % km / s
fprintf('dv0_r_KM_S = \n'); disp(dv0_r_KM_S); 
dv1_r_KM_S  = outputOptimization.dV1_r/UC.jour*UC.AU; % km / s
fprintf('dv1_r_KM_S = \n'); disp(dv1_r_KM_S);

% Define Bocop and HamPath parameters
[q0_CR3BP,~,~,~,thetaS0] = Helio2CR3BP(q0_SUN_AU, t0_day); % q0 in LD/d
q0          = q0_CR3BP(1:6); q0 = q0(:);
qf          = [UC.xL2 0.0 0.0 0.0 0.0 0.0]';

Tmax        = TmaxN*1e-3*(UC.time_syst)^2/UC.LD; fprintf('Tmax = %f \n', Tmax);
muCR3BP     = UC.mu0MoonLD/(UC.mu0EarthLD+UC.mu0MoonLD);
muSun       = UC.mu0SunLD/(UC.mu0EarthLD+UC.mu0MoonLD);
rhoSun      = UC.AU/UC.LD;
omegaS      = (-(UC.speedMoon+UC.NoeudMoonDot)+2*pi/UC.Period_EMB)/UC.jour*UC.time_syst;
tf_guess    = tf_guess*UC.jour/UC.time_syst; % time in UT

g0          = 9.80665*1e-3*(UC.time_syst)^2/UC.LD;
Isp         = 375/UC.time_syst; % 375 s
beta        = 1.0/(Isp*g0); fprintf('beta = %f \n', beta);

fprintf('beta*Tmax = %f \n', beta*Tmax);

% ---------------
min_dist_2_earth    = 0.0;      %
init_choice         = 'none1';  % 'none1' -- 'warm1' or 'warm2' if numAsteroid = numOpti = 1

% Unique name to save intermediate results
case_name   = ['./min_tf_Tmax_' num22str(TmaxN,3) '_m0_' num22str(m0,6) '_ast_' int2str(numAsteroid) '_dist_' num22str(dist,4) ...
                '_dist_min_2_earth_' num22str(min_dist_2_earth,2)];

dir_results = './results/main_L2_return_non_constant_mass/in_progress_results/';

if(~exist(dir_results,'dir')); error('Wrong dir_results name!'); end

file_results= [dir_results case_name];

if(exist([file_results '.mat'],'file')==2)
    load(file_results);
else
    results = [];
    results.exec_min_tf_bocop                   = -1;
    results.exec_min_tf_hampath                 = -1;
    results.exec_regul_log                      = -1;
    results.exec_min_conso_free_tf              = -1;
    results.exec_min_conso_non_constant_mass    = -1;
    results.exec_min_conso_fixed_tf             = -1;
    results.exec_homotopy_tf                    = -1;
    results.exec_homotopy_m0                    = -1;
    save(file_results, 'results');
end

%results.exec_min_tf_bocop=-1;
%results.exec_min_tf_hampath=-1;
%results.exec_regul_log = -1;
results.exec_min_conso_free_tf = -1;
%results.exec_min_conso_non_constant_mass    = -1;
%results.exec_min_conso_fixed_tf = -1;
%results.exec_homotopy_tf = -1;
%results.exec_homotopy_m0 = -1;