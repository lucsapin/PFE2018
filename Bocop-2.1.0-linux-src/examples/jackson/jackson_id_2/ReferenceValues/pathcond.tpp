// Function for the path constraints of the problem
// a <= g(t,y,u,z,p) <= b

// Input :
// dim_path_constraints : number of path constraints
// t : time
// dim_* is the dimension of next vector in the declaration
// state : vector of state variables
// control : vector of control variables
// algebraicvars : vector of algebraic variables
// optimvars : vector of optimization variables
// constants : vector of constants

// Output :
// path_constraints : vector of path constraints expressions ("g" in the example above)

#include "header_pathcond"
{
	// HERE : description of the path constraints
	// Please give a function or a value for each element of path_constraints
	path_constraints[0] = 0; // no path constraints
}