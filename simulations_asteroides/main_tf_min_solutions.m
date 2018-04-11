
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

format longE;

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
% Parameters
%
numAsteroid = 1;    % Numero of the asteroid
numOpti     = 1;    % Numero of optimization for this asteroid

dirLoad = 'results/total_impulse/';
if(~exist(dirLoad,'dir')); error('Wrong directory name!'); end;

file2load = [dirLoad 'asteroid_no_' int2str(numAsteroid)];
if(exist([file2load '.mat'],'file')~=2)
    error(['there is no total impulse optimization done for asteroid number ' int2str(numAsteroid)]);
end;

%
load(file2load);
nbOpti              = length(allResults);
if(numOpti>nbOpti)
    error(['numOpti should be less than ' int2str(nbOpti)]);
end;
outputOptimization  = allResults{numOpti};

% Get initial condition
dist        = 0.01; % We propagate the trajectory to the distance dist (in AU) of EMB
[times_out, traj_out, time_Hill, state_Hill, xC_EMB_HIll, flag, hFigSpace] = propagate2Hill(outputOptimization, dist); % The solution is given in HELIO frame

t0_day      = time_Hill;                % the initial time in Day
q0_SUN_AU   = state_Hill(1:6);          % q0 in HELIO frame in AU unit
t0_r        = outputOptimization.t0_r;
dt1_r       = outputOptimization.dt1_r;
dtf_r       = outputOptimization.dtf_r;
tf          = t0_r + dt1_r + dtf_r;
tf_guess    = tf-times_out(end);        % Remaining time to reach EMB

% Define Bocop and HamPath parameters
[q0_CR3BP,~,~,~,thetaS0] = Helio2CR3BP(q0_SUN_AU, t0_day); % q0 in LD/d
q0          = q0_CR3BP(1:6); q0 = q0(:);
qf          = [UC.xL2 0.0 0.0 0.0 0.0 0.0]';

m0          = 1e4;                                          % kg
TmaxN       = 50;
Tmax        = TmaxN*1e-3*(UC.time_syst)^2/UC.LD;            % 50 N
muCR3BP     = UC.mu0MoonLD/(UC.mu0EarthLD+UC.mu0MoonLD);
muSun       = UC.mu0SunLD/(UC.mu0EarthLD+UC.mu0MoonLD);
rhoSun      = UC.AU/UC.LD;
omegaS      = (-(UC.speedMoon+UC.NoeudMoonDot)+2*pi/UC.Period_EMB)/UC.jour*UC.time_syst;
tf_guess    = tf_guess*UC.jour/UC.time_syst;

min_dist_2_earth            = 0.0;
min_dist_2_earth_non_zero   = 0.15; % 0.05, 0.07, 0.08, 0.10, 0.15 LD

% Bocop parameters
par_bocop               = [q0; qf; Tmax; muCR3BP; muSun; rhoSun; thetaS0; omegaS; m0; min_dist_2_earth];
par_bocop_dist_2_earth  = [q0; qf; Tmax; muCR3BP; muSun; rhoSun; thetaS0; omegaS; m0; min_dist_2_earth_non_zero];

% HamPath parameters
choice_pb   = 0; % minimal time
par_hampath = [choice_pb; q0; qf; Tmax; muCR3BP; muSun; rhoSun; thetaS0; omegaS; m0; min_dist_2_earth];
par_hampath_dist_2_earth = [choice_pb; q0; qf; Tmax; muCR3BP; muSun; rhoSun; thetaS0; omegaS; m0; min_dist_2_earth_non_zero];

% Used to compute delta_V
g0          = 9.80665*1e-3*(UC.time_syst)^2/UC.LD;
Isp         = 375/UC.time_syst;
beta        = 1.0/(Isp*g0)

% Unique name to save intermediate results
case_name   = ['./min_tf_Tmax_' num22str(TmaxN,3) '_m0_' num22str(m0,6) '_ast_' int2str(numAsteroid) '_dist_' num22str(dist,4) ...
                '_dist_min_2_earth_' num22str(min_dist_2_earth_non_zero,2)];
dir_results = ['./results/main_tf_min_solutions/'];
if(~exist(dir_results,'dir')); error('Wrong dir_results name!'); end;
file_results= [dir_results case_name];
if(exist([file_results '.mat'],'file')==2)
    load(file_results);
