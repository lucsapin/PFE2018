// This code is published under the Eclipse Public License
// File: bocop_save_solution.cpp
// Authors: Vincent Grelard, Daphne Giorgi, Pierre Martinon, Jinyan Liu, Virgile Andreani
// Inria Saclay and CMAP Ecole Polytechnique
// 2011-2017

#include "bocop_save_definition.hpp"

BocopSaveDefinition::BocopSaveDefinition()
{
    problem_path = "";

    name_def.reserve(100);
    type_def.reserve(100);
    value_def.reserve(100);
    delete_def.reserve(100);

    dim_state = -1;
    dim_control = -1;
    dim_algebraic = -1;
    dim_optimvars = -1;
    dim_constants = -1;
    dim_ifcond = -1;
    dim_pathcond = -1;
    dim_steps = -1;
    dim_stages = -1;
}


BocopSaveDefinition::BocopSaveDefinition(string path)
{
    problem_path = path;

    name_def.reserve(100);
    type_def.reserve(100);
    value_def.reserve(100);
    delete_def.reserve(100);

    dim_state = -1;
    dim_control = -1;
    dim_algebraic = -1;
    dim_optimvars = -1;
    dim_constants = -1;
    dim_ifcond = -1;
    dim_pathcond = -1;
    dim_steps = -1;
    dim_stages = -1;
}


BocopSaveDefinition::~BocopSaveDefinition()
{}


/**
  *\fn int BocopSaveDefinition::addDefinitionEntry(string name, string type, string value)
  * This method allows to add an entry with the standard format that is used to write
  * bocop definition files. "name" should be a keyword known by bocop core. If it is, the
  * associated "value" will be used when running bocop.
  */
int BocopSaveDefinition::addDefinitionEntry(string name, string type, string value)
{
    name_def.push_back(name);
    type_def.push_back(type);
    value_def.push_back(value);

    return 0;
}


/**
  *\fn int BocopSaveDefinition::removeDefinitionEntry(string name)
  * This method allows to remove an entry written in the standard format that is used for
  * bocop definition files. "name" should be a keyword known by bocop core. If this keyword
  * is found in the definition file, the whole line will later be removed.
  */
int BocopSaveDefinition::removeDefinitionEntry(string name)
{
    delete_def.push_back(name);
    return 0;
}


/**
  *\fn void BocopSaveDefinition::showAddedEntries(void) const
  * For debug. Shows all the lines that are currently stored for a coming
  * save in the definition file.
  */
void BocopSaveDefinition::showAddedEntries(void) const
{
    for (int i=0; i<(int)name_def.size(); ++i) {
        cout << name_def.at(i) << "  " << type_def.at(i) << "  " << value_def.at(i) << endl;
    }
}


/**
  *\fn int BocopSaveDefinition::saveConstant(const int i, const double val)
  * This method allows to set the value for one constant in the constant vector.
  * If the index is invalid,
  */
int BocopSaveDefinition::setConstant(const int i, const double val)
{
    if (constants.size() == 0) {
        if (dim_constants < 0) {
            m_errorString.append("BocopSaveDefinition::saveConstant : error");
            m_errorString.append("Dimension of the constants is not defined...");
            return 1;
        }
        else
            constants.resize(dim_constants);

    }

    if (i >= (int)constants.size()) {
        m_errorString.append("BocopSaveDefinition::saveConstant : error");
        m_errorString.append("Index is out of the array size...");
        return 2;
    }

    constants.at(i) = val;
    return 0;
}


/**
  *\fn int BocopSaveDefinition::setBound(const int index, const double lower, const double upper, const string type)
  * Define bounds properties on a variable
  */
