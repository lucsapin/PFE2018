// This code is published under the Eclipse Public License
// File: start_from_sol.cpp
// Authors: Vincent Grelard, Daphne Giorgi, Pierre Martinon
// Inria Saclay and Cmap Ecole Polytechnique
// 2011-2016


#include <StartingPoint.hpp>


StartFromPreviousSolution::StartFromPreviousSolution(const int n,
        const double* m_timeSteps,
        const double* m_timeStages,
        const int n_y,
        const int n_u,
        const int n_z,
        const int n_p,
        const int n_if,
        const int n_path,
        const int m_dimStage,
        const int n_total,
        const int n_c,
        const double* constants,
        const double t0,
        const double tf,
        const string m_freeTime,
        const bool init_lambda,
        const double* b):
    StartingPoint(n,
                  m_timeSteps,
                  m_timeStages,
                  n_y,
                  n_u,
                  n_z,
                  n_p,
                  m_dimStage,
                  n_total,
                  n_c,
                  constants,
                  t0,
                  tf,
                  m_freeTime),
    m_dimGenStep(-1),
    m_dimGenStage(-1),
    m_dimBoundaryCond(n_if),
    m_dimPathCond(n_path),
    m_solutionFile("problem.sol"),
    m_initLambda(init_lambda),
    m_flagAllocGenLambda(false),
    m_flagAllocInterpLambda(false),
    m_flagAllocGenZ(false),
    m_flagAllocInterpZ(false)
{
    if (b == 0)
        m_discCoeffB = 0;
    else {
        this->m_discCoeffB = new double[m_dimStage];

        for (int i = 0; i < m_dimStage; i++) {
            m_discCoeffB[i] = b[i];
        }
    }
}



// This function gets a starting point for an optimization from
// the solution of a previous optimization.
int StartFromPreviousSolution::setStartingPoint()
{
    int status = -1;

    status = readVariables();
    if (status != 0) {
        cerr << endl << " *****  ERROR  ***** " << endl;
        cerr << " In StartingPoint::readVariables() " << endl;
        return 1;
    }

    status = interpolateVariables();
    if (status != 0) {
        cerr << endl << " *****  ERROR  ***** " << endl;
        cerr << " In StartingPoint::interpolateVariables() " << endl;
        return 2;
    }

    status = generateStartingPoint();
    if (status != 0) {
        cerr << endl << " *****  ERROR  ***** " << endl;
        cerr << " In StartingPoint::generateStartingPoint() " << endl;
        return 3;
    }

    if (m_initLambda == true) {
        status = interpolateMultipliers();
        if (status != 0) {
            cerr << endl << " *****  ERROR  ***** " << endl;
            cerr << " In StartFromPreviousSolution::interpolateMultipliers() " << endl;
            return 4;
        }

        status = generateStartingLambda();
        if (status != 0) {
            cerr << endl << " *****  ERROR  ***** " << endl;
            cerr << " In StartFromPreviousSolution::generateStartingLambda() " << endl;
            return 5;
        }

        status = interpolateBoundMultipliers();
        if (status != 0) {
            cerr << endl << " *****  ERROR  ***** " << endl;
            cerr << " In StartFromPreviousSolution::interpolateBoundMultipliers() " << endl;
            return 6;
        }

        status = generateStartingZ();
        if (status != 0) {
            cerr << endl << " *****  ERROR  ***** " << endl;
            cerr << " In StartFromPreviousSolution::generateStartingZ() " << endl;
            return 7;
        }
    }

    return 0;
}


StartFromPreviousSolution::~StartFromPreviousSolution()
{
    if (m_flagAllocGenLambda)
        deallocateGenMultipliers();

    if (m_flagAllocInterpLambda)
        deallocateInterpMultipliers();

    if (m_flagAllocGenZ)
        deallocateGenBoundMultipliers();

    if (m_flagAllocInterpZ)
        deallocateInterpBoundMultipliers();

    if (m_initLambda == true) {
        delete[] this->m_discCoeffB;
        delete[] this->m_startingLambda;
        delete[] this->m_startingZL;
        delete[] this->m_startingZU;
    }
}