else
    results.exec_bocop_sol_gravity_assist       = -1;
    results.exec_hampath_sol_gravity_assist     = -1;
    results.result_bocop_sol_gravity_assist     = [];
    results.result_hampath_sol_gravity_assist   = [];

    results.exec_bocop_sol_gravity_assist_dist_2_earth       = -1;
    results.exec_hampath_sol_gravity_assist_dist_2_earth     = -1;
    results.result_bocop_sol_gravity_assist_dist_2_earth     = [];
    results.result_hampath_sol_gravity_assist_dist_2_earth   = [];

    results.exec_bocop_sol_simple               = -1;
    results.exec_hampath_sol_simple             = -1;
    results.result_bocop_sol_simple             = [];
    results.result_hampath_sol_simple           = [];

    save(file_results, 'results');
end;

% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------
%  SOLUTION WITH GRAVITY ASSIST
% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------
% Get Bocop and HamPath solutions
%
defPbBocop  = ['./bocop/'];                                                 % Directory where main bocop pb directory is: ./bocop/def_pb_temps_min/

options             = [];
options.disc_steps  = '1000';
options.disc_method = 'gauss';

solFileLoad = ['./min_tf_Tmax_50_m0_10000_ast_1_sol_gravity_assist_dist_min_2_earth_0p0.sol'];   % Path from the main bocop pb directory
solFileSave = ['./min_tf_current.sol'];

init.type   = 'from_sol_file_warm';
init.file   = solFileLoad;
init.X0     = [];

if(results.exec_bocop_sol_gravity_assist==-1)

    [toutB,stageB,zB,uB,optimvarsB,outputB] = exec_bocop_min_tf(defPbBocop, init, par_bocop, options, solFileSave);
    outputB

    if(outputB.status ~= 0)
        error('Bocop did not converge for the minimal time problem!');
    end;

    results.exec_bocop_sol_gravity_assist               = 1;
    results.result_bocop_sol_gravity_assist.toutB       = toutB;
    results.result_bocop_sol_gravity_assist.stageB      = stageB;
    results.result_bocop_sol_gravity_assist.zB          = zB;
    results.result_bocop_sol_gravity_assist.uB          = uB;
    results.result_bocop_sol_gravity_assist.optimvarsB  = optimvarsB;
    results.result_bocop_sol_gravity_assist.outputB     = outputB;
    save(file_results, 'results');

end;

% HamPath
n               = 6;
tf_guess        = results.result_bocop_sol_gravity_assist.outputB.objective;
p0              = results.result_bocop_sol_gravity_assist.zB(n+1:2*n,1);
y0              = [p0; tf_guess];
options_shoot   = hampathset('TolOdeAbs',1e-12,'TolOdeRel',1e-12,'ode','dop853','TolX',1e-12,'MaxFEval',200);

if(results.exec_hampath_sol_gravity_assist==-1)

    [ysol,ssol,nfev,njev,flag] = ssolve(y0, options_shoot, par_hampath);

    if(flag~=1)
        error('ssolve did not converge for the minimal time problem!');
    end;

    results.exec_hampath_sol_gravity_assist         = 1;
    results.result_hampath_sol_gravity_assist.ysol  = ysol;
    results.result_hampath_sol_gravity_assist.ssol  = ssol;
    results.result_hampath_sol_gravity_assist.nfev  = nfev;
    results.result_hampath_sol_gravity_assist.njev  = njev;
    results.result_hampath_sol_gravity_assist.flag  = flag;
    save(file_results, 'results');

end;

% ----------------------------------------------------------------------------------------------------
% Affichage de la solution
p0               = results.result_hampath_sol_gravity_assist.ysol(1:n);
tf               = results.result_hampath_sol_gravity_assist.ysol(n+1);
tspan            = [0.0 tf];
z0               = [q0; p0];
options_exphv    = hampathset('TolOdeAbs',1e-12,'TolOdeRel',1e-12,'ode','dopri5');
[tout, z, flag ] = exphvfun(tspan, z0, options_exphv, par_hampath);
u                = control(tout, z, par_hampath);
Hs               = relevement(tout, z, par_hampath);
ham              = hfun(tout, z, par_hampath);
H1 = Hs(2,:);
H2 = Hs(3,:);
H3 = Hs(4,:);
const_dist_2_earth_all  = getconstdistearth(tout, z, par_hampath);
const_dist_2_earth      = const_dist_2_earth_all(1,:);

% calcul du \int ||u||
options_ode45                   = odeset('AbsTol',1e-12,'RelTol',1e-12);
[tout_aux, zout_aux, zi_aux, costi_aux, nu_total ]  = expcost_conso_min(z0, tspan, options_ode45, par_hampath);

% delta_V
conso           = beta*Tmax*nu_total
ndelta_V_soL1   = (Tmax*nu_total/m0)*UC.LD/UC.time_syst %en km/s

% ----------------------------------------------------------------------------------------------------
% distance to Earth
dist_2_earth            = sqrt(min_dist_2_earth^2-const_dist_2_earth);
[vv,ii]                 = min(dist_2_earth);
min_dist_2_earth_time   = tout(ii);

