// This code is published under the Eclipse Public License
// File: bocop_solution.cpp
// Authors: Vincent Grelard, Daphne Giorgi, Virgile Andreani
// Inria Saclay and CMAP Ecole Polytechnique
// 2011-2017

#include <cstdlib>
#include <iostream>
#include <string>
#include <fstream>
#include <sstream>

using namespace std;

#include "bocop_solution.hpp"

BocopSolution::BocopSolution(string SOL_FILE){
    sol_file = SOL_FILE;
    
    // dimension initialization :
    dim_state = -1;
    dim_control = -1;
    dim_algebraic = -1;
    dim_optimvars = -1;
    dim_constants = -1;
    dim_ifcond = -1;
    dim_pathcond = -1;
    dim_steps = -1;
    dim_stepsAfterMerge = -1;
    dim_stages = -1;

    // pointer initialization :
    time_steps = 0;
    time_stages = 0;

    state = 0;
    control = 0;
    averageControl = 0;
    algebraic = 0;
    optimvars = 0;
    constants = 0;

    ifcond = 0;
    bound_pathcond = 0;
    pathcond = 0;
    dyncond = 0;

    ifcondMultipliers = 0;
    pathcondMultipliers = 0;
    dyncondMultipliers = 0;

    coeff_b_i = 0;

}


BocopSolution::~BocopSolution()
{
    if (this->time_steps != 0)
        delete[] this->time_steps;
    if (this->time_stages != 0)
        delete[] this->time_stages;


    if (this->state != 0) {
        for (int i = 0; i < this->dim_state; i++)
            delete[] state[i];
        delete[] state;
    }
    if (this->control != 0) {
        for (int i = 0; i < this->dim_control; i++)
            delete[] control[i];
        delete[] control;
    }
    if (this->averageControl != 0) {
        for (int i = 0; i < this->dim_control; i++)
            delete[] averageControl[i];
        delete[] averageControl;
    }
    if (this->algebraic != 0) {
        for (int i = 0; i < this->dim_algebraic; i++)
            delete[] algebraic[i];
        delete[] algebraic;
    }


    if (this->optimvars != 0)
        delete[] this->optimvars;
    if (this->constants != 0)
        delete[] this->constants;


    if (this->ifcond != 0) {
        for (int i = 0; i < this->dim_ifcond; i++)
            delete[] ifcond[i];
        delete[] ifcond;
    }
    if (this->pathcond != 0) {
        for (int i = 0; i < this->dim_pathcond; i++)
            delete[] pathcond[i];
        delete[] pathcond;
    }
    if (this->bound_pathcond != 0) {
        for (int i = 0; i < this->dim_pathcond; i++)
            delete[] bound_pathcond[i];
        delete[] bound_pathcond;
    }
    if (this->dyncond  != 0) {
        for (int i = 0; i < this->dim_state; i++)
            delete[] dyncond[i];
        delete[] dyncond;
    }

    if (this->ifcondMultipliers != 0) {
        delete[] ifcondMultipliers;
    }
    if (this->pathcondMultipliers != 0) {
        for (int i = 0; i < this->dim_pathcond; i++)
            delete[] pathcondMultipliers[i];
        delete[] pathcondMultipliers;
    }
    if (this->dyncondMultipliers  != 0) {
        for (int i = 0; i < this->dim_state; i++)
            delete[] dyncondMultipliers[i];
        delete[] dyncondMultipliers;
    }

    if (this->coeff_b_i != 0) {
        delete[] coeff_b_i;
    }

}


int BocopSolution::readSolutionFile()
{
    emit loading_begin();

    emit loaded(0);
    int status;

    status = readDimensions();
    if (status != 0)
        return status;

    emit loaded(5);
    
    status = allocateVectors();
    if (status != 0)
        return status;

    emit loaded(6);

    status = readDefinitionComments();
    if (status != 0)
        return status;
    
    status = readVariablesAndConstraints();
    if (status != 0)
        return status;

    status = calculateAverageControl();
    if (status != 0)
        return status;
    
    emit loading_end();
    return 0;
}


/**
 *\fn int BocopSolution::readDefinitionComments(void)
 *This method allows to read all the comments at the beginning of the solution file.
 *These comments give a summary of the problem definition that lead to this
 *solution file.
 */
