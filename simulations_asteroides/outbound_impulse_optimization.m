% Script to optimize the outbound 3 impulse manoeuver: from EMB to asteroid
%

function outbound_impulse_optimization(numAsteroid, numOptiReturn, destination, Sansmax)

% numAsteroid: the numero of the asteroid for which we perform the optimization
% numOptiReturn: the outbound trip is optimize with the constraint that the spacecraft must
% stay a certain amoun of time on the asteroid before the return. So numOptiReturn is the
% numero of the return optimization for this asteroid
%
% exitflag = 1 if the return Optimization exists, -2 if not.
%
% This value may change if others return optimizations are done after that 
% outbound optimizations are performed
%

disp('-------------------------------------------------');
fprintf('\nnumAsteroid = %d \n', numAsteroid);
fprintf('numOptiReturn = %d \n\n', numOptiReturn);

%
format shortE;
addpath('tools/');

%
if Sansmax
    repOutput = ['results/outbound_impulse_' destination '_Sansmax/'];
    repOutputReturn  = ['results/return_impulse_' destination '_Sansmax/'];
else
    repOutput = ['results/outbound_impulse_' destination '/'];
    repOutputReturn  = ['results/return_impulse_' destination '/'];
end

if(~exist(repOutput,'dir')); error('Wrong result directory name!'); end
if(~exist(repOutputReturn,'dir')); error('Wrong result directory name!'); end

file2loadReturn = [repOutputReturn 'asteroid_no_' int2str(numAsteroid)];
if(exist([file2loadReturn '.mat'],'file')~=2)
    error(['there is no return optimization done for asteroid number ' int2str(numAsteroid)]);
end

% We get the data of the numero numOptiReturn of the return optimizations for asteroid numAsteroid
load(file2loadReturn);
allResultsReturn = allResults;
clear allResults;
nbOpti      = length(allResultsReturn); fprintf('nbOpti = %d \n', nbOpti);
if(0<numOptiReturn && numOptiReturn<=nbOpti)
    outputOptiReturn  = allResultsReturn{numOptiReturn};
else
    error('numOptiReturn is invalid!');
end

% The spacecraft has to wait between 90 and 360 days on the asteroid
t0_r    = outputOptiReturn.t0;
tfmin   = t0_r-360;
tfmax   = t0_r-0;
t0_o_G  = tfmin; % Guess for the initial time

% ----------------------------------------------------------------------------------------------------
% Load the 4258 asteroid's orbital parameters
% Are there in the Heliocentric referentiel ?
%
load('bdd/bdd_asteroids_oribtal_params');
[~,n_ast]=size(asteroids_orbital_params);

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
                                    'MaxFunEvals', 10000, 'MaxIterations', 300);

% facteur d'echelle
dVmax   = 2.e-3;
ratio   = period_Ast/dVmax;
scaling = 1e0;

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
if(existFile==1 && 0)
    % k_init      = k;
    load([repOutput 'asteroid_no_' int2str(k) '.mat']);
    oo          = allResults{1};
    X0          = oo.Xsol;
    ratio_old   = oo.ratio;
    X0          = [X0(1); X0(2); X0(3); ratio*X0(4:end)/ratio_old];
else
    t0          = t0_o_G;
    dt1_o       = 100;
    dtf_o       = 100;
    delta_V0_o  = 1e-5*[1 1 1]';
    delta_V1_o  = 1e-5*[1 1 1]';
    X0          = [t0; dt1_o; dtf_o; ratio*delta_V0_o; ratio*delta_V1_o];
end

% Lower and upper bounds
t0_min  = -1.0 * 365.25;
t0_max  = 18*365.25; % 18 years
d_t0    = [t0_min;t0_max];
d_dt1   = [1;period_Ast];
d_dt2   = [1;period_Ast];
LB      = [d_t0(1); d_dt1(1); d_dt2(1); -ratio*dVmax*ones(6,1)];
UB      = [d_t0(2); d_dt1(2); d_dt2(2);  ratio*dVmax*ones(6,1)];

% Poids dans le critere sur la minimisation de la date retour
% Plus le poids est petit, plus le delta_V sera petit
poids   = 0.0;
%poids   = 1e-2/365.0;
%poids   = 1e-0/365.0;

% Constraints
if strcmp(destination, 'L2')
    nonlc               = @(X) outbound_impulse_nonlcon_L2(X, xOrb_epoch_t0_Ast, ratio, tfmin, tfmax);
elseif strcmp(destination, 'EMB')
    nonlc               = @(X) outbound_impulse_nonlcon_EMB(X, xOrb_epoch_t0_Ast, ratio, tfmin, tfmax);
else
    error('Wrong destination name!');
end

% Criterion
F0                  = @(X) outbound_impulse_criterion(X, xOrb_epoch_t0_Ast, ratio, poids, scaling, destination, Sansmax);

% Solver
[Xsol,Fsol,exitflag,output,~,~,~] = fmincon(F0,X0,[],[],[],[],LB,UB,nonlc,optionsFmincon);

if(exitflag==0)
    [Xsol,Fsol,exitflag,output,~,~,~] = fmincon(F0,Xsol,[],[],[],[],LB,UB,nonlc,optionsFmincon);
end

fprintf('exitflag = %d \n', exitflag);
fprintf('output = \n'); disp(output);
fprintf('Xsol = \n'); disp(Xsol);

if(exitflag == 1)
    if strcmp(destination, 'L2')
        [cin, ceq, delta_Vf_o]  = outbound_impulse_nonlcon_L2(Xsol, xOrb_epoch_t0_Ast, ratio, tfmin, tfmax);
    elseif strcmp(destination, 'EMB')
        [cin, ceq, delta_Vf_o]  = outbound_impulse_nonlcon_EMB(Xsol, xOrb_epoch_t0_Ast, ratio, tfmin, tfmax);
    else
        error('Wrong destination name!');
    end
    
    [~, delta_V          ]  = outbound_impulse_criterion(Xsol, xOrb_epoch_t0_Ast, ratio, poids, scaling, destination, Sansmax);

    % We construct the output to save
    outputOptimization.xOrb_epoch_t0_Ast = xOrb_epoch_t0_Ast;
    outputOptimization.numAsteroid  = numAsteroid;
    outputOptimization.poids        = poids;
    outputOptimization.dVmax        = dVmax;
    outputOptimization.scaling      = scaling;
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
    outputOptimization.delta_V      = delta_V;
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

    fprintf('delta_V = %f \n', delta_V)
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
            %On trie en fonction du delta_V_total ! Aller + retour !
            i    = 1;
            fini = 0;
            while ((fini==0) && (i<=n))
                oo  = allResults{i}; i=i+1;
                if((oo.delta_V+oo.optiReturn.delta_V)>=(outputOptimization.delta_V+outputOptimization.optiReturn.delta_V))
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