%
ii1 = find(H1(1:end-1).*H1(2:end)<0);
ii2 = find(H2(1:end-1).*H2(2:end)<0);
ii3 = find(H3(1:end-1).*H3(2:end)<0);

Phi = sqrt(H1.^2+H2.^2+H3.^3);
[vv,ii] = min(Phi);
almost_pi_sing_time     = tout(ii);
almost_pi_sing_position = z(:,ii);

% ----------------------------------------------------------------------------------------------------
% First figure: trajectory
hFig_GA_Traj    = figure;
lc      = {1,1};
color   = DC.rouge;

subplot(lc{:}, 1); plot3(z(1,:), z(2,:), z(3,:), 'Color', color, 'LineWidth', DC.LW); hold on; view(0,90); axis image; xlabel('x'); ylabel('y'); zlabel('z');
display_Earth();
display_Moon();
display_Position(almost_pi_sing_position, color);
title('Trajectory in rotating frame: solution with gravity assist');
%axis([-0.2 UC.xL2 -0.05 0.35]); daxes(UC.xL2, 0.0, axisColor);
axis([-1.5 UC.xL2 -0.2 1.6]); daxes(UC.xL2, 0.0, axisColor);

% ----------------------------------------------------------------------------------------------------
% Figure : state-costate wrt time
hFig_GA_position    = figure;
lc                  = {3,2};

subplot(lc{:}, 1); z_cur = z(1,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('r_1');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 3); z_cur = z(2,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('r_2');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 5); z_cur = z(3,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('r_3');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 2); z_cur = z(n+1,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('p_1');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 4); z_cur = z(n+2,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('p_2');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 6); z_cur = z(n+3,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('p_3');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

% ----------------------------------------------------------------------------------------------------
% Figure : state-costate wrt time
hFig_GA_velocity    = figure;
lc                  = {3,2};

subplot(lc{:}, 1); z_cur = z(3,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('v_1');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 3); z_cur = z(4,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('v_2');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 5); z_cur = z(5,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('v_3');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 2); z_cur = z(n+4,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('p_4');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 4); z_cur = z(n+5,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('p_5');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 6); z_cur = z(n+6,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('p_6');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

% ----------------------------------------------------------------------------------------------------
% Last figure: trajectory, control, distance to earth and moon ant Hamiltonian lifts
hFig_GA_All    = figure;
lc      = {3,3};

% trajectory
subplot(lc{:}, 1); plot3(z(1,:), z(2,:), z(3,:), 'Color', color, 'LineWidth', DC.LW); hold on; view(0,90); axis image; xlabel('x'); ylabel('y'); zlabel('z');
display_Earth();
display_Moon();
display_Position(almost_pi_sing_position, color);
title('Trajectory in rotating frame');

% distance to earth
subplot(lc{:}, 4); plot(tout, dist_2_earth, 'Color', color, 'LineWidth', DC.LW); hold on;
xlabel('t');
ylabel('distance');
title('distance to Earth');
axis tight;

ylim([0.0 max(dist_2_earth)]);
daxes(min_dist_2_earth_time, min_dist_2_earth, axisColor);

% distance to moon
moon_position  = [1.0-muCR3BP; 0.0; 0.0];
dist_2_moon    = sqrt((z(1,:)-moon_position(1)).^2+(z(2,:)-moon_position(2)).^2+(z(3,:)-moon_position(3)).^2);
subplot(lc{:}, 7); plot(tout, dist_2_moon, 'Color', color, 'LineWidth', DC.LW); hold on;
xlabel('t');
ylabel('distance');
title('distance to Moon');
axis tight;

[vv,ii] = min(dist_2_moon);
min_dist_2_moon_time = tout(ii);

ylim([0.0 max(dist_2_moon)]);
%daxes(min_dist_2_moon_time, 0.0, axisColor);

% control
subplot(lc{:}, 2); axis([tout(1) tout(end) min(u(1,:)) max(u(1,:))]); hold on; xlabel('t'); ylabel('u_1');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, u(1,:), 'Color', color, 'LineWidth', DC.LW);% axis tight;

subplot(lc{:}, 5); axis([tout(1) tout(end) min(u(2,:)) max(u(2,:))]); hold on; xlabel('t'); ylabel('u_2');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, u(2,:), 'Color', color, 'LineWidth', DC.LW);% axis tight;

subplot(lc{:}, 8); axis([tout(1) tout(end) min(u(3,:)) max(u(3,:))]); hold on; xlabel('t'); ylabel('u_3');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, u(3,:), 'Color', color, 'LineWidth', DC.LW);% axis tight;