int BocopSaveDefinition::setBound(const int index, const double lower, const double upper, const string type)
{
    // There is a bound on each variable and constraint, therefore we need to know the dimensions :
    if (dim_state<0  || dim_control<0 || dim_algebraic<0 || dim_optimvars<0 || dim_ifcond<0 || dim_pathcond<0) {
        m_errorString.append("BocopSaveDefinition::setBound : error");
        m_errorString.append("One or more of the needed dimensions is not defined...");
        return 1;
    }

    // The total dimension of the bounds vectors is :
    int dim_all_bounds = dim_state+dim_control+dim_algebraic+dim_optimvars+dim_ifcond+dim_pathcond;

    // If the bounds vector are empty, we allocate memory :
    if (lower_bound.size() == 0)
        lower_bound.resize(dim_all_bounds);

    if (upper_bound.size() == 0)
        upper_bound.resize(dim_all_bounds);

    if (type_bound.size() == 0)
        type_bound.resize(dim_all_bounds);

    // We check that the index is inside the range :
    if (index >= (int)lower_bound.size() || index >= (int)upper_bound.size() || index >= (int)type_bound.size()) {
        m_errorString.append("BocopSaveDefinition::setBound : error\n");
        m_errorString.append("Index is out of the array size...\n");
        return 2;
    }

    // We check that the bounds are valid :
    if (lower_bound > upper_bound) {
        m_errorString.append("BocopSaveDefinition::setBound : error\n");
        m_errorString.append("Lower bound is greater than upper bound...\n");
        return 3;
    }

    // Finally we assign the values :
    if (type == "free")
    {
        lower_bound.at(index) = 0.0;
        upper_bound.at(index) = 0.0;
        type_bound.at(index) = type;
    }
    else if (type == "lower")
    {
        lower_bound.at(index) = lower;
        upper_bound.at(index) = MY_INF;
        type_bound.at(index) = type;
    }
    else if (type == "upper")
    {
        lower_bound.at(index) = -MY_INF;
        upper_bound.at(index) = upper;
        type_bound.at(index) = type;
    }
    else if (type == "both")
    {
        lower_bound.at(index) = lower;
        upper_bound.at(index) = upper;
        type_bound.at(index) = type;
    }
    else if (type == "equal")
    {
        lower_bound.at(index) = lower;
        upper_bound.at(index) = lower;
        type_bound.at(index) = type;
    }
    else
    {
        m_errorString.append("BocopSaveDefinition::setBound : error\n");
        m_errorString.append("Type of bound should be an integer between 0 and 4...\n");
        return 4;
    }

    return 0;
}


/**
  *\fn int BocopSaveDefinition::writeFiles(void)
  * This method writes all Bocop definition files (.def, .bounds, .constants)
  * with the values saved in the current instance. It calls one dedicated method
  * for each file.
  */
int BocopSaveDefinition::writeFiles(void)
{
    int status;
    status = writeDefinition();
    if (status != 0)
        return status;

    status = writeBounds();
    if (status != 0)
        return status;


    status = writeConstants();
    if (status != 0)
        return status;

    return 0;
}


/**
  *\fn int BocopSaveDefinition::writeDefinition(void)
  * This method writes the definition file with the new entries saved in
  * the triplets array <name_def,type_def,value_def>. It also erases any
  * entry found in delete_def from this file.
  * \warning Does not work if the existing bounds file is empty... Default file
  * has to contain 7 lines of data (dimensions + 1 line for each type of var)
  */
