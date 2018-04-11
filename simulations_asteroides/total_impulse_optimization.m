% Script to optimize the outbound-return 3+3 impulse manoeuver: from EMB to asteroid, stay on it and back to EMB
%

function total_impulse_optimization(numAsteroid, numOptiOutbound, destination)

% numAsteroid: the numero of the asteroid for which we perform the optimization
% numOptiOutbound: the numero of outbound (and so return has been performed) optimization
%

fprintf('numAsteroid = %d \n', numAsteroid);
fprintf('numOptiOutbound = %d \n', numOptiOutbound);

%
format shortE;
addpath('tools/');

%
repOutput = ['results/total_impulse_' destination '/'];
if(~exist(repOutput,'dir')); error('Wrong result directory name!'); end

% Directory of the outbound-return data
repOutputOutbound = ['results/outbound_impulse_' destination '/'];
if(~exist(repOutputOutbound,'dir')); error('Wrong result directory name!'); end

file2loadOutbound = [repOutputOutbound 'asteroid_no_' int2str(numAsteroid)];
if(exist([file2loadOutbound '.mat'],'file')~=2)
    error(['there is no outbound optimization done for asteroid number ' int2str(numAsteroid)]);
end

% We get the data of the numero numOptiOutbound of the outbound optimizations for asteroid numAsteroid
load(file2loadOutbound);
allResultsOutbound = allResults;
clear allResults;
nbOpti      = length(allResultsOutbound); fprintf('nbOpti = %d \n', nbOpti);
if(0<numOptiOutbound && numOptiOutbound<=nbOpti)
    outputOptiOutbound  = allResultsOutbound{numOptiOutbound};
else
    error('numOptiReturn is invalid!');
end

% ----------------------------------------------------------------------------------------------------
% Load the 4258 asteroid's orbital parameters
% Are there in the Heliocentric referentiel ?
%
load('bdd/bdd_asteroids_oribtal_params');
% [n_par,n_ast]=size(asteroids_orbital_params);

%
UC          = get_Univers_Constants(); % Univers constants

% Get asteroid's orbital elements at epoch_t0
xOrb_epoch_t0_Ast   = get_Ast_init_Orbital_elements(asteroids_orbital_params, numAsteroid);
period_Ast          = 2*pi*sqrt(xOrb_epoch_t0_Ast(1)^3/UC.mu0SunAU);

% Options for the solver
optionsFmincon      = optimoptions('fmincon','display','iter','Algorithm','interior-point', ...
                                    'ConstraintTolerance', 1e-5, 'OptimalityTolerance', 1e-5, 'StepTolerance', 1e-12, 'FunctionTolerance', 1e-12, ...
                                    'MaxFunEvals', 10000, 'MaxIterations', 300);

% facteur d'echelle
dVmax   = 2.e-3;
ratio   = period_Ast/dVmax;
scaling = 1e5;
time_min_on_ast = 0.0;
time_max_on_ast = 360;

% Initial guess
t0_o    = outputOptiOutbound.t0;
dt1_o   = outputOptiOutbound.dt1;
dtf_o   = outputOptiOutbound.dtf;
dV0_o   = outputOptiOutbound.dV0;
dV1_o   = outputOptiOutbound.dV1;
t0_r    = outputOptiOutbound.optiReturn.t0;
dt1_r   = outputOptiOutbound.optiReturn.dt1;
dtf_r   = outputOptiOutbound.optiReturn.dtf;
dV0_r   = outputOptiOutbound.optiReturn.dV0;
dV1_r   = outputOptiOutbound.optiReturn.dV1;
X0          = [t0_o; dt1_o; dtf_o; t0_r; dt1_r; dtf_r; ratio*dV0_o; ratio*dV1_o; ratio*dV0_r; ratio*dV1_r];

