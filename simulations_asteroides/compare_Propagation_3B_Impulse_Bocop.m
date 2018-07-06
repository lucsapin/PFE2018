% ------------------------------------------------------------------------------
% Display settings
close all;
clear all;
set(0,  'defaultaxesfontsize'   ,  16     , ...
    'DefaultTextVerticalAlignment'  , 'bottom', ...
    'DefaultTextHorizontalAlignment', 'left'  , ...
    'DefaultTextFontSize'           ,  16     , ...
    'DefaultFigureWindowStyle','docked');

axisColor = 'k--';

format longE;

% ------------------------------------------------------------------------------
% Directories with matlab auxiliary functions
addpath('tools/');
addpath('bocop/libBocop2/');
addpath('bocop/');
addpath('hampath/libhampath3Mex/');

% ------------------------------------------------------------------------------
% Definition of all the parameters
numAsteroid         = 1;
numOpti             = 1;        % Numero of optimization for this asteroid
TmaxN               = 50;       % Newton
dist                = 0.01;     % We propagate the trajectory to the distance dist (in AU) of EMB
m0                  = 60000;      % kg

DC          = get_Display_Constants(); % Display constants
UC          = get_Univers_Constants(); % Univers constants

destination = 'L2';
typeSimu = 'total';

% ------------------------------------------------------------------------------
% Computation of trajectories for each destination
[resDrift, resP2H, ~, ~] = get_all_traj(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, 4);

% ------------------------------------------------------------------------------
% Results affectation
times_out = resP2H.times;
traj_out  = resP2H.traj_out;
t0_day    = resP2H.time_Hill;
tf_guess  = resP2H.tf_guess;

% T_CR3BP   = resDrift.T_CR3BP;
% Q_EMB_SUN = resDrift.Q_EMB_SUN;
Q_CR3BP   = resDrift.Q_CR3BP;
q0_SUN_AU = resDrift.q0_SUN_AU;

% ------------------------------------------------------------------------------
% Define Bocop parameters
% Initial and final conditions in CR3BP Rotating frame (same frame as the dynamic)
[q0_CR3BP,~,~,~,thetaS0] = Helio2CR3BP(q0_SUN_AU, t0_day); % q0 in LD/d
q0          = q0_CR3BP(1:6); q0 = q0(:);
qf          = [UC.xL2; 0.0; 0.0; 0.0; 0.0; 0.0];

Tmax        = TmaxN*1e-3*(UC.time_syst)^2/UC.LD;
muCR3BP     = UC.mu0MoonLD/(UC.mu0EarthLD+UC.mu0MoonLD);
muSun       = UC.mu0SunLD/(UC.mu0EarthLD+UC.mu0MoonLD);
rhoSun      = UC.AU/UC.LD;
omegaS      = (-(UC.speedMoon+UC.NoeudMoonDot)+2*pi/UC.Period_EMB)/UC.jour*UC.time_syst;
tf_guess    = tf_guess*UC.jour/UC.time_syst; % time in UT

g0          = 9.80665*1e-3*(UC.time_syst)^2/UC.LD;
Isp         = 375/UC.time_syst; % 375 s
Ispg0       = 1.0/(Isp*g0);

init_choice = 'none1';

% Unique name to save intermediate results
case_name   = ['./min_dV_Tmax' num22str(TmaxN,3) ...
               '_m0_' num22str(m0,6) ...
               '_ast_' int2str(numAsteroid) ...
               '_dist_' num22str(dist,4)];

dir_results = ['./results/compare_inside_Hill/3B_Impulse/' destination '/in_progress_results/'];
if(~exist(dir_results,'dir')); error('Wrong dir_results name!'); end

file_results = [dir_results case_name];

if(exist([file_results '.mat'],'file')==2)
    load(file_results);
else
    results = [];
    results.exec_min_dV_bocop = -1;
    save(file_results, 'results');
end

% ------------------------------------------------------------------------------
% Bocop solution : min sum dVi
% impulse_Hill_bocop        = [];

% parameters
par_bocop = [Tmax; Ispg0; muCR3BP; muSun; rhoSun; q0; qf; thetaS0; omegaS; m0];

n = 12;

inc               = 1;
iTmax             = inc;                      inc = inc + 1;
ibeta             = inc;                      inc = inc + 1;
imuCR3BP          = inc;                      inc = inc + 1;
imuSun            = inc;                      inc = inc + 1;
irhoSun           = inc;                      inc = inc + 1;
iq0               = inc:inc+n-1;              inc = inc + n;
iqf               = inc:inc+n-1;              inc = inc + n;
ithetaS0          = inc;                      inc = inc + 1;
iomegaS           = inc;                      inc = inc + 1;
im0               = inc;                      inc = inc + 1;

