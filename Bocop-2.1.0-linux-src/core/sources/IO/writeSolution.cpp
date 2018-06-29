// This code is published under the Eclipse Public License
// Authors: Vincent Grelard, Pierre Martinon, Daphne Giorgi, Olivier Tissot
// Inria Saclay and Cmap Ecole Polytechnique
// 2011-2017

#include <BocopProblem.hpp>
using namespace Ipopt;


// ************************************
// ***** Functions WRITE SOLUTION *****
// ************************************
void BocopProblem::extractDataBlock1D(const Number* x, int begin, int stride, int dim, double* datablock)
{
    // Extract data block (1D) from x to datablock
    for (int i = 0; i < dim; i++)
        datablock[i] = x[begin + i * stride];
}

void BocopProblem::writeDataBlock1D(ofstream& file_out, string header, int dim, double* datablock)
{
    // Write data block (1D) to output file
    file_out << header << endl;
    for (int i = 0; i < dim; i++)
        file_out << datablock[i] << endl;
    file_out << endl;
}

void BocopProblem::writeDataBlock2D(ofstream& file_out, string header, int dim1, int dim2, double** datablock)
{
    // Write data block (2D) to output file
    for (int i = 0; i < dim1; i++) {
        file_out << header << " " << i << endl;
        for (int j = 0; j < dim2; j++) {
            file_out << datablock[i][j] << endl;
        }
        file_out << endl;
    }
}

// extract variables of (OCP) from unknown X of (NLP)
// X= { [y (u k z) ... (u k z)] ... [y (u k z) ... (u k z)] yf pi}
void BocopProblem::extractVariables(const Number* x, double **state, double **control, double **kstage, double **algvars, double *parameter)
{
    int index_x = 0, index_u = 0, index_k = 0, index_z = 0;

    // loop on time steps: block [ y (u k z) ... (u k z) ]
    for (int i = 0; i < m_bocopDefPtr->dimSteps(); i++) {

        // state: y
        for (int j = 0; j < m_bocopDefPtr->dimState(); j++)
            state[j][i] = x[index_x++];

        // loop on time stages: block (u k z)
        for (int l = 0; l < m_bocopDefPtr->dimStages(); l++) {

            // control u
            for (int j = 0; j < m_bocopDefPtr->dimControl(); j++)
                control[j][index_u] = x[index_x++];
            index_u++;

            // stage k
            for (int j = 0; j < m_bocopDefPtr->dimState(); j++)
                index_x++; //kstage[j][index_k] = x[index_x++];
            index_k++;

            // algebraic vars z
            for (int j = 0; j < m_bocopDefPtr->dimAlgebraic(); j++)
                algvars[j][index_z] = x[index_x++];
            index_z++;
        }
    }

    // final step: yf
    for (int j = 0; j < m_bocopDefPtr->dimState(); j++)
        state[j][m_bocopDefPtr->dimSteps()] = x[index_x++];

    // parameters: pi
    for (int j = 0; j < m_bocopDefPtr->dimOptimVars(); j++)
        parameter[j] = x[index_x++];

}


// extract multipliers for the constraints C(X) of (NLP)
// C= {boundarycond [dynstep (dynstage) (pathcond)] ... [dynstep (dynstage) (pathcond)]}
// where boundarycond is the constraint: lb <= \phi(y^0,Y^N) <= ub
// dynstep is the dynamics equation: y^{i+1} - ( y^i + sum_{i=1..s} b_j k_j ) = 0
// dynstage are the s equations: k^i_j - f(t_i + c_i h, y^i + sum_{i=1..s} a_lj k_l, u^i_j) = 0     //check indexes for a +++
// and pathcond are the s constraints: LB <= g(t_i + c_i h, y^i + sum_{i=1..s} a_lj k_l, u^i_j) <= UB
//void BocopProblem::extractMultipliers(const Number* lambda, )
//{

//}



