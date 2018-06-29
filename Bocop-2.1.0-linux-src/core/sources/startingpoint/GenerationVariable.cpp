// This code is published under the Eclipse Public License
// File: GenerationVariable.cpp
// Authors: Daphne Giorgi, Vincent Grelard, Pierre Martinon
// Inria Saclay and Cmap Ecole Polytechnique
// 2011-2016


#include <GenerationVariable.hpp>

/**
 * \fn GenerationVariable::GenerationVariable()
 * Default constructor
 */
GenerationVariable::GenerationVariable()
{
    this->dim_gen = -1;
    this->var_gen = 0;
    this->t_gen = 0;
}

/**
 * \fn GenerationVariable::GenerationVariable(const int dim)
 * Constructor
 */
GenerationVariable::GenerationVariable(const int dim)
{
    this->dim_gen = dim;
    this->var_gen = 0;
    this->t_gen = 0;

    allocate_gen_mem();
}

/**
 * \fn GenerationVariable::GenerationVariable(const GenerationVariable& genVar)
 * Copy constructor
 */
GenerationVariable::GenerationVariable(const GenerationVariable& genVar)
{
//    cout << "Call to copy contructor of generation variable" << endl;

    this->dim_gen = genVar.dim_gen;
    this->type_interp = genVar.type_interp;

    if (this->var_gen != 0)
        delete[] this->var_gen;
    this->var_gen = new double[this->dim_gen];

    if (this->t_gen != 0)
        delete[] this->t_gen;
    this->t_gen = new double[this->dim_gen];

    for (int i = 0; i < this->dim_gen; i++) {
        this->var_gen[i] = genVar.var_gen[i];
        this->t_gen[i] = genVar.t_gen[i];
    }
}

/**
 * \fn GenerationVariable::~GenerationVariable()
 * Destructor
 */
GenerationVariable::~GenerationVariable()
{
    if (this->var_gen != 0)
        delete[] this->var_gen;

    if (this->t_gen != 0)
        delete[] this->t_gen;
}

/**
 * \fn void GenerationVariable::operator=(const GenerationVariable& genVar)
 * Overloaded operator=
 */
void GenerationVariable::operator=(const GenerationVariable& genVar)
{
    this->dim_gen = genVar.dim_gen;
    this->type_interp = genVar.type_interp;

    if (this->var_gen != 0)
        delete[] this->var_gen;
    this->var_gen = new double[this->dim_gen];
    for (int i = 0; i < this->dim_gen; i++)
        this->var_gen[i] = genVar.var_gen[i];

    if (this->t_gen != 0)
        delete[] this->t_gen;
    this->t_gen = new double[this->dim_gen];
    for (int i = 0; i < this->dim_gen; i++)
        this->t_gen[i] = genVar.t_gen[i];
}

/**
 * \fn void GenerationVariable::allocate_gen_mem()
 * This function allocates memory for the arrays of the current instance of GenerationVariable
 */
void GenerationVariable::allocate_gen_mem()
{
    if (this->dim_gen <= 0) {
        cerr << " GenerationVariable::allocate_gen_mem : ERROR." << endl;
        cerr << " Cannot allocate, dimension of the array is invalid (dim <= 0)." << endl;
        exit(1);
    }

    if (this->var_gen != 0)
        delete[] this->var_gen;
    this->var_gen = new double[this->dim_gen];

    if (this->t_gen != 0)
        delete[] this->t_gen;
    this->t_gen = new double[this->dim_gen];

}

/**
 * \fn int GenerationVariable::SetFromInitFile(const string name_file)
 * This function reads bocop init file to fill the arrays of the instanciated GenerationVariable.
 */
int GenerationVariable::SetFromInitFile(const string name_file)
{
    int status = -1;

    ifstream file_gen;
    file_gen.open(name_file.c_str(), ios::in | ios::binary);

    if (!file_gen) {
        cout << endl << " *****  Warning  ***** " << endl;
        cout << " In GenerationVariable::SetFromInitFile()." << endl;
        cout << " Cannot open initialization file (\"" << name_file << "\")." << endl;
        cout << " Warning : a new DEFAULT init file will now be created."  << endl << endl;

        // We create a default init file, and open it :
        status = default_init_file(name_file);
        file_gen.open(name_file.c_str(), ios::in | ios::binary);
        if (!file_gen || status != 0) {
            cerr << endl << " *****  Error  ***** " << endl;
            cerr << " In GenerationVariable::SetFromInitFile()." << endl;
            cerr << " Default initialization file cannot be opened." << endl;

            return 1;
        }
    }

    string temp;
    streampos current_pos;

    current_pos = file_gen.tellg();
    skip_comments(file_gen, current_pos);
    file_gen >> temp;

    file_gen.close();

    if (temp == "constant")
        ReadConstantInit(name_file);
    else if (temp == "splines")
        ReadInterpInit(name_file);
    else if (temp == "linear")
        ReadInterpInit(name_file);
    else {
        cerr << " GenerationVariable::SetFromInitFile : ERROR." << endl;
        cerr << " Unknown initialization type in file (" << name_file << "). Read type: " << temp << endl;
        return 2;
    }

    this->type_interp = temp;

    return 0;
}

/**
 * \fn int GenerationVariable::ReadConstantInit(const string name_file)
 * This function fills current arrays reading an initialization file of type "constant".
 * These init files contain only one value, which is constant over the whole time interval.
 */
