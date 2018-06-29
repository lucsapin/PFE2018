% compute initial conditions for hemato problem

tau = 1;
beta = 2;
gamma = 0.15;
%lambda = 0.158452 %solve equation here

% solve equation (23) for lambda (nb. bocop already does this)
l = sym('lambda');
g = (l + beta) - 2*beta*exp(-(l+gamma)*2*tau);
[l] = solve(g);
lambda = eval(l)

% compute and check initial conditions
a = sym('a');
p0 = 0.5e5;
f = 2*exp((lambda+gamma)*(a-2*tau))*p0;

Ptilde0 = eval(int(f,0,2*tau))
P2tilde0 = eval(int(f,tau,2*tau))

% check against exact expression
2*p0/(lambda+gamma)*(1-exp(-(lambda+gamma)*2*tau))
2*p0/(lambda+gamma)*(1-exp(-(lambda+gamma)*tau))
