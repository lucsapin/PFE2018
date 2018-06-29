// Copyright (C) 2011 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: BocopInterpolation.hpp
// Authors: Andrea Walther, Vincent Grelard

/**
 * \file BocopInterpolation.hpp
 * \brief Class BocopInterpolation header.
 * \authors Andrea Walther, Vincent Grelard
 *
 */

#ifndef __BOCOPINTERPOLATION_HPP__
#define __BOCOPINTERPOLATION_HPP__

#include <vector>
#include <string>

#include "GenerationVariable.hpp"

/**
 * \class BocopInterpolation
 * \brief Abstract class to interpolate the variables
 * \authors Andrea Walther, Vincent Grelard
 */
class BocopInterpolation
{
    protected :
        int n; // number of interpolation points

        double* x; // array for the interpolation points
        double* y; // array for the interpolation values

        void FillTables(const int, const double*, const double*);
        bool tables_filled;

    public:

        BocopInterpolation();
        BocopInterpolation(const GenerationVariable&);
        virtual ~BocopInterpolation();

        virtual void SetInterpolationTables(const int, const double*, const double*) = 0;

        virtual void GetValueInterp(const double, double*) const = 0;
        int GetArrayInterp(const int, const double*, double*) const;

        void TestInterpolation(const int, const double, const double, double*) const;
        void TestInterpolation(const int, const double, const double, string) const;
// 		void read_constants(void);


};

/**
 * \class BocopSplinesInterpolation
 * \brief Spline interpolation
 */
class BocopSplinesInterpolation : public BocopInterpolation
{
    protected :
        double yp_left, yp_right; // boundary condition
        double* ypp; // second derivatives of the function
        bool splines_tables_filled;

        // Function to compute the second derivatives ;
        void ComputeSecDeriv();

    public :
        BocopSplinesInterpolation();
        BocopSplinesInterpolation(const GenerationVariable&);
        ~BocopSplinesInterpolation();

        void SetInterpolationTables(const int, const double*, const double*);

        void GetValueInterp(const double, double*) const;
};

/**
 * \class BocopLinearInterpolation
 * \brief Linear interpolation
 */
class BocopLinearInterpolation : public BocopInterpolation
{
    protected :
        double* slope_coeff;
        bool linear_tables_filled;

        void ComputeSlope(void);

    public :
        BocopLinearInterpolation();
        BocopLinearInterpolation(const GenerationVariable& gen_var);
        ~BocopLinearInterpolation();

        void SetInterpolationTables(const int, const double*, const double*);

        void GetValueInterp(const double, double*) const;
};

#endif