int BocopSolution::readDefinitionComments(void)
{
    int i, j;

    // First we try to open the solution file :
    ifstream ifile (this->sol_file.c_str(), ios::in | ios::binary);
    if (!ifile) {
        m_errorString.append ("Error in BocopSolution::readDefinitionComments()\n");
        m_errorString.append ("Cannot open the specified solution file (" + sol_file + ")\n");
        return 1;
    }

    // We build the arrays of names to look for :
    vector<string> default_names;
    default_names.reserve(dim_state+dim_control+dim_algebraic+dim_optimvars+dim_ifcond+dim_pathcond+dim_state+dim_ifcond+dim_pathcond+dim_state);
    //    default_names.reserve(dim_state+dim_control+dim_algebraic+dim_optimvars+dim_ifcond+dim_pathcond+dim_state+dim_constants);
    for (i=0; i<dim_state; ++i) {
        stringstream sstr;
        sstr << i;
        string name = "state."+sstr.str()+" ";
        default_names.push_back(name);
    }
    for (i=0; i<dim_control; ++i) {
        stringstream sstr;
        sstr << i;
        string name = "control."+sstr.str()+" ";
        default_names.push_back(name);
    }
    for (i=0; i<dim_algebraic; ++i) {
        stringstream sstr;
        sstr << i;
        string name = "algebraic."+sstr.str()+" ";
        default_names.push_back(name);
    }
    for (i=0; i<dim_optimvars; ++i) {
        stringstream sstr;
        sstr << i;
        string name = "parameter."+sstr.str()+" ";
        default_names.push_back(name);
    }
    for (i=0; i<dim_ifcond; ++i) {
        stringstream sstr;
        sstr << i;
        string name = "boundarycond."+sstr.str()+" ";
        default_names.push_back(name);
    }
    for (i=0; i<dim_pathcond; ++i) {
        stringstream sstr;
        sstr << i;
        string name = "constraint."+sstr.str()+" ";
        default_names.push_back(name);
    }
    for (i=0; i<dim_state; ++i) {
        stringstream sstr;
        sstr << i;
        string name = "dyncond."+sstr.str()+" ";
        default_names.push_back(name);
    }
    for (i=0; i<dim_ifcond; ++i) {
        stringstream sstr;
        sstr << i;
        string name = "boundCondMult."+sstr.str()+" ";
        default_names.push_back(name);
    }
    for (i=0; i<dim_pathcond; ++i) {
        stringstream sstr;
        sstr << i;
        string name = "pathConstrMult."+sstr.str()+" ";
        default_names.push_back(name);
    }
    for (i=0; i<dim_state; ++i) {
        stringstream sstr;
        sstr << i;
        string name = "adjointState."+sstr.str()+" ";
        default_names.push_back(name);
    }
    //    for (i=1; i<=dim_constants; ++i) {
    //        stringstream sstr;
    //        sstr << i;
    //        string name = "constant."+sstr.str()+" ";
    //        default_names.push_back(name);
    //    }

    vector<string> comments;
    string line;

    // The definition of the problem in problem.sol is at the beginning
    // of the file. It is written in commented lines, we read them :
    char first_char;


    // We read the beginning of the solution file, it contains commented (#)
    // lines giving the definition of the problem solved.
    ifile >> first_char;
    while (first_char == '#') {
        getline(ifile,line);
        comments.push_back(line);

        ifile >> first_char;
    }

    // The names array has the same size as the defaults :
    names.resize(default_names.size());

    // Now we look for each name of the list in the comments :
    bool name_was_found;

    for (i=0; i<(int)default_names.size(); ++i) {
        size_t found;
        name_was_found = false;

        // We skim through all the comments, looking for the current name :
        for (j=0; j<(int)comments.size(); ++j) {
            found = comments[j].find(default_names[i]);

            // If the name is found :
            if (found!=string::npos) {
                //                cout << default_names[i] << " found at: " << j << endl;

                // We look for the position of the middle string
                // containing the type ("string"):
                size_t found_val;
                found_val = comments[j].find(" string ");

                // We get what remains after "string" : the name of the variable
                if (found_val!=string::npos) {
                    names.at(i) = comments[j].substr(found_val+8); // +8 to skip " string "
                    name_was_found = true;
                }
                break;
            }
        }

        if (!name_was_found)
            names.at(i) = default_names.at(i);
    }


    return 0;
}


