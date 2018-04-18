function [T_CR3BP_in_EMB, Q_EMB_SUN, Q_CR3BP_in_EMB, color, LW, hFigSpace] = propagateCompare(destination,numAsteroid, numOpti, dist, display)

  outputOptimization = loadFile(destination, numAsteroid, numOpti);


  % Get initial condition
  [times_out, traj_out, time_Hill, state_Hill, xC_EMB_HIll, ~, hFigSpace] = propagate2Hill(outputOptimization, dist, display); % The solution is given in HELIO frame

  t0_day      = time_Hill;                % the initial time in Day
  q0_SUN_AU   = state_Hill(1:6);          % q0 in HELIO frame in AU unit
  t0_r        = outputOptimization.t0_r;
  dt1_r       = outputOptimization.dt1_r;
  dtf_r       = outputOptimization.dtf_r;
  tf          = t0_r + dt1_r + dtf_r;
  tf_guess    = tf-times_out(end);         % Remaining time to reach EMB in Day


  [T_CR3BP_in_EMB, Q_EMB_SUN, Q_CR3BP_in_EMB] = Drift_compareBIS(t0_day, dtf_r, q0_SUN_AU);

  if strcmp(destination, 'L2')
    color   = 'm--';
    LW      = 1.5;
  elseif strcmp(destination, 'EMB')
    color   = 'b--';
    LW      = 1.5;
  else
    error('Wrong destination name!');
  end


return
