// This code is published under the Eclipse Public License
// Authors: Vincent Grelard, Pierre Martinon, Daphne Giorgi
// Inria Saclay and CMAP Ecole Polytechnique
// 2011-2017


#include <BocopProblem.hpp>

using namespace Ipopt;

/**
 * \fn bool BocopProblem::get_nlp_info(Index& n, Index& m, Index& nnz_jac_g, Index& nnz_h_lag, IndexStyleEnum& index_style)
 *
 * Overloaded method from Ipopt to get the dimensions of the NLP problem (variables and constraints)
 */
bool BocopProblem::get_nlp_info(Index& n,
                                Index& m,
                                Index& nnz_jac_g,
                                Index& nnz_h_lag,
                                IndexStyleEnum& index_style)
{

  // Set number of variables and constraints (equality and inequality)
  n = this->m_dimX;
  m = this->m_dimConstraints;

  // Initialize automatic differentiation tools
#ifndef USE_CPPAD
  // AdolC
  generateTapes(n, m, nnz_jac_g, nnz_h_lag);
#else
  // CppAD
  generateOpSeq(n, m, nnz_jac_g, nnz_h_lag);
#endif

  // use the C style indexing (0-based)
  index_style = C_STYLE;

  return true;
}

/**
 * \fn BocopProblem::get_starting_point(Index n, bool init_x, Number* x, bool init_z, Number* z_L, Number* z_U, Index m, bool init_lambda, Number* lambda)
 *
 * \param n total number of variables
 * \param init_x flag, true if the initialization of x is needed
 * \param x array of variables to optimize
 * \param init_z flag, true if the initialization of the lower and upper bounds is needed
 * \param z_L multipliers for the lower bound of the x variables
 * \param z_U multipliers for the upper bound of the x variables
 * \param m total number of constraints
 * \param init_lambda flag, true if the initialization of the constraint multipliers is needed
 * \param lambda constraint multipliers
 *
 * This is an overloaded method from Ipopt. It needs from us to return a starting point for the solver.
 * We need to give a value for each variable at each point. To do so, we use class StartingPoint to read
 * the initialization files. Depending on the initialization type (from previous solution, or from dedicated
 * initialization file), we call different methods to generate the starting point. At the end, we copy the result
 * in array x used by Ipopt.
 */
