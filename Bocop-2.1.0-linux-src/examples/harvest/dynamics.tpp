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
  // constants
  double Ce = 0.2;
  double a = 3.0;
  double b = 5.0;
  double beta = 0.05;
  double p = 2;
  double h = 0.5;

  // final time
  double T = constants[0];

  // variables
  Tdouble x = state[0];
  Tdouble u = control[0];

  // get x(t-h)
  // note: more complicated with free final time (Tdouble interpolation)
  // if t<h then x(t-h) = 2 else recover past state
  Tdouble xprev = 2.0;
  if (normalized_time > h/T)
    xprev = interpolation(normalized_time - h/T, past_steps, past_states[0],current_step);

  // dynamics
  state_dynamics[0] = a * x * (1.0 - xprev/b) - u;
  state_dynamics[1] = exp(-beta * normalized_time*T) * (Ce / x * pow(u,3) - p * u);

  // rescale dynamics for normalized time
  for (int i=0; i<dim_state; i++)
    state_dynamics[i] *= T;  

}


