// This code is published under the Eclipse Public License
// Authors: Vincent Grelard, Daphne Giorgi, Pierre Martinon
// Inria
// 2011-2017

#include <StartingPoint.hpp>

/**
 *\fn StartingPoint::StartingPoint()
 * Default constructor.
 */
StartingPoint::StartingPoint(const int N_DISC,
                             const double* T_STEPS,
                             const double* T_STAGES,
                             const int DIM_Y,
                             const int DIM_U,
                             const int DIM_Z,
                             const int DIM_P,
                             const int N_STAGES,
                             const int N_TOTAL,
                             const int DIM_C,
                             const double* CONSTANTS,
                             const double T0,
                             const double TF,
                             const string FREE_TIME)
{
  // dimensions
  this->m_dimStep = N_DISC;
  this->m_dimState = DIM_Y;
  this->m_dimControl = DIM_U;
  this->m_dimAlgebraic = DIM_Z;
  this->m_dimParameter = DIM_P;
  this->m_dimConstant = DIM_C;
  this->m_dimStage = N_STAGES;
  this->m_dimStartingPoint = N_TOTAL;

  // flags for specific allocations (not done yet: false)
  this->m_flagAllocGen = false;
  this->m_flagAllocInterp = false;

  // general allocations and initialisations
  this->m_startingPoint = new double[this->m_dimStartingPoint];

  // constants (for call to dynamics)
  if (this->m_dimConstant > 0) {
    this->m_constant = new double[this->m_dimConstant];
    for (int i = 0; i < this->m_dimConstant; i++)
      this->m_constant[i] = CONSTANTS[i];
  }

  // discretization times
  this->m_timeSteps = new double[this->m_dimStep + 1];
  for (int i = 0; i < this->m_dimStep + 1; ++i)
    this->m_timeSteps[i] = T_STEPS[i];

  // stages
  this->m_timeStages = new double[this->m_dimStep * m_dimStage];
  for (int i = 0; i < this->m_dimStep * m_dimStage; ++i)
    this->m_timeStages[i] = T_STAGES[i];

  this->m_t0 = T0;
  this->m_tF = TF;
  this->m_freeTime = FREE_TIME;
}

/**
 *\fn StartingPoint::~StartingPoint()
 * Destructor.
 */
StartingPoint::~StartingPoint()
{
  // general deallocations
  delete[] this->m_startingPoint;
  delete[] this->m_timeSteps;
  delete[] this->m_timeStages;
  if (this->m_dimConstant > 0)
    delete[] this->m_constant;

  if (m_flagAllocGen)
    deallocateGenerationVars();

  if (m_flagAllocInterp)
    deallocateInterpolationVars();
}

/**
 *\fn int StartingPoint::allocateGenerationVars()
 * Allocation of space in memory for the arrays used to store the values for the generation variables.
 */
int StartingPoint::allocateGenerationVars()
{

  this->m_genState = new GenerationVariable[this->m_dimState];

  if (this->m_dimControl > 0)
    this->m_genControl = new GenerationVariable[this->m_dimControl];

  if (this->m_dimAlgebraic > 0)
    this->m_genAlgebraic = new GenerationVariable[this->m_dimAlgebraic];

  if (this->m_dimParameter > 0)
    this->m_parameter = new double[this->m_dimParameter];

  this->m_flagAllocGen = true;

  return 0;
}

/**
 *\fn void StartingPoint::deallocateGenerationVars()
 * Deallocation of space in memory for the arrays used to store the values for the generation variables.
 */
void StartingPoint::deallocateGenerationVars()
{

  // deallocate matrix m_state
  delete[] this->m_genState;

  // deallocate matrix m_control
  if (this->m_dimControl > 0)
    delete[] this->m_genControl;

  // deallocate matrix m_algebraic
  if (this->m_dimAlgebraic > 0)
    delete[] this->m_genAlgebraic;

  // deallocate vector m_parameter
  if (this->m_dimParameter > 0)
    delete[] this->m_parameter;
}

/**
 *\fn int StartingPoint::allocateInterpolationVars()
 * Allocation of space in memory for the arrays used to store the values for the interpolated variables.
 */