bool BocopProblem::get_starting_point(Index n,
                                      bool init_x,
                                      Number* x,
                                      bool init_z,
                                      Number* z_L,
                                      Number* z_U,
                                      Index m,
                                      bool init_lambda,
                                      Number* lambda)
{
  // Filling the main vector of the discretized variables of the problem :
  StartingPoint* MyInit;
  if (m_bocopDefPtr->methodInitialization() == "from_sol_file_cold" || m_bocopDefPtr->methodInitialization() == "from_sol_file_warm") {
    if (m_bocopDefPtr->nameInitializationFile() != "no_file") {
      if (init_lambda != true) {
        MyInit = new StartFromPreviousSolution(m_bocopDefPtr->dimSteps(),
                                               m_bocopDefPtr->timeSteps(),
                                               m_bocopDefPtr->timeStages(),
                                               m_bocopDefPtr->dimState(),
                                               m_bocopDefPtr->dimControl(),
                                               m_bocopDefPtr->dimAlgebraic(),
                                               m_bocopDefPtr->dimOptimVars(),
                                               m_bocopDefPtr->dimInitFinalCond(),
                                               m_bocopDefPtr->dimPathConstraints(),
                                               m_bocopDefPtr->dimStages(),
                                               n,
                                               m_bocopDefPtr->dimConstants(),
                                               m_bocopDefPtr->constants(),
                                               m_bocopDefPtr->initialTime(),
                                               m_bocopDefPtr->finalTime(),
                                               m_bocopDefPtr->freeTime(),
                                               init_lambda);
      } else {
        MyInit = new StartFromPreviousSolution(m_bocopDefPtr->dimSteps(),
                                               m_bocopDefPtr->timeSteps(),
                                               m_bocopDefPtr->timeStages(),
                                               m_bocopDefPtr->dimState(),
                                               m_bocopDefPtr->dimControl(),
                                               m_bocopDefPtr->dimAlgebraic(),
                                               m_bocopDefPtr->dimOptimVars(),
                                               m_bocopDefPtr->dimInitFinalCond(),
                                               m_bocopDefPtr->dimPathConstraints(),
                                               m_bocopDefPtr->dimStages(),
                                               n,
                                               m_bocopDefPtr->dimConstants(),
                                               m_bocopDefPtr->constants(),
                                               m_bocopDefPtr->initialTime(),
                                               m_bocopDefPtr->finalTime(),
                                               m_bocopDefPtr->freeTime(),
                                               init_lambda,
                                               m_bocopDefPtr->discCoeffB()
                                               );
      }

      MyInit->setSolutionFile(m_bocopDefPtr->nameInitializationFile());
    } else {
      cout << " WARNING : Initialization file name (.sol) not defined or not found in problem.def" << endl;
      cout << "           BOCOP will now try the default initialization using init files." << endl << endl;

      MyInit = new StartFromInitFile(m_bocopDefPtr->dimSteps(),
                                     m_bocopDefPtr->timeSteps(),
                                     m_bocopDefPtr->timeStages(),
                                     m_bocopDefPtr->dimState(),
                                     m_bocopDefPtr->dimControl(),
                                     m_bocopDefPtr->dimAlgebraic(),
                                     m_bocopDefPtr->dimOptimVars(),
                                     m_bocopDefPtr->dimStages(),
                                     n,
                                     m_bocopDefPtr->dimConstants(),
                                     m_bocopDefPtr->constants(),
                                     m_bocopDefPtr->initialTime(),
                                     m_bocopDefPtr->finalTime(),
                                     m_bocopDefPtr->freeTime());
    }
  } else { // 0 or 1 (unknown or "from_init_file")

    if (m_bocopDefPtr->methodInitialization() != "from_init_file") { // unknown
      cout << " WARNING : Initialization type not defined or not found in problem.def" << endl;
      cout << "           BOCOP will now try the default initialization using init files." << endl << endl;
    }

    MyInit = new StartFromInitFile(m_bocopDefPtr->dimSteps(),
                                   m_bocopDefPtr->timeSteps(),
                                   m_bocopDefPtr->timeStages(),
                                   m_bocopDefPtr->dimState(),
                                   m_bocopDefPtr->dimControl(),
                                   m_bocopDefPtr->dimAlgebraic(),
                                   m_bocopDefPtr->dimOptimVars(),
                                   m_bocopDefPtr->dimStages(),
                                   n,
                                   m_bocopDefPtr->dimConstants(),
                                   m_bocopDefPtr->constants(),
                                   m_bocopDefPtr->initialTime(),
                                   m_bocopDefPtr->finalTime(),
                                   m_bocopDefPtr->freeTime());
  }

  // We can now set the starting point in StartingPoint :
  try {
    MyInit->setStartingPoint();
  } catch (int) {
    cerr << " <MyADOLC_NLP::get_starting_point> --> ERROR. " << endl;
    cerr << " Cannot set the starting point for the optimization... Leaving." << endl;
    exit(3);
  }

  // We initialize the private members of BocopProblem class corresponding to the generation variables
  // We use the copy constructors in order to keep these values after we delete the starting point
  // Since get_starting_point is called many times we delete the generation variables if previously declared

  if (m_genState != 0)
    delete[] m_genState;
  if (m_genControl != 0)
    delete[] m_genControl;
  if (m_genAlgebraic != 0)
    delete[] m_genAlgebraic;
  if (m_genParameter != 0)
    delete[] m_genParameter;

  m_genState = new GenerationVariable[m_bocopDefPtr->dimState()];
  for (int i = 0; i < m_bocopDefPtr->dimState(); i++)
    m_genState[i] = MyInit->getGenState()[i];

  if (m_bocopDefPtr->dimControl() > 0) {
    m_genControl = new GenerationVariable[m_bocopDefPtr->dimControl()];
    for (int i = 0; i < m_bocopDefPtr->dimControl(); i++)
      m_genControl[i] = MyInit->getGenControl()[i];
  }

  if (m_bocopDefPtr->dimAlgebraic() > 0) {
    m_genAlgebraic = new GenerationVariable[m_bocopDefPtr->dimAlgebraic()];
    for (int i = 0; i < m_bocopDefPtr->dimAlgebraic(); i++)
      m_genAlgebraic[i] = MyInit->getGenAlgebraic()[i];
  }

  if (m_bocopDefPtr->dimOptimVars() > 0) {
    m_genParameter = new double[m_bocopDefPtr->dimOptimVars()];
    for (int i = 0; i < m_bocopDefPtr->dimOptimVars(); i++)
      m_genParameter[i] = MyInit->getGenParameter()[i];
  }

  // copy the starting point for ipopt:
  for (Index i = 0; i < n; i++) {
    x[i] = MyInit->m_startingPoint[i];
  }

  if (init_lambda == true) {
    for (Index i = 0; i < m; i++)
      lambda[i] = MyInit->m_startingLambda[i];

    for (Index i = 0; i < n; i++) {
      z_L[i] = MyInit->m_startingZL[i];
      z_U[i] = MyInit->m_startingZU[i];
    }
  }

  delete MyInit;

  return true;
}


