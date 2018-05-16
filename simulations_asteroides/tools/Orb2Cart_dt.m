function [q,nu] = Orb2Cart_dt(mu0,xOrb,dt)
    % Inputs :
    %   mu0 : gravitational parameters (same units as xOrb and dt)
    %   xOrb : classical orbital elements (a,e,i,Omega,argper,nu) at time 0
    %   dt : time duration at which cartesian coordinates have to be
    %       computed (IN DAYS !!)
    % Outputs :
    %   q : position/velocity at time dt
    %   nu : true anomaly at time dt
    a = xOrb(1); e = xOrb(2); %i = xOrb(3); Omega = xOrb(4);
    %argper = xOrb(5);
    nu0 = xOrb(6);
    % compute mean eccentricity at t0
    % N/B : the real part extraction is for when the orbit is not elliptic,
    % result is then not valid but does not provoke an error
    E0 = atan2(real(sqrt(1-e^2)*sin(nu0)),real(e+cos(nu0)));
    % mean anomaly at time 0
    M0 = E0-e*sin(E0);
    % mean anomaly at time dt
    M = M0 + dt*sqrt(mu0/a^3);
    % mean eccentricity at time dt
    E = M;
    tol = 1.e-12;
    j = 0;
    jMax = 100;
    while (abs(E-e*sin(E)-M) > tol)&&(j<jMax)
        E = E - (E-e*sin(E)-M)/(1-e*cos(E));
        j = j+1;
    end
    if abs(E-e*sin(E)-M) > tol
        fprintf(1,'[Orb2Cart_dt] Could not compute mean eccentricity !\n');
    end
    % true eccentricity at time dt,
    % N/B : the real part extraction is for when the orbit is not elliptic,
    % result is then not valid but does not provoke an error
    nu = 2*atan2(real(sqrt(1+e)*sin(E/2)),real(sqrt(1-e)*cos(E/2)));
    q = Gauss2Cart(mu0,Orb2Gauss([xOrb(1:5);nu]));
end
