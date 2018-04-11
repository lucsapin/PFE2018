function [times, states, q0, q1, qf] = get_Trajectory_SpaceCraft(xOrb_epoch_t0_system, t0, dt1, dtf, dV0, dV1, dVf)

UC      = get_Univers_Constants();
times   = [];
states  = [];

% Initial position
q0      = get_Current_State_Cart(xOrb_epoch_t0_system, t0);

% First boost
q0(4:6) = q0(4:6)+dV0(:);
xOrb    = Cart2Orb(UC.mu0SunAU, q0);

nbTime  = 100;
t_deb   = t0;
t_fin   = t0+dt1;
t_span  = linspace(t_deb,t_fin,nbTime);
for i=1:nbTime
    dt  = t_span(i)-t_deb;
    q1  = get_Current_State_Cart(xOrb, dt);
    times   = [times t_span(i)];
    states  = [states q1(:)];
end

% Second boost
q1(4:6) = q1(4:6)+dV1(:);
xOrb    = Cart2Orb(UC.mu0SunAU, q1);

t_deb   = t0+dt1;
t_fin   = t0+dt1+dtf;
t_span  = linspace(t_deb,t_fin,nbTime);
for i=2:nbTime
    dt  = t_span(i)-t_deb;
    qf  = get_Current_State_Cart(xOrb, dt);
    times   = [times t_span(i)];
    states  = [states qf(:)];
end

% Final boost
qf(4:6) = qf(4:6)+dVf(:);

return
