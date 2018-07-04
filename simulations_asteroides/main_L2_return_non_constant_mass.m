% Display trajectories & results of simulation and computation of trajectories with bocop & hampath for different problems
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
destination = 'L2';
dirLoad = ['results/total_impulse_' destination '/'];
if(~exist(dirLoad,'dir')); error('Wrong directory name!'); end

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
[times_out, traj_out, time_Hill, state_Hill, xC_EMB_HIll, ~, ~, ~, ~, ~] = propagate2Hill(outputOptimization, dist); % The solution is given in HELIO frame

t0_day      = time_Hill;                % the initial time in Day
q0_SUN_AU   = state_Hill(1:6);          % q0 in HELIO frame in AU unit
t0_r        = outputOptimization.t0_r;
dt1_r       = outputOptimization.dt1_r;
dtf_r       = outputOptimization.dtf_r;
tf          = t0_r + dt1_r + dtf_r;
tf_guess    = tf-times_out(end);         % Remaining time to reach EMB in Day

% Drift compare ??
% Drift_compare(t0_day, dtf_r, q0_SUN_AU)

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

results.exec_min_tf_bocop=-1;
results.exec_min_tf_hampath=1;
results.exec_regul_log = 1;
results.exec_min_conso_free_tf = 1;
results.exec_min_conso_non_constant_mass    = 1;
results.exec_min_conso_fixed_tf = 1;
results.exec_homotopy_tf = 1;
results.exec_homotopy_m0 = 1;

% ----------------------------------------------------------------------------------------------------
% Bocop solution : min tf
%
disp('Bocop solution : min tf');
%
min_tf_bocop        = [];

% parameters
m0_init     = m0;
par_bocop   = [q0; qf; Tmax; muCR3BP; muSun; rhoSun; thetaS0; omegaS; m0_init; min_dist_2_earth];

n           = 6;
dimStates   = n;
inc         = 1;
iq0         = inc:inc+dimStates-1;      inc = inc + dimStates;
iqf         = inc:inc+dimStates-1;      inc = inc + dimStates;
iTmax       = inc;                      inc = inc + 1;
imuCR3BP    = inc;                      inc = inc + 1;
imuSun      = inc;                      inc = inc + 1;
irhoSun     = inc;                      inc = inc + 1;
ithetaS0    = inc;                      inc = inc + 1;
iomegaS     = inc;                      inc = inc + 1;
im0         = inc;                      inc = inc + 1;
imin_dist_2_earth = inc;                inc = inc + 1;

keySet      = {'q0','qf','Tmax','muCR3BP','muSun','rhoSun','thetaS0','omegaS','m0','min_dist_2_earth'};
valueSet    = {iq0, iqf, iTmax, imuCR3BP, imuSun, irhoSun, ithetaS0, iomegaS, im0, imin_dist_2_earth};
map_indices_par_bocop = containers.Map(keySet, valueSet);

% Initialization
defPbBocop  = './bocop/'; % Directory where main bocop pb directory is: ./bocop/def_pb_temps_min/

if(strcmp(init_choice, 'none1')==1)

    options             = [];
    options.disc_steps  = '200';
    options.disc_method = 'gauss';

    solFileSave = './min_tf_current.sol';

    init.type   = 'from_init_file';
    init.file   = 'none';
    init.X0     = [
        {'state.0','constant',(q0(1)+qf(1))/2};         % q1
        {'state.1','constant',(q0(2)+qf(2))/2};         % q2
        {'state.2','constant',(q0(3)+qf(3))/2};         % q3
        {'state.3','constant',(q0(4)+qf(4))/2};         % v1
        {'state.4','constant',(q0(5)+qf(5))/2};         % v2
        {'state.5','constant',(q0(6)+qf(6))/2};         % v3
        {'control.0','constant',sign(qf(1)-q0(1))*0.2};                  % u1
        {'control.1','constant',sign(qf(2)-q0(2))*0.2};                  % u2
        {'control.3','constant',0.0};                   % u3
        {'optimvars','constant',1.0*tf_guess}];         % tf

else

    error('No such init_choix!');

end

% Computation
if(results.exec_min_tf_bocop==-1)

    [toutB,stageB,zB,uB,optimvarsB,outputB] = exec_bocop_min_tf(defPbBocop, init, par_bocop, options, solFileSave);
    fprintf('outputB = '); disp(outputB);

    if(outputB.status ~= 0)
        error('Bocop did not converge for the minimal time problem!');
    end

    % useful
    min_tf_bocop.indices        = map_indices_par_bocop;

    % inputs
    min_tf_bocop.init           = init;
    min_tf_bocop.par            = par_bocop;
    min_tf_bocop.options        = options;

    % outputs
    min_tf_bocop.toutB          = toutB;
    min_tf_bocop.stageB         = stageB;
    min_tf_bocop.zB             = zB;
    min_tf_bocop.uB             = uB;
    min_tf_bocop.optimvarsB     = optimvarsB;
    min_tf_bocop.outputB        = outputB;

    % Save in progress results
    results.exec_min_tf_bocop   = 1;
    results.min_tf_bocop        = min_tf_bocop;
    save(file_results, 'results');