int BocopSaveDefinition::writeDefinition(void)
{
    if (name_def.size() != type_def.size() || name_def.size() != value_def.size()) {
        m_errorString.append("BocopSaveDefinition::writeDefinition : error\n");
        m_errorString.append("Sizes of the vectors (name, type, value) to write in definition file do not match...\n");
        return 1;
    }

    int timeNbValues = 3, dimensionNbValues = 7, discretizationNbValues = 2 , optimizationNbValues = 7, initializationNbValues = 2, paramIdNbValues = 4, problemSolNbValues = 2;


    // First we check if the dimensions are right
    int dimTotal = dimState()+dimControl()+dimAlgebraic()+dimOptimvars()+dimInitFinalCond()+dimPathConstraints()+dimConstants();
    int dimCheck = timeNbValues+dimensionNbValues+discretizationNbValues+optimizationNbValues+initializationNbValues+paramIdNbValues+dimTotal+problemSolNbValues;
    if (dimCheck != int(name_def.size()))
    {
        cout << "dimCheck: " << dimCheck << "is not equal to name_def: " << name_def.size() << endl;
        for (int i=0; i<(int)name_def.size();i++){
            cout << " name def " << name_def[i] << endl;
        }
        m_errorString.append("BocopSaveDefinition::writeDefinition : error\n");
        m_errorString.append("Size of the vectors (name, type, value) doesn't match with the problem dimensions\n");
        m_errorString.append("Here the list of expected entries to write in definition file\n");
        // We display the names of the entries to write in the definition file
        for (int i=0; i<(int)name_def.size(); i++)
            m_errorString.append(name_def[i]+"; ");
        m_errorString.append("\n The total dimension should be ");
        stringstream ss;
        ss << dimCheck;
        m_errorString.append(ss.str());
        return 2;
    }

    // Before we write the new problem.def file, we save a copy of the old one
    string definition_filename = problem_path + "problem.def";
    string definition_filebackup = problem_path + "problem.def.backup";
    QFile fileDef(definition_filename.c_str());
    if (!fileDef.exists())
    {
        m_errorString.append("BocopSaveDefinition::writeDefinition : warning");
        m_errorString.append("Unable to save a backup file of problem.def because problem.def file doesn't exist");
        return 3;
    }

    QFile::remove(definition_filebackup.c_str());
    QFile::rename(definition_filename.c_str(), definition_filebackup.c_str());
    ofstream file_def_out(definition_filename.c_str(), ios::out | ios::binary);
    string new_line;

    int i=0;
    int j;

    file_def_out << "# This file defines all dimensions and parameters" << endl;
    file_def_out << "# values for your problem :" << endl << endl;

    // First we write the informations about time
    file_def_out << "# Initial and final time :" << endl;
    for (j=0; j<3; j++)
    {
        new_line = name_def.at(i) + " " + type_def.at(i) + " " + value_def.at(i);
        file_def_out << new_line << endl;
        i++;
    }

    // Then we write the dimensions
    file_def_out << endl << "# Dimensions :" << endl;
    for (j=0; j<7; j++)
    {
        new_line = name_def.at(i) + " " + type_def.at(i) + " " + value_def.at(i);
        file_def_out << new_line << endl;
        i++;
    }

    // Then we write the discretization informations
    file_def_out << endl << "# Discretization :" << endl;
    for (j=0; j<2; j++)
    {
        new_line = name_def.at(i) + " " + type_def.at(i) + " " + value_def.at(i);
        file_def_out << new_line << endl;
        i++;
    }

    // Then we write the optimization informations
    file_def_out << endl << "# Optimization :" << endl;
    for (j=0; j<7; j++)
    {
        new_line = name_def.at(i) + " " + type_def.at(i) + " " + value_def.at(i);
        file_def_out << new_line << endl;
        i++;
    }

    // Then we write the initialization informations
    file_def_out << endl << "# Initialization :" << endl;
    for (j=0; j<2; j++)
    {
        new_line = name_def.at(i) + " " + type_def.at(i) + " " + value_def.at(i);
        file_def_out << new_line << endl;
        i++;
    }

// Then we write the parameter identification informations
    file_def_out << endl << "# Parameter identification :" << endl;
    for (j=0; j<4; j++)
    {
        new_line = name_def.at(i) + " " + type_def.at(i) + " " + value_def.at(i);
        file_def_out << new_line << endl;
        i++;
    }

    // Then we write the names
    file_def_out << endl << "# Names :" << endl;
    for (j=0; j<dimTotal; j++)
    {
        new_line = name_def.at(i) + " " + type_def.at(i) + " " + value_def.at(i);
        file_def_out << new_line << endl;
        i++;
    }

    // We write the solution file name
    file_def_out << endl << "# Solution file :" << endl;

    new_line = name_def.at(i) + " " + type_def.at(i) + " " + value_def.at(i);
    file_def_out << new_line << endl;
    i++;

    // We write the iteration output frequency
    file_def_out << endl << "# Iteration output frequency :" << endl;

    new_line = name_def.at(i) + " " + type_def.at(i) + " " + value_def.at(i);
    file_def_out << new_line << endl;

    file_def_out  << endl;
    file_def_out.close();

    return 0;
}