% hamiltonian lifts
% find where Phi = ||(H1, H2, H3)|| touches 0
% H1 = Hs(2,:)
% H2 = Hs(3,:)
% H3 = Hs(4,:)
subplot(lc{:}, 3); axis([tout(1) tout(end) min(H1(:)) max(H1(:))]); hold on; xlabel('t'); ylabel('H_1');
%daxes(almost_pi_sing_time, 0.0, axisColor);
daxes(min_dist_2_earth_time, 0.0, axisColor);
plot(tout, H1(:), 'Color', color, 'LineWidth', DC.LW);% axis tight;

subplot(lc{:}, 6); axis([tout(1) tout(end) min(H2(:)) max(H2(:))]); hold on; xlabel('t'); ylabel('H_2');
%daxes(almost_pi_sing_time, 0.0, axisColor);
daxes(min_dist_2_earth_time, 0.0, axisColor);
plot(tout, H2(:), 'Color', color, 'LineWidth', DC.LW);% axis tight;

subplot(lc{:}, 9); axis([tout(1) tout(end) min(H3(:)) max(H3(:))]); hold on; xlabel('t'); ylabel('H_3');
%daxes(almost_pi_sing_time, 0.0, axisColor);
daxes(min_dist_2_earth_time, 0.0, axisColor);
plot(tout, H3(:), 'Color', color, 'LineWidth', DC.LW);% axis tight;

% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------
%  SOLUTION WITH GRAVITY ASSIST AND STATE CONSTRAINT
% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------
% Get Bocop and HamPath solutions
%
defPbBocop  = ['./bocop/'];                                                 % Directory where main bocop pb directory is: ./bocop/def_pb_temps_min/

options             = [];
options.disc_steps  = '1000';
options.disc_method = 'gauss';

solFileLoad = ['./min_tf_Tmax_50_m0_10000_ast_1_sol_gravity_assist_dist_min_2_earth_' num22str(min_dist_2_earth_non_zero,2) '.sol']; % Path from the main bocop pb directory
if(exist([defPbBocop '/def_pb_temps_min/' solFileLoad],'file')~=2)
    solFileLoad = ['./min_tf_Tmax_50_m0_10000_ast_1_sol_gravity_assist_dist_min_2_earth_0p08.sol'];   % Path from the main bocop pb directory
end;
solFileSave = ['./min_tf_current.sol'];

init.type   = 'from_sol_file_warm';
init.file   = solFileLoad;
init.X0     = [];

if(results.exec_bocop_sol_gravity_assist_dist_2_earth==-1)

    [toutB,stageB,zB,uB,optimvarsB,outputB] = exec_bocop_min_tf(defPbBocop, init, par_bocop_dist_2_earth, options, solFileSave);
    outputB

    if(outputB.status ~= 0)
        error('Bocop did not converge for the minimal time problem!');
    end;

    results.exec_bocop_sol_gravity_assist_dist_2_earth               = 1;
    results.result_bocop_sol_gravity_assist_dist_2_earth.toutB       = toutB;
    results.result_bocop_sol_gravity_assist_dist_2_earth.stageB      = stageB;
    results.result_bocop_sol_gravity_assist_dist_2_earth.zB          = zB;
    results.result_bocop_sol_gravity_assist_dist_2_earth.uB          = uB;
    results.result_bocop_sol_gravity_assist_dist_2_earth.optimvarsB  = optimvarsB;
    results.result_bocop_sol_gravity_assist_dist_2_earth.outputB     = outputB;
    save(file_results, 'results');

end;

%return

% HamPath
n               = 6;
tf_guess        = results.result_bocop_sol_gravity_assist_dist_2_earth.outputB.objective;
p0              = results.result_bocop_sol_gravity_assist_dist_2_earth.zB(n+1:2*n,1);
y0              = [p0; tf_guess];

% t1, z1 ?
const_dist_2_earth_all  = getconstdistearth( results.result_bocop_sol_gravity_assist_dist_2_earth.toutB*tf_guess,   ...
                                        results.result_bocop_sol_gravity_assist_dist_2_earth.zB,                    ...
                                        par_hampath_dist_2_earth);
const_dist_2_earth      = const_dist_2_earth_all(1,:);

[vv,ii]         = min(abs(const_dist_2_earth));
t1_guess        = results.result_bocop_sol_gravity_assist_dist_2_earth.toutB(ii+1)*tf_guess;

pB              = results.result_bocop_sol_gravity_assist_dist_2_earth.zB(n+1:2*n,:);
diff_p          = pB(:,2:end)-pB(:,1:end-1);
norm_diff_p     = sqrt(diff_p(1,:).^2+diff_p(2,:).^2+diff_p(3,:).^2);
norm_c          = sqrt(const_dist_2_earth_all(3,:).^2+const_dist_2_earth_all(4,:).^2+const_dist_2_earth_all(5,:).^2);
nu1_guess       = -max(norm_diff_p./norm_c(1:end-1));
z1_guess        = results.result_bocop_sol_gravity_assist_dist_2_earth.zB(:,ii+1);
y0              = [y0; t1_guess; nu1_guess; z1_guess];