/**
 *\fn int BocopSolution::readDimensions(void)
 *This function reads the dimensions of the problem solved from the solution file
 *generated at the end of the optimization.
 */
int BocopSolution::readDimensions(void)
{

    // First we try to open the solution file :
    ifstream ifile (this->sol_file.c_str(), ios::in | ios::binary);
    if (!ifile) {
        m_errorString.append ("Error in BocopSolution::ReadDimensions()\n");
        m_errorString.append ("Cannot open the specified solution file (" + sol_file + ")\n");
        return 1;
    }

    // The dimensions of the problem in problem.sol are at the beginning
    // of the file. They are written in commented lines, so we will only
    // look for the lines starting with "#" :
    char first_char;
    string first_word, type;
    string line;


    // We read the beginning of the solution file, it contains commented (#)
    // lines giving the definition of the problem solved.
    ifile >> first_char;
    while (first_char == '#') {
        ifile >> first_word;

        if (first_word == "time.free")
            ifile >> type >> m_timeFree;
        else if (first_word == "time.initial")
            ifile >> type >> m_initialTime;
        else if (first_word == "time.final")
            ifile >> type >> m_finalTime;
        else if (first_word == "discretization.steps")
            ifile >> type >> dim_steps;
        else if (first_word == "discretization.stages")
            ifile >> type >> dim_stages;
        else if (first_word == "state.dimension")
            ifile >> type >> dim_state;
        else if (first_word == "control.dimension")
            ifile >> type >> dim_control;
        else if (first_word == "algebraic.dimension")
            ifile >> type >> dim_algebraic;
        else if (first_word == "parameter.dimension")
            ifile >> type >> dim_optimvars;
        else if (first_word == "constant.dimension")
            ifile >> type >> dim_constants;
        else if (first_word == "boundarycond.dimension")
            ifile >> type >> dim_ifcond;
        else if (first_word == "constraint.dimension")
            ifile >> type >> dim_pathcond;
        else if (first_word == "discretization.steps.after.merge")
            ifile >> dim_stepsAfterMerge;
        else
            getline (ifile, line);

        ifile >> first_char;
    }
    ifile.close();

    if (dim_stepsAfterMerge == -1)
        dim_stepsAfterMerge = dim_steps;

    // If one of the dimensions was not found
    if ( (this->dim_state < 0) | (dim_control < 0) | (dim_algebraic < 0)
         | (dim_optimvars < 0) | (dim_ifcond < 0) | (dim_pathcond < 0)
         | (dim_steps < 0) | (dim_stages < 0) | (dim_stepsAfterMerge <0)) {
        m_errorString.append ("Error in BocopSolution::ReadDimensions()\n");
        m_errorString.append (" Unable to read the dimensions of the problem in the solution file.\n");
        return 2;
    }
    return 0;
}


/**
 *\fn int BocopSolution::allocateVectors(void)
 *This function is called once the dimensions are read. It allocates space
 *in memory for the vectors of variables :
 */
int BocopSolution::allocateVectors(void)
{
    time_steps =  new double[dim_stepsAfterMerge+1];
    time_stages = new double[dim_stepsAfterMerge*dim_stages];

    state = new double* [dim_state];
    for (int i=0; i<dim_state; ++i) {
        state[i] = new double[dim_stepsAfterMerge+1];
    }

    control = new double* [dim_control];
    for (int i=0; i<dim_control; ++i) {
        control[i] = new double[dim_stepsAfterMerge*dim_stages];
    }

    averageControl = new double* [dim_control];
    for (int i=0; i<dim_control; ++i) {
        averageControl[i] = new double[dim_stepsAfterMerge];
    }

    algebraic = new double* [dim_algebraic];
    for (int i=0; i<dim_algebraic; ++i) {
        algebraic[i] = new double[dim_stepsAfterMerge*dim_stages];
    }

    optimvars =  new double[dim_optimvars];
    constants =  new double[dim_constants];

    ifcond = new double* [dim_ifcond];
    for (int i=0; i<dim_ifcond; ++i) {
        ifcond[i] = new double[4];
    }
    pathcond = new double* [dim_pathcond];
    for (int i=0; i<dim_pathcond; ++i) {
        pathcond[i] = new double[dim_stepsAfterMerge*dim_stages];
    }
    bound_pathcond = new double* [dim_pathcond];
    for (int i=0; i<dim_pathcond; ++i) {
        bound_pathcond[i] = new double[3];
    }
    dyncond = new double* [dim_state];
    for (int i=0; i<dim_state; ++i) {
        dyncond[i] = new double[dim_stepsAfterMerge];
    }

    ifcondMultipliers = new double[dim_ifcond];

    pathcondMultipliers = new double* [dim_pathcond];
    for (int i=0; i<dim_pathcond; ++i) {
        pathcondMultipliers[i] = new double[dim_stepsAfterMerge*dim_stages];
    }

    dyncondMultipliers = new double* [dim_state];
    for (int i=0; i<dim_state; ++i) {
        dyncondMultipliers[i] = new double[dim_stepsAfterMerge];
    }

    coeff_b_i = new double[dim_stages];

    return 0;
    
}