// This function reads the variables stored in a solution file. It
// returns the values of each variables on the discretization points.
// It also gives the dimensions found in this solution file.
int StartFromPreviousSolution::readVariables()
{
    int status = -1;

    int i = 0;
    int j = 0;

    // First we read the dimensions of the problem :
    status = readDimensions();
    if (status != 0) {
        cerr << endl << " *****  ERROR  ***** " << endl;
        cerr << " StartFromPreviousSolution::readVariables() : error while reading dimensions " << endl;
        return 1;
    }

    // We allocate the memory to store the variables :
    status = allocateGenerationVars();
    if (status != 0) {
        cerr << endl << " *****  ERROR  ***** " << endl;
        cerr << " In StartFromPreviousSolution::readVariables() : error allocating memory " << endl << endl;
        return 2;
    }

    // If we are doing a warm start
    // we allocate the memory to store the multipliers :
    if (m_initLambda == true) {
        status = allocateGenMultipliers();
        if (status != 0) {
            cerr << endl << " *****  ERROR  ***** " << endl;
            cerr << " In StartFromPreviousSolution::readVariables() : error allocating memory " << endl << endl;
            return 2;
        }

        status = allocateGenBoundMultipliers();
        if (status != 0) {
            cerr << endl << " *****  ERROR  ***** " << endl;
            cerr << " In StartFromPreviousSolution::readVariables() : error allocating memory " << endl << endl;
            return 2;
        }
    }

    // We now read the variables that will be used to generate the starting point :
    // First we try to open the solution file :
    ifstream ifile(this->m_solutionFile.c_str(), ios::in | ios::binary);
    if (!ifile) {
        cerr << endl << " *****  ERROR  ***** " << endl;
        cerr << "  In StartFromPreviousSolution::readVariables : cannot open solution file" << endl << endl;
        return 3; // unable to open the specified solution file
    }

    // We skip all commented lines at the beginning, and 4 values
    // after that which we are not interested in :
    streampos current_pos;
    string trash;

    for (i = 0; i < 4; ++i) {
        current_pos = ifile.tellg();
        skip_comments(ifile, current_pos);

        ifile >> trash;
    }


    // Now we can read the variables :

    // 1) Time discretization vector and time stages vector :

    // time vector found in the solution file (can be different from the one
    // of the current problem, in which case an interpolation is necessary to
    // set the starting point). We extract it and reorganize it in two time vectors,
    // one for the steps and one for the stages :
    double* m_genTimeSteps;
    m_genTimeSteps = new double[this->m_dimGenStep + 1];

    double* m_genTimeStages;
    m_genTimeStages = new double[this->m_dimGenStep * this->m_dimGenStage];

    current_pos = ifile.tellg();
    skip_comments(ifile, current_pos);
    for (i = 0; i < this->m_dimGenStep; ++i) {
        ifile >> m_genTimeSteps[i];
        // We read the time on the stages of the discretization method
        for (j = 0; j < this->m_dimGenStage; ++j)
            ifile >> m_genTimeStages[i * this->m_dimGenStage + j];
    }
    ifile >> m_genTimeSteps[m_dimGenStep]; // last time step (on the bound of the time domain)


    // 2) State :
    for (i = 0; i < this->m_dimState; ++i) {
        current_pos = ifile.tellg();
        skip_comments(ifile, current_pos);

        status = this->m_genState[i].SetFromFile("linear", m_dimGenStep + 1, m_genTimeSteps, ifile);
        if (status != 0) {
            cerr << " StartFromPreviousSolution::readVariables() : ERROR" << endl;
            cerr << " An error occurred while reading previous solution file for state #" << i << endl;
            return 1;
        }
    }

    // 3) Control :
    for (i = 0; i < this->m_dimControl; ++i) {
        current_pos = ifile.tellg();
        skip_comments(ifile, current_pos);

        status = this->m_genControl[i].SetFromFile("linear", m_dimGenStep * m_dimGenStage, m_genTimeStages, ifile);
        if (status != 0) {
            cerr << " StartFromPreviousSolution::readVariables() : ERROR" << endl;
            cerr << " An error occurred while reading init file for control #" << i << endl;
            return 1;
        }
    }

    // 4) Algebraic variables :
    for (i = 0; i < this->m_dimAlgebraic; ++i) {
        current_pos = ifile.tellg();
        skip_comments(ifile, current_pos);

        status = this->m_genAlgebraic[i].SetFromFile("linear", m_dimGenStep * m_dimGenStage, m_genTimeStages, ifile);
        if (status != 0) {
            cerr << " StartFromPreviousSolution::readVariables() : ERROR" << endl;
            cerr << " An error occurred while reading init file for algebraic variable #" << i << endl;
            return 1;
        }
    }

    // 5) Parameters:
    for (j = 0; j < this->m_dimParameter; ++j) {
        current_pos = ifile.tellg();
        skip_comments(ifile, current_pos);

        ifile >> this->m_parameter[j];
    }

    ////////////////////////////////////////////////////////////
    // If it's a warm start we read also the multipliers
    ////////////////////////////////////////////////////////////

    if (m_initLambda == true) {

        // We skip the boundary conditions, the path constraints and the dynamic constraints

        // Loop for the boundary conditions
        current_pos = ifile.tellg();
        skip_comments(ifile, current_pos);
        for (i = 0; i < this->m_dimBoundaryCond * 4; ++i)
            ifile >> trash;

        // Loop for the path conditions
        for (i = 0; i < this->m_dimPathCond; ++i) {
            current_pos = ifile.tellg();
            skip_comments(ifile, current_pos);
            for (j = 0; j < m_dimGenStep * m_dimGenStage + 3; ++j)
                ifile >> trash;
        }

        // Loop for the dynamic conditions
        for (i = 0; i < this->m_dimState; ++i) {
            current_pos = ifile.tellg();
            skip_comments(ifile, current_pos);
            for (j = 0; j < m_dimGenStep + 3; ++j)
                ifile >> trash;
        }

        // We skip the dimension of the constraint multipliers
        current_pos = ifile.tellg();
        skip_comments(ifile, current_pos);

        ifile >> trash;

        // 6) Boundary conditions multipliers
        for (i = 0; i < this->m_dimBoundaryCond; ++i) {
            current_pos = ifile.tellg();
            skip_comments(ifile, current_pos);

            ifile >> this->m_boundaryCondLambda[i];
        }

        // 7) Path constraints multipliers
        for (i = 0; i < this->m_dimPathCond; ++i) {
            current_pos = ifile.tellg();
            skip_comments(ifile, current_pos);

            status = this->m_genPathCondLambda[i].SetFromFile("linear", m_dimGenStep * this->m_dimGenStage, m_genTimeStages, ifile);
            if (status != 0) {
                cerr << " StartFromPreviousSolution::readVariables() : ERROR" << endl;
                cerr << " An error occurred while reading previous solution file for path constraint multiplier #" << i << endl;
                return 1;
            }
            //double* test = new double[m_dimGenStep*m_dimGenStage];
            //m_genPathCondLambda[i].GetVar(test);
            //cout<< "value of the first path constraint multiplier:  " << test[0]<< endl;
            //cout<< "value of the last path constraint multiplier:  " << test[m_dimGenStep*m_dimGenStage-1]<< endl;
            //delete [] test;
        }

        // 8) Adjoint states

        // If we are doing a warm start we generate the time vector for the adjoint states
        // which is the same of the time vector m_genTimeSteps without the first element
        double* gen_t_lambda_steps;
        gen_t_lambda_steps = new double[this->m_dimGenStep];
        for (i = 0; i < this->m_dimGenStep; i++)
            gen_t_lambda_steps[i] = m_genTimeSteps[i + 1];

        for (i = 0; i < this->m_dimState; ++i) {
            current_pos = ifile.tellg();
            skip_comments(ifile, current_pos);

            status = this->m_genDynCondLambda[i].SetFromFile("linear", m_dimGenStep, gen_t_lambda_steps, ifile);
            if (status != 0) {
                cerr << " StartFromPreviousSolution::readVariables() : ERROR" << endl;
                cerr << " An error occurred while reading previous solution file for adjoint state #" << i << endl;
                return 1;
            }
        }
        // We deallocate the memory for the time vector of the adjoint states
        delete[] gen_t_lambda_steps;

        // We skip the a(i,j), b(i), and c(i)
        current_pos = ifile.tellg();
        skip_comments(ifile, current_pos);
        for (i = 0; i < m_dimGenStage * m_dimGenStage; i++)
            ifile >> trash;

        current_pos = ifile.tellg();
        skip_comments(ifile, current_pos);
        for (i = 0; i < m_dimGenStage; i++)
            ifile >> trash;

        current_pos = ifile.tellg();
        skip_comments(ifile, current_pos);
        for (i = 0; i < m_dimGenStage; i++)
            ifile >> trash;

        // 9) z_L lower bound multipliers

        // corresponding to state variables
        for (i = 0; i < this->m_dimState; ++i) {
            current_pos = ifile.tellg();
            skip_comments(ifile, current_pos);

            status = this->m_genStateZL[i].SetFromFile("linear", m_dimGenStep + 1, m_genTimeSteps, ifile);
            if (status != 0) {
                cerr << " StartFromPreviousSolution::readVariables() : ERROR" << endl;
                cerr << " An error occurred while reading previous solution file for z_L corresponding to state variable #" << i << endl;
                return 1;
            }
        }

        // corresponding to controls
        for (i = 0; i < this->m_dimControl; ++i) {
            current_pos = ifile.tellg();
            skip_comments(ifile, current_pos);

            status = this->m_genControlZL[i].SetFromFile("linear", m_dimGenStep * m_dimGenStage, m_genTimeStages, ifile);
            if (status != 0) {
                cerr << " StartFromPreviousSolution::readVariables() : ERROR" << endl;
                cerr << " An error occurred while reading init file for control #" << i << endl;
                return 1;
            }
        }

        // corresponding to algebraic variables
        for (i = 0; i < this->m_dimAlgebraic; ++i) {
            current_pos = ifile.tellg();
            skip_comments(ifile, current_pos);

            status = this->m_genAlgebraicZL[i].SetFromFile("linear", m_dimGenStep * m_dimGenStage, m_genTimeStages, ifile);
            if (status != 0) {
                cerr << " StartFromPreviousSolution::readVariables() : ERROR" << endl;
                cerr << " An error occurred while reading init file for algebraic variable #" << i << endl;
                return 1;
            }
        }

        // corresponding to parameters:
        for (j = 0; j < this->m_dimParameter; ++j) {
            current_pos = ifile.tellg();
            skip_comments(ifile, current_pos);

            ifile >> this->m_parameterZL[j];
        }

        // 10) z_U upper bound multipliers

        // corresponding to state variables
        for (i = 0; i < this->m_dimState; ++i) {
            current_pos = ifile.tellg();
            skip_comments(ifile, current_pos);

            status = this->m_genStateZU[i].SetFromFile("linear", m_dimGenStep + 1, m_genTimeSteps, ifile);
            if (status != 0) {
                cerr << " StartFromPreviousSolution::readVariables() : ERROR" << endl;
                cerr << " An error occurred while reading previous solution file for z_L corresponding to state variable #" << i << endl;
                return 1;
            }
        }

        // corresponding to controls
        for (i = 0; i < this->m_dimControl; ++i) {
            current_pos = ifile.tellg();
            skip_comments(ifile, current_pos);

            status = this->m_genControlZU[i].SetFromFile("linear", m_dimGenStep * m_dimGenStage, m_genTimeStages, ifile);
            if (status != 0) {
                cerr << " StartFromPreviousSolution::readVariables() : ERROR" << endl;
                cerr << " An error occurred while reading init file for control #" << i << endl;
                return 1;
            }
        }

        // corresponding to algebraic variables
        for (i = 0; i < this->m_dimAlgebraic; ++i) {
            current_pos = ifile.tellg();
            skip_comments(ifile, current_pos);

            status = this->m_genAlgebraicZU[i].SetFromFile("linear", m_dimGenStep * m_dimGenStage, m_genTimeStages, ifile);
            if (status != 0) {
                cerr << " StartFromPreviousSolution::readVariables() : ERROR" << endl;
                cerr << " An error occurred while reading init file for algebraic variable #" << i << endl;
                return 1;
            }
        }

        // corresponding to parameters:
        for (j = 0; j < this->m_dimParameter; ++j) {
            current_pos = ifile.tellg();
            skip_comments(ifile, current_pos);

            ifile >> this->m_parameterZU[j];
        }
    }

    // We deallocate all
    delete[] m_genTimeSteps;
    delete[] m_genTimeStages;

    ifile.close();

    return 0;
}


