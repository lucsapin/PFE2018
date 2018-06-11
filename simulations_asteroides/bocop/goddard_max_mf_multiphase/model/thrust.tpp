#include "adolc/adolc.h"
#include "adolc/adouble.h"
#include <cmath>

// FUNCTION FOR THRUST (GODDARD)
// T = u * Tmax

// Arguments:
// r: radius

template<class Tdouble> Tdouble thrust(Tdouble u, double Tmax)
{
	Tdouble thrust;
	thrust = u * Tmax;
	return thrust;
}
