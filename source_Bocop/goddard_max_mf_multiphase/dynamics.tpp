// Function for the dynamics of the problem
// dy/dt = dynamics(y,u,z,p)

// The following are the input and output available variables
// for the dynamics of your optimal control problem.

// Input :
// time : current time (t)
// normalized_time: t renormalized in [0,1]
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
	// HERE : description of the function for the dynamics
	// Please give a function or a value for the dynamics of each state variable

	// DYNAMICS FOR GODDARD PROBLEM
	// dr/dt = v
	// dv/dt = (Thrust(u) - Drag(r,v)) / m - grav(r)
	// dm/dt = -b*|u|

	double A          = constants[0];
	double b          = constants[1];
	double Tmax       = constants[2];
	double k          = constants[3];
	double r0         = constants[4];
	double v0         = constants[5];
	double m0         = constants[6];
	double rf         = constants[7];

	Tdouble r1        = state[0];
	Tdouble v1        = state[1];
	Tdouble m1        = state[2];

	Tdouble r2        = state[3];
	Tdouble v2        = state[4];
	Tdouble m2        = state[5];

	Tdouble r3        = state[6];
	Tdouble v3        = state[7];
	Tdouble m3        = state[8];

	Tdouble u1        = control[0];
	Tdouble u2        = control[1];
	Tdouble u3        = control[2];

	Tdouble dt1       = optimvars[0];
	Tdouble dt2       = optimvars[1];
	Tdouble dtf       = optimvars[2];

	state_dynamics[0] = dt1 * v1;
	state_dynamics[1] = dt1 * ((thrust(u1,Tmax) - drag(r1,v1,A,k,r0)) / m1 - grav(r1));
	state_dynamics[2] = dt1 * (- b * u1);

	state_dynamics[3] = dt2 * v2;
	state_dynamics[4] = dt2 * ((thrust(u2,Tmax) - drag(r2,v2,A,k,r0)) / m2 - grav(r2));
	state_dynamics[5] = dt2 * (- b * u2);

	state_dynamics[6] = dtf * v3;
	state_dynamics[7] = dtf * ((thrust(u3,Tmax) - drag(r3,v3,A,k,r0)) / m3 - grav(r3));
	state_dynamics[8] = dtf * (- b * u3);

}