//+++ mettre plutot les steps suivis des stages en utilisant block 1D
void BocopProblem::writeDiscretizedTimes(ofstream& file_out)
{
    // The number of stages of the discretization method :
    file_out << "# Number of stages of discretization method : " << endl;
    file_out << m_bocopDefPtr->dimStages() << endl;

    file_out << endl;

    // We write the time vector containing each time step and stage
    int i, stepIndex = 0, stageIndex = 0;
    for (stepIndex = 0; stepIndex < m_bocopDefPtr->dimSteps(); stepIndex++) {
        // time at the nodes :
        file_out << m_bocopDefPtr->timeSteps()[stepIndex] << endl;

        // times at the stages of the discretization method :
        for (i = 0; i < m_bocopDefPtr->dimStages(); i++) {
            file_out << m_bocopDefPtr->timeStages()[stageIndex] << endl;
            ++stageIndex;
        }
    }

    // Last step of the discretization (final time point)
    file_out << m_bocopDefPtr->timeSteps()[m_bocopDefPtr->dimSteps()] << endl;
}

/**
 * \fn void BocopProblem::writeDiscretizedVariables(ofstream& file_out,
 *                                                  const Number* x,
 *                                                  bool is_postprocessing,
 *                                                  double** state,
 *                                                  double** control,
 *                                                  double** algebraic,
 *                                                  double* parameter)
 *
 * This function writes the discretized variables from the unknown X, in the .sol file
 * If we want to export individual files for the variables, also extract the vectors
 *
 *
 */
void BocopProblem::writeDiscretizedVariables(ofstream& file_out,
                                             const Number* x,
                                             bool is_postprocessing,
                                             double** state,
                                             double** control,
                                             double** algebraic,
                                             double* parameter)
{

    // extract all variables from NLP unknown X
    double **kstage = NULL; //+++ ajouter l'alloc avec les autres
    extractVariables(x, state, control, kstage, algebraic, parameter);
    string header;

    // state
    header = "# State";
    writeDataBlock2D(file_out, header, m_bocopDefPtr->dimState(), m_bocopDefPtr->dimSteps()+1, state);

    // control
    header = "# Control";
    writeDataBlock2D(file_out, header, m_bocopDefPtr->dimControl(), m_bocopDefPtr->dimSteps()*m_bocopDefPtr->dimStages(), control);

    // algebraic
    header = "# Algebraic";
    writeDataBlock2D(file_out, header, m_bocopDefPtr->dimAlgebraic(), m_bocopDefPtr->dimSteps()*m_bocopDefPtr->dimStages(), algebraic);

    // parameters
    header = "# Parameters";
    writeDataBlock1D(file_out, header, m_bocopDefPtr->dimOptimVars(), parameter);

}

/**
 * \fn void BocopProblem::writeDiscretizedMultipliers(ofstream& file_out,
 *                                              Index m,
 *                                              const Number* lambda,
 *                                              bool is_postprocessing,
 *                                              double* boundaryCondMultiplier,
 *                                              double** pathConstrMultiplier,
 *                                              double** adjointState)
 *
 * This function writes the multipliers lambda at the end of the optimization.
 *
 */
