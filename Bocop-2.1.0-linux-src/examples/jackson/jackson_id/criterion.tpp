// Function for the criterion of the problem
// Min criterion(z)

// Input :
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
// criterion : expression of the criterion to minimize

#include "header_criterion"
{
	// CRITERION FOR JACKSON PROBLEM

	criterion = -final_state[2]; // max c(tf)
}

