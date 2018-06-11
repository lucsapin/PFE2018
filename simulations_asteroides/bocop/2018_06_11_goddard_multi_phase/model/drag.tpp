#include "adolc/adolc.h"
#include "adolc/adouble.h"
#include <cmath>

// FUNCTION FOR GODDARD DRAG
// drag = 310 v^2 exp (-500(r-1))

// Arguments:
// r: radius
// v: velocity

template<class Tdouble> Tdouble drag(Tdouble r, Tdouble v, double A, double k, double r0)
{

	Tdouble drag;
	drag = A * v * v * exp(-k*(fabs(r)-r0));
	return drag;

}
