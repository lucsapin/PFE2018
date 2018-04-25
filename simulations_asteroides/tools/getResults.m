function [delta_V, nbOpti, t0, dt1, dtf] = getResults(destination, typeSimu, Sansmax)
    
    delta_V= zeros(1, 10);
    nbOpti = zeros(1, 10);
    t0 = zeros(1, 10);
    dt1 = zeros(1, 10);
    dtf = zeros(1, 10);

    for numAst=1:10
        [outputOptimization, nbOpti(numAst)] = loadFile(destination, typeSimu, numAst, 1, Sansmax);
        delta_V(numAst) = outputOptimization.delta_V;
        t0(numAst) = outputOptimization.t0;
        dt1(numAst) = outputOptimization.dt1;
        dtf(numAst) = outputOptimization.dtf;
    end
return