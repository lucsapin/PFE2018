function [cin, ceq, delta_Vf_o, delta_Vf_r] = total_impulse_nonlcon(X, xOrb_epoch_t0_Ast, ratio, time_min_on_ast, time_max_on_ast, destination)

UC          = get_Univers_Constants(); % Univers constants

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

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% Outbound
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
departure = destination;
% get EMB state at time t0
xOrb_epoch_t0_EMB   = get_EMB_init_Orbital_elements();
initial_state_EMB   = get_Current_State_Cart(xOrb_epoch_t0_EMB, t0_o);
% get Moon's and L2's state at time t0
[qM0, ~, qL2_EMB_LD_t0] = get_Moon_Earth_L2_State_Cart_LD(t0_o);
qL2_SUN_AU_t0 = initial_state_EMB + qL2_EMB_LD_t0*UC.LD/UC.AU;

if strcmp(departure, 'EMB')
  % state of the spacecraft at t0
  q0      = initial_state_EMB(:);
elseif strcmp(departure, 'L2')
  % state of the spacecraft at t0
  q0      = qL2_SUN_AU_t0(:);
else
  error('Wrong departure name');
end

% first boost
q0(4:6) = q0(4:6)+delta_V0_o(:);

% State at t0 + dt1_o
xOrb    = Cart2Orb(UC.mu0SunAU, q0);
q1      = get_Current_State_Cart(xOrb, t0_o + dt1_o);

% Second boost
q1(4:6) = q1(4:6)+delta_V1_o(:);

% State at t0 + dt1_o + dtf_o
xOrb    = Cart2Orb(UC.mu0SunAU, q1);
qf      = get_Current_State_Cart(xOrb, t0_o + dt1_o + dtf_o);

% ------------------------------------------------------------------------------
% Constraint: qf = state of the asteroid at time t0 + dt1_o + dtf_o
% asteroid's state at time t0 + dt1_o + dtf_o
tf_o            = t0_o + dt1_o + dtf_o;
final_state_Ast_o = get_Current_State_Cart(xOrb_epoch_t0_Ast, tf_o);

% Final boost
delta_Vf_o      = final_state_Ast_o(4:6)-qf(4:6);

spacecraft_qf_o = qf;

% ------------------------------------------------------------------------------
% Constraint: start from the Moon orbital plane
% initial velocity in EMB centric inertial
v0 = delta_V0_o*UC.AU/UC.LD; % = (xC0(4:6)-xEMB0(4:6))*AU/LD;

% Normal to Moon's orbital plane in EMB centric
normal_o = cross(qM0(1:3),qM0(4:6));

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% Return
% ------------------------------------------------------------------------------
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
%xOrb_epoch_t0_EMB   = get_EMB_init_Orbital_elements();
tf_r                = t0_r + dt1_r + dtf_r;
final_state_EMB_f   = get_Current_State_Cart(xOrb_epoch_t0_EMB, tf_r);
% Moon's & L2's state in EMB, LD
[qMf, ~, qL2_EMB_LD] = get_Moon_Earth_L2_State_Cart_LD(tf_r);
% L2's state in SUN, AU
qL2_SUN_AU = final_state_EMB_f(:) + qL2_EMB_LD(:)*UC.LD/UC.AU;

if strcmp(destination,'EMB')
  % Final boost
  delta_Vf_r       = final_state_EMB_f(4:6)-qf(4:6);
elseif strcmp(destination, 'L2')
  % Final boost for L2
  delta_Vf_r       = qL2_SUN_AU(4:6) - qf(4:6);
else
  error('Wrong destination name !');
end

spacecraft_qf_r = qf;

% ------------------------------------------------------------------------------
% Constraint: start from the Moon orbital plane
% final velocity in EMB centric inertial
vf = delta_Vf_r*UC.AU/UC.LD; % = (xC0(4:6)-xEMB0(4:6))*AU/LD;

% Normal to Moon's orbital plane in EMB centric
normal_f = cross(qMf(1:3),qMf(4:6));

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% Constraints
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
if strcmp(destination, 'EMB')
  ceq     = [spacecraft_qf_o(1:3) - final_state_Ast_o(1:3);
             v0'*normal_o;
             spacecraft_qf_r(1:3) - final_state_EMB_f(1:3);
             vf'*normal_f];
elseif strcmp(destination,'L2')
  ceq     = [spacecraft_qf_o(1:3) - final_state_Ast_o(1:3);
             v0'*normal_o;
             spacecraft_qf_r(1:3) - qL2_SUN_AU(1:3);
             vf'*normal_f];
else
  error('Wrong destination name !');
end

cin     = [(t0_r-time_max_on_ast)-tf_o; tf_o-(t0_r-time_min_on_ast)];

return
