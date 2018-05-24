function [cin, ceq, delta_Vf_r] = return_impulse_nonlcon(X, xOrb_epoch_t0_Ast, ratio, destination)

UC          = get_Univers_Constants(); % Univers constants

%
icur        = 1;
t0_r        = X(icur)           ; icur = icur + 1; % initial time for the impulse return manoeuver
dt1_r       = X(icur)           ; icur = icur + 1; % time of the second boost
dtf_r       = X(icur)           ; icur = icur + 1; % final time when we meet the EMB
delta_V0_r  = X(icur:icur+3-1)/ratio  ; icur = icur + 3; % first boost at time t0_r
delta_V1_r  = X(icur:icur+3-1)/ratio  ; icur = icur + 3; % second boost at time t0_r + dt1_r

% ------------------------------------------------------------------------------
% get Asteroid state at time t0_r
initial_state_Ast   = get_Current_State_Cart(xOrb_epoch_t0_Ast, t0_r);

% state of the spacecraft at t0_r
q0      = initial_state_Ast(:);

% first boost
q0(4:6) = q0(4:6)+delta_V0_r(:);

% State at t0 + dt1_o
xOrb    = Cart2Orb(UC.mu0SunAU, q0);
q1      = get_Current_State_Cart(xOrb, dt1_r);

% Second boost
q1(4:6) = q1(4:6)+delta_V1_r(:);

% State at t0 + dt1_o + dtf_o
xOrb    = Cart2Orb(UC.mu0SunAU, q1);
qf      = get_Current_State_Cart(xOrb, dtf_r);

% ------------------------------------------------------------------------------
% Constraint: qf = state of the destination at time t0_r + dt1_r + dtf_r

xOrb_epoch_t0_EMB   = get_EMB_init_Orbital_elements(); % EMB's state at time t0_r + dt1_r + dtf_r
final_state_EMB     = get_Current_State_Cart(xOrb_epoch_t0_EMB, t0_r + dt1_r + dtf_r); % Heliocentric referentiel (AU)

% Moon's & L2's state in EMB, LD
[qM, ~, qL2_EMB_LD] = get_Moon_Earth_L2_State_Cart_LD(t0_r + dt1_r + dtf_r);

if strcmp(destination, 'EMB')
  % Final boost for EMB
  delta_Vf_r    = final_state_EMB(4:6) - qf(4:6);
elseif strcmp(destination, 'L2')
  % L2's state in SUN, AU
  qL2_SUN_AU    = final_state_EMB(:) + qL2_EMB_LD(:)*UC.LD/UC.AU;
  % Final boost for L2
  delta_Vf_r    = qL2_SUN_AU(4:6) - qf(4:6);
else
  error('Wrong destination name !');
end

% ------------------------------------------------------------------------------
%Constraint: start from the Moon orbital plane
% final velocity in EMB centric inertial
vf = delta_Vf_r*UC.AU/UC.LD; % = (xC0(4:6)-xEMB0(4:6))*AU/LD;

% Normal to Moon's orbital plane in EMB centric
normal = cross(qM(1:3),qM(4:6));

% ------------------------------------------------------------------------------
if strcmp(destination, 'EMB')
  ceq     = [qf(1:3) - final_state_EMB(1:3); vf'*normal];

elseif strcmp(destination, 'L2')
  ceq     = [qf(1:3) - qL2_SUN_AU(1:3); vf'*normal];
else
  error('Wrong destination name !');
end
cin     = [];

return
