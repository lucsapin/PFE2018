function parking_impulse_optimization(numAsteroid, numOptiReturn)
% Impulsionnel sur la PHASE PARKING
% min \Delta V = \sum_{i=1}^{nbImpulse} \delta V_i  # Objective
% s.c. \cdot{x} (t) = f(t, x(t))                    # Dynamics
%       x(t_0) = x_{Hill} ; x(t_f) = x_{L2}         # Initial & Final Conditions
%
% Dynamics description : CR3BP

%
format shortE;
addpath('tools/');

%
repOutput = ['results/parking_impulse_L2/'];
repOutputReturn  = ['results/return_impulse_L2/'];

if (~exist(repOutput,'dir'))
  error('Wrong result directory name!');
end
if (~exist(repOutputReturn,'dir'))
  error('Wrong result directory name!');
end

file2loadReturn = [repOutputReturn 'asteroid_no_' int2str(numAsteroid)];

if (exist([file2loadReturn '.mat'],'file')~=2)
    error(['there is no return optimization done for asteroid number ' int2str(numAsteroid)]);
end

% We get the data of the numero numOptiReturn of the return optimizations for asteroid numAsteroid
load(file2loadReturn);
allResultsReturn = allResults;
clear allResults;
nbOpti      = length(allResultsReturn); fprintf('nbOpti = %d \n', nbOpti);
if (0<numOptiReturn && numOptiReturn<=nbOpti)
    outputOptiReturn  = allResultsReturn{numOptiReturn};
else
    error('numOptiReturn is invalid!');
end
% ----------------------------------------------------------------------------------------------------
% Load the 4258 asteroid's orbital parameters
%
load('bdd/bdd_asteroids_oribtal_params');

UC          = get_Univers_Constants(); % Univers constants

% Get asteroid's orbital elements at epoch_t0
xOrb_epoch_t0_Ast   = get_Ast_init_Orbital_elements(asteroids_orbital_params, numAsteroid);
period_Ast          = 2*pi*sqrt(xOrb_epoch_t0_Ast(1)^3/UC.mu0SunAU);

% % Get initial conditions at Hill's sphere
% outputOpti = loadFile('L2', 'total', numAsteroid, tour_init, Sansmax);

% Get initial condition for time and state
[~, ~, time_Hill, state_Hill, ~, ~, ~, ~, ~] = propagate2Hill(outputOptiReturn, 0.01);
% The solution is given in HELIO frame
t0_p        = time_Hill;                % the initial time in Day
q0_SUN_AU   = state_Hill(1:6);          % q0 in HELIO frame in AU unit


% Options for the solver
optionsFmincon      = optimoptions('fmincon','display','iter','Algorithm','interior-point', ...
                                   'ConstraintTolerance', 1e-3, 'OptimalityTolerance', 1e-3, 'StepTolerance', 1e-12, 'FunctionTolerance', 1e-12, ...
                                   'MaxFunEvals', 10000, 'MaxIter', 300);

% facteur d'echelle
dVmax   = 2.e-3;
ratio   = period_Ast/dVmax;

% Lower and upper bounds
LB = [];
UB = [];

% Initial Guess
tf_r      = outputOptiReturn.t0 + outputOptiReturn.dt1 + outputOptiReturn.dtf;
diff_time = tf_r - t0_p;
tf_p      = diff_time;
t1_p      = (tf_p-t0_p)/2; % au hasard

dt1_p = t1_p; %%% Convertir Temps système pour l'intégration
dtf_p = tf_p - t1_p; %%% Convertir Temps système pour l'intégration
delta_V0_p  = 1e-5*[1; 1; 1];
delta_V1_p  = 1e-5*[1; 1; 1];
delta_Vf_p  = outputOptiReturn.dVf;
X0          = [dt1_p;
               dtf_p;
               ratio*delta_V0_p;
               ratio*delta_V1_p;
               ratio*delta_Vf_p];

% Constraints
nonlc               = @(X) parking_impulse_nonlcon(X, xOrb_epoch_t0_Ast, q0_SUN_AU, t0_p, ratio);