end




% ----------------------------------------------------------------------------------------------------
% HamPath solution : min tf
%
disp('HamPath solution : min tf');
min_tf_bocop        = results.min_tf_bocop;
min_tf_hampath      = [];

% parameters
choice_pb           = 0; % minimal time
par_hampath         = [choice_pb; min_tf_bocop.par(:)];

% indices
ind_add             = 1;
iq0                 = min_tf_bocop.indices('q0')+ind_add;
iqf                 = min_tf_bocop.indices('qf')+ind_add;
iTmax               = min_tf_bocop.indices('Tmax')+ind_add;
imuCR3BP            = min_tf_bocop.indices('muCR3BP')+ind_add;
imuSun              = min_tf_bocop.indices('muSun')+ind_add;
irhoSun             = min_tf_bocop.indices('rhoSun')+ind_add;
ithetaS0            = min_tf_bocop.indices('thetaS0')+ind_add;
iomegaS             = min_tf_bocop.indices('omegaS')+ind_add;
im0                 = min_tf_bocop.indices('m0')+ind_add;
imin_dist_2_earth   = min_tf_bocop.indices('min_dist_2_earth')+ind_add;

keySet              = {'choice_pb', 'q0','qf','Tmax','muCR3BP','muSun','rhoSun','thetaS0','omegaS','m0','min_dist_2_earth'};
valueSet            = {1, iq0, iqf, iTmax, imuCR3BP, imuSun, irhoSun, ithetaS0, iomegaS, im0, imin_dist_2_earth};
map_indices_par_ham = containers.Map(keySet, valueSet);

% initial guess
n               = 6;
tf_guess        = min_tf_bocop.outputB.objective;
p0              = min_tf_bocop.zB(n+1:2*n,1);
y0              = [p0; tf_guess];
options_shoot   = hampathset('TolOdeAbs',1e-12,'TolOdeRel',1e-12,'ode','dop853','TolX',1e-12,'MaxFEval',200);

% computation
if(results.exec_min_tf_hampath==-1)

    [ysol,ssol,nfev,njev,flag] = ssolve(y0, options_shoot, par_hampath);

    if(flag~=1)
        error('ssolve did not converge for the minimal time problem!');
    end

    % useful
    min_tf_hampath.indices      = map_indices_par_ham;

    % inputs
    min_tf_hampath.y0           = y0;
    min_tf_hampath.options      = options_shoot;
    min_tf_hampath.par          = par_hampath;

    % outputs
    min_tf_hampath.ysol         = ysol;
    min_tf_hampath.ssol         = ssol;
    min_tf_hampath.nfev         = nfev;
    min_tf_hampath.njev         = njev;
    min_tf_hampath.flag         = flag;

    % save
    results.exec_min_tf_hampath = 1;
    results.min_tf_hampath      = min_tf_hampath;
    save(file_results, 'results');

end

% ----------------------------------------------------------------------------------------------------
% HamPath : homotopy from min tf to min consumption by barrier logarithmic
%
% with no variation of mass
%
disp('HamPath : homotopy from min tf to min consumption by barrier logarithmic');
min_tf_hampath  = results.min_tf_hampath;
regul_log       = [];

% ----------------------------------------------------------------------------------------------------
% On affiche la trajectoire
%
p0               = min_tf_hampath.ysol(1:n);
tf               = min_tf_hampath.ysol(n+1);
tspan            = [0.0 tf];
z0               = [q0; p0];
options_exphv    = hampathset('TolOdeAbs',1e-12,'TolOdeRel',1e-12,'ode','dopri5');
[tout, z, flag ] = exphvfun(tspan, z0, options_exphv, min_tf_hampath.par);
hFig_GA_Traj     = figure;
lc               = {1,1};
color            = DC.rouge;
subplot(lc{:}, 1); plot3(z(1,:), z(2,:), z(3,:), 'Color', color, 'LineWidth', DC.LW); hold on; view(0,90);
axis image; xlabel('x'); ylabel('y'); zlabel('z');
display_Earth();
display_Moon();

% ----------------------------------------------------------------------------------------------------
% parameters
%
par_shoot           = min_tf_hampath.par;

lambda_init         = 1e-3;
beta_init           = 0.0;
par_init            = [par_shoot; beta_init; lambda_init];

choice_pb           = 1; % regularization tf min - conso min by barrier log
ichoice_pb          = min_tf_hampath.indices('choice_pb');
par_init(ichoice_pb)= choice_pb; % update choice_pb

