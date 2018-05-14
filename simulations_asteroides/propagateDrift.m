function [resDrift, correspondingPoint] = propagateDrift(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, Sansmax, choix, propagation)

  outputOptimization = loadFile(destination, typeSimu, numAsteroid, numOpti, Sansmax);

  UC = get_Univers_Constants();

  % Get initial condition
  disp('Propagate to Hill');
  [times_out, ~, time_Hill, state_Hill, ~, ~, states, states_q_L1, states_q_L2] = propagate2Hill(outputOptimization, dist, propagation); % The solution is given in HELIO frame

  t0_day      = time_Hill;                % the initial time in Day
  q0_SUN_AU   = state_Hill(1:6);          % q0 in HELIO frame in AU unit
  t0_r        = outputOptimization.t0_r;
  dt1_r       = outputOptimization.dt1_r;
  dtf_r       = outputOptimization.dtf_r;
  tf          = t0_r + dt1_r + dtf_r;
  difftime    = tf-times_out(end);        % Remaining time to reach EMB in Day

  % ----------------------------------------------------------------------------------------------------
  % Drift Compare : compute the trajectory inside the Hill's sphere, considering a certain dynamics
  disp('Drift Compare');
  [T_CR3BP, Q_EMB_SUN, Q_CR3BP] = Drift_BP(t0_day, difftime, q0_SUN_AU, choix);

  % Compute time and position of the trajectory corresponding to the min distance of L2's point
  [timeMinDistL2, correspondingPoint] = getTimeMinDistL2(T_CR3BP, Q_CR3BP);

  % ----------------------------------------------------------------------------------------------------
  % Results affectation
  resDrift.T_CR3BP = T_CR3BP;
  resDrift.Q_EMB_SUN = Q_EMB_SUN;
  resDrift.Q_CR3BP = Q_CR3BP;

return