options_shoot   = hampathset('TolOdeAbs',1e-12,'TolOdeRel',1e-12,'ode','dop853','TolX',1e-12,'MaxFEval',200);

if(results.exec_hampath_sol_gravity_assist_dist_2_earth==-1)

    [ysol,ssol,nfev,njev,flag] = ssolve(y0, options_shoot, par_hampath_dist_2_earth);

    if(flag~=1)
        error('ssolve did not converge for the minimal time problem!');
    end;

    results.exec_hampath_sol_gravity_assist_dist_2_earth         = 1;
    results.result_hampath_sol_gravity_assist_dist_2_earth.ysol  = ysol;
    results.result_hampath_sol_gravity_assist_dist_2_earth.ssol  = ssol;
    results.result_hampath_sol_gravity_assist_dist_2_earth.nfev  = nfev;
    results.result_hampath_sol_gravity_assist_dist_2_earth.njev  = njev;
    results.result_hampath_sol_gravity_assist_dist_2_earth.flag  = flag;
    save(file_results, 'results');

end;


% ----------------------------------------------------------------------------------------------------
% Affichage de la solution
ysol = results.result_hampath_sol_gravity_assist_dist_2_earth.ysol;
[tout, z, u, Hs, const_dist_2_earth_all] = getSol_min_dist_2_earth(n, q0, 0.0, ysol, par_hampath_dist_2_earth);
H1 = Hs(2,:);
H2 = Hs(3,:);
H3 = Hs(4,:);
const_dist_2_earth = const_dist_2_earth_all(1,:);

% ----------------------------------------------------------------------------------------------------
% distance to Earth
dist_2_earth            = sqrt(min_dist_2_earth_non_zero^2-const_dist_2_earth);
[vv,ii]                 = min(dist_2_earth);
min_dist_2_earth_time   = tout(ii);

%
ii1 = find(H1(1:end-1).*H1(2:end)<0);
ii2 = find(H2(1:end-1).*H2(2:end)<0);
ii3 = find(H3(1:end-1).*H3(2:end)<0);

Phi = sqrt(H1.^2+H2.^2+H3.^3);
[vv,ii] = min(Phi);
almost_pi_sing_time     = tout(ii);
almost_pi_sing_position = z(:,ii);

% ----------------------------------------------------------------------------------------------------
% First figure: trajectory
hFig_GA_Traj    = figure;
lc      = {1,1};
color   = DC.vert;

subplot(lc{:}, 1); plot3(z(1,:), z(2,:), z(3,:), 'Color', color, 'LineWidth', DC.LW); hold on; view(0,90); axis image; xlabel('x'); ylabel('y'); zlabel('z');
display_Earth();
display_Moon();
display_Position(almost_pi_sing_position, color);
title(['Trajectory in rotating frame: solution with gravity assist and safety distance = ' num2str(min_dist_2_earth_non_zero) ' LD to Earth']);
%axis([-0.2 UC.xL2 -0.05 0.35]); daxes(UC.xL2, 0.0, axisColor);
axis([-1.5 UC.xL2 -0.2 1.6]); daxes(UC.xL2, 0.0, axisColor);

% ----------------------------------------------------------------------------------------------------
% Figure : state-costate wrt time
hFig_GA_position    = figure;
lc                  = {3,2};

