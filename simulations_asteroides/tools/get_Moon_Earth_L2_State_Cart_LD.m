function [qM,qE,qL2] = get_Moon_Earth_L2_State_Cart_LD(t)

    UC          = get_Univers_Constants();

    % Dans le referentiel centre en EMB !

    % Get L2's, Moon's and Earth's states at time t in LD  in EMB inertial 
    % frame !!!!!!!
    tau         = t;

    mu          = UC.mu0MoonAU/(UC.mu0MoonAU+UC.mu0EarthAU);
    rM          = (1-mu);

    nu          = mod(UC.nu0Moon + tau*UC.speedMoon,2*pi);
    nu_dot      = UC.speedMoon;

    Omega_dot   = UC.NoeudMoonDot;
    Omega       = mod(UC.Noeud0Moon+tau*UC.NoeudMoonDot,2*pi);

    i_Moon      = UC.iMoon;

    qM = rM*[cos(nu)*cos(Omega)-cos(i_Moon)*sin(nu)*sin(Omega);...
        cos(nu)*sin(Omega)+cos(i_Moon)*cos(Omega)*sin(nu);...
        sin(i_Moon)*sin(nu);...
        -nu_dot*sin(nu)*cos(Omega)-Omega_dot*cos(nu)*sin(Omega)-nu_dot*cos(i_Moon)*cos(nu)*sin(Omega) - Omega_dot*cos(i_Moon)*sin(nu)*cos(Omega);...
        -nu_dot*sin(nu)*sin(Omega)+Omega_dot*cos(nu)*cos(Omega)-Omega_dot*cos(i_Moon)*sin(Omega)*sin(nu)+nu_dot*cos(i_Moon)*cos(Omega)*cos(nu);...
        nu_dot*sin(i_Moon)*cos(nu)];

    qE = -mu/(1-mu)*qM;
    
    qL2 = UC.xL2/(1-mu)*qM;

end
