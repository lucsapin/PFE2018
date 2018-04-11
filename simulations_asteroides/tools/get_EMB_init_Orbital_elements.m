function xOrb = get_EMB_init_Orbital_elements()

% We assume we want the orbital elements in the Heliocentric referentiel

% a     = semi-major axis,
% e     = eccentricity,
% i     = inclination w.r.t ecliptic plane
% Omega = Ascending Node Longitude,
% Argpe = argument of perihelion,
% nu0   = true anomaly at time t

% EMB's orbital elements at Epoch_t0

a       = 1.000004444118239; % AU
e       = 0.016694896378168;
i       = 0.0;
Omega   = 0.0;
Argpe   = 1.798669025532871; % radian
nu0     = 6.224355095006212; % radian

xOrb    = [a e i Omega Argpe nu0]';

%% Get the orbital elements at time dt
%xC      = Orb2Cart(UC.mu0SunAU,xOrb);
%%[xC,nu] = Orb2Cart_dt(UC.mu0SunAU,xOrb,dt);
%xOrb    = Cart2Orb(UC.mu0SunAU,xC);

return