subplot(lc{:}, 1); z_cur = z(1,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('r_1');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 3); z_cur = z(2,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('r_2');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 5); z_cur = z(3,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('r_3');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 2); z_cur = z(n+1,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('p_1');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 4); z_cur = z(n+2,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('p_2');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 6); z_cur = z(n+3,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('p_3');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

% ----------------------------------------------------------------------------------------------------
% Figure : state-costate wrt time
hFig_GA_velocity    = figure;
lc                  = {3,2};

subplot(lc{:}, 1); z_cur = z(3,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('v_1');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 3); z_cur = z(4,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('v_2');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 5); z_cur = z(5,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('v_3');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 2); z_cur = z(n+4,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('p_4');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 4); z_cur = z(n+5,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('p_5');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 6); z_cur = z(n+6,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('p_6');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

% ----------------------------------------------------------------------------------------------------
% Last figure: trajectory, control, distance to earth and moon ant Hamiltonian lifts
hFig_GA_All    = figure;
lc      = {3,3};

% trajectory
subplot(lc{:}, 1); plot3(z(1,:), z(2,:), z(3,:), 'Color', color, 'LineWidth', DC.LW); hold on; view(0,90); axis image; xlabel('x'); ylabel('y'); zlabel('z');
display_Earth();
display_Moon();
display_Position(almost_pi_sing_position, color);
title('Trajectory in rotating frame');

% distance to earth
subplot(lc{:}, 4); plot(tout, dist_2_earth, 'Color', color, 'LineWidth', DC.LW); hold on;
xlabel('t');
ylabel('distance');
title('distance to Earth');
axis tight;

ylim([0.0 max(dist_2_earth)]);
daxes(min_dist_2_earth_time, min_dist_2_earth_non_zero, axisColor);

% distance to moon
moon_position  = [1.0-muCR3BP; 0.0; 0.0];
dist_2_moon    = sqrt((z(1,:)-moon_position(1)).^2+(z(2,:)-moon_position(2)).^2+(z(3,:)-moon_position(3)).^2);
subplot(lc{:}, 7); plot(tout, dist_2_moon, 'Color', color, 'LineWidth', DC.LW); hold on;
xlabel('t');
ylabel('distance');
title('distance to Moon');
axis tight;

[vv,ii] = min(dist_2_moon);
min_dist_2_moon_time = tout(ii);

ylim([0.0 max(dist_2_moon)]);
daxes(min_dist_2_moon_time, 0.0, axisColor);

% control
subplot(lc{:}, 2); axis([tout(1) tout(end) min(u(1,:)) max(u(1,:))]); hold on; xlabel('t'); ylabel('u_1');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, u(1,:), 'Color', color, 'LineWidth', DC.LW);% axis tight;

subplot(lc{:}, 5); axis([tout(1) tout(end) min(u(2,:)) max(u(2,:))]); hold on; xlabel('t'); ylabel('u_2');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, u(2,:), 'Color', color, 'LineWidth', DC.LW);% axis tight;

subplot(lc{:}, 8); axis([tout(1) tout(end) min(u(3,:)) max(u(3,:))]); hold on; xlabel('t'); ylabel('u_3');
daxes(min_dist_2_earth_time, 0.0, axisColor); plot(tout, u(3,:), 'Color', color, 'LineWidth', DC.LW);% axis tight;

% hamiltonian lifts
% find where Phi = ||(H1, H2, H3)|| touches 0
% H1 = Hs(2,:)
% H2 = Hs(3,:)
% H3 = Hs(4,:)
subplot(lc{:}, 3); axis([tout(1) tout(end) min(H1(:)) max(H1(:))]); hold on; xlabel('t'); ylabel('H_1');
%daxes(almost_pi_sing_time, 0.0, axisColor);
daxes(min_dist_2_earth_time, 0.0, axisColor);
plot(tout, H1(:), 'Color', color, 'LineWidth', DC.LW);% axis tight;

subplot(lc{:}, 6); axis([tout(1) tout(end) min(H2(:)) max(H2(:))]); hold on; xlabel('t'); ylabel('H_2');
%daxes(almost_pi_sing_time, 0.0, axisColor);
daxes(min_dist_2_earth_time, 0.0, axisColor);
plot(tout, H2(:), 'Color', color, 'LineWidth', DC.LW);% axis tight;

subplot(lc{:}, 9); axis([tout(1) tout(end) min(H3(:)) max(H3(:))]); hold on; xlabel('t'); ylabel('H_3');
%daxes(almost_pi_sing_time, 0.0, axisColor);
daxes(min_dist_2_earth_time, 0.0, axisColor);
plot(tout, H3(:), 'Color', color, 'LineWidth', DC.LW);% axis tight;

% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------
%  SIMPLE SOLUTION
% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------
% Get Bocop and HamPath solutions
%
defPbBocop  = ['./bocop/'];                                         % Directory where main bocop pb directory is: ./bocop/def_pb_temps_min/

options             = [];
options.disc_steps  = '200';
options.disc_method = 'gauss';

solFileLoad = ['./min_tf_Tmax_50_m0_10000_ast_1_sol_simple_dist_min_2_earth_0p0.sol'];   % Path from the main bocop pb directory
solFileSave = ['./min_tf_current.sol'];

init.type   = 'from_sol_file_warm';
init.file   = solFileLoad;
init.X0     = [];

if(results.exec_bocop_sol_simple==-1)

    [toutB,stageB,zB,uB,optimvarsB,outputB] = exec_bocop_min_tf(defPbBocop, init, par_bocop, options, solFileSave);
    outputB

    if(outputB.status ~= 0)
        error('Bocop did not converge for the minimal time problem!');
    end;

    results.exec_bocop_sol_simple               = 1;
    results.result_bocop_sol_simple.toutB       = toutB;
    results.result_bocop_sol_simple.stageB      = stageB;
    results.result_bocop_sol_simple.zB          = zB;
    results.result_bocop_sol_simple.uB          = uB;
    results.result_bocop_sol_simple.optimvarsB  = optimvarsB;
    results.result_bocop_sol_simple.outputB     = outputB;
    save(file_results, 'results');

