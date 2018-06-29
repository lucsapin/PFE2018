// This code is published under the Eclipse Public License
// File: readDefinition.cpp
// Authors: Vincent Grelard, Daphne Giorgi, Stephan Maindrault, Pierre Martinon, Olivier Tissot
// Inria Saclay and Cmap Ecole Polytechnique
// 2011-2016

#include <BocopDefinition.hpp>

//#ifdef PATH_DISC
//#define default_m_pathToDiscFiles PATH_DISC
//#else
//#define default_m_pathToDiscFiles "../core/disc/"
//#endif


/**
  *\fn int BocopDefinition::readAll (void)
  * This method calls all the methods to read the files
  * and fill the members of the Bocopdefinition's instance.
  */
int BocopDefinition::readAll(void)
{
    int status = 0;
    status = readDefinition();
    if (status != 0) {
        return 1;
    }

    status = readBoundaries();
    if (status != 0)
        return 2;

    status = readConstants();
    if (status != 0)
        return 3;

    //status = readMethod();
    status = setDiscMethod();
    if (status != 0)
        return 4;

    this->m_dimTimeObservation = NULL;
    if (isParamId()) {

        status = readObservations();
        if (status != 0)
            return 5;
    }

    // ca ne fait pas que lire, il y a l'insertion des mesures aussi...
    status = readTimes();
    if (status != 0)
        return 6;

    return 0;
}

// ***************************
// ******  DEFINITION  *******
// ***************************

/**
  *\fn int BocopDefinition::readDefFile (void)
  * This method reads the .def file.
  */
int BocopDefinition::readDefFile(void)
{
    ifstream file_def(this->m_defFileName.c_str(), ios::in | ios::binary);

    if (!file_def) { // if the opening failed
        m_errorString = "In readDefFile : cannot open specified definition file to read the parameters.";
        return 1;
    }

    // temp variables for reading the file:
    string name, type, value_str;
    string line = "";
    int value_int;
    double value_dbl;

    // We now read the data from the file :
    try {
        while (!file_def.eof()) {
            file_def >> name;
            if (name != "#" && name != "" && name != "# ") {
                file_def >> type;
                if (type == "string") {
                    file_def >> value_str;
                    this->m_stringValue.push_back(value_str);
                    this->m_stringName.push_back(name);
                } else if (type == "integer") {
                    file_def >> value_int;
                    this->m_integerValue.push_back(value_int);
                    this->m_integerName.push_back(name);
                } else if (type == "double") {
                    file_def >> value_dbl;
                    this->m_doubleValue.push_back(value_dbl);
                    this->m_doubleName.push_back(name);
                }
            } else
                getline(file_def, line);
        }

        file_def.close();
    } catch (...) {
        m_errorString = "In readDefFile : an error occurred while reading definition file.";
        return 3;
    }

    return 0;
}


/**
  *\fn template<class valueType> void BocopDefinition::missingDefinition (const string name_in_def, valueType* var, const valueType default_val, const string valueName)
  * This function is called when a definition value was not found in the
  * definition file. It allows to set a new default value for the parameter.
  * This function only works for string, double and int parameters.
  */
template<class valueType> void BocopDefinition::missingDefinition(const string name_in_def, valueType* var, const valueType default_val, const string valueName)
{
    if (valueName != "string" && valueName != "double" && valueName != "integer") {
        m_errorString.append(valueName + " is not a valid type, a missing definition has to be a string, a double or an integer.\n");
        return;
    }

    // First we display a warning message :
    m_isWarning = true;
    m_warningString.append(" Parameter \"" + name_in_def + "\" not found in your definition file.\n");
    m_warningString.append(" A default value will be given for this parameter.\n");

    // Then we set the default value to the associated variable :
    *var = default_val;

    // Finally we write the default value for the parameter in the definition file :
    ofstream file_def(this->m_defFileName.c_str(), ios::out | ios::binary | ios::app);
    if (!file_def) { // if the opening failed
        m_warningString.append(" Cannot open definition file to write the default value for parameter " + name_in_def + ".\n");
        m_warningString.append(" Default value will be used but not written.\n");
        return;
    }

    file_def << name_in_def << " " << valueName << " " << default_val << endl;
    file_def.close();
}


/**
  *\fn int BocopDefinition::readDefinition (void)
  * This function sets the parameters with the values found
  * in the definition file.
  */
