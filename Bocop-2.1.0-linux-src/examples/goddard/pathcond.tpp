// Function for the path constraints of the problem
// a <= g(t,y,u,z,p) <= b

// Input :
// dim_path_constraints : number of path constraints
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
// path_constraints : vector of path constraints expressions ("g" in the example above)

// The functions of your problem have to be written in C++ code
// Remember that the vectors numbering in C++ starts from 0
// (ex: the first component of the vector state is state[0])

// Tdouble variables correspond to values that can change during optimization:
// states, controls, algebraic variables and optimization parameters.
// Values that remain constant during optimization use standard types (double, int, ...).

#include "header_pathcond"
{
	// CONSTRAINT ON MAX DRAG FOR GODDARD PROBLEM
	// Drag <= C ie Drag - C <= 0
	
	double A = constants[1];
	double k = constants[2];
	double r0 = constants[3];
	double C = constants[5];

	Tdouble r = state[0];
	Tdouble v = state[1];

	path_constraints[0] = drag(r,v,A,k,r0) - C;
}

