// Copyright (C) 2012 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: parametrizedcontrol.hpp
// Authors: Pierre Martinon

#ifndef PARAMETRIZEDCONTROL_HPP
#define PARAMETRIZEDCONTROL_HPP


#include "tools.hpp"

template<class Tdouble> Tdouble parametrizedcontrol(const int flag, const int nbintervals, const int degree, const Tdouble* coeffs,
                                                    const double normalizedTime, const double initial_time, const double final_time);
template<class Tdouble> Tdouble polynomialcontrol(const int degree, const Tdouble* localcoeffs, const double localtime);
template<class Tdouble> Tdouble trigonometriccontrol(const int degree, const Tdouble* coeffs, const double realtime);
template<class Tdouble> void junctionconditions(const int flag, const int nbintervals, const int degree, const Tdouble* coeffs,
                                                const double initial_time, const double final_time, Tdouble* junctions);


template<class Tdouble> Tdouble parametrizedcontrol(const int flag, const int nbintervals, const int degree, const Tdouble* coeffs,
                                                    const double normalizedTime, const double initial_time, const double final_time)
{
    Tdouble control = 0.0;
    double realtime = initial_time + normalizedTime*(final_time - initial_time);
    int position;

    switch(flag)
    {
    case 1:
    {
        //build uniform time grid for control (use separate grid later !)
        double *controltimes = new double[nbintervals+1];
        double step = (final_time - initial_time) / nbintervals;
        for (int i=0; i<=nbintervals; i++)
            controltimes[i] = i*step;

        //determine local control interval
        position = 1;
        while((normalizedTime>double(position)/double(nbintervals)) & (position<nbintervals)){position++;}

        //compute polynomial control
        const Tdouble *localcoeffs = coeffs + (position-1)*(degree+1);
        double localtime = realtime - controltimes[position-1];
        control = polynomialcontrol(degree,localcoeffs,localtime);
        break;
    }

    case 2:
    {
        control = trigonometriccontrol(degree,coeffs,realtime);
        break;
    }

    default:
        cout << "ERROR: Parametrizedcontrol >>> Unknown value for control type (1:polynomial 2:trigonometric):" << flag <<  endl;
    }

    return control;
}




// Evaluate parametrized control: polynomial case
template<class Tdouble> Tdouble polynomialcontrol(const int degree, const Tdouble* localcoeffs, const double localtime)
{
    Tdouble control = localcoeffs[0];

    for (int i=1;i<=degree;i++)
        control += localcoeffs[i] * pow(localtime,i);

    return control;
}

// Evaluate parametrized control: trigonometric case
template<class Tdouble> Tdouble trigonometriccontrol(const int degree, const Tdouble* coeffs, const double realtime)
{
    Tdouble control = coeffs[0];

    for (int i=1; i<=degree; i++)
        control += coeffs[2*(i-1)+1]*cos(i*realtime) + coeffs[2*(i-1)+2]*sin(i*realtime);

    return control;
}



// Evaluate junctions conditions (continuity)
template<class Tdouble> void junctionconditions(const int flag, const int nbintervals, const int degree, const Tdouble* coeffs,
                                                const double initial_time, const double final_time, Tdouble* junctions)
{
    //use separate grid later !
    //build uniform time grid for control
    double *controltimes = new double[nbintervals+1];
    //double step = tf / nbintervals;
    double step = (final_time - initial_time) / nbintervals;
    for (int i=0; i<=nbintervals; i++)
        controltimes[i] = i*step;

    // compute junctions
    for (int i=0; i<=nbintervals-2; i++)
    {
        int position = i;
        double hi = controltimes[position+1] - controltimes[position];
        Tdouble u1 = polynomialcontrol(degree,coeffs + position*(degree+1),hi);
        double zero = 0.0;
        Tdouble u0 = polynomialcontrol(degree,coeffs + (position+1)*(degree+1),zero);
        junctions[i] = u0 - u1;
    }

}

#endif
