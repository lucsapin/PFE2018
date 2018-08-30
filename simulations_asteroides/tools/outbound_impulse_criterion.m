function F = outbound_impulse_criterion(X, xOrb_epoch_t0_Ast, ratio, departure, Sansmax)

UC          = get_Univers_Constants();

%
icur        = 1;
t0          = X(icur)           ; icur = icur + 1; % initial time for the impulse outbound manoeuver
dt1_o       = X(icur)           ; icur = icur + 1; % time of the second boost
dtf_o       = X(icur)           ; icur = icur + 1; % final time when we meet the asteroid
delta_V0_o  = X(icur:icur+3-1)/ratio  ; icur = icur + 3; % first boost at time t0
delta_V1_o  = X(icur:icur+3-1)/ratio  ; icur = icur + 3; % second boost at time t0 + dt1_o

[~, ~, delta_Vf_o] = outbound_impulse_nonlcon(X, xOrb_epoch_t0_Ast, ratio, 1, 1, departure); % tfmin and tfmax are not used

if Sansmax
  delta_v     = norm(delta_Vf_o) + norm(delta_V1_o) + norm(delta_V0_o);
else
  delta_v     = norm(delta_Vf_o) + norm(delta_V1_o) + 0.5*max(0e-12, norm(delta_Vf_o) - UC.v0AUJour);
end

%F           = scaling*(max_delta_V^2 + norm(delta_V1_o)^2 + norm(delta_Vf_o)^2) + poids*(t0 + dt1_o + dtf_o);
F           = delta_v;

return
