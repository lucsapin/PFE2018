function F = parking_impulse_criterion(X, xOrb_epoch_t0_Ast, ratio, Sansmax)
  % disp('begin criterion');
  % tic;
  UC          = get_Univers_Constants();

  %
  icur        = 1;
  dt1_p       = X(icur)           ; icur = icur + 1; % time of the second boost
  dtf_p       = X(icur)           ; icur = icur + 1; % final time when we meet the EMB
  delta_V0_p  = X(icur:icur+3-1)/ratio  ; icur = icur + 3; % first boost at time t0_p
  delta_V1_p  = X(icur:icur+3-1)/ratio  ; icur = icur + 3; % second boost at time t0_p + dt1_p
  delta_Vf_p  = X(icur:icur+3-1)/ratio  ; icur = icur + 3; % last boost at time t0_p + dt1_p + dtf_p

  % [~, ~, delta_Vf_p] = parking_impulse_nonlcon(X, xOrb_epoch_t0_Ast, q0_SUN_AU, t0_p, ratio);
  if Sansmax
    F     = norm(delta_Vf_p) + norm(delta_V1_p) + norm(delta_V0_p);
  else
    F     = norm(delta_Vf_p) + norm(delta_V1_p) + 0.5*max(0, norm(delta_V0_p) - UC.v0AUJour);
  end

  % max_delta_V = 0.5*sqrt(max(0.0, norm(delta_Vf_p)-UC.v0AUJour)^2+1e-12);
  % F     = max_delta_V + norm(delta_V1_p) + norm(delta_V0_p);

  % toc
  % disp('end criterion');
  return
