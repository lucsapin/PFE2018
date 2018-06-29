// Function for the initial and final conditions of the problem
// lb <= Phi(t0, y(t0), tf, y(tf), p) <= ub

// Input :
// dim_boundary_conditions : number of boundary conditions
// initial_time : value of the initial time
// final_time : value of the final time
// dim_state : number of state variables
// initial_state : initial state vector
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
	// INITIAL CONDITIONS FOR GODDARD PROBLEM
	// r0 = 1    v0 = 0   m0 = 1
	// MODELED AS 1 <= r0 <= 1, etc
	boundary_conditions[0] = initial_state[0];
	boundary_conditions[1] = initial_state[1];
	boundary_conditions[2] = initial_state[2];

	// FINAL CONDITIONS FOR GODDARD PROBLEM
  	// rf >= 1.01   MODELED AS   1.01 <= rf
	boundary_conditions[3] = final_state[0];
}

