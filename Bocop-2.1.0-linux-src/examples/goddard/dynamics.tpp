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
	// DYNAMICS FOR GODDARD PROBLEM
	// dr/dt = v
	// dv/dt = (Thrust(u) - Drag(r,v)) / m - grav(r)
	// dm/dt = -b*|u|

	double Tmax = constants[0];
	double A = constants[1];
	double k = constants[2];
	double r0 = constants[3];
	double b = constants[4];

	Tdouble r = state[0];
	Tdouble v = state[1];
	Tdouble m = state[2];

	state_dynamics[0] = v;
	state_dynamics[1] = (thrust(control[0],Tmax) - drag(r,v,A,k,r0)) / m - grav(r);
	state_dynamics[2] = - b * control[0];
}

