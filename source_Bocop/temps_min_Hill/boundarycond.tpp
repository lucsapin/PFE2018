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
  Tdouble q31i = initial_state[12];
  Tdouble q32i = initial_state[13];
  Tdouble q33i = initial_state[14];
  Tdouble q34i = initial_state[15];
  Tdouble q35i = initial_state[16];
  Tdouble q36i = initial_state[17];
  Tdouble q41i = initial_state[18];
  Tdouble q42i = initial_state[19];
  Tdouble q43i = initial_state[20];
  Tdouble q44i = initial_state[21];
  Tdouble q45i = initial_state[21];
  Tdouble q46i = initial_state[23];
  Tdouble q51i = initial_state[24];
  Tdouble q52i = initial_state[25];
  Tdouble q53i = initial_state[26];
  Tdouble q54i = initial_state[27];
  Tdouble q55i = initial_state[28];
  Tdouble q56i = initial_state[29];

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
  Tdouble q31f = final_state[12];
  Tdouble q32f = final_state[13];
  Tdouble q33f = final_state[14];
  Tdouble q34f = final_state[15];
  Tdouble q35f = final_state[16];
  Tdouble q36f = final_state[17];
  Tdouble q41f = final_state[18];
  Tdouble q42f = final_state[19];
  Tdouble q43f = final_state[20];
  Tdouble q44f = final_state[21];
  Tdouble q45f = final_state[21];
  Tdouble q46f = final_state[23];
  Tdouble q51f = final_state[24];
  Tdouble q52f = final_state[25];
  Tdouble q53f = final_state[26];
  Tdouble q54f = final_state[27];
  Tdouble q55f = final_state[28];
  Tdouble q56f = final_state[29];

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


    boundary_conditions[0]  = q11i - q01;
    boundary_conditions[1]  = q12i - q02;
    boundary_conditions[2]  = q13i - q03;
    boundary_conditions[3]  = q14i - q04;
    boundary_conditions[4]  = q15i - q05;
    boundary_conditions[5]  = q16i - q06;

    boundary_conditions[6]  = q21i - q11f;
    boundary_conditions[7]  = q22i - q12f;
    boundary_conditions[8]  = q23i - q13f;
    boundary_conditions[9]  = q24i - q14f;
    boundary_conditions[10] = q25i - q15f;
    boundary_conditions[11] = q26i - q16f;

    boundary_conditions[12] = q21f - q31i;
    boundary_conditions[13] = q22f - q32i;
    boundary_conditions[14] = q23f - q33i;
    boundary_conditions[15] = q24f - q34i;
    boundary_conditions[16] = q25f - q35i;
    boundary_conditions[17] = q26f - q36i;

    boundary_conditions[18] = q31f - q41i;
    boundary_conditions[19] = q32f - q42i;
    boundary_conditions[20] = q33f - q43i;
    boundary_conditions[21] = q34f - q44i;
    boundary_conditions[22] = q35f - q45i;
    boundary_conditions[23] = q36f - q46i;

    boundary_conditions[24] = q41f - q51i;
    boundary_conditions[25] = q42f - q52i;
    boundary_conditions[26] = q43f - q53i;
    boundary_conditions[27] = q44f - q54i;
    boundary_conditions[28] = q45f - q55i;
    boundary_conditions[29] = q46f - q56i;

    boundary_conditions[30] = q51f - qL21;
    boundary_conditions[31] = q52f - qL22;
    boundary_conditions[32] = q53f - qL23;
    boundary_conditions[33] = q54f - qL24;
    boundary_conditions[34] = q55f - qL25;
    boundary_conditions[35] = q56f - qL26;

}
