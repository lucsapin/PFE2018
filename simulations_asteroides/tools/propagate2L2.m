%%%%% Propagate 2 L2 directly with the 2 Body dynamics on one side,
%%%%% with the Ad Hoc dynamic on the other
function [statesOpti, traj_out, q0, q1, t0_r, dt1_r] = propagate2L2(destination, typeSimu, numAsteroid, numOpti)

% ----------------------------------------------------------------------------------------------------
% Load results of the optimization
outputTotalOpti = loadFile(destination, typeSimu, numAsteroid, numOpti);

% Get initial condition
time_Hill   = 0;
state_Hill  = [];
xC_EMB_HIll = [];
flag        = -1;

% ----------------------------------------------------------------------------------------------------
DC          = get_Display_Constants(); % Display constants
UC          = get_Univers_Constants(); % Univers constants

% get Data
%
xOrb_epoch_t0_Ast   =   outputTotalOpti.xOrb_epoch_t0_Ast;
% numAsteroid         =   outputTotalOpti.numAsteroid ;
% dVmax               =   outputTotalOpti.dVmax       ;
% ratio               =   outputTotalOpti.ratio       ;
% LB                  =   outputTotalOpti.LB          ;
% UB                  =   outputTotalOpti.UB          ;
% X0                  =   outputTotalOpti.X0          ;
% Xsol                =   outputTotalOpti.Xsol        ;
% t0_o                =   outputTotalOpti.t0_o        ;
% dt1_o               =   outputTotalOpti.dt1_o       ;
% dtf_o               =   outputTotalOpti.dtf_o       ;
t0_r                =   outputTotalOpti.t0_r        ;
dt1_r               =   outputTotalOpti.dt1_r       ;
dtf_r               =   outputTotalOpti.dtf_r       ;
% dV0_o               =   outputTotalOpti.dV0_o       ;
% dV1_o               =   outputTotalOpti.dV1_o       ;
dV0_r               =   outputTotalOpti.dV0_r       ;
dV1_r               =   outputTotalOpti.dV1_r       ;
% dVf_o               =   outputTotalOpti.dVf_o       ;
dVf_r               =   outputTotalOpti.dVf_r       ;
% delta_V             =   outputTotalOpti.delta_V     ;
% delta_V_o           =   outputTotalOpti.delta_V_o   ;
% delta_V_r           =   outputTotalOpti.delta_V_r   ;
% Fsol                =   outputTotalOpti.Fsol        ;
% exitflag            =   outputTotalOpti.exitflag    ;
% output              =   outputTotalOpti.output      ;
%
% duration_o          = dt1_o + dtf_o;
% duration_r          = dt1_r + dtf_r;
% tf_o                = t0_o + dt1_o + dtf_r;
% tf_r                = t0_r + dt1_r + dtf_r;

% ----------------------------------------------------------------------------------------------------
% Display trajectory to compare
[timesOpti, states, ~, ~, ~] = get_Trajectory_SpaceCraft(xOrb_epoch_t0_Ast, t0_r, dt1_r, dtf_r, dV0_r, dV1_r, dVf_r);
% COnversion in Rotating frame
for i=1:size(timesOpti, 2)
  [statesOpti(1:6, i)  , ~, ~, ~, ~]  = Helio2CR3BP(states(1:6,i)  , timesOpti(i));
end
% ----------------------------------------------------------------------------------------------------
% Get initial point on the asteroid
% The spacecraft is on the asteroid
q0                  = get_Current_State_Cart(xOrb_epoch_t0_Ast, t0_r); % Heliocentric frame !!
q0(4:6)             = q0(4:6) + dV0_r(:);

% On integre le systeme jusqu'au temps t0_r + dt1_r ie
% jusqu'au 2e boost
xOrb_epoch_t0_EMB   = get_EMB_init_Orbital_elements(); % Heliocentric frame !!
xC_EMB              = get_Current_State_Cart(xOrb_epoch_t0_EMB, t0_r);
xG_EMB              = Cart2Gauss(UC.mu0SunAU, xC_EMB); % Orbital elements
state_q_L_init      = [q0; xG_EMB(6)];

% With dynamics with Sun-Earth-Moon

OptionsOde          = odeset('AbsTol', 1.e-12, 'RelTol', 1.e-12);

odefun              = @(t,x) rhs_2B_Sun_AU(t, x);

[times, states_q_L] = ode45(odefun, [t0_r t0_r+dt1_r], state_q_L_init, OptionsOde);
times       = times(:)';
states_q_L1  = transpose(states_q_L);

times_out   = times;
traj_out    = states_q_L1(1:7,:);

% Second boost !
q1          = states_q_L1(1:6,end);
q1(4:6)     = q1(4:6) + dV1_r(:);
state_q_L_init  = [q1; states_q_L1(7,end)];

[times, states_q_L] = ode45(odefun, [t0_r+dt1_r t0_r+dt1_r+dtf_r], state_q_L_init, OptionsOde);
times       = times(:)';
states_q_L2  = transpose(states_q_L);

times_out   = [times_out    times(2:end)];
traj_out    = [traj_out     states_q_L2(1:7,2:end)];

% Convert from Heliocentric frame to Rotating Frame
for i=1:size(times_out, 2)
  [traj_out(1:6, i), ~, ~, ~, ~]  = Helio2CR3BP(traj_out(1:6,i), times_out(i));
end

% ----------------------------------------------------------------------------------------------------
function qLdot = rhs_2B_Sun_AU(t, qL)
    % dans ref inertiel centre soleil
    % Be careful, the dynamics is not autonomous!!

    UC          = get_Univers_Constants(); % Univers constants

    mu0_Sun     = UC.mu0SunAU;

    xG_EMB      = UC.xG_EMB0;

    %
    r           = qL(1:3);
    v           = qL(4:6);
    L_EMB       = qL(7);
    Ldot        = rhsLGauss(t, L_EMB, xG_EMB, mu0_Sun);
    qS          = -Gauss2Cart(mu0_Sun, [xG_EMB(1:5); L_EMB]); % Dans le repere inertiel centre EMB

    % Replace the position in the frame centered in the Sun
    qS(1:3)     = qS(1:3) - qS(1:3);

    rSun        = sqrt((r(1)-qS(1))^2 + (r(2)-qS(2))^2 + (r(3)-qS(3))^2);

    % Dynamics
    qLdot       = zeros(7,1);
    qLdot(1:3)  = v;
    qLdot(4:6)  = -mu0_Sun*(r-qS(1:3))/rSun^3;
    qLdot(7)    = Ldot;

return
