// Function for the measure of the problem
// phi(tk,y(tk))

// The following are the input and output available variables
// for the measures of your optimal control problem.

// Input :
// dataSetIndex : index of the observation file which the measure refers to
// dim_time_observation : number of the observation times
// time : current time (t)
// dim_state : dimension of vector of state variables
// state : vector of state variables
// dim_constants : dimension of vector of constants
// constants : vector of constants
// dim_optimvars : dimension of vector of optimization parameters
// optimvars : vector of optimization parameters 
// dim_measures : dimension of vector of observations and of vector of measures
// observations : vector of the observations for file dataSetIndex, at current time

// Output :
// measures : vector giving the theoretical measure, this vector has the
// same dimension of the vector of observations corresponding to file k

// The functions of your problem have to be written in C++ code
// Remember that the vectors numbering in C++ starts from 0
// (ex: the first component of the vector state is state[0])

// Tdouble variables correspond to values that can change during optimization:
// states and optimization parameters.
// Values that remain constant during optimization use standard types (double, int, ...).

#include "header_measure"
{
// MEASURES FOR JACKSON PROBLEM

switch (dataSetIndex) {
    case 0 :
        measures[0] = pow(state[0] - observations[0] ,2);
        measures[0]+= pow(state[1] - observations[1] ,2);
        break;
    case 1 :
        measures[0] = pow(state[2] - observations[0] ,2);
        break;
}
}

