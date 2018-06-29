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
	boundary_conditions[0] = initial_state[0] - constants[4];
	boundary_conditions[1] = initial_state[1] - constants[5];
	boundary_conditions[2] = initial_state[2] - constants[6];
	boundary_conditions[3] = final_state[3] - constants[7];
	boundary_conditions[4] = final_state[0] - initial_state[3];
	boundary_conditions[5] = final_state[1] - initial_state[4];
	boundary_conditions[6] = final_state[2] - initial_state[5];
}

