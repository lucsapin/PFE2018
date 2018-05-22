function parking_impulse_optimization(numAsteroid, tour_init, Sansmax)
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
if Sansmax
    repOutput = ['results/parking_impulse_Sansmax/'];
else
    repOutput = ['results/parking_impulse/'];
end

if(~exist(repOutput,'dir')); error('Wrong result directory name!'); end


% ----------------------------------------------------------------------------------------------------
% Load the 4258 asteroid's orbital parameters
%
load('bdd/bdd_asteroids_oribtal_params');

UC          = get_Univers_Constants(); % Univers constants

% Get asteroid's orbital elements at epoch_t0
xOrb_epoch_t0_Ast   = get_Ast_init_Orbital_elements(asteroids_orbital_params, numAsteroid);
period_Ast          = 2*pi*sqrt(xOrb_epoch_t0_Ast(1)^3/UC.mu0SunAU);

% Get initial conditions at Hill's sphere
outputOpti = loadFile('L2', 'total', numAsteroid, tour_init, Sansmax);

UC = get_Univers_Constants();

% Get initial condition for time and state
[~, ~, time_Hill, state_Hill, ~, ~, ~, ~, ~] = propagate2Hill(outputOpti, 0.01);
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
scaling = 1e5;

% Lower and upper bounds
d_dt1   = [1;period_Ast];
d_dt2   = [1;period_Ast];
LB      = [d_dt1(1); d_dt2(1); -ratio*dVmax*ones(6,1)];
UB      = [d_dt1(2); d_dt2(2);  ratio*dVmax*ones(6,1)];

% Initial Guess
dt1_r       = 100;
dtf_r       = 100;
delta_V0_r  = 1e-5*[1; 1; 1];
delta_V1_r  = 1e-5*[1; 1; 1];
X0          = [dt1_r; dtf_r; ratio*delta_V0_r; ratio*delta_V1_r];

poids   = 0.0;

nonlc               = @(X) parking_impulse_nonlcon  (X, xOrb_epoch_t0_Ast, q0_SUN_AU, t0_p, ratio);

% Criterion
F0                  = @(X) parking_impulse_criterion(X, xOrb_epoch_t0_Ast, q0_SUN_AU, t0_p, ratio, poids, scaling, 'L2', Sansmax);

% Solver
[Xsol, Fsol, exitflag, output, ~, ~, ~] = fmincon(F0, X0, [], [], [], [], LB, UB, nonlc, optionsFmincon);

if(exitflag==0)
    [Xsol, Fsol, exitflag, output, ~, ~, ~] = fmincon(F0, Xsol, [], [], [], [], LB, UB, nonlc, optionsFmincon);
end

fprintf('exitflag = %d \n', exitflag);
fprintf('output = \n'); disp(output);
fprintf('Xsol = \n'); disp(Xsol);

if(exitflag == 1)

    [cin, ceq, delta_Vf_p]  = parking_impulse_nonlcon(Xsol, xOrb_epoch_t0_Ast, q0_SUN_AU, t0_p, ratio);

    [~, delta_V          ]  = parking_impulse_criterion(Xsol, xOrb_epoch_t0_Ast, q0_SUN_AU, t0_p, ratio, poids, scaling, 'L2', Sansmax);

    % We construct the output to save
    outputOptimization.xOrb_epoch_t0_Ast = xOrb_epoch_t0_Ast;
    outputOptimization.numAsteroid  = numAsteroid;
    outputOptimization.poids        = poids;
    outputOptimization.scaling      = scaling;
    outputOptimization.dVmax        = dVmax;
    outputOptimization.ratio        = ratio;
    outputOptimization.LB           = LB;
    outputOptimization.UB           = UB;
    outputOptimization.X0           = X0;
    outputOptimization.Xsol         = Xsol;
    outputOptimization.dt1          = Xsol(1);
    outputOptimization.dtf          = Xsol(2);
    outputOptimization.dV0          = Xsol(3:5)/ratio;
    outputOptimization.dV1          = Xsol(6:8)/ratio;
    outputOptimization.dVf          = delta_Vf_p;
    outputOptimization.cin          = cin;
    outputOptimization.ceq          = ceq;
    outputOptimization.Fsol         = Fsol;
    outputOptimization.exitflag     = exitflag;
    outputOptimization.output       = output;
    outputOptimization.delta_V      = delta_V;

    dt1 = outputOptimization.dt1;
    dtf = outputOptimization.dtf;
    dV0 = outputOptimization.dV0;
    dV1 = outputOptimization.dV1;
    dVf = outputOptimization.dVf;
    Fsol= outputOptimization.Fsol;

    fprintf('delta_V = %f \n', delta_V)
    duration    = dt1 + dtf; fprintf('duration = %f \n', duration);
    return_time = t0_p + dt1 + dtf; fprintf('return_time = %f \n\n', return_time);
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
            %On trie en fonction du delta_V
            i    = 1;
            fini = 0;
            while ((fini==0) && (i<=n))
                oo  = allResults{i}; i=i+1;
                if(oo.delta_V>=outputOptimization.delta_V)
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

end
