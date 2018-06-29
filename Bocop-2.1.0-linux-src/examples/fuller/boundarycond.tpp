// Function for the initial and final conditions of the problem
// lb <= Phi(t0, y(t0), tf, y(tf), p) <= ub

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
// boundaryconditions : vector of the boundary conditions ("Phi" in the example above).

// The functions of your problem have to be written in C++ code
// Remember that the vectors numbering in C++ starts from 0
// (ex: the first component of the vector state is state[0])

// Tdouble variables correspond to values that can change during optimization:
// states, controls, algebraic variables and optimization parameters.
// Values that remain constant during optimization use standard types (double, int, ...).

#include "header_boundarycond"
{	
 	// INITIAL CONDITIONS FOR FULLER PROBLEM
 	// y(0) = (0,1,0)
 	Tdouble x0 = initial_state[0];
 	Tdouble xdot0 = initial_state[1];
 	Tdouble integral0 = initial_state[2];
 	
 	Tdouble xT = final_state[0];
 	Tdouble xdotT = final_state[1];
 	
	boundary_conditions[0] = x0;
	boundary_conditions[1] = xdot0;	
	boundary_conditions[2] = integral0;	

	// FINAL CONDITIONS FOR FULLER PROBLEM
	// y(T) = (0,0)
	boundary_conditions[3] = xT;
	boundary_conditions[4] = xdotT;
}

