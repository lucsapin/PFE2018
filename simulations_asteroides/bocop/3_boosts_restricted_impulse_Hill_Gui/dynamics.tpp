// Function for the dynamics of the problem
// dy/dt = dynamics(y,u,z,p)

// The following are the input and output available variables
// for the dynamics of your optimal control problem.

// Input :
// time : current time (t)
// normalized_time: t renormalized in [0,1]
// initial_time : time value on the first discretization point
// final_time : time value on the last discretization point
// dim_* is the dimension of next vector in the declaration
// state : vector of state variables
// control : vector of control variables
// algebraicvars : vector of algebraic variables
// optimvars : vector of optimization parameters
// constants : vector of constants

// Output :
// state_dynamics : vector giving the expression of the dynamic of each state variable.

// The functions of your problem have to be written in C++ code
// Remember that the vectors numbering in C++ starts from 0
// (ex: the first component of the vector state is state[0])

// Tdouble variables correspond to values that can change during optimization:
// states, controls, algebraic variables and optimization parameters.
// Values that remain constant during optimization use standard types (double, int, ...).

#include "header_dynamics"
{
	// HERE : description of the function for the dynamics
	// Please give a function or a value for the dynamics of each state variable
	Tdouble dt1   = optimvars[0];
	Tdouble dt2   = optimvars[1];

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

	Tdouble x1    = state[0];
	Tdouble y1    = state[1];
	Tdouble z1    = state[2];
	Tdouble xdot1 = state[3];
	Tdouble ydot1 = state[4];
	Tdouble zdot1 = state[5];
	Tdouble x2    = state[6];
	Tdouble y2    = state[7];
	Tdouble z2    = state[8];
	Tdouble xdot2 = state[9];
	Tdouble ydot2 = state[10];
	Tdouble zdot2 = state[11];

	Tdouble rho11   = sqrt((x1+mu)*(x1+mu) + y1*y1 + z1*z1);
	Tdouble rho12   = sqrt((x1-1+mu)*(x1-1+mu) + y1*y1 + z1*z1);
	Tdouble theta1 = theta0 + omegaS*dt1*time;
	Tdouble rhoS1  = sqrt((x1-rS*cos(theta1))*(x1-rS*cos(theta1)) + (y1-rS*sin(theta1))*(y1-rS*sin(theta1)) + z1*z1);

	Tdouble rho21   = sqrt((x2+mu)*(x2+mu) + y2*y2 + z2*z2);
	Tdouble rho22   = sqrt((x2-1+mu)*(x2-1+mu) + y2*y2 + z2*z2);
	Tdouble theta2 = theta0 + omegaS*(dt1 + dt2*time);
	Tdouble rhoS2  = sqrt((x2-rS*cos(theta2))*(x2-rS*cos(theta2)) + (y2-rS*sin(theta2))*(y2-rS*sin(theta2)) + z2*z2);

// PREMIER ARC
	state_dynamics[0] = dt1 * xdot1;
	state_dynamics[1] = dt1 * ydot1;
	state_dynamics[2] = dt1 * zdot1;
	state_dynamics[3] = dt1 * (2*ydot1 + x1 - (1-mu)*(x1+mu)/rho11/rho11/rho11 - mu*(x1-1+mu)/rho12/rho12/rho12 - muS*(x1-rS*cos(theta1))/rhoS1/rhoS1/rhoS1 - muS*cos(theta1)/rS/rS);
	state_dynamics[4] = dt1 * (-2*xdot1 + y1 - (1-mu)*y1/rho11/rho11/rho11 - mu*y1/rho12/rho12/rho12 - muS*(y1-rS*sin(theta1))/rhoS1/rhoS1/rhoS1 - muS*sin(theta1)/rS/rS);
	state_dynamics[5] = dt1 * (-(1-mu)*z1/rho11/rho11/rho11 - mu*z1/rho12/rho12/rho12 - muS*z1/rhoS1/rhoS1/rhoS1);
// DEUXIEME ARC
	state_dynamics[6] = dt2 * xdot2;
	state_dynamics[7] = dt2 * ydot2;
	state_dynamics[8] = dt2 * zdot2;
	state_dynamics[9] = dt2 * (2*ydot2 + x2 - (1-mu)*(x2+mu)/rho21/rho21/rho21 - mu*(x2-1+mu)/rho22/rho22/rho22 - muS*(x2-rS*cos(theta2))/rhoS2/rhoS2/rhoS2 - muS*cos(theta2)/rS/rS);
	state_dynamics[10] = dt2 * (-2*xdot2 + y2 - (1-mu)*y2/rho21/rho21/rho21 - mu*y2/rho22/rho22/rho22 - muS*(y2-rS*sin(theta2))/rhoS2/rhoS2/rhoS2 - muS*sin(theta2)/rS/rS);
	state_dynamics[11] = dt2 * (-(1-mu)*z2/rho21/rho21/rho21 - mu*z2/rho22/rho22/rho22 - muS*z2/rhoS2/rhoS2/rhoS2);

}