int BocopDefinition::readDefinition(void)
{
    bool found = false;

    // First we read the file, and store its contents depending
    // on the type of value. There is a set of 2 vectors (name
    // and value) for each type (int, double, str).

    int status = readDefFile();
    if (status != 0)
        return 1;

    int returnValue = 0;

    // Initial and final time
    found = findInDef("time.free", &m_freeTime);
    if (found == false)
        missingDefinition<string> ("time.free", &m_freeTime, "none", "string");

    found = findInDef("time.initial", &m_t0);  // initial time
    if (found == false)
        missingDefinition<double> ("time.initial", &m_t0, 0, "double");

    found = findInDef("time.final", &m_tF);  // final time
    if (found == false)
        missingDefinition<double> ("time.final", &m_tF, 1, "double");

    // Dimensions
    found = findInDef("state.dimension", &m_dimState);  // number of state variables
    if (found == false)
        missingDefinition("state.dimension", &m_dimState, 1, "integer");

    found = findInDef("control.dimension", &m_dimControl);  // number of control variables
    if (found == false)
        missingDefinition("control.dimension", &m_dimControl, 0, "integer");

    found = findInDef("algebraic.dimension", &m_dimAlgebraic);  // number of algebro-differential variables
    if (found == false)
        missingDefinition("algebraic.dimension", &m_dimAlgebraic, 0, "integer");

    found = findInDef("parameter.dimension", &m_dimParameter);  // number of parameters
    if (found == false)
        missingDefinition("parameter.dimension", &m_dimParameter, 0, "integer");

    found = findInDef("constant.dimension", &m_dimConstant);  // number of constants
    if (found == false)
        missingDefinition("constant.dimension", &m_dimConstant, 0, "integer");

    found = findInDef("boundarycond.dimension", &m_dimBoundCond);  // number of boundary conditions
    if (found == false)
        missingDefinition("boundarycond.dimension", &m_dimBoundCond, 0, "integer");

    found = findInDef("constraint.dimension", &m_dimPathCond);    // number of path constraints
    if (found == false)
        missingDefinition("constraint.dimension", &m_dimPathCond, 0, "integer");

    // Discretization
    found = findInDef("discretization.steps", &m_dimStep);  // number of discretization steps
    if (found == false)
        missingDefinition("discretization.steps", &m_dimStep, 10, "integer");

    found = findInDef("discretization.method", &m_discMethod);  // name of the discretization method
    if (found == false)
        missingDefinition<string> ("discretization.method", &m_discMethod, "lobatto", "string");

    // Optimization
    found = findInDef("optimization.type", &m_optimType);
    if (found == false)
        missingDefinition<string> ("optimization.type", &m_optimType, "single", "string");

    status = readBatchOptions();
    if (status != 0)
        returnValue = status;

    // Initialization
    found = findInDef("initialization.type", &m_initMethod);
    if (found == false)
        missingDefinition<string> ("initialization.type", &m_initMethod, "from_init_file", "string");

    found = findInDef("initialization.file", &m_initFilename);
    if (found == false)
        missingDefinition<string> ("initialization.file", &m_initFilename, "none", "string");

    // Parameter identification
    found = findInDef("paramid.type", &m_paramIdType);
    if (found == false)
        missingDefinition<string> ("paramid.type", &m_paramIdType, "false", "string");

    status = readParamIdOptions();
    if (status != 0)
        return status;

    this->m_flagDefinitionDone = true;

    // Names
    status = readNames();
    if (status != 0)
        return status;

    // Solution file
    found = findInDef("solution.file", &m_solFilename);
    if (found == false)
        missingDefinition<string> ("solution.file", &m_solFilename, "problem.sol", "string");

    // Iteration output frequency
    found = findInDef("iteration.output.frequency", &m_iterationOutputFrequency);
    // default is no output at all
    if (found == false)
        m_iterationOutputFrequency = 0;

    return returnValue;
}


/**
  *\fn int BocopDefinition::readBatchOptions(void)
  * Method to set the options for batch optimization.
  */
int BocopDefinition::readBatchOptions(void)
{
    bool found = false;

    found = findInDef("batch.type", &m_batchType);
    if (found == false)
        missingDefinition("batch.type", &m_batchType, 0, "integer");

    found = findInDef("batch.index", &m_batchIndex);
    if (found == false)
        missingDefinition("batch.index", &m_batchIndex, 0, "integer");

    found = findInDef("batch.nrange", &m_batchRange);
    if (found == false)
        missingDefinition("batch.nrange", &m_batchRange, 1, "integer");

    found = findInDef("batch.lowerbound", &m_batchStarting);
    if (found == false)
        missingDefinition<double> ("batch.lowerbound", &m_batchStarting, 0, "double");

    found = findInDef("batch.upperbound", &m_batchEnding);
    if (found == false)
        missingDefinition<double> ("batch.upperbound", &m_batchEnding, 0, "double");

    found = findInDef("batch.directory", &m_batchFolder);
    if (found == false)
        missingDefinition<string> ("batch.directory", &m_batchFolder, "none", "string");

    return 0;
}


/**
  *\fn int BocopDefinition::readParamIdOptions(void)
  * Method to set the options for Parameter Identification.
  */
int BocopDefinition::readParamIdOptions(void)
{
    bool found = false;
    string obsSep;

    if (this->m_freeTime == "final" && isParamId()) {
        m_errorString.append("Impossible to solve a problem with parameters identification and final time free.\n");
        m_errorString.append("If you don't change these settings the optimization will fail.\n");
    }

    found = findInDef("paramid.separator", &obsSep);
    if (found == false)
        missingDefinition<string> ("paramid.separator", &obsSep, ",", "string");

    found = findInDef("paramid.file", &m_observationFileName);

    if (found == false)
        missingDefinition<string> ("paramid.file", &m_observationFileName, "none", "string");

    //We convert the string in obsep to a char in m_osbservationSeparator
    if (obsSep == ",")
        m_observationSeparator = ',';
    else if (obsSep == ";")
        m_observationSeparator = ';';
    else if (obsSep == ":")
        m_observationSeparator = ':';
    else if (obsSep == "Tab")
        m_observationSeparator = '\t';
    else if (obsSep == "Space")
        m_observationSeparator = ' ';
    else {
        m_errorString.append("Wrong separator: " + obsSep + "\n");
        m_errorString.append("Please choose between: , ; : Tab Space.\n");
        return 16;
    }

    found = findInDef("paramid.dimension", &m_sizeDataSet);
    if (found == false)
        missingDefinition("paramid.dimension", &m_sizeDataSet, 1, "integer");

    return 0;
}


