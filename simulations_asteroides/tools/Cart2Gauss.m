function xG = Cart2Gauss(mu0,xC)

r = xC(1:3);
v = xC(4:6);

r0 = norm(r,2);
V0 = norm(v,2);

%% ************ Conversion ******************
a = 1/(2/r0-V0^2/mu0);
t1 = r0*V0^2/mu0-1; t2 = r'*v/sqrt(mu0*a);
e0 = sqrt(t1^2+t2^2);
P = a*(1-e0^2);
h = cross(r,v);
h0 = norm(h,2);
e = cross(v,h)/mu0 - r/r0;
n = cross([0;0;1],h);
n0 = norm(n,2);
if (n0 > 0)
    if (n(2)>=0)
      Omega = acos(n(1)/n0);
    else
      Omega = 2*pi - acos(n(1)/n0);
    end;
    i = acos(h(3)/h0);
    hx = tan(i/2)*cos(Omega);
    hy = tan(i/2)*sin(Omega);
    if (e(3) >= 0)
      omega = acos(e'*n/(e0*n0));
    else
      omega = 2*pi - acos(e'*n/(e0*n0));
    end;
    ex = e0*cos(Omega+omega);
    ey = e0*sin(Omega+omega);
    % anomalie vraie
    % nu = acos(r'*e/(r0*e0)); % anomalie vraie
    ke = cross(r,e); je = cross(e,ke);
    je = cross(h,e);
    if (r'*je >= 0)
        nu = real(acos(r'*e/(r0*e0)));
    else
        nu = 2*pi - real(acos(r'*e/(r0*e0)));
    end;
    
    L = mod(Omega+omega+nu,2*pi);
else %% CHECK THIS PART
    ex = e(1); ey = e(2); hx = 0; hy = 0;
    L = atan2(r(2),r(1)); % Omega = 0
end;

xG = [P;ex;ey;hx;hy;L];

% fprintf(1,'P = %e, ex = %e, ey = %e, hx = %e, hy = %e, L = %e\n',P,ex,ey,hx,hy,L);
% format long;
% fprintf(1,'a = %f, e = %f, Omega = %f, argper = %f, nu = %f, incl = %f\n',a,e0,Omega,omega,nu,i);