// Overloaded methods for objective, constraints, lagrangian and their derivatives

/**
 * \fn bool BocopProblem::eval_f(Index n, const Number* x, bool new_x, Number& obj_value)
 *
 * Overloaded method from Ipopt to evaluate the objective.
 * calls the template method evalObjective, also used by the AD tools with different types
 */
bool BocopProblem::eval_f(Index n, const Number* x, bool new_x, Number& obj_value)
{
  evalObjective(n, x, obj_value);
  return true;
}


/**
 * \fn bool BocopProblem::eval_g(Index n, const Number* x, bool new_x, Index m, Number* g)
 *
 * Overloaded method from Ipopt to evaluate the constraints. The computation is performed by
 * calls the template method evalConstraints method, also used by the AD tools with different types
 */
bool BocopProblem::eval_g(Index n, const Number* x, bool new_x, Index m, Number* g)
{
  bool ok = evalConstraints(n, x, m, g);
  return ok;
}


/**
 * \fn bool BocopProblem::eval_grad_f(Index n, const Number* x, bool new_x, Number* grad_f)
 *
 * Overloaded method from Ipopt to evaluate the gradient of the objective.
 * The computation is performed by ADOL-C  or CppAD. Gradient is not sparse.
 *
 */
bool BocopProblem::eval_grad_f(Index n, const Number* x, bool new_x, Number* grad_f)
{
#ifndef USE_CPPAD
  // AdolC
  gradient(tag_f, n, x, grad_f);
#else
  // CppAD
  for (int i = 0; i<n; i++)
    m_x2[i] = x[i];
  m_grad = f_obj.Jacobian(m_x2);
  std::copy(m_grad.begin(), m_grad.end(), grad_f);

#endif

  return true;
}



/**
 * \fn bool BocopProblem::eval_jac_g(Index n, const Number* x, bool new_x, Index m, Index nele_jac, Index* iRow, Index *jCol, Number* values)
 *
 * Overloaded method from Ipopt to evaluate the jacobian of the constraints.
 * Computation by Adolc or CppAD.
 */
