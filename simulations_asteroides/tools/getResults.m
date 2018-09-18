function [delta_V_o, delta_V_r, t0_o, tf_o, t0_r, tf_r] = getResults(numAst, destination, typeSimu, Sansmax)

    delta_V_o = zeros(1,4);
    delta_V_r = zeros(1,4);

    outputOptimization = loadFile(destination, typeSimu, numAst, 1, Sansmax);
    if strcmp(typeSimu, 'outbound')

      delta_V_o(:,1) = norm(outputOptimization.dV0);
      delta_V_o(:,2) = norm(outputOptimization.dV1);
      delta_V_o(:,3) = norm(outputOptimization.dVf);
      delta_V_o(:,4) = outputOptimization.Fsol;
      
      delta_V_r(:,1) = norm(outputOptimization.optiReturn.dV0);
      delta_V_r(:,2) = norm(outputOptimization.optiReturn.dV1);
      delta_V_r(:,3) = norm(outputOptimization.optiReturn.dVf);
      delta_V_r(:,4) = outputOptimization.optiReturn.Fsol;
      t0_o           = outputOptimization.t0;
      tf_o           = t0_o + outputOptimization.dt1 + outputOptimization.dtf;

      t0_r           = outputOptimization.optiReturn.t0;
      tf_r           = t0_r + outputOptimization.optiReturn.dt1 + outputOptimization.optiReturn.dtf;
    elseif strcmp(typeSimu, 'total')

      delta_V_o(:,1) = norm(outputOptimization.dV0_o);
      delta_V_o(:,2) = norm(outputOptimization.dV1_o);
      delta_V_o(:,3) = norm(outputOptimization.dVf_o);
      delta_V_o(:,4) = outputOptimization.delta_V_o;

      delta_V_r(:,1) = norm(outputOptimization.dV0_r);
      delta_V_r(:,2) = norm(outputOptimization.dV1_r);
      delta_V_r(:,3) = norm(outputOptimization.dVf_r);
      delta_V_r(:,4) = outputOptimization.delta_V_r;
      t0_o           = outputOptimization.t0_o;
      tf_o           = t0_o + outputOptimization.dt1_o + outputOptimization.dtf_o;

      t0_r           = outputOptimization.t0_r;
      tf_r           = t0_r + outputOptimization.dt1_r + outputOptimization.dtf_r;
    else
      error('Wrong typeSimu name !');
    end

return
