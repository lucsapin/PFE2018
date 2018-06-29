// FUNCTION FOR BIOMASS GROWTH
// Arguments:
// s: substrate
// mu2m: parameter
// K: parameter
template<class Tdouble> Tdouble growth(const Tdouble s, const double mu2m, const double K)
{
  // MONOD
	Tdouble growth = mu2m * s / (s+K);

  return growth;
}


// FUNCTION FOR ALGAE GROWTH
// Arguments:
// mubar: day growth
// time: current time
// halfperiod: day duration
template<class Tdouble> Tdouble daynightgrowth(const double mubar, const Tdouble time, const double halfperiod)
{

	// light model: max^2 (0,sin) * mubar
	// DAY/NIGHT CYCLE: [0,2 halfperiod] rescaled to [0,2pi]
	double pi = 3.141592653589793;
	Tdouble days = time / (halfperiod*2e0);
	  
#ifndef USE_CPPAD
  // note: problems with adolc 2.6.3, 2.5.2 is fine (same with old code formulation)
	Tdouble tau = (days - floor(days)) * 2e0*pi;  //fmod does not seem to be compatible with AD ...
  Tdouble	mu = pow(fmax(0.0,sin(tau)),2) * mubar;
#else
  Tdouble tau = (days - CppAD::Integer(days)) * 2e0*pi;
	Tdouble zero = 0e0;
  Tdouble	mu = pow(max(zero,sin(tau)),2) * mubar;
#endif

	return mu;
}
