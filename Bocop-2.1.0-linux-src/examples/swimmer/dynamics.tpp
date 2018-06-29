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
//Purcell: central stick length 2; side sticks length 1
//state: [x, y, th, b1, b3]
//(x,y,th) position of the swimmer
//alpha_i: angle between stick i and i+1
//control: [b1' b3']
//dynamics for (x,y,th): g1 u1 + g2 u2

Tdouble th = state[2];
Tdouble b1 = state[3];
Tdouble b3 = state[4];
Tdouble u1 = control[0];
Tdouble u2 = control[1];

// aux vars
Tdouble aux = 543 + 186*cos(b1) + 37*cos(2*b1) + 12*cos(b1 - 2*b3) + 30*cos(b1 - b3) + 2*cos(2*(b1 - b3)) + 12*cos(2*b1 - b3) + 186*cos(b3) + 37*cos(2*b3) - 6*cos(b1 + b3) - 3*cos(2*(b1 + b3)) - 6*cos(2*b1 + b3) - 6*cos(b1 + 2*b3);


//coefficients for dynamics
Tdouble g11 = (-42*sin(b1 - th) - 2*sin(2*b1 - th) - 24*sin(th) - 300*sin(b1 + th) - 12*sin(2*b1 + th) - 6*sin(b1 - th - 2*b3) - sin(2*b1 - th - 2*b3) + 4*sin(th - 2*b3) - 12*sin(b1 + th - 2*b3) - sin(2*b1 + th - 2*b3) + 18*sin(b1 - th - b3) + 8*sin(th - b3) - 54*sin(b1 + th - b3) - 2*sin(2*b1 + th - b3) - 18*sin(b1 - th + b3) - 38*sin(th + b3) - 90*sin(b1 + th + b3) - 6*sin(b1 - th + 2*b3) - 18*sin(th + 2*b3) - 30*sin(b1 + th + 2*b3)) / (4.*aux);

Tdouble g12 = (-42*cos(b1 - th) - 2*cos(2*b1 - th) + 24*cos(th) + 300*cos(b1 + th) + 12*cos(2*b1 + th) - 6*cos(b1 - th - 2*b3) - cos(2*b1 - th - 2*b3) - 4*cos(th - 2*b3) + 12*cos(b1 + th - 2*b3) + cos(2*b1 + th - 2*b3) + 18*cos(b1 - th - b3) - 8*cos(th - b3) + 54*cos(b1 + th - b3)+ 2*cos(2*b1 + th - b3) - 18*cos(b1 - th + b3) + 38*cos(th + b3) + 90*cos(b1 + th + b3) - 6*cos(b1 - th + 2*b3) + 18*cos(th + 2*b3) + 30*cos(b1 + th + 2*b3)) / (4.*aux);

Tdouble g13 = -(105 + 186*cos(b1) + 2*cos(2*b1) + 12*cos(b1 - 2*b3) + 30*cos(b1 - b3) + cos(2*(b1 - b3)) - 4*cos(2*b3) - 6*cos(b1 + b3) - 6*cos(b1 + 2*b3)) / (2.*aux);

Tdouble g21 = (8*sin(b1 - th) + 4*sin(2*b1 - th) + 24*sin(th) + 38*sin(b1 + th) + 18*sin(2*b1 + th) - 2*sin(b1 - th - 2*b3) - sin(2*b1 - th - 2*b3) - 2*sin(th - 2*b3) - sin(2*b1 + th - 2*b3) - 54*sin(b1 - th - b3) - 12*sin(2*b1 - th - b3) - 42*sin(th - b3) + 18*sin(b1 + th - b3) - 6*sin(2*b1 + th - b3) + 18*sin(b1 - th + b3) + 6*sin(2*b1 - th + b3) + 300*sin(th + b3) + 90*sin(b1 + th + b3) + 30*sin(2*b1 + th + b3) + 12*sin(th + 2*b3)) / (4.*aux);

Tdouble g22 = (8*cos(b1 - th) + 4*cos(2*b1 - th) - 24*cos(th) - 38*cos(b1 + th) - 18*cos(2*b1 + th) - 2*cos(b1 - th - 2*b3) - cos(2*b1 - th - 2*b3) + 2*cos(th - 2*b3) + cos(2*b1 + th - 2*b3) - 54*cos(b1 - th - b3) - 12*cos(2*b1 - th - b3) + 42*cos(th - b3) - 18*cos(b1 + th - b3) + 6*cos(2*b1 + th - b3) + 18*cos(b1 - th + b3) + 6*cos(2*b1 - th + b3) - 300*cos(th + b3) - 90*cos(b1 + th + b3) - 30*cos(2*b1 + th + b3) - 12*cos(th + 2*b3)) / (4.*aux);

Tdouble g23 = -(105 - 4*cos(2*b1) + 30*cos(b1 - b3) + cos(2*(b1 - b3)) + 12*cos(2*b1 - b3) + 186*cos(b3) + 2*cos(2*b3) - 6*cos(b1 + b3) - 6*cos(2*b1 + b3)) / (2.*aux);


//dynamics: g1 u1 + g2 u2
state_dynamics[0] = g11*u1 + g21*u2;
state_dynamics[1] = g12*u1 + g22*u2;
state_dynamics[2] = g13*u1 + g23*u2;
state_dynamics[3] = u1;
state_dynamics[4] = u2;

// "energy" integral cost \int_0^T |u|^2 dt
state_dynamics[5] = u1*u1 + u2*u2;

}


