% function to launch bocop optimization from matlab
% Olivier Cots, Pierre Martinon
% 2015

function [time,stage,state,control,optimvars,output,adjoint,boundarycond_mult] = bocop(workspace,init,options_bocop,options_ipopt, ...
dims,bounds,constants,solFileName,namesDef)

if(strcmp(strtrim(workspace),'')==1)
    workspace = './';
else
    workspace = [workspace '/'];
end
if(strcmp(init.type,'from_sol_file_cold')==1 || strcmp(init.type,'from_sol_file_warm')==1)
    if(~exist([workspace '/' init.file],'file'))
        error(['Attention : le fichier ' init.file ' n''existe pas !']);
    end
end

% Input args:

% X0: data to write .init files
% list of tuple (LABEL,TYPE,VALUE)
% where LABEL is of the form 'state.xxx', 'control.xxx', 'algebraic.xxx'
% with xxx in [0, dim-1], or 'optimvars'. Each will write its .init file
% TYPE is 'constant' for now, unused for optimvars
% VALUE is a scalar for 'constant' init type or a vector for optimvars
% TODO: setter et getter pour X0

% options: settings for optimization
% list of pairs (NAME,VALUE) sorted in two groups:
% options.bocop
% initial.time, final.time, disc.type, disc.steps
% options.ipopt
% max_iter, tol, print_level, mu_strategy, file_print_level, output_file
% TODO fusionner les deux et faire setter/getter unique


% write .def file
% TODO: parse def info from options, def and par
% FAIRE DES COUPLES NOM,VALEUR EN REPRENANT LES NOMS DU DEF
% required data:
% t0 tf freetf <default 0 1 none>
% dims: <default 1 for state and 0 everywhere else>
% boundarycond state control algebraic parameter constraint constant
% disc.type and steps <default midpoint 100>
t0 = options_bocop.t0;
tf = options_bocop.tf;
freetf = options_bocop.freetf;
disc_steps = options_bocop.disc_steps;
disc_method = options_bocop.disc_method;
writeDefFile(init,t0,tf,freetf,dims,disc_steps,disc_method,[workspace '/problem.def'],namesDef);
% write .bounds file
% TODO: parse bounds from par
writeBounds(dims,bounds,[workspace '/problem.bounds']);

% write .constants file > OK
% TODO: put constants in par
writeConstants(constants, [workspace '/problem.constants']);

% write .init files in init/ folder > OK
if(strcmp(init.type,'from_init_file')==1)
    X0 = init.X0;

    % parse X0
    for initdata = X0'
        label = initdata{1};
        type  = initdata{2};
        value = initdata{3};
        writeInit(label,type,value,[workspace '/init/']);
    end
end

% write ipopt.opt file > OK
writeIpopt(options_ipopt,[workspace '/ipopt.opt']);

% launch bocop executable (assumed to be present in correct folder)
exec = ['cd ' workspace '; ./bocop'];
status = system(exec);
if(status == 254)
    status = -2;
else if(status == 255)
    status = -1;
end

solFile = 'problem.sol';
movefile([workspace '/' solFile],[workspace '/' solFileName])

% read and parse .sol file written by bocop
solfile = [workspace '/' solFileName];
verbose = 0; % silent mode
[time,stage,state,control,control_average,algebraic,constants,optimvars,...
    adjoint,zl_state,zu_state,zl_control,zu_control,objective,...
    primal_inf,iterations,boundarycond_mult] = readsolfile2(solfile,verbose);
% status = 'UNDEFINED'; %to be added in sol file
output  = struct('status',status,'iterations',iterations,'objective',objective,'constraints',primal_inf);
control = control_average;

end