/**
 *\fn int BocopSolution::readVariablesAndConstraints(void)
 *This function reads the solution file
 *and takes the informations about the variables, the constraints and the multipliers
 */
int BocopSolution::readVariablesAndConstraints(void)
{
    // First we try to open the solution file :
    ifstream ifile (this->sol_file.c_str(), ios::in | ios::binary);
    if (!ifile) {
        m_errorString.append ("Error in BocopSolution::readVariablesAndConstraints()\n");
        m_errorString.append ("Cannot open the specified solution file (" + sol_file + ")\n");
        return 1;
    }

    string trash;
    int i, j;

    // The dimensions of the problem in problem.sol are at the beginning
    // of the file. They are written in commented lines, so we will only
    // look for the lines starting with "#" :
    skipComments(ifile);

    // The first non commented line should be the value of the objective :
    try {

        skipComments(ifile);
        ifile >> objective;

        skipComments(ifile);
        ifile >> constr_viol;

        skipComments(ifile);
        ifile >> trash; // constr_viol 2

        skipComments(ifile);
        ifile >> trash; // discretization.stages
    }
    catch (...) {
        m_errorString.append ("Error in BocopSolution::readVariablesAndConstraints()\n");
        m_errorString.append ("Cannot read the objective or constraints violation...\n");
        return 2;
    }

    // Next we should find the times arrays :
    try {

        skipComments(ifile);

        for (i=0; i<dim_stepsAfterMerge; ++i)
        {
            ifile >> time_steps[i];

            for(j=0;j<dim_stages;++j)
                ifile >> time_stages[i*dim_stages+j];
        }
        ifile >> time_steps[dim_stepsAfterMerge]; // last time step (on the bound of the time domain)
    }
    catch (...) {
        m_errorString.append ("Error in BocopSolution::readVariablesAndConstraints()\n");
        m_errorString.append ("Cannot read the time discretization arrays...\n");
        return 3;
    }

    // Next we should read the state variables :
    try {
        for (i=0; i<dim_state; ++i) {
            skipComments(ifile);

            for (j=0; j<dim_stepsAfterMerge+1; ++j)
                ifile >> state[i][j];
        }
    }
    catch (...) {
        m_errorString.append ("Error in BocopSolution::readVariablesAndConstraints()\n");
        m_errorString.append ("Cannot read the discretized state variables arrays...\n");
        return 4;
    }

    // Next we should read the control variables :
    try {
        for (i=0; i<dim_control; ++i) {
            skipComments(ifile);

            for (j=0; j<dim_stepsAfterMerge*dim_stages; ++j)
                ifile >> control[i][j];
        }
    }
    catch (...) {
        m_errorString.append ("Error in BocopSolution::readVariablesAndConstraints()\n");
        m_errorString.append ("Cannot read the discretized control variables arrays...\n");
        return 5;
    }

    // Next we should read the algebraic variables :
    try {
        for (i=0; i<dim_algebraic; ++i) {
            skipComments(ifile);

            for (j=0; j<dim_stepsAfterMerge*dim_stages; ++j)
                ifile >> algebraic[i][j];
        }
    }
    catch (...) {
        m_errorString.append ("Error in BocopSolution::readVariablesAndConstraints()\n");
        m_errorString.append ("Cannot read the discretized algebraic variables arrays...\n");
        return 6;
    }

    // Next we should read the optimization parameters :
    try {
        for (i=0; i<dim_optimvars; ++i) {
            skipComments(ifile);
            ifile >> optimvars[i];
        }
    }
    catch (...) {
        m_errorString.append ("Error in BocopSolution::readVariablesAndConstraints()\n");
        m_errorString.append ("Cannot read the optimization parameters array...\n");
        return 6;
    }

    // Next we should read the boundary conditions :
    try {
        for (i=0; i<dim_ifcond; ++i) {
            skipComments(ifile);

            for (j=0; j<4; ++j)
                ifile >> ifcond[i][j];
        }
    }
    catch (...) {
        m_errorString.append ("Error in BocopSolution::readVariablesAndConstraints()\n");
        m_errorString.append ("Cannot read the initial and final conditions arrays...\n");
        return 7;
    }

    // Next we should read the path constraints :
    try {
        for (i=0; i<dim_pathcond; ++i) {
            skipComments(ifile);

            // First the bounds on the path constraint :
            for (j=0; j<3; ++j)
                ifile >> bound_pathcond[i][j];

            // Then the value of the constraint :
            for (j=0; j<dim_stepsAfterMerge*dim_stages; ++j)
                ifile >> pathcond[i][j];
        }
    }
    catch (...) {
        m_errorString.append ("Error in BocopSolution::readVariablesAndConstraints()\n");
        m_errorString.append ("Cannot read the discretized path constraints arrays...\n");
        return 8;
    }

    // Next we should read the dynamic constraints :
    try {
        for (i=0; i<dim_state; ++i) {
            skipComments(ifile);

            // First the bounds on the dynamic constraint :
            for (j=0; j<3; ++j)
                ifile >> trash; // 0.0 0.0 4

            // Then the value of the constraint :
            for (j=0; j<dim_stepsAfterMerge; ++j)
                ifile >> dyncond[i][j];
        }
    }
    catch (...) {
        m_errorString.append ("Error in BocopSolution::readVariablesAndConstraints()\n");
        m_errorString.append ("Cannot read the discretized dynamic constraints arrays...\n");
        return 9;
    }

    // Next we skip the dimension of constraint multipliers
    try {
        skipComments(ifile);
        ifile >> trash;
    }
    catch (...) {
        m_errorString.append ("Error in BocopSolution::readVariablesAndConstraints()\n");
        m_errorString.append ("Cannot read the dimension of multipliers...\n");
        return 10;
    }

    // Next we read the boundary condition multipliers :
    try {
        skipComments(ifile);
        for (i=0; i<dim_ifcond; ++i) {
            ifile >> ifcondMultipliers[i];
        }
    }
    catch (...) {
        m_errorString.append ("Error in BocopSolution::readVariablesAndConstraints()\n");
        m_errorString.append ("Cannot read the boundary conditions multipliers arrays...\n");
        return 11;
    }

    // Next we should read the path constraints :
    try {
        for (i=0; i<dim_pathcond; ++i) {
            skipComments(ifile);

            for (j=0; j<dim_stepsAfterMerge*dim_stages; ++j)
                ifile >> pathcondMultipliers[i][j];
        }
    }
    catch (...) {
        m_errorString.append ("Error in BocopSolution::readVariablesAndConstraints()\n");
        m_errorString.append ("Cannot read the discretized path constraints multipliers arrays...\n");
        return 12;
    }

    // Next we should read the adjoint states :
    try {
        for (i=0; i<dim_state; ++i) {
            skipComments(ifile);

            for (j=0; j<dim_stepsAfterMerge; ++j)
                ifile >> dyncondMultipliers[i][j];
        }
    }
    catch (...) {
        m_errorString.append ("Error in BocopSolution::readVariablesAndConstraints()\n");
        m_errorString.append ("Cannot read the discretized adjoint states arrays...\n");
        return 13;
    }

    // Next we should read the coefficients b_i :

    // First we skip the coefficients a_i
    try {
        skipComments(ifile);

        for (i=0; i<dim_stages*dim_stages; ++i) {
            ifile >> trash;
        }
    }
    catch (...) {
        m_errorString.append ("Error in BocopSolution::readVariablesAndConstraints()\n");
        m_errorString.append ("Cannot read the coefficients a_i...\n");
        return 14;
    }

    // Then we read the coefficients b_i
    try {
        skipComments(ifile);

        for (i=0; i<dim_stages; ++i) {
            ifile >> coeff_b_i[i];
        }
    }
    catch (...) {
        m_errorString.append ("Error in BocopSolution::readVariablesAndConstraints()\n");
        m_errorString.append ("Cannot read the coefficients a_i...\n");
        return 15;
    }

    ifile.close();
    return 0;
}


