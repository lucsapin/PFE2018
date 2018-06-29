// This code is realeased under the Eclipse Public License
// Interface to problem specific functions (located in problem folder, user supplied)
// Vincent Grelard, Daphne Giorgi, Pierre Martinon
// Inria Saclay and Cmap Ecole Polytechnique
// 2012-2017

#ifndef FUNCTIONS_H
#define FUNCTIONS_H

#include <common.hpp>

// Note: for template functions the definition is usually written / included directly after the declaration
// (this is a C++ requirement)
#include "publicTools.hpp"
#include "dependencies.hpp"
#include "parametrizedcontrol.hpp"

// For the following functions declarations are not needed except measure called in errorToObservation
// Note: actual headers are kept in header_* files to allow changes without breaking existing problem files

template<class Tdouble> void measure(const int dataSetIndex,
                                     const int dim_time,
                                     //const Tdouble current_time,
                                     const double observation_time,
                                     const int dim_state,
                                     const Tdouble* state,
                                     const int dim_optimvars,
                                     const Tdouble* optimvars,
                                     const int dim_constants,
                                     const double* constants,
                                     const int dim_measures,
                                     const double* observations,
                                     Tdouble* measures);

#include "boundarycond.tpp"
#include "pathcond.tpp"
#include "dynamics.tpp"
#include "errorToObservation.tpp"
#include "criterion.tpp"
#include "measure.tpp"
#include "dependencies.tpp" // to keep backward compatibility

#endif

