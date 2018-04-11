function [cin, ceq, delta_Vf_r_L2] = return_impulse_nonlcon_L2(X, xOrb_epoch_t0_Ast, ratio)

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
% Constraint: qf = state of the EMB at time t0_r + dt1_r + dtf_r
% EMB's state at time t0_r + dt1_r + dtf_r
xOrb_epoch_t0_EMB   = get_EMB_init_Orbital_elements();
final_state_EMB     = get_Current_State_Cart(xOrb_epoch_t0_EMB, t0_r + dt1_r + dtf_r);

% Moon's & L2's state in EMB, LD
[qM, ~, qL2_EMB_LD] = get_Moon_Earth_L2_State_Cart_LD(t0_r + dt1_r + dtf_r);
% EMB's state in SUN, LD
qEMB_SUN_LD = final_state_EMB(:);
% L2's state in SUN, AU
qL2_SUN_AU = qEMB_SUN_LD(:) + qL2_EMB_LD(:)*UC.LD/UC.AU;

% Final boost for L2
delta_Vf_r_L2       = qL2_SUN_AU(4:6) - qf(4:6);

% ------------------------------------------------------------------------------
%Constraint: start from the Moon orbital plane
% final velocity in EMB centric inertial
%vf_EMB = delta_Vf_r*UC.AU/UC.LD; % = (xC0(4:6)-xEMB0(4:6))*AU/LD;

% L2's velocity in EMB centric inertial
vf_L2 = delta_Vf_r_L2*UC.AU/UC.LD;

% Normal to Moon's orbital plane in EMB centric
normal = cross(qM(1:3),qM(4:6));

% ------------------------------------------------------------------------------
ceq     = [qf(1:3) - qL2_SUN_AU(1:3); vf_L2'*normal];
cin     = [];

return
