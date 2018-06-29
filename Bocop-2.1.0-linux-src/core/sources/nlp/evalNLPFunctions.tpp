// This code is published under the Eclipse Public License
// Authors: Vincent Grelard, Daphne Giorgi, Pierre Martinon, Stephan Maindrault
// Inria
// 2011-2016

#ifndef NLPFUNCTIONS_TPP
#define NLPFUNCTIONS_TPP

#include "BocopProblem.hpp"
#include "functions.hpp"

using namespace std;

// Evaluation of the constraints :
/**
 * \fn template<class Tdouble> bool  BocopProblem::evalConstraints(Index n, const Tdouble *x, Index m, Tdouble* g)
 *
 * Template to compute the value of the constraints.
 * It evaluates the boundary conditions constraints, the path conditions constraints and the dynamic constraints
 */
template<class Tdouble> bool  BocopProblem::evalConstraints(Index n, const Tdouble *x, Index m, Tdouble* g)
{
    int i,j,k,l;
    Tdouble dt;

    // +++use this
    int dimState = m_bocopDefPtr->dimState();
    //int dimControl = m_bocopDefPtr->dimControl();
    //int dimAlgebraic = m_bocopDefPtr->dimAlgebraic();
    int dimSteps = m_bocopDefPtr->dimSteps();
    //int dimStages = m_bocopDefPtr->dimStages();

    // If final time is free, we have to multiply the normalized time found
    // in m_timeSteps by the current final time (which is the last element of VEC)
    Tdouble T_F;//+++ write function
    if (m_bocopDefPtr->freeTime() == "final") {
        // the last element of the array contains the final time
        T_F = x[(m_bocopDefPtr->dimSteps()*m_dimProblem)+m_bocopDefPtr->dimState()+m_bocopDefPtr->dimOptimVars()-1];
    }
    else
        T_F = m_bocopDefPtr->finalTime();

    Tdouble initialTime = UnnormalizedTime(0.0, T_F);
    Tdouble finalTime = UnnormalizedTime(1.0, T_F);

    // First we compute the dynamic constraints of the problem, using
    // the generic RK discretization method.
    Tdouble* dynamicConstraints = new Tdouble[m_bocopDefPtr->dimSteps()* (m_bocopDefPtr->dimState() + m_bocopDefPtr->dimStages()*m_bocopDefPtr->dimState())];
    computeDynConstraints(x, dynamicConstraints);

    // 1) Fill the constraints vector with boundary conditions :
    Tdouble* boundaryConditions = new Tdouble[m_bocopDefPtr->dimInitFinalCond()]; // vector for the boundary conditions
    
    // We affect default values to the boundaryConditions array, in order to check if some elements of the array weren't affected after the call to "boundarycond"
    for (i=0; i<m_bocopDefPtr->dimInitFinalCond(); i++)
        boundaryConditions[i] = 1e20;

    Tdouble* y_step_0 = new Tdouble[m_bocopDefPtr->dimState()]; getStateAtStep(x,0, y_step_0);
    Tdouble* y_step_f = new Tdouble[m_bocopDefPtr->dimState()]; getStateAtStep(x,m_bocopDefPtr->dimSteps(), y_step_f);
    Tdouble* param = new Tdouble[m_bocopDefPtr->dimOptimVars()]; getParameter(x, param);

    boundarycond(initialTime,
                 finalTime,
                 m_bocopDefPtr->initialTime(),//double instead of Tdouble
                 m_bocopDefPtr->finalTime(),//double instead of Tdouble
                 m_bocopDefPtr->dimState(),
                 y_step_0,
                 y_step_f,
                 m_bocopDefPtr->dimOptimVars(),
                 param,
                 m_bocopDefPtr->dimConstants(),
                 m_bocopDefPtr->constants(),
                 m_bocopDefPtr->dimInitFinalCond(),
                 boundaryConditions);

    // We check if the values of boundaryConditions changed
    for (i=0; i<m_bocopDefPtr->dimInitFinalCond(); i++) {
        if (boundaryConditions[i] == 1e20) {
            cerr << " ERROR : An element of the boundary conditions array didn't change from its defaut value (1e20)." << endl;
            cerr << "         Please make sure that boundary_conditions[" << i  << "] has been set." << endl;
            cerr << "         Check if you entered the right dimensions in your Boundary Conditions function." << endl << endl;
            return false;
        }
    }

    for (k=0; k<m_bocopDefPtr->dimInitFinalCond(); k++)
        g[k] = boundaryConditions[k];

    k=m_bocopDefPtr->dimInitFinalCond();

    // We fill the result vector with the value of the
    // constraints on each point of the discretization :

    // Vector to fill with the path constraints at each time step
    Tdouble* pathConstraints = NULL;
    if (m_bocopDefPtr->dimPathConstraints() != 0) {
        pathConstraints = new Tdouble[m_bocopDefPtr->dimPathConstraints()];
        
        // We affect default values to the pathConstraints array, in order to check if some elements of the array weren't affected after the call to "pathcond"
        for (i=0; i<m_bocopDefPtr->dimPathConstraints(); i++)
            pathConstraints[i] = 1e20;
    }

    // number of constraints on a time step (path constraints, y(t_l+1)-y(t_l)=0, k_i-f = 0) :
    int indice_dyn=0;

    // Loop over the time discretization
    Tdouble t_this_stage;
    double normalized_time;
    Tdouble* y_stage; y_stage = new Tdouble[m_bocopDefPtr->dimState()];
    Tdouble* u_stage; u_stage = new Tdouble[m_bocopDefPtr->dimControl()];
    Tdouble* z_stage; z_stage = new Tdouble[m_bocopDefPtr->dimAlgebraic()];

    // vectors for past states and controls (delay problems)
    // +++ a terme passer directement m_timeSteps, m_timeStages et les vecteurs control/state complets (doit y avoir une fonction qui extrait ca cf export)
    vector<double> past_steps(dimSteps); // normalized
    vector<vector<Tdouble> > past_states(dimState,vector<Tdouble>(dimSteps));

    for (l=0; l<m_bocopDefPtr->dimSteps(); l++) {

        // save step state for delay problems
        dt = getTimeStep(l, x);
        past_steps[l] = m_bocopDefPtr->timeSteps()[l];
        getStateAtStep(x, l, y_stage);
        for (j=0; j<dimState; j++)
          past_states[j][l] = y_stage[j];

        if (m_bocopDefPtr->dimPathConstraints() != 0) {
            for (i=0; i<m_bocopDefPtr->dimStages(); i++) {
                // first we get the variables and the time on the
                // current time stage :
                getStateAtStage(x, dt, l, i, y_stage);
                getControl(x, l, i, u_stage);
                getAlgebraic(x, l, i, z_stage);
                normalized_time = m_bocopDefPtr->timeStages()[l*m_bocopDefPtr->dimStages()+i];
                t_this_stage = UnnormalizedTime(m_bocopDefPtr->timeStages()[l*m_bocopDefPtr->dimStages()+i], T_F);

                pathcond(t_this_stage,
                         normalized_time,
                         initialTime,//Tdouble
                         finalTime,//Tdouble
                         m_bocopDefPtr->initialTime(),//double
                         m_bocopDefPtr->finalTime(),//double
                         m_bocopDefPtr->dimState(),
                         y_stage,
                         m_bocopDefPtr->dimControl(),
                         u_stage,
                         m_bocopDefPtr->dimAlgebraic(),
                         z_stage,
                         m_bocopDefPtr->dimOptimVars(),
                         param,
                         m_bocopDefPtr->dimConstants(),
                         m_bocopDefPtr->constants(),
                         l,
                         past_steps,
                         past_states,
                         m_bocopDefPtr->dimPathConstraints(),
                         pathConstraints);

                for (j=0; j<m_bocopDefPtr->dimPathConstraints(); j++)	{
                    if (pathConstraints[j] == 1e20)	{
                        cerr << " ERROR : An element of the path constraints array didn't change from its defaut value (1e20)." << endl;
                        cerr << "         Please make sure that path_constraints[" << j << "] has been set." << endl;
                        cerr << "         Check if you entered the right dimensions in your Path Constraints function." << endl << endl;
                        return false;
                    }
                }

                // 2) Fill the constraints vector with the path constraints
                for (j=0; j<m_bocopDefPtr->dimPathConstraints(); j++) {
                    g[k] = pathConstraints[j];
                    k++;
                }
            }
        }

        // 3) Fill the constraints vector with the dynamics constraints
        // first the condition y(t_l+1) - y(t_l) - h sum (...) = 0 on the node l:
        for (j=0; j<m_bocopDefPtr->dimState(); j++) {
            g[k] = dynamicConstraints[indice_dyn];
            k++;
            indice_dyn++;
        }

        // then the condition k_i - f(...) = 0 on the stages i of node l :
        for (i=0; i<m_bocopDefPtr->dimStages(); i++) {
            for (j=0; j<m_bocopDefPtr->dimState(); j++) {
                g[k] = dynamicConstraints[indice_dyn];
                k++;
                indice_dyn++;
            }
        }
    }

    delete[] boundaryConditions;
    delete[] y_step_0;
    delete[] y_step_f;
    delete[] param;

    delete[] pathConstraints;
    delete[] dynamicConstraints;
    delete[] y_stage;
    delete[] u_stage;
    delete[] z_stage;

    return true;
}

