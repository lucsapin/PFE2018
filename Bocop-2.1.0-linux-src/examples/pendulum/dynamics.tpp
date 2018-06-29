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
	// DYNAMICS FOR PENDULUM PROBLEM
	
  Tdouble x = state[0];
  Tdouble y = state[1];
  Tdouble v_x = state[2];
  Tdouble v_y = state[3];
  Tdouble u = control[0];
  Tdouble lambda = algebraicvars[0];

  double g = constants[0];
  double gamma = constants[1];

  state_dynamics[0] = v_x;
  state_dynamics[1] = v_y;
  state_dynamics[2] = lambda*x + u;
  state_dynamics[3] = lambda*y - g;
  state_dynamics[4] = pow(x,2)+pow(y-1,2)+gamma*pow(u,2);

}

