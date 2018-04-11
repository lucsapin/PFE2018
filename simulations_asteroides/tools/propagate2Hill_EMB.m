function [times_out, traj_out, time_Hill, state_Hill, xC_EMB_HIll, flag, hFigSpace_r] = propagate2Hill_EMB(outputTotalOpti, dist)

% state_Hill : centré au soleil
%
% dist in AU : we stop the integration when the spacecraft is at a distance dist from EMB
%

times_out   = [];
traj_out    = [];
traj_out_EMB= [];
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
numAsteroid         =   outputTotalOpti.numAsteroid ;
dVmax               =   outputTotalOpti.dVmax       ;
ratio               =   outputTotalOpti.ratio       ;
LB                  =   outputTotalOpti.LB          ;
UB                  =   outputTotalOpti.UB          ;
X0                  =   outputTotalOpti.X0          ;
Xsol                =   outputTotalOpti.Xsol        ;
t0_o                =   outputTotalOpti.t0_o        ;
dt1_o               =   outputTotalOpti.dt1_o       ;
dtf_o               =   outputTotalOpti.dtf_o       ;
t0_r                =   outputTotalOpti.t0_r        ;
dt1_r               =   outputTotalOpti.dt1_r       ;
dtf_r               =   outputTotalOpti.dtf_r       ;
dV0_o               =   outputTotalOpti.dV0_o       ;
dV1_o               =   outputTotalOpti.dV1_o       ;
dV0_r               =   outputTotalOpti.dV0_r       ;
dV1_r               =   outputTotalOpti.dV1_r       ;
dVf_o               =   outputTotalOpti.dVf_o       ;
dVf_r               =   outputTotalOpti.dVf_r       ;
delta_V             =   outputTotalOpti.delta_V     ;
delta_V_o           =   outputTotalOpti.delta_V_o   ;
delta_V_r           =   outputTotalOpti.delta_V_r   ;
Fsol                =   outputTotalOpti.Fsol        ;
exitflag            =   outputTotalOpti.exitflag    ;
output              =   outputTotalOpti.output      ;

duration_o          = dt1_o + dtf_o;
duration_r          = dt1_r + dtf_r;
tf_o                = t0_o + dt1_o + dtf_r;
tf_r                = t0_r + dt1_r + dtf_r;

% ----------------------------------------------------------------------------------------------------
% Display trajectory to compare
%
hFigSpace_r = figure('DefaultAxesColor', DC.blanc, 'Units', 'normalized');
set(hFigSpace_r, 'OuterPosition', [ 0.0   0.0   0.49   0.45 ]); hold on; %axis equal;

[times, states, q0, q1, qf] = get_Trajectory_SpaceCraft(xOrb_epoch_t0_Ast, t0_r, dt1_r, dtf_r, dV0_r, dV1_r, dVf_r);

display_Trajectory_Spacecraft(hFigSpace_r, states, 'return_compare');

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
odefun              = @(t,x) rhs_4B_EMB_AU(t, x);

% -----------------------
% SUN 2 EMB
%
xG_EMB0_AU          = UC.xG_EMB0;
L_EMB0_AU           = drift_L(t0_r, xG_EMB0_AU, UC.mu0SunAU);
qS                  = -Gauss2Cart(UC.mu0SunAU, [xG_EMB0_AU(1:5); L_EMB0_AU]); % Dans le repere inertiel centre EMB
state_q_L_init_EMB  = [];
state_q_L_init_EMB  = state_q_L_init(1:6) + qS(1:6);
state_q_L_init_EMB(7) = state_q_L_init(7);

[times, states_q_L, time_event, state_q_L_event] = ode45(odefun, [t0_r t0_r+dt1_r], state_q_L_init_EMB, OptionsOde);
times       = times(:)';
states_q_L  = transpose(states_q_L);

% EMB 2 SUN
L_EMB = states_q_L(7,:);
for i = 1:length(times)
    qS                  = -Gauss2Cart(UC.mu0SunAU, [xG_EMB0_AU(1:5); L_EMB(i)]); % Dans le repere inertiel centre EMB
    states_q_L(1:6,i)   = states_q_L(1:6,i) - qS(1:6);
end;

% -----------------------
%

display_Trajectory_Spacecraft(hFigSpace_r, states_q_L, 'return');

times_out   = times;
traj_out    = states_q_L(1:7,:);

if(~isempty(time_event))
    error('We reach the required distance to EMB at time t0_r + dt1_r!');
end;

% Second boost !
q1          = states_q_L(1:6,end);
q1(4:6)     = q1(4:6) + dV1_r(:);
state_q_L_init  = [q1; states_q_L(7,end)];

% -----------------------
% SUN 2 EMB
%
xG_EMB0_AU          = UC.xG_EMB0;
L_EMB0_AU           = drift_L(t0_r+dt1_r, xG_EMB0_AU, UC.mu0SunAU);
qS                  = -Gauss2Cart(UC.mu0SunAU, [xG_EMB0_AU(1:5); L_EMB0_AU]); % Dans le repere inertiel centre EMB
state_q_L_init_EMB  = [];
state_q_L_init_EMB  = state_q_L_init(1:6) + qS(1:6);
state_q_L_init_EMB(7) = state_q_L_init(7);

