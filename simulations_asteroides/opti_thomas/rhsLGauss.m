%% Right Hand Side of dynamical system for orbital elements
function Ldot = rhsLGauss(t,L,x,mu0)
    P = x(1); ex = x(2); ey = x(3);
    W = 1 +ex*cos(L)+ey*sin(L);
    Ldot = sqrt(mu0/P)*W^2/P;
    
    
