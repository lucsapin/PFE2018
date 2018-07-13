function Lf = drift_L(dt,xGauss,mu0)
    % remove full revolutions
    a = xGauss(1)/(1-xGauss(2)^2-xGauss(3)^2);
    T = real(2*pi*sqrt(a^3/mu0)); % Orbit period
    dt = mod(dt,T);
    if (abs(dt) > 1.e-14)
        % integrate remaining revolution
        L0 = xGauss(6);
        OptionsOde = odeset('AbsTol',1.e-12,'RelTol',1.e-12);
        [~,L] = ode45(@rhsLGauss,[0;dt/2;dt],L0,OptionsOde,xGauss,mu0);
        Lf = L(3);
    else
        Lf = xGauss(6);
    end;
