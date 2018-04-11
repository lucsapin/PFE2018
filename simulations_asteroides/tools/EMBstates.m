function [qEMB,qM,qE,thetaSun] = EMBstates(t, xG_EMB)
% Copmutes EMB states in Heliocentric Ecliptic inertial (LD,LD/d) along
% with Moon and Earth states in EMB Ecliptic inertial (LD,LD/d). Alos
% computes angle (following Moon's orbital plane) between EMB-Moon and
% EMB-Sun (used for CR3BP approximation)
%   Inputs:
%       t = time (after 01/01/2028) at which the convertion has to be made
%       in day
%       xG_EMG = Gauss coordinates of EMB on (01/01/2028) in AU
%   Output:
%       qEMB = (position/velocity) of EMB in Heliocentric ecliptic (LD,LD/d)
%       qM = (position/velocity) of Moon in EMB ecliptic inertial (LD,LD/d)
%       qE = (position/velocity) of Earth in EMB ecliptic inertial (LD,LD/d)
%       thetaSun = angle between qM(1:3) and -qEMB(1:3) (Sun's position in
%       EMB ecliptic inertial) (radian)

    UC          = get_Univers_Constants();

    if (nargin < 2)
        xG_EMB    = UC.xG_EMB0;
        xG_EMB(1) = xG_EMB(1)*UC.AU/UC.LD;
    end;

    % Get EMB state at time t
    L           = drift_L(t, xG_EMB, UC.mu0SunLD);
    qEMB        = Gauss2Cart(UC.mu0SunLD, [xG_EMB(1:5); L]);

    % Get Moon's and Earth's state at time t
    [qM,qE]     = get_Moon_Earth_State_Cart_LD(t); % dans ref centre EMB en LD
%    qM          = qM*UC.AU/UC.LD;
%    qE          = qE*UC.AU/UC.LD;

    thetaSun    = mod(pi-(UC.nu0Moon+t*UC.speedMoon+UC.Noeud0Moon+t*UC.NoeudMoonDot-L),2*pi);

end
