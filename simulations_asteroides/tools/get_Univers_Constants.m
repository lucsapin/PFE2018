function UC = get_Univers_Constants()

% Univers constants
UC.AU           = 149597870.7;                      % km = Astronomical unit.
UC.jour         = 86400;                            % On considere 1j = 86400s. Meme si c'est pas toujours vrai, on peut prendre ca comme unite
UC.LD           = 384400;                           % km

% Sun
UC.mu0Sun       = 132712440018;                     % km^3/s^2 = Sun’s gravitational parameter.
UC.mu0SunAU     = UC.mu0Sun*(UC.jour)^2/(UC.AU^3);  % AU^3/jour^2
UC.mu0SunLD     = UC.mu0Sun*(UC.jour)^2/(UC.LD^3);  % LD^3/jour^2
UC.radiusSun    = 695700;                           % km
UC.radiusSunAU  = UC.radiusSun/UC.AU;
UC.radiusSunAU10 = 10*UC.radiusSun/UC.AU;

% Moon
UC.mu0Moon      = 4902.7779;                        % km^3/s^2
UC.mu0MoonAU    = UC.mu0Moon*(UC.jour)^2/(UC.AU^3); % AU^3/jour^2
UC.mu0MoonLD    = UC.mu0Moon*(UC.jour)^2/(UC.LD^3); % LD^3/jour^2
UC.nu0Moon      = 0.407422649915963;
UC.periodMoon   = 2361000/UC.jour;                  % jour or 27.326388888888889
UC.speedMoon    = 2*pi/UC.periodMoon;               % rad/jour
UC.Noeud0Moon   = -0.992559541384275;               % rad
UC.NoeudMoonDot = -0.000924945038810;               % rad/jour
UC.iMoon        = 0.089884456477708;                % rad

% Earth
UC.mu0Earth     = 398600.4418;                      % km^3/s^2
UC.mu0EarthAU   = UC.mu0Earth*(UC.jour)^2/(UC.AU^3);% AU^3/jour^2
UC.mu0EarthLD   = UC.mu0Earth*(UC.jour)^2/(UC.LD^3);% LD^3/jour^2

% EMB
UC.mu0EMB       = UC.mu0Earth+UC.mu0Moon;           % km^3/s^2
UC.mu0EMBAU     = UC.mu0EMB*(UC.jour)^2/(UC.AU^3);  % AU^3/jour^2
UC.xG_EMB0      = [0.999725723314499; -0.00377147271186; 0.016263319423213; 0.; 0.;1.739838813359497];
UC.Period_EMB   = 2*pi*sqrt((UC.xG_EMB0(1)/(1-norm(UC.xG_EMB0(2:3),2)^2)^3)/UC.mu0SunAU);

%
UC.date_epoch_t0= datetime(2028,01,01);
UC.epoch_t0     = 0.0;                              % Epoch_t0 = 01/01/2028, Epoch_t0 = 61771; % 01/01/2028 at 0:00 of JMD
UC.v0AUJour     = 1.73*UC.jour/UC.AU;               % velocity gap below which we assume that a lunar gravity assist will 
                                                    % perform the cis-lunar capture for a zero cost
                                                    %
%
UC.dist_syst    = UC.LD*1e3; % m
UC.period_syst  = 2.361e6; % s*rad.
UC.time_syst    = UC.period_syst/(2*pi); % s
UC.speed_syst   = UC.dist_syst/(UC.time_syst); % m/s

% L_i coordinates computed with Li_compute (in "~/Documents/Recherche/04-TroisCorps/03-NASA_Proposal/Numerics/BCR4BP/CR3BP")
UC.xL1 = 0.836915401990301;
UC.xL2 = 1.155681950839609;
UC.xL3 = -1.005062622562382;
UC.xL4 = 0.487849481112747; UC.yL4 =  0.866025397589986;
UC.xL5 = 0.487849481112747; UC.yL5 = -0.866025397589986;

% Halo states
UC.q_Halo_L2 = [1.119353017735519 0 0.011933614199998 0 0.179037935127886 0]';


return