keySet      = {'Tmax','beta','muCR3BP','muSun','rhoSun','q0','qf','thetaS0','omegaS','m0'};
valueSet    = {iTmax, ibeta, imuCR3BP, imuSun, irhoSun, iq0, iqf, ithetaS0, iomegaS, im0};
map_indices_par_bocop = containers.Map(keySet, valueSet);

% Initialization
defPbBocop  = 'bocop/'; % Directory where main bocop pb directory is: ./bocop/3B_impulse_Hill/

if(strcmp(init_choice, 'none1')==1)
    options             = [];
    options.disc_steps  = '100';
    options.disc_method = 'midpoint';

    solFileSave         = './min_dV_current.sol';

    init.type           = 'from_init_file';
    init.file           = 'none';
    init.X0             = [{'state.0'     , 'constant', (q0(1)+qf(1))/2}; % q11
                           {'state.1'     , 'constant', (q0(2)+qf(2))/2}; % q12
                           {'state.2'     , 'constant', (q0(3)+qf(3))/2}; % q13
                           {'state.3'     , 'constant', (q0(4)+qf(4))/2}; % q14
                           {'state.4'     , 'constant', (q0(5)+qf(5))/2}; % q15
                           {'state.5'     , 'constant', (q0(6)+qf(6))/2}; % q16
                           {'state.6'     , 'constant', (q0(1)+qf(1))/2}; % q21
                           {'state.7'     , 'constant', (q0(2)+qf(2))/2}; % q22
                           {'state.8'     , 'constant', (q0(3)+qf(3))/2}; % q23
                           {'state.9'     , 'constant', (q0(4)+qf(4))/2}; % q24
                           {'state.10'    , 'constant', (q0(5)+qf(5))/2}; % q25
                           {'state.11'    , 'constant', (q0(6)+qf(6))/2}; % q26
                           {'optimvars.0' , 'constant', 0.9};             % dt1
                           {'optimvars.1' , 'constant', 0.9};             % dt2
                           {'optimvars.2' , 'constant', 0.1};             % dV11
                           {'optimvars.3' , 'constant', 0.1};             % dV12
                           {'optimvars.4' , 'constant', 0.1};             % dV13
                           {'optimvars.5' , 'constant', 0.1};             % dV21
                           {'optimvars.6' , 'constant', 0.1};             % dV22
                           {'optimvars.7' , 'constant', 0.1};             % dV23
                           {'optimvars.8' , 'constant', 0.1};             % dV31
                           {'optimvars.9' , 'constant', 0.1};             % dV32
                           {'optimvars.10', 'constant', 0.1}];            % dV33
else
    error('No such init_choix!');
end

% Computation
if(results.exec_min_dV_bocop==-1)
    [toutB,stageB,zB,uB,optimvarsB,outputB] = exec_bocop_3B_impulse_hill(defPbBocop, init, par_bocop, options, solFileSave);

    if(outputB.status ~= 0)
        error('Bocop did not converge for the minimal time problem!');
    end

    % useful
    min_dV_bocop.indices        = map_indices_par_bocop;

    % inputs
    min_dV_bocop.init           = init;
    min_dV_bocop.par            = par_bocop;
    min_dV_bocop.options        = options;

    % outputs
    min_dV_bocop.toutB          = toutB;
    min_dV_bocop.stageB         = stageB;
    min_dV_bocop.zB             = zB;
    min_dV_bocop.uB             = uB;
    min_dV_bocop.optimvarsB     = optimvarsB;
    min_dV_bocop.outputB        = outputB;

    % Save in progress results
    results.exec_min_dV_bocop   = 1;
    results.min_dV_bocop        = min_dV_bocop;
    save(file_results, 'results');
else
    min_dV_bocop = results.min_dV_bocop;
    toutB = min_dV_bocop.toutB;
    stageB = min_dV_bocop.stageB;
    zB = min_dV_bocop.zB;
    uB = min_dV_bocop.uB;
    optimvarsB = min_dV_bocop.optimvarsB;
    outputB = min_dV_bocop.outputB;
end

% ------------------------------------------------------------------------------
% Affichage des trajectoires
plot = true;
if plot
  figure;
  display_Moon(); hold on;
  display_Earth(); hold on;
  display_L2(); hold on;

  plot3(Q_CR3BP(1,:), Q_CR3BP(2,:), Q_CR3BP(3,:), 'r', 'LineWidth', DC.LW); hold on;
  plot3(zB(1,:), zB(2,:), zB(3,:), 'b', 'LineWidth', DC.LW);

  % draw Hill's sphere (on the (q_1, q_2) plan)
  viscircles([0 0], dist*UC.AU/UC.LD, 'Color', 'g');

  legend('Moon', 'Earth', 'L2', '2 corps Soleil', 'Bocop');
  title('Compare Dynamics : Compare Bocop and Propagation in Hill''s sphere');

  xlabel('q_1');
  ylabel('q_2');
  zlabel('q_3');
  view(0, 90);
end
