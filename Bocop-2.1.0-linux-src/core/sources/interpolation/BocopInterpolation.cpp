// This code is published under the Eclipse Public License
// File: BocopInterpolation.cpp
// Authors: Vincent Grelard, Pierre Martinon
// Inria Saclay and Cmap Ecole Polytechnique
// 2011-2016

#include <cstdlib>
#include <iostream>
#include <string>
#include <fstream>

#include "BocopInterpolation.hpp"
#include "tools.hpp"

using namespace std;

/**
 *\fn BocopInterpolation::BocopInterpolation()
 * Default constructor.
 */
BocopInterpolation::BocopInterpolation()
{
    this->n = 0;
    this->x = 0;
    this->y = 0;
    this->tables_filled = false;
}

/**
 *\fn BocopInterpolation::BocopInterpolation(const GenerationVariable& gen_var)
 * Constructor.
 */
BocopInterpolation::BocopInterpolation(const GenerationVariable& gen_var)
{
    // First we get the number of interpolation points stored in
    // gen_var, and allocate the same amount of space in the current
    // instance of BocopInterpolation :
    this->n = gen_var.GetDimension();
    this->x = new double[this->n];
    this->y = new double[this->n];

    // Then we copy the values from gen_var, to our instance :
    gen_var.GetVar(this->y);
    gen_var.GetT(this->x);

    this->tables_filled = true;

}

/**
 *\fn BocopInterpolation::~BocopInterpolation()
 * Destructor.
 */
BocopInterpolation::~BocopInterpolation()
{
    if (this->x != 0)
        delete[] x;
    if (this->y != 0)
        delete[] y;
}

/**
 *\fn void BocopInterpolation::FillTables(const int N, const double* X, const double* Y)
 */
void BocopInterpolation::FillTables(const int N, const double* X, const double* Y)
{
    // dimension of the interpolation table :
    this->n = N;

    // Memory allocation :
    this->x = new double[this->n];
    this->y = new double[this->n];

    // We now fill the arrays :
    for (int i = 0; i < this->n; ++i)
        this->x[i] = X[i];

    for (int i = 0; i < this->n; ++i)
        this->y[i] = Y[i];

    this->tables_filled = true;

}

/**
 *\fn void BocopInterpolation::TestInterpolation(const int dim_interp, const double x_lo, const double x_hi, double* y_interp) const
 * This function allows to check that the interpolation is correct.
 * It returns values computed from the tables given, evaluated at
 * new x_test points :
 */
void BocopInterpolation::TestInterpolation(const int dim_interp, const double x_lo, const double x_hi, double* y_interp) const
{
    // We build the new array of interpolation points,
    // separated with an equal constant step :
    double* x_interp;
    x_interp = new double[dim_interp];
    double h = (x_hi - x_lo) / (dim_interp - 1);
    for (int i = 0; i < dim_interp; ++i)
        x_interp[i] = x_lo + i * h;

    // Now we compute the interpolation :
    for (int i = 0; i < dim_interp; ++i)
        GetValueInterp(x_interp[i], &y_interp[i]);
}

/**
 *\fn void BocopInterpolation::TestInterpolation(const int dim_interp, const double x_lo, const double x_hi, string name_file_out) const
 * This function allows to check that the interpolation is correct.
 * It returns values computed from the tables given, evaluated at
 * new x_test points.
 */
void BocopInterpolation::TestInterpolation(const int dim_interp, const double x_lo, const double x_hi, string name_file_out) const
{

    double val;

    // We build the new array of interpolation points,
    // separated with an equal constant step :
    double* x_interp;
    x_interp = new double[dim_interp];
    double h = (x_hi - x_lo) / (dim_interp - 1);
    for (int i = 0; i < dim_interp; ++i)
        x_interp[i] = x_lo + i * h;

    ofstream file_out(name_file_out.c_str(), ios::out);

    for (int i = 0; i < dim_interp; ++i) {
        GetValueInterp(x_interp[i], &val);
        file_out << x_interp[i] << " " << val << endl;
    }

    file_out.close();

}

/**
 *\fn int BocopInterpolation::GetArrayInterp(const int dim, const double* x_interp, double* y_interp) const
 * This function returns the value of the interpolation function
 * at a given points x_interp (array of x-axis points)
 */
int BocopInterpolation::GetArrayInterp(const int dim, const double* x_interp, double* y_interp) const
{
    for (int i = 0; i < dim; ++i)
        GetValueInterp(x_interp[i], &y_interp[i]);

    return 0;
}