% Criterion
F0                  = @(X) parking_impulse_criterion(X, xOrb_epoch_t0_Ast, ratio);

% Solver
[Xsol, Fsol, exitflag, output, ~, ~, ~] = fmincon(F0, X0, [], [], [], [], LB, UB, nonlc, optionsFmincon);

if(exitflag==0)
    [Xsol, Fsol, exitflag, output, ~, ~, ~] = fmincon(F0, Xsol, [], [], [], [], LB, UB, nonlc, optionsFmincon);
end

fprintf('exitflag = %d \n', exitflag);
fprintf('output = \n'); disp(output);
fprintf('Xsol = \n'); disp(Xsol);

if(exitflag == 1)

    [cin, ceq]  = parking_impulse_nonlcon(Xsol, xOrb_epoch_t0_Ast, q0_SUN_AU, t0_p, ratio);

    % We construct the output to save
    outputOptimization.xOrb_epoch_t0_Ast = xOrb_epoch_t0_Ast;
    outputOptimization.numAsteroid  = numAsteroid;
    outputOptimization.dVmax        = dVmax;
    outputOptimization.ratio        = ratio;
    outputOptimization.LB           = LB;
    outputOptimization.UB           = UB;
    outputOptimization.X0           = X0;
    outputOptimization.Xsol         = Xsol;
    outputOptimization.t0           = Xsol(1);
    outputOptimization.dt1          = Xsol(2);
    outputOptimization.dtf          = Xsol(3);
    outputOptimization.dV0          = Xsol(4:6)/ratio;
    outputOptimization.dV1          = Xsol(7:9)/ratio;
    outputOptimization.dVf          = delta_Vf_o;
    outputOptimization.cin          = cin;
    outputOptimization.ceq          = ceq;
    outputOptimization.Fsol         = Fsol;
    outputOptimization.exitflag     = exitflag;
    outputOptimization.output       = output;
    outputOptimization.tfmin        = tfmin;
    outputOptimization.tfmax        = tfmax;
    outputOptimization.optiReturn   = outputOptiReturn;

    t0  = outputOptimization.t0;
    dt1 = outputOptimization.dt1;
    dtf = outputOptimization.dtf;
    dV0 = outputOptimization.dV0;
    dV1 = outputOptimization.dV1;
    dVf = outputOptimization.dVf;
    Fsol= outputOptimization.Fsol;

    fprintf('Fsol = %f \n', Fsol);
    duration    = dt1 + dtf; fprintf('duration = %f \n', duration);
    return_time = t0 + dt1 + dtf; fprintf('return_time = %f \n\n', return_time);
    disp('-------------------------------------------------');

    % file to save
    file2save = [repOutput 'asteroid_no_' int2str(numAsteroid)];
    if(exist([file2save '.mat'],'file')==2)
        load(file2save);
        n       = length(allResults);
        doSave  = 1;
        i       = 1;
        while ((i<=n) && (doSave==1))
            oo  = allResults{i}; i=i+1;
            gap = norm(oo.Xsol-outputOptimization.Xsol);
            if(gap<1e-8)
                doSave = 0;
            end
        end
        if(doSave==1)
            %On trie en fonction du Fsol total ! Aller + retour !
            i    = 1;
            fini = 0;
            while ((fini==0) && (i<=n))
                oo  = allResults{i}; i=i+1;
                if((oo.Fsol+oo.optiReturn.Fsol)>=(outputOptimization.Fsol+outputOptimization.optiReturn.Fsol))
                    fini=1;
                    k   = i-1;
                end
            end
            if(fini==1) % on doit placer au milieu
                allResultsNew           = {};
                for i=1:k-1
                    allResultsNew{i} = allResults{i};
                end
                allResultsNew{k}        = outputOptimization;
                for i=k+1:n+1
                    allResultsNew{i} = allResults{i-1};
                end
                allResults              = {};
                allResults              = allResultsNew;
            else % on doit placer en fin
                allResults{n+1}         = outputOptimization;
            end
            save(file2save,'allResults');
        end
    else
        allResults      = {};
        allResults{1}   = outputOptimization;
        save(file2save,'allResults');
    end

end
