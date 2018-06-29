// Copyright (C) 2011 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: BocopSplinesInterpolation.cpp
// Authors: Andrea Walther, Vincent Grélard

#include <cstdlib>
#include <iostream>
#include <string>
#include <fstream>

using namespace std;

#include "BocopInterpolation.hpp"
#include "tools.hpp"

/**
 *\fn BocopSplinesInterpolation::BocopSplinesInterpolation()
 * Default constructor.
 */
BocopSplinesInterpolation::BocopSplinesInterpolation()
{
    this->yp_left = 1.0e30;
    this->yp_right = 1.0e30;

    this->ypp = 0;
    this->splines_tables_filled = false;
}

/**
 *\fn BocopSplinesInterpolation::BocopSplinesInterpolation(const GenerationVariable& gen_var)
 * Constructor.
 */
BocopSplinesInterpolation::BocopSplinesInterpolation(const GenerationVariable& gen_var) :
    BocopInterpolation(gen_var)
{
    this->ypp = 0;
    this->splines_tables_filled = false;

    this->yp_left = 1.0e30;
    this->yp_right = 1.0e30;

    // Then we compute the second derivatives :
    ComputeSecDeriv();
}

/**
 *\fn BocopSplinesInterpolation::~BocopSplinesInterpolation()
 * Destructor.
 */
BocopSplinesInterpolation::~BocopSplinesInterpolation()
{
    if (this->ypp != 0)
        delete[] this->ypp;
}

/**
 *\fn void BocopSplinesInterpolation::SetInterpolationTables(const int N, const double* X, const double* Y)
 * Fill tables and compute second derivatives.
 */
void BocopSplinesInterpolation::SetInterpolationTables(const int N, const double* X, const double* Y)
{
    // First we fill the data tables :
    FillTables(N, X, Y);

    // Then we compute the second derivatives :
    ComputeSecDeriv();
}

/**
 *\fn void BocopSplinesInterpolation::ComputeSecDeriv()
 * Compute second derivatives of the function at each interpolation point. The result is returned in member y_pp,
 * and the arguments of the function are the boundary conditions to compute the second derivatives. 
 * Indeed two equations are missing in the recursive conditions, so we need two more arbitrary conditions.
 */
void BocopSplinesInterpolation::ComputeSecDeriv()
{
    if (this->tables_filled == false) {
        cerr << " BocopSplinesInterpolation::ComputeSecDeriv : ERROR." << endl;
        cerr << " You cannot call this function before running FillTables" << endl;
        exit(1);
    }

    int i;
    double sig, p;
    double qn, un;

    // First we allocate memory for the second derivatives array :
    this->ypp = new double[this->n];

    // We create a new dummy array :
    double* u =  new double[this->n - 1];

    // the lower boundary condition is set either to be natural,
    // or else to have a specified first derivative :
    if (yp_left > 0.99e30) {
        ypp[0] = 0.0;
        u[0] = 0.0;
    } else {
        ypp[0] = -0.5;
        u[0] = (3.0 / (x[1] - x[0])) * ((y[1] - y[0]) / (x[1] - x[0]) - yp_left);
    }

    // Decomposition loop for the triagonal algorithm :
    for (i = 1; i < n - 1; ++i) {
        sig = (x[i] - x[i - 1]) / (x[i + 1] - x[i - 1]);
        p = sig * ypp[i - 1] + 2;
        ypp[i] = (sig - 1.0) / p;
        u[i] = (y[i + 1] - y[i]) / (x[i + 1] - x[i]) - (y[i] - y[i - 1]) / (x[i] - x[i - 1]);
        u[i] = (6.0 * u[i] / (x[i + 1] - x[i - 1]) - sig * u[i - 1]) / p;
    }

    // the upper boundary condition is set either to be natural,
    // or else to have a specified first derivative :
    if (yp_right > 0.99e30) {
        qn = 0.0;
        un = 0.0;
    } else {
        qn = -0.5;
        un = (3.0 / (x[n - 1] - x[n - 2])) * ((y[n - 1] - y[n - 2]) / (x[n - 1] - x[n - 2]) - yp_right);
    }


    // Finally, we get the second derivatives :
    ypp[n - 1] = (un - qn * u[n - 2]) / (qn - ypp[n - 2] + 1.0);
    for (i = n - 2; i >= 0; --i)
        ypp[i] = ypp[i] * ypp[i + 1] + u[i];

    delete[] u;

    this->splines_tables_filled = true;
}


// This function returns the value of the interpolation function
// at a given point x_interp. It can be called only if the
// interpolation tables have been filled, and the second derivatives
// have been computed :
/**
 *\fn void BocopSplinesInterpolation::GetValueInterp(const double x_interp, double* y_interp) const
 * Computes the interpolated value y_interp at the given point x_interp by bisection method, using the previously computed second derivatives.
 */
void BocopSplinesInterpolation::GetValueInterp(const double x_interp, double* y_interp) const
{
    if (this->splines_tables_filled == false) {
        cerr << " BocopSplinesInterpolation::GetValueInterp : ERROR." << endl;
        cerr << " You cannot call this function before running SetInterpolationTables" << endl;
        *y_interp = 0;
        return;
    }

    // Bisection method to find the polynomial :
    int klo = 0;
    int khi = this->n - 1;
    int k = 0;

    while (khi - klo > 1) {
        k = (khi + klo) / 2;
        if (this->x[k] > x_interp)
            khi = k;
        else
            klo = k;
    }

    double h;
    h = this->x[khi] - this->x[klo];
    if (h == 0.0) {
        cerr << " BocopSplinesInterpolation::GetValueInterp : ERROR." << endl;
        cerr << " x was found to belong to an empty interval. Interval " << endl;
        cerr << " between x_inf and x_sup is zero." << endl;
        *y_interp = 0;
        exit(1);
    }

    // Now we can compute the interpolated value :
    double a, b;
    a = (this->x[khi] - x_interp) / h;
    b = (x_interp - this->x[klo]) / h;

    *y_interp = a * this->y[klo] + b * this->y[khi] + ((a * a * a - a) * ypp[klo] + (b * b * b - b) * ypp[khi]) * (h * h) / 6.0;
}