[times, states_q_L, time_event, state_q_L_event] = ode45(odefun, [t0_r+dt1_r t0_r+dt1_r+dtf_r], state_q_L_init_EMB, OptionsOde);
times       = times(:)';
states_q_L  = transpose(states_q_L);
state_q_L_event = state_q_L_event(:);

% EMB 2 SUN
L_EMB = states_q_L(7,:);
for i = 1:length(times)
    qS                  = -Gauss2Cart(UC.mu0SunAU, [xG_EMB0_AU(1:5); L_EMB(i)]); % Dans le repere inertiel centre EMB
    states_q_L(1:6,i)   = states_q_L(1:6,i) - qS(1:6);
end;

% -----------------------
%

display_Trajectory_Spacecraft(hFigSpace_r, states_q_L, 'return');

times_out   = [times_out    times(2:end)];
traj_out    = [traj_out     states_q_L(1:7,2:end)];

times(end)
states_q_L(:,end)

if(~isempty(time_event))
    % EMB 2 SUN
    qS                  = -Gauss2Cart(UC.mu0SunAU, [xG_EMB0_AU(1:5); state_q_L_event(7)]); % Dans le repere inertiel centre EMB
    state_q_L_event(1:6)= state_q_L_event(1:6) - qS(1:6);
    %
    time_Hill           = time_event;
    state_Hill          = state_q_L_event(1:6);
    L_EMB               = state_q_L_event(7);
    xC_EMB_HIll         = Gauss2Cart(UC.mu0SunAU, [xG_EMB(1:5); L_EMB]);
    flag                = 1;
    [value,isterminal,direction] = HillTouch_SUN(time_Hill, [state_Hill; L_EMB], UC.mu0SunAU, xG_EMB, dist)
end;

% ----------------------------------------------------------------------------------------------------
% On affiche la distance en fonction du temps
d=[];
for i=1:length(times_out)
    [value,isterminal,direction] = HillTouch_SUN(times_out(i), traj_out(:,i), UC.mu0SunAU, xG_EMB, dist);
    d(i) = value;
end;

hFig = figure('Units', 'normalized');
set(hFig, 'OuterPosition', [ 0.0   0.5   0.49   0.45 ]); hold on; %axis equal;

plot(times_out, d);

return

% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------
function [value,isterminal,direction] = HillTouch(t, x, mu0_Sun, xG_EMB, dist)
%    L_EMB       = x(7);
%    qEMB        = Gauss2Cart(mu0_Sun, [xG_EMB(1:5); L_EMB]);
    r           = x(1:3);
%    value       = norm(r-qEMB(1:3),2)-dist;
    value       = norm(r,2)-dist;
    isterminal  = 1;   % Stop the integration
    direction   = -1;
return

% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------
function [value,isterminal,direction] = HillTouch_SUN(t, x, mu0_Sun, xG_EMB, dist)
    L_EMB       = x(7);
    qEMB        = Gauss2Cart(mu0_Sun, [xG_EMB(1:5); L_EMB]);
    r           = x(1:3);
    value       = norm(r-qEMB(1:3),2)-dist;
    isterminal  = 1;   % Stop the integration
    direction   = -1;
return

% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------
%% dynamics of body and Earth-Moon barycenter longitude. Body is subjected 
% to Sun and EMB gravities (so Moon ~included). In Heliocentric ecliptic
function xdot = rhs_SEMB_Sun(t, x, mu0_Sun, xG_EMB, mu0_EMB)
    r       = x(1:3);
    v       = x(4:6);
    L_EMB   = x(7);
    Ldot    = rhsLGauss(t, L_EMB, xG_EMB, mu0_Sun);
    x_EMB   = Gauss2Cart(mu0_Sun,[xG_EMB(1:5);L_EMB]);
    r_EMB   = x_EMB(1:3);
    xdot    = [v; -mu0_Sun*r/norm(r,2)^3 - 1.0*mu0_EMB*(r-r_EMB)/norm(r-r_EMB,2)^3; Ldot];
return

% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------
function qLdot = rhs_4B_EMB_AU(t, qL)
    % dans ref inertiel centre EMB
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
    [qM,qE]     = get_Moon_Earth_State_Cart_LD(t); % Dans ref centre EMB en AU
    qM          = qM*UC.LD/UC.AU;
    qE          = qE*UC.LD/UC.AU;

    rSun        = sqrt((r(1)-qS(1))^2 + (r(2)-qS(2))^2 + (r(3)-qS(3))^2);
    rE          = sqrt((r(1)-qE(1))^2 + (r(2)-qE(2))^2 + (r(3)-qE(3))^2);
    rM          = sqrt((r(1)-qM(1))^2 + (r(2)-qM(2))^2 + (r(3)-qM(3))^2);

    % Dynamics
    qLdot       = zeros(7,1);
    qLdot(1:3)  = v;
    qLdot(4:6)  =   - mu0_Sun*(r-qS(1:3))/rSun^3 - mu0_Earth*(r-qE(1:3))/rE^3 - mu0_Moon*(r-qM(1:3))/rM^3 ...
                    - (mu0_Sun/(mu0_Earth+mu0_Moon))* ...
                    (   ...
                            mu0_Earth*(qS(1:3)-qE(1:3))/norm(qS(1:3)-qE(1:3))^3 ...
                        +   mu0_Moon *(qS(1:3)-qM(1:3))/norm(qS(1:3)-qM(1:3))^3 ...
                    );
    qLdot(7)    = Ldot;

return


