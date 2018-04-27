function [qCR3BP,qEMB,qM,qE,theta_Sun] = Helio2CR3BP(q,t,xG_EMB)
% Convert the state q expressed in Heliocentric Ecliptic Inertial Frame
% into this state in the CR3BP rotating reference frame. Also return EMB
% (resp. Earth and Moon) Heliocentric (resp. EMB centric) states at the
% given time 't' (in days)
%   Inputs:
%       q = (position/velocity) in Heliocentric Ecliptic Inertial (AU,AU/d)
%       t = time (after 01/01/2028) at which the convertion has to be made
%       xG_EMG = Gauss coordinates of EMB on (01/01/2028) in AU
%   Output:
%       qCR3BP = (position/velocity) in CR3BP rotating frame (LD,
%           LD/time_syst)
%       qEMB = (position/velocity) of EMB in Heliocentric (LD,LD/d)
%       qM = (position/velocity) of Moon in EMB inertial (LD,LD/d)
%       qE = (position/velocity) of Earth in EMB inertial (LD,LD/d)

    UC          = get_Univers_Constants();

    if (nargin < 3)
        xG_EMB = UC.xG_EMB0;
        xG_EMB(1) = xG_EMB(1)*UC.AU/UC.LD; % En LD
    end

    [qEMB, qM, qE, theta_Sun] = EMBstates(t, xG_EMB); % Tout en LD

    % Convert q to EMB centric and (LD,LD/d)
    q       = q*UC.AU/UC.LD - qEMB;
    cT      = (UC.jour/UC.time_syst); % time conversion
    Ox      = qM(1:3)/norm(qM(1:3),2);
    Oz      = cross(qM(1:3),qM(4:6)); Oz = Oz/norm(Oz,2);
    Oy      = cross(Oz,Ox); Oy = Oy/norm(Oy,2); % normalisation not really needed
    M       = [Ox'; Oy'; Oz']; % change of ccordinates matrix
    rCR3BP  = M*q(1:3);
    vCR3BP  = 1/cT*M*q(4:6)-cross([0;0;1],rCR3BP);
    qCR3BP  = [rCR3BP; vCR3BP];

end

