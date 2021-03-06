function [F, delta_V_o, delta_V_r] = total_impulse_criterion(X, xOrb_epoch_t0_Ast, ratio, time_min_on_ast, time_max_on_ast, destination, Sansmax)

UC          = get_Univers_Constants();

%
icur        = 1;
t0_o        = X(icur)           ; icur = icur + 1;
dt1_o       = X(icur)           ; icur = icur + 1;
dtf_o       = X(icur)           ; icur = icur + 1;
t0_r        = X(icur)           ; icur = icur + 1;
dt1_r       = X(icur)           ; icur = icur + 1;
dtf_r       = X(icur)           ; icur = icur + 1;
delta_V0_o  = X(icur:icur+3-1)/ratio  ; icur = icur + 3;
delta_V1_o  = X(icur:icur+3-1)/ratio  ; icur = icur + 3;
delta_V0_r  = X(icur:icur+3-1)/ratio  ; icur = icur + 3;
delta_V1_r  = X(icur:icur+3-1)/ratio  ; icur = icur + 3;

[~, ~, delta_Vf_o, delta_Vf_r] = total_impulse_nonlcon(X, xOrb_epoch_t0_Ast, ratio, time_min_on_ast, time_max_on_ast, destination);

if Sansmax
  delta_V_r     = norm(delta_Vf_r) + norm(delta_V1_r) + norm(delta_V0_r);
  delta_V_o     = norm(delta_Vf_o) + norm(delta_V1_o) + norm(delta_V0_o);
else
  delta_V_r     = norm(delta_Vf_r) + norm(delta_V1_r) + 0.5*max(0e-12, norm(delta_Vf_r) - UC.v0AUJour);
  delta_V_o     = norm(delta_Vf_o) + norm(delta_V1_o) + 0.5*max(0e-12, norm(delta_Vf_o) - UC.v0AUJour);
end

delta_V       = delta_V_o +delta_V_r;
%F               = scaling*(norm(delta_V0_r)^2  + norm(delta_V1_r)^2 + max_delta_V_r^2 + max_delta_V_o^2 + norm(delta_V1_o)^2 + norm(delta_Vf_o)^2);
F               = delta_V;

return