// This function reads the dimensions of the problem solved from the solution file
// generated at the end of the optimization. It will then be useful to read the
// solution, and this solution will finally be used to generate a new starting point.
int StartFromPreviousSolution::readDimensions()
{

    // First we try to open the solution file :
    ifstream ifile(this->m_solutionFile.c_str(), ios::in | ios::binary);
    if (!ifile)
        throw "Cannot open specified solution file to generate a starting point.";

    // The dimensions of the problem in problem.sol are at the beginning
    // of the file. They are written in commented lines, so we will only
    // look for the lines starting with "#" :
    char first_char;
    string first_word, type;
    string line;

    // dummy variables to read the dimensions of the variables in
    // the solution file. If these dimensions do not match those
    // of the current problem, we cannot use this solution file
    // to get the starting point.
    int dimGenState = -1;
    int dimGenControl = -1;
    int dimGenAlgebraic = -1;
    int dimGenParameter = -1;
    int dimGenBoundaryCond = -1;
    int dimGenPathCond = -1;

    ifile >> first_char;
    while (first_char == '#') {
        ifile >> first_word;

        if (first_word == "discretization.steps")
            ifile >> type >> this->m_dimGenStep;
        else if (first_word == "discretization.steps.after.merge") // if the sol file contains this line, we have a bocop version with parameter identification option
            ifile >>  this->m_dimGenStep;
        else if (first_word == "discretization.stages")
            ifile >> type >> this->m_dimGenStage;
        else if (first_word == "state.dimension")
            ifile >> type >> dimGenState;
        else if (first_word == "control.dimension")
            ifile >> type >> dimGenControl;
        else if (first_word == "algebraic.dimension")
            ifile >> type >> dimGenAlgebraic;
        else if (first_word == "parameter.dimension")
            ifile >> type >> dimGenParameter;
        else if (first_word == "boundarycond.dimension")
            ifile >> type >> dimGenBoundaryCond;
        else if (first_word == "constraint.dimension")
            ifile >> type >> dimGenPathCond;
        else
            getline(ifile, line);

        ifile >> first_char;
    }
    ifile.close();

    if ((this->m_dimGenStep < 0) | (this->m_dimGenStage < 0) | (dimGenState < 0)
            | (dimGenControl < 0) | (dimGenAlgebraic < 0) | (dimGenParameter < 0)
            | (dimGenBoundaryCond < 0) | (dimGenPathCond < 0)) {
        cerr << " In StartFromPreviousSolution::readDimensions() : ERROR " << endl;
        cerr << " Unable to read the dimensions of the problem in the solution file." << endl;
        return 1;
    }

    if ((dimGenState != this->m_dimState) | (dimGenControl != this->m_dimControl) | (dimGenAlgebraic != this->m_dimAlgebraic) | (dimGenParameter != this->m_dimParameter)) {
        cerr << " In StartFromPreviousSolution::readDimensions() : ERROR " << endl;
        cerr << " One of the variables dimension does not match between the solution file used to generate the starting point, and the current definition of your problem. You cannot use this previous solution to generate your starting point." << endl;
        return 2;
    }

    if ((dimGenBoundaryCond != this->m_dimBoundaryCond) | (dimGenPathCond != this->m_dimPathCond)) {
        cerr << " In StartFromPreviousSolution::readDimensions() : WARNING " << endl;
        cerr << " The constraint dimension does not match between the solution file used to generate the starting point, and the current definition of your problem. You cannot use this previous solution to generate your starting point." << endl;
        return 3;
    }

    return 0;
}


