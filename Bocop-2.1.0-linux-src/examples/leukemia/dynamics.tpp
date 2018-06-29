#include "header_dynamics"
{	
  // leukemia problem
  // State variables
  // R: resting cells
  // Ptilde: proliferating cells phase 1+2 (weighted) 
  // P2tilde: proliferating cells phase 2 (weighted) 
  // k: fraction of inhibited (resting) cells
  // y: effect of cytotoxic int_t-tau^tau u(s)ds
  // U: cumulative cytotoxic dose
  // V: cumulative cytostatic dose
  // P: proliferating cells phase 1+2 (non-weighted)(for visu only)
  // P2: proliferating cells phase 2 (non-weighted)(for visu only)
  
  // Control variables
  // u: cytotoxic 
  // v: cytostatic
 
  // constants
  double tau = constants[0];
  double alpha = constants[1];
  double beta = constants[2];
  double gamma = constants[3];
  double p0 = constants[4];
  double ubar = constants[5];
  double vbar = constants[6]; 
 
  // variables
  Tdouble lambda = optimvars[0];
  Tdouble R = state[0];
  Tdouble Ptilde = state[1];
  Tdouble P2tilde = state[2]; 
  Tdouble k = state[3];
  Tdouble y = state[4];
  Tdouble u = control[0] * ubar;
  Tdouble v = control[1] * vbar; 
 
  // past control at t-tau
  // warning: control are discretized at *stage* times that do not necessarily start at t0 ...
  Tdouble uprev;
  if (normalized_time < tau/fixed_final_time)
    uprev = 0e0;
  else
    uprev = ubar * interpolation(normalized_time-tau/fixed_final_time,past_stages,past_controls[0],current_stage); 
 
  // ptilde terms ptilde(t,0), ptilde(t,tau), ptilde(t,2tau)
  Tdouble pt0, pttau, pt2tau;
  
  // ptilde(t,0)
  pt0 = (1e0-k) * (lambda+beta) * R;

  // ptilde(t,tau)
  if (normalized_time < tau/fixed_final_time)
    pttau = p0 * 2e0*exp(-gamma*time-(lambda+gamma)*tau);
  else 
  {
    Tdouble Rprev = interpolation(normalized_time-tau/fixed_final_time,past_steps,past_states[0],current_step);
    Tdouble kprev = interpolation(normalized_time-tau/fixed_final_time,past_steps,past_states[3],current_step);
    pttau = (1e0-kprev)*(lambda+beta)*Rprev*exp(lambda*tau);   
  }

  // ptilde(t,2tau)
  if (normalized_time < 2e0*tau/fixed_final_time)
    pt2tau = p0 * 2e0*exp(-gamma*time-y);    
  else
  {
    Tdouble Rprev2 = interpolation(normalized_time-2e0*tau/fixed_final_time,past_steps,past_states[0],current_step);
    Tdouble kprev2 = interpolation(normalized_time-2e0*tau/fixed_final_time,past_steps,past_states[3],current_step);
    pt2tau = (1e0-kprev2)*(lambda+beta)*Rprev2*exp(lambda*2e0*tau-y);   
  }
  
  // dynamics
  state_dynamics[0] = -(1e0-k)*beta*R + pt2tau; // (5)==(44) OK
  state_dynamics[1] = lambda*Ptilde - u*P2tilde + pt0 - pt2tau;
  state_dynamics[2] = (lambda-u)*P2tilde + pttau - pt2tau;
  state_dynamics[3] = v*(1e0-k) - alpha*k;
  state_dynamics[4] = u - uprev;
  state_dynamics[5] = u;
  state_dynamics[6] = v;
  
  // add non weighted populations for graphs, from (5-6), (22) and 4.3 we get
  // p(t,a) = ptilde(t,a) *psibar/phibar(a) = ptilde(t,a) * 0.5 exp((lambda+gamma)(2tau-a))
  // p(t,0) = ptilde(t,0) * 0.5 exp((lambda+gamma)2tau) 
  // p(t,tau) = ptilde(t,tau) * 0.5 exp((lambda+gamma)tau) 
  // p(t,2tau) = ptilde(t,2tau) * 0.5
  // ALL CHECKS OK VS FORMULATIONS IN PAPER
  Tdouble auxP0 = (1e0-k)*beta*R; // pt0 * 0.5e0 * exp((lambda+gamma)*2e0*tau); // = (1-k)*beta*R OK
  Tdouble auxP = pttau * 0.5e0 * exp((lambda+gamma)*tau);
  Tdouble auxP2 = pt2tau * 0.5e0;
  Tdouble P = state[7];
  Tdouble P2 = state[8]; 
  state_dynamics[7] = - gamma*P - u*P2 + auxP0 - auxP2;
  state_dynamics[8] = (-gamma-u)*P2 + auxP - auxP2;
  

}


