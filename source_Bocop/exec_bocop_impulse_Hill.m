function [time,stage,z,control,optimvars,output] = exec_bocop_min_dv(bocop_def_pb, init, par, options, solFileName)

workspace = [bocop_def_pb 'impulse_Hill/'];

%-----------------------------------
% Bocop options
%-----------------------------------
options_bocop = struct('t0','0','tf','1','freetf','none','disc_steps',options.disc_steps,'disc_method',options.disc_method);

%-----------------------------------
% IPOPT options
%-----------------------------------
options_ipopt = [{'max_iter','1000' };
                 {'tol','1e-10'};
                 {'mu_strategy','adaptive'};
                 {'print_level','5'};
                 {'file_print_level','6'};
                 {'output_file','result.out'}];

%-----------------------------------
% Dimensions and names
%-----------------------------------

dims.state          = 12;
dims.control        = 0;
dims.algebraic      = 0;
dims.parameter      = 11;
dims.constant       = 20;
dims.boundarycond   = 18;
dims.constraint     = 0;

%
name_state      = {'q11', 'q12', 'q13', 'q14','q15','q16', 'q21','q22','q23', 'q24','q25','q26'};
name_control    = {};
name_boundary   = {'qH1q11i', 'qH2q12i', 'qH3q13i', ...
                   'qH4dV11q14i', 'qH5dV12q15i', 'qH6dV13q16i', ...
                   'q11fq21i', 'q12fq22i', 'q13fq23i', ...
                   'q14fdV21q24i', 'q15fdV22q25i', 'q16fdV23q26i', ...
                   'q21fqL21', 'q22fqL22', 'q23fqL23', ...
                   'q24fdV31qL24', 'q25fdV32qL25', 'q26fdV33qL26'};

name_par        = {'Tmax','beta','mu','muS','rSun', ...
                   'qH1','qH2','qH3','qH4','qH5','qH6', ...
                   'qL21','qL22','qL23','qL24','qL25','qL26', ...
                   'theta0', 'omegaS', 'm0'};

name_opti       = {'dt1', 'dt2', ...
                   'dV11', 'dV12', 'dV13', ...
                   'dV21', 'dV22', 'dV23', ...
                   'dV31', 'dV32', 'dV33'};

namesDef        = NamesDefFile(name_state,name_control,name_par,name_boundary,name_opti);

%-----------------------------------
% Bounds
% Bounds for the initial and final conditions :
bic = [0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0];
bfc = [0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0];

% Bounds for the state variables :
bsv = [];

% Bounds for the control variables :
bcv = [];
% Bounds for the algebraic variables :
bav = [];

% Bounds for the optimization parameters :
bop = [0 50; 0 50];
% Bounds for the path constraints :
bpc = [];

% Bounds
bounds = [bic; bfc; bsv; bcv; bav; bop; bpc];

%-----------------------------------
% Constants
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
