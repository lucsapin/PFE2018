function [liste_status, liste_iterations, liste_objective, liste_constraints, traj_out] = loadResultsBocop(destination)

    liste_status = zeros(1, 10);
    liste_iterations = zeros(1, 10);
    liste_objective = zeros(1, 10);
    liste_constraints = zeros(1, 10);
    
    TmaxN               = 50;       % Newton
    dist                = 0.01;     % We propagate the trajectory to the distance dist (in AU) of EMB
    min_dist_2_earth    = 0.0;

    for numAst=1:10
        if numAst==1
            m0 = 1000; % kg
        else
            m0 = 500;  % kg
        end
        case_name   = ['./min_tf_Tmax_' num22str(TmaxN,3) '_m0_' num22str(m0,6) '_ast_' int2str(numAst) ...
                    '_dist_' num22str(dist,4) '_dist_min_2_earth_' num22str(min_dist_2_earth,2)];

        dirLoad = ['./results/compare_return_non_constant_mass/' destination '/in_progress_results/'];

        if(~exist(dirLoad,'dir')); error('Wrong directory name!'); end

        file_results= [dirLoad case_name];

        if(exist([file_results '.mat'],'file')==2); load(file_results); end

        zB = results.min_tf_bocop.zB;
        outputB = results.min_tf_bocop.outputB;
        liste_status(numAst) = outputB.status;
        liste_iterations(numAst) = outputB.iterations;
        liste_objective(numAst) = outputB.objective;
        liste_constraints(numAst) = outputB.constraints;

    end
return
