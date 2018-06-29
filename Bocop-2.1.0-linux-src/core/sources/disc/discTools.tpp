// This code is published under the Eclipse Public License
// File: discTools.tpp
// Authors: Vincent Grelard, Daphne Giorgi, Pierre Martinon
// Inria Saclay and Cmap Ecole Polytechnique
// 2011-2017

#ifndef DISC_TOOLS_TPP
#define DISC_TOOLS_TPP

#include <math.h>

using namespace std;

#include "BocopProblem.hpp"


// ***************************
// ***** Get Step Vector *****
// ***************************

/** 
 * \fn BocopProblem::getX(const Tdouble* VEC, const int l, const int i, Tdouble* x_stage)
 *
 * \param VEC input, main vector
 * \param l time step
 * \param i step in the discretization method (1<=i<=s)
 * \param x_stage output, result vector
 *
 * Function to get the vector of the l-th step, and i-th stage, from the main vector.
 * This function extracts at a time step l, the values of :
 * y[l], u[l][i], k[l][i], z[l], p
 * Dimension of the result vector : m_bocopDefPtr->dimState()+m_bocopDefPtr->dimControl()+m_bocopDefPtr->dimAlgebraic()+m_bocopDefPtr->dimOptimVars()
 */
template<class Tdouble> void BocopProblem::getX(const Tdouble* VEC, const int l, const int i, Tdouble* x_stage)
{

    // We have to use getTimeStep in case the problem has free final time.
    // Indeed, in such case, we have to use the non-normalized values
    Tdouble dt;
    dt = getTimeStep(l, VEC);

    int m,n;
    int ind_res=0;

    // The formula for evaluating y at a time stage involves a sum over s,
    // we use this dummy variable to evaluate it :
    Tdouble sum_ak = 0.;

    // Vector for the result :

    int dim_stage = m_bocopDefPtr->dimControl()+m_bocopDefPtr->dimState()+m_bocopDefPtr->dimAlgebraic();

    // ******   Y   ********

    // We have access to y(tl) at the beginning of the time step
    // but we must evaluate them at current stage i, according to the formula for ki :
    // y[] = y[](tl) + h*sum (m_discCoeffA_ij*k[]_j) (see ::getState for more information)

    // To do so, we get the index of the first k[0 (m_dimState)][0 (s)] :
    int indice_k = (l*this->m_dimProblem) + m_bocopDefPtr->dimState() + m_bocopDefPtr->dimControl();

    // We also need the first index of y(tl)
    int indice_y = l*this->m_dimProblem;

    // We can now compute the values of y[]
    for (n=0; n<m_bocopDefPtr->dimState(); n++) {
        sum_ak = 0.;

        // We now compute the values of the sum for the n-th entry of y :
        for (int j=0; j<m_bocopDefPtr->dimStages(); j++) {
            // k_j = VEC[indice_k+j*(m_bocopDefPtr->dimControl()+m_bocopDefPtr->dimState())]
            sum_ak += m_bocopDefPtr->discCoeffA()[i][j]*VEC[indice_k+j*(dim_stage)];
        }
        sum_ak *= dt;  //dt

        // Finally we have the value of y_i (y(tl)+sum()) :
        x_stage[ind_res] = VEC[indice_y]+sum_ak;

        // the next k[n][0] and y[n] are right besides the previous :
        indice_k++;
        indice_y++;
        ind_res++;
    }


    // ******   U   ********

    // Then the variable u at time step l, at stage i :
    int ind_start = (l*this->m_dimProblem) + m_bocopDefPtr->dimState() + i*(dim_stage);
    int ind_stop = ind_start + m_bocopDefPtr->dimControl();

    for (m=ind_start; m<ind_stop; m++) {
        x_stage[ind_res] = VEC[m];
        ind_res++;
    }

    // ******   Z   ********

    // For z, we have to do the same as for u (z is on the stages) :

    // We also need the first index of z(tl)
    int indice_z = l*this->m_dimProblem + m_bocopDefPtr->dimState() + i*(dim_stage) + m_bocopDefPtr->dimControl() + m_bocopDefPtr->dimState();

    // We can now compute the values of z[]
    for (n=0; n<m_bocopDefPtr->dimAlgebraic(); n++) {
        x_stage[ind_res] = VEC[indice_z+n];
        ind_res++;
    }

    // ******   P   ********

    // Finally the parameters, at the end of the main vector :
    ind_start = m_bocopDefPtr->dimSteps()*this->m_dimProblem + m_bocopDefPtr->dimState();
    ind_stop =  ind_start + m_bocopDefPtr->dimOptimVars();

    for (m=ind_start; m<ind_stop; m++){
        x_stage[ind_res] = VEC[m];
        ind_res++;
    }
}


