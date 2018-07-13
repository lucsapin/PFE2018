% Units and gravity constants
mu0_Sun = 132712440018; % km^3/s^2
mu0_Earth = 398600.4418; %km^3/s^2
mu0_Moon = 4902.7779; % km^3/s^2
mu0_EMB = mu0_Earth+mu0_Moon; % km^3/s^2
mu = mu0_Moon/(mu0_Earth+mu0_Moon); % EM-CR3BP parameter

AU = 149597870.7; % km
LD = 384400; % km
jour = 3600*24; % seconds in a day

mu0_Sun = mu0_Sun/AU^3*jour^2; % in AU^3/day^2
mu0_Earth = mu0_Earth/AU^3*jour^2; % in AU^3/day^2
mu0_Moon = mu0_Moon/AU^3*jour^2; % in AU^3/day^2
mu0_EMB = mu0_EMB/AU^3*jour^2; % in AU^3/day^2

Epoch_t0 = 61771; % 01/01/2028 at 0:00 of JMD

%% EMB's orbital elements at Epoch_t0
xG_EMB0 = [0.999725723314499; -0.00377147271186; 0.016263319423213;...
    0.; 0.;1.739838813359497];

%% Moon in EMB frame (axis parallel to Heliocentric ecliptic), from JPL (MoonElement.m)
% motion is assumed circular with Earth to Moon distance = LD and
% Earth circular motion
r_Moon = (1-mu)*LD;
period_Moon = 2361000/jour; % jour or 27.326388888888889
speed_Moon = 2*pi/period_Moon; % rad/jour
i_Moon = 0.089884456477708; % rad
Noeud_Moon0 = -0.992559541384275; % rad
Noeud_Moon_dot = -0.000924945038810; %rad/jour 
% => Noeud_Moon(t) = Noeud_Moon0 + t*Noeud_Moon_dot
nu_Moon0 = 0.407422649915963;

%% The Sample Asteroid (no. ?)
% Asteroid's (no. 1) orbital elements at Epoch_t0
% a_A = 1.021489281928; % AU e_A = 0.19544556093290; i_A = 1.398188196278*pi/180;
xG_A0 = [0.982469446262206; -0.005487931946876; -0.195368497694286; ...
  -0.002495137049363; -0.011944267214153; 0.621124066365539];

%% Constants for Earth-Moorn RC3BP
dist_syst = LD*1e3; % m
period_syst = 2.361e6; % s*rad.
time_syst = period_syst/(2*pi); % s
speed_syst = dist_syst/(time_syst); % m/s

% L_i coordinates computed with Li_compute (in "~/Documents/Recherche/04-TroisCorps/03-NASA_Proposal/Numerics/BCR4BP/CR3BP")
xL1 = 0.836915401990301;
xL2 = 1.155681950839609;
xL3 = -1.005062622562382;
xL4 = 0.487849481112747; yL4 =  0.866025397589986;
xL5 = 0.487849481112747; yL5 = -0.866025397589986;

% Halo states
q_Halo_L2 = [1.119353017735519 0 0.011933614199998 0 0.179037935127886 0]';
