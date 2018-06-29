// This code is published under the Eclipse Public License
// File: BocopOptimize.hpp
// Authors: Daphne Giorgi, Vincent Grelard, Pierre Martinon
// Inria Saclay and Cmap Ecole Polytechnique
// 2011-2016

/**
 * \file BocopOptimize.cpp
 * \brief Class BocopOptimize header.
 * \author Vincent Grelard, Daphne Giorgi
 *
 *
 * This class is used to solve the problem in the working directory,
 * calling IPOPT for optimization. It returns the status
 * integer given by IPOPT at the end of the optimization.
 * It can be called when all definition files are in the working
 * directory, and filled with appropriate information.
 * This function is based on the following :
 * Copyright (C) 2004, 2009 International Business Machines and others.
 * All Rights Reserved.
 * This code is published under the Eclipse Public License.
 * Id: cpp_example.cpp 2005 2011-06-06 12:55:16Z stefan
 * Authors:  Carl Laird, Andreas Waechter     IBM    2004-11-05
 */


#ifndef OPTI_FUNCTIONS
#define OPTI_FUNCTIONS

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <limits>
#include <cstdlib>

#include <IpIpoptApplication.hpp>
#include <IpSolveStatistics.hpp>

#include "BocopDefinition.hpp"
#include "BocopProblem.hpp"

/**
 * \class BocopOptimize
 * \brief Abstract class to solve the problem
 * \author Vincent Grelard, Daphne Giorgi
 */
class BocopOptimize
{

    protected :
        bocopDefPtr MyDef;

        int iter; // number of iterations
        double obj; // final objective
        double constr; // constraint violation
        double cpu; // total cpu time

        int solve_single_problem(const bocopDefPtr myBocopDefPtr);
        string get_status_string(const int);

    public :

        /** @name Constructor */
        BocopOptimize(const bocopDefPtr bocopDef);

        /** @name Destructor */
        virtual ~BocopOptimize();

        /** @name Solve problem */
        virtual int SolveProblem(void) = 0;

        /** @name Getters */
        int getIter() const {
            return iter;
        }
        double getObj() const {
            return obj;
        }
        double getConstr() const {
            return constr;
        }
        double getCpu() const {
            return cpu;
        }
};

/** \class BocopOptimizeBatch
  * \brief Batch optimization
  *
  * Solves a series of instances of the problem, making a constant vary.
  * For each different value of the constant we launch an optimization.
  */
class BocopOptimizeBatch : public BocopOptimize
{
    protected :
        int type; // type of element on which we make the batch optimization (element that will vary)
        int index; // index of the element to vary (for example the constant[0])
        double startingbound; // starting value of the constant
        double endingbound; // ending value of the constant
        int n_batch; // number of optimizations to perform
        int n_success; // number of successful optimizations

        string batch_dir; // name of the output directory
        string init_type; // method to generate starting point
        string name_const; // name of the constant to vary

        int solve_batch();
        void write_log_file(const int, const double, const int, const int);

    public :
        BocopOptimizeBatch(const bocopDefPtr bocopDef);
        ~BocopOptimizeBatch();
        int SolveProblem(void);
};

/** \class BocopOptimizeSingle
  * \brief Single optimization
  *
  * Solves a single instance of the problem.
  */
class BocopOptimizeSingle : public BocopOptimize
{
    protected :

    public :
        BocopOptimizeSingle(const bocopDefPtr bocopDef);
        ~BocopOptimizeSingle();
        int SolveProblem(void);
};

#endif