void BocopProblem::writeDiscretizedMultipliers(ofstream& file_out,
                                               Index m,
                                               const Number* lambda,
                                               bool is_postprocessing,
                                               double* boundaryCondMultiplier,
                                               double** pathConstrMultiplier,
                                               double** adjointState)
{
    int i, j, l, indice;
    // We write the multipliers :
    // First we write the number of constraint multipliers, which is also the
    // dimension of the constraints :
    file_out << "# Dimension of the constraints multipliers : " << endl;
    file_out << (int) m << endl << endl;
    file_out << "# Constraint Multipliers : " << endl;

    file_out << endl;
    // Boundary conditions :
    file_out << "# Multipliers associated to the boundary conditions : " << endl;

    // First the boundary conditions' multipliers (at the beginning of lambda) :
    for (i = 0; i < this->m_bocopDefPtr->dimInitFinalCond(); i++) {
        file_out << lambda[i] << endl;
        if (is_postprocessing == true)
            boundaryCondMultiplier[i] = lambda[i];
    }

    file_out << endl;


    // Then we write the multipliers of the constraints on each time step :
    int ind_start = this->m_bocopDefPtr->dimInitFinalCond();
    // number of constraints at each time step :
    int dimConstr = m_bocopDefPtr->dimStages() * (m_bocopDefPtr->dimPathConstraints() + m_bocopDefPtr->dimState()) + m_bocopDefPtr->dimState();


    // 1) Path constraints' multipliers :
    for (j = 0; j < m_bocopDefPtr->dimPathConstraints(); j++) { // Loop over each constraint
        file_out << "# Path constraint " << j << " multipliers : " << endl;

        // index of the first element of the current path constraint l :
        indice = ind_start + j;

        // At each time step :
        for (l = 0; l < m_bocopDefPtr->dimSteps(); l++) {
            // At each stage of the discretization method :
            for (i = 0; i < m_bocopDefPtr->dimStages(); i++) {
                file_out << lambda[indice] << endl;
                if (is_postprocessing == true)
                    pathConstrMultiplier[j][i + l * m_bocopDefPtr->dimStages()] = lambda[indice];
                indice += m_bocopDefPtr->dimPathConstraints();
            }

            // we skip the dynamics at this step,
            // we get to the path constraints' multiplier at the next step :
            indice += m_bocopDefPtr->dimState() + m_bocopDefPtr->dimStages() * m_bocopDefPtr->dimState();
        }

        file_out << endl;
    }

    // 2) Dynamics' multipliers I (y(t_l+1) - y(t_l) - h*sum(b_i*k_i) = 0)
    ind_start = this->m_bocopDefPtr->dimInitFinalCond() + m_bocopDefPtr->dimStages() * m_bocopDefPtr->dimPathConstraints();
    for (j = 0; j < m_bocopDefPtr->dimState(); j++) { // Loop over each (y_dot-f) of the dynamics
        file_out << "# Dynamic constraint " << j << " (y_dot - f = 0) multipliers : " << endl;
        indice = ind_start + j;

        for (l = 0; l < m_bocopDefPtr->dimSteps(); l++) { // we write a given (y_dot-f) associated multiplier for each time step
            file_out << lambda[indice] << endl;
            if (is_postprocessing == true)
                adjointState[j][l] = lambda[indice];

            // we get to y[j] for the next time step :
            indice += dimConstr;
            //note : we skipped the multipliers associated to the constraints k_i-f(...) = 0
        }
        file_out << endl;
    }
}


/**
 * \fn void BocopProblem::writeSolution(Index n, const Number* x,  Index m, const Number* g, Number obj_value, const Number* lambda, const IpoptData* ip_data, IpoptCalculatedQuantities* ip_cq)
 *
 * This function writes :
 * - all definition informations used to get this solution file (commented lines)
 * - value of the objective, constraint violation, and number of steps of the discretization method
 * - discretized variables vector x at the end of the optimization
 * - discretized constraint vector C, preceded by one line for its bounds (lower, upper and type)
 *
 * Note that at this level we don't have access to the Ipopt informations about statistics (iteration and CPU time)
 */
