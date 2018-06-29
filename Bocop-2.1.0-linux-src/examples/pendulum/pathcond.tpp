// Function for the path constraints of the problem
// a <= g(t,y,u,z,p) <= b

// Input :
// dim_path_constraints : number of path constraints
// t : time
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
	// PATH CONSTRAINTS FOR PENDULUM PROBLEM
	path_constraints[0] = pow(state[2],2) + pow(state[3],2) + algebraicvars[0]*(pow(state[0],2)+pow(state[1],2)) + control[0]*state[0] - constants[0]*state[1];
}

