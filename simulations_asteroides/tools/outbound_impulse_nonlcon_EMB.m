function [cin, ceq, delta_Vf_o] = outbound_impulse_nonlcon_EMB(X, xOrb_epoch_t0_Ast, ratio, tfmin, tfmax)

UC          = get_Univers_Constants(); % Univers constants

%
icur        = 1;
t0          = X(icur)           ; icur = icur + 1; % initial time for the impulse outbound manoeuver
dt1_o       = X(icur)           ; icur = icur + 1; % time of the second boost
dtf_o       = X(icur)           ; icur = icur + 1; % final time when we meet the asteroid
delta_V0_o  = X(icur:icur+3-1)/ratio  ; icur = icur + 3; % first boost at time t0
delta_V1_o  = X(icur:icur+3-1)/ratio  ; icur = icur + 3; % second boost at time t0 + dt1_o

% ------------------------------------------------------------------------------
% get EMB state at time t0
xOrb_epoch_t0_EMB   = get_EMB_init_Orbital_elements();
initial_state_EMB   = get_Current_State_Cart(xOrb_epoch_t0_EMB, t0);

% state of the spacecraft at t0
q0      = initial_state_EMB(:);

% first boost
q0(4:6) = q0(4:6)+delta_V0_o(:);

% State at t0 + dt1_o
xOrb    = Cart2Orb(UC.mu0SunAU, q0);
q1      = get_Current_State_Cart(xOrb, dt1_o);

% Second boost
q1(4:6) = q1(4:6)+delta_V1_o(:);

% State at t0 + dt1_o + dtf_o
xOrb    = Cart2Orb(UC.mu0SunAU, q1);
qf      = get_Current_State_Cart(xOrb, dtf_o);

% ------------------------------------------------------------------------------
% Constraint: qf = state of the asteroid at time t0 + dt1_o + dtf_o
% asteroid's state at time t0 + dt1_o + dtf_o
tf              = t0+dt1_o+dtf_o;
final_state_Ast = get_Current_State_Cart(xOrb_epoch_t0_Ast, tf);

% Final boost
delta_Vf_o      = final_state_Ast(4:6)-qf(4:6);

% ------------------------------------------------------------------------------
% Constraint: start from the Moon orbital plane
% initial velocity in EMB centric inertial
v0_EMB = delta_V0_o*UC.AU/UC.LD; % = (xC0(4:6)-xEMB0(4:6))*AU/LD;

% Moon's state in EMB
[qM, ~, ~] = get_Moon_Earth_L2_State_Cart_LD(t0);

% Normal to Moon's orbital plane in EMB centric
normal = cross(qM(1:3),qM(4:6));

% ------------------------------------------------------------------------------
ceq     = [qf(1:3) - final_state_Ast(1:3); v0_EMB'*normal];
cin     = [tfmin - tf; tf - tfmax ];

return
