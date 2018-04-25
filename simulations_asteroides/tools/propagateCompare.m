function [T_CR3BP_in_EMB, Q_EMB_SUN, Q_CR3BP_in_EMB, color, LW, hFigSpace, qM, qE, qL2, tf, t0_day] = propagateCompare(destination, typeSimu, numAsteroid, numOpti, dist, display, Sansmax, TmaxN, m0)

  [outputOptimization, ~] = loadFile(destination, typeSimu, numAsteroid, numOpti, Sansmax);


  % Get initial condition
  [times_out, ~, time_Hill, state_Hill, ~, ~, hFigSpace] = propagate2Hill(outputOptimization, dist, display); % The solution is given in HELIO frame

  t0_day      = time_Hill;                % the initial time in Day
  q0_SUN_AU   = state_Hill(1:6);          % q0 in HELIO frame in AU unit
  t0_r        = outputOptimization.t0_r;
  dt1_r       = outputOptimization.dt1_r;
  dtf_r       = outputOptimization.dtf_r;
  tf          = t0_r + dt1_r + dtf_r;
  tf_guess    = tf-times_out(end);         % Remaining time to reach EMB in Day


  [T_CR3BP_in_EMB, Q_EMB_SUN, Q_CR3BP_in_EMB] = Drift_compareBIS(t0_day, dt1_r, q0_SUN_AU);

  [qM, qE, qL2] = get_Moon_Earth_L2_State_Cart_LD(tf); % EMB inertial frame

  if strcmp(destination, 'L2')
    color   = 'm--';
    LW      = 1.5;
  elseif strcmp(destination, 'EMB')
    color   = 'b--';
    LW      = 1.5;
  else
    error('Wrong destination name!');
  end

  do_bocop_opti(destination, outputOptimization, q0_SUN_AU, t0_day, TmaxN, tf_guess, m0, dist)

return
