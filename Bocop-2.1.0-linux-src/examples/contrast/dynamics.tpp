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

//constants
double pi = 3.141592653589793e0;
double omegamax = constants[0];
double T11 = constants[1];
double T12 = constants[2];
double T21 = constants[3];
double T22 = constants[4];
double Tmin = constants[5];
double tmincoeff = constants[6];
double regcoeff = constants[7];

double biggamma1 = 1e0 / (T12 * omegamax);
double smallgamma1 = 1e0 / (T11 * omegamax);
double biggamma2 = 1e0 / (T22 * omegamax);
double smallgamma2 = 1e0 / (T21 * omegamax);

//variables
Tdouble y1 = state[0];
Tdouble z1 = state[1];
Tdouble y2 = state[2];
Tdouble z2 = state[3];

Tdouble ux = control[0];

//dynamics for 1st and 2nd spin
state_dynamics[0] = - biggamma1 * y1 - ux * z1;
state_dynamics[1] = smallgamma1 * (1e0 - z1) + ux * y1;

state_dynamics[2] = - biggamma2 * y2 - ux * z2;
state_dynamics[3] = smallgamma2 * (1e0 - z2) + ux * y2;	

//quadratic regularization
state_dynamics[4] = pow(10e0,-regcoeff) * ux * ux;

//manual time normalization
for (int i=0;i<dim_state;i++) state_dynamics[i] *= Tmin * tmincoeff * 2.0 * pi;

}

