function [resDrift, resFig, resB, resP2H, correspondingPoint] = get_all_traj(destination, typeSimu, numAsteroid, numOpti, dist, TmaxN, m0, choixDyn)

  outputOptimization = loadFile(destination, typeSimu, numAsteroid, numOpti);

  UC = get_Univers_Constants();

  % Get initial condition
  [times_out, traj_out, time_Hill, state_Hill, ~, ~, states, states_q_L1, states_q_L2] = propagate2Hill(outputOptimization, dist);
  % The solution is given in HELIO frame

  t0_day      = time_Hill;                % the initial time in Day
  q0_SUN_AU   = state_Hill(1:6);          % q0 in HELIO frame in AU unit
  t0_r        = outputOptimization.t0;
  dt1_r       = outputOptimization.dt1;
  dtf_r       = outputOptimization.dtf;
  tf          = t0_r + dt1_r + dtf_r;
  difftime    = tf-times_out(end);        % Remaining time to reach EMB in Day

  % ----------------------------------------------------------------------------------------------------
  % Drift Compare : compute the trajectory inside the Hill's sphere, considering a certain dynamics
  [T_CR3BP, Q_EMB_SUN, Q_CR3BP] = Drift_BP(t0_day, difftime, q0_SUN_AU, choixDyn);

  % Compute time and position of the trajectory corresponding to the min distance of L2's point
  [timeMinDistL2, correspondingPoint] = getTimeMinDistL2(T_CR3BP, Q_CR3BP);

  % ----------------------------------------------------------------------------------------------------
  % Results affectation
  resP2H.times = times_out;
  resP2H.traj_out = traj_out;

  resDrift.T_CR3BP = T_CR3BP;
  resDrift.Q_EMB_SUN = Q_EMB_SUN;
  resDrift.Q_CR3BP = Q_CR3BP;
  resDrift.q0_SUN_AU = q0_SUN_AU;


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
  outputOptiB = loadFile(destination, 'total', numAsteroid, numOpti);
  [~, ~,zB, ~, optimvarsB, ~] = do_bocop_opti(destination, outputOptiB, q0_SUN_AU, t0_day, TmaxN, difftime, m0, dist);
  resB.zB = zB;
  resB.optimvarsB = optimvarsB;
  solutionBocop = t0_day + optimvarsB*UC.time_syst/UC.jour; % en jour
return