// **********************************
// ***** Get y at a given step  *****
// **********************************

/** 
 * \fn BocopProblem::getStateAtStep(const Tdouble* VEC, const int l, Tdouble* y_step)
 *
 * \param VEC input, main vector
 * \param l time step
 * \param y_step output, result vector
 *
 * Function to get y[] of the l-th step from the main vector.
 * Values of y in main discretized variables vector are computed on the time
 * steps, so y is easy to know at l-th time step
 * Dimension of the result vector : m_bocopDefPtr->dimState()
 */
template<class Tdouble> void BocopProblem::getStateAtStep(const Tdouble* VEC, const int l, Tdouble* y_step)
{
    int i;

    // ******   Y   ********
    // We have access to y(tl) at the beginning of the time step

    // To do so, we get the index of y[l][0] :
    int indice_y = l*this->m_dimProblem;

    // We can now compute the values of y[]
    for (i=0; i<m_bocopDefPtr->dimState(); i++)  {
        y_step[i] = VEC[indice_y];

        // the next and y[l][i] is right besides the previous :
        indice_y++;
    }
}


// **********************************
// ***** Get y at given steps  *****
// **********************************

/**
 * \fn BocopProblem::getStateAtSteps(const Tdouble* VEC, const int* indexes, const int dimIndexes, Tdouble** y_step)
 *
 * \param VEC input, main vector
 * \param indexes vector of indexes of time steps
 * \param y_step output, result vector matrix
 *
 * Function to get a set of y[] on  a set of steps from the main vector.
 * Values of y in main discretized variables vector are computed on the time
 * steps, so y is easy to know at l-th time step
 * Dimension of the result matrix : dimIndexes*m_dimState
 */
template<class Tdouble> void BocopProblem::getStateAtSteps(const Tdouble* VEC, const int* indexes, int dimIndexes, Tdouble** y_step)
{
    int k=0;

    // ******   Y   ********
    // For each index k, we have access to y(tk) at the beginning of the time step
    for ( int i=0; i<dimIndexes; i++) {
        k=indexes[i];
        getStateAtStep(VEC, k, y_step[i]);
    }
}


// ***********************************
// ***** Get y at a given stage  *****
// ***********************************

/** 
 * \fn BocopProblem::getStateAtStage(const Tdouble* VEC, const Tdouble dt, const int l, const int i, Tdouble* y_stage)
 *
 * \param VEC input, main vector
 * \param dt time increment
 * \param l time step
 * \param i stage in the discretization method (1<=i<=s)
 * \param y_stage output, result vector
 *
 * Function to get y[] of the l-th step, and i-th stage, from the main vector.
 * Values of y stored in the main vector, are only computed at the nodes of the
 * discretization (time step). We do not know explicitly the values of y on the
 * stages of the discretization method. We have to evaluate the values at i-th
 * stage with an approximation : y[l][i] = y[l] + h*sum_{j=1:s}(a[i][j]*k[j])
 * Dimension of the result vector : m_bocopDefPtr->dimState()
 */
template<class Tdouble> void BocopProblem::getStateAtStage(const Tdouble* VEC, const Tdouble dt, const int l, const int i, Tdouble* y_stage)
{
    // The formula for evaluating y at a time stage involves a sum over s,
    // we use this dummy variable to evaluate it :
    Tdouble sum_ak = 0.;

    int dim_stage = m_bocopDefPtr->dimControl()+m_bocopDefPtr->dimState()+m_bocopDefPtr->dimAlgebraic();

    // To do so, we get the index of the first k[0 (m_dimState)][0 (s)] :
    int indice_k = (l*this->m_dimProblem) + m_bocopDefPtr->dimState() + m_bocopDefPtr->dimControl();

    // We also need the first index of y(tl)
    int indice_y = l*this->m_dimProblem;

    // We can now compute the values of y[]
    for (int n=0; n<m_bocopDefPtr->dimState(); n++) {
        sum_ak = 0.;

        // We now compute the values of the sum for the n-th entry of y :
        for (int j=0; j<m_bocopDefPtr->dimStages(); j++) {
            // k_j = VEC[indice_k+j*(m_bocopDefPtr->dimControl()+m_bocopDefPtr->dimState())]
            sum_ak += m_bocopDefPtr->discCoeffA()[i][j]*VEC[indice_k+j*(dim_stage)];
        }
        sum_ak *= dt;  //dt

        // Finally we have the value of y_i (y(tl)+sum()) :
        y_stage[n] = VEC[indice_y]+sum_ak;

        // the next k[n][0] and y[n] are right besides the previous :
        indice_k++;
        indice_y++;
    }
}


