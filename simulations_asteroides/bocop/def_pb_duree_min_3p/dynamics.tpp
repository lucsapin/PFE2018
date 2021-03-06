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
	Tdouble dtf   = optimvars[2];

	Tdouble u11   = control[0];
	Tdouble u12   = control[1];
	Tdouble u13   = control[2];
	Tdouble u31   = control[3];
	Tdouble u32   = control[4];
	Tdouble u33   = control[5];

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
	double qL21   = constants[12];
	double qL22   = constants[13];
	double qL23   = constants[14];
	double qL24   = constants[15];
	double qL25   = constants[16];
	double qL26   = constants[17];
	double theta0 = constants[18];
	double omegaS = constants[19];
	double m0     = constants[20];

	Tdouble x1    = state[0];
	Tdouble y1    = state[1];
	Tdouble z1    = state[2];
	Tdouble xdot1 = state[3];
	Tdouble ydot1 = state[4];
	Tdouble zdot1 = state[5];
	Tdouble m1    = state[6];
	Tdouble x2    = state[7];
	Tdouble y2    = state[8];
	Tdouble z2    = state[8];
	Tdouble xdot2 = state[10];
	Tdouble ydot2 = state[11];
	Tdouble zdot2 = state[12];
	Tdouble m2    = state[13];
	Tdouble x3    = state[14];
	Tdouble y3    = state[15];
	Tdouble z3    = state[16];
	Tdouble xdot3 = state[17];
	Tdouble ydot3 = state[18];
	Tdouble zdot3 = state[19];
	Tdouble m3    = state[20];

	Tdouble rho11   = sqrt((x1+mu)*(x1+mu) + y1*y1 + z1*z1);
	Tdouble rho12   = sqrt((x1-1+mu)*(x1-1+mu) + y1*y1 + z1*z1);
	Tdouble theta1 = theta0 + omegaS*dt1*time;
	Tdouble rhoS1  = sqrt((x1-rS*cos(theta1))*(x1-rS*cos(theta1)) + (y1-rS*sin(theta1))*(y1-rS*sin(theta1)) + z1*z1);

	Tdouble rho21   = sqrt((x2+mu)*(x2+mu) + y2*y2 + z2*z2);
	Tdouble rho22   = sqrt((x2-1+mu)*(x2-1+mu) + y2*y2 + z2*z2);
	Tdouble theta2 = theta0 + omegaS*(dt1 + dt2*time);
	Tdouble rhoS2  = sqrt((x2-rS*cos(theta2))*(x2-rS*cos(theta2)) + (y2-rS*sin(theta2))*(y2-rS*sin(theta2)) + z2*z2);

	Tdouble rho31   = sqrt((x3+mu)*(x3+mu) + y3*y3 + z3*z3);
	Tdouble rho32   = sqrt((x3-1+mu)*(x3-1+mu) + y3*y3 + z3*z3);
	Tdouble theta3 = theta0 + omegaS*(dt1 + dt2 + dtf*time);
	Tdouble rhoS3  = sqrt((x3-rS*cos(theta3))*(x3-rS*cos(theta3)) + (y3-rS*sin(theta3))*(y3-rS*sin(theta3)) + z3*z3);

// PREMIER ARC
	state_dynamics[0] = dt1 * xdot1;
	state_dynamics[1] = dt1 * ydot1;
	state_dynamics[2] = dt1 * zdot1;
	state_dynamics[3] = dt1 * (2*ydot1 + x1 - (1-mu)*(x1+mu)/rho11/rho11/rho11 - mu*(x1-1+mu)/rho12/rho12/rho12 - muS*(x1-rS*cos(theta1))/rhoS1/rhoS1/rhoS1 - muS*cos(theta1)/rS/rS) + (Tmax/m1)*u11;
	state_dynamics[4] = dt1 * (-2*xdot1 + y1 - (1-mu)*y1/rho11/rho11/rho11 - mu*y1/rho12/rho12/rho12 - muS*(y1-rS*sin(theta1))/rhoS1/rhoS1/rhoS1 - muS*sin(theta1)/rS/rS) + (Tmax/m1)*u12;
	state_dynamics[5] = dt1 * (-(1-mu)*z1/rho11/rho11/rho11 - mu*z1/rho12/rho12/rho12 - muS*z1/rhoS1/rhoS1/rhoS1) + (Tmax/m1)*u13;
	state_dynamics[6] = dt1 * (-beta*Tmax*sqrt(u11*u11+u12*u12+u13*u13));
// DEUXIEME ARC
	state_dynamics[7]  = dt2 * xdot2;
	state_dynamics[8]  = dt2 * ydot2;
	state_dynamics[9]  = dt2 * zdot2;
	state_dynamics[10] = dt2 * (2*ydot2 + x2 - (1-mu)*(x2+mu)/rho21/rho21/rho21 - mu*(x2-1+mu)/rho22/rho22/rho22 - muS*(x2-rS*cos(theta2))/rhoS2/rhoS2/rhoS2 - muS*cos(theta2)/rS/rS);
	state_dynamics[11] = dt2 * (-2*xdot2 + y2 - (1-mu)*y2/rho21/rho21/rho21 - mu*y2/rho22/rho22/rho22 - muS*(y2-rS*sin(theta2))/rhoS2/rhoS2/rhoS2 - muS*sin(theta2)/rS/rS);
	state_dynamics[12] = dt2 * (-(1-mu)*z2/rho21/rho21/rho21 - mu*z2/rho22/rho22/rho22 - muS*z2/rhoS2/rhoS2/rhoS2);
	state_dynamics[13] = dt2 * 0;
// TROISIEME ARC
	state_dynamics[14] = dtf * xdot3;
	state_dynamics[15] = dtf * ydot3;
	state_dynamics[16] = dtf * zdot3;
	state_dynamics[17] = dtf * (2*ydot3 + x3 - (1-mu)*(x3+mu)/rho31/rho31/rho31 - mu*(x3-1+mu)/rho32/rho32/rho32 - muS*(x3-rS*cos(theta3))/rhoS3/rhoS3/rhoS3 - muS*cos(theta3)/rS/rS) + (Tmax/m3)*u31;
	state_dynamics[18] = dtf * (-2*xdot3 + y3 - (1-mu)*y3/rho31/rho31/rho31 - mu*y3/rho32/rho32/rho32 - muS*(y3-rS*sin(theta3))/rhoS3/rhoS3/rhoS3 - muS*sin(theta3)/rS/rS) + (Tmax/m3)*u32;
	state_dynamics[19] = dtf * (-(1-mu)*z3/rho31/rho31/rho31 - mu*z3/rho32/rho32/rho32 - muS*z3/rhoS3/rhoS3/rhoS3) + (Tmax/m3)*u33;
	state_dynamics[20] = dtf * (-beta*Tmax*sqrt(u31*u31+u32*u32+u33*u33));
}
