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
	// HERE : description of the function for the initial and final conditions
	// Please give a function or a value for each element of boundaryconditions
  // double A = constants[0];
  // double b = constants[1];
  // double Tmax = constants[2];
  // double k = constants[3];
  // double r0 = constants[4];
  // double v0 = constants[5];
  // double m0 = constants[6];
  // double rf = constants[7];

  boundary_conditions[0] = initial_state[0] - constants[4]; // r1(0) = r0
  boundary_conditions[1] = initial_state[1] - constants[5]; // v1(0) = v0
  boundary_conditions[2] = initial_state[2] - constants[6]; // m1(0) = m0

  boundary_conditions[3] = initial_state[3] - final_state[0]; // r2(0) = r1(1)
  boundary_conditions[4] = initial_state[4] - final_state[1]; // v2(0) = v1(1)
  boundary_conditions[5] = initial_state[5] - final_state[2]; // m2(0) = m1(1)

  boundary_conditions[6] = initial_state[6] - final_state[3]; // r3(0) = r2(1)
  boundary_conditions[7] = initial_state[7] - final_state[4]; // v3(0) = v2(1)
  boundary_conditions[8] = initial_state[8] - final_state[5]; // m3(0) = m2(1)

  boundary_conditions[9] = final_state[6] - constants[7]; // m3(1) = 1.01

}
