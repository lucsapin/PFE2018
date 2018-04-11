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
#include <cmath>
{
	// HERE : description of the function for the dynamics
	// Please give a function or a value for the dynamics of each state variable

	double Tmax 	= constants[12];
	double mu	 	= constants[13];
	double muSun 	= constants[14];
	double rhoSun 	= constants[15];
	double thetaSun_0 	= constants[16];
	double omegaSun 	= constants[17];
	double m0		= constants[18];
	double tf    		= constants[19];

	Tdouble q1		= state[0];
	Tdouble q2		= state[1];
	Tdouble q3		= state[2];
	Tdouble v1		= state[3];
	Tdouble v2		= state[4];
	Tdouble v3		= state[5];

	Tdouble u1		= control[0];
	Tdouble u2		= control[1];
	Tdouble u3		= control[2];

	Tdouble r1          	= sqrt(pow(q1+mu,2)    +pow(q2,2)+pow(q3,2));
	Tdouble r2		= sqrt(pow(q1-1+mu,2)+pow(q2,2)+pow(q3,2));
	Tdouble thetaS      	= thetaSun_0 + omegaSun*time*tf;
	Tdouble rS          	= sqrt(pow(q1-rhoSun*cos(thetaS),2)+pow(q2-rhoSun*sin(thetaS),2)+pow(q3,2));

	state_dynamics[0] = tf*(v1);
	state_dynamics[1] = tf*(v2);
	state_dynamics[2] = tf*(v3);

	state_dynamics[3] = tf*(	2*v2 				+
			q1-(1-mu)*(q1+mu)/pow(r1,3) 		-
			mu*(q1-1+mu)/pow(r2,3)		-
			(q1-rhoSun*cos(thetaS))*muSun/pow(rS,3)	-
			muSun*cos(thetaS)/pow(rhoSun,2)		+
			u1*Tmax/m0			);

	state_dynamics[4] = tf*(-2*v1 				+
			q2 - (1-mu)*q2/pow(r1,3)       		- 
			mu*q2/pow(r2,3)        			- 
			(q2-rhoSun*sin(thetaS))*muSun/pow(rS,3) 	- 
			muSun*sin(thetaS)/pow(rhoSun,2)		+
			u2*Tmax/m0			);

	state_dynamics[5] = tf*(  -(1-mu)*q3/pow(r1,3) - mu*q3/pow(r2,3) - q3*muSun/pow(rS,3) + u3 * Tmax/m0);

	state_dynamics[6] = tf*( u1*u1+u2*u2+u3*u3 ) ;

}


