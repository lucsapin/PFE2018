function [time,stage,z,control,optimvars,output] = exec_bocop_3B_impulse_hill(bocop_def_pb, init, par, options, solFileName)

workspace = [bocop_def_pb 'def_pb_duree_min_5p/'];
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
dims.state          = 35;
dims.control        = 9;
dims.algebraic      = 0;
dims.parameter      = 5;
dims.constant       = 20;
dims.boundarycond   = 41;
dims.constraint     = 3;

%
name_state      = {'q11','q12','q13','q14','q15','q16','m1', ...
                   'q21','q22','q23','q24','q25','q26','m2', ...
                   'q31','q32','q33','q34','q35','q36','m3', ...
                   'q41','q42','q43','q44','q45','q46','m4', ...
                   'q51','q52','q53','q54','q55','q56','m5'};

name_control    = {'u11','u12','u13', ...
                   'u31','u32','u33', ...
                   'u51','u52','u53'};

name_boundary   = {'q11i-qH1','q12i-qH2','q13i-qH3', ...
                   'q14i-qH4','q15i-qH5','q16i-qH6','m1i-m0', ...
                   'q21i-q11f','q22i-q12f','q23i-q13f', ...
                   'q24i-q14f','q25i-q15f','q26i-q16f','m2i-m1f', ...
                   'q31i-q21f','q32i-q22f','q33i-q23f', ...
                   'q34i-q24f','q35i-q25f','q36i-q26f','m3i-m2f', ...
                   'q41i-q31f','q42i-q32f','q43i-q33f', ...
                   'q44f-q34f','q45i-q35f','q46i-q36f','m4i-m3f', ...
                   'q51i-q41f','q52i-q42f','q53i-q43f', ...
                   'q54i-q44f','q55i-q45f','q56i-q46f','m5i-m4f', ...
                   'qL21-q51f','qL22-q52f','qL23-q53f', ...
                   'qL24-q54f','qL25-q55f','qL26-q56f'}; %m5f libre

name_par        = {'Tmax','beta','mu','muS','rS', ...
                   'qH1','qH2','qH3','qH4','qH5','qH6', ...
                   'qL21','qL22','qL23','qL24','qL25','qL26', ...
                   'thetaS0','omegaS','m0'};

name_opti       = {'dt1','dt2','dt3','dt4','dtf'};

namesDef        = NamesDefFile(name_state,name_control,name_par,name_boundary,name_opti);

% -----------------------------------
% Bounds
% -----------------------------------
% Bounds for the initial and final conditions :
bifc = [0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; ...
        0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; ...
        0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; ...
        0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; ...
        0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; ...
        0 0; 0 0; 0 0; 0 0; 0 0; 0 0];

% Bounds for the state variables :
bsv = [-2e20 2e20; -2e20 2e20; -2e20 2e20;
       -2e20 2e20; -2e20 2e20; -2e20 2e20;
       -2e20 2e20; % 1ère phase
       -2e20 2e20; -2e20 2e20; -2e20 2e20;
       -2e20 2e20; -2e20 2e20; -2e20 2e20;
       -2e20 2e20; % 2è phase
       -2e20 2e20; -2e20 2e20; -2e20 2e20;
       -2e20 2e20; -2e20 2e20; -2e20 2e20;
       -2e20 2e20; % 3è phase
       -2e20 2e20; -2e20 2e20; -2e20 2e20;
       -2e20 2e20; -2e20 2e20; -2e20 2e20;
       -2e20 2e20; % 4è phase
       -2e20 2e20; -2e20 2e20; -2e20 2e20;
       -2e20 2e20; -2e20 2e20; -2e20 2e20;
       -2e20 2e20]; % 5è phase

% Bounds for the control variables :
bcv = [-1 1; -1 1; -1 1; % u1
       -1 1; -1 1; -1 1; % u3
       -1 1; -1 1; -1 1]; % u5

% Bounds for the algebraic variables :
bav = [];

% Bounds for the optimization parameters :
bop = [0     2e20;
       0     2e20;
       0     2e20;
       0     2e20;
       0     2e20];

% Bounds for the path constraints :
bpc = [0 0;
       0 0;
       0 0];

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
z = [zMultiphase(1:7,:)   zMultiphase(8:14,:) zMultiphase(15:21,:) zMultiphase(22:28,:) zMultiphase(29:35,:);% state
     zMultiphase(36:42,:) zMultiphase(43:49,:) zMultiphase(50:56,:) zMultiphase(57:63,:) zMultiphase(64:70,:)]; % adjoint

if control ~= []
  control = [control control(:,end)];
end

return
