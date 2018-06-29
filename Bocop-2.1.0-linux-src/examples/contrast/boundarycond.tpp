// Function for the initial and final conditions of the problem
// lb <= Phi(t0, y(t0), tf, y(tf), p) <= ub

// Input :
// dim_boundary_conditions : number of boundary conditions
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
// boundaryconditions : vector of boundary conditions ("Phi" in the example above).

#include "header_boundarycond"
{
//1st spin: initial and final conditions
boundary_conditions[0] = initial_state[0];
boundary_conditions[1] = initial_state[1];
boundary_conditions[2] = final_state[0];
boundary_conditions[3] = final_state[1];

//2nd spin: initial conditions
boundary_conditions[4] = initial_state[2];
boundary_conditions[5] = initial_state[3];

//regularisation
boundary_conditions[6] = initial_state[4];
}