int GenerationVariable::ReadConstantInit(const string name_file)
{
    // First we allocate space for the constant value :
    this->dim_gen = 1;
    allocate_gen_mem();

    // We open the file to read :
    ifstream file_gen;
    file_gen.open(name_file.c_str(), ios::in | ios::binary);
    if (!file_gen) {
        cerr << " In GenerationVariable::ReadConstantInit() " << endl;
        cerr << " Cannot open file \"" << name_file << "\"..." << endl;
        return 1;
    }


    // We skip the type of initialization :
    string temp;
    streampos current_pos;

    current_pos = file_gen.tellg();
    skip_comments(file_gen, current_pos);
    file_gen >> temp;

    // Now we read the value :
    double const_val;
    current_pos = file_gen.tellg();
    skip_comments(file_gen, current_pos);
    file_gen >> const_val;

    this->var_gen[0] = const_val;
    this->t_gen[0] = -1.0; // default value for t

    file_gen.close();

    return 0;
}

/**
 * \fn int GenerationVariable::ReadInterpInit(const string name_file)
 * This function fills current arrays reading an initialization file of type "splines" or "linear".
 * These init files contain several values of the function, and the points of interpolation where it was evaluated.
 * t0 val0
 * t1 val1 ...
 */
int GenerationVariable::ReadInterpInit(const string name_file)
{
    ifstream file_gen;
    file_gen.open(name_file.c_str(), ios::in | ios::binary);
    if (!file_gen) {
        cerr << " In GenerationVariable::ReadInterpInit() : ERROR " << endl;
        cerr << " Cannot open file \"" << name_file << endl;
        return 1;
    }

    // We skip the type of initialization :
    string temp;
    streampos current_pos;

    current_pos = file_gen.tellg();
    skip_comments(file_gen, current_pos);
    file_gen >> temp;

    // We read the dimension of the generation variable :
    current_pos = file_gen.tellg();
    skip_comments(file_gen, current_pos);
    file_gen >> this->dim_gen;

    // Now that we know this dimension, we can allocate the arrays :
    allocate_gen_mem();

    // And finally, we can read the values of the generation variable :
    current_pos = file_gen.tellg();
    skip_comments(file_gen, current_pos);
    for (int i = 0; i < this->dim_gen; ++i)
        file_gen >> this->t_gen[i] >> this->var_gen[i];

    file_gen.close();

    return 0;
}

/**
 * \fn int GenerationVariable::SetFromFile(const string TYPE_INTERP, const int DIM, const double* X, istream& FILE)
 * Function to set the values of the arrays of an instance of GenerationVariable,
 * using a previous Bocop solution file. This function is mainly called in function
 * readVariables from class StartFromPreviousSolution. But it can be used to set
 * a generation variable from any file, array t_gen must be provided, and the istream
 * must be open and ready to be written.
 */
int GenerationVariable::SetFromFile(const string type_interp, const int dim, const double* x, istream& file)
{

    this->type_interp = type_interp;

    // First we set the dimension :
    this->dim_gen = dim;

    // Now that we know this dimension, we can allocate arrays :
    allocate_gen_mem();

    // We fill the x-axis array with X values, and the y-axis array
    // with the values found in the file :.
    for (int i = 0; i < this->dim_gen; ++i) {
        this->t_gen[i] = x[i];
        file >> this->var_gen[i];
    }

    return 0;
}


int GenerationVariable::SetCopyFromArray(const double* t, const double* var)
{
    if (dim_gen <= 0) {
        cerr << " GenerationVariable::SetCopyFromArray : ERROR." << endl;
        cerr << " The dimension of the arrays must be known before" << endl;
        cerr << " trying to fill them..." << endl;
        return 1;
    }

    if (var_gen == 0 && t_gen == 0)
        allocate_gen_mem();

    int i;
    for (i = 0; i < this->dim_gen; ++i) {
        var_gen[i] = var[i];
        t_gen[i] = t[i];
    }

    return 0;
}

/**
 * \fn void GenerationVariable::EchoGenVar(void)
 * This function displays the properties of the instance of generation vars.
 * It shows the type of init, the number of generation vars, and their values.
 */
void GenerationVariable::EchoGenVar(void)
{
    cout << endl;
    cout << " ** Echo Generation Variable **" << endl;
    cout << " - Type of initialization : " << this->type_interp << endl;
    cout << " - Number of points       : " << this->dim_gen << endl;
    cout << " - x-axis & values        : " << endl;
    for (int i = 0; i < this->dim_gen; ++i)
        cout << "   " << i << ") " << t_gen[i] << " -- " << var_gen[i] << endl;
    cout << endl;

}


int GenerationVariable::GetDimension(void) const
{
    return this->dim_gen;
}

void GenerationVariable::GetVar(double* var_copy) const
{
    for (int i = 0; i < this->dim_gen; ++i)
        var_copy[i] = this->var_gen[i];

}

void GenerationVariable::GetT(double* t_copy) const
{
    for (int i = 0; i < this->dim_gen; ++i)
        t_copy[i] = this->t_gen[i];
}

int GenerationVariable::GetTypeInterp(void) const
{
    if (this->type_interp == "linear")
        return 1; // we return code 1 for linear interpolation
    else if (this->type_interp == "constant")
        return 1; // constant interpolation is treated the same way as linear
    else if (this->type_interp == "splines")
        return 2; // we return code 2 for splines interpolation
    else
        return 0; // error
}

/**
 * \fn int GenerationVariable::default_init_file(const string file_path) const
 * This function allows to generate a new default init file. It creates a new file in <problem's directory>/init/.
 * If the init folder does not exist, we exit with an error.
 */
int GenerationVariable::default_init_file(const string file_path) const
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
    file_init << "# Type of initialization : " << endl;
    file_init << "constant" << endl << endl;
    file_init << "# Constant value for the starting point : " << endl;
    file_init << "0.1" << endl; // 0.1 and not 0 to reduce the risk of math errors

    file_init.close();

    return 0;
}
