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

// The functions of your problem have to be written in C++ code
// Remember that the vectors numbering in C++ starts from 0
// (ex: the first component of the vector state is state[0])

// Tdouble variables correspond to values that can change during optimization:
// states, controls, algebraic variables and optimization parameters.
// Values that remain constant during optimization use standard types (double, int, ...).

#include "header_dynamics"
{
	// DYNAMICS FOR STATECONSTRAINTS3 PROBLEM
	
	double alpha = constants[0];
	double beta = constants[1];
	double gamma = constants[2];
	int i;

	// INTEGRATOR X(n) = U
	for(i=0;i<dim_state-2;i++)
		state_dynamics[i] = state[i+1];

	state_dynamics[dim_state - 2] = control[0];

	// CRITERION min int (alpha x + beta x^2 + gamma u^2 )
	state_dynamics[dim_state - 1] = alpha*state[0] + beta*state[0]*state[0] + gamma*control[0]*control[0];
}

