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
numAsteroid         = 3;
numOpti             = 1;        % Numero of optimization for this asteroid
TmaxN               = 50;       % Newton
dist                = 0.01;     % We propagate the trajectory to the distance dist (in AU) of EMB
m0                  = 60000;      % kg

DC          = get_Display_Constants(); % Display constants
UC          = get_Univers_Constants(); % Univers constants

destination = 'L2';
typeSimu = 'total';

outputOptimization = loadFile(destination, typeSimu, numAsteroid, numOpti);
% ------------------------------------------------------------------------------
% Computation of trajectories for each destination
[resDrift, resP2H, ~, ~] = get_all_traj(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, 4);
% Results affectation
times_out = resP2H.times;
traj_out  = resP2H.traj_out;
t0_day    = resP2H.time_Hill;
tf_guess  = resP2H.tf_guess;
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
beta       = 1.0/(Isp*g0);

init_choice = 'none1';

% Unique name to save intermediate results
dir_results = ['./results/compare_inside_Hill/' destination '/in_progress_results/'];
if(~exist(dir_results,'dir')); error('Wrong dir_results name!'); end

case_name   = ['./min_inside_hill_bocop_Tmax_' num22str(TmaxN,3) ...
               '_m0_' num22str(m0,6) ...
               '_beta_' num22str(beta,3) ...
               '_ast_' int2str(numAsteroid)];

file_results = [dir_results case_name];

if(exist([file_results '.mat'],'file')==2)
    load(file_results);
else
    results = [];
    results.exec_min_3B_impulse_bocop = -1;
    results.exec_min_5p_continuous_bocop = -1;
    save(file_results, 'results');
end



% ------------------------------------------------------------------------------
% Bocop : min sum dVi impulsionnel
% impulse_Hill_bocop        = [];

% parameters
par_bocop = [Tmax; beta; muCR3BP; muSun; rhoSun; q0; qf; thetaS0; omegaS; m0];
% par_bocop = [18366.1811174018; 0.2781732195; 0.0121505298; 328900.57263154; 389.1724003642;
%              3.1726866765; -2.2537912313; 0.0002415389; -5.0462014285; 0.4203995399; -0.0014357139;
%              1.1556819508; 0; 0; 0; 0; 0; 6.0847870924; -0.9211841499; 60000];

n = 6;

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

    solFileSave         = './current_min_3B_impulse_bocop.sol';

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
                           {'optimvars.1' , 'constant', 0.0};             % dt2
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
if(results.exec_min_3B_impulse_bocop==-1)
    [toutB,stageB,zB,uB,optimvarsB,outputB] = exec_bocop_3B_impulse_hill(defPbBocop, init, par_bocop, options, solFileSave);

    if(outputB.status ~= 0)
        error('Bocop did not converge for the minimal dV problem!');
    end

    % useful
    min_3B_impulse_bocop.outputOpti     = outputOptimization;
    min_3B_impulse_bocop.indices        = map_indices_par_bocop;

    % inputs
    min_3B_impulse_bocop.init           = init;
    min_3B_impulse_bocop.par            = par_bocop;
    min_3B_impulse_bocop.options        = options;

    % outputs
    min_3B_impulse_bocop.toutB          = toutB;
    min_3B_impulse_bocop.stageB         = stageB;
    min_3B_impulse_bocop.zB             = zB;
    min_3B_impulse_bocop.uB             = uB;
    min_3B_impulse_bocop.optimvarsB     = optimvarsB;
    min_3B_impulse_bocop.outputB        = outputB;

    % Save in progress results
    results.exec_min_3B_impulse_bocop   = 1;
    results.min_3B_impulse_bocop        = min_3B_impulse_bocop;
    save(file_results, 'results');

    % Duplicate .sol file to save results and use it for the continuous problem
    status = system(['cp bocop/3_boosts_impulse_Hill/' solFileSave ...
                               ' bocop/3_boosts_impulse_Hill/min_3B_impulse_bocop' ...
                               '_Tmax_' num22str(TmaxN,3) ...
                               '_m0_' num22str(m0,6) ...
                               '_beta_' num22str(beta,3) ...
                               '_ast_' int2str(numAsteroid) '.sol']);