bool BocopProblem::eval_jac_g(Index n, const Number* x, bool new_x,
                              Index m, Index nele_jac, Index* iRow, Index* jCol,
                              Number* values)
{

#ifndef USE_CPPAD

  if (values == NULL)
    // return the structure of the jacobian
    for(Index idx = 0; idx < m_nnz_jac; idx++)
    {
      iRow[idx] = m_rind_jac[idx];
      jCol[idx] = m_cind_jac[idx];
    }
  else
  {
    // return the values of the jacobian of the constraints
    // Adolc (use repeat=1 since sparsity pattern does not change)
    sparse_jac(tag_g, m, n, m_adolc_repeat, x, &m_nnz_jac, &m_rind_jac, &m_cind_jac, &m_val_jac, m_options_jac);
    //+++ why not use values directly in adolc call ??
    for(Index idx = 0; idx < m_nnz_jac; idx++)
      values[idx] = m_val_jac[idx];
  }

#else
  if (values == NULL)

    for(Index idx = 0; idx < nele_jac; idx++)
    {
      iRow[idx] = m_row_jac[idx];
      jCol[idx] = m_col_jac[idx];
    }
  else
  {
    // CppAD
    //use forward or reverse mode depending on dimensions
    for (int i = 0; i<n; i++)
      m_x2[i] = x[i];
    //CppAD::sparse_jacobian_work m_work_jac2;
    // m_work_jac.clear();
    if (n <= m)
      g_con.SparseJacobianForward(m_x2,m_pattern_jac,m_row_jac,m_col_jac,m_jac,m_work_jac);
    else
      g_con.SparseJacobianReverse(m_x2,m_pattern_jac,m_row_jac,m_col_jac,m_jac,m_work_jac);

    std::copy(m_jac.begin(),m_jac.end(),values);
  }
#endif

  return true;
}



/**
 * \fn bool BocopProblem::eval_h(Index n, const Number* x, bool new_x, Number obj_factor, Index m, const Number* lambda, bool new_lambda, Index nele_hess, Index* iRow, Index* jCol, Number* values)
 *
 * Overloaded method from Ipopt to evaluate the hessian of the lagrangian.
 * Computation is performed by Adolc or Cppad.
 */
bool BocopProblem::eval_h(Index n, const Number* x, bool new_x,
                          Number obj_factor, Index m, const Number* lambda,
                          bool new_lambda, Index nele_hess, Index* iRow,
                          Index* jCol, Number* values)
{


#ifndef USE_CPPAD
  if (values == NULL)

    // return the structure
    for(Index idx = 0; idx < m_nnz_hess; idx++)
    {
      iRow[idx] = m_rind_hess[idx];
      jCol[idx] = m_cind_hess[idx];
    }

  else
  {
    // return the values of the hessian


    // build input variables (x,lambda,objfactor)
    for(Index idx = 0; idx < n ; idx++)
      m_xlf[idx] = x[idx];
    for(Index idx = 0; idx < m ; idx++)
      m_xlf[n+idx] = lambda[idx];
    m_xlf[n+m] = obj_factor;

    // FULL HESSIAN VERSION
    // compute full Hessian wrt (x,lambda,objfactor) (in this case repeat = 1 is possible)
    sparse_hess(tag_L, n+m+1, m_adolc_repeat, m_xlf, &m_nnz_hess_total, &m_rind_hess_total, &m_cind_hess_total, &m_val_hess, m_options_hess);

    // retrieve part of the Hessian that depends on x only (ie the n x n upper left submatrix)
    Index idx = 0;
    for(Index idx_total = 0; idx_total < m_nnz_hess_total ; idx_total++)
      if((m_rind_hess_total[idx_total] < (unsigned int) n) && (m_cind_hess_total[idx_total] < (unsigned int) n))
        values[idx++] = m_val_hess[idx_total];
  }



#else

  if (values == NULL)

    // return the structure of the hessian
    for(Index idx = 0; idx < nele_hess; idx++)
    {
      iRow[idx] = m_row_hess[idx];
      jCol[idx] = m_col_hess[idx];
    }
  else
  {

    //CppAD
    // FULL HESSIAN VERSION
    // initialize
    int i;
    size_t n_sweep;
    vector<double> w(1);
    w[0] = 1e0;
    for (i = 0; i<n; i++)
      m_xlf2[i] = x[i];
    for (i = 0; i<m; i++)
      m_xlf2[n+i] = lambda[i];
    m_xlf2[n+m] = obj_factor;

    //check for reused structures (DEBUG)
    //m_work_hess.clear(); //rajoute un peu moins de 10% au temps cpu seulement: il doit quand meme refaire une partie des calculs sans le clear :(
    //cout << "In sparse hessian" << endl;
    //cout << "pattern " << m_pattern_hess.size() << " row " << m_row_hess.size() << " col " << m_col_hess.size() << " work " << m_work_hess.color.size() << endl;
    // CppAD::sparse_hessian_work m_work_hess2;
    // we pass the indices corresponding to the n x n upper submatrix only
    n_sweep = h_lag.SparseHessian(m_xlf2, w, m_pattern_hess, m_row_hess, m_col_hess, m_hess, m_work_hess);
    std::copy(m_hess.begin(),m_hess.end(),values);

  }
#endif


  // Output the iteration result if it is a multiple of iterationOutputFrequency
  // +++use intermediate_callback instead of this !!!
  if (m_currentIteration > 0 && m_bocopDefPtr->iterationOutputFrequency() > 0 && (m_currentIteration%m_bocopDefPtr->iterationOutputFrequency() == 0) )
  {
    // cout << "Solution output at iteration " << m_currentIteration << endl;
    writeIterSolution(m_currentIteration, m, x, lambda);
  }
  m_currentIteration++;

  return true;
}


