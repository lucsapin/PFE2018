#include "header_pathcond"
{
  // total population (R+P) for visu
  path_constraints[0] = state[0] + state[7];

 // total population (R+Ptilde) for visu
  path_constraints[1] = state[0] + state[1];

}