int StartingPoint::allocateInterpolationVars()
{
  int i = 0;

  this->m_state = new double*[this->m_dimState];
  for (i = 0; i < this->m_dimState; ++i)
    this->m_state[i] = new double[this->m_dimStep + 1];

  if (this->m_dimControl > 0)	{
    this->m_control = new double*[this->m_dimControl];
    for (i = 0; i < this->m_dimControl; ++i)
      this->m_control[i] = new double[this->m_dimStep * this->m_dimStage];
  }

  if (this->m_dimAlgebraic > 0) {
    this->m_algebraic = new double*[this->m_dimAlgebraic];
    for (i = 0; i < this->m_dimAlgebraic; ++i)
      this->m_algebraic[i] = new double[this->m_dimStep + 1];
  }

  this->m_flagAllocInterp = true;

  return 0;
}

/**
 *\fn void StartingPoint::deallocateInterpolationVars()
 * Deallocation of space in memory for the arrays storing the values of the variables evaluated at each discretization point of the problem.
 */
void StartingPoint::deallocateInterpolationVars()
{
  int i = 0;

  // deallocate matrix m_state :
  for (i = 0; i < this->m_dimState; ++i)
    delete[] this->m_state[i];
  delete[] this->m_state;

  // deallocate matrix m_control :
  if (this->m_dimControl > 0) {
    for (i = 0; i < this->m_dimControl; ++i)
      delete[] this->m_control[i];
    delete[] this->m_control;
  }

  // deallocate matrix m_algebraic :
  if (this->m_dimAlgebraic > 0) {
    for (i = 0; i < this->m_dimAlgebraic; ++i)
      delete[] this->m_algebraic[i];
    delete[] this->m_algebraic;
  }
}

/**
 *\fn int StartingPoint::interpolateVariables()
 * This function is called after reading the generation variables, it computes an interpolation of their values, in order to get
 * the values of the functions (y,u,z) at each discretization step of the current problem.
 * Therefore, we obtain a starting point for this problem with correct dimensions.
 */
int StartingPoint::interpolateVariables()
{
  int status = -1;
  int type_interp = 0; // type of interpolation chosen for each variable

  // First we allocate space in memory to store the values
  // of each variable after interpolation on each point of
  // the time discretization :
  allocateInterpolationVars();

  // Now we can compute the interpolation values and store
  // it in these arrays :
  int i;

  // 	string name_f = "view_interp_";
  for (i = 0; i < this->m_dimState; ++i) {
    BocopInterpolation* MyInterp = 0; // Interpolation class

    type_interp = m_genState[i].GetTypeInterp();
    switch (type_interp) {
    case 1:
      MyInterp = new BocopLinearInterpolation(m_genState[i]);
      break;
    case 2:
      MyInterp = new BocopSplinesInterpolation(m_genState[i]);
      break;
    default:
      cerr << " StartingPoint::interpolateVariables() : ERROR!" << endl;
      cerr << " Unknown interpolation type in GenerationVariable for the " << i << "-th state" << endl;
      return 1;
    }

    if (MyInterp == 0) {
      cerr << " StartingPoint::interpolateVariables() : ERROR!" << endl;
      cerr << " Interpolation failed for state variable #" << i << endl;
      return 2;
    }

    status = MyInterp->GetArrayInterp(this->m_dimStep + 1, this->m_timeSteps, this->m_state[i]);
    if (status != 0) {
      cerr << endl << " In StartingPoint::interpolateVariables() " << endl;
      cerr << " Unable to get the values back after interpolation for state variable #" << i << endl;
      return 3;
    }

    delete MyInterp;
  }

  for (i = 0; i < this->m_dimControl; ++i) {
    BocopInterpolation* MyInterp = 0; // Interpolation class

    type_interp = m_genControl[i].GetTypeInterp();
    switch (type_interp) {
    case 1:
      MyInterp = new BocopLinearInterpolation(m_genControl[i]);
      break;
    case 2:
      MyInterp = new BocopSplinesInterpolation(m_genControl[i]);
      break;
    default:
      cerr << " StartingPoint::interpolateVariables() : ERROR!" << endl;
      cerr << " Unknown interpolation type in GenerationVariable for the " << i << "-th control" << endl;
      return 1;
    }

    if (MyInterp == 0) {
      cerr << " StartingPoint::interpolateVariables() : ERROR!" << endl;
      cerr << " Interpolation failed for control variable #" << i << endl;
      return 2;
    }

    status = MyInterp->GetArrayInterp(this->m_dimStep * this->m_dimStage, this->m_timeStages, this->m_control[i]);
    if (status != 0) {
      cerr << endl << " In StartingPoint::interpolateVariables() " << endl;
      cerr << " Unable to get the values back after interpolation for control variable #" << i << endl;
      return 3;
    }

    delete MyInterp;
  }

  for (i = 0; i < this->m_dimAlgebraic; ++i) {
    BocopInterpolation* MyInterp = 0; // Interpolation class

    type_interp = m_genAlgebraic[i].GetTypeInterp();
    switch (type_interp) {
    case 1:
      MyInterp = new BocopLinearInterpolation(m_genAlgebraic[i]);
      break;
    case 2:
      MyInterp = new BocopSplinesInterpolation(m_genAlgebraic[i]);
      break;
    default:
      cerr << " StartingPoint::interpolateVariables() : ERROR!" << endl;
      cerr << " Unknown interpolation type in GenerationVariable for the " << i << "-th algebraic variable" << endl;
      return 1;
    }

    if (MyInterp == 0) {
      cerr << " StartingPoint::interpolateVariables() : ERROR!" << endl;
      cerr << " Interpolation failed for algebraic variable #" << i << endl;
      return 2;
    }


    status = MyInterp->GetArrayInterp(this->m_dimStep + 1, this->m_timeSteps, this->m_algebraic[i]);
    if (status != 0) {
      cerr << endl << " In StartingPoint::interpolateVariables() " << endl;
      cerr << " Unable to get the values back after interpolation for algebraic variable #" << i << endl;
      return 3;
    }

    delete MyInterp;
  }

  return 0;
}

