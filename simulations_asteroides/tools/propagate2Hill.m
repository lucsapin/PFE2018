function [times_out, traj_out, time_Hill, state_Hill, xC_EMB_HIll, flag, states, states_q_L1, states_q_L2, dist2Hill] = propagate2Hill(outputTotalOpti, dist)

% state_Hill : centré au soleil
%
% dist in AU : we stop the integration when the spacecraft is at a distance dist from EMB
%

time_Hill   = 0;
state_Hill  = [];
xC_EMB_HIll = [];
flag        = -1;

% ----------------------------------------------------------------------------------------------------
% DC          = get_Display_Constants(); % Display constants
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

[~, states, ~, ~, ~] = get_Trajectory_SpaceCraft(xOrb_epoch_t0_Ast, t0_r, dt1_r, dtf_r, dV0_r, dV1_r, dVf_r);

% ----------------------------------------------------------------------------------------------------
% Get initial point on the asteroid
%
q0                  = get_Current_State_Cart(xOrb_epoch_t0_Ast, t0_r);
q0(4:6)             = q0(4:6) + dV0_r(:);

% On integre le systeme jusqu'au temps t0_r + dt1_r
%
xOrb_epoch_t0_EMB   = get_EMB_init_Orbital_elements();
xC_EMB              = get_Current_State_Cart(xOrb_epoch_t0_EMB, t0_r);
xG_EMB              = Cart2Gauss(UC.mu0SunAU, xC_EMB);
state_q_L_init      = [q0; xG_EMB(6)];

% With dynamics with Sun-Earth-Moon
odefun_event        = @(t,x) HillTouch(t, x, UC.mu0SunAU, xG_EMB, dist);
OptionsOde          = odeset('Events', odefun_event, 'AbsTol', 1.e-12, 'RelTol', 1.e-12);
%odefun              = @(t,x) rhs_4B_Sun_AU(t, x);
odefun              = @(t,x) rhs_SEMB_Sun(t, x);

%ii                  = find(times<=t0_r+dt1_r);
%[times, states_q_L, time_event, state_q_L_event] = ode45(odefun, times(ii), state_q_L_init, OptionsOde);

[times, states_q_L, time_event, ~] = ode45(odefun, [t0_r t0_r+dt1_r], state_q_L_init, OptionsOde);
times       = times(:)';
states_q_L1  = transpose(states_q_L);

times_out   = times;
traj_out    = states_q_L1(1:7,:);

if(~isempty(time_event))
    error('We reach the required distance to EMB at time t0_r + dt1_r!');
end

% Second boost !
q1          = states_q_L1(1:6,end);
q1(4:6)     = q1(4:6) + dV1_r(:);
state_q_L_init  = [q1; states_q_L1(7,end)];

[times, states_q_L, time_event, state_q_L_event] = ode45(odefun, [t0_r+dt1_r t0_r+dt1_r+dtf_r], state_q_L_init, OptionsOde);
times       = times(:)';
states_q_L2  = transpose(states_q_L);


times_out   = [times_out    times(2:end)];
traj_out    = [traj_out     states_q_L2(1:7,2:end)];

if(~isempty(time_event))
    state_q_L_event = state_q_L_event(:);
    time_Hill   = time_event;
    state_Hill  = state_q_L_event(1:6);
    L_EMB       = state_q_L_event(7);
    xC_EMB_HIll = Gauss2Cart(UC.mu0SunAU, [xG_EMB(1:5); L_EMB]);
    flag    = 1;
end

% ----------------------------------------------------------------------------------------------------
% On affiche la distance à la sphère de Hill en fonction du temps
d=zeros(1, length(times_out));
for i=1:length(times_out)
    [value, ~, ~] = HillTouch(times_out(i), traj_out(:,i), UC.mu0SunAU, xG_EMB, dist);
    d(i) = value;
end

dist2Hill = d;



return

% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------
function [value,isterminal,direction] = HillTouch(t, x, mu0_Sun, xG_EMB, dist)
    L_EMB       = x(7);
    qEMB        = Gauss2Cart(mu0_Sun, [xG_EMB(1:5); L_EMB]);
    r           = x(1:3);
    value       = norm(r-qEMB(1:3),2)-dist;
    isterminal  = 1;   % Stop the integration
    direction   = -1;
return

% ----------------------------------------------------------------------------------------------------
% dynamics of body and Earth-Moon barycenter longitude. Body is subjected
% to Sun and EMB gravities (so Moon ~included). In Heliocentric ecliptic
function xdot = rhs_SEMB_Sun(t, x)

    UC      = get_Univers_Constants();

    mu0_Sun = UC.mu0SunAU;
    xG_EMB  = UC.xG_EMB0;
    mu0_EMB = UC.mu0EMBAU;

    r       = x(1:3);
    v       = x(4:6);
    L_EMB   = x(7);
    Ldot    = rhsLGauss(t, L_EMB, xG_EMB, mu0_Sun);
    x_EMB   = Gauss2Cart(mu0_Sun,[xG_EMB(1:5);L_EMB]);
    r_EMB   = x_EMB(1:3);
    xdot    = [v; -mu0_Sun*r/norm(r,2)^3 - 1.0*mu0_EMB*(r-r_EMB)/norm(r-r_EMB,2)^3; Ldot];
return

% ----------------------------------------------------------------------------------------------------
function qLdot = rhs_4B_Sun_AU(t, qL)
    % dans ref inertiel centre soleil
    % Be careful, the dynamics is not autonomous!!

    UC          = get_Univers_Constants(); % Univers constants

    mu0_Sun     = UC.mu0SunAU;
    mu0_Earth   = UC.mu0EarthAU;
    mu0_Moon    = UC.mu0MoonAU;

    xG_EMB0_AU  = UC.xG_EMB0;
    xG_EMB      = xG_EMB0_AU;

    %
    r           = qL(1:3);
    v           = qL(4:6);
    L_EMB       = qL(7);
    Ldot        = rhsLGauss(t,L_EMB,xG_EMB,mu0_Sun);
    qS          = -Gauss2Cart(mu0_Sun, [xG_EMB(1:5); L_EMB]); % Dans le repere inertiel centre EMB

    % Moon and Earth position
    [qM,qE]     = get_Moon_Earth_State_Cart_LD(t);  % Dans ref centre EMB
    qM          = qM*UC.LD/UC.AU;
    qE          = qE*UC.LD/UC.AU;

    % Replace the position in the frame centered in the Sun
    qS(1:3)     = qS(1:3) - qS(1:3);
    qM(1:3)     = qM(1:3) - qS(1:3);
    qE(1:3)     = qE(1:3) - qS(1:3);

    rSun        = sqrt((r(1)-qS(1))^2 + (r(2)-qS(2))^2 + (r(3)-qS(3))^2);
    rE          = sqrt((r(1)-qE(1))^2 + (r(2)-qE(2))^2 + (r(3)-qE(3))^2);
    rM          = sqrt((r(1)-qM(1))^2 + (r(2)-qM(2))^2 + (r(3)-qM(3))^2);

    % Dynamics
    qLdot       = zeros(7,1);
    qLdot(1:3)  = v;
    qLdot(4:6)  = -mu0_Sun*(r-qS(1:3))/rSun^3 - mu0_Earth*(r-qE(1:3))/rE^3 - mu0_Moon*(r-qM(1:3))/rM^3; % ...
                  +mu0_Earth*(qS(1:3)-qE(1:3))/norm(qS(1:3)-qE(1:3))^3 + mu0_Moon*(qS(1:3)-qM(1:3))/norm(qS(1:3)-qM(1:3))^3 ;
    qLdot(7)    = Ldot;

return