// This function is called after reading the generation multipliers,
// it computes an interpolation of their values, in order to get
// the values of the multipliers at each discretization
// step of the current problem. Therefore, we obtain a starting
// lambda for this problem with correct dimension.
int StartFromPreviousSolution::interpolateMultipliers()
{
    int status = -1;
    int type_interp = 0; // type of interpolation chosen for each variable

    // First we allocate space in memory to store the values
    // of each multiplier after interpolation on each point of
    // the time discretization :
    allocateInterpMultipliers();

    // Now we can compute the interpolation values and store
    // them in these arrays :
    int i;

    for (i = 0; i < this->m_dimState; ++i) {
        BocopInterpolation* MyInterp = 0; // Interpolation class

        type_interp = m_genDynCondLambda[i].GetTypeInterp();
        switch (type_interp) {
            case 1:
                MyInterp = new BocopLinearInterpolation(m_genDynCondLambda[i]);
                break;
            case 2:
                MyInterp = new BocopSplinesInterpolation(m_genDynCondLambda[i]);
                break;
            default:
                cerr << " StartFromPreviousSolution::interpolateMultipliers() : ERROR!" << endl;
                cerr << " Unknown interpolation type in GenerationVariable for the " << i << "-th adjoint state" << endl;
                return 1;
        }

        if (MyInterp == 0) {
            cerr << " StartFromPreviousSolution::interpolateMultipliers() : ERROR!" << endl;
            cerr << " Interpolation failed for adjoint state  #" << i << endl;
            return 2;
        }

        // The value corresponding to the initial time will be unused during initialization
        status = MyInterp->GetArrayInterp(this->m_dimStep + 1, this->m_timeSteps, this->m_dynCondLambda[i]);
        if (status != 0) {
            cerr << endl << " In StartFromPreviousSolution::interpolateMultipliers() " << endl;
            cerr << " Unable to get the values back after interpolation for adjoint state  #" << i << endl;
            return 3;
        }

        delete MyInterp;
    }

    for (i = 0; i < this->m_dimPathCond; ++i) {
        BocopInterpolation* MyInterp = 0; // Interpolation class

        type_interp = m_genPathCondLambda[i].GetTypeInterp();
        switch (type_interp) {
            case 1:
                MyInterp = new BocopLinearInterpolation(m_genPathCondLambda[i]);
                break;
            case 2:
                MyInterp = new BocopSplinesInterpolation(m_genPathCondLambda[i]);
                break;
            default:
                cerr << " StartFromPreviousSolution::interpolateMultipliers() : ERROR!" << endl;
                cerr << " Unknown interpolation type in GenerationVariable for the " << i << "-th path condition multiplier" << endl;
                return 1;
        }

        if (MyInterp == 0)  {
            cerr << " StartFromPreviousSolution::interpolateMultipliers() : ERROR!" << endl;
            cerr << " Interpolation failed for path condition multiplier #" << i << endl;
            return 2;
        }

        // We interpolate on the time steps, since we don't have the values of the time stages for the new problem
        // For each step, all stages will use the same interpolated values
        status = MyInterp->GetArrayInterp(this->m_dimStep * this->m_dimStage, this->m_timeStages, this->m_pathCondLambda[i]);
        if (status != 0) {
            cerr << endl << " In StartFromPreviousSolution::interpolateMultipliers() " << endl;
            cerr << " Unable to get the values back after interpolation for path condition multiplier #" << i << endl;
            return 3;
        }

        delete MyInterp;
    }

    return 0;
}


