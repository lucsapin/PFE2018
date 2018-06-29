// This code is published under the Eclipse Public License
// Authors: Vincent Grelard, Daphne Giorgi, Pierre Martinon
// Inria
// 2011-2017

#ifndef GENERIC_METHOD_TPP
#define GENERIC_METHOD_TPP

#include <iostream>
#include <math.h>
using namespace std;

#include "BocopProblem.hpp"
#include "functions.hpp"

/** 
 * \fn BocopProblem::computeDynConstraints(const Tdouble* VEC, Tdouble* vec_dyn_constr)
 *
 * \param VEC input, main vector (y,u,z,p)
 * \param vec_dyn_constr output, result discretized vector for the dynamic constraints
 *
 * Generic method to compute the constraints corresponding to the discretized dynamics.
 * Dynamics is discretized according to the chosen generalized Runge Kutta method:
 * y_{i+1} = y_i + sum(b_i * k_i)      where       k_i = f(t_i+c_i*h, y_i+h*sum(a_ij*k_j)
 * with the coefficients a_ij, b_i, c_i defined in the .disc file for the RK method
 *
 * This method calls "computeDynamics" which evaluates the dynamics f at each time step.
 * Then for each time step we compute the main and stage constraints.
 * The constraint are of the form: (y_i + sum(b_i*k_i)) - y_{i+1} = 0 and  f(...)- k_i = 0
 * so that the associated multiplier has the same sign as the adjoint variable from the PMP
 *
 * Dimension of the result : dimSteps* (dimState + dimStages*dimState)
 */
template<class Tdouble> void BocopProblem::computeDynConstraints(const Tdouble* VEC, Tdouble* vec_dyn_constr)
{

    int dimState = m_bocopDefPtr->dimState();
    int dimControl = m_bocopDefPtr->dimControl();
    int dimAlgebraic = m_bocopDefPtr->dimAlgebraic();
    int dimSteps = m_bocopDefPtr->dimSteps();
    int dimStages = m_bocopDefPtr->dimStages();

    // Aux
    Tdouble sum_bk; // sum_i (b_i * k_i)
    int ind_constr=0; // index for the constraint array to be filled
    int indice_k, indice_y; // indexes for k and y in main vector VEC
    // size of a variables block (u,k,z) for one stage
    int dim_stage_block = dimControl+dimState+dimAlgebraic;

    // times
    // If final time is free, actual value is the last element of VEC
    Tdouble T_F; //+++ write function
    if (m_bocopDefPtr->freeTime() == "final")
        T_F = VEC[(dimSteps*this->m_dimProblem)+dimState+m_bocopDefPtr->dimOptimVars()-1];
    else
        T_F = m_bocopDefPtr->finalTime();
    double normalized_time;
    Tdouble time;
    Tdouble initial_time = this->UnnormalizedTime(0.0, T_F);
    Tdouble final_time = this->UnnormalizedTime(1.0, T_F);
    Tdouble dt;

    // allocations +++ use members ?
    Tdouble* f_stage = new Tdouble[dimState];
    Tdouble* y_stage = new Tdouble[dimState];
    Tdouble* u_stage = new Tdouble[dimControl];
    Tdouble* z_stage = new Tdouble[dimAlgebraic];
    Tdouble* p = new Tdouble[m_bocopDefPtr->dimOptimVars()];
    getParameter(VEC, p);

    // vectors for past states and controls (delay problems)
    // +++ a terme passer directement m_timeSteps, m_timeStages et les vecteurs control/state complets (doit y avoir une fonction qui extrait ca cf export)
    vector<double> past_steps(dimSteps); // normalized
    vector<double> past_stages(dimSteps*dimStages); // normalized
    vector<vector<Tdouble> > past_states(dimState,vector<Tdouble>(dimSteps));
    vector<vector<Tdouble> > past_controls(dimControl,vector<Tdouble>(dimSteps*dimStages));

    // Affect default values to dynamics array to check for unassigned values
    for (int i=0; i<dimState; i++)
        f_stage[i] = 1e20;

    // Loop over the time steps
    for (int l=0; l<dimSteps; l++)
    {
        dt = getTimeStep(l, VEC);
        indice_y = l*this->m_dimProblem;
        indice_k = indice_y + dimState + dimControl;

        // First we write the constraint on y_l+1: (y_i + sum(b_i*k_i)) - y_{i+1} = 0    
        for (int j=0; j<dimState; j++) {

            // Compute sum(b_i*k_i)
            sum_bk = 0.;
            for(int i=0; i<dimStages; i++)
                sum_bk += m_bocopDefPtr->discCoeffB()[i] * VEC[indice_k+i*(dim_stage_block)];

            // Write the constraint
            vec_dyn_constr[ind_constr++] = VEC[indice_y] + dt * sum_bk - VEC[indice_y+this->m_dimProblem];
            indice_y++;
            indice_k++;
        }

        // save step state for delay problems
        past_steps[l] = m_bocopDefPtr->timeSteps()[l];
        getStateAtStep(VEC, l, y_stage);
        for (int j=0; j<dimState; j++)
          past_states[j][l] = y_stage[j];

        // Write the constraints on k_i: f(...) - k_i = 0
        indice_k = (l*this->m_dimProblem) + dimState + dimControl;
        for (int i=0; i<dimStages; i++) {

            // retrieve t, y, u, z at current stage
            this->getStateAtStage(VEC, dt, l, i, y_stage);
            this->getControl(VEC, l, i, u_stage);
            this->getAlgebraic(VEC, l, i, z_stage);
            normalized_time = m_bocopDefPtr->timeStages()[l*dimStages+i];
            time = this->UnnormalizedTime(normalized_time, T_F);

            // save stage control for delay problems
            // +++ USE AVERAGE CONTROL AT STEPS ??
            past_stages[l*dimStages+i] = normalized_time;
            for (int j=0; j<dimControl; j++)
              past_controls[j][l*dimStages+i] = u_stage[j];

            // call dynamics at current stage
            dynamics(time,
                     normalized_time,
                     initial_time, //Tdouble
                     final_time, //Tdouble
                     m_bocopDefPtr->initialTime(),//double
                     m_bocopDefPtr->finalTime(),//double
                     dimState,
                     y_stage,
                     dimControl,
                     u_stage,
                     dimAlgebraic,
                     z_stage,
                     m_bocopDefPtr->dimOptimVars(),
                     p,
                     m_bocopDefPtr->dimConstants(),
                     m_bocopDefPtr->constants(),
                     l,
                     past_steps,
                     past_states,
                     l*dimStages+i,
                     past_stages,
                     past_controls,
                     f_stage);

            // We check if the values of f_stage changed
            for (int i=0; i<dimState; i++) {
                if (f_stage[i] == 1e20) {
                    cerr << " ERROR : An element of the state dynamics array didn't change from its defaut value (1e20)." << endl;
                    cerr << "         Please make sure that state_dynamics[" << i  << "] has been set." << endl;
                    cerr << "         Check if you entered the right dimensions in your Dynamics function." << endl << endl;
                    exit(-7);
                }
            }


            // compute constraint f(...) - k_i = 0
            for(int j=0; j<dimState; j++) {
                vec_dyn_constr[ind_constr++] = f_stage[j] - VEC[indice_k++];
            }

            // to get k for the next stage we skip u and k
            indice_k += dimControl + dimAlgebraic;
        }
    }

    // deallocations (NB. cannot use a single delete -_-)
    delete[] f_stage;
    delete[] y_stage;
    delete[] u_stage;
    delete[] z_stage;
    delete[] p;

}


#include "discTools.tpp"

#endif
