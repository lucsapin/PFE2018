function [T_CR3BP, Q_EMB_SUN, Q_CR3BP, color, LW, hFigSpace, zB, optimvarsB] = propagateCompare(destination, typeSimu, numAsteroid, numOpti, dist, display, Sansmax, TmaxN, m0)

  outputOptimization = loadFile(destination, typeSimu, numAsteroid, numOpti, Sansmax);


  % Get initial condition
  disp('Propagate to Hill');
  [times_out, ~, time_Hill, state_Hill, ~, ~, hFigSpace] = propagate2Hill(outputOptimization, dist, display); % The solution is given in HELIO frame

  t0_day      = time_Hill;                % the initial time in Day
  q0_SUN_AU   = state_Hill(1:6);          % q0 in HELIO frame in AU unit
  t0_r        = outputOptimization.t0_r;
  dt1_r       = outputOptimization.dt1_r;
  dtf_r       = outputOptimization.dtf_r;
  tf          = t0_r + dt1_r + dtf_r;
  difftime    = tf-times_out(end);         % Remaining time to reach EMB in Day

  disp('Drift Compare');
  [T_CR3BP, Q_EMB_SUN, Q_CR3BP] = Drift_compareBIS(t0_day, difftime, q0_SUN_AU);

  timeMinDistL2 = getTimeMinDistL2(T_CR3BP, Q_CR3BP)

  if strcmp(destination, 'L2')
    color   = 'm--';
    LW      = 1.5;
  elseif strcmp(destination, 'EMB')
    color   = 'b--';
    LW      = 1.5;
  else
    error('Wrong destination name!');
  end

  disp('Bocop resolution');
  [~, ~,zB, ~, optimvarsB, ~] = do_bocop_opti(destination, outputOptimization, q0_SUN_AU, t0_day, TmaxN, timeMinDistL2, m0, dist);

return