// This function is called after reading the generation bound multipliers,
// it computes an interpolation of their values, in order to get
// the values of the bound multipliers at each discretization
// step of the current problem. Therefore, we obtain a starting
// z for this problem with correct dimension.
int StartFromPreviousSolution::interpolateBoundMultipliers()
{
    int status = -1;
    int type_interp = 0; // type of interpolation chosen for each variable

    // First we allocate space in memory to store the values
    // of each multiplier after interpolation on each point of
    // the time discretization :
    allocateInterpBoundMultipliers();

    // Now we can compute the interpolation values and store
    // them in these arrays :
    int i;

    for (i = 0; i < this->m_dimState; ++i) {
        BocopInterpolation* MyInterp = 0; // Interpolation class

        type_interp = m_genStateZL[i].GetTypeInterp();
        switch (type_interp) {
            case 1:
                MyInterp = new BocopLinearInterpolation(m_genStateZL[i]);
                break;
            case 2:
                MyInterp = new BocopSplinesInterpolation(m_genStateZL[i]);
                break;
            default:
                cerr << " StartFromPreviousSolution::interpolateBoundMultipliers() : ERROR!" << endl;
                cerr << " Unknown interpolation type in GenerationVariable for the " << i << "-th state lower bound multiplier" << endl;
                return 1;
        }

        if (MyInterp == 0) {
            cerr << " StartFromPreviousSolution::interpolateMultipliers() : ERROR!" << endl;
            cerr << " Interpolation failed for state lower bound multiplier  #" << i << endl;
            return 2;
        }

        // The value corresponding to the initial time will be unused during initialization
        status = MyInterp->GetArrayInterp(this->m_dimStep + 1, this->m_timeSteps, this->m_stateZL[i]);
        if (status != 0) {
            cerr << endl << " In StartFromPreviousSolution::interpolateBoundMultipliers() " << endl;
            cerr << " Unable to get the values back after interpolation for state lower bound multiplier  #" << i << endl;
            return 3;
        }

        delete MyInterp;

        type_interp = m_genStateZU[i].GetTypeInterp();
        switch (type_interp) {
            case 1:
                MyInterp = new BocopLinearInterpolation(m_genStateZU[i]);
                break;
            case 2:
                MyInterp = new BocopSplinesInterpolation(m_genStateZU[i]);
                break;
            default:
                cerr << " StartFromPreviousSolution::interpolateBoundMultipliers() : ERROR!" << endl;
                cerr << " Unknown interpolation type in GenerationVariable for the " << i << "-th state upper bound multiplier" << endl;
                return 1;
        }

        if (MyInterp == 0) {
            cerr << " StartFromPreviousSolution::interpolateBoundMultipliers() : ERROR!" << endl;
            cerr << " Interpolation failed for state upper bound multiplier  #" << i << endl;
            return 2;
        }

        // The value corresponding to the initial time will be unused during initialization
        status = MyInterp->GetArrayInterp(this->m_dimStep + 1, this->m_timeSteps, this->m_stateZU[i]);
        if (status != 0) {
            cerr << endl << " In StartFromPreviousSolution::interpolateBoundMultipliers() " << endl;
            cerr << " Unable to get the values back after interpolation for state upper bound multiplier  #" << i << endl;
            return 3;
        }

        delete MyInterp;
    }

    for (i = 0; i < this->m_dimControl; ++i) {
        BocopInterpolation* MyInterp = 0; // Interpolation class

        type_interp = m_genControlZL[i].GetTypeInterp();
        switch (type_interp) {
            case 1:
                MyInterp = new BocopLinearInterpolation(m_genControlZL[i]); // mem leak here ?
                break;
            case 2:
                MyInterp = new BocopSplinesInterpolation(m_genControlZL[i]);
                break;
            default:
                cerr << " StartFromPreviousSolution::interpolateBoundMultipliers() : ERROR!" << endl;
                cerr << " Unknown interpolation type in GenerationVariable for the " << i << "-th control lower bound multiplier" << endl;
                return 1;
        }

        if (MyInterp == 0) {
            cerr << " StartFromPreviousSolution::interpolateBoundMultipliers() : ERROR!" << endl;
            cerr << " Interpolation failed for control lower bound multiplier #" << i << endl;
            return 2;
        }

        // We interpolate on the time steps, since we don't have the values of the time stages for the new problem
        // For each step, all stages will use the same interpolated values
        status = MyInterp->GetArrayInterp(this->m_dimStep * this->m_dimStage, this->m_timeStages, this->m_controlZL[i]);
        if (status != 0) {
            cerr << endl << " In StartFromPreviousSolution::interpolateBoundMultipliers() " << endl;
            cerr << " Unable to get the values back after interpolation for control lower bound multiplier #" << i << endl;
            return 3;
        }

        delete MyInterp;

        type_interp = m_genControlZU[i].GetTypeInterp();
        switch (type_interp) {
            case 1:
                MyInterp = new BocopLinearInterpolation(m_genControlZU[i]);
                break;
            case 2:
                MyInterp = new BocopSplinesInterpolation(m_genControlZU[i]);
                break;
            default:
                cerr << " StartFromPreviousSolution::interpolateBoundMultipliers() : ERROR!" << endl;
                cerr << " Unknown interpolation type in GenerationVariable for the " << i << "-th control upper bound multiplier" << endl;
                return 1;
        }

        if (MyInterp == 0) {
            cerr << " StartFromPreviousSolution::interpolateBoundMultipliers() : ERROR!" << endl;
            cerr << " Interpolation failed for control upper bound multiplier #" << i << endl;
            return 2;
        }

        // We interpolate on the time steps, since we don't have the values of the time stages for the new problem
        // For each step, all stages will use the same interpolated values
        status = MyInterp->GetArrayInterp(this->m_dimStep * this->m_dimStage, this->m_timeStages, this->m_controlZU[i]);
        if (status != 0)  {
            cerr << endl << " In StartFromPreviousSolution::interpolateBoundMultipliers() " << endl;
            cerr << " Unable to get the values back after interpolation for control upper bound multiplier #" << i << endl;
            return 3;
        }

        delete MyInterp;
    }

    for (i = 0; i < this->m_dimAlgebraic; ++i) {
        BocopInterpolation* MyInterp = 0; // Interpolation class

        type_interp = m_genAlgebraicZL[i].GetTypeInterp();
        switch (type_interp) {
            case 1:
                MyInterp = new BocopLinearInterpolation(m_genAlgebraicZL[i]);
                break;
            case 2:
                MyInterp = new BocopSplinesInterpolation(m_genAlgebraicZL[i]);
                break;
            default:
                cerr << " StartFromPreviousSolution::interpolateBoundMultipliers() : ERROR!" << endl;
                cerr << " Unknown interpolation type in GenerationVariable for the " << i << "-th algebraic lower bound multiplier" << endl;
                return 1;
        }

        if (MyInterp == 0) {
            cerr << " StartFromPreviousSolution::interpolateBoundMultipliers() : ERROR!" << endl;
            cerr << " Interpolation failed for algebraic lower bound multiplier #" << i << endl;
            return 2;
        }

        // We interpolate on the time steps, since we don't have the values of the time stages for the new problem
        // For each step, all stages will use the same interpolated values
        status = MyInterp->GetArrayInterp(this->m_dimStep * this->m_dimStage, this->m_timeStages, this->m_algebraicZL[i]);
        if (status != 0) {
            cerr << endl << " In StartFromPreviousSolution::interpolateBoundMultipliers() " << endl;
            cerr << " Unable to get the values back after interpolation for algebraic lower bound multiplier #" << i << endl;
            return 3;
        }

        type_interp = m_genAlgebraicZU[i].GetTypeInterp();
        switch (type_interp) {
            case 1:
                MyInterp = new BocopLinearInterpolation(m_genAlgebraicZU[i]);
                break;
            case 2:
                MyInterp = new BocopSplinesInterpolation(m_genAlgebraicZU[i]);
                break;
            default:
                cerr << " StartFromPreviousSolution::interpolateBoundMultipliers() : ERROR!" << endl;
                cerr << " Unknown interpolation type in GenerationVariable for the " << i << "-th algebraic upper bound multiplier" << endl;
                return 1;
        }

        if (MyInterp == 0) {
            cerr << " StartFromPreviousSolution::interpolateBoundMultipliers() : ERROR!" << endl;
            cerr << " Interpolation failed for algebraic upper bound multiplier #" << i << endl;
            return 2;
        }

        // We interpolate on the time steps, since we don't have the values of the times stages for the new problem
        // For each step, all stages will use the same interpolated values
        status = MyInterp->GetArrayInterp(this->m_dimStep * this->m_dimStage, this->m_timeStages, this->m_algebraicZU[i]);
        if (status != 0) {
            cerr << endl << " In StartFromPreviousSolution::interpolateBoundMultipliers() " << endl;
            cerr << " Unable to get the values back after interpolation for algebraic upper bound multiplier #" << i << endl;
            return 3;
        }

        delete MyInterp;
    }

    return 0;
}


