// Function for the dynamics of the problem
// y_dot = dynamics(z) = dynamics(y,u,z,p)

// Input :
// t : time
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
   // DYNAMICS FOR HEAT PROBLEM
   
   // Spatial step
   double h = 1.0/(dim_state-1);
   double h2 = h * h;
   
   // Problem constants
   double c0 = constants[0];
   double c1 = constants[1];
   double a = constants[2];   // it has to be 0 < a < dim_state
   double gamma = constants[3];
   double delta = constants[4];


   Tdouble normstate = 0.0;
   Tdouble u = control[0];

/*
   // DIRICHLET
   // We recall that the boundary conditions are y(0,t)=y(1,t)=0
   state_dynamics[0] = c0 * (- 2*state[0] + state[1]) / h2;	
   state_dynamics[dim_state-2] = c0 * (- 2*state[dim_state-2] + state[dim_state-3]) / h2;

   for(int i=1;i<dim_state-2;i++)
   {
       state_dynamics[i] = c0 * (state[i-1] - 2*state[i] + state[i+1]) / h2;
   }

   for(int i=0;i<(int)a;i++)
   {
       state_dynamics[i] += c1 * u ;
   }
*/

   // NEUMANN    
   // We recall that the boundary conditions are y_x(0,t) = -c1*u and  y_x(1,t)=0
   state_dynamics[0] = c0 * (- state[0] + state[1]) / h2 + c1 * u / h;	
   state_dynamics[dim_state-2] = c0 * (- state[dim_state-2] + state[dim_state-3]) / h2;

   for(int i=1;i<dim_state-2;i++)
   {
       state_dynamics[i] = c0 * (state[i-1] - 2*state[i] + state[i+1]) / h2;
   }


   // CRITERION Min int (state^2 + gamma control + delta control^2)
   for(int i=0;i<dim_state-2;i++)
   {
       normstate = normstate + pow(state[i],2);
   }
   state_dynamics[dim_state-1] = normstate / 2.0 + gamma*u + delta*pow(u,2);

}