// ***************************
// ******  BOUNDARIES  *******
// ***************************

/**
  *\fn int BocopDefinition::allocateBoundsArrays (void)
  * This function reads the boundary conditions file, and
  * the results are stored in the bounds arrays.
  */
int BocopDefinition::readBoundsFile(void)
{
    int offset;
    int ret;

    ifstream file_bounds(this->m_boundsFileName.c_str(), ios::in | ios::binary);

    if (!file_bounds) { // if the opening failed
        m_errorString.append("ERROR >>> BocopDefinition::readBoundsFile : Cannot open specified boundary conditions file to read the bounds. \n");
        return 1;
    }

    int test_m_dimBound, test_m_dimPathConstr, test_m_dimState, test_m_dimControl, test_m_dimAlgebraic, test_m_dimParameter;

    // start reading the file
    streampos current_pos;
    current_pos = file_bounds.tellg();
    skip_comments(file_bounds, current_pos);

    // recover dimensions for the bounds blocks
    file_bounds >> test_m_dimBound >> test_m_dimState >> test_m_dimControl >> test_m_dimAlgebraic >> test_m_dimParameter >> test_m_dimPathConstr;

    // check that these values match the problem variables
    if (test_m_dimBound != this->m_dimBoundCond || test_m_dimPathConstr != this->m_dimPathCond
            || test_m_dimState != this->m_dimState || test_m_dimControl != this->m_dimControl
            || test_m_dimAlgebraic != this->m_dimAlgebraic || test_m_dimParameter != this->m_dimParameter) {
        m_warningString.append(" BocopDefinition::readBoundsFile : WARNING. \n");
        m_warningString.append(" Dimensions do not match between bounds file and definition file. All variables bounds will be set to DEFAULT (free).\n");
        file_bounds.close();

        int status = generateDefaultBounds();
        if (status != 0)
            return 2;

        return 0;
    }

    // Read the bounds for initial and final conditions
    ret =  readBoundsBlock(file_bounds, "boundary conditions", test_m_dimBound, m_typeBoundary, m_lowerBoundary, m_upperBoundary);
    if (ret != 0) return ret;

    // Then for each variable block: state, control, algebraic, parameters
    offset = 0;
    ret =  readBoundsBlock(file_bounds, "state", test_m_dimState, &m_typeVariable[offset], &m_lowerVariable[offset], &m_upperVariable[offset]);
    if (ret != 0) return ret;

    offset += test_m_dimState;
    ret =  readBoundsBlock(file_bounds, "control", test_m_dimControl, &m_typeVariable[offset], &m_lowerVariable[offset], &m_upperVariable[offset]);
    if (ret != 0) return ret;

    offset += test_m_dimControl;
    ret =  readBoundsBlock(file_bounds, "algebraic", test_m_dimAlgebraic, &m_typeVariable[offset], &m_lowerVariable[offset], &m_upperVariable[offset]);
    if (ret != 0) return ret;

    offset += test_m_dimAlgebraic;
    ret =  readBoundsBlock(file_bounds, "parameter", test_m_dimParameter, &m_typeVariable[offset], &m_lowerVariable[offset], &m_upperVariable[offset]);
    if (ret != 0) return ret;

    // Finally, read the bounds on the path constraints
    ret =  readBoundsBlock(file_bounds, "path constraints", test_m_dimPathConstr, m_typePath, m_lowerPath, m_upperPath);
    if (ret != 0) return ret;

    file_bounds.close();

    return ret;
}


/**
  *\fn int BocopDefinition:::readBoundsBlock(ifstream& file_bounds, string block_name, int block_dim, string* block_type, double* block_lowerbound, double* block_upperbound)
  * Auxiliary function to read a block of bounds (free bounds will be reset to +/- 2e19 for ipopt solver).
  */
int BocopDefinition::readBoundsBlock(ifstream& file_bounds, string block_name, int block_dim, string* block_type, double* block_lowerbound, double* block_upperbound)
{
    int ret = 0;
    streampos current_pos;
    current_pos = file_bounds.tellg();
    skip_comments(file_bounds, current_pos);
    stringstream msg;
    //  cout << "read " << block_name << endl;

    // fill block with undefined to check later for duplicate / missing indices
    for (int i = 0; i < block_dim; i++)
        block_type[i] = "undefined";

    if (block_dim > 0) {
        // check whether .bounds files uses basic or block syntax
        if (file_bounds.peek() == std::char_traits<char>::to_int_type('>')) {
            ret = readBoundsSetBlock(file_bounds, block_name, block_dim, block_type, block_lowerbound, block_upperbound);
        } else {
            // basic syntax: 1 bounds definition per line
            for (int i = 0; i < block_dim; ++i) {
                file_bounds >> block_lowerbound[i] >> block_upperbound[i] >> block_type[i];

                ret = processBounds(block_type[i], &block_lowerbound[i], &block_upperbound[i]);
                if (ret == 4)
                    msg << "ERROR: Equal bounds expected for " << block_name << " index " << i << "\n";
                if (ret == 5)
                    msg << "ERROR: Bound type not recognised for " << block_name << " index " << i << "\n";
                if (ret == 9)
                    msg << "ERROR: Lower bound is greater than upper bound for " << block_name << " index " << i << "\n";
            }
        }

        // check for missing indices in the block
        if (ret == 0) {
            for (int i = 0; i < block_dim; i++)
                if (block_type[i] == "undefined") {
                    msg << "ERROR: missing bound type for " << block_name << " " << i << "\n";
                    ret = 6;
                }
        }

        m_errorString.append(msg.str());
    }

    return ret;

}