else
    min_3B_impulse_bocop = results.min_3B_impulse_bocop;
    toutB = min_3B_impulse_bocop.toutB;
    stageB = min_3B_impulse_bocop.stageB;
    zB = min_3B_impulse_bocop.zB;
    uB = min_3B_impulse_bocop.uB;
    optimvarsB = min_3B_impulse_bocop.optimvarsB;
    outputB = min_3B_impulse_bocop.outputB;
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


% ------------------------------------------------------------------------------
% Bocop : min sum duree poussee continue 5p
% parameters
par_bocop = [Tmax; beta; muCR3BP; muSun; rhoSun; q0; qf; thetaS0; omegaS; m0];

n = 6;

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
solFile = ['../3_boosts_impulse_Hill/min_3B_impulse_bocop' ...
               '_Tmax_' num22str(TmaxN,3) ...
               '_m0_' num22str(m0,6) ...
               '_beta_' num22str(beta,3) ...
               '_ast_' int2str(numAsteroid) '.sol'];

load(['results/compare_inside_Hill/L2/in_progress_results/min_inside_hill_bocop' ...
      '_Tmax_' num22str(TmaxN,3) ...
      '_m0_' num22str(m0,6) ...
      '_beta_' num22str(beta,3) ...
      '_ast_' int2str(numAsteroid) '.mat']);

norm_dV1 = norm(results.min_3B_impulse_bocop.optimvarsB(3:5));
norm_dV2 = norm(results.min_3B_impulse_bocop.optimvarsB(6:8));
norm_dV3 = norm(results.min_3B_impulse_bocop.optimvarsB(9:11));

init_m1 = m0;
init_m2 = init_m1*exp(-beta*norm_dV1);
init_m3 = init_m2;
init_m4 = init_m3*exp(-beta*norm_dV2);
init_m5 = init_m4;

init_dt1 = init_m1*norm_dV1/Tmax;
init_dt3 = init_m3*norm_dV2/Tmax;
init_dtf = init_m5*norm_dV3/Tmax;

init_dt2 = results.min_3B_impulse_bocop.optimvarsB(1) - (init_dt1 + init_dt3/2);
init_dt4 = results.min_3B_impulse_bocop.optimvarsB(2) - (init_dtf + init_dt3/2);

init_u11 = results.min_3B_impulse_bocop.optimvarsB(3);
init_u12 = results.min_3B_impulse_bocop.optimvarsB(4);
init_u13 = results.min_3B_impulse_bocop.optimvarsB(5);
init_u31 = results.min_3B_impulse_bocop.optimvarsB(6);
init_u32 = results.min_3B_impulse_bocop.optimvarsB(7);
init_u33 = results.min_3B_impulse_bocop.optimvarsB(8);
init_u51 = results.min_3B_impulse_bocop.optimvarsB(9);
init_u52 = results.min_3B_impulse_bocop.optimvarsB(10);
init_u53 = results.min_3B_impulse_bocop.optimvarsB(11);