end;

% HamPath
n               = 6;
tf_guess        = results.result_bocop_sol_simple.outputB.objective;
p0              = results.result_bocop_sol_simple.zB(n+1:2*n,1);
y0              = [p0; tf_guess];
options_shoot   = hampathset('TolOdeAbs',1e-12,'TolOdeRel',1e-12,'ode','dop853','TolX',1e-12,'MaxFEval',200);

if(results.exec_hampath_sol_simple==-1)

    [ysol,ssol,nfev,njev,flag] = ssolve(y0, options_shoot, par_hampath);

    if(flag~=1)
        error('ssolve did not converge for the minimal time problem!');
    end;

    results.exec_hampath_sol_simple         = 1;
    results.result_hampath_sol_simple.ysol  = ysol;
    results.result_hampath_sol_simple.ssol  = ssol;
    results.result_hampath_sol_simple.nfev  = nfev;
    results.result_hampath_sol_simple.njev  = njev;
    results.result_hampath_sol_simple.flag  = flag;
    save(file_results, 'results');

end;

% ----------------------------------------------------------------------------------------------------
% Affichage de la solution
p0               = results.result_hampath_sol_simple.ysol(1:n);
tf               = results.result_hampath_sol_simple.ysol(n+1);
tspan            = [0.0 tf];
z0               = [q0; p0];
options_exphv    = hampathset('TolOdeAbs',1e-12,'TolOdeRel',1e-12,'ode','dopri5');
[tout, z, flag ] = exphvfun(tspan, z0, options_exphv, par_hampath);
u                = control(tout, z, par_hampath);
Hs               = relevement(tout, z, par_hampath);
H1 = Hs(2,:);
H2 = Hs(3,:);
H3 = Hs(4,:);

ii1 = find(H1(1:end-1).*H1(2:end)<0);
ii2 = find(H2(1:end-1).*H2(2:end)<0);
ii3 = find(H3(1:end-1).*H3(2:end)<0);

Phi = sqrt(H1.^2+H2.^2+H3.^3);
[vv,ii] = min(Phi);
almost_pi_sing_time     = tout(ii);
almost_pi_sing_position = z(:,ii);

% calcul du \int ||u||
options_ode45                   = odeset('AbsTol',1e-12,'RelTol',1e-12);
[tout_aux, zout_aux, zi_aux, costi_aux, nu_total ]  = expcost_conso_min(z0, tspan, options_ode45, par_hampath);

% delta_V
conso           = beta*Tmax*nu_total
ndelta_V_soL3   = (Tmax*nu_total/m0)*UC.LD/UC.time_syst %en km/s

% ----------------------------------------------------------------------------------------------------
% First figure: trajectory
hFig_Simple_Traj = figure;
lc      = {1,1};
color   = DC.bleu;

subplot(lc{:}, 1); plot3(z(1,:), z(2,:), z(3,:), 'Color', color, 'LineWidth', DC.LW); hold on; view(0,90); axis image; xlabel('x'); ylabel('y'); zlabel('z');
display_Earth();
display_Moon();
display_Position(almost_pi_sing_position, color);
title('Trajectory in rotating frame: simple solution');
%axis([-0.2 UC.xL2 -0.05 0.35]);
daxes(UC.xL2, 0.0, axisColor);

% ----------------------------------------------------------------------------------------------------
% Figure : state-costate wrt time
hFig_Simple_position    = figure;
lc                  = {3,2};

