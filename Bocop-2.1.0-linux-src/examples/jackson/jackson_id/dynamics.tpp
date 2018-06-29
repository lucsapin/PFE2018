// Function for the dynamics of the problem
// y_dot = dynamics(z) = dynamics(y,u,z,p)

// Input :
// t : time
// dim_* is the dimension of next vector in the declaration
// state : vector of state variables
// control : vector of control variables
// algebraicvars : vector of algebraic variables
// optimvars : vector of optimization parameters
// constants : vector of constants

// Output :
// state_dynamics : vector giving the expression of the dynamic of each state variable.

#include "header_dynamics"
{
	// DYNAMICS FOR JACKSON PROBLEM

	Tdouble a = state[0];
	Tdouble b = state[1];
	Tdouble u = control[0];
	//double k1 = constants[0];
	//double k2 = constants[1];
	//double k3 = constants[2];

	Tdouble k1 = optimvars[0];
	Tdouble k2 = optimvars[1];
	Tdouble k3 = optimvars[2];

	state_dynamics[0] = -u*(k1*a-k2*b); 
	state_dynamics[1] = u*(k1*a-k2*b) - (1-u)*k3*b; 
	state_dynamics[2] = (1-u)*k3*b; 
}

