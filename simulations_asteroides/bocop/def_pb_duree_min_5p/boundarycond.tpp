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
  double Tmax   = constants[0];
  double beta   = constants[1];
  double mu     = constants[2];
  double muS    = constants[3];
  double rS     = constants[4];
  double qH1    = constants[5];
  double qH2    = constants[6];
  double qH3    = constants[7];
  double qH4    = constants[8];
  double qH5    = constants[9];
  double qH6    = constants[10];
  double qL21   = constants[11];
  double qL22   = constants[12];
  double qL23   = constants[13];
  double qL24   = constants[14];
  double qL25   = constants[15];
  double qL26   = constants[16];
  double theta0 = constants[17];
  double omegaS = constants[18];
  double m0     = constants[19];

  boundary_conditions[0]  = initial_state[0]  - qH1;
  boundary_conditions[1]  = initial_state[1]  - qH2;
  boundary_conditions[2]  = initial_state[2]  - qH3;
  boundary_conditions[3]  = initial_state[3]  - qH4;
  boundary_conditions[4]  = initial_state[4]  - qH5;
  boundary_conditions[5]  = initial_state[5]  - qH6;
  boundary_conditions[6]  = initial_state[6]  - m0;

  boundary_conditions[7]  = initial_state[7]  - final_state[0];
  boundary_conditions[8]  = initial_state[8]  - final_state[1];
  boundary_conditions[9]  = initial_state[9]  - final_state[2];
  boundary_conditions[10] = initial_state[10] - final_state[3];
  boundary_conditions[11] = initial_state[11] - final_state[4];
  boundary_conditions[12] = initial_state[12] - final_state[5];
  boundary_conditions[13] = initial_state[13] - final_state[6];

  boundary_conditions[14] = initial_state[14] - final_state[7];
  boundary_conditions[15] = initial_state[15] - final_state[8];
  boundary_conditions[16] = initial_state[16] - final_state[9];
  boundary_conditions[17] = initial_state[17] - final_state[10];
  boundary_conditions[18] = initial_state[18] - final_state[11];
  boundary_conditions[19] = initial_state[19] - final_state[12];
  boundary_conditions[20] = initial_state[20] - final_state[13];

  boundary_conditions[21] = initial_state[21] - final_state[14];
  boundary_conditions[22] = initial_state[22] - final_state[15];
  boundary_conditions[23] = initial_state[23] - final_state[16];
  boundary_conditions[24] = initial_state[24] - final_state[17];
  boundary_conditions[25] = initial_state[25] - final_state[18];
  boundary_conditions[26] = initial_state[26] - final_state[19];
  boundary_conditions[27] = initial_state[27] - final_state[20];

  boundary_conditions[28] = initial_state[28] - final_state[21];
  boundary_conditions[29] = initial_state[29] - final_state[22];
  boundary_conditions[30] = initial_state[30] - final_state[23];
  boundary_conditions[31] = initial_state[31] - final_state[24];
  boundary_conditions[32] = initial_state[32] - final_state[25];
  boundary_conditions[33] = initial_state[33] - final_state[26];
  boundary_conditions[34] = initial_state[34] - final_state[27];

  boundary_conditions[35] = qL21              - final_state[28];
  boundary_conditions[36] = qL22              - final_state[29];
  boundary_conditions[37] = qL23              - final_state[30];
  boundary_conditions[38] = qL24              - final_state[31];
  boundary_conditions[39] = qL25              - final_state[32];
  boundary_conditions[40] = qL26              - final_state[33];
  // masse finale libre
}
