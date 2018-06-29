// Copyright (C) 2011-2013 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: GenerationVariable.hpp
// Authors: Vincent Grelard, Daphne Giorgi

#ifndef GENERATION_VARIABLE_H
#define GENERATION_VARIABLE_H

#include <iostream>
#include <fstream>
#include <string>
#include <cstdlib>
#include <memory> // pour std::auto_ptr
#include <sys/stat.h> // for mkdir

#include "tools.hpp"

using namespace std;


/**
 * \file GenerationVariable.hpp
 * \brief Class GenerationVariable header.
 * \author Vincent Grelard
 * \date 06/2012
 *
 * Stores data points that can later be used to perform an interpolation.
 * Implements methods to read Bocop initialization files.
 *
 */

/**
 * \class GenerationVariable
 * \brief Initialization data: points and interpolation method
 *
 * Stores data points that can later be used to perform an interpolation.
 * Implements methods to read Bocop initialization files.
 *
 */
class GenerationVariable
{
    protected :
        /** @name Interpolation data */
        /** number of given sample data points */
        int dim_gen;
        /** type of interpolation (constant, linear, or splines) */
        string type_interp;
        /** y-axis data points : the values of the function at given sample points */
        double* var_gen;
        /** x-axis sample points (var_gen = f(t_gen)) */
        double* t_gen;


        /** Method to allocate space in memory for the gen arrays */
        void allocate_gen_mem();

        /** Method to create a default initialization file */
        int default_init_file(const string) const;

        /** Method to read Bocop constant initialization file */
        int ReadConstantInit(const string);
        /** Method to read Bocop interpolation (linear or splines) initialization file */
        int ReadInterpInit(const string);

    public :
        /** @name Constructors and destructor */
        GenerationVariable();
        GenerationVariable(const int);
        GenerationVariable(const GenerationVariable& genVar);
        ~GenerationVariable();

        void operator=(const GenerationVariable& genVar);

        /** @name Set methods */
        int SetFromInitFile(const string);
        int SetFromFile(const string, const int, const double*, istream&);
        int SetCopyFromArray(const double*, const double*);

        void EchoGenVar(void);

        /** @name Get methods */
        int GetDimension(void) const;
        void GetVar(double*) const;
        void GetT(double*) const;
        int GetTypeInterp(void) const;
        string getGenType() const {
            return type_interp;
        }
};

// typedef of a smart pointer to GenerationVariable objects
typedef auto_ptr<GenerationVariable> genVarPtr;   // warning : this is the std smart pointer, which cannot be copied

#endif