// This function allows to set a new value to the variable solution_file.
// Therefore, after calling this function, if the user wants to create a
// starting point from a previous solution, this previous solution will
// be read from this solution_file.
int StartFromPreviousSolution::setSolutionFile(string sol_file_name)
{
    this->m_solutionFile = sol_file_name;
    ifstream ifile(this->m_solutionFile.c_str());
    if (ifile)
        ifile.close();
    else {
        cerr << " StartFromPreviousSolution::setSolutionFile : Error" << endl;
        cerr << " Given solution file does not exist. Starting point cannot be generated." << endl;
        return 1;
    }

    return 0;
}


// This function allows to allocate space in memory for the
// arrays used to store the values for the multipliers before interpolation
int StartFromPreviousSolution::allocateGenMultipliers()
{
    if (this->m_dimBoundaryCond > 0)
        this->m_boundaryCondLambda = new double[this->m_dimBoundaryCond];

    if (this->m_dimPathCond > 0)
        this->m_genPathCondLambda = new GenerationVariable[this->m_dimPathCond];

    this->m_genDynCondLambda = new GenerationVariable[this->m_dimState];

    this->m_flagAllocGenLambda = true;

    return 0;
}


// This function allows to deallocate space in memory for the
// arrays storing the values of the multipliers used to generate
// the starting point before interpolation.
void StartFromPreviousSolution::deallocateGenMultipliers()
{

    // deallocate vector m_boundaryCondLambda
    if (this->m_dimBoundaryCond > 0)
        delete[] this->m_boundaryCondLambda;

    // deallocate m_genPathCondLambda
    if (this->m_dimPathCond > 0)
        delete[] this->m_genPathCondLambda;

    // deallocate m_genDynCondLambda
    delete[] this->m_genDynCondLambda;
}


