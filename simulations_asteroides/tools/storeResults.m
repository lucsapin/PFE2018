function [delta_V, nbOpti, t0, dt1, dtf] = storeResults(destination, typeSimu, numAst)

  [outputOptimization, nbOpti] = loadFile(destination, typeSimu, numAst, 1);
  delta_V = outputOptimization.delta_V;
  t0 = outputOptimization.t0;
  dt1 = outputOptimization.dt1;
  dtf = outputOptimization.dtf;
return
