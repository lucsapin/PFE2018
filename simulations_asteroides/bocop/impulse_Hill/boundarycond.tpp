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

  Tdouble q11i = initial_state[0];
  Tdouble q12i = initial_state[1];
  Tdouble q13i = initial_state[2];
  Tdouble q14i = initial_state[3];
  Tdouble q15i = initial_state[4];
  Tdouble q16i = initial_state[5];

  Tdouble q21i = initial_state[6];
  Tdouble q22i = initial_state[7];
  Tdouble q23i = initial_state[8];
  Tdouble q24i = initial_state[9];
  Tdouble q25i = initial_state[10];
  Tdouble q26i = initial_state[11];

  Tdouble q11f = final_state[0];
  Tdouble q12f = final_state[1];
  Tdouble q13f = final_state[2];
  Tdouble q14f = final_state[3];
  Tdouble q15f = final_state[4];
  Tdouble q16f = final_state[5];

  Tdouble q21f = final_state[6];
  Tdouble q22f = final_state[7];
  Tdouble q23f = final_state[8];
  Tdouble q24f = final_state[9];
  Tdouble q25f = final_state[10];
  Tdouble q26f = final_state[11];

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
	double m0     = constants[18];

  boundary_conditions[0]  = q01 - q11i;
  boundary_conditions[1]  = q02 - q12i;
  boundary_conditions[2]  = q03 - q13i;
  boundary_conditions[3]  = q04 + dV11 - q14i;
  boundary_conditions[4]  = q05 + dV12 - q15i;
  boundary_conditions[5]  = q06 + dV13 - q16i;

  boundary_conditions[6]  = q11f - q21i;
  boundary_conditions[7]  = q12f - q22i;
  boundary_conditions[8]  = q13f - q23i;
  boundary_conditions[9]  = q14f + dV21 - q24i;
  boundary_conditions[10] = q15f + dV22 - q25i;
  boundary_conditions[11] = q16f + dV23 - q26i;

  boundary_conditions[12] = q21f - qL21;
  boundary_conditions[13] = q22f - qL22;
  boundary_conditions[14] = q23f - qL23;
  boundary_conditions[15] = q24f + dV31 - qL24; // car L2 immobile dans repère tournant
  boundary_conditions[16] = q25f + dV32 - qL25;
  boundary_conditions[17] = q26f + dV33 - qL26;
}