subplot(lc{:}, 1); z_cur = z(1,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('r_1');
plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 3); z_cur = z(2,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('r_2');
plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 5); z_cur = z(3,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('r_3');
plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 2); z_cur = z(n+1,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('p_1');
plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 4); z_cur = z(n+2,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('p_2');
plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 6); z_cur = z(n+3,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('p_3');
plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

% ----------------------------------------------------------------------------------------------------
% Figure : state-costate wrt time
hFig_Simple_velocity    = figure;
lc                  = {3,2};

subplot(lc{:}, 1); z_cur = z(3,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('v_1');
plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 3); z_cur = z(4,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('v_2');
plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 5); z_cur = z(5,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('v_3');
plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 2); z_cur = z(n+4,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('p_4');
plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 4); z_cur = z(n+5,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('p_5');
plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

subplot(lc{:}, 6); z_cur = z(n+6,:);
axis([tout(1) tout(end) min(z_cur) max(z_cur)]); hold on; xlabel('t'); ylabel('p_6');
plot(tout, z_cur, 'Color', color, 'LineWidth', DC.LW);

% ----------------------------------------------------------------------------------------------------
% Last figure: trajectory, control, distance to earth and moon ant Hamiltonian lifts
hFig_Simple_All    = figure;
lc      = {3,3};

% trajectory
subplot(lc{:}, 1); plot3(z(1,:), z(2,:), z(3,:), 'Color', color, 'LineWidth', DC.LW); hold on; view(0,90); axis image; xlabel('x'); ylabel('y'); zlabel('z');
display_Earth();
display_Moon();
display_Position(almost_pi_sing_position, color);
title('Trajectory in rotating frame');

% distance to earth
earth_position  = [muCR3BP; 0.0; 0.0];
dist_2_earth    = sqrt((z(1,:)-earth_position(1)).^2+(z(2,:)-earth_position(2)).^2+(z(3,:)-earth_position(3)).^2);
subplot(lc{:}, 4); plot(tout, dist_2_earth, 'Color', color, 'LineWidth', DC.LW); hold on;
xlabel('t');
ylabel('distance');
title('distance to Earth');
axis tight;

[vv,ii] = min(dist_2_earth);
min_dist_2_earth_time = tout(ii);
daxes(min_dist_2_earth_time, min_dist_2_earth, axisColor);

% distance to moon
moon_position  = [1.0-muCR3BP; 0.0; 0.0];
dist_2_moon    = sqrt((z(1,:)-moon_position(1)).^2+(z(2,:)-moon_position(2)).^2+(z(3,:)-moon_position(3)).^2);
subplot(lc{:}, 7); plot(tout, dist_2_moon, 'Color', color, 'LineWidth', DC.LW); hold on;
xlabel('t');
ylabel('distance');
title('distance to Moon');
axis tight;

[vv,ii] = min(dist_2_moon);
min_dist_2_moon_time = tout(ii);
%daxes(min_dist_2_moon_time, 0.0, axisColor);

% control
subplot(lc{:}, 2); axis([tout(1) tout(end) min(u(1,:)) max(u(1,:))]); hold on; xlabel('t'); ylabel('u_1');
%daxes(min_dist_2_earth_time, 0.0, axisColor);
plot(tout, u(1,:), 'Color', color, 'LineWidth', DC.LW);% axis tight;
daxes(0.0, 0.0, axisColor);

subplot(lc{:}, 5); axis([tout(1) tout(end) min(u(2,:)) max(u(2,:))]); hold on; xlabel('t'); ylabel('u_2');
%daxes(min_dist_2_earth_time, 0.0, axisColor);
plot(tout, u(2,:), 'Color', color, 'LineWidth', DC.LW);% axis tight;
daxes(0.0, 0.0, axisColor);

subplot(lc{:}, 8); axis([tout(1) tout(end) min(u(3,:)) max(u(3,:))]); hold on; xlabel('t'); ylabel('u_3');
%daxes(min_dist_2_earth_time, 0.0, axisColor);
plot(tout, u(3,:), 'Color', color, 'LineWidth', DC.LW);% axis tight;
daxes(0.0, 0.0, axisColor);

% hamiltonian lifts
% find where Phi = ||(H1, H2, H3)|| touches 0
% H1 = Hs(2,:)
% H2 = Hs(3,:)
% H3 = Hs(4,:)
subplot(lc{:}, 3); axis([tout(1) tout(end) min(H1(:)) max(H1(:))]); hold on; xlabel('t'); ylabel('H_1');
%daxes(almost_pi_sing_time, 0.0, axisColor);
%daxes(min_dist_2_earth_time, 0.0, axisColor);
plot(tout, H1(:), 'Color', color, 'LineWidth', DC.LW);% axis tight;
daxes(0.0, 0.0, axisColor);

subplot(lc{:}, 6); axis([tout(1) tout(end) min(H2(:)) max(H2(:))]); hold on; xlabel('t'); ylabel('H_2');
%daxes(almost_pi_sing_time, 0.0, axisColor);
%daxes(min_dist_2_earth_time, 0.0, axisColor);
plot(tout, H2(:), 'Color', color, 'LineWidth', DC.LW);% axis tight;
daxes(0.0, 0.0, axisColor);

subplot(lc{:}, 9); axis([tout(1) tout(end) min(H3(:)) max(H3(:))]); hold on; xlabel('t'); ylabel('H_3');
%daxes(almost_pi_sing_time, 0.0, axisColor);
%daxes(min_dist_2_earth_time, 0.0, axisColor);
plot(tout, H3(:), 'Color', color, 'LineWidth', DC.LW);% axis tight;
daxes(0.0, 0.0, axisColor);
