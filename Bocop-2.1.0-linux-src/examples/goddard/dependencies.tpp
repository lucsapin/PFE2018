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
