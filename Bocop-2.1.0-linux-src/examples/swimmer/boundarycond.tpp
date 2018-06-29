// Function for the initial and final conditions of the problem
// lb <= Phi(t0, y(t0), tf, y(tf), p) <= ub

// The following are the input and output available variables 
// for the boundary conditions of your optimal control problem.

// Input :
// dim_boundary_conditions : number of boundary conditions
// dim_state : number of state variables
// initial_time : value of the initial time
// initial_state : initial state vector
// final_time : value of the final time
// final_state : final state vector
// dim_optimvars : number of optimization parameters
// optimvars : vector of optimization parameters
// dim_constants : number of constants
// constants : vector of constants

// Output :
// boundaryconditions : vector of boundary conditions ("Phi" in the example above).

// The functions of your problem have to be written in C++ code
// Remember that the vectors numbering in C++ starts from 0
// (ex: the first component of the vector state is state[0])

// Tdouble variables correspond to values that can change during optimization:
// states, controls, algebraic variables and optimization parameters.
// Values that remain constant during optimization use standard types (double, int, ...).

#include "header_boundarycond"
{
// initial conditions: x0, y0, theta0, E0
boundary_conditions[0] = initial_state[0];
boundary_conditions[1] = initial_state[1];
boundary_conditions[2] = initial_state[2];
boundary_conditions[3] = initial_state[5];

// final conditions: xf, yf, thetaf, Ef
boundary_conditions[4] = final_state[0];
boundary_conditions[5] = final_state[1];
boundary_conditions[6] = final_state[2];
boundary_conditions[7] = final_state[5];

// periodicity conditions: theta, beta1, beta2
boundary_conditions[8] = final_state[2] - initial_state[2];
boundary_conditions[9] = final_state[3] - initial_state[3];
boundary_conditions[10] = final_state[4] - initial_state[4];

// beta1(0) (set sign to break symmetries)
boundary_conditions[11] = initial_state[3];
}


