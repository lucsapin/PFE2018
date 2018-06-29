// This code is published under the Eclipse Public License
// Authors: Daphne Giorgi, Vincent Grelard, Pierre Martinon
// Inria Saclay and Cmap Ecole Polytechnique
// 2011-2017

#include <BocopProblem.hpp>


/**
 * \fn BocopProblem::BocopProblem()
 * This constructor reads all default definition files (problem.def, problem.bounds,
 * problem.constants, problem.times). If you wish to specify the names of these files,
 * you need to create a new instance of BocopDefinition and then use
 * BocopProblem::BocopProblem(const BocopDefinition &def).
 */
BocopProblem::BocopProblem()
{
    // Definition of the problem :
    int status;

    m_genState = 0;
    m_genControl = 0;
    m_genAlgebraic = 0;
    m_genParameter = 0;

    BocopDefinition def("problem.def", "problem.bounds", "problem.constants");
    status = def.readAll();

    if (status != 0) {
        cerr << def.errorString() << endl;
        return;
    }

    if (def.isWarning())
        cout << def.warningString() << endl;

    this->m_dimProblem = m_bocopDefPtr->dimState() + m_bocopDefPtr->dimStages() * (m_bocopDefPtr->dimControl() + m_bocopDefPtr->dimState() + m_bocopDefPtr->dimAlgebraic());
    this->m_dimX = (m_bocopDefPtr->dimSteps() * this->m_dimProblem) + m_bocopDefPtr->dimState() + m_bocopDefPtr->dimOptimVars();
    this->m_dimConstraints =  m_bocopDefPtr->dimInitFinalCond() + m_bocopDefPtr->dimSteps() * (m_bocopDefPtr->dimState() + m_bocopDefPtr->dimStages() * (m_bocopDefPtr->dimPathConstraints() + m_bocopDefPtr->dimState()));

    m_currentIteration = 0;

#ifndef USE_CPPAD
    // Adolc-C
    m_xlf = NULL;  // input variables (x,lambda,objfactor)

    // jacobian of constraints (row indices, column indices, values, non zero elements)
    m_rind_jac = NULL;
    m_cind_jac = NULL;
    m_val_jac = NULL;
    m_nnz_jac = 0;

    // hessian of Lagrangian (full wrt (x,lambda,objfactor) or only wrt variables x)
    m_rind_hess = NULL;
    m_cind_hess = NULL;
    m_rind_hess_total = NULL;
    m_cind_hess_total = NULL;
    m_val_hess = NULL;
    m_nnz_hess = 0;
    m_nnz_hess_total = 0;
#endif

}


/**
 * \fn BocopProblem::BocopProblem(const BocopDefinition &def)
 * \param def Definition of the problem, stores definition, bounds, constants, and times
 *
 * After creating an instance of BocopDefinition, and running SetXxx functions to read
 * and store the properties of the problem, this constructor can be called to create the
 * associated instance of BocopProblem. It stores the exact same data as in BocopDefinition
 * and contains methods to formulate the NLP, and to solve it.
 */
BocopProblem::BocopProblem(const bocopDefPtr def)
{
    m_bocopDefPtr = def;

    m_genState = 0;
    m_genControl = 0;
    m_genAlgebraic = 0;
    m_genParameter = 0;

    this->m_dimProblem = m_bocopDefPtr->dimState() + m_bocopDefPtr->dimStages() * (m_bocopDefPtr->dimControl() + m_bocopDefPtr->dimState() + m_bocopDefPtr->dimAlgebraic());
    this->m_dimX = (m_bocopDefPtr->dimSteps() * this->m_dimProblem) + m_bocopDefPtr->dimState() + m_bocopDefPtr->dimOptimVars();
    this->m_dimConstraints =  m_bocopDefPtr->dimInitFinalCond() + m_bocopDefPtr->dimSteps() * (m_bocopDefPtr->dimState() + m_bocopDefPtr->dimStages() * (m_bocopDefPtr->dimPathConstraints() + m_bocopDefPtr->dimState()));

    m_currentIteration = 0;

#ifndef USE_CPPAD
    // Adolc-C
    m_xlf = NULL;  // input variables (x,lambda,objfactor)

    // jacobian of constraints (row indices, column indices, values, non zero elements)
    m_rind_jac = NULL;
    m_cind_jac = NULL;
    m_val_jac = NULL;
    m_nnz_jac = 0;

    // hessian of Lagrangian (full wrt (x,lambda,objfactor) or only wrt variables x)
    m_rind_hess = NULL;
    m_cind_hess = NULL;
    m_rind_hess_total = NULL;
    m_cind_hess_total = NULL;
    m_val_hess = NULL;
    m_nnz_hess = 0;
    m_nnz_hess_total = 0;
#endif

}


BocopProblem::~BocopProblem()
{
    // The smart pointer m_bocopDefPtr is automatically deleted

    // memory deallocation of generation variables
    // these variables were allocated with new
    if (m_genState != 0)
        delete[] m_genState;

    if (m_genControl != 0)
        delete[] m_genControl;

    if (m_genAlgebraic != 0)
        delete[] m_genAlgebraic;

    if (m_genParameter != 0)
        delete[] m_genParameter;

#ifndef USE_CPPAD
    // memory deallocation of ADOL-C variables
    if (m_xlf != NULL)
        delete[] m_xlf;
    if (m_rind_jac != NULL)
        free(m_rind_jac);
    if (m_cind_jac != NULL)
        free(m_cind_jac);
    if (m_val_jac != NULL)
        free(m_val_jac);
    if (m_rind_hess != NULL)
        delete[] m_rind_hess;
    if (m_cind_hess != NULL)
        delete[] m_cind_hess;
    if (m_rind_hess_total != NULL)
        free(m_rind_hess_total);
    if (m_cind_hess_total != NULL)
        free(m_cind_hess_total);
    if (m_val_hess != NULL)
        free(m_val_hess);
#endif

}

