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
	Tdouble dt1 = optimvars[0];
	Tdouble dt2 = optimvars[1];
	Tdouble dt3 = optimvars[2];
	Tdouble dt4 = optimvars[3];
	Tdouble dtf = optimvars[4];

	double Tmax = constants[0];
	double beta = constants[1];
	double mu = constants[2];
	double muS = constants[3];
	double rS = constants[4];
	double q01 = constants[5];
	double q02 = constants[6];
	double q03 = constants[7];
	double q04 = constants[8];
	double q05 = constants[9];
	double q06 = constants[10];
	double qL21 = constants[11];
	double qL22 = constants[12];
	double qL23 = constants[13];
	double qL24 = constants[14];
	double qL25 = constants[15];
	double qL26 = constants[16];

// PREMIER ARC
	Tdouble x1 = states[0];
	Tdouble y1 = states[1];
	Tdouble z1 = states[2];
	Tdouble xdot1 = states[3];
	Tdouble ydot1 = states[4];
	Tdouble zdot1 = states[5];

	double rho1 = sqrt((x1+mu)*(x1+mu) + y1*y1 + z1*z1);
	double rho2 = sqrt((x1-1+mu)*(x1-1+mu) + y1*y1 + z1*z1);

	Tdouble theta = ?????
	Tdouble rhoS = sqrt((x1-rS*cos(theta))*(x1-rS*cos(theta)) + (y1-rS*sin(theta))*(y1-rS*sin(theta)) + z1*z1);

	state_dynamics[0] = dt1 * xdot1;
	state_dynamics[1] = dt1 * ydot1;
	state_dynamics[2] = dt1 * zdot1;
	state_dynamics[3] = dt1 * (2*ydot1 + x1 - (1-mu)*(x1+mu)/rho1/rho1/rho1 - mu*(x1-1+mu)/rho2/rho2/rho2 - muS*(x1-rS*cos(theta))/rhoS/rhoS/rhoS - muS*cos(theta)/rS/rS);
	state_dynamics[4] = dt1 * (-2*xdot1 + y1 - (1-mu)*y1/rho1/rho1/rho1 - mu*y1/rho2/rho2/rho2 - muS*(y1-rS*sin(theta))/rhoS/rhoS/rhoS - muS*sin(theta)/rS/rS);
	state_dynamics[5] = dt1 * (-(1-mu)*z1/rho1/rho1/rho1 - mu*z1/rho2/rho2/rho2 - muS*z1/rhoS/rhoS/rhoS);

// DEUXIEME ARC
	Tdouble x2 = states[6];
	Tdouble y2 = states[7];
	Tdouble z2 = states[8];
	Tdouble xdot2 = states[9];
	Tdouble ydot2 = states[10];
	Tdouble zdot2 = states[11];

	double rho1 = sqrt((x2+mu)*(x2+mu) + y2*y2 + z2*z2);
	double rho2 = sqrt((x2-1+mu)*(x2-1+mu) + y2*y2 + z2*z2);

	Tdouble theta = ?????
	Tdouble rhoS = sqrt((x2-rS*cos(theta))*(x2-rS*cos(theta)) + (y2-rS*sin(theta))*(y2-rS*sin(theta)) + z2*z2);

	state_dynamics[6] = dt2 * xdot2;
	state_dynamics[7] = dt2 * ydot2;
	state_dynamics[8] = dt2 * zdot2;
	state_dynamics[9] = dt2 * (2*ydot2 + x2 - (1-mu)*(x2+mu)/rho1/rho1/rho1 - mu*(x2-1+mu)/rho2/rho2/rho2 - muS*(x2-rS*cos(theta))/rhoS/rhoS/rhoS - muS*cos(theta)/rS/rS);
	state_dynamics[10] = dt2 * (-2*xdot2 + y2 - (1-mu)*y2/rho1/rho1/rho1 - mu*y2/rho2/rho2/rho2 - muS*(y2-rS*sin(theta))/rhoS/rhoS/rhoS - muS*sin(theta)/rS/rS);
	state_dynamics[11] = dt2 * (-(1-mu)*z2/rho1/rho1/rho1 - mu*z2/rho2/rho2/rho2 - muS*z2/rhoS/rhoS/rhoS);