/**
  * \fn string BocopSolution::calculateAverageControl(void)
  * This method calculates the average control using the weights b_i
  */
int BocopSolution::calculateAverageControl(void)
{

    for (int i = 0; i< dim_control; i++){
        for (int j = 0; j<dim_stepsAfterMerge; j++){
            averageControl[i][j] = 0;
            for (int k = 0; k< dim_stages; k++)
                averageControl[i][j] += control[i][j*dim_stages + k]*coeff_b_i[k];
        }
    }
    return 0;
}


/**
  * \fn void BocopSolution::skipComments(ifstream& file)
  * This method skips the comments while reading a file
  */
void BocopSolution::skipComments(ifstream& file)
{
    string line = ""; // trash variable for the line
    string comment = "#"; // Sign declaring a comment line
    size_t found;


    streampos pos_fin;
    pos_fin = file.tellg();

    file >> line;

    // We now seek if the line contains the comment character
    // "find" returns the position of the occurrence in the string of the searched content.
    // If the content is not found, the member value "npos" is returned.
    found = line.find(comment);

    while (found!=string::npos)
    {
        // if the first line is a comment
        getline(file, line); // we read the whole line
        //        cout << " Skip comments --> " << line << endl;
        pos_fin = file.tellg();

        file >> line;
        found = line.find(comment);

    }
    file.seekg (pos_fin, ios::beg);
}


