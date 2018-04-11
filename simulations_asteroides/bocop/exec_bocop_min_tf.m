function [time,stage,z,control,optimvars,output] = exec_bocop_min_tf(bocop_def_pb, init, par, options, solFileName)

workspace = [bocop_def_pb '/def_pb_temps_min/'];

%-----------------------------------
% Bocop options
%-----------------------------------

options_bocop = struct('t0','0','tf','1','freetf','none','disc_steps',options.disc_steps,'disc_method',options.disc_method);

%-----------------------------------
% IPOPT options
%-----------------------------------
options_ipopt = [{'max_iter','10000' };
                 {'tol','1e-10'};
                 {'mu_strategy','adaptive'};
                 {'print_level','5'};  
                 {'file_print_level','5'};
                 {'output_file','result.out'}];

%-----------------------------------
% Dimensions and names
%-----------------------------------

dims.state          = 6;
dims.control        = 3;
dims.algebraic      = 0;
dims.parameter      = 1;
dims.constant       = 20;
dims.boundarycond   = 12;
dims.constraint     = 2;

%
name_state      = {'q1','q2','q3','v1','v2','v3'};
name_control    = {'u1','u2','u3'};
name_boundary   = {'q1(0)','q2(0)','q3(0)','v1(0)','v2(0)','v3(0)','q1(1)','q2(1)','q3(1)','v1(1)','v2(1)','v3(1)'};
name_par        = {'q1_0','q2_0','q3_0','v1_0','v2_0','v3_0','q1_f','q2_f','q3_f','v1_f','v2_f','v3_f','Tmax','mu','muSun', ...
                    'rhoSun','thetaSun_0','omegaSun','m0','min_dist_2_earth'};
name_opti       = {'tf'};
namesDef        = NamesDefFile(name_state,name_control,name_par,name_boundary,name_opti);

%-----------------------------------
% Bounds
%-----------------------------------

% Bounds for the initial and final conditions :
bic = [0 0; 0 0; 0 0; 0 0; 0 0; 0 0;];
bfc = [0 0; 0 0; 0 0; 0 0; 0 0; 0 0;];

% Bounds for the state variables :
bsv = [ -2e20 2e20;
        -2e20 2e20;
        -2e20 2e20;
        -2e20 2e20;
        -2e20 2e20;
        -2e20 2e20];

% Bounds for the control variables :
bcv = [-1 1; -1 1; -1 1];

% Bounds for the algebraic variables :
bav = [];

% Bounds for the optimization parameters :
bop = [0 50];

% Bounds for the path constraints :
bpc = [-2e20 0; -2e20 0];

% Bounds 
bounds = [bic; bfc; bsv; bcv; bav; bop; bpc];

%-----------------------------------
% Constants
%-----------------------------------

constants = par;

%-----------------------------------
% Launch Bocop
%-----------------------------------

[time,stage,state,control,optimvars,output,adjoint,boundarycond_mult] = bocop(workspace,init,options_bocop,options_ipopt,dims,bounds,constants,solFileName,namesDef);
time    = time';
state   = state';
adjoint = adjoint';
control = control';
boundarycond_mult = boundarycond_mult';
z       = [state ; -[-boundarycond_mult(1:length(state(:,1))) adjoint]];
control = [control control(:,end)];

return
