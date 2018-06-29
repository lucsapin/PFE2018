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
	// PATH CONSTRAINTS FOR METHANE PROBLEM

  // dummy constraint (free bounds) used to check mu for light model
  double mubar = constants[0];
  double halfperiod = constants[6];
  Tdouble mu = daynightgrowth(mubar,time,halfperiod);
  path_constraints[0] = mu;

	// Parametrized control 
	// Note: manually add in optimvars the correct number of coefficients !
  // type 1: piecewise polynomial case: (degree+1)*(intervals)
  // type 2: trigonometric case: (1+2*degree)
  // also set the constraint equal to 0 in the bounds !
  if (dim_path_constraints > 1)
  {
	  int paramcontrol_type = constants[8];
    int paramcontrol_degree = constants[9];
    int paramcontrol_intervals = constants[10];
    path_constraints[1] = control[0] - parametrizedcontrol(paramcontrol_type, paramcontrol_intervals, paramcontrol_degree, &optimvars[1], normalized_time, fixed_initial_time, fixed_final_time);
	}
	
}