void BocopProblem::writeSolution(Index n,
                                 const Number* x,
                                 const Number* z_L,
                                 const Number* z_U,
                                 Index m,
                                 const Number* g,
                                 Number obj_value,
                                 const Number* lambda,
                                 const IpoptData* ip_data,
                                 IpoptCalculatedQuantities* ip_cq,
                                 double** state,
                                 double** control,
                                 double** algebraic,
                                 double* parameter,		// si tf libre, j'enleve le dernier element?
                                 double* boundaryCondMultiplier,
                                 double** pathConstrMultiplier,
                                 double** adjointState)
{
    if (m_bocopDefPtr->nameSolutionFile() == "")
        m_bocopDefPtr->setSolutionFile("problem.sol");

    string solFile = m_bocopDefPtr->nameSolutionFile();

    // If problem.sol already exists we rename it problem.sol.backup
    bool exists;
    ifstream file_check(solFile.c_str());
    // fail() checks if the file is readable (the .sol file is always readable unless it does not exist)
    exists = !file_check.fail();
    // We close it before writing
    file_check.close();
    if (exists) {
        string newName = solFile + ".backup";
        rename(solFile.c_str(),newName.c_str());
    }

    // Open the file where we want to write the results
    ofstream file_out(solFile.c_str(), ios::out | ios::binary);

    file_out.precision(15);

    if (!file_out)  { // if the opening succeeded
        cerr << endl << " BocopProblem::writeSolution() : ERROR! " << endl;
        cerr << " Cannot open solution file (" << solFile << ") to write the optimization results." << endl << endl;
        exit(1);
    }

    int indice_y, indice_u, indice_z, indice_p;
    int i, j, l;

    // First we write the definition, using the values used to initialise the problem
    // and stored in the members of BocopDefinition and BocopProblem
    writeDefinition(file_out);

    // Solution data:
    // objective
    // constraint violation
    // time
    // state
    // control
    // constraints (boundary, path, dynamics)
    // multipliers
    // RK scheme coefficients
    // bound multipliers

    file_out << "# # #" << endl;
    file_out << "# # #" << endl;
    file_out << "# **************************** " << endl;
    file_out << "# **************************** " << endl;
    file_out << "# *****     SOLUTION     ***** " << endl;
    file_out << "# **************************** " << endl;
    file_out << "# **************************** " << endl;
    file_out << "# # #" << endl;

    // ***** Objective *****
    file_out << "# Objective value : " << endl;
    file_out << obj_value << endl;

    // ***** Constraint violation *****
    double constr_viol_norminf = ip_cq->unscaled_curr_nlp_constraint_violation(NORM_MAX);
    double constr_viol_norm2 = ip_cq->unscaled_curr_nlp_constraint_violation(NORM_2);
    file_out << "# L2-norm of the constraints : " << endl;
    file_out << (double)constr_viol_norm2 << endl;
    file_out << "# Inf-norm of the constraints : " << endl;
    file_out << (double)constr_viol_norminf << endl;

    // ***** Discretized times *****
    writeDiscretizedTimes(file_out);

    // ***** Result vector x *****
    file_out << endl;
    writeDiscretizedVariables(file_out, x, true, state, control, algebraic, parameter);

    // ***** Constraints ***** +++ make aux fonction !
    // Boundary conditions :
    file_out << "# Boundary conditions : " << endl;

    int type;

    double lower, upper;
    string typeBound;

    // First the boundary conditions (at the beginning of "constraints_vector") :
    for (i = 0; i < m_bocopDefPtr->dimInitFinalCond(); i++) {
        m_bocopDefPtr->lowerBoundInitFinalCond(i, lower);
        m_bocopDefPtr->upperBoundInitFinalCond(i, upper);
        m_bocopDefPtr->typeBoundInitFinalCond(i, typeBound);
        file_out << lower << " " << g[i] << " " << upper;
        if (typeBound == "free" || typeBound == "0")
            type = 0;
        else if (typeBound == "lower" || typeBound == "1")
            type = 1;
        else if (typeBound == "upper" || typeBound == "2")
            type = 2;
        else if (typeBound == "both" || typeBound == "3")
            type = 3;
        else if (typeBound == "equal" || typeBound == "4")
            type = 4;
        else
            type = 666;

        file_out << " " << type << endl;
    }

    file_out << endl;

    // Then we write the constraints on each time step :
    int indice;
    int ind_start = this->m_bocopDefPtr->dimInitFinalCond();
    // number of constraints at each time step :
    int dimConstr = m_bocopDefPtr->dimStages() * (m_bocopDefPtr->dimPathConstraints() + m_bocopDefPtr->dimState()) + m_bocopDefPtr->dimState();

    // 1) Path constraints :
    for (j = 0; j < m_bocopDefPtr->dimPathConstraints(); j++) { // Loop over each constraint
        file_out << "# Path constraint " << j << " : " << endl;

        m_bocopDefPtr->lowerBoundPathConstraint(j, lower);
        m_bocopDefPtr->upperBoundPathConstraint(j, upper);
        m_bocopDefPtr->typeBoundPathConstraint(j, typeBound);

        file_out << lower << " " << upper;

        if (typeBound == "free" || typeBound == "0")
            type = 0;
        else if (typeBound == "lower" || typeBound == "1")
            type = 1;
        else if (typeBound == "upper" || typeBound == "2")
            type = 2;
        else if (typeBound == "both" || typeBound == "3")
            type = 3;
        else if (typeBound == "equal" || typeBound == "4")
            type = 4;
        else
            type = 666;

        file_out << " " << type << endl;


        // index of the first element of the current path constraint l :
        indice = ind_start + j;

        // At each time step :
        for (l = 0; l < m_bocopDefPtr->dimSteps(); l++) {
            // At each stage of the discretization method :
            for (i = 0; i < m_bocopDefPtr->dimStages(); i++) {
                file_out << g[indice] << endl;
                indice += m_bocopDefPtr->dimPathConstraints();
            }

            // we skip the dynamics at this step,
            // we get to the path constraints at the next step :
            indice += m_bocopDefPtr->dimState() + m_bocopDefPtr->dimStages() * m_bocopDefPtr->dimState();
        }

        file_out << endl;
    }

    // 2) Dynamics I (y(t_l+1) - y(t_l) - h*sum(b_i*k_i) = 0)
    ind_start = this->m_bocopDefPtr->dimInitFinalCond() + m_bocopDefPtr->dimStages() * m_bocopDefPtr->dimPathConstraints();
    for (j = 0; j < m_bocopDefPtr->dimState(); j++) { // Loop over each (y_dot-f) of the dynamics
        file_out << "# Dynamic constraint " << j << " (y_dot - f = 0) : " << endl;
        file_out << 0.0 << " " << 0.0 << " " << 4 << endl;
        indice = ind_start + j;

        for (l = 0; l < m_bocopDefPtr->dimSteps(); l++) { // we write a given (y_dot-f) for each time step
            file_out << g[indice] << endl;

            // we get to y[j] for the next time step :
            indice += dimConstr;
        }

        file_out << endl;
    }

    // We can now write the multipliers :
    writeDiscretizedMultipliers(file_out,
                                m,
                                lambda,
                                true,
                                boundaryCondMultiplier,
                                pathConstrMultiplier,
                                adjointState);

    // Then we write the coefficients of the discretization method
    file_out << "# Coefficients of discretization method : " << endl;

    file_out << endl;

    file_out << "# a(i,j) by column : " << endl;

    for (j = 0; j < m_bocopDefPtr->dimStages(); j++) {
        for (l = 0; l < m_bocopDefPtr->dimStages(); l++) {
            file_out << m_bocopDefPtr->discCoeffA()[l][j] << endl;
        }
    }

    file_out << endl;

    file_out << "# b  : " << endl;

    for (j = 0; j < m_bocopDefPtr->dimStages(); j++) {
        file_out << m_bocopDefPtr->discCoeffB()[j] << endl;
    }

    file_out << endl;

    file_out << "# c  : " << endl;

    for (j = 0; j < m_bocopDefPtr->dimStages(); j++) {
        file_out << m_bocopDefPtr->discCoeffC()[j] << endl;
    }

    // ***** Bound multipliers z_L and z_U *****
    file_out << endl;

    file_out << "# z_L and z_U : " << endl;

    file_out << endl;


    // First we write z_L

    // First we write the values of z_L corresponding to y (on the nodes) :
    for (i = 0; i < m_bocopDefPtr->dimState(); i++) {
        // Index of the first element of the i-th state variable :
        indice_y = i;
        file_out << "# z_L corresponding to state variable " << i << " : " << endl;
        for (l = 0; l < m_bocopDefPtr->dimSteps() + 1; l++) {
            file_out << z_L[indice_y] << endl;
            indice_y += this->m_dimProblem;
        }

        file_out << endl;
    }

    // Then the values of values of z_L corresponding to u (u is defined on every stage of the discretization
    // method, but we only write its values on the first stage) :

    // number of variables stored for a stage s of the discretization method :
    int dim_stage = m_bocopDefPtr->dimControl() + m_bocopDefPtr->dimState() + m_bocopDefPtr->dimAlgebraic();
    for (i = 0; i < m_bocopDefPtr->dimControl(); i++) {
        // Index of the first element of the i-th control variable :
        indice_u = m_bocopDefPtr->dimState() + i;
        file_out << "# z_L corresponding to control variable " << i << " : " << endl;
        for (l = 0; l < m_bocopDefPtr->dimSteps(); l++) {
            for (int k = 0; k < m_bocopDefPtr->dimStages(); ++k)
                file_out << z_L[indice_u + k * dim_stage] << endl;

            indice_u += this->m_dimProblem;
        }

        file_out << endl;
    }

    // The values of z_L corresponding to z (as for u : first stage of the discretization method only) :
    for (i = 0; i < m_bocopDefPtr->dimAlgebraic(); i++) {
        // Index of the first element of the i-th algebraic variable :
        // (we have to skip the state, control, and k variables)
        indice_z = m_bocopDefPtr->dimState() + m_bocopDefPtr->dimControl() + m_bocopDefPtr->dimState() + i;
        file_out << "# z_L corresponding to algebraic variable " << i << " : " << endl;
        for (l = 0; l < m_bocopDefPtr->dimSteps(); l++) {
            for (int k = 0; k < m_bocopDefPtr->dimStages(); ++k)
                file_out << z_L[indice_z + k * dim_stage] << endl;

            indice_z += this->m_dimProblem;
        }

        file_out << endl;
    }


    // And finally, the z_L corresponding to optimization variables :
    indice_p = (m_bocopDefPtr->dimSteps() * this->m_dimProblem) + m_bocopDefPtr->dimState();
    file_out << "# z_L corresponding to parameters : " << endl;
    for (i = 0; i < m_bocopDefPtr->dimOptimVars(); i++) {
        file_out << z_L[indice_p] << endl;
        indice_p++;
    }

    file_out << endl;

    // Then  we write z_U

    // First we write the values of z_U corresponding to y (on the nodes) :
    for (i = 0; i < m_bocopDefPtr->dimState(); i++) {
        // Index of the first element of the i-th state variable :
        indice_y = i;
        file_out << "# z_U corresponding to state variable " << i << " : " << endl;
        for (l = 0; l < m_bocopDefPtr->dimSteps() + 1; l++) {
            file_out << z_U[indice_y] << endl;
            indice_y += this->m_dimProblem;
        }

        file_out << endl;
    }

    // Then the values of values of z_U corresponding to u (u is defined on every stage of the discretization
    // method, but we only write its values on the first stage) :

    // number of variables stored for a stage s of the discretization method :
    dim_stage = m_bocopDefPtr->dimControl() + m_bocopDefPtr->dimState() + m_bocopDefPtr->dimAlgebraic();
    for (i = 0; i < m_bocopDefPtr->dimControl(); i++) {
        // Index of the first element of the i-th control variable :
        indice_u = m_bocopDefPtr->dimState() + i;
        file_out << "# z_U corresponding to control variable " << i << " : " << endl;
        for (l = 0; l < m_bocopDefPtr->dimSteps(); l++) {
            for (int k = 0; k < m_bocopDefPtr->dimStages(); ++k)
                file_out << z_U[indice_u + k * dim_stage] << endl;

            indice_u += this->m_dimProblem;
        }

        file_out << endl;
    }

    // The values of z_U corresponding to z (as for u : first stage of the discretization method only) :
    for (i = 0; i < m_bocopDefPtr->dimAlgebraic(); i++) {
        // Index of the first element of the i-th algebraic variable :
        // (we have to skip the state, control, and k variables)
        indice_z = m_bocopDefPtr->dimState() + m_bocopDefPtr->dimControl() + m_bocopDefPtr->dimState() + i;
        file_out << "# z_U corresponding to algebraic variable " << i << " : " << endl;
        for (l = 0; l < m_bocopDefPtr->dimSteps(); l++) {
            for (int k = 0; k < m_bocopDefPtr->dimStages(); ++k)
                file_out << z_U[indice_z + k * dim_stage] << endl;

            indice_z += this->m_dimProblem;
        }

        file_out << endl;
    }


    // And finally, the z_U corresponding to optimization variables :
    indice_p = (m_bocopDefPtr->dimSteps() * this->m_dimProblem) + m_bocopDefPtr->dimState();
    file_out << "# z_U corresponding to parameters : " << endl;
    for (i = 0; i < m_bocopDefPtr->dimOptimVars(); i++) {
        file_out << z_U[indice_p] << endl;
        indice_p++;
    }

    file_out.close();
}


