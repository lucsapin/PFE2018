// Function for the criterion of the problem
// Min criterion(z)

// The following are the input and output available variables
// for the criterion of your optimal control problem.

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

// The functions of your problem have to be written in C++ code
// Remember that the vectors numbering in C++ starts from 0
// (ex: the first component of the vector state is state[0])

// Tdouble variables correspond to values that can change during optimization:
// states, controls, algebraic variables and optimization parameters.
// Values that remain constant during optimization use standard types (double, int, ...).

#include "header_criterion"
{
	// HERE : description of the function for the criterion
	// "criterion" is a function of all variables X[]
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

	Tdouble dt1  = optimvars[0];
	Tdouble dt2  = optimvars[1];
	Tdouble dV11 = optimvars[2];
	Tdouble dV12 = optimvars[3];
	Tdouble dV13 = optimvars[4];
	Tdouble dV21 = optimvars[5];
	Tdouble dV22 = optimvars[6];
	Tdouble dV23 = optimvars[7];
	Tdouble dV31  = optimvars[8];
	Tdouble dV32  = optimvars[9];
	Tdouble dV33  = optimvars[10];

	Tdouble normdV1 = sqrt(dV11*dV11 + dV12*dV12 + dV13*dV13);
	Tdouble normdV2 = sqrt(dV21*dV21 + dV22*dV22 + dV23*dV23);
	Tdouble normdV3 = sqrt(dV31*dV31 + dV32*dV32 + dV33*dV33);

	criterion = normdV1 + normdV2 + normdV3;
}
