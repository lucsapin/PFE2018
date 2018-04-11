function xOrb = Gauss2Orb(xGauss)

P = xGauss(1); ex = xGauss(2); ey = xGauss(3); hx = xGauss(4); hy = xGauss(5); L = xGauss(6);

e = norm([ex;ey],2);
a = P/(1-e^2);
incl = 2*atan(norm([hx;hy],2));
Noeud = atan2(hy,hx);
argper = mod(atan2(ey,ex)-Noeud,2*pi);
nu = mod(L - (Noeud+argper),2*pi);

xOrb = [a; e; incl; Noeud; argper; nu];