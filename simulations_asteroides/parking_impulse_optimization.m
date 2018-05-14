function parking_impulse_optimization(numAsteroid, tour_init, Sansmax)
% Impulsionnel sur la PHASE PARKING
% min \Delta V = \sum_{i=1}^{nbImpulse} \delta V_i  # Objective
% s.c. \cdot{x} (t) = f(t, x(t))                    # Dynamics
%       x(t_0) = x_{Hill} ; x(t_f) = x_{L2}         # Initial & Final Conditions
%
% Dynamics description : CR3BP


disp('-------------------------------------------------');
fprintf('\nnumAsteroid = %d \n', numAsteroid);
fprintf('tour_init = %d \n\n', tour_init);

%
format shortE;
addpath('tools/');

%
if Sansmax
    repOutput = ['results/parking_impulse_Sansmax/'];
else
    repOutput = ['results/parking_impulse/'];
end

if(~exist(repOutput,'dir')); error('Wrong result directory name!'); end


% ----------------------------------------------------------------------------------------------------
% Load the 4258 asteroid's orbital parameters
% Are there in the Heliocentric referentiel ?
%
load('bdd/bdd_asteroids_oribtal_params');
[~, n_ast]=size(asteroids_orbital_params);

%
UC          = get_Univers_Constants(); % Univers constants

% Asteroid number
%numAsteroid         = 14;

% Get asteroid's orbital elements at epoch_t0
xOrb_epoch_t0_Ast   = get_Ast_init_Orbital_elements(asteroids_orbital_params, numAsteroid);
period_Ast          = 2*pi*sqrt(xOrb_epoch_t0_Ast(1)^3/UC.mu0SunAU);

% Options for the solver
optionsFmincon      = optimoptions('fmincon','display','iter','Algorithm','interior-point', ...
                                   'ConstraintTolerance', 1e-3, 'OptimalityTolerance', 1e-3, 'StepTolerance', 1e-12, 'FunctionTolerance', 1e-12, ...
                                   'MaxFunEvals', 10000, 'MaxIter', 300);
% facteur d'echelle
dVmax   = 2.e-3;
ratio   = period_Ast/dVmax;
scaling = 1e5;

% Lower and upper bounds
t0_min  = 365.25/2;
t0_max  = 19*365.25; % 19 years
d_t0    = [t0_min;t0_max];
d_dt1   = [1;period_Ast];
d_dt2   = [1;period_Ast];
LB      = [d_t0(1); d_dt1(1); d_dt2(1); -ratio*dVmax*ones(6,1)];
UB      = [d_t0(2); d_dt1(2); d_dt2(2);  ratio*dVmax*ones(6,1)];

% Initial Guess
t0_r        = tour_init*365.25;
dt1_r       = 100;
dtf_r       = 100;
delta_V0_r  = 1e-5*[1 1 1]';
delta_V1_r  = 1e-5*[1 1 1]';
X0          = [t0_r; dt1_r; dtf_r; ratio*delta_V0_r; ratio*delta_V1_r];

poids   = 0.0;
end
