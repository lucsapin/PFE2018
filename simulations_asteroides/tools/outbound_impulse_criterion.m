function [F, delta_V] = outbound_impulse_criterion(X, xOrb_epoch_t0_Ast, ratio, poids, scaling, destination)

UC          = get_Univers_Constants();

%
icur        = 1;
t0          = X(icur)           ; icur = icur + 1; % initial time for the impulse outbound manoeuver
dt1_o       = X(icur)           ; icur = icur + 1; % time of the second boost
dtf_o       = X(icur)           ; icur = icur + 1; % final time when we meet the asteroid
delta_V0_o  = X(icur:icur+3-1)/ratio  ; icur = icur + 3; % first boost at time t0
delta_V1_o  = X(icur:icur+3-1)/ratio  ; icur = icur + 3; % second boost at time t0 + dt1_o

if strcmp(destination, 'L2')
    [~, ~, delta_Vf_o] = outbound_impulse_nonlcon_L2(X, xOrb_epoch_t0_Ast, ratio, 1, 1); % tfmin and tfmax are not used
elseif strcmp(destination, 'EMB')
    [~, ~, delta_Vf_o] = outbound_impulse_nonlcon_EMB(X, xOrb_epoch_t0_Ast, ratio, 1, 1); % tfmin and tfmax are not used
else
    error('Wrong destination name!');
end

veps        = 1e-12;
max_delta_V = 0.5*sqrt((max(0.0,norm(delta_V0_o)-UC.v0AUJour))^2+veps);

delta_V     = max_delta_V + norm(delta_V1_o) + norm(delta_Vf_o) + poids*(t0 + dt1_o + dtf_o);
%F           = scaling*(max_delta_V^2 + norm(delta_V1_o)^2 + norm(delta_Vf_o)^2) + poids*(t0 + dt1_o + dtf_o);
F           = delta_V + poids*(t0 + dt1_o + dtf_o);

return
