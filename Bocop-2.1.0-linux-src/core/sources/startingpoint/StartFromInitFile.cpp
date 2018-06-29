// Copyright (C) 2011 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: start_full_init.cpp
// Authors: Vincent Grelard

#include "StartingPoint.hpp"


// This function sets a starting point for the discretized variables.
// It reads these values from files state, control, algebraic and
// parameter, defined with the graphical interface.
int StartFromInitFile::setStartingPoint()
{
    int status;

    status = readVariables();
    if (status != 0) {
        cerr << endl << "Error in StartingPoint::readVariables() " << endl << endl;
        return 1;
    }

    status = interpolateVariables();
    if (status != 0) {
        cerr << endl << "Error in StartingPoint::interpolateVariables() "  << endl << endl;
        return 2;
    }

    status = generateStartingPoint();
    if (status != 0) {
        cerr << endl << "Error in StartingPoint::generateStartingPoint() " << endl << endl;
        return 3;
    }

    return 0;
}


StartFromInitFile::~StartFromInitFile()
{
}


// This function reads the variables stored in a initialization file. It
// returns the values of each variables on the discretization points.
// It also gives the dimensions found in this file.
int StartFromInitFile::readVariables()
{
    int status;

    // First we allocate space for the variables we will read :
    status = allocateGenerationVars();
    if (status != 0) {
        cerr << " StartFromInitFile::readVariables() : ERROR" << endl;
        cerr << " Cannot allocate memory for the generation variables" << endl;
        return 1;
    }

    // Now we have to fill each generation var :
    string init_file;
    string i_str;

    for (int i = 0; i < this->m_dimState; ++i) {
        // We need to read a file with a standard name :
        // <type of var>.<#>.init. So to get the filename,
        // first, we need to convert i to a string format :
        stringstream sstr;
        sstr.setf(ios::scientific);
        sstr << i;
        i_str = sstr.str();

        // And then we concatenate the strings :
        init_file = "init/state." + i_str + ".init";

        status = m_genState[i].SetFromInitFile(init_file);
        if (status != 0) {
            cerr << " StartFromInitFile::readVariables() : ERROR" << endl;
            cerr << " An error occurred while reading init file for state #" << i << endl;
            return 1;
        }
    }


    for (int i = 0; i < this->m_dimControl; ++i) {
        // We need to read a file with a standard name :
        // <type of var>.<#>.init. So to get the filename,
        // first, we need to convert i to a string format :
        stringstream sstr;
        sstr.setf(ios::scientific);
        sstr << i;
        i_str = sstr.str();

        // And then we concatenate the strings :
        init_file = "init/control." + i_str + ".init";

        status = m_genControl[i].SetFromInitFile(init_file);
        if (status != 0) {
            cerr << " StartFromInitFile::readVariables() : ERROR" << endl;
            cerr << " An error occurred while reading init file for control #" << i << endl;
            return 1;
        }
    }

    for (int i = 0; i < this->m_dimAlgebraic; ++i) {
        // We need to read a file with a standard name :
        // <type of var>.<#>.init. So to get the filename,
        // first, we need to convert i to a string format :
        stringstream sstr;
        sstr.setf(ios::scientific);
        sstr << i;
        i_str = sstr.str();

        // And then we concatenate the strings :
        init_file = "init/algebraic." + i_str + ".init";

        status = m_genAlgebraic[i].SetFromInitFile(init_file);
        if (status != 0) {
            cerr << " StartFromInitFile::readVariables() : ERROR" << endl;
            cerr << " An error occurred while reading init file for algebraic variable #" << i << endl;
            return 1;
        }
    }

    // Finally we read the optimization variables :
    if (m_dimParameter != 0) {
        status = readOptimVars();
        if (status != 0) {
            cerr << " StartFromInitFile::readVariables() : ERROR" << endl;
            cerr << " An error occurred while reading init file for the optimization variables" << endl;
            return 2;
        }
    }


    return 0;
}



// Function to read p (optimization variables that do not
// vary wrt time) from an init file :
int StartFromInitFile::readOptimVars()
{
    string init_file = "init/optimvars.init";
    ifstream ifile(init_file.c_str(), ios::in | ios::binary);
    if (!ifile) {
        cout << endl << " *****  Warning  ***** " << endl;
        cout << " In StartFromInitFile::readOptimVars()." << endl;
        cout << " Cannot open initialization file (\"" << init_file << "\")." << endl;
        cout << " Warning : a new DEFAULT init file will now be created."  << endl << endl;

        // We create a new default file :
        default_optimvars_init_file(init_file, this->m_dimParameter);

        // We try to open the new file :
        ifile.open(init_file.c_str(), ios::in | ios::binary);

        if (!ifile) {
            cout << endl << " *****  ERROR  ***** " << endl;
            cout << " In StartFromInitFile::readOptimVars()." << endl;
            cout << " Cannot open initialization file (\"" << init_file << "\")." << endl << endl;
            return 1;
        }
    }

    streampos current_pos;
    current_pos = ifile.tellg();
    skip_comments(ifile, current_pos);

    // The first non commented line in this file should be the number of
    // optimization variables :
    int p_temp;
    ifile >> p_temp;

    if (p_temp != this->m_dimParameter) {
        cerr << " StartFromInitFile::readOptimVars() : ERROR! " << endl;
        cerr << " Dimensions for optimization variables do not match between " << endl;
        cerr << " definition file, and optimvars init file..." << endl;
        return 2;
    }

    current_pos = ifile.tellg();
    skip_comments(ifile, current_pos);

    for (int i = 0; i < this->m_dimParameter; ++i)
        ifile >> this->m_parameter[i];

    return 0;

}


// This function allows to generate a new default init file for the optimization variables.
// It creates a new file in <problem's directory>/init/. If the init folder
// does not exist, we exit with an error.
int StartFromInitFile::default_optimvars_init_file(const string file_path, const int dim_optimvars) const
{
    // We create the file (file_path should be a filename located in folder "init"
    // relative to the problem's directory, e.g. file_path="init/state.X.init")
    ofstream file_init(file_path.c_str(), ios::out | ios::binary);
    if (!file_init)  { // if the opening failed
        cout << endl << " *****  Warning  ***** " << endl;
        cout << " \"init\" directory not found. Attempting to create it..." << endl << endl;
        int stat = 1;

        if (stat != 0) {
            cerr << endl << " *****  ERROR  ***** " << endl;
            cerr << " Cannot create a new default initialization file." << endl;
            cerr << " Maybe the \"/init\" folder doesn't exist in your" << endl;
            cerr << " problem's directory, please create it..." << endl;
            return 1;
        }
    }

    file_init << "# This is a DEFAULT initialization file..." << endl;
    file_init << "# Please give correct values for the starting point." << endl << endl;
    file_init << "# Number of optimization variables : " << endl;
    file_init << dim_optimvars << endl << endl;
    file_init << "# Default values for the starting point : " << endl;
    for (int i = 0; i < dim_optimvars; ++i)
        file_init << "0.1" << endl; // 0.1 and not 0 to reduce the risk of math errors

    file_init.close();

    return 0;

}


int StartFromInitFile::setSolutionFile(string str)
{
    cout << "StartFromInitFile::setSolutionFile : undefined function" << endl;
    return 1;
}