/**
  *\fn int BocopDefinition:::readBoundsSetBlock(ifstream& file_bounds, string block_name, int block_dim, string* block_type, double* block_lowerbound, double* block_upperbound)
  * Auxiliary function to read a block of bounds (free bounds will be reset to +/- 2e19 for ipopt solver).
  * This version uses the set syntax, "> i : j : k" denoting all indices from i to k (with step j) in the block
  * with the convention that index '-1' corresponds to the index for the end of the block.
  * Thus the syntax '> 0 : 1 : -1' designates the whole block.
  */
int BocopDefinition::readBoundsSetBlock(ifstream& file_bounds, string block_name, int block_dim, string* block_type, double* block_lowerbound, double* block_upperbound)
{

    int start_index, end_index, step_index, ret;
    char firstchar, separator;
    string type;
    stringstream msg;
    double lowerbound, upperbound;

    ret = 0;
    // read all lines in the block
    while (file_bounds.peek() == std::char_traits<char>::to_int_type('>')) {

        file_bounds >> firstchar >> start_index >> separator >> step_index >> separator >> end_index >> lowerbound >> upperbound >> type;
        // cout << " " << firstchar << " " << start_index << " " << separator << " " << step_index << " " << separator << " " << end_index << " " << lowerbound << " " << upperbound << " " << type << endl;

        //convention: end_index = -1 indicates end_index is at the end of the block
        if (end_index == -1)
            end_index = block_dim - 1;

        //various checks on indices
        if (step_index <= 0 || start_index < 0 || end_index > block_dim - 1 || start_index > end_index) {
            msg << "ERROR: Bound set indices are incorrect for " << block_name << " > " << start_index << " : " << step_index << " : " << end_index << "\n";
            msg << "Indices >i:j:k must satisfy 0 <= i <= k <= dim_var-1 and j >= 1" << "\n";
            m_errorString.append(msg.str());
            ret = 8;
            return ret;
        }

        ret = processBounds(type, &lowerbound, &upperbound);
        if (ret != 0) {
            if (ret == 4)
                msg << "ERROR: Equal bounds expected for " << block_name << " > " << start_index << " : " << step_index << " : " << end_index << "\n";
            if (ret == 5)
                msg << "ERROR: Bound type not recognised for " << block_name << " > " << start_index << " : " << step_index << " : " << end_index << "\n";
            if (ret == 9)
                msg << "ERROR: Lower bound is greater than upper bound for " << block_name << " > " << start_index << " : " << step_index << " : " << end_index << "\n";
            m_errorString.append(msg.str());
            return ret;
        }

        // affect all bounds in the set
        for (int i = start_index; i <= end_index; i += step_index) {
            if (block_type[i] != "undefined") {
                msg << "ERROR: Bound already defined for " << block_name << "> " << start_index << " : " << step_index << " : " << end_index << "\n";
                m_errorString.append(msg.str());
                ret = 7;
            } else {
                block_type[i] = type;
                block_lowerbound[i] = lowerbound;
                block_upperbound[i] = upperbound;
            }
        }

        // move to next line
        // note that this will fail if there are blank lines between two sets of indexes (of the same block)
        file_bounds.ignore(256, '\n');
    }

    return ret;
}


// ***************************
// ******  CONSTANTS   *******
// ***************************

/**
  *\fn int BocopDefinition::readConstants (void)
  * This function allows to read the constants of the problem
  * from constants file (member).
  */
int BocopDefinition::readConstants(void)
{
    // First we allocate space for the constants array :
    this->m_constants = new double[this->m_dimConstant];

    int test_m_dimConstant;

    // Then we read the file :
    ifstream file_const(this->m_constantsFileName.c_str(), ios::in | ios::binary);
    streampos current_pos; // position in the file when reading it
    if (file_const) { // if the opening succeeded
        // First we read the dimension of the constants which is written
        // at the beginning of the file, after the comments :
        current_pos = file_const.tellg();  // beginning of the file
        skip_comments(file_const, current_pos);  // Skip comments in file
        file_const >> test_m_dimConstant;

        if (test_m_dimConstant != this->m_dimConstant) {
            m_errorString.append(" BocopDefinition::readConstants : ERROR.\n");
            m_errorString.append(" Dimension for the constants between definition and constants files do not match\n");
            return 1;
        }

        // Now we can read the values for the constants :
        for (int i = 0; i < this->m_dimConstant; i++) {
            current_pos = file_const.tellg();  // beginning of the file
            skip_comments(file_const, current_pos);  // Skip comments in file

            // Then we read the value :
            try {
                file_const >> this->m_constants[i];
            } catch (int) {
                m_errorString.append("BocopDefinition::readConstants : an error occurred while reading constants file.\n");
                return 2;
            }
        }
    }

    this->m_flagConstantsDone = true;
    return 0;
}


