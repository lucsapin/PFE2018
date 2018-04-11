function [tout, zout, zi, costi, cost ] = expcost_conso_min(z0, ti, options, par)
%-------------------------------------------------------------------------------------------
%
%    expcost
%
%    Description
%
%        Computes the cost.
%
%-------------------------------------------------------------------------------------------
%
%    Matlab Usage
%
%        [tout, z, flag] = expcost(tspan, z0, options, iepsi)
%
%    Inputs
%
%        z0      - real vector                      : initial flow
%        ti      - ti = [t0 t1 t2 ... tf]
%        options - struct vector                    : odeset options
%        par     - real vector                      : parameters, par=[] if no parameters
%
%    Outputs
%
%        J       - real                             : cost
%
%-------------------------------------------------------------------------------------------

odefun  = @(t,zc) rhsfun(t,zc,ti,par);
nz      = length(z0);
J       = 0.0;
tout    = [];
zout    = [];
zi      = z0;
costi   = J;
for i=1:length(ti)-1

    tspan       = [ti(i) ti(i+1)];

    [tc, zc]    = ode45(odefun, tspan, [z0; J], options);
    zc          = zc';
    z0          = zc(1:nz,end);
    J           = zc(1+nz,end);

    tout        = [tout tc(:)'];
    zout        = [zout zc];

    zi          = [zi z0];
    costi       = [costi J];

end;

cost = J;

return

function rhs = rhsfun(t, zc, ti, par)

n           = (length(zc)-1)/2;
z           = zc(1:2*n);
u           = control(t,z,ti,par);
rhs         = zeros(length(zc),1);
rhs(1:2*n)  = hvfun(t,z,ti,par);
nu          = sqrt(u(1)^2+u(2)^2+u(3)^2);
rhs(2*n+1)  = nu; % |u(t)|

return
