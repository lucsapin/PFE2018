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
	Tdouble finalTime = optimvars[0];

	Tdouble u1 = control[0];
	Tdouble u2 = control[1];
	Tdouble u3 = control[2];

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

	Tdouble x     = state[0];
	Tdouble y     = state[1];
	Tdouble z     = state[2];
	Tdouble xdot  = state[3];
	Tdouble ydot  = state[4];
	Tdouble zdot  = state[5];
	Tdouble m     = state[6];

	Tdouble rho1  = sqrt((x+mu)*(x+mu) + y*y + z*z);
	Tdouble rho2  = sqrt((x-1+mu)*(x-1+mu) + y*y + z*z);
	Tdouble theta = theta0 + omegaS*finalTime*time;
	Tdouble rhoS  = sqrt((x-rS*cos(theta))*(x-rS*cos(theta)) + (y-rS*sin(theta))*(y-rS*sin(theta)) + z*z);

	state_dynamics[0] = finalTime*xdot;
	state_dynamics[1] = finalTime*ydot;
	state_dynamics[2] = finalTime*zdot;
	state_dynamics[3] = finalTime*(2*ydot + x - (1-mu)*(x+mu)/rho1/rho1/rho1 - mu*(x-1+mu)/rho2/rho2/rho2 - muS*(x-rS*cos(theta))/rhoS/rhoS/rhoS - muS*cos(theta)/rS/rS + (Tmax/m)*u1);
	state_dynamics[4] = finalTime*(-2*xdot + y - (1-mu)*y/rho1/rho1/rho1 - mu*y/rho2/rho2/rho2 - muS*(y-rS*sin(theta))/rhoS/rhoS/rhoS - muS*sin(theta)/rS/rS + (Tmax/m)*u2);
	state_dynamics[5] = finalTime*(-(1-mu)*z/rho1/rho1/rho1 - mu*z/rho2/rho2/rho2 - muS*z/rhoS/rhoS/rhoS + (Tmax/m)*u3);
	state_dynamics[6] = finalTime*(-beta*Tmax*sqrt(u1*u1 + u2*u2 + u3*u3));
}
