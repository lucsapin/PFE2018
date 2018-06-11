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
	double Tmax 	= constants[0];
	double A  		= constants[1];
	double k 		= constants[2];
	double b 		= constants[3];
	double r0 		= constants[4];

	Tdouble r1 		= state[0];
	Tdouble v1 		= state[1];
	Tdouble m1		= state[2];

	Tdouble r2 		= state[3];
	Tdouble v2 		= state[4];
	Tdouble m2		= state[5];

	double u1		= 1.0;
	double u2		= 0.0;

	Tdouble dt1		= optimvars[0];
	Tdouble dt2		= optimvars[1];

	state_dynamics[0] = dt1*v1;
	state_dynamics[1] = dt1*((thrust(u1,Tmax) - drag(r1,v1,A,k,r0)) / m1 - grav(r1));
	state_dynamics[2] = - dt1*(b * u1);

	state_dynamics[3] = dt2*v2;
	state_dynamics[4] = dt2*((thrust(u2,Tmax) - drag(r2,v2,A,k,r0)) / m2 - grav(r2));
	state_dynamics[5] = - dt2*(b * u2);

}

