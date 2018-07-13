function [z_sol,fval,flag,dV_tot,lambda] = Ast2Halo_min4(xG0,z0)
% computes minimum deltaV 4 impulse rdv from Asteroid to EM-Halo-L2.
    tic;
    
    if (nargin < 2)
        dV1234_0 = 1.e-6*ones(12,1);
        t00 = 7560;
        dt0 = 200;
        dt1 = 40;
        dt2 = 10;
        z0 = [dV1234_0; t00; dt0; dt1; dt2];
    end
    
    T0 = [0;8000];
    DT0 = [1;400];
    DT1 = [1;300];
    DT2 = [1;30];
    dVmax = 1;
    LB = [-dVmax*ones(12,1); T0(1); DT0(1); DT1(1); DT2(1)];
    UB = [dVmax*ones(12,1); T0(2); DT0(2); DT1(2); DT2(2)];

    % options fmincon
    OptionsOptim = optimoptions('fmincon','Algorithm','interior-point',...
            'Display','iter','MaxFunEvals', 1000);
    % 'Algorihm' = 'interior-point' | 'trust-region-reflective' | 'sqp' | 'active-set'

    [z_sol,fval,flag,~,lambda] = fmincon(@(z) (norm(z(1:3),2)+norm(z(4:6),2)+norm(z(7:9),2)+norm(z(10:12),2)),...
        z0,[],[],[],[],LB,UB,@(z) Drift_dVs_Cart_I(z,xG0),OptionsOptim);
    
    AU = 149597870.7; % km
    jour = 3600*24; % seconds in an day
    dV_tot = (norm(z_sol(1:3),2) + norm(z_sol(4:6),2) + norm(z_sol(7:9),2) + norm(z_sol(10:12),2))*AU/jour;
    
    toc
end

function [err_ineq,err_eq,xC0,xC1,xC2] = Drift_dVs_Cart_I(z,xG0,qfCR3BP)

    dV1 = z(1:3); dV2 = z(4:6); dV3 = z(7:9); dV4 = z(10:12);
    t0 = z(13); dt1 = z(14); dt2 = z(15); dt3 = z(16);
    tf = t0+dt1+dt2+dt3; % in days after Epoch_t0 = 01/01/2028

    constantes;
    if (nargin < 3)
        % Get EM-Halo-L2 orbit in Heliocentric reference frame
%         qfCR3BP = [1.119353017735519 0 0.011933614199998 0 0.179037935127886 0]';
        % EMB-L2
        qfCR3BP = [xL2 0 0 0 0 0]';
    end 
    % Cumulative longitude of EMB at t0
    L_EMB0 =  drift_L(t0,xG_EMB0,mu0_Sun); % Cumulative longitude of EMB at t0
    
    %% Get initial state and propagate the impulses
    L0_t0 = drift_L(t0,xG0,mu0_Sun);
    xC_t0 = Gauss2Cart(mu0_Sun,[xG0(1:5);L0_t0]);
    xC0 = xC_t0 + [zeros(3,1);dV1];
    [xC1,L_EMB1] = Drift_CartL(0,dt1,[xC0;L_EMB0],t0);
    xC1 = xC1 + [zeros(3,1);dV2];
    [xC2,L_EMB2] = Drift_CartL(0,dt2,[xC1;L_EMB1],t0+dt1);
    xC2 = xC2 + [zeros(3,1);dV3];
    [xC3,L_EMBf] = Drift_CartL(0,dt3,[xC2;L_EMB2],t0+dt1+dt2);
    xC3 = xC3 + [zeros(3,1);dV4];
    
    %% Get final state
    qEMB = Gauss2Cart(mu0_Sun,[xG_EMB0(1:5);L_EMBf]);
    
    % Get qfCR3BP in Heliocentric reference frame
    qf = CR3BP2EMB(qfCR3BP,L_EMBf,tf); % in Heliocentric and AU, AU/d

    err_eq = (xC3-qf)*AU/LD;

    %% Inequality constraint : thrird boost near Moon for gravity assist
    % Moon's location at third boost
%     [qM2,~] = MoonEarth(t0+dt1+dt2);
%     qEMB2 = Gauss2Cart(mu0_Sun,[xG_EMB0(1:5);L_EMB2]);
%     q2 = (xC2-qEMB2)*AU/LD;
%     dist_min = 0.15; % LD
%     err_ineq = [sum((q2(1:3)-qM2(1:3)).^2)-dist_min^2];
    err_ineq = [];
    
end

function [qf,Lf] = Drift_CartL(t0,dt,qL0,t00)
    OptionsOde = odeset('AbsTol',1.e-8,'RelTol',1.e-8);
    [~,X] = ode45(@rhsCartL,[t0;t0+dt/2;t0+dt],qL0,OptionsOde,t00);
    qf = X(3,1:6)'; Lf = X(3,7);
end

function qLdot = rhsCartL(t,qL,t00)
    constantes;
    r = qL(1:3); v = qL(4:6); L = qL(7);
    
    Ldot = rhsLGauss(t,L,xG_EMB0,mu0_Sun);
    
    qEMB = Gauss2Cart(mu0_Sun,[xG_EMB0(1:5);L]);
    % Get Moon's and Earth's state at time t00+t
    [qM,qE] = MoonEarth(t00+t);
    qM = (qM*LD/AU+qEMB);
    qE = (qE*LD/AU+qEMB);
    
    vdot = -mu0_Sun*r/norm(r,2)^3 - mu0_Earth*(r-qE(1:3))/norm(r-qE(1:3),2)^3 ...
        - mu0_Moon*(r-qM(1:3))/norm(r-qM(1:3),2)^3;

    qLdot = [v;vdot;Ldot];
end

function q = CR3BP2EMB(qCR3BP,L_EMB,t)
% Convert the state qCR3BP expressed in CR3BP rotating frame into q
% expressed in Heliocentric interial frame (AU,AU/d)

    constantes; % for day, AU, LD, time_syst
    
    [qM,~] = MoonEarth(t);
    % Convert qCR3BP to EMB inertial and (LD,LD/d)
    cT = (jour/time_syst); % time conversion
    Ox = qM(1:3)/norm(qM(1:3),2);
    Oz = cross(qM(1:3),qM(4:6)); Oz = Oz/norm(Oz,2);
    Oy = cross(Oz,Ox); Oy = Oy/norm(Oy,2); % normalisation not really needed
    M = [Ox'; Oy'; Oz']; % change of coordinates matrix
    R = M'*qCR3BP(1:3);
    V = cT*M'*(qCR3BP(4:6)+cross([0;0;1],qCR3BP(1:3)));
    q = [R;V];

    % Convert to Heliocentric inertial and (AU,AU/d)
    qEMB = Gauss2Cart(mu0_Sun,[xG_EMB0(1:5);L_EMB]);
    q = q*LD/AU+qEMB;
    
end