if(strcmp(init_choice, 'none1')==1)

    options             = [];
    options.disc_steps  = '100';
    options.disc_method = 'midpoint';

    solFileSave         = './min_5p_continuous_bocop.sol';

    init.type           = 'from_init_file';
    init.file           = 'none';
    init.X0             = [{'state.0'     , 'constant', (q0(1)+qf(1))/2}; % q11
                           {'state.1'     , 'constant', (q0(2)+qf(2))/2}; % q12
                           {'state.2'     , 'constant', (q0(3)+qf(3))/2}; % q13
                           {'state.3'     , 'constant', (q0(4)+qf(4))/2}; % q14
                           {'state.4'     , 'constant', (q0(5)+qf(5))/2}; % q15
                           {'state.5'     , 'constant', (q0(6)+qf(6))/2}; % q16
                           {'state.6'     , 'constant', init_m1};         % m1
                           {'state.7'     , 'constant', (q0(2)+qf(2))/2}; % q21 balistique
                           {'state.8'     , 'constant', (q0(3)+qf(3))/2}; % q22 balistique
                           {'state.9'     , 'constant', (q0(4)+qf(4))/2}; % q23 balistique
                           {'state.10'    , 'constant', (q0(5)+qf(5))/2}; % q24 balistique
                           {'state.11'    , 'constant', (q0(6)+qf(6))/2}; % q25 balistique
                           {'state.12'    , 'constant', (q0(1)+qf(1))/2}; % q26 balistique
                           {'state.13'    , 'constant', init_m2};         % m2  balistique
                           {'state.14'    , 'constant', (q0(3)+qf(3))/2}; % q31
                           {'state.15'    , 'constant', (q0(4)+qf(4))/2}; % q32
                           {'state.16'    , 'constant', (q0(5)+qf(5))/2}; % q33
                           {'state.17'    , 'constant', (q0(6)+qf(6))/2}; % q34
                           {'state.18'    , 'constant', (q0(1)+qf(1))/2}; % q35
                           {'state.19'    , 'constant', (q0(2)+qf(2))/2}; % q36
                           {'state.20'    , 'constant', init_m3};         % m3
                           {'state.21'    , 'constant', (q0(4)+qf(4))/2}; % q41 balistique
                           {'state.22'    , 'constant', (q0(5)+qf(5))/2}; % q42 balistique
                           {'state.23'    , 'constant', (q0(6)+qf(6))/2}; % q43 balistique
                           {'state.24'    , 'constant', (q0(2)+qf(2))/2}; % q44 balistique
                           {'state.25'    , 'constant', (q0(3)+qf(3))/2}; % q45 balistique
                           {'state.26'    , 'constant', (q0(4)+qf(4))/2}; % q46 balistique
                           {'state.27'    , 'constant', init_m4};         % m4  balistique
                           {'state.28'    , 'constant', (q0(6)+qf(6))/2}; % q51
                           {'state.29'    , 'constant', (q0(1)+qf(1))/2}; % q52
                           {'state.30'    , 'constant', (q0(2)+qf(2))/2}; % q53
                           {'state.31'    , 'constant', (q0(3)+qf(3))/2}; % q54
                           {'state.32'    , 'constant', (q0(4)+qf(4))/2}; % q55
                           {'state.33'    , 'constant', (q0(5)+qf(5))/2}; % q56
                           {'state.34'    , 'constant', init_m5};         % m5
                           {'optimvars.0' , 'constant', init_dt1};        % dt1
                           {'optimvars.1' , 'constant', init_dt2};        % dt2 balistique
                           {'optimvars.2' , 'constant', init_dt3};        % dt3
                           {'optimvars.3' , 'constant', init_dt4};        % dt4 balistique
                           {'optimvars.4' , 'constant', init_dtf};        % dtf
                           {'control.0'   , 'constant', init_u11};        % u11
                           {'control.1'   , 'constant', init_u12};        % u12
                           {'control.2'   , 'constant', init_u13};        % u13
                           {'control.3'   , 'constant', init_u31};        % u31
                           {'control.4'   , 'constant', init_u32};        % u32
                           {'control.5'   , 'constant', init_u33};        % u33
                           {'control.6'   , 'constant', init_u51};        % u51
                           {'control.7'   , 'constant', init_u52};        % u52
                           {'control.8'   , 'constant', init_u53}];        % u53

else
    error('No such init_choix!');
end