indices             = min_tf_hampath.indices;
ibeta               = length(par_init)-1;
indices('beta')     = ibeta; % update indices

ilambda             = length(par_init);
indices('lambda')   = ilambda; % update indices

lambda_end          = 0.9999;
par_end             = par_init;
par_end(ilambda)    = lambda_end;

options_shoot       = hampathset('TolOdeAbs',1e-12,'TolOdeRel',1e-12,'ode','dop853','TolX',1e-12,'MaxFEval',200);
%options_hampath     = hampathset('TolOdeAbs',1e-10,'TolOdeRel',1e-10,'TolOdeHamAbs',1e-10,'TolOdeHamRel',1e-10, ...
%                                 'odeHam','dopri5','ode','dopri5','MaxIterCorrection',7,'TolX',1e-8, 'MaxSfunNorm', 1e-2);


options_hampath     = hampathset('TolOdeAbs',1e-6,'TolOdeRel',1e-6,'TolOdeHamAbs',1e-6,'TolOdeHamRel',1e-6, ...
                                 'odeHam','dopri5','ode','dopri5','MaxIterCorrection',2,'TolX',1e-8, 'MaxSfunNorm', 1e-4);

% ----------------------------------------------------------------------------------------------------
% computation
%
if(results.exec_regul_log == -1)

    % -----------------------------
    % initial shoot
    pm0 = 0.0;
    y0  = [min_tf_hampath.ysol(1:6); pm0; min_tf_hampath.ysol(7)];
    s   = sfun(y0, options_shoot, par_init)

    [ysol,ssol,nfev,njev,flag] = ssolve(y0, options_shoot, par_init);

    if(flag~=1)
        error('ssolve did not converge during log regularization: par = par_init!');
    end

    % useful
    regul_log.indices           = indices;

    % inputs
    regul_log.y0                = y0;
    regul_log.options_shoot     = options_shoot;
    regul_log.par               = par_init;

    % outputs
    regul_log.ysol              = ysol;
    regul_log.ssol              = ssol;
    regul_log.nfev              = nfev;
    regul_log.njev              = njev;
    regul_log.flag              = flag;

    % -----------------------------
    % homotopy on lambda
    parspan                     = [par_init par_end];
    [parout,yout,sout,viout,dets,norms,ps,flag] = doHampath(parspan, ysol, options_hampath, 5);

    if(flag~=1 && flag~=-5 || parout(ilambda,end)<0.9)
        error('hampath did not finished the log regularization homotopy!');
    end

    % inputs
    regul_log.parspan           = parspan;
    regul_log.options_hampath   = options_hampath;

    % outputs
    regul_log.parout            = parout;
    regul_log.yout              = yout;
    regul_log.sout              = sout;
    regul_log.norms             = norms;
    regul_log.flag              = flag;

    % save
    results.exec_regul_log      = 1;
    results.regul_log           = regul_log;
    save(file_results, 'results');

end

% ----------------------------------------------------------------------------------------------------
% Detection of the structure for the minimal consumption problem with free tf + solution
%

