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
  boundary_conditions[7]  = qL21   - final_state[0];
  boundary_conditions[8]  = qL22   - final_state[1];
  boundary_conditions[9]  = qL23   - final_state[2];
  boundary_conditions[10] = qL24   - final_state[3];
  boundary_conditions[11] = qL25   - final_state[4];
  boundary_conditions[12] = qL26   - final_state[5];
}