// This function allows to allocate space in memory for the
// arrays used to store the values for the multipliers after interpolation
// We calculate the interpolated values on the time steps
int StartFromPreviousSolution::allocateInterpMultipliers()
{
    int i = 0;

    if (this->m_dimPathCond > 0) {
        this->m_pathCondLambda = new double*[this->m_dimPathCond];
        for (i = 0; i < this->m_dimPathCond; ++i)
            this->m_pathCondLambda[i] = new double[this->m_dimStep * this->m_dimStage];
    }

    this->m_dynCondLambda = new double*[this->m_dimState];
    for (i = 0; i < this->m_dimState; ++i)
        this->m_dynCondLambda[i] = new double[m_dimStep + 1];

    this->m_flagAllocInterpLambda = true;

    return 0;

}


// This function allows to deallocate space in memory for the
// arrays storing the values of the multipliers used to generate
// the starting point after interpolation.
void StartFromPreviousSolution::deallocateInterpMultipliers()
{
    // deallocate matrix m_pathCondLambda
    if (this->m_dimPathCond > 0) {
        for (int i = 0; i < this->m_dimPathCond; i++)
            delete [] this->m_pathCondLambda[i];
        delete[] this->m_pathCondLambda;
    }

    // deallocate matrix m_dynCondLambda
    for (int i = 0; i < this->m_dimState; i++)
        delete [] this->m_dynCondLambda[i];
    delete[] this->m_dynCondLambda;
}

// This function allows to allocate space in memory for the
// arrays used to store the values for the bound multipliers before interpolation
int StartFromPreviousSolution::allocateGenBoundMultipliers()
{
    this->m_genStateZL = new GenerationVariable[this->m_dimState];
    this->m_genStateZU = new GenerationVariable[this->m_dimState];

    if (this->m_dimControl > 0) {
        this->m_genControlZL = new GenerationVariable[this->m_dimControl];
        this->m_genControlZU = new GenerationVariable[this->m_dimControl];
    }

    if (this->m_dimAlgebraic > 0) {
        this->m_genAlgebraicZL  = new GenerationVariable[this->m_dimAlgebraic];
        this->m_genAlgebraicZU  = new GenerationVariable[this->m_dimAlgebraic];
    }

    if (this->m_dimParameter > 0) {
        this->m_parameterZL = new double[this->m_dimParameter];
        this->m_parameterZU = new double[this->m_dimParameter];
    }

    this->m_flagAllocGenZ = true;

    return 0;
}


// This function allows to deallocate space in memory for the
// arrays storing the values of the bound multipliers used to generate
// the starting point before interpolation.
void StartFromPreviousSolution::deallocateGenBoundMultipliers()
{
    // deallocate vectors used to store the generation bound multipliers

    // deallocate m_genStateZL and m_genStateZU
    delete[] this->m_genStateZL;
    delete[] this->m_genStateZU;

    // deallocate m_genControlZL and m_genControlZU
    if (this->m_dimControl > 0) {
        delete[] this->m_genControlZL;
        delete[] this->m_genControlZU;
    }

    // deallocate m_genAlgebraicZL and m_genAlgebraicZU
    if (this->m_dimAlgebraic > 0) {
        delete[] this->m_genAlgebraicZL;
        delete[] this->m_genAlgebraicZU;
    }

    // deallocate m_parameterZL and m_parameterZU
    if (this->m_dimParameter > 0) {
        delete[] this->m_parameterZL;
        delete[] this->m_parameterZU;
    }
}


// This function allows to allocate space in memory for the
// arrays used to store the values for the bound multipliers after interpolation
// We calculate the interpolated values on the time steps
int StartFromPreviousSolution::allocateInterpBoundMultipliers()
{
    int i = 0;

    this->m_stateZL = new double*[this->m_dimState];
    this->m_stateZU = new double*[this->m_dimState];
    for (i = 0; i < this->m_dimState; ++i) {
        this->m_stateZL[i] = new double[m_dimStep + 1];
        this->m_stateZU[i] = new double[m_dimStep + 1];
    }

    this->m_controlZL = new double*[this->m_dimControl];
    this->m_controlZU = new double*[this->m_dimControl];
    for (i = 0; i < this->m_dimControl; ++i) {
        this->m_controlZL[i] = new double[m_dimStep * m_dimStage];
        this->m_controlZU[i] = new double[m_dimStep * m_dimStage];
    }

    this->m_algebraicZL = new double*[this->m_dimAlgebraic];
    this->m_algebraicZU = new double*[this->m_dimAlgebraic];
    for (i = 0; i < this->m_dimAlgebraic; ++i) {
        this->m_algebraicZL[i] = new double[this->m_dimStep + 1];
        this->m_algebraicZU[i] = new double[this->m_dimStep + 1];
    }

    this->m_flagAllocInterpZ = true;

    return 0;
}


// This function allows to deallocate space in memory for the
// arrays storing the values of the multipliers used to generate
// the starting point after interpolation.
void StartFromPreviousSolution::deallocateInterpBoundMultipliers()
{
    int i = 0;

    for (i = 0; i < this->m_dimState; ++i) {
        delete[] this->m_stateZL[i];
        delete[] this->m_stateZU[i];
    }
    delete[] this->m_stateZL;
    delete[] this->m_stateZU;

    for (i = 0; i < this->m_dimControl; ++i) {
        delete[] this->m_controlZL[i];
        delete[] this->m_controlZU[i];
    }
    delete[] this->m_controlZL;
    delete[] this->m_controlZU;

    for (i = 0; i < this->m_dimAlgebraic; ++i) {
        delete[] this->m_algebraicZL[i];
        delete[] this->m_algebraicZU[i];
    }
    delete[] this->m_algebraicZL;
    delete[] this->m_algebraicZU;
}


