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

	double q1_0 	= constants[0];
	double q2_0 	= constants[1];
	double q3_0 	= constants[2];
	double v1_0 	= constants[3];
	double v2_0 	= constants[4];
	double v3_0 	= constants[5];
	double q1_f	 	= constants[6];
	double q2_f	 	= constants[7];
	double q3_f	 	= constants[8];
	double v1_f		= constants[9];
	double v2_f	 	= constants[10];
	double v3_f	 	= constants[11]; 

   	boundary_conditions[0] =  initial_state[0]-q1_0;
    	boundary_conditions[1] =  initial_state[1]-q2_0;
    	boundary_conditions[2] =  initial_state[2]-q3_0;
   	boundary_conditions[3] =  initial_state[3]-v1_0;
    	boundary_conditions[4] =  initial_state[4]-v2_0;
    	boundary_conditions[5] =  initial_state[5]-v3_0;
   	boundary_conditions[6] =  final_state[0]-q1_f;
    	boundary_conditions[7] =  final_state[1]-q2_f;
    	boundary_conditions[8] =  final_state[2]-q3_f;
   	boundary_conditions[9] =  final_state[3]-v1_f;
    	boundary_conditions[10] =  final_state[4]-v2_f;
    	boundary_conditions[11] =  final_state[5]-v3_f;


}


