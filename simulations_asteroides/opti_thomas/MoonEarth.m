function [qM,qE] = MoonEarth(t)
  % Returns Moon (qM) and Earth (qE) cartesian coordinates with respect to EMB 
  % in the Heliocentric Ecliptic inertial frame
  % Units are LD and day
    constantes;
    % Get Moon's and Earth's state at time epoch0+t
    tau = t;
    mu = mu0_Moon/(mu0_Moon+mu0_Earth);
    rM = (1-mu);
    nu = mod(nu_Moon0 + tau*speed_Moon,2*pi);
    nu_dot = speed_Moon;
    Omega_dot = Noeud_Moon_dot;
    Omega = mod(Noeud_Moon0+tau*Noeud_Moon_dot,2*pi);
    cn = cos(nu); sn = sin(nu);
    ci = cos(i_Moon); si = sin(i_Moon);
    cO = cos(Omega); sO = sin(Omega);
    qM = rM*[cn*cO-ci*sn*sO;...
        cn*sO+ci*cO*sin(nu);...
        si*sn;...
        -nu_dot*sn*cO-Omega_dot*cn*sO-nu_dot*ci*cn*sO - Omega_dot*ci*sn*cO;...
        -nu_dot*sn*sO+Omega_dot*cn*cO-Omega_dot*ci*sO*sn+nu_dot*ci*cO*cn;...
        nu_dot*si*cn];
    qE = -mu/(1-mu)*qM;
end
