#include "adolc/adolc.h"
#include "adolc/adouble.h"
#include <cmath>

// FUNCTION FOR GRAVITY 
// g = 1 / r^2

// Arguments:
// r: radius

template<class Tdouble> Tdouble grav(Tdouble r)
{

	Tdouble grav;
	grav = 1e0 / r / r;
	return grav;

}
