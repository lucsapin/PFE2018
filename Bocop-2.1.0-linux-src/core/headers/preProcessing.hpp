// This code is published under the Eclipse Public License
// Header included at the beginning of the function defined in the problem folder
// Daphne Giorgi, Olivier Tissot, Pierre Martinon
// Inria Saclay and Cmap Ecole Polytechnique
// 2015-2017

#ifndef PREPROCESSING_H
#define PREPROCESSING_H

#include <common.hpp>
#include <publicTools.hpp>

using namespace std;

int preProcessing(const int dim_state,
                  const int dim_control,
                  const int dim_algebraic,
                  const int dim_optimvars,
                  const int dimConstants,
                  const int dimSteps,
                  double* constants,
                  double** discCoeffA,
                  double* discCoeffB,
                  double* discCoeffC);


#endif
