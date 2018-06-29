// Copyright (C) 2011, 2012 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: BocopLinearInterpolation.cpp
// Authors: Andrea Walther, Vincent Grelard, Daphne Giorgi

#include <cstdlib>
#include <iostream>
#include <string>
#include <fstream>

using namespace std;

#include "BocopInterpolation.hpp"
#include "tools.hpp"

/**
 *\fn BocopLinearInterpolation::BocopLinearInterpolation()
 * Default constructor.
 */
BocopLinearInterpolation::BocopLinearInterpolation()
{
    this->slope_coeff = 0;
}

/**
 *\fn BocopLinearInterpolation::~BocopLinearInterpolation()
 * Destructor.
 */
BocopLinearInterpolation::~BocopLinearInterpolation()
{
    if (this->slope_coeff != 0)
        delete[] slope_coeff;
}

/**
 *\fn BocopLinearInterpolation::BocopLinearInterpolation(const GenerationVariable& gen_var)
 * Constructor.
 */
BocopLinearInterpolation::BocopLinearInterpolation(const GenerationVariable& gen_var) :
    BocopInterpolation(gen_var)
{
    this->slope_coeff = 0;
    this->linear_tables_filled = false;

    // Then we compute the second derivatives :
    ComputeSlope();
}

/**
 *\fn void BocopLinearInterpolation::ComputeSlope(void)
 * Computes the slope between two points.
 */
void BocopLinearInterpolation::ComputeSlope(void)
{
    if (this->tables_filled == false) {
        cerr << " BocopLinearInterpolation::ComputeSlope : ERROR." << endl;
        cerr << " You cannot call this function before running FillTables" << endl;
        exit(1);
    }

    // We create a new array to store the slope coefficient, between
    // two given points :
    this->slope_coeff = new double[this->n - 1];

    for (int i = 0; i < this->n - 1; ++i)
        this->slope_coeff[i] = (y[i + 1] - y[i]) / (x[i + 1] - x[i]);

    this->linear_tables_filled = true;
}

/**
 *\fn void BocopLinearInterpolation::GetValueInterp(const double x_interp, double* y_interp) const
 * Computes the interpolated value y_interp at the given point x_interp by bisection method, using the previously computed slopes.
 */
void BocopLinearInterpolation::GetValueInterp(const double x_interp, double* y_interp) const
{
    if (this->linear_tables_filled == false) {
        cerr << " BocopLinearInterpolation::GetValueInterp : ERROR." << endl;
        cerr << " You cannot call this function before running ComputeSlope" << endl;
        *y_interp = 0;
        return;
    }

    // If we only have one point, we suppose we have a constant function :
    if (this->n == 1) {
        *y_interp = this->y[0];
        return;
    }
    // Bisection method to find the slope :
    int k_sup, k_inf, k;

    k_inf = 0;
    k_sup = this->n - 1;

    while (k_sup - k_inf > 1) {
        k = (k_sup + k_inf) / 2;
        if (this->x[k] > x_interp)
            k_sup = k;
        else
            k_inf = k;
    }

    double h;
    h = this->x[k_sup] - this->x[k_inf];
    if (h <= 0.0) {
        if (h < -1.0e-6) {
            cerr << x_interp << endl;
            cerr << " BocopLinearInterpolation::GetValueInterp : ERROR." << endl;
            cerr << " x was found to belong to an empty interval. Interval " << endl;
            cerr << " (x_sup-x_inf) is lower or equal to zero." << endl;
            *y_interp = 0;
            return;
        } else {
            *y_interp = this->y[k_inf];
        }
    } else
        // Now we can compute the value of the linear interpolation :
        *y_interp = this->y[k_inf] + slope_coeff[k_inf] * (x_interp - this->x[k_inf]);
}

/**
 *\fn void BocopLinearInterpolation::SetInterpolationTables(const int N, const double* X, const double* Y)
 * Fills the tables and computes the slope.
 */
void BocopLinearInterpolation::SetInterpolationTables(const int N, const double* X, const double* Y)
{
    FillTables(N, X, Y);

    ComputeSlope();
}