// Evaluation of the objective function :
/**
 * \fn template<class Tdouble> bool  BocopProblem::evalObjective(Index n, const Tdouble *x, Tdouble& obj_value)
 *
 * Template function to calculate the value of the objective.
 */
template<class Tdouble> bool  BocopProblem::evalObjective(Index n, const Tdouble *x, Tdouble& obj_value)
{

    // The objective function is defined by the user in criterion.tpp. We have to
    // provide the values of t0, y0, tf, yf, parameters and constants. These values
    // are not available in criterion.tpp, but we can evaluate them here, and call
    // criterion with these values.
    Tdouble* param;
    param =  new Tdouble[m_bocopDefPtr->dimOptimVars()];
    getParameter(x, param);

    Tdouble* y_step_0;
    y_step_0 =  new Tdouble[m_bocopDefPtr->dimState()];
    getStateAtStep(x,0, y_step_0);

    Tdouble* y_step_f;
    y_step_f =  new Tdouble[m_bocopDefPtr->dimState()];
    getStateAtStep(x,m_bocopDefPtr->dimSteps(), y_step_f);


    // If final time is free, we have to multiply the normalized time found
    // in m_timeSteps by the current final time (which is the last element of VEC)
    Tdouble T_F;
    if (m_bocopDefPtr->freeTime() == "final")	{
        // the last element of the array contains the final time
        T_F = x[(m_bocopDefPtr->dimSteps()*m_dimProblem)+m_bocopDefPtr->dimState()+m_bocopDefPtr->dimOptimVars()-1];
    }
    else {
        T_F = m_bocopDefPtr->finalTime();
    }
    Tdouble initial_time = UnnormalizedTime(0.0,T_F);
    Tdouble final_time = UnnormalizedTime(1.0,T_F);

    // We call the criterion function defined for the current problem (defined by user)
    crit(initial_time,
         final_time,
         m_bocopDefPtr->initialTime(),//double instead of Tdouble
         m_bocopDefPtr->finalTime(),//double instead of Tdouble
         m_bocopDefPtr->dimState(),
         y_step_0,
         y_step_f,
         m_bocopDefPtr->dimOptimVars(),
         param,
         m_bocopDefPtr->dimConstants(),
         m_bocopDefPtr->constants(),
         obj_value);


    // If there is a parameter identification to do, the obj_value will be the obj_value + the errorToObservation
    if ( m_bocopDefPtr->paramIdType() != "false" ) {
        Tdouble totalError = 0;
        Tdouble error = 0;

        for (int k=0; k<m_bocopDefPtr->sizeDataSet();k++){
            Tdouble** stateForMeasure = new Tdouble*[m_bocopDefPtr->sizeObservation()[k]];
            for (int p=0; p<m_bocopDefPtr->sizeObservation()[k]; p++)
                stateForMeasure[p] = new Tdouble[m_bocopDefPtr->dimState()];
            for (int i=0; i<m_bocopDefPtr->sizeObservation()[k];i++)
                getStateAtSteps(x, m_bocopDefPtr->indexObservation()[k], m_bocopDefPtr->sizeObservation()[k], stateForMeasure );

          /*  Tdouble* timeForMeasure;
            timeForMeasure = new Tdouble[m_bocopDefPtr->sizeObservation()[k]]; // to make equal to m_bocopDefPtr->timeObservation() but with Tdouble
            for (int i=0; i<m_bocopDefPtr->sizeObservation()[k]; i++)
                timeForMeasure[i] = m_bocopDefPtr->timeObservation()[k][i]; */

            // Compute the error to observation corresponding to the file k
            errorToObservation(m_bocopDefPtr->sizeObservation()[k],
                               //timeForMeasure,
                               m_bocopDefPtr->timeObservation()[k],
                               m_bocopDefPtr->dimObservation()[k],
                               m_bocopDefPtr->observations()[k],
                               m_bocopDefPtr->weightObservations()[k],
                               m_bocopDefPtr->dimState(),
                               stateForMeasure,
                               m_bocopDefPtr->dimOptimVars(),
                               param,
                               m_bocopDefPtr->dimConstants(),
                               m_bocopDefPtr->constants(),
                               m_bocopDefPtr->paramIdType(),
                               k,
                               error);

            totalError += error;

            for (int i=0; i< m_bocopDefPtr->sizeObservation()[k]; i++)
                delete[] stateForMeasure[i];
            delete[] stateForMeasure;
            //delete[] timeForMeasure;
        }

        // We choose if we keep or discard the cost in user function criterion
        if (m_bocopDefPtr->paramIdType() == "LeastSquareWithCriterion" || m_bocopDefPtr->paramIdType() == "Manual")
            obj_value += totalError;
        else if ( m_bocopDefPtr->paramIdType() == "LeastSquare")
            obj_value = totalError;
        else {
            cerr << " BocopProblem::evalObjective (evalNLPFunctions.tpp) " << endl;
            cerr << " The value for paramid.type is not recognized. " << endl;
            cerr << " Value read: "+ m_bocopDefPtr->paramIdType() +" Possible values: LeastSquare, LeastSquareWithCriterion, Manual." << endl;
            return 18;
        }
    }
    delete[] param;
    delete[] y_step_0;
    delete[] y_step_f;

    return true;
}

#endif

