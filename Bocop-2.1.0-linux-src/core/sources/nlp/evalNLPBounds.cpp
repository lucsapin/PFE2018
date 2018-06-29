// Copyright (C) 2011 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: evalNLPBounds.cpp
// Authors: Vincent Grelard, Daphne Giorgi

#include <BocopProblem.hpp>

using namespace std;

// We set an new value for infinity. This value must be greater than the
// one set in IPOPT //!!! a faire : lien entre MY_INF et IPOPT
const double MY_INF = 2e19;

/**
 * \fn bool BocopProblem::get_bounds_info(Index n, Number* x_l, Number* x_u,
                                   Index m, Number* g_l, Number* g_u)
 *
 * Compute bounds for the discretized constraints of the problem. This function fills the bounds vectors from class Problem for variables (y,u,z,p)
 * and constraints (i&f, path constraints, dynamic constraints). Bounds values are read in file problem.bounds, so this file must have a standard format. 
 * For each discretized variable or constraint, we must set lower and upper bounds.
 */
bool BocopProblem::get_bounds_info(Index n, Number* x_l, Number* x_u,
                                   Index m, Number* g_l, Number* g_u)
{
    int i, j, l;

    // *********************
    // *****  WRITING  *****
    // *********************

    // ***** CONSTRAINTS *****

    // We now need to fill the discretized vectors for the bounds.
    // The indices of these vectors must match those of vector constraints_vector.
    // Indeed, at each constraints, we associate a lower and an upper bound

    // At the beginning of the vector, we find the boundary conditions
    int ind_constr = 0;
    double lower, upper;
    for (i = 0; i < m_bocopDefPtr->dimInitFinalCond(); ++i) {
        m_bocopDefPtr->lowerBoundInitFinalCond(i, lower);
        g_l[ind_constr] = lower;
        m_bocopDefPtr->upperBoundInitFinalCond(i, upper);
        g_u[ind_constr] = upper;
        ind_constr++;
    }

    // Then a loop over the time discretization, with the path and dynamic
    // constraints at each time step.
    for (l = 0; l < m_bocopDefPtr->dimSteps(); ++l) {
        // Path constraints :
        for (i = 0; i < m_bocopDefPtr->dimStages(); ++i) {
            for (j = 0; j < m_bocopDefPtr->dimPathConstraints(); ++j) {
                m_bocopDefPtr->lowerBoundPathConstraint(j, lower);
                g_l[ind_constr] = lower;
                m_bocopDefPtr->upperBoundPathConstraint(j, upper);
                g_u[ind_constr] = upper;
                ind_constr++;
            }
        }

        // Dynamics :
        // all the equations are equal to zero :
        // y(t_l+1)-y(t_l)=0
        for (j = 0; j < m_bocopDefPtr->dimState(); ++j) {
            g_l[ind_constr] = 0.;
            g_u[ind_constr] = 0.;
            ind_constr++;
        }

        // k_i - f() = 0
        for (i = 0; i < m_bocopDefPtr->dimStages(); ++i) {
            for (j = 0; j < m_bocopDefPtr->dimState(); ++j) {
                g_l[ind_constr] = 0.;
                g_u[ind_constr] = 0.;
                ind_constr++;
            }
        }
    }


    // ***** VARIABLES *****

    // Now we do the same for the bounds on the variables :

    // We set dimVars = m_bocopDefPtr->dimState()+m_bocopDefPtr->dimControl()+m_bocopDefPtr->dimAlgebraic(), in order to add the bounds on X at each discretization point
    // Indeed, as parameters p are added at the end of X, we don't need them at each step.
    int ind_vars = 0;

    for (l = 0; l < m_bocopDefPtr->dimSteps(); ++l) {
        // first the bounds on y :
        for (j = 0; j < m_bocopDefPtr->dimState(); ++j) {
            m_bocopDefPtr->lowerBoundVariable(j, lower);
            x_l[ind_vars] = lower;
            m_bocopDefPtr->upperBoundVariable(j, upper);
            x_u[ind_vars] = upper;
            ind_vars++;
        }

        // then the bounds on u and k at each stage :
        for (i = 0; i < m_bocopDefPtr->dimStages(); ++i) {
            // we get the bounds on u from the file :
            for (j = 0; j < m_bocopDefPtr->dimControl(); ++j) {
                m_bocopDefPtr->lowerBoundVariable(m_bocopDefPtr->dimState() + j, lower);
                x_l[ind_vars] = lower;
                m_bocopDefPtr->upperBoundVariable(m_bocopDefPtr->dimState() + j, upper);
                x_u[ind_vars] = upper;
                ind_vars++;
            }

            // k is free :
            for (j = 0; j < m_bocopDefPtr->dimState(); ++j) {
                x_l[ind_vars] = -MY_INF;
                x_u[ind_vars] = MY_INF;
                ind_vars++;
            }

            // now we write the bounds on z :
            for (j = 0; j < m_bocopDefPtr->dimAlgebraic(); ++j) {
                m_bocopDefPtr->lowerBoundVariable(m_bocopDefPtr->dimState() + m_bocopDefPtr->dimControl() + j, lower);
                x_l[ind_vars] = lower;
                m_bocopDefPtr->upperBoundVariable(m_bocopDefPtr->dimState() + m_bocopDefPtr->dimControl() + j, upper);
                x_u[ind_vars] = upper;
                ind_vars++;
            }
        }
    }

    // Now we have to write the bounds on the last point of the discretization (y only) :
    for (j = 0; j < m_bocopDefPtr->dimState(); ++j) {
        m_bocopDefPtr->lowerBoundVariable(j, lower);
        x_l[ind_vars] = lower;
        m_bocopDefPtr->upperBoundVariable(j, upper);
        x_u[ind_vars] = upper;
        ind_vars++;
    }


    // Finally we set the bounds on the parameters :
    for (j = 0; j < m_bocopDefPtr->dimOptimVars(); ++j) {
        m_bocopDefPtr->lowerBoundVariable(m_bocopDefPtr->dimState() + m_bocopDefPtr->dimControl() + m_bocopDefPtr->dimAlgebraic() + j, lower);
        x_l[ind_vars] = lower;
        m_bocopDefPtr->upperBoundVariable(m_bocopDefPtr->dimState() + m_bocopDefPtr->dimControl() + m_bocopDefPtr->dimAlgebraic() + j, upper);
        x_u[ind_vars] = upper;
        ind_vars++;
    }

    return true;
}

