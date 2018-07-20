// Function for the path constraints of the problem
// a <= g(t,y,u,z,p) <= b

// The following are the input and output available variables
// for the path constraints of your optimal control problem.

// Input :
// dim_path_constraints : number of path constraints
// time : current time (t)
// initial_time : time value on the first discretization point
// final_time : time value on the last discretization point
// dim_* is the dimension of next vector in the declaration
// state : vector of state variables
// control : vector of control variables
// algebraicvars : vector of algebraic variables
// optimvars : vector of optimization vector of optimization parameters
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
	// HERE : description of the path constraints
	// Please give a function or a value for each path constraint
  Tdouble u11   = control[0];
  Tdouble u12   = control[1];
  Tdouble u13   = control[2];
  Tdouble u31   = control[3];
  Tdouble u32   = control[4];
  Tdouble u33   = control[5];
  Tdouble u51   = control[6];
  Tdouble u52   = control[7];
  Tdouble u53   = control[8];

  path_constraints[0] = sqrt(u11*u11 + u12*u12 + u13*u13) - 1;
  path_constraints[1] = sqrt(u31*u31 + u32*u32 + u33*u33) - 1;
  path_constraints[2] = sqrt(u51*u51 + u52*u52 + u53*u53) - 1;
}
