function [delta_V_o, delta_V_r, t0_o, tf_o, t0_r, tf_r] = getResults(destination, typeSimu, Sansmax)

    delta_V_o = zeros(1, 10);
    delta_V_r = zeros(1, 10);
    t0_o = zeros(1, 10);
    tf_o = zeros(1, 10);
    t0_r = zeros(1, 10);
    tf_r = zeros(1, 10);

    for numAst=1:10
        outputOptimization = loadFile(destination, typeSimu, numAst, 1, Sansmax);
        if typeSimu == 'outbound'
            delta_V_o(numAst) = outputOptimization.Fsol;
            delta_V_r(numAst) = outputOptimization.optiReturn.Fsol;
            t0_o(numAst) = outputOptimization.t0;
            tf_o(numAst) = t0_o(numAst) + outputOptimization.dt1 + outputOptimization.dtf;

            t0_r(numAst) = outputOptimization.optiReturn.t0;
            tf_r(numAst) = t0_r(numAst) + outputOptimization.optiReturn.dt1 + outputOptimization.optiReturn.dtf;
        elseif typeSimu == 'total'
            delta_V_o(numAst) = outputOptimization.delta_V_o;
            delta_V_r(numAst) = outputOptimization.delta_V_r;
            t0_o(numAst) = outputOptimization.t0_o;
            tf_o(numAst) = t0_o(numAst) + outputOptimization.dt1_o + outputOptimization.dtf_o;

            t0_r(numAst) = outputOptimization.t0_r;
            tf_r(numAst) = t0_r(numAst) + outputOptimization.dt1_r + outputOptimization.dtf_r;
        else
            error('Wrong typeSimu name !');
        end
    end
return