/**
 * \fn void BocopProblem::writeIterSolution(int iter_index,
 *                                    const Number* x,
 *                                    const Number* lambda)
 *
 * This functions writes a simplified .sol file (named .iter) at the end of an iteration.
 *
 */
void BocopProblem::writeIterSolution(int iter_index,
                                     Index m,
                                     const Number* x,
                                     const Number* lambda)
{
    if (m_bocopDefPtr->nameSolutionFile() == "")
        m_bocopDefPtr->setSolutionFile("problem.iter");

    stringstream solFileStr;
    solFileStr << m_bocopDefPtr->nameSolutionFile() << ".iter" << iter_index;
    string solFile = solFileStr.str();

    // Open the file where we want to write the results
    ofstream file_out(solFile.c_str(), ios::out | ios::binary);

    // set number of digits in order to avoid precision loss
    file_out.precision(15);

    if (!file_out)  { // if the opening succeeded
        cerr << endl << " BocopProblem::writeIterSolution() : ERROR! " << endl;
        cerr << " Cannot open solution file (" << solFile << ") to write the optimization results." << endl << endl;
        exit(1);
    }

    // First we write the definition, using the values used to initialise the problem
    // and stored in the members of BocopDefinition and BocopProblem
    // This first part is commented
    writeDefinition(file_out); // in order to have the dimensions in the file ...

    file_out << "# # #" << endl;
    file_out << "# # #" << endl;
    file_out << "# **************************** " << endl;
    file_out << "# **************************** " << endl;
    file_out << "# ***** ITERATION " <<  iter_index << endl;
    file_out << "# **************************** " << endl;
    //file_out << "# **************************** " << endl;
    file_out << "# # #" << endl;

    // First we write the value of the objective +++DUMMY. retrieve them via callback
    double dummy = 0;
    file_out << "# Objective value : " << endl;
    file_out << dummy << endl;
    file_out << "# L2-norm of the constraints : " << endl; //+++ wtf c'est 2 fois la meme... virer la L2 ??
    file_out << dummy << endl;
    file_out << "# Inf-norm of the constraints : " << endl;
    file_out << dummy << endl;

    // First we extract the informations from bocopDefPtr
    // +++ use aux function here and call also in writeSolution
    int dimStep = m_bocopDefPtr->dimSteps();
    int dimStage = m_bocopDefPtr->dimStages();
    //int dimConstant = m_bocopDefPtr->dimConstants();
    //int dimState = m_bocopDefPtr->dimState();
    //int dimControl = m_bocopDefPtr->dimControl();
    //int dimAlgebraic = m_bocopDefPtr->dimAlgebraic();
    //int dimParameter = m_bocopDefPtr->dimOptimVars();
    //int dimBoudCondMult = m_bocopDefPtr->dimInitFinalCond();
    //int dimPathConstrMult = m_bocopDefPtr->dimPathConstraints();

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


    // ***** Discretized times *****
    writeDiscretizedTimes(file_out);

    // ***** Result vector x *****
    file_out << endl;
    bool no_postprocessing = false;
    writeDiscretizedVariables(file_out, x, no_postprocessing, state, control, algebraic, parameter);

    //+++ missing boundary and path constraints ?

    // ***** Multipliers *****
    file_out << endl;
    writeDiscretizedMultipliers(file_out, m, lambda, no_postprocessing, boundaryCondMultiplier, pathConstrMultiplier, adjointState);

}

