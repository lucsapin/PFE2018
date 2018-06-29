// Copyright (C) 2013-2014 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: errorToObservation.tpp
// Authors: Daphne Giorgi, Pierre Martinon, Stephan Maindrault

using namespace std;

#include <functions.hpp>
#include <BocopProblem.hpp>

/**
 * \fn template<class Tdouble> void errorToObservation(const int dimTimeObservation,
 *                                              const Tdouble* timeObservation,
 *                                              const int dimObservation,
 *                                              double const *const *const observations,
 *                                              double const *const *const weightObservations,
 *                                              const int dimState,
 *                                              Tdouble const *const *const states,
 *                                              const int dimOptimvars,
 *                                              const Tdouble* optimvars,
 *                                              const int dimConstant,
 *                                              const double* constants,
 *                                              const string paramIdType,
 *                                              const int k,
 *                                              Tdouble& error)
 *
 * Template function to compute the error to observation.
 */
template<class Tdouble> void errorToObservation(const int dimTimeObservation,
                                                //const Tdouble* timeObservation,
                                                const double* timeObservation,
                                                const int dimObservation,
                                                double const *const *const observations,
                                                double const *const *const weightObservations,
                                                const int dimState,
                                                Tdouble const *const *const states,
                                                const int dimOptimvars,
                                                const Tdouble* optimvars,
                                                const int dimConstant,
                                                const double* constants,
                                                const string paramIdType,
                                                const int k,
                                                Tdouble& error)
{
    // Reset error
    error = 0;

    //Tdouble ti = 0;

    // Dimension of the output array, for user measure function, depending on the parameter identification type
    int dimFunction;
    if (paramIdType == "LeastSquare" || paramIdType == "LeastSquareWithCriterion")
        dimFunction = dimObservation;
    else if (paramIdType == "Manual")
        dimFunction = 1;
    else {
        cout << " errorToObservation : ERROR " << endl;
        cout << " The value of paramid.type is not recognized " << endl;
        cout << " Value read: "+ paramIdType +" Possible values: LeastSquare, LeastSquareWithCriterion and Manual" << endl;
        return;
    }
    Tdouble* measures = new Tdouble[dimFunction];

    // We transpose observations and observations weights, in order to give them in the right order to the measure fct
    double ** observationsTmp = new double*[dimTimeObservation];
    double ** weightObservationsTmp = new double*[dimTimeObservation];
    for (int i=0; i<dimTimeObservation; i++){
        observationsTmp[i] = new double[dimObservation];
        weightObservationsTmp[i] = new double[dimObservation];
        for (int p=0; p<dimObservation; p++){
            observationsTmp[i][p]=observations[p][i];
            weightObservationsTmp[i][p]=weightObservations[p][i];
        }
    }
    // We affect default values to the measures array, in order to check if some elements of the array weren't affected after the call to "measure"
    for (int i=0; i<dimFunction; i++)
        measures[i] = 1e20;

    // For each observation time, calculate the error between the expected measure and the observation
    // and sum these errors
    for (int i=0;i<dimTimeObservation; i++) {
        //ti = timeObservation[i];

        measure(k,
                dimTimeObservation,
                //ti,
                timeObservation[i],
                dimState,
                states[i],
                dimOptimvars,
                optimvars,
                dimConstant,
                constants,
                dimObservation,
                observationsTmp[i],
                measures);

        // We check if the values of measures changed
        for (int p=0; p<dimFunction; p++) {
            if (measures[p] == 1e20) {
                cout << " WARNING : The element " << p << " of the measures array didn't change from its defaut value." << endl;
                cout << "           Please make sure that it didn't fail to be affected." << endl;
                cout << "           Check if you entered the right dimensions in your Measure function." << endl << endl;
                exit(1);
            }
        }

        if (paramIdType == "LeastSquare" || paramIdType == "LeastSquareWithCriterion"){
            for (int p=0; p< dimObservation; p++)
                error += weightObservations[p][i] * pow( measures[p] - observations[p][i] ,2);
        }
        else if (paramIdType == "Manual")
                error += measures[0];
    }

    delete[] measures;
    for (int i=0;i<dimTimeObservation; i++) {
        delete[] observationsTmp[i];
        delete[] weightObservationsTmp[i];
    }
    delete[] observationsTmp;
    delete[] weightObservationsTmp;
}

