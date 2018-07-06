function [time,stage,z,control,optimvars,output] = exec_bocop_3B_impulse_hill(bocop_def_pb, init, par, options, solFileName)

workspace = [bocop_def_pb '3_boosts_impulse_Hill/'];
% -----------------------------------
% Bocop options
% -----------------------------------
options_bocop = struct('t0','0','tf','1','freetf','none','disc_steps',options.disc_steps,'disc_method',options.disc_method);

% -----------------------------------
% IPOPT options
% -----------------------------------
options_ipopt = [{'max_iter','1000' };
                 {'tol','1e-10'};
                 {'mu_strategy','adaptive'};
                 {'print_level','5'};
                 {'file_print_level','5'};
                 {'output_file','result.out'}];

% -----------------------------------
% Dimensions and names
% -----------------------------------
dims.state          = 12;
dims.control        = 0;
dims.algebraic      = 0;
dims.parameter      = 11;
dims.constant       = 20;
dims.boundarycond   = 18;
dims.constraint     = 0;

%
name_state      = {'q11','q12','q13','q14','q15','q16', ...
                   'q21','q22','q23','q24','q25','q26'};
name_control    = {};
name_boundary   = {'q11i-qH1','q12i-qH2','q13i-qH3', ...
                   'q14i-qH4-dV11','q15i-qH5-dV12','q16i-qH6-dV13', ...
                   'q21i-q11f','q22i-q12f','q23i-q13f', ...
                   'q24i-q14f-dV21','q25i-q15f-dV22','q26i-q16f-dV23', ...
                   'q21f-qL21','q22f-qL22','q23f-qL23', ...
                   'q24f-qL24+dV31','q25f-qL25+dV32','q26f-qL26+dV33'};
name_par        = {'Tmax','beta','mu','muS','rS', ...
                   'qH1','qH2','qH3','qH4','qH5','qH6', ...
                   'qL21','qL22','qL23','qL24','qL25','qL26', ...
                   'thetaS0','omegaS','m0'};
name_opti       = {'dt1','dt2','dV11','dV12','dV13','dV21','dV22','dV23','dV31','dV32','dV33'};

namesDef        = NamesDefFile(name_state,name_control,name_par,name_boundary,name_opti);

% -----------------------------------
% Bounds
% -----------------------------------
% Bounds for the initial and final conditions :
bifc = [0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0];

% Bounds for the state variables :
bsv = [-2e20 2e20;
       -2e20 2e20;
       -2e20 2e20;
       -2e20 2e20;
       -2e20 2e20;
       -2e20 2e20;
       -2e20 2e20;
       -2e20 2e20;
       -2e20 2e20;
       -2e20 2e20;
       -2e20 2e20;
       -2e20 2e20];

% Bounds for the control variables :
bcv = [];

% Bounds for the algebraic variables :
bav = [];

% Bounds for the optimization parameters :
bop = [0     2e20;
       -2e20 2e20;
       -2e20 2e20;
       -2e20 2e20;
       -2e20 2e20;
       -2e20 2e20;
       -2e20 2e20;
       -2e20 2e20;
       -2e20 2e20;
       -2e20 2e20;
       -2e20 2e20];

% Bounds for the path constraints :
bpc = [];

% Bounds
bounds = [bifc; bsv; bcv; bav; bop; bpc];

% -----------------------------------
% Constants
% -----------------------------------
constants = par;

% -----------------------------------
% Launch Bocop
% -----------------------------------
[time,stage,state,control,optimvars,output,adjoint,boundarycond_mult] = bocop(workspace,init,options_bocop,options_ipopt,dims,bounds,constants,solFileName,namesDef);
time    = time';
state   = state';
adjoint = adjoint';
control = control';
boundarycond_mult = boundarycond_mult';
% attention il faut que les condition initiales soient avant les finales dans le fichier bocop
zMultiphase       = [state ; -[-boundarycond_mult(1:length(state(:,1))) adjoint]];
% Multiphase : on recolle les morceaux
z = [zMultiphase(1:6,:)   zMultiphase(7:12,:); % state
     zMultiphase(13:18,:) zMultiphase(19:24,:)]; % adjoint

if control ~= []
  control = [control control(:,end)];
end

return