// TROISIEME ARC
	Tdouble x3 = states[12];
	Tdouble y3 = states[13];
	Tdouble z3 = states[14];
	Tdouble xdot3 = states[15];
	Tdouble ydot3 = states[16];
	Tdouble zdot3 = states[17];

	double rho1 = sqrt((x3+mu)*(x3+mu) + y3*y3 + z3*z3);
	double rho2 = sqrt((x3-1+mu)*(x3-1+mu) + y3*y3 + z3*z3);

	Tdouble theta = ?????
	Tdouble rhoS = sqrt((x3-rS*cos(theta))*(x3-rS*cos(theta)) + (y3-rS*sin(theta))*(y3-rS*sin(theta)) + z3*z3);

	state_dynamics[12] = dt3 * xdot3;
	state_dynamics[13] = dt3 * ydot3;
	state_dynamics[14] = dt3 * zdot3;
	state_dynamics[15] = dt3 * (2*ydot3 + x3 - (1-mu)*(x3+mu)/rho1/rho1/rho1 - mu*(x3-1+mu)/rho2/rho2/rho2 - muS*(x3-rS*cos(theta))/rhoS/rhoS/rhoS - muS*cos(theta)/rS/rS);
	state_dynamics[16] = dt3 * (-2*xdot3 + y3 - (1-mu)*y3/rho1/rho1/rho1 - mu*y3/rho2/rho2/rho2 - muS*(y3-rS*sin(theta))/rhoS/rhoS/rhoS - muS*sin(theta)/rS/rS);
	state_dynamics[17] = dt3 * (-(1-mu)*z3/rho1/rho1/rho1 - mu*z3/rho2/rho2/rho2 - muS*z3/rhoS/rhoS/rhoS);

// QUATRIEME ARC
	Tdouble x4 = states[18];
	Tdouble y4 = states[19];
	Tdouble z4 = states[20];
	Tdouble xdot4 = states[21];
	Tdouble ydot4 = states[22];
	Tdouble zdot4 = states[23];

	double rho1 = sqrt((x4+mu)*(x4+mu) + y4*y4 + z4*z4);
	double rho2 = sqrt((x4-1+mu)*(x4-1+mu) + y4*y4 + z4*z4);

	Tdouble theta = ?????
	Tdouble rhoS = sqrt((x4-rS*cos(theta))*(x4-rS*cos(theta)) + (y4-rS*sin(theta))*(y4-rS*sin(theta)) + z4*z4);

	state_dynamics[18] = dt4 * xdot4;
	state_dynamics[19] = dt4 * ydot4;
	state_dynamics[20] = dt4 * zdot4;
	state_dynamics[21] = dt4 * (2*ydot4 + x4 - (1-mu)*(x4+mu)/rho1/rho1/rho1 - mu*(x4-1+mu)/rho2/rho2/rho2 - muS*(x4-rS*cos(theta))/rhoS/rhoS/rhoS - muS*cos(theta)/rS/rS);
	state_dynamics[22] = dt4 * (-2*xdot4 + y4 - (1-mu)*y4/rho1/rho1/rho1 - mu*y4/rho2/rho2/rho2 - muS*(y4-rS*sin(theta))/rhoS/rhoS/rhoS - muS*sin(theta)/rS/rS);
	state_dynamics[23] = dt4 * (-(1-mu)*z4/rho1/rho1/rho1 - mu*z4/rho2/rho2/rho2 - muS*z4/rhoS/rhoS/rhoS);

// CINQUIEME ARC
	Tdouble x5 = states[24];
	Tdouble y5 = states[25];
	Tdouble z5 = states[26];
	Tdouble xdot5 = states[27];
	Tdouble ydot5 = states[28];
	Tdouble zdot5 = states[29];

	double rho1 = sqrt((x5+mu)*(x5+mu) + y5*y5 + z5*z5);
	double rho2 = sqrt((x5-1+mu)*(x5-1+mu) + y5*y5 + z5*z5);

	Tdouble theta = ?????
	Tdouble rhoS = sqrt((x5-rS*cos(theta))*(x5-rS*cos(theta)) + (y5-rS*sin(theta))*(y5-rS*sin(theta)) + z5*z5);

	state_dynamics[24] = dtf * xdot5;
	state_dynamics[25] = dtf * ydot5;
	state_dynamics[26] = dtf * zdot5;
	state_dynamics[27] = dtf * (2*ydot5 + x5 - (1-mu)*(x5+mu)/rho1/rho1/rho1 - mu*(x5-1+mu)/rho2/rho2/rho2 - muS*(x5-rS*cos(theta))/rhoS/rhoS/rhoS - muS*cos(theta)/rS/rS);
	state_dynamics[28] = dtf * (-2*xdot5 + y5 - (1-mu)*y5/rho1/rho1/rho1 - mu*y5/rho2/rho2/rho2 - muS*(y5-rS*sin(theta))/rhoS/rhoS/rhoS - muS*sin(theta)/rS/rS);
	state_dynamics[29] = dtf * (-(1-mu)*z5/rho1/rho1/rho1 - mu*z5/rho2/rho2/rho2 - muS*z5/rhoS/rhoS/rhoS);

}