% Lower and upper bounds
t0_min_o    = -1.0 * 365.25;
t0_max_o    = 18*365.25; % 18 years
d_t0_o      = [t0_min_o;t0_max_o];
d_dt1_o     = [1;period_Ast];
d_dt2_o     = [1;period_Ast];
t0_min_r    = 365.25/2;
t0_max_r    = 19*365.25; % 19 years
d_t0_r      = [t0_min_r;t0_max_r];
d_dt1_r     = [1;period_Ast];
d_dt2_r     = [1;period_Ast];
LB          = [d_t0_o(1); d_dt1_o(1); d_dt2_o(1); d_t0_r(1); d_dt1_r(1); d_dt2_r(1); -ratio*dVmax*ones(12,1)];
UB          = [d_t0_o(2); d_dt1_o(2); d_dt2_o(2); d_t0_r(2); d_dt1_r(2); d_dt2_r(2);  ratio*dVmax*ones(12,1)];


% Constraints
if strcmp(destination, 'L2')
    nonlc               = @(X) total_impulse_nonlcon_L2  (X, xOrb_epoch_t0_Ast, ratio, time_min_on_ast, time_max_on_ast);
elseif strcmp(destination, 'EMB')
    nonlc               = @(X) total_impulse_nonlcon_EMB  (X, xOrb_epoch_t0_Ast, ratio, time_min_on_ast, time_max_on_ast);
else
    error('Wrong destination name!');
end

% Criterion
F0                  = @(X) total_impulse_criterion(X, xOrb_epoch_t0_Ast, ratio, scaling, time_min_on_ast, time_max_on_ast, destination);

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
        [cin, ceq, delta_Vf_o, delta_Vf_r]  = total_impulse_nonlcon_L2(Xsol, xOrb_epoch_t0_Ast, ratio, time_min_on_ast, time_max_on_ast);
    elseif strcmp(destination, 'EMB')
        [cin, ceq, delta_Vf_o, delta_Vf_r]  = total_impulse_nonlcon_EMB(Xsol, xOrb_epoch_t0_Ast, ratio, time_min_on_ast, time_max_on_ast);
    else
        error('Wrong destination name!');
    end
    
    [~, delta_V, delta_V_o, delta_V_r]  = total_impulse_criterion(Xsol, xOrb_epoch_t0_Ast, ratio, scaling, time_min_on_ast, time_max_on_ast, destination);

    % We construct the output to save
    outputOptimization.xOrb_epoch_t0_Ast = xOrb_epoch_t0_Ast;
    outputOptimization.numAsteroid  = numAsteroid;
    outputOptimization.dVmax        = dVmax;
    outputOptimization.ratio        = ratio;
    outputOptimization.scaling      = scaling;
    outputOptimization.LB           = LB;
    outputOptimization.UB           = UB;
    outputOptimization.X0           = X0;
    outputOptimization.Xsol         = Xsol;
    outputOptimization.t0_o         = Xsol(1);
    outputOptimization.dt1_o        = Xsol(2);
    outputOptimization.dtf_o        = Xsol(3);
    outputOptimization.t0_r         = Xsol(4);
    outputOptimization.dt1_r        = Xsol(5);
    outputOptimization.dtf_r        = Xsol(6);
    outputOptimization.dV0_o        = Xsol(7:9)/ratio;
    outputOptimization.dV1_o        = Xsol(10:12)/ratio;
    outputOptimization.dV0_r        = Xsol(13:15)/ratio;
    outputOptimization.dV1_r        = Xsol(16:18)/ratio;
    outputOptimization.dVf_o        = delta_Vf_o;
    outputOptimization.dVf_r        = delta_Vf_r;
    outputOptimization.delta_V      = delta_V;
    outputOptimization.delta_V_o    = delta_V_o;
    outputOptimization.delta_V_r    = delta_V_r;
    outputOptimization.cin          = cin;
    outputOptimization.ceq          = ceq;
    outputOptimization.Fsol         = Fsol;
    outputOptimization.exitflag     = exitflag;
    outputOptimization.output       = output;

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
                    k   =i-1;
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
