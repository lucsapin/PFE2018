function return_impulse_optimization(numAsteroid, tour_init, destination, Sansmax)
% Script to optimize the return 3 impulse manoeuver: from asteroid to EMB
%
% numAsteroid: the numero of the asteroid for which we perform the optimization
% tour_init: the initial guess for t0 is given by t0_guess = tour_init*365.25
%
disp('-------------------------------------------------');
fprintf('\nnumAsteroid = %d \n', numAsteroid);
fprintf('tour_init = %d \n\n', tour_init);

%
format shortE;
addpath('tools/');

%
if Sansmax
  repOutput = ['results/return_impulse_' destination '/without_g_assist/'];
else
  repOutput = ['results/return_impulse_' destination '/gravity_assist/'];
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

% Initial guess
existFile   = 0;
i           = numAsteroid-1;
j           = numAsteroid+1;
while((i>0) && (j<=n_ast) && (existFile==0))
    filei = [repOutput 'asteroid_no_' int2str(i)];
    filej = [repOutput 'asteroid_no_' int2str(j)];
    if(exist([filei '.mat'],'file')==2)
        existFile = 1;
        k   = i;
    elseif(exist([filej '.mat'],'file')==2)
        existFile = 1;
        k   = j;
    end
    i = i - 1;
    j = j + 1;
end

% if (existFile==1 && 0)
%     % utiliser une solution de l’astéroïde k pour initialiser le k+1
%     % k_init      = k;
%     load([repOutput 'asteroid_no_' int2str(k) '.mat']);
%     oo          = allResults{1};
%     X0          = oo.Xsol;
%     ratio_old   = oo.ratio;
%     X0          = [X0(1); X0(2); X0(3); ratio*X0(4:end)/ratio_old];
% else

t0_r        = tour_init*365.25;
dt1_r       = 100;
dtf_r       = 100;
delta_V0_r  = 1e-5*[1 1 1]';
delta_V1_r  = 1e-5*[1 1 1]';
X0          = [t0_r; dt1_r; dtf_r; ratio*delta_V0_r; ratio*delta_V1_r];
% end

% Lower and upper bounds
t0_min  = 365.25/2;
t0_max  = 19*365.25; % 19 years
d_t0    = [t0_min;t0_max];
d_dt1   = [1;period_Ast];
d_dt2   = [1;period_Ast];
LB      = [d_t0(1); d_dt1(1); d_dt2(1); -ratio*dVmax*ones(6,1)];
UB      = [d_t0(2); d_dt1(2); d_dt2(2);  ratio*dVmax*ones(6,1)];

% Non linear Constraints
nonlc               = @(X) return_impulse_nonlcon  (X, xOrb_epoch_t0_Ast, ratio, destination);

% Criterion
F0                  = @(X) return_impulse_criterion(X, xOrb_epoch_t0_Ast, ratio, destination, Sansmax);

% Solver
[Xsol,Fsol,exitflag,output,~,~,~] = fmincon(F0,X0,[],[],[],[],LB,UB,nonlc,optionsFmincon);

if(exitflag==0)
    [Xsol,Fsol,exitflag,output,~,~,~] = fmincon(F0,Xsol,[],[],[],[],LB,UB,nonlc,optionsFmincon);
end

fprintf('exitflag = %d \n', exitflag);
fprintf('output = \n'); disp(output);
fprintf('Xsol = \n'); disp(Xsol);

if(exitflag == 1)

    [cin, ceq, delta_Vf_r]  = return_impulse_nonlcon(Xsol, xOrb_epoch_t0_Ast, ratio, destination);


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
    outputOptimization.dVf          = delta_Vf_r;
    outputOptimization.cin          = cin;
    outputOptimization.ceq          = ceq;
    outputOptimization.Fsol         = Fsol;
    outputOptimization.exitflag     = exitflag;
    outputOptimization.output       = output;

    t0  = outputOptimization.t0;
    dt1 = outputOptimization.dt1;
    dtf = outputOptimization.dtf;
    dV0 = outputOptimization.dV0;
    dV1 = outputOptimization.dV1;
    dVf = outputOptimization.dVf;
    Fsol= outputOptimization.Fsol;

    fprintf('Fsol = %f \n', Fsol)
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
            %On trie en fonction du Fsol
            i    = 1;
            fini = 0;
            while ((fini==0) && (i<=n))
                oo  = allResults{i}; i=i+1;
                if(oo.Fsol>=outputOptimization.Fsol)
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