/**
 *\fn int StartingPoint::generateStartingPoint()
 * This function generates a starting point using the values
 * for the variables that are stored in the variables arrays (y, u, z, p).
 */
int StartingPoint::generateStartingPoint()
{

  // layout of starting point
  // for each step n
  // - state y_n
  //   then for each stage j
  //   - control u_n^j
  //   - stage dynamics k_n^j
  //   - algebraic vars z_n (should use stage and be after u)+++

  int i = 0, j = 0, n = 0, ind = 0;
  double time, normalized_time;

  // allocations +++ use members same as computedynconstraints ?
  double* y_n = new double[m_dimState];
  double* u_nj = new double[m_dimControl];
  double* z_n = new double[m_dimAlgebraic];
  double* f_n = new double[m_dimState];

  // vectors for past states and controls (delay problems)
  // +++ a terme passer directement m_timeSteps, m_timeStages et les vecteurs control/state complets (doit y avoir une fonction qui extrait ca cf export)
  vector<double> past_steps(m_dimStep); // normalized
  vector<double> past_stages(m_dimStep*m_dimStage); // normalized
  vector<vector<double> > past_states(m_dimState,vector<double>(m_dimStep));
  vector<vector<double> > past_controls(m_dimControl,vector<double>(m_dimStep*m_dimStage));

  // loop over time steps
  for (n = 0; n < m_dimStep; n++)
  {

    // save step state for delay problems
    past_steps[n] = m_timeSteps[n];
    for (i = 0; i < this->m_dimState; i++)
    {
      y_n[i] = m_state[i][n];
      this->m_startingPoint[ind++] = y_n[i];
      past_states[i][n] = y_n[i];
    }

    // recover algebraic variables
    //+++ should be on stages like u; also put z right after u ! recheck main layout for X
    for (i = 0; i < this->m_dimAlgebraic; i++)	z_n[i] = m_algebraic[i][n];

    // loop over time stages
    for (j = 0; j < this->m_dimStage; j++)
    {
      // retrieve t at current stage
      normalized_time =  m_timeStages[n*m_dimStage+j];
      if (m_freeTime == "final")
        time = this->m_t0 + normalized_time * (this->m_parameter[m_dimParameter - 1] - this->m_t0);
      else
        time = this->m_t0 + normalized_time * (this->m_tF - this->m_t0);
      past_stages[n*m_dimStage+j] = normalized_time;

      // recover and save u_n^j at current stage j of step n
      for (i = 0; i < this->m_dimControl; i++)
      {
        u_nj[i] = m_control[i][n * m_dimStage + j];
        this->m_startingPoint[ind++] = u_nj[i];
        past_controls[i][n * m_dimStage + j] = u_nj[i];
      }

      // initialize k_n^j with f(t,y_n,u_n^j,z_n)
      dynamics(time, normalized_time, this->m_t0, this->m_tF, this->m_t0, this->m_tF, m_dimState, y_n, m_dimControl, u_nj,
               m_dimAlgebraic, z_n, m_dimParameter, this->m_parameter, m_dimConstant, this->m_constant,
               n, past_steps, past_states, n*m_dimStage+j, past_stages, past_controls,
               f_n);

      for (i = 0; i < this->m_dimState; i++)
        this->m_startingPoint[ind++] = f_n[i];  //does not seem much better than constant suc as 0.5 :P +++recheck this

      // save algebraic vars
      //+++ should be on stages like u; also put z right after u ! recheck main layout for X
      for (i = 0; i < this->m_dimAlgebraic; i++)
        this->m_startingPoint[ind++] = z_n[i];
    }
  }

  // Last time step: no u and k, only write y and z:
  for (i = 0; i < this->m_dimState; i++)
    this->m_startingPoint[ind++] = this->m_state[i][m_dimStep];

  // Finally, at the end of the vector, we initialize p :
  for (i = 0; i < this->m_dimParameter; i++)
    this->m_startingPoint[ind++] = this->m_parameter[i];

  // deallocations  (NB. cannot use a single delete -_-)
  delete[] y_n;
  delete[] u_nj;
  delete[] z_n;
  delete[] f_n;

  return 0;
}


