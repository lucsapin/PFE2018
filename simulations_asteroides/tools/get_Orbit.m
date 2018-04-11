function [orbit, period] = get_Orbit(xOrb, period)

% We assume we want the orbital elements in the Heliocentric referentiel
% Only for elliptic trajectories around the Sun

UC          = get_Univers_Constants();
period      = 2*pi*sqrt(xOrb(1)^3/UC.mu0SunAU);   % asteroid's period

% Time interval of trajectories integration
date_deb    = 0.0;
date_fin    = period;
Ndates      = 1001;
times       = linspace(date_deb, date_fin, Ndates);

% Computation of the asteroid's trajectories with ad-hoc formulas
orbit      = [];
for i=1:Ndates
    dt      = times(i);
    [q,nu]  = Orb2Cart_dt(UC.mu0SunAU,xOrb,dt);
    orbit   = [orbit q(:)];
end

%% Computation of the asteroid's trajectory with the 2 bodies dynamics
%options     = odeset('AbsTol',1e-12,'RelTol',1e-8);
%rhsfun      = @RHS_Asteroid;
%tspan       = times;
%par         = [UC.mu0SunAU];
%[ time_out, state_out ]  = exprhsfun(rhsfun, tspan, initial_state_Ast, options, par);
%diff_orbits = norm(qs-state_out)
%
% Display asteroid's trajectory display
%qs          = state_out;
%plot3(qs(1,:), qs(2,:), qs(3,:), 'Color', DC.rouge, 'LineStyle', '--', 'LineWidth', DC.LW); hold on;

return
