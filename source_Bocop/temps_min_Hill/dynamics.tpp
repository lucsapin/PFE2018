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
	Tdouble dt3   = optimvars[2];
	Tdouble dt4   = optimvars[3];
	Tdouble dtf   = optimvars[4];

	Tdouble u11 = control[0];
  Tdouble u12 = control[1];
  Tdouble u13 = control[2];
	Tdouble u31 = control[6];
  Tdouble u32 = control[7];
  Tdouble u33 = control[8];
	Tdouble u51 = control[3];
	Tdouble u52 = control[4];
	Tdouble u53 = control[5];

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
	Tdouble x3    = state[12];
	Tdouble y3    = state[13];
	Tdouble z3    = state[14];
	Tdouble xdot3 = state[15];
	Tdouble ydot3 = state[16];
	Tdouble zdot3 = state[17];
	Tdouble x4    = state[18];
	Tdouble y4    = state[19];
	Tdouble z4    = state[20];
	Tdouble xdot4 = state[21];
	Tdouble ydot4 = state[22];
	Tdouble zdot4 = state[23];
	Tdouble x5    = state[24];
	Tdouble y5    = state[25];
	Tdouble z5    = state[26];
	Tdouble xdot5 = state[27];
	Tdouble ydot5 = state[28];
	Tdouble zdot5 = state[29];

	double omegaS  = -0.9212;

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
	Tdouble theta3 = theta0 + omegaS*(dt1 + dt2 + dt3*time);
	Tdouble rhoS3  = sqrt((x3-rS*cos(theta3))*(x3-rS*cos(theta3)) + (y3-rS*sin(theta3))*(y3-rS*sin(theta3)) + z3*z3);

	Tdouble rho41   = sqrt((x4+mu)*(x4+mu) + y4*y4 + z4*z4);
	Tdouble rho42   = sqrt((x4-1+mu)*(x4-1+mu) + y4*y4 + z4*z4);
	Tdouble theta4 = theta0 + omegaS*(dt1 + dt2 + dt3 + dt4*time);
	Tdouble rhoS4  = sqrt((x4-rS*cos(theta4))*(x4-rS*cos(theta4)) + (y4-rS*sin(theta4))*(y4-rS*sin(theta4)) + z4*z4);

	Tdouble rho51   = sqrt((x5+mu)*(x5+mu) + y5*y5 + z5*z5);
	Tdouble rho52   = sqrt((x5-1+mu)*(x5-1+mu) + y5*y5 + z5*z5);
	Tdouble theta5 = theta0 + omegaS*(dt1 + dt2 + dt3 + dt4 + dtf*time);
	Tdouble rhoS5  = sqrt((x5-rS*cos(theta5))*(x5-rS*cos(theta5)) + (y5-rS*sin(theta5))*(y5-rS*sin(theta5)) + z5*z5);

// PREMIER ARC
	state_dynamics[0] = dt1 * xdot1;
	state_dynamics[1] = dt1 * ydot1;
	state_dynamics[2] = dt1 * zdot1;
	state_dynamics[3] = dt1 * (2*ydot1 + x1 - (1-mu)*(x1+mu)/rho11/rho11/rho11 - mu*(x1-1+mu)/rho12/rho12/rho12 - muS*(x1-rS*cos(theta1))/rhoS1/rhoS1/rhoS1 - muS*cos(theta1)/rS/rS) + (Tmax/m0)*u11;
	state_dynamics[4] = dt1 * (-2*xdot1 + y1 - (1-mu)*y1/rho11/rho11/rho11 - mu*y1/rho12/rho12/rho12 - muS*(y1-rS*sin(theta1))/rhoS1/rhoS1/rhoS1 - muS*sin(theta1)/rS/rS) + (Tmax/m0)*u12;
	state_dynamics[5] = dt1 * (-(1-mu)*z1/rho11/rho11/rho11 - mu*z1/rho12/rho12/rho12 - muS*z1/rhoS1/rhoS1/rhoS1) + (Tmax/m0)*u13;