% Computation
if(results.exec_min_5p_continuous_bocop==-1)
    [toutB,stageB,zB,uB,optimvarsB,outputB] = exec_bocop_5p_continuous_Hill(defPbBocop, init, par_bocop, options, solFileSave);

    if(outputB.status ~= 0)
        error('Bocop did not converge for the minimal dV problem!');
    end

    % useful
    min_5p_continuous_bocop.outputOpti     = outputOptimization;
    min_5p_continuous_bocop.indices        = map_indices_par_bocop;

    % inputs
    min_5p_continuous_bocop.init           = init;
    min_5p_continuous_bocop.par            = par_bocop;
    min_5p_continuous_bocop.options        = options;

    % outputs
    min_5p_continuous_bocop.toutB          = toutB;
    min_5p_continuous_bocop.stageB         = stageB;
    min_5p_continuous_bocop.zB             = zB;
    min_5p_continuous_bocop.uB             = uB;
    min_5p_continuous_bocop.optimvarsB     = optimvarsB;
    min_5p_continuous_bocop.outputB        = outputB;

    % Save in progress results
    results.exec_min_5p_continuous_bocop   = 1;
    results.min_5p_continuous_bocop        = min_5p_continuous_bocop;
    save(file_results, 'results');

else
    min_5p_continuous_bocop = results.min_5p_continuous_bocop;
    toutB = min_5p_continuous_bocop.toutB;
    stageB = min_5p_continuous_bocop.stageB;
    zB = min_5p_continuous_bocop.zB;
    uB = min_5p_continuous_bocop.uB;
    optimvarsB = min_5p_continuous_bocop.optimvarsB;
    outputB = min_5p_continuous_bocop.outputB;
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


% ------------------------------------------------------------------------------
% Bocop : min sum duree poussee continue 3p
% parameters
par_bocop = [Tmax; beta; muCR3BP; muSun; rhoSun; q0; qf; thetaS0; omegaS; m0];

n = 6;

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
solFile = ['../3_boosts_impulse_Hill/min_3B_impulse_bocop' ...
               '_Tmax_' num22str(TmaxN,3) ...
               '_m0_' num22str(m0,6) ...
               '_beta_' num22str(beta,3) ...
               '_ast_' int2str(numAsteroid) '.sol'];

if(strcmp(init_choice, 'none1')==1)

    options             = [];
    options.disc_steps  = '100';
    options.disc_method = 'midpoint';

    solFileSave         = './min_3p_continuous_bocop.sol';

    init.type           = 'from_sol_file_warm';
    init.file           = solFile;
    init.X0             = [];

else
    error('No such init_choix!');
end

% Computation
if(results.exec_min_3p_continuous_bocop==-1)
    [toutB,stageB,zB,uB,optimvarsB,outputB] = exec_bocop_3p_continuous_Hill(defPbBocop, init, par_bocop, options, solFileSave);

    if(outputB.status ~= 0)
        error('Bocop did not converge for the minimal dV problem!');
    end

    % useful
    min_3p_continuous_bocop.outputOpti     = outputOptimization;
    min_3p_continuous_bocop.indices        = map_indices_par_bocop;

    % inputs
    min_3p_continuous_bocop.init           = init;
    min_3p_continuous_bocop.par            = par_bocop;
    min_3p_continuous_bocop.options        = options;

    % outputs
    min_3p_continuous_bocop.toutB          = toutB;
    min_3p_continuous_bocop.stageB         = stageB;
    min_3p_continuous_bocop.zB             = zB;
    min_3p_continuous_bocop.uB             = uB;
    min_3p_continuous_bocop.optimvarsB     = optimvarsB;
    min_3p_continuous_bocop.outputB        = outputB;

    % Save in progress results
    results.exec_min_3p_continuous_bocop   = 1;
    results.min_3p_continuous_bocop        = min_3p_continuous_bocop;
    save(file_results, 'results');

else
    min_3p_continuous_bocop = results.min_3p_continuous_bocop;
    toutB = min_3p_continuous_bocop.toutB;
    stageB = min_3p_continuous_bocop.stageB;
    zB = min_3p_continuous_bocop.zB;
    uB = min_3p_continuous_bocop.uB;
    optimvarsB = min_3p_continuous_bocop.optimvarsB;
    outputB = min_3p_continuous_bocop.outputB;
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