int BocopDefinition::readNames(void)
{
    int i;

    // State :
    m_stateNames.reserve(m_dimState);
    for (i = 0; i < m_dimState; ++i) {
        string found = getName("state", i);
        m_stateNames.push_back(found);
    }

    // COntrol
    m_controlNames.reserve(m_dimControl);
    for (i = 0; i < m_dimControl; ++i) {
        string found = getName("control", i);
        m_controlNames.push_back(found);
    }

    // Algebraic variables
    m_algebraicNames.reserve(m_dimAlgebraic);
    for (i = 0; i < m_dimAlgebraic; ++i) {
        string found = getName("algebraic", i);
        m_algebraicNames.push_back(found);
    }

    // optimization parameters
    m_optimvarsNames.reserve(m_dimParameter);
    for (i = 0; i < m_dimParameter; ++i) {
        string found = getName("parameter", i);
        m_optimvarsNames.push_back(found);
    }

    // Constants
    m_constantNames.reserve(m_dimConstant);
    for (i = 0; i < m_dimConstant; ++i) {
        string found = getName("constant", i);
        m_constantNames.push_back(found);
    }

    // Boundary conditions
    m_boundcondNames.reserve(m_dimBoundCond);
    for (i = 0; i < m_dimBoundCond; ++i) {
        string found = getName("boundarycond", i);
        m_boundcondNames.push_back(found);
    }

    // Path constraints
    m_pathcondNames.reserve(m_dimPathCond);
    for (i = 0; i < m_dimPathCond; ++i) {
        string found = getName("constraint", i);
        m_pathcondNames.push_back(found);
    }

    return 0;
}


// ********* DISCRETIZATION ************

// ****************************
// ***** Get Coefficients *****
// ****************************


/**
 * \fn int BocopDefinition::readMethod()
 * Function to read the coefficients of the method in a file.
 * .disc files have to be written in correct standard format in order
 * to be read by this function. The coefficients are those of a general
 * Runge Kutta method (a, b, c), and presented in the Butcher form.
 */
/*
int BocopDefinition::readMethod()
{

    if (this->m_flagDefinitionDone == false) {
        m_errorString.append(" BocopDefinition::readMethod() : ERROR \n");
        m_errorString.append(" Cannot set the discretization method coefficients");
        m_errorString.append(" because no problem definition was found... Please");
        m_errorString.append(" call readDefinition, and try again. \n");
        return 1;
    }

    // We need to get a variable defined during compilation (option -DPATH_DISC),
    // giving us the path to the /disc folder, in bocop folder :
    string name_f_disc = m_pathToDiscFiles + this->m_discMethod + ".disc";
    ifstream file_disc(name_f_disc.c_str(), ios::in | ios::binary);
    string lookingString = "Looking for file " + name_f_disc + "\n";

    if (!file_disc) { // if the opening failed
        m_errorString.append("Cannot find discretization file...\n");
        m_errorString.append(lookingString);
        //        m_errorString.append ("1) The path to the discretization folder might be wrong. It can be defined ");
        //        m_errorString.append ("during the compilation of the executable (-D option), or set later with setPathDiscretization.\n");
        m_errorString.append("1) The value of discretization.method set in problem.def might be wrong. ");
        m_errorString.append("This value should be the name of an existing .disc file in the disc folder.\n");
        return 2;
    }

    // *********************
    // *****  READING  *****
    // *********************

    streampos current_pos; // position in the file
    current_pos = file_disc.tellg();  // beginning of the file

    skip_comments(file_disc, current_pos);  // Skip comments in file

    // First we read the number of stages of the discretization method :
    int dim_stage; // value found in .disc file
    file_disc >> dim_stage;

    if (this->m_dimStage <= 0)
        this->m_dimStage =  dim_stage;
    else {
        if (this->m_dimStage != dim_stage) {
            m_errorString.append("Value for the number of stages of the discretization method ");
            m_errorString.append("given in the constructor does not match with the one found ");
            m_errorString.append("found in .disc file. \n");
            return 3;
        }
    }

    // We allocate space for the coefficients vectors
    m_discCoeffA = new double * [this->m_dimStage];
    for (int i = 0; i < this->m_dimStage; ++i) {
        m_discCoeffA[i] = new double[this->m_dimStage];
    }
    m_discCoeffB =  new double[this->m_dimStage];
    m_discCoeffC =  new double[this->m_dimStage];

    // Then we read the coefficients of the method
    // a line contains c[i], and all a[i][]
    int i, j;

    try {
        for (i = 0; i < m_dimStage; i++) {
            current_pos = file_disc.tellg(); // New position in file
            skip_comments(file_disc, current_pos);

            file_disc >> m_discCoeffC[i];

            for (j = 0; j < m_dimStage; j++) {
                file_disc >> m_discCoeffA[i][j];
            }
        }


        // The last line contains b[j]
        for (j = 0; j < m_dimStage; j++) {
            file_disc >> m_discCoeffB[j];
        }

    } catch (...) {
        m_errorString.append("An error occurred while reading the method's coefficients. ");
        m_errorString.append("Please check .disc file format and coefficients are correct.\n");
        return 4;
    }

    file_disc.close();

    m_flagMethodDone = true;

    return 0;
}
*/

/**
 * \fn int BocopDefinition::readTimes()
 * This function allows to set the time discretization values.
 * We store these values in arrays : one for the discretization
 * steps, and another for the stages of the method.
 */