// ***********************************
// ***** Get u at a given stage  *****
// ***********************************

/** 
 * \fn BocopProblem::getControl(const Tdouble* VEC, const int l, const int i, Tdouble* u_stage)
 *
 * \param VEC input, main vector
 * \param l time step
 * \param i step in the discretization method (1<=i<=s)
 * \param u_stage output, result vector
 *
 * Function to get u[] of the l-th step, and i-th stage, from the main vector.
 * Values of u in main discretized variables vector are computed on the discretization
 * stages, so u is easy to know at i-th time stage
 * Dimension of the result vector : m_bocopDefPtr->dimControl()
 */
template<class Tdouble> void BocopProblem::getControl(const Tdouble* VEC, const int l, const int i, Tdouble* u_stage)
{

    int dim_stage = m_bocopDefPtr->dimControl()+m_bocopDefPtr->dimState()+m_bocopDefPtr->dimAlgebraic();

    // ******   U   ********

    // The index of u at time step l, and stage i :
    // l*this->m_dimProblem : get to the l-th time step
    // + m_bocopDefPtr->dimState() : skip variable y for this step
    // after this, the index points to the first u of this step.
    // + i*(dim_stage) : go to the i-th stage
    int indice_u = l*this->m_dimProblem + m_bocopDefPtr->dimState() + i*(dim_stage);

    // We can now compute the values of u[l][i][]
    for (int n=0; n<m_bocopDefPtr->dimControl(); n++) {
        u_stage[n] = VEC[indice_u];

        // the next and u[l][i] is right besides the previous :
        indice_u++;
    }
}

// ***********************************
// ***** Get z at a given stage  *****
// ***********************************

/** 
 * \fn BocopProblem::getAlgebraic(const Tdouble* VEC, const int l, const int i, Tdouble* u_stage)
 *
 * \param VEC input, main vector
 * \param l time step
 * \param i step in the discretization method (1<=i<=s)
 * \param z_stage output, result vector
 *
 * Function to get z[] of the l-th step, and i-th stage, from the main vector.
 * Values of z in main discretized variables vector are computed on the discretization
 * stages, so z is easy to know at i-th time stage
 */
template<class Tdouble> void BocopProblem::getAlgebraic(const Tdouble* VEC, const int l, const int i, Tdouble* z_stage)
{

    if (m_bocopDefPtr->dimAlgebraic() != 0)  {
        int dim_stage = m_bocopDefPtr->dimControl()+m_bocopDefPtr->dimState()+m_bocopDefPtr->dimAlgebraic();


        // ******   Z   ********

        // The index of z at time step l, and stage i :
        // l*this->m_dimProblem : get to the l-th time step
        // + m_bocopDefPtr->dimState() : skip variable y for this step
        // + m_bocopDefPtr->dimControl() + m_bocopDefPtr->dimState() : skip u and k for the first stage,
        // after this, the index points to the first z of this step.
        // + i*(dim_stage) : go to the i-th stage
        int indice_z = l*this->m_dimProblem + m_bocopDefPtr->dimState() + m_bocopDefPtr->dimControl() + m_bocopDefPtr->dimState() + i*(dim_stage);

        // We can now compute the values of z[l][i][]
        for (int n=0; n<m_bocopDefPtr->dimAlgebraic(); n++) {
            z_stage[n] = VEC[indice_z];

            // the next and z[l][i] is right besides the previous :
            indice_z++;
        }
    }
}

// **********************************
// *****    Get Parameters p    *****
// **********************************

