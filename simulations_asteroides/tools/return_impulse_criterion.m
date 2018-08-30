function F = return_impulse_criterion(X, xOrb_epoch_t0_Ast, ratio, destination, Sansmax)

UC          = get_Univers_Constants();

%
icur        = 1;
t0_r        = X(icur)           ; icur = icur + 1; % initial time for the impulse return manoeuver
dt1_r       = X(icur)           ; icur = icur + 1; % time of the second boost
dtf_r       = X(icur)           ; icur = icur + 1; % final time when we meet the EMB
delta_V0_r  = X(icur:icur+3-1)/ratio  ; icur = icur + 3; % first boost at time t0_r
delta_V1_r  = X(icur:icur+3-1)/ratio  ; icur = icur + 3; % second boost at time t0_r + dt1_r

[~, ~, delta_Vf_r] = return_impulse_nonlcon(X, xOrb_epoch_t0_Ast, ratio, destination);

if Sansmax
  delta_v     = norm(delta_Vf_r) + norm(delta_V1_r) + norm(delta_V0_r);
else
  delta_v     = norm(delta_Vf_r) + norm(delta_V1_r) + 0.5*max(0e-12, norm(delta_Vf_r) - UC.v0AUJour);
end


%F           = scaling*(max_delta_V^2 + norm(delta_V1_r)^2 + norm(delta_V0_r)^2) + poids*(t0_r + dt1_r + dtf_r);
F           = delta_v;


return