int BocopDefinition::readTimes()
{
    int status = 0;

    status = setTimeSteps();
    if (status != 0)
        return 1;

    // If there is a parameter identification to do, we have to merge the vector of time steps with the vector of observation times
    if (isParamId()) {
        // since m_timeSteps is normalized, before merging it with m_timeObservation, we have to rescale it
        double* unnormTimeSteps = new double[m_dimStep + 1];
        for (int i = 0; i < m_dimStep + 1 ; i++)
            unnormTimeSteps[i] = m_t0 + m_timeSteps[i] * (m_tF - m_t0);

        int dim = m_dimStep + 1;
        status = this->merge(m_timeObservation, m_dimTimeObservation, unnormTimeSteps, dim, m_indexObservation);

        m_dimStepBeforeMerge = m_dimStep;

        m_dimStep = dim - 1;

        // and now we have to affect to m_timeSteps the normalized merged vector
        delete[] m_timeSteps;
        m_timeSteps = new double[m_dimStep + 1];

        if (unnormTimeSteps[m_dimStep] <= unnormTimeSteps[0]) {
            stringstream error;
            error << "After merging times final time is lower than initial time.\n initial time: ";
            error << unnormTimeSteps[0] << "  final time: " << unnormTimeSteps[m_dimStep] <<  endl;
            m_errorString.append(error.str());
            return 2;
        }

        for (int i = 0; i < m_dimStep + 1; i++)
            m_timeSteps[i] = (unnormTimeSteps[i] - unnormTimeSteps[0]) / (unnormTimeSteps[m_dimStep] - unnormTimeSteps[0]);

        delete[] unnormTimeSteps;

        if (status != 0)
            return 3;
    }

    status = setTimeStages();
    if (status != 0)
        return 4;

    m_flagTimesDone = true;

    return 0;
}




/**
 * \fn int BocopDefinition::setTimeStepsFromFile (const string name_file)
 * This function allows to set all the values of the times for the discretization steps.
 * It reads from a standard ".times" file which contains the number of steps of the problem,
 * and the values of the times.
 */
int BocopDefinition::setTimeStepsFromFile(const string name_file)
{
    int dimStep_in_file;

    // We open the file containing the discretization steps :
    ifstream file_times(name_file.c_str(), ios::in | ios::binary);
    if (!file_times) {
        m_errorString.append("error in setTimeStepsFromFile : Unable to open times file (" + name_file + ")\n");
        return 1;
    }

    streampos current_pos; // position in the file when reading it

    // Now we read the first value, which should be the number of
    // stages of the discretization method :
    try {
        current_pos = file_times.tellg();  // beginning of the file
        skip_comments(file_times, current_pos);  // Skip comments in file
        file_times >> dimStep_in_file;
    } catch (...) {
        m_errorString.append("error in setTimeStepsFromFile : cannot read the number of steps at the beginning of the file.\n");
        return 2;
    }

    // If m_dimStep was undefined in this instance, we assign
    // the value found in times file :
    if (this->m_dimStep <= 0)
        this->m_dimStep = dimStep_in_file;
    else {
        // If m_dimStep is defined but is different from the
        // value in times file, we return :
        if (this->m_dimStep != dimStep_in_file) {
            //            m_warningString.append("Number of discretization steps in times file (" + name_file + ") does not match the one given at instanciation. ");
            //            m_warningString.append("Warning : a new DEFAULT constant step time grid will be used.\n");
            //            m_isWarning = true;

            if (m_timeSteps != 0)
                delete[] m_timeSteps;
            this->m_timeSteps = new double[this->m_dimStep + 1];
            int status = setConstTimeSteps();
            if (status != 0)
                return 2;
            else
                return 0;
        }
    }

    // Now that the number of steps is confirmed, we can allocate memory
    // for the time vector :
    if (m_timeSteps != 0)
        delete[] m_timeSteps;
    this->m_timeSteps = new double[this->m_dimStep + 1];

    try {
        current_pos = file_times.tellg();  // current position in the file
        skip_comments(file_times, current_pos);  // Skip comments in file

        for (int i = 0; i < m_dimStep + 1; ++i)
            file_times >> this->m_timeSteps[i];
    } catch (...) {
        m_errorString.append("error in setTimeStepsFromFile : an error occurred when reading the time discretization values.\n");
        return 3;
    }

    // We check that the array is normalized :
    if (m_timeSteps[0] != 0.0 || m_timeSteps[m_dimStep] != 1.0) {
        m_warningString.append("Time grid found in \"" + name_file + "\" is not normalized.\n");
        m_warningString.append("Warning : a new DEFAULT constant step time grid will be used.\n");
        m_isWarning = true;

        delete[] m_timeSteps;

        int status = setConstTimeSteps();
        if (status != 0)
            return 4;
    }

    return 0;
}


/**
 * \fn int BocopDefinition::readObservations()
 * This function allows to read the file where the user put the observations informations.
 * It supposes that the file is structered as it follows:
 * first the column with the times of observations, then the matrix with the observations and then the matrix
 * with the weights of the observation. The columns should be separated by a comma.
 *
 */
