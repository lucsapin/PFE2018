// Function for the dynamics of the problem
// dy/dt = dynamics(y,u,z,p)

// Input :
// time : current time (t)
// initial_time : time value on the first discretization point
// final_time : time value on the last discretization point
// dim_* is the dimension of next vector in the declaration
// state : vector of state variables
// control : vector of control variables
// algebraicvars : vector of algebraic variables
// optimvars : vector of optimization variables
// constants : vector of constants

// Output :
// state_dynamics : vector giving the expression of the dynamic of each state variable.

#include "header_dynamics"
{
// METHANE PROBLEM
// y' = mu y / (1+y) - (r+u)y
// s' = -mu2(s) x + u beta (gamma y-s)
// x' = (mu2(s) - u beta)x
// J' = - mu2*x / (beta+c)
// with
// mu2 according to growth model
// mu according to light model
// time scale is [0,10] for 24h (day then night)
// (changing this would require adjusting some other constants)

// constants
double mubar = constants[0];
double r = constants[1];
double beta = constants[2];
double gamma = constants[3];
double mu2m = constants[4];
double Ks = constants[5];
double halfperiod = constants[6];
double c = constants[7];

//Tdouble beta = optimvars[0];

// variables
Tdouble y = state[0];
Tdouble s = state[1];
Tdouble x = state[2];
Tdouble u = control[0];

//biomass growth
Tdouble mu2 = growth(s,mu2m,Ks);

//algae growth
Tdouble mu = daynightgrowth(mubar,time,halfperiod);

// dynamics
state_dynamics[0] = mu*y/(1+y) - (r+u)*y;
state_dynamics[1] = -mu2*x + u*beta*(y*gamma-s);
state_dynamics[2] = (mu2-u*beta)*x;
state_dynamics[3] = mu2*x / (beta+c);
}
