function [F, delta_v] = parking_impulse_criterion(X, xOrb_epoch_t0_Ast, q0_SUN_AU, t0_p, ratio, poids, scaling, destination, Sansmax)


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
      delta_v     = norm(delta_Vf_p) + norm(delta_V1_p) + norm(delta_V0_p);

  else
      max_delta_V = 0.5*sqrt(max(0.0, norm(delta_Vf_p)-UC.v0AUJour)^2+1e-12);
      delta_v     = max_delta_V + norm(delta_V1_p) + norm(delta_V0_p);

  end

  %F           = scaling*(max_delta_V^2 + norm(delta_V1_p)^2 + norm(delta_V0_p)^2) + poids*(t0_p + dt1_p + dtf_p);
  F           = delta_v + poids*(t0_p + dt1_p + dtf_p);


  return
