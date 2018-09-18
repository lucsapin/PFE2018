function [status, iterations, objective, constraints, zB, optimvarsB] = loadResultsBocop(destination, numAst, TmaxN, m0, beta)

    liste_status = zeros(1, 10);
    liste_iterations = zeros(1, 10);
    liste_objective = zeros(1, 10);
    liste_constraints = zeros(1, 10);

    dist                = 0.01;     % We propagate the trajectory to the distance dist (in AU) of EMB
    min_dist_2_earth    = 0.0;


    case_name   = ['./min_inside_hill_bocop_Tmax_' num22str(TmaxN,3) '_m0_' num22str(m0,6) '_beta_' num22str(beta,3) ...
                   '_ast_' int2str(numAst)];

    dirLoad = ['./results/compare_inside_Hill/' destination '/in_progress_results/'];

    if(~exist(dirLoad,'dir')); error('Wrong directory name!'); end

    file_results= [dirLoad case_name];

    if(exist([file_results '.mat'],'file')==2); load(file_results); end


    zB = results.min_3B_impulse_bocop.zB(1:6,:);
    optimvarsB = results.min_3B_impulse_bocop.optimvarsB;
    outputB = results.min_3B_impulse_bocop.outputB;
    status = outputB.status;
    iterations = outputB.iterations;
    objective = outputB.objective;
    constraints = outputB.constraints;

return
