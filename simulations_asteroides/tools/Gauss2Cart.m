%% Position et Vitesse depuis Gauss
function xC = Gauss2Cart(mu0,x)

P = x(1); ex = x(2); ey = x(3); hx = x(4); hy = x(5); L = x(6);

co = cos(L); si = sin(L);
W = 1 + ex*co + ey*si;
Z = hx*si - hy*co;
C = 1 + hx^2 + hy^2;

r = P/(C*W)*[(1+hx^2-hy^2)*co + 2*hx*hy*si;...
  (1-hx^2+hy^2)*si + 2*hx*hy*co;...
  2*Z];
v = sqrt(mu0/P)/C*[2*hx*hy*(ex+co)-(1+hx^2-hy^2)*(ey+si);...
  (1-hx^2+hy^2)*(ex+co)-2*hx*hy*(ey+si);...
  2*(hx*(ex+co)+hy*(ey+si))];

xC = [r;v];