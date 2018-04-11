function xGauss = Orb2Gauss(xOrb)

a = xOrb(1); e = xOrb(2); i = xOrb(3);
Noeud = xOrb(4); argper = xOrb(5); nu = xOrb(6);

P = a*(1-e^2);
ex = e*cos(Noeud+argper); ey = e*sin(Noeud+argper);
hx = tan(i/2)*cos(Noeud); hy = tan(i/2)*sin(Noeud);
L = mod(Noeud + argper + nu,2*pi);

xGauss = [P; ex; ey; hx; hy; L];