int BocopDefinition::readObservations()
{
    m_dimTimeObservation = new int[m_sizeDataSet];
    m_dimObservation = new int[m_sizeDataSet];
    m_timeObservation = new double*[m_sizeDataSet];
    m_indexObservation = new int* [m_sizeDataSet];
    m_observations = new double** [m_sizeDataSet];
    m_weightObservations = new double** [m_sizeDataSet];




    string local_problem_dir;
    if (m_defFileName.size() > 11){// called by interface
        //++++ recontruct problem dir only used for observation files
        //++++ erase "problem.def"
        local_problem_dir = m_defFileName;
        local_problem_dir.erase(local_problem_dir.end()-11,local_problem_dir.end());
        cout << "my problem dir: " << m_defFileName.size() << endl;
    }


    // We extract the extension of the observation file
    string extension = m_observationFileName;
    reverse(extension.begin(), extension.end());
    string delimiter = ".";
    size_t pos = extension.find(delimiter);
    if (pos == string::npos) {
        m_errorString.append("BocopDefinition::readObservations : ERROR. Observation file must be in .csv format\n");
        return 1;
    } else
        extension.erase(extension.begin() + pos, extension.end());

    // We check that the extension of the file is csv
    if (extension != "vsc") {
        m_errorString.append("BocopDefinition::readObservations : ERROR. Observation file must be in .csv format\n");
        return 1;
    }

    // We extract the base name without number
    string baseFileName = m_observationFileName;
    reverse(baseFileName.begin(), baseFileName.end());
    baseFileName.erase(0, pos + delimiter.length());

    delimiter = "-";
    pos = baseFileName.find(delimiter);
    if (m_sizeDataSet > 1 && pos == string::npos) {
        m_errorString.append("BocopDefinition::readObservations : ERROR. Observation files name must contain '-' in case of multiple datasets.\n");
        return 2;
    }
    baseFileName.erase(0, pos + delimiter.length());

    reverse(baseFileName.begin(), baseFileName.end());

    // We make a loop on the number of observation files
    // and we read one file after the other
    for (int k = 0; k < m_sizeDataSet; k++) {

        vector<string> allFileData;

        // We set the name of the file
        ostringstream nameFileStream;
        if (m_sizeDataSet > 1){
            if (m_defFileName.size() > 11)// called by interface
                nameFileStream << local_problem_dir << baseFileName << "-" << k << ".csv";
            else
                nameFileStream << baseFileName << "-" << k << ".csv";
        }
        else{
                if (m_defFileName.size() > 11)// called by interface
                    nameFileStream << local_problem_dir << baseFileName << ".csv";
                else
                    nameFileStream << baseFileName << ".csv";
            }

        string numFile = nameFileStream.str();


        // First we read the file containing the observation times, the observation values and the observation weights
        try {
            ifstream file_obs(numFile.c_str(), ios::in | ios::binary);

            if (!file_obs) { //the opening failed
                m_errorString.append("BocopDefinition::readObservations : ERROR. \n");
                m_errorString.append("Cannot open the file containing the observations.\n ");
                m_errorString.append(numFile);
                return 2;
            }

            string line; //string to stock each line
            streampos current_pos; //position in the file
            current_pos = file_obs.tellg(); //beginning of the file

            skip_comments(file_obs, current_pos);

            //        while(getline(file_obs, line))
            while (!file_obs.eof()) {
                getline(file_obs, line);
                if (line != "")
                    allFileData.push_back(line);
            }

            file_obs.close();
        } catch (...) {
            m_errorString.append("BocopDefinition::readObservations : ERROR. \n");
            m_errorString.append("An error occured while reading the observations file.");
            return 3;
        }

        // Then we read line by line
        string value;
        int commaNb = 0;
        int missingCounter = 0;

        m_dimTimeObservation[k] = (int) allFileData.size();
        commaNb  = (int) count(allFileData.at(0).begin(), allFileData.at(0).end(), m_observationSeparator);
        if (m_paramIdType == "LeastSquareWithCriterion" || m_paramIdType == "LeastSquare") {
            // Check first if commaNb is even
            m_dimObservation[k] = commaNb / 2;
        } else if (m_paramIdType == "Manual")
            m_dimObservation[k] = commaNb;
        else {
            ostringstream oss;
            oss <<  "The paramid.type value is wrong. The value read is : " << m_paramIdType << ". Possible values: LeastSquare, LeastSquareWithCriterion, Manual. \n";
            m_errorString.append("BocopDefinition::readObservations() : ERROR. \n");
            m_errorString.append("An error occured while reading the definition file.");
            m_errorString.append(oss.str());
            return 18;
        }

        string* tmpObs = new string[m_dimObservation[k]]; // temporary array to store the observation values on a line

        string* tmpWeights = new string[m_dimObservation[k]]; // temporary array to store the weights values on a line


        m_timeObservation[k] = new double[m_dimTimeObservation[k]];
        m_indexObservation[k] = new int[m_dimTimeObservation[k]];

        m_observations[k] = new double*[m_dimObservation[k]];
        m_weightObservations[k] = new double*[m_dimObservation[k]];

        for (int i = 0; i < m_dimObservation[k]; i++) {
            m_observations[k][i] = new double[m_dimTimeObservation[k]];
            m_weightObservations[k][i] = new double[m_dimTimeObservation[k]];
        }

        // We check if there are missing values in the data observation file
        ostringstream oss;

        for (int i = 0; i < m_dimTimeObservation[k]; i++) {
            if (commaNb != count(allFileData.at(i).begin(), allFileData.at(i).end(), m_observationSeparator)) {
                oss << "Wrong number of separators detected at line: " << i + 1 << "\n";
                oss << "expected " << commaNb << " separators and found " << count(allFileData.at(i).begin(), allFileData.at(i).end(), m_observationSeparator) << "\n";
            }
        }

        // We read one line after the other, checking at each step if there are missing values
        for (int i = 0; i < m_dimTimeObservation[k]; i++) {
            // If the number of commas is different, the file given by the user is not correct format
            if (commaNb != count(allFileData.at(i).begin(), allFileData.at(i).end(), m_observationSeparator)) {
                m_errorString.append("BocopDefinition::readObservations : ERROR. \n");
                m_errorString.append(oss.str());
                return 4;
            } else {
                stringstream stream;
                double valueToDouble;

                // First we get the time value
                istringstream line(allFileData.at(i));
                getline(line, value, m_observationSeparator);
                if (value.find_first_not_of(' ') == string::npos || value == "") {
                    m_errorString.append("BocopDefinition::readObservations : ERROR. \n");
                    ostringstream oss;
                    oss << "Missing time value at position " << i << "\n";
                    m_errorString.append(oss.str());
                    return 5;
                }
                stream.str(value);
                stream >> valueToDouble;
                m_timeObservation[k][i] = valueToDouble;

                // Then we read the observation values
                for (int j = 0; j < m_dimObservation[k]; j++)
                    getline(line, tmpObs[j], m_observationSeparator);

                // and the weight values, only if it's not Manual
                if (m_paramIdType != "Manual") {
                    for (int j = 0; j < m_dimObservation[k]; j++)
                        getline(line, tmpWeights[j], m_observationSeparator);
                }

                // We store the observation and weight values checking for missing values
                for (int j = 0; j < m_dimObservation[k]; j++) {
                    if (tmpObs[j].find_first_not_of(' ') == string::npos || tmpObs[j] == "") {
                        m_warningString.append("BocopDefinition::readObservations : WARNING. \n");
                        ostringstream oss;
                        oss << "Missing observation value at time " << i << " and observation " << j << "\n";
                        m_warningString.append(oss.str());
                        m_warningString.append("A null weight will be used for this observation.");

                        m_observations[k][j][i] = 0;
                        m_weightObservations[k][j][i] = 0;
                        missingCounter++;
                    } else { //we store the values
                        // We reinitialize the stringstream
                        stream.str("");
                        stream.clear();

                        stream.str(tmpObs[j]);
                        stream >> valueToDouble;
                        m_observations[k][j][i] = valueToDouble;
                        if (m_paramIdType == "LeastSquareWithCriterion" || m_paramIdType == "LeastSquare") {
                            if (tmpWeights[j].find_first_not_of(' ') == string::npos || tmpWeights[j] == "") {
                                m_warningString.append("BocopDefinition::readObservations : WARNING. \n");
                                ostringstream oss;
                                oss << "Missing weight value in observation file " << numFile << " at time " << i << " and observation " << j << "\n";
                                m_warningString.append(oss.str());
                                m_warningString.append("A null weight will be used for this observation.");
                                m_weightObservations[k][j][i] = 0; //  v1.1.3
                                missingCounter++;
                            } else {
                                // We reinitialize the stringstream
                                stream.str("");
                                stream.clear();

                                stream.str(tmpWeights[j]);
                                stream >> valueToDouble;
                                m_weightObservations[k][j][i] = valueToDouble;
                            }
                        } else if (m_paramIdType == "Manual")
                            m_weightObservations[k][j][i] = 1;
                        else {
                            ostringstream oss;
                            oss <<  "The paramid.type value is wrong. The value read is : " << m_paramIdType << ". Possible values: LeastSquare, LeastSquareWithCriterion, Manual. \n";
                            m_errorString.append("BocopDefinition::readObservations() : ERROR. \n");
                            m_errorString.append("An error occured while reading the definition file.");
                            m_errorString.append(oss.str());
                            return 18;
                        }

                        // We check that the weights are positive
                        if (m_weightObservations[k][j][i] < 0) {
                            m_errorString.append("BocopDefinition::readObservations : ERROR. \n");
                            ostringstream oss;
                            oss << "Wrong weight :" << m_weightObservations[k][j][i] << "\n";
                            m_errorString.append(oss.str());
                            m_errorString.append("Weights have to be positive. \n");
                            return 6;
                        }
                    }
                }
            } //test sur le nombre de separateur en commentaires si weight = 1
        }

        delete[] tmpObs;
        delete[] tmpWeights;

//        for (int i=1; i<m_dimTimeObservation[k]; i++) {
//        ostringstream ossdebug;
//        ossdebug << m_timeObservation[k][i] <<  "\n";
//        m_errorString.append(ossdebug.str());
//        }

        // We check if the time vector is in ascending order
        for (int i = 1; i < m_dimTimeObservation[k]; i++) {
            if (m_timeObservation[k][i] <= m_timeObservation[k][i - 1]) {
                m_errorString.append("BocopDefinition::readObservations : ERROR. \n");
                m_errorString.append("The time vector of observation is not in ascending order.");
                return 6;
            }
        }

        // We show a message saying how many measures we encountered, for how many times, and how many missing values there were
        cout << "The dimension of the measures for file " << numFile << " is " << m_dimObservation[k] << endl;
        cout << "The number of measures is " << m_dimTimeObservation[k] << endl;
        cout << "The total number of missing values is " << missingCounter << endl;
    }

//    // Display the observations
//    for (int k=0; k<m_sizeDataSet; k++) {
//        for(int i=0; i<m_dimTimeObservation[k]; i++) {
//            cout << "observation time " << m_timeObservation[k][i] << " observations ";
//            for (int j=0; j<m_dimObservation[k]; j++)
//                cout << " " << m_observations[k][j][i] ;
//            cout << endl;
//        }
//    }

    return 0;

}
