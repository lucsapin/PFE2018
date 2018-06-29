// Copyright (C) 2011-2014 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: BocopOptimizeSingle.cpp
// Authors: Vincent Grelard, Daphne Giorgi

#include <BocopOptimize.hpp>

/**
 * \fn BocopOptimizeSingle::BocopOptimizeSingle(const bocopDefPtr DEF)
 * \param DEF
 * Constructor
 */
BocopOptimizeSingle::BocopOptimizeSingle(const bocopDefPtr DEF) :
    BocopOptimize(DEF) {}

/**
 * \fn BocopOptimizeSingle::~BocopOptimizeSingle
 * Destructor
 */
BocopOptimizeSingle::~BocopOptimizeSingle() {}

/**
 * \fn BocopOptimizeSingle::SolveProblem()
 * \return status
 * This is an overloaded function. It solves a single problem.
 */
int BocopOptimizeSingle::SolveProblem()
{
    int status;
    status = solve_single_problem(MyDef);
    return status;
}