// DEUXIEME ARC
	state_dynamics[6] = dt2 * xdot2;
	state_dynamics[7] = dt2 * ydot2;
	state_dynamics[8] = dt2 * zdot2;
	state_dynamics[9] = dt2 * (2*ydot2 + x2 - (1-mu)*(x2+mu)/rho21/rho21/rho21 - mu*(x2-1+mu)/rho22/rho22/rho22 - muS*(x2-rS*cos(theta2))/rhoS2/rhoS2/rhoS2 - muS*cos(theta2)/rS/rS);
	state_dynamics[10] = dt2 * (-2*xdot2 + y2 - (1-mu)*y2/rho21/rho21/rho21 - mu*y2/rho22/rho22/rho22 - muS*(y2-rS*sin(theta2))/rhoS2/rhoS2/rhoS2 - muS*sin(theta2)/rS/rS);
	state_dynamics[11] = dt2 * (-(1-mu)*z2/rho21/rho21/rho21 - mu*z2/rho22/rho22/rho22 - muS*z2/rhoS2/rhoS2/rhoS2);
// TROISIEME ARC
	state_dynamics[12] = dt3 * xdot3;
	state_dynamics[13] = dt3 * ydot3;
	state_dynamics[14] = dt3 * zdot3;
	state_dynamics[15] = dt3 * (2*ydot3 + x3 - (1-mu)*(x3+mu)/rho31/rho31/rho31 - mu*(x3-1+mu)/rho32/rho32/rho32 - muS*(x3-rS*cos(theta3))/rhoS3/rhoS3/rhoS3 - muS*cos(theta3)/rS/rS) + (Tmax/m0)*u31;
	state_dynamics[16] = dt3 * (-2*xdot3 + y3 - (1-mu)*y3/rho31/rho31/rho31 - mu*y3/rho32/rho32/rho32 - muS*(y3-rS*sin(theta3))/rhoS3/rhoS3/rhoS3 - muS*sin(theta3)/rS/rS) + (Tmax/m0)*u32;
	state_dynamics[17] = dt3 * (-(1-mu)*z3/rho31/rho31/rho31 - mu*z3/rho32/rho32/rho32 - muS*z3/rhoS3/rhoS3/rhoS3) + (Tmax/m0)*u33;
// QUATRIEME ARC
	state_dynamics[18] = dt4 * xdot4;
	state_dynamics[19] = dt4 * ydot4;
	state_dynamics[20] = dt4 * zdot4;
	state_dynamics[21] = dt4 * (2*ydot4 + x4 - (1-mu)*(x4+mu)/rho41/rho41/rho41 - mu*(x4-1+mu)/rho42/rho42/rho42 - muS*(x4-rS*cos(theta4))/rhoS4/rhoS4/rhoS4 - muS*cos(theta4)/rS/rS);
	state_dynamics[22] = dt4 * (-2*xdot4 + y4 - (1-mu)*y4/rho41/rho41/rho41 - mu*y4/rho42/rho42/rho42 - muS*(y4-rS*sin(theta4))/rhoS4/rhoS4/rhoS4 - muS*sin(theta4)/rS/rS);
	state_dynamics[23] = dt4 * (-(1-mu)*z4/rho41/rho41/rho41 - mu*z4/rho42/rho42/rho42 - muS*z4/rhoS4/rhoS4/rhoS4);
// CINQUIEME ARC
	state_dynamics[24] = dtf * xdot5;
	state_dynamics[25] = dtf * ydot5;
	state_dynamics[26] = dtf * zdot5;
	state_dynamics[27] = dtf * (2*ydot5 + x5 - (1-mu)*(x5+mu)/rho51/rho51/rho51 - mu*(x5-1+mu)/rho52/rho52/rho52 - muS*(x5-rS*cos(theta5))/rhoS5/rhoS5/rhoS5 - muS*cos(theta5)/rS/rS) + (Tmax/m0)*u51;
	state_dynamics[28] = dtf * (-2*xdot5 + y5 - (1-mu)*y5/rho51/rho51/rho51 - mu*y5/rho52/rho52/rho52 - muS*(y5-rS*sin(theta5))/rhoS5/rhoS5/rhoS5 - muS*sin(theta5)/rS/rS) + (Tmax/m0)*u52;
	state_dynamics[29] = dtf * (-(1-mu)*z5/rho51/rho51/rho51 - mu*z5/rho52/rho52/rho52 - muS*z5/rhoS5/rhoS5/rhoS5) + (Tmax/m0)*u53;

}