// This function generates the vector of multipliers that we will use
// to generate the lambda in BocopProblem::get_m_startingPoint
int StartFromPreviousSolution::generateStartingLambda()
{
    int dim_m_startingLambda = m_dimBoundaryCond + m_dimPathCond * m_dimStep * m_dimStage + m_dimState * m_dimStep * (m_dimStage + 1);
    int i = 0;
    int j = 0;
    int n = 0;
    int ind = 0;

    // we prepare the coefficient that will multiply the normalized time step
    // that we will use to generate the dynamic multipliers on the stages
    double time_coeff;

    if (this->m_freeTime == "final")
        time_coeff = this->m_parameter[m_dimParameter - 1] - this->m_t0;
    else
        time_coeff = this->m_tF - this->m_t0;

    //cout << "time coeff (tf- t0) = " << time_coeff << endl;

    double h; // h=time_coeff * (m_timeSteps[n+1] - m_timeSteps[n])

    double* lambda_dyn_n;
    lambda_dyn_n = new double[m_dimState];

    // Boundary condition multipliers
    m_startingLambda = new double[dim_m_startingLambda];
    for (i = 0; i < m_dimBoundaryCond; ++i)
        m_startingLambda[ind++] = m_boundaryCondLambda[i];

    for (n = 0; n < this->m_dimStep; n++) {
        // Recover multipliers for time step n
        for (i = 0; i < this->m_dimState; i++)   lambda_dyn_n[i] = m_dynCondLambda[i][n + 1];

        // We write the multipliers for path constraints
        for (j = 0; j < this->m_dimStage; j++) {
            for (i = 0; i < m_dimPathCond; i++)
                this->m_startingLambda[ind++] =  m_pathCondLambda[i][n * this->m_dimStage + j];
        }

        // We write the adjoint states (multipliers for dynamics)
        for (i = 0; i < m_dimState; i++)
            this->m_startingLambda[ind++] = lambda_dyn_n[i];


        // We write the multipliers for dynamic constraints (on the stages)
        h = time_coeff * (this->m_timeSteps[n + 1] - this->m_timeSteps[n]);
        //cout << "h at disc step "<< n <<", time_coeff * (step(n+1)-step(n)) :" << h <<endl;
        for (j = 0; j < this->m_dimStage; j++) {
            for (i = 0; i < this->m_dimState; i++)
                m_startingLambda[ind++] = lambda_dyn_n[i] * h * this->m_discCoeffB[j];
        }
    }

    delete [] lambda_dyn_n;

    return 0;
}



// This function generates the two vectors of bound multipliers that we will use
// to generate the z_L and the z_U in BocopProblem::get_m_startingPoint
int StartFromPreviousSolution::generateStartingZ()
{
    int i = 0;
    int j = 0;
    int n = 0;
    int ind = 0;

    m_startingZL = new double[m_dimStartingPoint];
    m_startingZU = new double[m_dimStartingPoint];

    double* m_stateZL_n = new double[m_dimState];
    double* m_stateZU_n = new double[m_dimState];

    double* m_controlZL_jn = new double[m_dimControl];
    double* m_controlZU_jn = new double[m_dimControl];

    double* m_algebraicZL_n = new double[m_dimAlgebraic];
    double* m_algebraicZU_n = new double[m_dimAlgebraic];

    for (n = 0; n < (this->m_dimStep); ++n)  {
        // recover y, u, z for time step n
        for (i = 0; i < this->m_dimState; i++)  {
            m_stateZL_n[i] = m_stateZL[i][n];
            m_stateZU_n[i] = m_stateZU[i][n];
        }

        for (i = 0; i < this->m_dimAlgebraic; i++) {
            m_algebraicZL_n[i] = m_algebraicZL[i][n];
            m_algebraicZU_n[i] = m_algebraicZU[i][n];
        }

        // write y
        for (i = 0; i < this->m_dimState; ++i, ind++) {
            this->m_startingZL[ind] = 0.0;
            this->m_startingZU[ind] = 0.0;
        }

        // write the u_i, k_i and z_i
        for (j = 0; j < this->m_dimStage; ++j) {
            for (i = 0; i < this->m_dimControl; ++i, ind++) {
                m_controlZL_jn[i] = m_controlZL[i][n * m_dimStage + j];
                m_controlZU_jn[i] = m_controlZU[i][n * m_dimStage + j];
                this->m_startingZL[ind] = 0.0;
                this->m_startingZU[ind] = 0.0;
            }

            // on the k_i there are no boundary conditions
            for (i = 0; i < this->m_dimState; ++i, ind++) {
                this->m_startingZL[ind] = 0.0;
                this->m_startingZU[ind] = 0.0;
            }

            for (i = 0; i < this->m_dimAlgebraic; ++i, ind++) {
                this->m_startingZL[ind] = 0.0;
                this->m_startingZU[ind] = 0.0;
            }
        }
    }

    // Last time step: no u and k, only write y and z:
    for (i = 0; i < this->m_dimState; ++i, ind++) {
        this->m_startingZL[ind] = 0.0;
        this->m_startingZU[ind] = 0.0;
    }

    // Finally, at the end of the vector, we initialize p :
    for (i = 0; i < this->m_dimParameter; ++i, ind++)  {
        this->m_startingZL[ind] = 0.0;
        this->m_startingZU[ind] = 0.0;
    }

    // deallocations
    delete[] m_stateZL_n;
    delete[] m_stateZU_n;
    delete[] m_algebraicZL_n;
    delete[] m_algebraicZU_n;
    delete[] m_controlZL_jn;
    delete[] m_controlZU_jn;

    return 0;
}
