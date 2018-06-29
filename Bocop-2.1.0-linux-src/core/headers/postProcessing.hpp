// Copyright (C) 2013 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: postProcessing.hpp
// Authors: Daphne Giorgi

#ifndef POSTPROCESSING_H
#define POSTPROCESSING_H

#include <common.hpp>
#include <publicTools.hpp>

using namespace std;

int postProcessing(int dimStep,
                   int dimStage,
                   int dimConstant,
                   int dimState,
                   int dimControl,
                   int dimAlgebraic,
                   int dimParameter,
                   int dimBoundCondMult,
                   int dimPathConstrMult,
                   double* timeSteps,    // preciser si les temps sont normalisé ou pas?
                   double* timeStages,
                   double t0,
                   double tF,
                   double* constant,
                   double** state,
                   double** control,
                   double** algebraic,
                   double* parameter,		// si tf libre, j'enleve le dernier element?
                   double* boundaryCondMultiplier,
                   double** pathConstrMultiplier,
                   double** adjointState);


#endif
