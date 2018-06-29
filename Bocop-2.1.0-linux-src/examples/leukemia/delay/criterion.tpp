#include "header_criterion"
{
  // minimize R(T) + P_tilde(T) 
  criterion = final_state[0] + final_state[1];

  // for Fig.2 minimize R(T) + P(T) (used with gamma = 0.15 instead of 0.05)
  //criterion = final_state[0] + final_state[7];

}


