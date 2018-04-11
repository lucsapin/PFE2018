function [tout, z, u, Hs, const_dist_2_earth_all] = getSol_min_dist_2_earth(n, q0, t0, ysol, par)

tout    = [];
z       = [];
u       = [];
Hs      = [];
const_dist_2_earth_all = [];

options_exphv    = hampathset('TolOdeAbs',1e-12,'TolOdeRel',1e-12,'ode','dopri5');

p0      = ysol(1:n);
tf      = ysol(n+1);
t1      = ysol(n+2);
nu1     = ysol(n+3);
z1      = ysol(n+4:end);

ti      = [t0 t1 tf];

% On doit decouper en deux car il y a un saut sur le vecteur adjoint en t1
% Ce saut est deja dans z1 donc pas besoin de le rajouter

% premiere integration
%
tspan   = [t0 t1];
z0      = [q0; p0];

[tout_1, z_1, flag_1 ]      = exphvfun(tspan, z0, ti, options_exphv, par);
u_1                         = control           (tout_1, z_1, ti, par);
Hs_1                        = relevement        (tout_1, z_1, ti, par);
const_dist_2_earth_all_1    = getconstdistearth (tout_1, z_1, ti, par);

% seconde integration
%
tspan   = [t1 tf];
z0      = z1;

[tout_2, z_2, flag_2 ]      = exphvfun(tspan, z0, ti, options_exphv, par);
u_2                         = control           (tout_2, z_2, ti, par);
Hs_2                        = relevement        (tout_2, z_2, ti, par);
const_dist_2_earth_all_2    = getconstdistearth (tout_2, z_2, ti, par);

% on construit les sorties
%
tout                    = [tout_1                   tout_2(1:end)];
z                       = [z_1                      z_2(:,1:end)];
u                       = [u_1                      u_2(:,1:end)];
Hs                      = [Hs_1                     Hs_2(:,1:end)];
const_dist_2_earth_all  = [const_dist_2_earth_all_1 const_dist_2_earth_all_2(:,1:end)];

return
