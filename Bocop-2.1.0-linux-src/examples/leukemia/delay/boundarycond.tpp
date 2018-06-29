#include "header_boundarycond"
{

  // constants
  double tau = constants[0];
  double beta = constants[2];
  double gamma = constants[3];
  double p0 = constants[4];
  Tdouble lambda = optimvars[0]; //note: could also be computed offline (see matlab script)

  // initial conditions
  boundary_conditions[0] = initial_state[0];
  boundary_conditions[1] = initial_state[1] - 2e0*p0/(lambda+gamma)*(1e0-exp(-(lambda+gamma)*2e0*tau)); //+++factor 2 here vs xavier ?
  boundary_conditions[2] = initial_state[2] - 2e0*p0/(lambda+gamma)*(1e0-exp(-(lambda+gamma)*tau)); //+++factor 2 here vs xavier ?
  boundary_conditions[3] = initial_state[3];
  boundary_conditions[4] = initial_state[4];
  boundary_conditions[5] = initial_state[5]; 
  boundary_conditions[6] = initial_state[6];   
  boundary_conditions[8] = initial_state[7] - 2e0*p0*tau; 
  boundary_conditions[9] = initial_state[8] - tau*p0;  
  
  // final conditions U(T) <= 2 ubar
  boundary_conditions[10] = final_state[5] - 2e0*constants[5];
 
  // equation for lambda
  boundary_conditions[7] = lambda + beta - 2e0*beta*exp(-(lambda+gamma)*2e0*tau);
  
}


