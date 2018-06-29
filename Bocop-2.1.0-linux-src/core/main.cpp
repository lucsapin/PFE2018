// This code is published under the Eclipse Public License
// File: main.cpp
// Authors: Daphne Giorgi, Vincent Grelard, Pierre Martinon
// Inria Saclay and Cmap Ecole Polytechnique
// 2012-2016

/**
* \file main.cpp
* \brief Main file to read the definition files, and solve the problem.
* \author Vincent Grelard, Daphne Giorgi
* \version 1.1.5
* \date 03/14
*
* This is the main function of BOCOP problem. It calls various Ipopt methods to create a NLP Problem.
* These methods have been defined in BocopProblem.cpp such that they can call class Problem
* methods, which converts an optimal control problem into a NLP, using discretization. Once the
* problem is correctly defined, it is solved by IPOPT, calling ADOL-C methods for derivatives.
*
*/

#if defined(_WIN32) || defined(WIN32)
#include <io.h> // for access on windows
#include <windows.h>
#endif

#include <iostream>
#include <string>
#include <fstream>
#include <time.h>
#include <sys/types.h>  // For stat().
#include <sys/stat.h>
using namespace std;

#include <IpIpoptApplication.hpp>
#include <IpSolveStatistics.hpp>
using namespace Ipopt;

#include "tools.hpp"
#include "BocopDefinition.hpp"
#include "BocopOptimize.hpp"
#include "preProcessing.hpp" //this one is similar to header_preProcessing except ending ; ...


/**
 * \fn int main(int argc,char **argv)
 * \brief Main function for BOCOP
 *
 * \param argc empty
 * \param argv empty
 * \return 0 if the optimization process went well
 */
int main(int argc, char** argv)
{
    cout << "**********************************************" << endl;
    cout << "BOCOP - A toolbox for optimal control problems" << endl;
    cout << "http://bocop.org      (Eclipse Public License)" << endl;
    cout << "**********************************************" << endl;

#ifndef NDEBUG
    cout << endl << "Warning: compilation performed in debug mode !" << endl;
#endif

    int status = 0;
    double tps = 0.;

    clock_t tStart = clock();

    // Read problem definition
    BocopDefinition MyDef("problem.def", "problem.bounds", "problem.constants");
    status = MyDef.readAll();
    if (status != 0) {
        cerr << MyDef.errorString() << endl;
        return 1;
    }
    if (MyDef.isWarning())
        cout << MyDef.warningString() << endl;

    // Call pre-processing function (problem dependent, user supplied, optional)
    status = 0;
    status = preProcessing(MyDef.dimState(),
                           MyDef.dimControl(),
                           MyDef.dimAlgebraic(),
                           MyDef.dimOptimVars(),
                           MyDef.dimConstants(),
                           MyDef.dimSteps(),
                           MyDef.constants(),
                           MyDef.discCoeffA(),
                           MyDef.discCoeffB(),
                           MyDef.discCoeffC());

    // select single problem or batch optimization
    string optimization_type = "";
    optimization_type = MyDef.getOptimizationType();
    bocopDefPtr MyDefPtr = bocopDefPtr(new BocopDefinition(MyDef));
    BocopOptimize* MyOptimization;
    if (optimization_type == "single")
        MyOptimization = new BocopOptimizeSingle(MyDefPtr);
    else if (optimization_type == "batch")
        MyOptimization = new BocopOptimizeBatch(MyDefPtr);
    else {
        cerr << " *** BocopSolveProblem : ERROR." << endl;
        cerr << "     Unknown optimization type." << endl;
        exit(1);
    }

    // perform optimization
    status = MyOptimization->SolveProblem();

    // deallocate memory
    delete MyOptimization;

    tps = (double)(clock() - tStart) / CLOCKS_PER_SEC;
    printf("Time taken: %.2fs\n", tps);

    return status;
}


//+++ add a function for external call