/**
  * \fn string BocopSolution::nameVar(int i, int j) const
  * This method returns the name of a variable indexed by i and j.
  * i is the main category, the type of variable (state, control...) and
  * j is the index of the variable inside its category. The value is taken
  * from the main names array
  */
string BocopSolution::nameVar(int i, int j) const{
    string val = "name_not_found";

    if (i<0 || j<0)
        return val;

    int ind;

    switch (i) {
    case 0 : // state
        ind = j;
        if (ind < (int)names.size())
            val = names[ind];
        break;
    case 1 : // control
        ind = dim_state+j;
        if (ind < (int)names.size())
            val = names[ind];
        break;
    case 2 : // algebraic
        ind = dim_state+dim_control+j;
        if (ind < (int)names.size())
            val = names[ind];
        break;
    case 3 : // optimvars
        ind = dim_state+dim_control+dim_algebraic+j;
        if (ind < (int)names.size())
            val = names[ind];
        break;
    case 4 : // ifcond
        ind = dim_state+dim_control+dim_algebraic+dim_optimvars+j;
        if (ind < (int)names.size())
            val = names[ind];
        break;
    case 5 : // pathcond
        ind = dim_state+dim_control+dim_algebraic+dim_optimvars+dim_ifcond+j;
        if (ind < (int)names.size())
            val = names[ind];
        break;
    case 6 : // dyncond
        ind = dim_state+dim_control+dim_algebraic+dim_optimvars+dim_ifcond+dim_pathcond+j;
        if (ind < (int)names.size())
            val = names[ind];
        break;
    case 7 : // ifcondmult
        ind = dim_state+dim_control+dim_algebraic+dim_optimvars+dim_ifcond+dim_pathcond+dim_state+j;
        if (ind < (int)names.size())
            val = names[ind];
        break;
    case 8 : // pathcondmult
        ind = dim_state+dim_control+dim_algebraic+dim_optimvars+dim_ifcond+dim_pathcond+dim_state+dim_ifcond+j;
        if (ind < (int)names.size())
            val = names[ind];
        break;
    case 9 : // dyncondmult
        ind = dim_state+dim_control+dim_algebraic+dim_optimvars+dim_ifcond+dim_pathcond+dim_state+dim_ifcond+dim_pathcond+j;
        if (ind < (int)names.size())
            val = names[ind];
        break;
        //    case 7 : // constants
        //        ind = dim_state+dim_control+dim_algebraic+dim_optimvars+dim_ifcond+dim_pathcond+dim_state+j;
        //        if (ind < (int)names.size())
        //            val = names[ind];
        //        break;
    default :
        break;
    }

    return val;

}