// Function to get the parameters from the main vector.
/** 
 * \fn BocopProblem::getParameter(const Tdouble* VEC, Tdouble* vec_p)
 *
 * \param VEC input, main vector
 * \param vec_p output, result vector
 *
 * Function to get the parameters from the main vector.
 */
template<class Tdouble> void BocopProblem::getParameter(const Tdouble* VEC, Tdouble* vec_p)
{
    // ******   P   ********
    // Vector p is at the end of VEC :
    int indice_p = (m_bocopDefPtr->dimSteps()*this->m_dimProblem)+m_bocopDefPtr->dimState();

    // We can now compute the values of y[]
    for (int n=0; n<m_bocopDefPtr->dimOptimVars(); n++) {
        vec_p[n] = VEC[indice_p];

        // the next and y[l][i] is right besides the previous :
        indice_p++;
    }
}

// **********************************
// *****    Get time step    *****
// **********************************

/** 
 * \fn BocopProblem::getTimeStep(const int i, const Tdouble* VEC)
 *
 * \param i stage
 * \param VEC input main vector
 *
 * Function to get the the time step interval at the i-th stage.
 * This function is useful when solving a problem with free final time
 * It uses the current value of current optimized time to "un-normalize" the problem.
 * It returns the "non normalized" time step.
 */
template<class Tdouble> Tdouble BocopProblem::getTimeStep(const int i, const Tdouble* VEC)
{
    if (i>m_bocopDefPtr->dimSteps()) {
        cerr << endl << " *** <BocopProblem::getTimeStep()> --> ERROR. " << endl;
        cerr << "     Invalid index. Requested time step is out of bounds" << endl;
        exit(1);
    }

    Tdouble dt;
    // First we get the normalized value of the time step :
    dt = m_bocopDefPtr->timeSteps()[i+1] - m_bocopDefPtr->timeSteps()[i];

    // If final time is free, we have to multiply the normalized time found
    // in m_timeSteps by the current final time (which is the last element of VEC)
    Tdouble T_F;
    if (m_bocopDefPtr->freeTime() == "final")	{
        // the last element of the array contains the final time
        T_F = VEC[(m_bocopDefPtr->dimSteps()*this->m_dimProblem)+m_bocopDefPtr->dimState()+m_bocopDefPtr->dimOptimVars()-1];
    }
    else {
        T_F = m_bocopDefPtr->finalTime();
    }

    // We compute the unnormalized value (time step in [t0;tf]) :
    dt *= (T_F-m_bocopDefPtr->initialTime());

    return dt;
}


// ***************************************
// *****    Get unnormalized time    *****
// ***************************************

/** 
 * \fn BocopProblem::UnnormalizedTime(const double normalized_time, const Tdouble T_F)
 *
 * \param normalized_time
 * \param T_F final time
 *
 * All time arrays in Bocop are normalized values between 0 and 1.
 * When calling the functions, we want to get the actual times, between t0 and tf.
 */
template<class Tdouble> Tdouble BocopProblem::UnnormalizedTime(const double normalized_time, const Tdouble T_F)
{
    Tdouble regular_time = m_bocopDefPtr->initialTime() + normalized_time*(T_F-m_bocopDefPtr->initialTime());
    return regular_time;
}


/*
template<class Tdouble> void BocopProblem::getInterpolatedStateAtStep(const Tdouble* VEC, const double time, Tdouble* y_interp)
{

    // locate index of time interval containing t
    int i = locateInArray(time,m_bocopDefPtr->m_timeSteps,m_bocopDefPtr->m_dimStep+1);

    if (i < 0)
        getStateAtStep(VEC,0,y_interp);
    else
    {
    // get the two states around t
    Tdouble y0[m_bocopDefPtr->m_dimState];
    getStateAtStep(VEC,i,y0);
    Tdouble y1[m_bocopDefPtr->m_dimState];
    getStateAtStep(VEC,i+1,y1);

    // interpolate (linear)
    double t0 = m_bocopDefPtr->m_timeSteps[i];
    double t1 = m_bocopDefPtr->m_timeSteps[i+1];
    double alpha = (time - t0) / (t1 - t0);
    for (int i=0;i<m_bocopDefPtr->m_dimState;i++)
        y_interp[i] = (1e0 - alpha) * y0[i] + alpha * y1[i];

    }
}
*/





#endif