/**
 *\fn void StartingPoint::writeStartingPointFile(string name_f_init)
 * This function writes the starting point in a file that has the same format
 * as problem.sol. However, this function is to be used right after using
 * function Problem::fill_X to fill the main vector, so at this point, the
 * constraints, bounds and objective function value are still unknown. We don't
 * want them to be written in the file, so we set each and every of them to zero.
 * User can then use the "Visualization" part of the GUI to load this file
 * as if it was a solution, to check if the starting point he chose is correct.
 * This function is mainly used for checking that starting point was correctly
 * defined.
 */
void StartingPoint::writeStartingPointFile(string name_f_init)
{
  int dimProblem = this->m_dimState + this->m_dimStage * (this->m_dimControl + this->m_dimState + this->m_dimAlgebraic);

  // Open the file where we want to write the results
  ofstream file_out(name_f_init.c_str(), ios::out);

  if (file_out)  { // if the opening succeeded
    int indice_y, indice_u, indice_z, indice_p;
    int i, l;

    file_out << "# **************************** " << endl;
    file_out << "# **************************** " << endl;
    file_out << "# *****    DEFINITION    ***** " << endl;
    file_out << "# **************************** " << endl;
    file_out << "# **************************** " << endl;
    file_out << "# # #" << endl;

    // ***** Definition files *****
    // We write all the definition files at the beginning, in order to be able
    // to retrieve all the parameters leading to the solution contained in the file :
    vector<string> name_file;
    int nb_files = 3 + this->m_dimState + this->m_dimControl + this->m_dimAlgebraic;
    if (this->m_dimParameter != 0)
      nb_files++;
    name_file.reserve(nb_files);

    name_file.push_back("problem.def");
    name_file.push_back("problem.bounds");
    name_file.push_back("problem.constants");

    string name = "";
    string i_str;
    for (i = 0; i < this->m_dimState; ++i) {
      stringstream sstr;
      sstr.setf(ios::scientific);
      sstr << i;
      i_str = sstr.str();
      name = "init/state." + i_str + ".init";
      name_file.push_back(name);
    }

    for (i = 0; i < this->m_dimControl; ++i) {
      stringstream sstr;
      sstr.setf(ios::scientific);
      sstr << i;
      i_str = sstr.str();
      name = "init/control." + i_str + ".init";
      name_file.push_back(name);
    }

    for (i = 0; i < this->m_dimAlgebraic; ++i) {
      stringstream sstr;
      sstr.setf(ios::scientific);
      sstr << i;
      i_str = sstr.str();
      name = "init/algebraic." + i_str + ".init";
      name_file.push_back(name);
    }

    if (this->m_dimParameter != 0)
      name_file.push_back("init/optimvars.init");

    // 		char line[256]; // dummy variable to read a line in definition file, and write it in problem.sol
    string line;
    for (i = 0; i < nb_files; i++) {
      ifstream file_in(name_file[i].c_str(), ios::in | ios::binary);

      if (!file_in) {
        cerr << endl << " ** StartingPoint::writeStartingPointFile : WARNING." << endl;
        cerr << "    Cannot open definition file (" << name_file[i] << ")." << endl;
        cerr << "    The output file might still be readable, but some" << endl;
        cerr << "    information about the problem definition will miss." << endl;
      } else {
        file_out << "# ********************** " << endl;
        file_out << "# ** " << name_file[i]  << endl;
        file_out << "# ********************** " << endl;
        file_out << "# # #" << endl;
        while (!file_in.eof()) {
          getline(file_in, line); // read a line from current definition file
          if (line == "")
            line = "# #";
          file_out << "# " << line << endl; // write it in problem.sol, with a comment symbol
        }
        file_in.close();
      }
    }
    // Then the number of stages of the discretization method :
    file_out << "# discretization.stages integer " << this->m_dimStage << endl;

    file_out << "# # #" << endl;
    file_out << "# # #" << endl;
    file_out << "# ****************************** " << endl;
    file_out << "# ****************************** " << endl;
    file_out << "# *****   INITIALIZATION   ***** " << endl;
    file_out << "# ****************************** " << endl;
    file_out << "# ****************************** " << endl;
    file_out << "# # #" << endl;
    // ***** Objective *****
    // First we write the value of the objective
    file_out << "# Objective value : " << endl;
    file_out << 0 << endl;
    file_out << "# L2-norm of the constraints : " << endl;
    file_out << 0 << endl;
    file_out << "# Inf-norm of the constraints : " << endl;
    file_out << 0 << endl;

    // Then the number of stages of the discretization method :
    file_out << "# Number of stages of discretization method : " << endl;
    file_out << this->m_dimStage << endl;

    file_out << endl;

    // First, we write the time vector containing each time step and stage
    int stepIndex = 0;
    for (stepIndex = 0; stepIndex < this->m_dimStep; stepIndex++) {
      // time at the nodes :
      file_out << this->m_timeSteps[stepIndex] << endl;

      // times at the stages of the discretization method :
      for (i = 0; i < this->m_dimStage; i++)
        file_out << 0 << endl;
    }

    // Last step of the discretization (final time point)
    file_out << this->m_timeSteps[this->m_dimStep] << endl;



    // ***** Result vector X *****
    file_out << endl;

    // First we write the values of y (on the nodes) :
    for (i = 0; i < this->m_dimState; i++) {
      // Index of the first element of the i-th state variable :
      indice_y = i;
      file_out << "# State variable " << i << " : " << endl;
      for (l = 0; l < this->m_dimStep + 1; l++) {
        file_out << this->m_startingPoint[indice_y] << endl;
        indice_y += dimProblem;
      }

      file_out << endl;
    }

    // Then the values of u (u is defined on every stage of the discretization
    // method, but we only write its values on the first stage) :
    for (i = 0; i < this->m_dimControl; i++) {
      // Index of the first element of the i-th control variable :
      indice_u = this->m_dimState + i;
      file_out << "# Control variable " << i << " : " << endl;
      for (l = 0; l < this->m_dimStep; l++) {
        for (int j = 0; j < m_dimStage; ++j)
          file_out << this->m_startingPoint[indice_u] << endl;

        indice_u += dimProblem;
      }

      file_out << endl;
    }

    // The values of z (as for u : first stage of the discretization method only) :
    for (i = 0; i < this->m_dimAlgebraic; i++) {
      // Index of the first element of the i-th algebraic variable :
      // (we have to skip the state, control, and k variables)
      indice_z = this->m_dimState + this->m_dimControl + this->m_dimState + i;
      file_out << "# Algebraic variable " << i << " : " << endl;
      for (l = 0; l < this->m_dimStep; l++) {
        for (int j = 0; j < m_dimStage; ++j)
          file_out << this->m_startingPoint[indice_z] << endl;

        indice_z += dimProblem;
      }

      file_out << endl;
    }


    // And finally, the optimization variables :
    indice_p = (this->m_dimStep * dimProblem) + this->m_dimState;
    file_out << "# Parameters : " << endl;
    for (i = 0; i < this->m_dimParameter; i++) {
      file_out << this->m_startingPoint[indice_p] << endl;
      indice_p++;
    }


  } else { // if the opening failed
    cerr << "StartingPoint::write_m_startingPoint --> Cannot open file " << name_f_init << ". Leaving..." << endl;
    exit(3);
  }

  file_out.close();
}