/**
  *\fn int BocopSaveDefinition::writeBounds(void)
  * This method writes the bounds saved in triplet arrays
  * <lower_bound,upper_bound,type_bound> into .bounds file.
  */
int BocopSaveDefinition::writeBounds(void)
{
    int i;

    if (lower_bound.size() <= 0 || upper_bound.size() <= 0 || type_bound.size() <= 0) {
        m_errorString.append("BocopSaveDefinition::writeBounds : error");
        m_errorString.append("Bounds array should not be empty...");
        return 1;
    }
    if (lower_bound.size() != upper_bound.size() || lower_bound.size() != type_bound.size()) {
        m_errorString.append("BocopSaveDefinition::writeBounds : error");
        m_errorString.append("Size of the bounds arrays do not match...");
        return 2;
    }

    // First we read the existing file (if any) :
    string bounds_filename = problem_path + "problem.bounds";
    QFile file_bounds(bounds_filename.c_str());

    if (!file_bounds.open(QIODevice::ReadOnly))
    {
        m_errorString.append("BocopSaveDefinition::writeBounds : error");
        m_errorString.append("Cannot open bounds file...");
        return 3;
    }

    // We read the whole file :
    QString line;
    QTextStream in(&file_bounds);
    vector<string> all_in_bounds;
    while (!in.atEnd()) {
        line = in.readLine();
        all_in_bounds.push_back(line.toStdString());

    }
    file_bounds.close();


    // We get the indices of the data (not-commented) lines :
    vector<int> ind_data;

    // We get the indices of the commented lines:
    vector<int> ind_commented;

    for (i=0; i<(int)all_in_bounds.size(); ++i) {
        if (all_in_bounds.at(i).find("#") == string::npos && all_in_bounds.at(i) != "")
            ind_data.push_back(i);
    }

    // We get the dimensions of the old file :
    int old_dim_state = -1;
    int old_dim_control = -1;
    int old_dim_algebraic = -1;
    int old_dim_optimvars = -1;
    int old_dim_ifcond = -1;
    int old_dim_pathcond = -1;
    string dim_str = all_in_bounds.at(ind_data.at(0));
    stringstream dim_stream;
    dim_stream << dim_str;

    //    sscanf(dim_str, &old_dim_ifcond, &old_dim_state, &old_dim_control, &old_dim_algebraic, &old_dim_optimvars, &old_dim_pathcond);
    dim_stream >> old_dim_ifcond >> old_dim_state >> old_dim_control
               >> old_dim_algebraic >> old_dim_optimvars >> old_dim_pathcond;

    // We check that the process went well :
    if (old_dim_state<0 || old_dim_control<0 || old_dim_algebraic<0 ||
            old_dim_algebraic<0 || old_dim_ifcond<0 || old_dim_pathcond<0) {
        m_errorString.append("BocopSaveDefinition::writeBounds : error");
        m_errorString.append("Cannot read dimensions from the existing bounds file (first non commented line)...");
        return 4;
    }

    // On the first non-commented line, we write the dimensions :
    stringstream sstr;
    sstr << dim_ifcond << " " << dim_state << " " << dim_control << " " << dim_algebraic << " " << dim_optimvars << " " << dim_pathcond;
    all_in_bounds.at(ind_data.at(0)) = sstr.str();

    // Now we can write the bounds :
    ind_commented.clear();
    for (i=0; i<(int)all_in_bounds.size(); ++i) {
        if (all_in_bounds.at(i).find("#") != string::npos )
            ind_commented.push_back(i);
    }

    // ** Initial and final conditions **
    // if the dimension in the existing file is greater than
    // the new one, we have to remove data rows :
    for (i=old_dim_ifcond; i>dim_ifcond; --i)
        all_in_bounds.erase(all_in_bounds.begin()+ind_data.at(i));

    // We replace the existing bounds in the file :
    int begin_vec = dim_state+dim_control+dim_algebraic+dim_optimvars; // index where the ifcond begins in the bounds arrays
    for (i=0;(i<old_dim_ifcond && i<dim_ifcond); ++i) {
        stringstream stream;
        stream.precision(15);
        stream << lower_bound.at(begin_vec+i) << " " << upper_bound.at(begin_vec+i) << " "<< type_bound.at(begin_vec+i);
        all_in_bounds.at(ind_data.at(i+1)) = stream.str();
    }

    // if the dimension of the ifcond in the existing file is lower than
    // the new one, we have to add rows :
    // we insert the new line(s) at the end of the ifconds :
//    vector<string>::iterator it = all_in_bounds.begin()+ind_data.at(old_dim_ifcond);
    vector<string>::iterator it;
    // if no ifcond before, we write after the forth '#'
    if (old_dim_ifcond <=0)
        it = all_in_bounds.begin()+ind_commented.at(4);
    // otherwise we write after the data existed
    else
        it = all_in_bounds.begin()+ind_data.at(old_dim_ifcond);

    for (i=old_dim_ifcond; i<dim_ifcond; ++i) {
        stringstream stream;
        stream.precision(15);
        stream << lower_bound.at(begin_vec+i) << " " << upper_bound.at(begin_vec+i) << " "<< type_bound.at(begin_vec+i);
        it = all_in_bounds.insert(it+1, stream.str());
    }


    // ** State **//
    // The commented lines may have move because of the insert/erase, so we need to
    // get the indices of the data (not-commented) lines again :
    ind_data.clear();
//    for (i=0; i<(int)all_in_bounds.size(); ++i) {
//        if (all_in_bounds.at(i).find("#") == string::npos && all_in_bounds.at(i) != "")
//            ind_data.push_back(i);

//    }
    ind_commented.clear();
    for (i=0; i<(int)all_in_bounds.size(); ++i) {
        if (all_in_bounds.at(i).find("#") != string::npos )
            ind_commented.push_back(i);
        else if (all_in_bounds.at(i).find("#") == string::npos && all_in_bounds.at(i) != "")
            ind_data.push_back(i);
    }

    // if the dimension in the existing file is greater than
    // the new one, we have to remove data rows :
    int begin_text = dim_ifcond; // position of the first state bounds on the file text
    for (i=old_dim_state; i>dim_state; --i)
        all_in_bounds.erase(all_in_bounds.begin()+ind_data.at(begin_text+i));

    // We replace the existing bounds in the file :
    for (i=0;(i<old_dim_state && i<dim_state); ++i) {
        stringstream stream;
        stream.precision(15);
        // *** bounds block
//        stream << ">" << i << ":1:" << i << " " << lower_bound.at(i) << " " << upper_bound.at(i) << " "<< type_bound.at(i);
        stream << lower_bound.at(i) << " " << upper_bound.at(i) << " "<< type_bound.at(i);
        all_in_bounds.at(ind_data.at(i+begin_text+1)) = stream.str();
    }

    // if the dimension of the state in the existing file is lower than
    // the new one, we have to add rows :
    // we insert the new line(s) at the end of the states :
//    it = all_in_bounds.begin()+ind_data.at(begin_text+old_dim_state);

    // if no state before, we write after the fifth '#'
    if (old_dim_state <=0)
        it = all_in_bounds.begin()+ind_commented.at(5);
    // otherwise we write after the data existed
    else
        it = all_in_bounds.begin()+ind_data.at(begin_text+old_dim_state);

    for (i=old_dim_state; i<dim_state; ++i) {
        stringstream stream;
        stream.precision(15);
        // *** bounds block
//        stream << ">" << i << ":1:" << i << " " << lower_bound.at(i) << " " << upper_bound.at(i) << " "<< type_bound.at(i);
        stream << lower_bound.at(i) << " " << upper_bound.at(i) << " "<< type_bound.at(i);
        it = all_in_bounds.insert(it+1, stream.str());
    }


    // ** Control **//
    // The commented lines may have move because of the insert/erase, so we need to
    // get the indices of the data (not-commented) lines again :
    ind_data.clear();
//    for (i=0; i<(int)all_in_bounds.size(); ++i) {
//        if (all_in_bounds.at(i).find("#") == string::npos && all_in_bounds.at(i) != "")
//            ind_data.push_back(i);
//    }
    ind_commented.clear();
    for (i=0; i<(int)all_in_bounds.size(); ++i) {
        if (all_in_bounds.at(i).find("#") != string::npos )
            ind_commented.push_back(i);
        else if (all_in_bounds.at(i).find("#") == string::npos && all_in_bounds.at(i) != "")
            ind_data.push_back(i);
    }

    // if the dimension in the existing file is greater than
    // the new one, we have to remove data rows :
    begin_text = dim_ifcond+dim_state; // position of the first control bounds on the file text
    for (i=old_dim_control; i>dim_control; --i)
        all_in_bounds.erase(all_in_bounds.begin()+ind_data.at(begin_text+i));

    // We replace the existing bounds in the file :
    begin_vec = dim_state; // control bounds begin right after the state bounds
    for (i=0;(i<old_dim_control && i<dim_control); ++i) {
        stringstream stream;
        stream.precision(15);
        stream << lower_bound.at(begin_vec+i) << " " << upper_bound.at(begin_vec+i) << " "<< type_bound.at(begin_vec+i);
        all_in_bounds.at(ind_data.at(i+begin_text+1)) = stream.str();
    }

    // if the dimension of the control in the existing file is lower than
    // the new one, we have to add rows :
    // we insert the new line(s) at the end of the control :
//    it = all_in_bounds.begin()+ind_data.at(begin_text+old_dim_control);

    // if no control before, we write after the sixth '#'
    if (old_dim_control <= 0)
        it = all_in_bounds.begin()+ind_commented.at(6);
    // otherwise we write after the data existed
    else
        it = all_in_bounds.begin()+ind_data.at(begin_text+old_dim_control);

    for (i=old_dim_control; i<dim_control; ++i) {
        stringstream stream;
        stream.precision(15);
        stream << lower_bound.at(begin_vec+i) << " " << upper_bound.at(begin_vec+i) << " "<< type_bound.at(begin_vec+i);
        it = all_in_bounds.insert(it+1, stream.str());
    }


    // ** Algebraic **//
    // The commented lines may have move because of the insert/erase, so we need to
    // get the indices of the data (not-commented) lines again :
    ind_data.clear();
//    for (i=0; i<(int)all_in_bounds.size(); ++i) {
//        if (all_in_bounds.at(i).find("#") == string::npos && all_in_bounds.at(i) != "")
//            ind_data.push_back(i);
//    }
    ind_commented.clear();
    for (i=0; i<(int)all_in_bounds.size(); ++i) {
        if (all_in_bounds.at(i).find("#") != string::npos )
            ind_commented.push_back(i);
        else if (all_in_bounds.at(i).find("#") == string::npos && all_in_bounds.at(i) != "")
            ind_data.push_back(i);
    }

    // if the dimension in the existing file is greater than
    // the new one, we have to remove data rows :
    begin_text = dim_ifcond+dim_state+dim_control; // position of the first algebraic bounds on the file text
    for (i=old_dim_algebraic; i>dim_algebraic; --i)
        all_in_bounds.erase(all_in_bounds.begin()+ind_data.at(begin_text+i));

    // We replace the existing bounds in the file :
    begin_vec = dim_state + dim_control; // position of the first algebraic bounds on the bounds vector
    for (i=0;(i<old_dim_algebraic && i<dim_algebraic); ++i) {
        stringstream stream;
        stream.precision(15);
        stream << lower_bound.at(begin_vec+i) << " " << upper_bound.at(begin_vec+i) << " "<< type_bound.at(begin_vec+i);
        all_in_bounds.at(ind_data.at(i+begin_text+1)) = stream.str();
    }

    // if the dimension of the algebraic in the existing file is lower than
    // the new one, we have to add rows :
    // we insert the new line(s) at the end of the algebraic :
//    it = all_in_bounds.begin()+ind_data.at(begin_text+old_dim_algebraic);
    // if no algebraic before, we write after the seventh '#'
    if (old_dim_algebraic <= 0)
        it = all_in_bounds.begin()+ind_commented.at(7);
    // otherwise we write after the data existed
    else
        it = all_in_bounds.begin()+ind_data.at(begin_text+old_dim_algebraic);

    for (i=old_dim_algebraic; i<dim_algebraic; ++i) {
        stringstream stream;
        stream.precision(15);
        stream << lower_bound.at(begin_vec+i) << " " << upper_bound.at(begin_vec+i) << " "<< type_bound.at(begin_vec+i);
        it = all_in_bounds.insert(it+1, stream.str());
    }


    // ** optimization parameters **
    // The commented lines may have move because of the insert/erase, so we need to
    // get the indices of the data (not-commented) lines again :
    ind_data.clear();
//    for (i=0; i<(int)all_in_bounds.size(); ++i) {
//        if (all_in_bounds.at(i).find("#") == string::npos && all_in_bounds.at(i) != "")
//            ind_data.push_back(i);
//    }

    ind_commented.clear();
    for (i=0; i<(int)all_in_bounds.size(); ++i) {
        if (all_in_bounds.at(i).find("#") != string::npos )
            ind_commented.push_back(i);
        else if (all_in_bounds.at(i).find("#") == string::npos && all_in_bounds.at(i) != "")
            ind_data.push_back(i);
    }
    // if the dimension in the existing file is greater than
    // the new one, we have to remove data rows :
    begin_text = dim_ifcond+dim_state+dim_control+dim_algebraic; // position of the first optimvar bounds on the file text
    for (i=old_dim_optimvars; i>dim_optimvars; --i)
        all_in_bounds.erase(all_in_bounds.begin()+ind_data.at(begin_text+i));

    // We replace the existing bounds in the file :
    begin_vec = dim_state + dim_control + dim_algebraic; // position of the first optimvar bounds on the bounds vector
    for (i=0;(i<old_dim_optimvars && i<dim_optimvars); ++i) {
        stringstream stream;
        stream.precision(15);
        stream << lower_bound.at(begin_vec+i) << " " << upper_bound.at(begin_vec+i) << " "<< type_bound.at(begin_vec+i);
        all_in_bounds.at(ind_data.at(i+begin_text+1)) = stream.str();
    }

    // if the dimension of the optimvar in the existing file is lower than
    // the new one, we have to add rows :
    // we insert the new line(s) at the end of the optimvar bounds :
//    it = all_in_bounds.begin()+ind_data.at(begin_text+old_dim_optimvars);
    // if no algebraic before, we write after the eighth'#'
    if (old_dim_optimvars <= 0)
        it = all_in_bounds.begin()+ind_commented.at(8);
    // otherwise we write after the data existed
    else
        it = all_in_bounds.begin()+ind_data.at(begin_text+old_dim_optimvars);

    for (i=old_dim_optimvars; i<dim_optimvars; ++i) {
        stringstream stream;
        stream.precision(15);
        stream << lower_bound.at(begin_vec+i) << " " << upper_bound.at(begin_vec+i) << " "<< type_bound.at(begin_vec+i);
        it = all_in_bounds.insert(it+1, stream.str());
    }


    // ** Path constraints **//
    // The commented lines may have move because of the insert/erase, so we need to
    // get the indices of the data (not-commented) lines again :
    ind_data.clear();
    for (i=0; i<(int)all_in_bounds.size(); ++i) {
        if (all_in_bounds.at(i).find("#") == string::npos && all_in_bounds.at(i) != "")
            ind_data.push_back(i);
    }

    // if the dimension in the existing file is greater than
    // the new one, we have to remove data rows :
    begin_text = dim_ifcond+dim_state+dim_control+dim_algebraic+dim_optimvars; // position of the first pathcond bounds on the file text
    for (i=old_dim_pathcond; i>dim_pathcond; --i)
        all_in_bounds.erase(all_in_bounds.begin()+ind_data.at(begin_text+i));

    // We replace the existing bounds in the file :
    begin_vec = dim_state + dim_control + dim_algebraic + dim_optimvars + dim_ifcond; // position of the first pathcond bounds on the bounds vector
    for (i=0;(i<old_dim_pathcond && i<dim_pathcond); ++i) {
        stringstream stream;
        stream.precision(15);
        stream << lower_bound.at(begin_vec+i) << " " << upper_bound.at(begin_vec+i) << " "<< type_bound.at(begin_vec+i);
        all_in_bounds.at(ind_data.at(i+begin_text+1)) = stream.str();
    }

    // if the dimension of the pathcond in the existing file is lower than
    // the new one, we have to add rows :
    // we insert the new line(s) at the end of the pathcond :

    // if no algebraic before, we write after the ninth'#'
    if (old_dim_pathcond <= 0)
        it = all_in_bounds.begin()+ind_commented.at(9);
    // otherwise we write after the data existed
    else
        it = all_in_bounds.begin()+ind_data.at(begin_text+old_dim_pathcond);

    for (i=old_dim_pathcond; i<dim_pathcond; ++i) {
        stringstream stream;
        stream.precision(15);
        stream << lower_bound.at(begin_vec+i) << " " << upper_bound.at(begin_vec+i) << " "<< type_bound.at(begin_vec+i);
        it = all_in_bounds.insert(it+1, stream.str());
    }


    // If there are blank lines at the end of the file we don't write them
    int all_in_bounds_size = all_in_bounds.size();
    while (all_in_bounds.at(all_in_bounds_size-1) == "")
        all_in_bounds_size--;

    // Now we have to write the file :
    ofstream file_bounds_out(bounds_filename.c_str(), ios::out | ios::binary);
    for (int i=0; i<all_in_bounds_size; ++i)
        file_bounds_out << all_in_bounds.at(i) << endl;
    file_bounds_out.close();

    return 0;
}


