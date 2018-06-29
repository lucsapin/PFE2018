// Function for the criterion of the problem
// Min criterion(z)

// Input :
// dim_state : number of state variables
// initial_time : value of the initial time
// initial_state : initial state vector
// final_time : value of the final time
// final_state : final state vector
// dim_optimvars : number of optimization variables
// optimvars : vector of optimization variables
// dim_constants : number of constants
// constants : vector of constants

// Output :
// criterion : expression of the criterion to minimize

#include "header_criterion"
{
	// HERE : description of the function for the criterion
	// "criterion" is a function of all variables X[]
	criterion = -final_state[2]; // max c(tf)
}