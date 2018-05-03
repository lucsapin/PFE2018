function [resDriftCompare, resFig, resBocop, resPropagate2Hill, correspondingPoint] = propagateCompare(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, Sansmax)

  outputOptimization = loadFile(destination, typeSimu, numAsteroid, numOpti, Sansmax);

  UC = get_Univers_Constants();

  % Get initial condition
  disp('Propagate to Hill');
  [times_out, ~, time_Hill, state_Hill, ~, ~, states, states_q_L1, states_q_L2] = propagate2Hill(outputOptimization, dist); % The solution is given in HELIO frame

  resPropagate2Hill.states = states;
  resPropagate2Hill.states_q_L1 = states_q_L1;
  resPropagate2Hill.states_q_L2 = states_q_L2;

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
  [T_CR3BP, Q_EMB_SUN, Q_CR3BP] = Drift_3BP(t0_day, difftime, q0_SUN_AU);

  % Compute time and position of the trajectory corresponding to the min distance of L2's point
  [timeMinDistL2, correspondingPoint] = getTimeMinDistL2(T_CR3BP, Q_CR3BP)

  % ----------------------------------------------------------------------------------------------------
  % Results affectation
  resDriftCompare.T_CR3BP = T_CR3BP;
  resDriftCompare.Q_EMB_SUN = Q_EMB_SUN;
  resDriftCompare.Q_CR3BP = Q_CR3BP;

  if strcmp(destination, 'L2')
    color   = 'm--';
    LW      = 1.5;
  elseif strcmp(destination, 'EMB')
    color   = 'b--';
    LW      = 1.5;
  else
    error('Wrong destination name!');
  end

  resFig.color = color;
  resFig.LW = LW;

  disp('Bocop resolution');
  [~, ~,zB, ~, optimvarsB, ~] = do_bocop_opti(destination, outputOptimization, q0_SUN_AU, t0_day, TmaxN, difftime, m0, dist);
  resBocop.zB = zB;
  resBocop.optimvarsB = optimvarsB;
  solutionBocop = t0_day + optimvarsB*UC.time_syst/UC.jour % en jour
return