if(results.exec_min_conso_free_tf == -1)

    regul_log           = results.regul_log;
    min_conso_free_tf   = [];

    % Shoot to get a more accurate reguralized solution
    options_shoot   = regul_log.options_shoot;
    y0              = regul_log.yout(:,end);
    par             = regul_log.parout(:,end);

    [ysol,~,~,~,flag] = ssolve(y0, options_shoot, par);

    if(flag~=1)
        error('ssolve did not converge during log regularization: par = par_end!');
    end

    % Detection of the structure
    % regul log: x = (q1, q2, q3, v1, v2, v3, m)
    % y = (p0, tf)
    n                = 7;
    p0               = ysol(1:n);
    tf               = ysol(n+1);
    tspan            = [0.0 tf];
    z0               = [q0; m0; p0]; % il faut ajouter la masse initiale
    options_exphv    = hampathset('TolOdeAbs',1e-12,'TolOdeRel',1e-12,'ode','dopri5');
    [tout, z, ~ ]   = exphvfun(tspan, z0, options_exphv, par);
    u                = control(tout, z, par);
    nu               = sqrt(u(1,:).^2+u(2,:).^2+u(3,:).^2);
    sf              = switchfun(tout, z, par);

    h=figure;
    plot(tout,sf);

    [~, seq, flag]  = detectStructure(tout, nu);

    ii = find(sf(2:end).*sf(1:end-1)<0); fprintf('ii = %f \n', ii);
    ti = [0.0 tout(ii) tf]; fprintf('ti = '); disp(ti);

    if(flag~=1)
        error('problem during struture detection for the minimal consumption problem with free tf');
    end

    % Shooting for the minimal consumption problem with free tf
    nnodes = input('Number of nodes per arc for multiple shooting: ');

    % Init zi
    tspan = ti(1);
    for i=1:length(ti)-1
        times = linspace(ti(i), ti(i+1), 2+nnodes);
        tspan = [tspan times(2:end)];
    end
    tspan           = tspan(1:end-1); % on enleve tf
    options_exphv   = hampathset('TolOdeAbs',1e-12,'TolOdeRel',1e-12,'ode','dopri5');
    [tout, z_init, ~ ] = exphvfun(tspan, z0, options_exphv, par);
    z_init          = z_init(:,2:end); % on enlever z0

    % par
    par_conso_min               = [par(1:end-1); seq(:)]; % we remove lambda and add the sequence
    indices                     = regul_log.indices;
    choice_pb                   = 2; % conso min with free tf
    ichoice_pb                  = indices('choice_pb');
    par_conso_min(ichoice_pb)   = choice_pb; % update choice_pb

    % y guess
    % y = (p0, t1, t2, ..., tf, z01, ..., z0N, z1, z11, ..., z1N, z2, z21, ..., z2N)
    % consumption: x = (q1, q2, q3, v1, v2, v3, m)
    % n = 7
    %
    y0  = [p0; ti(2:end)'];
    for i=1:length(z_init(1,:))
        y0 = [y0; z_init(:,i)];
    end

    % shooting
    options_shoot   = hampathset('TolOdeAbs',1e-12,'TolOdeRel',1e-12,'ode','radau','TolX',1e-12,'MaxFEval',300);
    s               = sfun(y0, options_shoot, par_conso_min);
    ns              = norm(s); fprintf('ns = %f \n', ns);

    [ysol,ssol,nfev,njev,flag] = ssolve(y0, options_shoot, par_conso_min);

    if(flag~=1)
        error('ssolve did not converge for the minimal consumption problem with free tf!');
    end

    nbarcs          = length(ti)-1;

    % useful
    min_conso_free_tf.indices   = indices; % il y a ilambda en plus mais c'est pas grave

    % inputs
    min_conso_free_tf.nnodes    = nnodes;
    min_conso_free_tf.nbarcs    = nbarcs;
    min_conso_free_tf.y0        = y0;
    min_conso_free_tf.options   = options_shoot;
    min_conso_free_tf.par       = par_conso_min;

    % outputs
    min_conso_free_tf.ysol      = ysol;
    min_conso_free_tf.ssol      = ssol;
    min_conso_free_tf.nfev      = nfev;
    min_conso_free_tf.njev      = njev;
    min_conso_free_tf.flag      = flag;

    % save
    results.exec_min_conso_free_tf = 1;
    results.min_conso_free_tf      = min_conso_free_tf;
    save(file_results, 'results');

end

return

% ----------------------------------------------------------------------------------------------------
% Minimal consumption with variation of the mass and free tf
%

homotopy_on_beta = [];

min_conso_free_tf   = results.min_conso_free_tf;
indices             = min_conso_free_tf.indices;
par_init            = min_conso_free_tf.par(:);
nbarcs              = min_conso_free_tf.nbarcs;
nnodes              = min_conso_free_tf.nnodes;

% for first shoot: on enleve les noeuds intermediaires
options_shoot       = hampathset('TolOdeAbs',1e-12,'TolOdeRel',1e-12,'ode','dop853','TolX',1e-12,'MaxFEval',200);
n                   = 7;
ysol_prec           = min_conso_free_tf.ysol;
y0                  = ysol_prec(1:n+nbarcs);
inc                 = n+nbarcs+1+2*n*nnodes;
for i=1:nbarcs-1
    y0  = [y0; ysol_prec(inc:inc+2*n-1)]; inc = inc + 2*n;
    inc = inc + 2*n*nnodes;
end

% for homotopy on beta
options_hampath     = hampathset('TolOdeAbs',1e-10,'TolOdeRel',1e-10,'TolOdeHamAbs',1e-10,'TolOdeHamRel',1e-10, ...
                                 'odeHam','dopri5','ode','dopri5','MaxIterCorrection',7,'TolX',1e-8, 'MaxSfunNorm', 1e-2);

ibeta               = indices('beta');
par_end             = par_init;
par_end(ibeta)      = beta;
beta

if(results.exec_min_conso_non_constant_mass == -1)

    % ---------------------------------------
    % First shoot
    %
%    s = sfun(y0, options_shoot, par_init);
    [ysol,ssol,nfev,njev,flag] = ssolve(y0, options_shoot, par_init);

    if(flag~=1)
        error('ssolve did not converge during minimal consumption shooting with par = par_init!');
    end

    % useful
    homotopy_on_beta.indices           = indices;

    % inputs
    homotopy_on_beta.y0                = y0;
    homotopy_on_beta.options_shoot     = options_shoot;
    homotopy_on_beta.par               = par_init;

    % outputs
    homotopy_on_beta.ysol              = ysol;
    homotopy_on_beta.ssol              = ssol;
    homotopy_on_beta.nfev              = nfev;
    homotopy_on_beta.njev              = njev;
    homotopy_on_beta.flag              = flag;

    % ---------------------------------------
    % Homotopy on beta
    %
    parspan                     = [par_init par_end];
    [parout,yout,sout,viout,dets,norms,ps,flag] = hampath(parspan, ysol, options_hampath);

    if(flag~=1 && flag~=-5 || parout(ilambda,end)<0.9)
        error('hampath did not finished the log regularization homotopy!');
    end

    % inputs
    homotopy_on_beta.parspan           = parspan;
    homotopy_on_beta.options_hampath   = options_hampath;

    % outputs
    homotopy_on_beta.parout            = parout;
    homotopy_on_beta.yout              = yout;
    homotopy_on_beta.sout              = sout;
    homotopy_on_beta.norms             = norms;
    homotopy_on_beta.flag              = flag;

    % save
    results.exec_min_conso_non_constant_mass    = 1;
    results.homotopy_on_beta                    = homotopy_on_beta;
    save(file_results, 'results');

end

% ----------------------------------------------------------------------------------------------------
% Calcul et affichage de la solution conso min
%
min_conso_free_tf   = results.min_conso_free_tf;
homotopy_on_beta    = results.homotopy_on_beta;
options_exphv       = hampathset('TolOdeAbs',1e-12,'TolOdeRel',1e-12,'ode','dopri5');

par_conso_min   = homotopy_on_beta.parout(:,end);
ysol            = homotopy_on_beta.yout(:,end);
nbarcs          = min_conso_free_tf.nbarcs;
n               = 7;
p0              = ysol(1:n);
ti              = [0.0 ysol(n+1:n+1+nbarcs-1)'];
tf              = ti(end);
tf_optimal      = tf
Nbsteps         = 100;
tspan           = ti(1);
for i=1:length(ti)-1
    times = linspace(ti(i), ti(i+1), Nbsteps);
    tspan = [tspan times(1)+1e-8 times(2:end)]; % On ajoute le 1e-8 juste pour l'affichage des discontinuites
end

indices             = min_conso_free_tf.indices;
im0                 = indices('m0');
initial_mass        = par_conso_min(im0);
z0                  = [q0; initial_mass; p0]; % Attention il faut ajouter la masse initiale
[tout, z, flag ]    = exphvfun(tspan, z0, ti, options_exphv, par_conso_min);
u                   = control(tout, z, ti, par_conso_min);
sf                  = switchfun(tout, z, ti, par_conso_min);

hFig    = figure;
lc      = {3,2};

subplot(lc{:}, 1); plot3(z(1,:), z(2,:), z(3,:), 'Color', DC.rouge, 'LineWidth', DC.LW); hold on;

subplot(lc{:}, 2)   ; plot(tout, u(1,:), 'Color', DC.rouge, 'LineWidth', DC.LW); hold on;
subplot(lc{:}, 4)   ; plot(tout, u(2,:), 'Color', DC.rouge, 'LineWidth', DC.LW); hold on;
subplot(lc{:}, 6) ; plot(tout, u(3,:), 'Color', DC.rouge, 'LineWidth', DC.LW); hold on;

subplot(lc{:}, 3); plot(tout, sqrt(u(1,:).^2+u(2,:).^2+u(3,:).^2), 'Color', DC.rouge, 'LineWidth', DC.LW); hold on;
subplot(lc{:}, 5); plot(tout, sf, 'Color', DC.rouge, 'LineWidth', DC.LW); hold on; daxes(0,0,axisColor);

masse_initiale  = initial_mass
masse_finale    = z(n,end)

% delta_V
ibeta           = indices('beta');
beta            = par_conso_min(ibeta);
conso           = masse_initiale-masse_finale
delta_V_variable_mass   = - (1.0/beta) * (log(masse_finale) - log(m0)) * UC.LD / UC.time_syst

% On calcule delta_V pour la sol a masse constante avec une formule ad-hoc
par             = homotopy_on_beta.parout(:,1);
ysol            = homotopy_on_beta.yout(:,1);
nbarcs          = min_conso_free_tf.nbarcs;
p0              = ysol(1:n);
ti              = [0.0 ysol(n+1:n+1+nbarcs-1)'];
initial_mass    = par(im0);
z0              = [q0; initial_mass; p0]; % Attention il faut ajouter la masse initiale
options_ode45   = odeset('AbsTol',1e-12,'RelTol',1e-12);
[tout_expcost, z_expcost, zi, costi, cost] = expcost_conso_min(z0, ti, options_ode45, par);
iTmax           = indices('Tmax');
Tmax            = par(iTmax);
im0             = indices('m0');
m0              = par(im0);
delta_V_constant_mass   = (Tmax*cost/m0)*UC.LD/UC.time_syst

% ----------------------------------------------------------------------------------------------------
% Minimal consumption with variation of the mass and fixed tf
%
%
%if(results.exec_min_conso_fixed_tf == -1)
%
%    min_conso_fixed_tf  = [];
%    homotopy_on_beta    = results.homotopy_on_beta;
%
%    par_conso_min       = homotopy_on_beta.parout(:,end);
%    ysol                = homotopy_on_beta.yout(:,end);
%    nbarcs              = min_conso_free_tf.nbarcs
%    n                   = 7;
%    p0                  = ysol(1:n);
%    ti                  = [0.0 ysol(n+1:n+1+nbarcs-1)'];
%    tf                  = ti(end)
%
%    y0                  = [p0; ti(2:end-1)'/tf; ysol(n+nbarcs+1:end)]; % le temps est normalise
%    length(y0)
%    par                 = [par_conso_min(1:end-nbarcs); tf; par_conso_min(end-nbarcs+1:end)]; % on ajoute tf et on oublie pas la séquence
%
%    indices             = min_conso_free_tf.indices;
%    choice_pb           = 3; % conso min with fixed tf
%    ichoice_pb          = indices('choice_pb');
%    par(ichoice_pb)     = choice_pb; % update choice_pb
%
%    itf                 = length(par)-nbarcs; % update indices with itf
%    indices('tf')       = itf;
%
%    options_shoot       = hampathset('TolOdeAbs',1e-12,'TolOdeRel',1e-12,'ode','dop853','TolX',1e-12,'MaxFEval',200);
%
%    s = sfun(y0, options_shoot, par)
%    [ysol,ssol,nfev,njev,flag] = ssolve(y0, options_shoot, par);
%
%    if(flag~=1)
%        error('ssolve did not converge during minimal consumption shooting with par = par_init!');
%    end;
%
%    % useful
%    min_conso_fixed_tf.indices   = indices; % il y a ilambda en plus mais c'est pas grave
%
%    % inputs
%    min_conso_fixed_tf.nnodes    = 0;
%    min_conso_fixed_tf.nbarcs    = nbarcs;
%    min_conso_fixed_tf.y0        = y0;
%    min_conso_fixed_tf.options   = options_shoot;
%    min_conso_fixed_tf.par       = par;
%
%    % outputs
%    min_conso_fixed_tf.ysol      = ysol;
%    min_conso_fixed_tf.ssol      = ssol;
%    min_conso_fixed_tf.nfev      = nfev;
%    min_conso_fixed_tf.njev      = njev;
%    min_conso_fixed_tf.flag      = flag;
%
%    % save
%    results.exec_min_conso_fixed_tf = 1;
%    results.min_conso_fixed_tf  = min_conso_fixed_tf;
%    save(file_results, 'results');
%
%end;

% ----------------------------------------------------------------------------------------------------
% Minimal consumption with variation of the mass and fixed tf: homotopy on tf
%
%
%if(results.exec_homotopy_tf == -1)
%
%    homotopy_on_tf      = [];
%    min_conso_fixed_tf  = results.min_conso_fixed_tf;
%
%    % Parameters
%    indices             = min_conso_fixed_tf.indices;
%    itf                 = indices('tf');
%    par_init            = min_conso_fixed_tf.par;
%    par_end             = par_init;
%
%    % tf_end
%    tf_init             = par_init(itf);
%    tf_init_jour        = tf_init*UC.time_syst/UC.jour
%    tf_end_jour         = max(1.1*tf_init_jour, 30) % 30 jours
%    tf_end              = tf_end_jour*UC.jour/UC.time_syst
%    par_end(itf)        = tf_end;
%
%    % y0
%    y0                  = min_conso_fixed_tf.y0;
%
%    % options
%    options_hampath     = hampathset('TolOdeAbs',1e-8,'TolOdeRel',1e-8,'TolOdeHamAbs',1e-6,'TolOdeHamRel',1e-6, ...
%                                 'odeHam','dopri5','ode','dopri5','MaxIterCorrection',2,'TolX',1e-8, 'MaxSfunNorm', 1e-2);
%
%    % Homotopy
%    parspan                     = [par_init par_end];
%    [parout,yout,sout,viout,dets,norms,ps,flag] = hampath(parspan, y0, options_hampath);
%
%    if(flag~=1)
%        error('hampath did not finished the homotopy on tf!');
%    end;
%
%    % inputs
%    homotopy_on_tf.parspan          = parspan;
%    homotopy_on_tf.options_hampath  = options_hampath;
%
%    % outputs
%    homotopy_on_tf.parout           = parout;
%    homotopy_on_tf.yout             = yout;
%    homotopy_on_tf.sout             = sout;
%    homotopy_on_tf.norms            = norms;
%    homotopy_on_tf.flag             = flag;
%
%    % save
%    results.exec_homotopy_tf        = 1;
%    results.homotopy_on_tf          = homotopy_on_tf;
%    save(file_results, 'results');
%
%end

% ----------------------------------------------------------------------------------------------------
% Affichage de delta_V et masse finale en fonction de tf
%
%homotopy_on_tf      = results.homotopy_on_tf;
%min_conso_fixed_tf  = results.min_conso_fixed_tf;
%
%indices             = min_conso_fixed_tf.indices;
%im0                 = indices('m0');
%itf                 = indices('tf');
%ibeta               = indices('beta');
%
%n                   = 7;
%parout              = homotopy_on_tf.parout;
%yout                = homotopy_on_tf.yout;
%options_exphv       = hampathset('TolOdeAbs',1e-12,'TolOdeRel',1e-12,'ode','dopri5');
%
%masses_finales      = [];
%delta_Vs            = [];
%tfs                 = [];
%
%for i=1:length(parout(1,:))
%
%    par                 = parout(:,i);
%    y                   = yout(:,i);
%
%    p0                  = y(1:n);
%    ti                  = [0.0 y(n+1:n+1+nbarcs-2)' 1.0]; % the time is normalized
%
%    initial_mass        = par(im0);
%    z0                  = [q0; initial_mass; p0]; % Attention il faut ajouter la masse initiale
%
%    tspan               = [0.0 1.0];
%
%    [tout, z, flag ]    = exphvfun(tspan, z0, ti, options_exphv, par);
%
%    beta                = par(ibeta);
%    final_mass          = z(n,end);
%    tf_par              = par(itf);
%
%    delta_Vs(i)         = - (1.0/beta) * (log(final_mass) - log(initial_mass)) * UC.LD / UC.time_syst;
%    masses_finales(i)   = final_mass;
%    tfs(i)              = tf_par;
%
%end;
%
%hFig = figure;
%subplot(2,1,1); hold on; plot(tfs, masses_finales, 'Color', DC.rouge, 'LineWidth', DC.LW);
%subplot(2,1,2); hold on; plot(tfs, delta_Vs, 'Color', DC.bleu, 'LineWidth', DC.LW);

% ----------------------------------------------------------------------------------------------------
% Minimal consumption with variation of the mass and free tf: homotopy on m0
%

if(results.exec_homotopy_m0 == -1)

    homotopy_on_m0      = [];
    homotopy_on_beta    = results.homotopy_on_beta;

    % Parameters
    indices             = homotopy_on_beta.indices;
    im0                 = indices('m0');
    par_init            = homotopy_on_beta.parout(:,end);
    par_end             = par_init;

    % m0_end
    m0_init             = par_init(im0);
    m0_end              = max(1.1*m0_init, 30000) % en kg
    par_end(im0)        = m0_end;

    % y0
    y0                  = homotopy_on_beta.yout(:,end);

    % options
    options_hampath     = hampathset('TolOdeAbs',1e-8,'TolOdeRel',1e-8,'TolOdeHamAbs',1e-6,'TolOdeHamRel',1e-6, ...
                                 'odeHam','dopri5','ode','dopri5','MaxIterCorrection',2,'TolX',1e-8, 'MaxSfunNorm', 1e-2, ...
                                 'StopAtTurningPoint', 1);

    % Homotopy
    parspan                     = [par_init par_end];
    [parout,yout,sout,viout,dets,norms,ps,flag] = hampath(parspan, y0, options_hampath);

    if(flag~=1 && flag~=-5 && flag~=-7 || parout(im0,end)<5000)
        error('hampath did not finished the homotopy on tf!');
    end

    % inputs
    homotopy_on_m0.parspan          = parspan;
    homotopy_on_m0.options_hampath  = options_hampath;

    % outputs
    homotopy_on_m0.parout           = parout;
    homotopy_on_m0.yout             = yout;
    homotopy_on_m0.sout             = sout;
    homotopy_on_m0.norms            = norms;
    homotopy_on_m0.flag             = flag;

    % save
    results.exec_homotopy_m0        = 1;
    results.homotopy_on_m0          = homotopy_on_m0;
    save(file_results, 'results');

end

% Afficher delta_V + masse finale en fonction de tf
% Trouver le min de la masse finale et faire un tir conso min a tf libre

min_conso_free_tf   = results.min_conso_free_tf;
homotopy_on_beta    = results.homotopy_on_beta;
homotopy_on_m0      = results.homotopy_on_m0;

nbarcs              = min_conso_free_tf.nbarcs;

indices             = homotopy_on_beta.indices;
im0                 = indices('m0');
ibeta               = indices('beta');

n                   = 7;
parout              = homotopy_on_m0.parout;
yout                = homotopy_on_m0.yout;
options_exphv       = hampathset('TolOdeAbs',1e-12,'TolOdeRel',1e-12,'ode','dopri5');

masses_finales      = [];
delta_Vs            = [];
m0s                 = [];

if(0)
    for i=1:length(parout(1,:))

        par                 = parout(:,i);
        y                   = yout(:,i);

        p0                  = y(1:n);
        ti                  = [0.0 ysol(n+1:n+1+nbarcs-1)'];

        initial_mass        = par(im0);
        z0                  = [q0; initial_mass; p0]; % Attention il faut ajouter la masse initiale

        tspan               = [ti(1) ti(end)];

        [tout, z, flag ]    = exphvfun(tspan, z0, ti, options_exphv, par);

        beta                = par(ibeta);
        final_mass          = z(n,end);

        delta_Vs(i)         = - (1.0/beta) * (log(final_mass) - log(initial_mass)) * UC.LD / UC.time_syst; % en km/s
        masses_finales(i)   = final_mass;
        m0s(i)              = initial_mass;

    end

    temps_final = yout(n+1+nbarcs-1,:);

    hFig = figure;
    subplot(3,1,1); hold on; plot(m0s, masses_finales, 'Color', DC.rouge, 'LineWidth', DC.LW);
    subplot(3,1,2); hold on; plot(m0s, delta_Vs, 'Color', DC.bleu, 'LineWidth', DC.LW);
    subplot(3,1,3); hold on; plot(m0s, temps_final, 'Color', DC.vert, 'LineWidth', DC.LW);
end

% m0 = 0.3*m0_on_ast

[vv,ii]     = max(masses_finales);
mf_optimale = masses_finales(ii)
m0_optimale = m0s(ii)
dV_optimal  = delta_Vs(ii)
beta        = parout(ibeta,ii);
beta_KM_S   = beta*UC.time_syst/UC.LD;

% delta_V du trajet impulsionnel retour
dV_impulse  = norm(dv0_r_KM_S)+norm(dv1_r_KM_S)
ratio       = exp(-beta_KM_S*dV_impulse);
delta_M_ratio_imp = 1.0-ratio % pourcentage consomme

%
delta_M_ratio_cont  = (m0_optimale-mf_optimale)/m0_optimale

%
m0_on_ast_optimale  = m0_optimale/ratio


% ----------------------------------------------------------------------------------------------------
% Calcul et affichage de la solution conso min avec m0 finale
%
min_conso_free_tf   = results.min_conso_free_tf;
homotopy_on_m0      = results.homotopy_on_m0;
homotopy_on_beta    = results.homotopy_on_beta;
regul_log           = results.regul_log;

options_exphv       = hampathset('TolOdeAbs',1e-12,'TolOdeRel',1e-12,'ode','dopri5');

hom = regul_log;

steps=length(hom.parout(1,:))
k=338

par_conso_min   = hom.parout(:,k);
ysol            = hom.yout(:,k);
nbarcs          = min_conso_free_tf.nbarcs;
n               = 7;
p0              = ysol(1:n);
%ti              = [0.0 ysol(n+1:n+1+nbarcs-1)'];
ti              = [0.0 ysol(n+1)];
Nbsteps         = 300;
tspan           = ti(1);
for i=1:length(ti)-1
    times = linspace(ti(i), ti(i+1), Nbsteps);
    tspan = [tspan times(1)+1e-8 times(2:end)]; % On ajoute le 1e-8 juste pour l'affichage des discontinuites
end
indices             = min_conso_free_tf.indices;
im0                 = indices('m0');
initial_mass        = par_conso_min(im0);
z0                  = [q0; initial_mass; p0]; % Attention il faut ajouter la masse initiale
[tout, z, flag ]    = exphvfun(tspan, z0, ti, options_exphv, par_conso_min);
u                   = control(tout, z, ti, par_conso_min);
sf                  = switchfun(tout, z, ti, par_conso_min);

hFig    = figure;
lc      = {3,2};

subplot(lc{:}, 1); plot3(z(1,:), z(2,:), z(3,:), 'Color', DC.rouge, 'LineWidth', DC.LW); hold on;

subplot(lc{:}, 2)   ; plot(tout, u(1,:), 'Color', DC.rouge, 'LineWidth', DC.LW); hold on;
subplot(lc{:}, 4)   ; plot(tout, u(2,:), 'Color', DC.rouge, 'LineWidth', DC.LW); hold on;
subplot(lc{:}, 6) ; plot(tout, u(3,:), 'Color', DC.rouge, 'LineWidth', DC.LW); hold on;

subplot(lc{:}, 3); plot(tout, sqrt(u(1,:).^2+u(2,:).^2+u(3,:).^2), 'Color', DC.rouge, 'LineWidth', DC.LW); hold on;
subplot(lc{:}, 5); plot(tout, sf, 'Color', DC.rouge, 'LineWidth', DC.LW); hold on; daxes(0,0,axisColor);

return
