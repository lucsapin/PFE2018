function F = outbound_impulse_criterion(X, xOrb_epoch_t0_Ast, ratio, departure)

UC          = get_Univers_Constants();

%
icur        = 1;
t0          = X(icur)           ; icur = icur + 1; % initial time for the impulse outbound manoeuver
dt1_o       = X(icur)           ; icur = icur + 1; % time of the second boost
dtf_o       = X(icur)           ; icur = icur + 1; % final time when we meet the asteroid
delta_V0_o  = X(icur:icur+3-1)/ratio  ; icur = icur + 3; % first boost at time t0
delta_V1_o  = X(icur:icur+3-1)/ratio  ; icur = icur + 3; % second boost at time t0 + dt1_o

[~, ~, delta_Vf_o] = outbound_impulse_nonlcon(X, xOrb_epoch_t0_Ast, ratio, 1, 1, departure); % tfmin and tfmax are not used


delta_V     = norm(delta_V0_o) + norm(delta_V1_o) + norm(delta_Vf_o);


%F           = scaling*(max_delta_V^2 + norm(delta_V1_o)^2 + norm(delta_Vf_o)^2) + poids*(t0 + dt1_o + dtf_o);
F           = delta_V;

return