/**
 * \fn void BocopProblem::finalize_solution(SolverReturn status, Index n, const Number* x, const Number* z_L, const Number* z_U, Index m, const Number* g, const Number* lambda, Number obj_value, const IpoptData* ip_data, IpoptCalculatedQuantities* ip_cq)
 *
 * Overloaded method from Ipopt executed at the end of the optimization.
 * Input arguments are the optimization variables and informations at the end of the optimization process.
 * We print them in Bocop solution file, using function writeSolution.
 */
void BocopProblem::finalize_solution(SolverReturn status,
                                     Index n,
                                     const Number* x,
                                     const Number* z_L,
                                     const Number* z_U,
                                     Index m,
                                     const Number* g,
                                     const Number* lambda,
                                     Number obj_value,
                                     const IpoptData* ip_data,
                                     IpoptCalculatedQuantities* ip_cq)
{

  printf("\n\nObjective value: %e\n", obj_value);
  // We prepare the arrays to pass to the post-processing
  // First we extract the informations from bocopDefPtr
  // +++ put this block as aux function called in writeSolution and writeIterSolution
  int dimStep = m_bocopDefPtr->dimSteps();
  int dimStage = m_bocopDefPtr->dimStages();
  int dimConstant = m_bocopDefPtr->dimConstants();
  int dimState = m_bocopDefPtr->dimState();
  int dimControl = m_bocopDefPtr->dimControl();
  int dimAlgebraic = m_bocopDefPtr->dimAlgebraic();
  int dimParameter = m_bocopDefPtr->dimOptimVars();
  int dimBoudCondMult = m_bocopDefPtr->dimInitFinalCond();
  int dimPathConstrMult = m_bocopDefPtr->dimPathConstraints();

  /* +++ already done for steps and stages ? */
  double* timeSteps = new double[m_bocopDefPtr->dimSteps() + 1];
  for (int i = 0; i < dimStep + 1; i++)
    timeSteps[i] = m_bocopDefPtr->timeSteps()[i];
  double* timeStages = new double[dimStep * dimStage];
  for (int i = 0; i < dimStep * dimStage; i++)
    timeStages[i] = m_bocopDefPtr->timeStages()[i];

  // The constants array can be copied from bocopDefPtr:
  double* constant = new double[m_bocopDefPtr->dimConstants()];
  for (int i = 0; i < m_bocopDefPtr->dimConstants(); i++)
    constant[i] = m_bocopDefPtr->constants()[i];

  // The solution arrays (state, control, algebraic and parameter values and multipliers)
  // are filled while writing the solution file
  double** state = new double*[m_bocopDefPtr->dimState()];
  for (int i = 0; i < m_bocopDefPtr->dimState(); i++)
    state[i] = new double[dimStep + 1];

  double** control = new double*[m_bocopDefPtr->dimControl()];
  for (int i = 0; i < m_bocopDefPtr->dimControl(); i++)
    control[i] = new double[dimStep * dimStage];

  double** algebraic = new double*[m_bocopDefPtr->dimAlgebraic()];
  for (int i = 0; i < m_bocopDefPtr->dimAlgebraic(); i++)
    algebraic[i] = new double[dimStep * dimStage];

  double* parameter = new double[m_bocopDefPtr->dimOptimVars()];

  double* boundaryCondMultiplier = new double[m_bocopDefPtr->dimInitFinalCond()];

  double** pathConstrMultiplier = new double*[m_bocopDefPtr->dimPathConstraints()];
  for (int i = 0; i < m_bocopDefPtr->dimPathConstraints(); i++)
    pathConstrMultiplier[i] = new double[dimStep * dimStage];

  double** adjointState = new double*[m_bocopDefPtr->dimState()];
  for (int i = 0; i < m_bocopDefPtr->dimState(); i++)
    adjointState[i] = new double[dimStep];


  // Then, we write the results in .sol file and at the meantime we fill the arrays for post-processing
  this->writeSolution(n,
                      x,
                      z_L,
                      z_U,
                      m,
                      g,
                      obj_value,
                      lambda,
                      ip_data,
                      ip_cq,
                      state,
                      control,
                      algebraic,
                      parameter,    // si tf libre, j'enleve le dernier element?
                      boundaryCondMultiplier,
                      pathConstrMultiplier,
                      adjointState);

  // We extract the informations about initial and final time
  // We have to do it after the call to writeSolution, in the case we have
  // a final time free
  double t0 = m_bocopDefPtr->initialTime();
  double tF;
  if (m_bocopDefPtr->isFinalTimeFree())
    tF = parameter[m_bocopDefPtr->dimOptimVars() - 1];
  else
    tF = m_bocopDefPtr->finalTime();


  // Call to post-process coded by the user
  postProcessing(dimStep,
                 dimStage,
                 dimConstant,
                 dimState,
                 dimControl,
                 dimAlgebraic,
                 dimParameter,
                 dimBoudCondMult,
                 dimPathConstrMult,
                 timeSteps,
                 timeStages,
                 t0,
                 tF,
                 constant,
                 state,
                 control,
                 algebraic,
                 parameter,
                 boundaryCondMultiplier,
                 pathConstrMultiplier,
                 adjointState);

  // memory deallocation
  delete[] timeSteps;
  delete[] timeStages;
  delete[] constant;

  for (int i = 0; i < m_bocopDefPtr->dimState(); i++)
    delete[] state[i];
  delete[] state;

  for (int i = 0; i < m_bocopDefPtr->dimControl(); i++)
    delete[] control[i];
  delete[] control;

  for (int i = 0; i < m_bocopDefPtr->dimAlgebraic(); i++)
    delete[] algebraic[i];
  delete[] algebraic;

  delete[] parameter;
  delete[] boundaryCondMultiplier;

  for (int i = 0; i < m_bocopDefPtr->dimPathConstraints(); i++)
    delete[] pathConstrMultiplier[i];
  delete[] pathConstrMultiplier;

  for (int i = 0; i < m_bocopDefPtr->dimState(); i++)
    delete[] adjointState[i];
  delete[] adjointState;

}
