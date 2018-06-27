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
  Tdouble dt1   = optimvars[0];
	Tdouble dt2   = optimvars[1];
	Tdouble dV11  = optimvars[2];
	Tdouble dV12  = optimvars[3];
	Tdouble dV13  = optimvars[4];
	Tdouble dV21  = optimvars[5];
	Tdouble dV22  = optimvars[6];
	Tdouble dV23  = optimvars[7];
  Tdouble dV31  = optimvars[8]; //= -final_state[9] + qL24;
  Tdouble dV32  = optimvars[9]; //= -final_state[10] + qL25;
  Tdouble dV33  = optimvars[10]; //= -final_state[11] + qL26;

  double Tmax   = constants[0];
	double beta   = constants[1];
	double mu     = constants[2];
	double muS    = constants[3];
	double rS     = constants[4];
	double q01    = constants[5];
	double q02    = constants[6];
	double q03    = constants[7];
	double q04    = constants[8];
	double q05    = constants[9];
	double q06    = constants[10];
	double qL21   = constants[11];
	double qL22   = constants[12];
	double qL23   = constants[13];
	double qL24   = constants[14];
	double qL25   = constants[15];
	double qL26   = constants[16];
	double theta0 = constants[17];
	double omegaS = constants[18];
	double m0     = constants[19];

  boundary_conditions[0]  = initial_state[0] - q01;
  boundary_conditions[1]  = initial_state[1] - q02;
  boundary_conditions[2]  = initial_state[2] - q03;
  boundary_conditions[3]  = initial_state[3] - q04 - dV11;
  boundary_conditions[4]  = initial_state[4] - q05 - dV12;
  boundary_conditions[5]  = initial_state[5] - q06 - dV13;

  boundary_conditions[6]  = initial_state[6] - final_state[0];
  boundary_conditions[7]  = initial_state[7] - final_state[1];
  boundary_conditions[8]  = initial_state[8] - final_state[2];
  boundary_conditions[9]  = initial_state[9] - final_state[3] - dV21;
  boundary_conditions[10] = initial_state[10] - final_state[4] - dV22;
  boundary_conditions[11] = initial_state[11] - final_state[5] - dV23;

  boundary_conditions[12] = final_state[6] - qL21;
  boundary_conditions[13] = final_state[7] - qL22;
  boundary_conditions[14] = final_state[8] - qL23;
  boundary_conditions[15] = final_state[9] - qL24 - dV31;
  boundary_conditions[16] = final_state[10] - qL25 - dV32;
  boundary_conditions[17] = final_state[11] - qL26 - dV33;
}