/**
  *\fn int BocopSaveDefinition::writeConstants(void)
  * This method writes the constants file with the new values saved
  * in "constants" vector. It erases the existing file, and creates a
  * new one, with default comments.
  */
int BocopSaveDefinition::writeConstants(void)
{
    if (problem_path == "") {
        m_errorString.append("BocopSaveDefinition::writeConstants : error");
        m_errorString.append("Problem path is not defined...");
        return 1;
    }

    // We open current problem's constants file :
    string constants_filename = problem_path + "problem.constants";
    ofstream file_const(constants_filename.c_str(), ios::out | ios::binary);

    if (!file_const)
    {
        m_errorString.append("BocopSaveDefinition::writeConstants : error");
        m_errorString.append("Cannot open constants file...");
        return 2;
    }

    // We check that the constants have been defined :
    if (dim_constants >= 0 && (int)constants.size() != dim_constants)
    {
        m_errorString.append("BocopSaveDefinition::writeConstants : error");
        m_errorString.append("Constants vector is empty, please save your constants values before writing the file...");
        return 3;
    }

    if (dim_constants < 0)
    {
        m_errorString.append("BocopSaveDefinition::writeConstants : error");
        m_errorString.append("Constants dimension is not defined, please save your constants values before writing the file...");
        return 4;
    }

    // Now we can write the file with the new constants values :
    string comment1 = "# This file contains the values of the constants of your problem.";
    string comment2 = "# Number of constants used in your problem : ";
    string comment3 = "# Values of the constants : ";

    file_const << comment1 << endl;
    file_const << comment2 << endl;
    file_const << dim_constants << endl << endl;
    file_const << comment3 << endl;

    for (int i=0; i<dim_constants; ++i) {
        file_const.precision(15);
        file_const << constants.at(i) << endl;
    }

    return 0;
}


void BocopSaveDefinition::skipComments(ifstream& file)
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
