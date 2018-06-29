// Copyright (C) 2013-2014 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: writeDefinition.cpp
// Authors: Daphne Giorgi

#include <BocopProblem.hpp>


/**
 * \fn void BocopProblem::writeDefinition((ofstream file_out)
 *
 * This function writes all definition files
 *
 */
void BocopProblem::writeDefinition(ofstream& file_out)
{

    int i;
    double lower, upper;
    string typeBound;

    string solFile = m_bocopDefPtr->nameSolutionFile();
    string defFile = m_bocopDefPtr->nameDefFile();
    string boundsFile = m_bocopDefPtr->nameBoundsFile();
    string constantsFile = m_bocopDefPtr->nameConstantsFile();

    file_out << "# **************************** " << endl;
    file_out << "# **************************** " << endl;
    file_out << "# *****    DEFINITION    ***** " << endl;
    file_out << "# **************************** " << endl;
    file_out << "# **************************** " << endl;
    file_out << "# # #" << endl;

    file_out << "# ********************** " << endl;
    file_out << "# ** " <<      defFile     << endl;
    file_out << "# ********************** " << endl;
    file_out << "# # #" << endl;

    file_out << "# # This file defines all dimensions and parameters "  << endl;
    file_out << "# # values for your problem :"                         << endl;
    file_out << "# # #" << endl;

    file_out << "# # Initial and final time :" << endl;
    file_out << "# time.free string "       << m_bocopDefPtr->freeTime()    << endl;
    file_out << "# time.initial double "    << m_bocopDefPtr->initialTime() << endl;
    file_out << "# time.final double "      << m_bocopDefPtr->finalTime()   << endl;
    file_out << "# # #" << endl;

    file_out << "# # Dimensions :" << endl;
    file_out << "# state.dimension integer "        << m_bocopDefPtr->dimState()            << endl;
    file_out << "# control.dimension integer "      << m_bocopDefPtr->dimControl()          << endl;
    file_out << "# algebraic.dimension integer "    << m_bocopDefPtr->dimAlgebraic()        << endl;
    file_out << "# parameter.dimension integer "    << m_bocopDefPtr->dimOptimVars()        << endl;
    file_out << "# constant.dimension integer "     << m_bocopDefPtr->dimConstants()        << endl;
    file_out << "# boundarycond.dimension integer " << m_bocopDefPtr->dimInitFinalCond()    << endl;
    file_out << "# constraint.dimension integer "   << m_bocopDefPtr->dimPathConstraints()  << endl;
    file_out << "# # #" << endl;

    file_out << "# # Discretization :" << endl;
    if (m_bocopDefPtr->isParamId())
        file_out << "# discretization.steps integer " << m_bocopDefPtr->dimStepsBeforeMerge()              << endl;
    else
        file_out << "# discretization.steps integer " << m_bocopDefPtr->dimSteps()              << endl;
    file_out << "# discretization.method string " << m_bocopDefPtr->methodDiscretization()  << endl;
    file_out << "# # #" << endl;

    file_out << "# # Optimization :" << endl;
    file_out << "# optimization.type string "   << m_bocopDefPtr->optimType()      << endl;
    file_out << "# batch.type integer "        << m_bocopDefPtr->typeBatch()       << endl;
    file_out << "# batch.index integer "        << m_bocopDefPtr->indexBatch()     << endl;
    file_out << "# batch.nrange integer "       << m_bocopDefPtr->rangeBatch()     << endl;
    file_out << "# batch.lowerbound double "    << m_bocopDefPtr->startingBatch()  << endl;
    file_out << "# batch.upperbound double "    << m_bocopDefPtr->endingBatch()    << endl;
    file_out << "# batch.directory string "     << m_bocopDefPtr->folderBatch()    << endl;
    file_out << "# # #" << endl;

    file_out << "# # Initialization :" << endl;
    file_out << "# initialization.type string " << m_bocopDefPtr->methodInitialization()    << endl;
    file_out << "# initialization.file string " << m_bocopDefPtr->nameInitializationFile()  << endl;
    file_out << "# # #" << endl;

    file_out << "# # Parameter identification :" << endl;
    file_out << "# paramid.type string "        << m_bocopDefPtr->paramIdType()             << endl;
    file_out << "# paramid.separator string "   << m_bocopDefPtr->observationSeparator()    << endl;
    file_out << "# paramid.file string "        << m_bocopDefPtr->observationFile()         << endl;
    file_out << "# paramid.dimension integer "        << m_bocopDefPtr->sizeDataSet()         << endl;
    file_out << "# # #" << endl;

    string i_str;
    file_out << "# # Names :" << endl;
    if (m_bocopDefPtr->dimState() > 0) {
        for (i = 0; i < m_bocopDefPtr->dimState(); i++) {
            stringstream sstr;
            sstr.setf(ios::scientific);
            sstr << i;
            i_str = sstr.str();
            string name = m_bocopDefPtr->nameState(i);
            file_out << "# state."          << i_str << " string " << m_bocopDefPtr->nameState(i)          << endl;
        }
    }
    if (m_bocopDefPtr->dimControl() > 0) {
        for (i = 0; i < m_bocopDefPtr->dimControl(); i++) {
            stringstream sstr;
            sstr.setf(ios::scientific);
            sstr << i;
            i_str = sstr.str();
            file_out << "# control."        << i_str << " string " << m_bocopDefPtr->nameControl(i)        << endl;
        }
    }
    if (m_bocopDefPtr->dimAlgebraic() > 0) {
        for (i = 0; i < m_bocopDefPtr->dimAlgebraic(); i++) {
            stringstream sstr;
            sstr.setf(ios::scientific);
            sstr << i;
            i_str = sstr.str();
            file_out << "# algebraic."      << i_str << " string " << m_bocopDefPtr->nameAlgebraic(i)      << endl;
        }
    }
    if (m_bocopDefPtr->dimOptimVars() > 0) {
        for (i = 0; i < m_bocopDefPtr->dimOptimVars(); i++) {
            stringstream sstr;
            sstr.setf(ios::scientific);
            sstr << i;
            i_str = sstr.str();
            file_out << "# parameter."      << i_str << " string " << m_bocopDefPtr->nameOptimVar(i)       << endl;
        }
    }
    if (m_bocopDefPtr->dimInitFinalCond() > 0) {
        for (i = 0; i < m_bocopDefPtr->dimInitFinalCond(); i++) {
            stringstream sstr;
            sstr.setf(ios::scientific);
            sstr << i;
            i_str = sstr.str();
            file_out << "# boundarycond."   << i_str << " string " << m_bocopDefPtr->nameInitFinalCond(i)  << endl;
        }
    }
    if (m_bocopDefPtr->dimPathConstraints() > 0) {
        for (i = 0; i < m_bocopDefPtr->dimPathConstraints(); i++) {
            stringstream sstr;
            sstr.setf(ios::scientific);
            sstr << i;
            i_str = sstr.str();
            file_out << "# constraint."     << i_str << " string " << m_bocopDefPtr->namePathConstraint(i) << endl;
        }
    }
    if (m_bocopDefPtr->dimConstants() > 0) {
        for (i = 0; i < m_bocopDefPtr->dimConstants(); i++) {
            stringstream sstr;
            sstr.setf(ios::scientific);
            sstr << i;
            i_str = sstr.str();
            file_out << "# constant."       << i_str << " string " << m_bocopDefPtr->nameConstant(i)       << endl;
        }
    }
    file_out << "# # #" << endl;

    file_out << "# # Solution file :" << endl;
    file_out << "# solution.file string " << solFile    << endl;
    file_out << "# # #" << endl;
    file_out << "# # #" << endl;

    file_out << "# ********************** " << endl;
    file_out << "# ** " <<   boundsFile     << endl;
    file_out << "# ********************** " << endl;
    file_out << "# # #" << endl;

    file_out << "# # This file contains all the bounds of your problem."  << endl;
    file_out << "# # Bounds are stored in standard format : "             << endl;
    file_out << "# # [lower bound]  [upper bound] [type of bound]"        << endl;
    file_out << "# # #" << endl;

    file_out << "# # Dimensions (i&f conditions, y, u, z, p, path constraints) :" << endl;
    file_out << "# " << m_bocopDefPtr->dimInitFinalCond()    << " ";
    file_out <<         m_bocopDefPtr->dimState()            << " ";
    file_out <<         m_bocopDefPtr->dimControl()          << " ";
    file_out <<         m_bocopDefPtr->dimAlgebraic()        << " ";
    file_out <<         m_bocopDefPtr->dimOptimVars()        << " ";
    file_out <<         m_bocopDefPtr->dimPathConstraints()  << endl;
    file_out << "# # #" << endl;

    file_out << "# # Bounds for the initial and final conditions :" << endl;
    if (m_bocopDefPtr->dimInitFinalCond() > 0) {
        for (i = 0; i < m_bocopDefPtr->dimInitFinalCond(); i++) {
            m_bocopDefPtr->lowerBoundInitFinalCond(i, lower);
            m_bocopDefPtr->upperBoundInitFinalCond(i, upper);
            m_bocopDefPtr->typeBoundInitFinalCond(i, typeBound);
            file_out << "# " << lower << " " << upper << " " <<  typeBound << endl;
        }
    }
    file_out << "# # #" << endl;

    file_out << "# # Bounds for the state variables :" << endl;
    if (m_bocopDefPtr->dimState() > 0) {
        for (i = 0; i < m_bocopDefPtr->dimState(); i++) {
            m_bocopDefPtr->lowerBoundVariable(i, lower);
            m_bocopDefPtr->upperBoundVariable(i, upper);
            m_bocopDefPtr->typeBoundVariable(i, typeBound);
            file_out << "# " << lower << " " << upper << " " <<  typeBound << endl;
        }
    }
    file_out << "# # #" << endl;

    file_out << "# # Bounds for the control variables :" << endl;
    if (m_bocopDefPtr->dimControl() > 0) {
        for (i = 0; i < m_bocopDefPtr->dimControl(); i++) {
            m_bocopDefPtr->lowerBoundVariable(m_bocopDefPtr->dimState() + i, lower);
            m_bocopDefPtr->upperBoundVariable(m_bocopDefPtr->dimState() + i, upper);
            m_bocopDefPtr->typeBoundVariable(m_bocopDefPtr->dimState() + i, typeBound);
            file_out << "# " << lower << " " << upper << " " <<  typeBound << endl;
        }
    }
    file_out << "# # #" << endl;

    file_out << "# # Bounds for the algebraic variables :" << endl;
    if (m_bocopDefPtr->dimAlgebraic() > 0) {
        for (i = 0; i < m_bocopDefPtr->dimAlgebraic(); i++) {
            m_bocopDefPtr->lowerBoundVariable(m_bocopDefPtr->dimState() + m_bocopDefPtr->dimControl() + i, lower);
            m_bocopDefPtr->upperBoundVariable(m_bocopDefPtr->dimState() + m_bocopDefPtr->dimControl() + i, upper);
            m_bocopDefPtr->typeBoundVariable(m_bocopDefPtr->dimState() + m_bocopDefPtr->dimControl() + i, typeBound);
            file_out << "# " << lower << " " << upper << " " <<  typeBound << endl;
        }
    }
    file_out << "# # #" << endl;

    file_out << "# # Bounds for the optimization parameters :" << endl;
    if (m_bocopDefPtr->dimOptimVars() > 0) {
        for (i = 0; i < m_bocopDefPtr->dimOptimVars(); i++) {
            m_bocopDefPtr->lowerBoundVariable(m_bocopDefPtr->dimState() + m_bocopDefPtr->dimControl() + m_bocopDefPtr->dimAlgebraic() + i, lower);
            m_bocopDefPtr->upperBoundVariable(m_bocopDefPtr->dimState() + m_bocopDefPtr->dimControl() + m_bocopDefPtr->dimAlgebraic() + i, upper);
            m_bocopDefPtr->typeBoundVariable(m_bocopDefPtr->dimState() + m_bocopDefPtr->dimControl() + m_bocopDefPtr->dimAlgebraic() + i, typeBound);
            file_out << "# " << lower << " " << upper << " " <<  typeBound << endl;
        }
    }
    file_out << "# # #" << endl;

    file_out << "# # Bounds for the path constraints :" << endl;
    if (m_bocopDefPtr->dimPathConstraints() > 0) {
        for (i = 0; i < m_bocopDefPtr->dimPathConstraints(); i++) {
            m_bocopDefPtr->lowerBoundPathConstraint(i, lower);
            m_bocopDefPtr->upperBoundPathConstraint(i, upper);
            m_bocopDefPtr->typeBoundPathConstraint(i, typeBound);
            file_out << "# " << lower << " " << upper << " " <<  typeBound << endl;
        }
    }
    file_out << "# # #" << endl;

    file_out << "# ********************** " << endl;
    file_out << "# ** " <<  constantsFile   << endl;
    file_out << "# ********************** " << endl;
    file_out << "# # #" << endl;

    file_out << "# # This file contains the values of the constants of your problem."   << endl;
    file_out << "# # Number of constants used in your problem : "                       << endl;
    file_out << "# " << m_bocopDefPtr->dimConstants() << endl;
    file_out << "# # #" << endl;
    file_out << "# # Values of the constants : "  << endl;
    if (m_bocopDefPtr->dimConstants() > 0) {
        for (i = 0; i < m_bocopDefPtr->dimConstants(); i++)
            file_out << "# " << m_bocopDefPtr->constants()[i] << endl;
    }
    file_out << "# # #" << endl;

    // ***** Definition data *****
    // We write all the definition informations at the beginning, in order to be able
    // to retrieve all the parameters leading to the solution contained in the file :

    string name = "";
    string variableName = "";
    string interpType = "";
    int dimGen = 0;

    // First we write the initialization values of the states
    for (i = 0; i < m_bocopDefPtr->dimState(); ++i) {

        stringstream sstr;
        sstr.setf(ios::scientific);
        sstr << i;
        i_str = sstr.str();
        name = "init/state." + i_str + ".init";

        // We get the name of the current variable
        variableName = m_bocopDefPtr->nameState(i);

        // We get the initialization type (constant, linear or splines) of the current variable
        interpType = m_genState[i].getGenType();

        // We get the dimension of the generation variable
        dimGen = m_genState[i].GetDimension();

        // We get the generation variable values and times of the current variable
        double* varGen = new double[dimGen];
        double* timeGen = new double[dimGen];
        m_genState[i].GetVar(varGen);
        m_genState[i].GetT(timeGen);

        file_out << "# ********************** " << endl;
        file_out << "# ** " << name  << endl;
        file_out << "# ********************** " << endl;
        file_out << "# # #" << endl;

        file_out << "# # Starting point file." << endl;
        file_out << "# # This file contains the values of the initial points" << endl;
        file_out << "# # for variable " << variableName  << endl;
        file_out << "# # #" << endl;

        file_out << "# # Type of initialization : " << endl;
        file_out << "# " << interpType << endl;
        file_out << "# # #" << endl;

        if (interpType == "constant") {
            file_out << "# # Constant value for the starting point :" << endl;
            file_out << "# " << varGen[0] << endl;
            file_out << "# # #" << endl;
        } else if (interpType == "linear" || interpType == "splines") {
            file_out << "# #  Number of interpolation points :" << endl;
            file_out << "# " << dimGen << endl;
            file_out << "# # #" << endl;
            file_out << "# # Interpolation points for the starting point " << endl;
            for (int j = 0; j < dimGen; j++) {
                file_out << "# " << timeGen[j] << " " << varGen[j] << endl;
            }
            file_out << "# # #" << endl;
        } else {
            cerr << endl << " ** BocopProblem::writeDefintion : WARNING." << endl;
            cerr << "Interpolation type for state variable " << variableName << " is not a valid type (constant, linear, or splines)" << endl;
            cerr << "Read interpolation type : " << interpType << endl;
        }

        delete[] varGen;
        delete[] timeGen;
    }

    // Then we write the initialization values of the controls
    for (i = 0; i < m_bocopDefPtr->dimControl(); ++i) {
        stringstream sstr;
        sstr.setf(ios::scientific);
        sstr << i;
        i_str = sstr.str();
        name = "init/control." + i_str + ".init";

        // We get the name of the current variable
        variableName = m_bocopDefPtr->nameControl(i);

        // We get the initialization type (constant, linear or splines)
        interpType = m_genControl[i].getGenType();

        // We get the dimension of the generation variable
        dimGen = m_genControl[i].GetDimension();

        // We get the generation variable values and times of the current variable
        double* varGen = new double[dimGen];
        double* timeGen = new double[dimGen];
        m_genControl[i].GetVar(varGen);
        m_genControl[i].GetT(timeGen);

        file_out << "# ********************** " << endl;
        file_out << "# ** " << name  << endl;
        file_out << "# ********************** " << endl;
        file_out << "# # #" << endl;

        file_out << "# # Starting point file." << endl;
        file_out << "# # This file contains the values of the initial points" << endl;
        file_out << "# # for variable " << variableName  << endl;
        file_out << "# # #" << endl;

        file_out << "# # Type of initialization : " << endl;
        file_out << "# " << interpType << endl;
        file_out << "# # #" << endl;

        if (interpType == "constant") {
            file_out << "# # Constant value for the starting point :" << endl;
            file_out << "# " << varGen[0] << endl;
            file_out << "# # #" << endl;
        } else if (interpType == "linear" || interpType == "splines") {
            file_out << "# #  Number of interpolation points :" << endl;
            file_out << "# " << dimGen << endl;
            file_out << "# # #" << endl;
            file_out << "# # Interpolation points for the starting point " << endl;
            for (int j = 0; j < dimGen; j++) {
                file_out << "# " << timeGen[j] << " " << varGen[j] << endl;
            }
            file_out << "# # #" << endl;
        } else {
            cerr << endl << " ** BocopProblem::writeDefintion : WARNING." << endl;
            cerr << "Interpolation type for control variable " << variableName << " is not a valid type (constant, linear, or splines)" << endl;
            cerr << "Read interpolation type : " << interpType << endl;
        }

        delete[] varGen;
        delete[] timeGen;
    }

    // Then we write the initialization values of the algebraic values
    for (i = 0; i < m_bocopDefPtr->dimAlgebraic(); ++i) {
        stringstream sstr;
        sstr.setf(ios::scientific);
        sstr << i;
        i_str = sstr.str();
        name = "init/algebraic." + i_str + ".init";

        // We get the name of the current variable
        variableName = m_bocopDefPtr->nameAlgebraic(i);

        // We get the initialization type (constant, linear or splines)
        interpType = m_genAlgebraic[i].getGenType();

        // We get the dimension of the generation variable
        dimGen = m_genAlgebraic[i].GetDimension();

        // We get the generation variable values and times of the current variable
        double* varGen = new double[dimGen];
        double* timeGen = new double[dimGen];
        m_genAlgebraic[i].GetVar(varGen);
        m_genAlgebraic[i].GetT(timeGen);

        file_out << "# ********************** " << endl;
        file_out << "# ** " << name  << endl;
        file_out << "# ********************** " << endl;
        file_out << "# # #" << endl;

        file_out << "# # Starting point file." << endl;
        file_out << "# # This file contains the values of the initial points" << endl;
        file_out << "# # for variable " << variableName  << endl;
        file_out << "# # #" << endl;

        file_out << "# # Type of initialization : " << endl;
        file_out << "# " << interpType << endl;
        file_out << "# # #" << endl;

        if (interpType == "constant") {
            file_out << "# # Constant value for the starting point :" << endl;
            file_out << "# " << varGen[0] << endl;
            file_out << "# # #" << endl;
        } else if (interpType == "linear" || interpType == "splines") {
            file_out << "# #  Number of interpolation points :" << endl;
            file_out << "# " << dimGen << endl;
            file_out << "# # #" << endl;
            file_out << "# # Interpolation points for the starting point " << endl;
            for (int j = 0; i < dimGen; i++) {
                file_out << "# " << timeGen[j] << " " << varGen[j] << endl;
            }
            file_out << "# # #" << endl;
        } else {
            cerr << endl << " ** BocopProblem::writeDefintion : WARNING." << endl;
            cerr << "Interpolation type for algebraic variable " << variableName << " is not a valid type (constant, linear, or splines)" << endl;
            cerr << "Read interpolation type : " << interpType << endl;
        }

        delete[] varGen;
        delete[] timeGen;
    }

    // And finally we write the constant initialization values of the optimization parameters
    if (m_bocopDefPtr->dimOptimVars() != 0) {

        file_out << "# ********************** " << endl;
        file_out << "# ** init/optimvars.init"  << endl;
        file_out << "# ********************** " << endl;
        file_out << "# # #" << endl;

        file_out << "# # Optimization parameters starting point file." << endl;
        file_out << "# # This file contains initialization values" << endl;
        file_out << "# # for all optimization parameters" << endl;
        file_out << "# # #" << endl;

        file_out << "# # Number of optimization parameters :" << endl;
        file_out << "# " << m_bocopDefPtr->dimOptimVars() << endl;
        file_out << "# # #" << endl;

        file_out << "# # Initial values : " << endl;
        for (int j = 0; j < m_bocopDefPtr->dimOptimVars(); j++) {
            file_out << "# " << m_genParameter[j] << endl;
        }

        file_out << "# # #" << endl;
    }

    // Then the number of stages of the discretization method :
    file_out << "# discretization.stages integer " << m_bocopDefPtr->dimStages() << endl;

    // Then the number of steps after merge
    file_out << "# discretization.steps.after.merge " << m_bocopDefPtr->dimSteps() << endl;
}

