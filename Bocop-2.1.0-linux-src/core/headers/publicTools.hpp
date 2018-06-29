// This code is published under the Eclipse Public License
// Authors: Vincent Grelard, Pierre Martinon, Olivier Tissot
// Inria Saclay and CMAP Ecole Polytechnique
// 2014-2016

#ifndef PUBLICTOOLS_H
#define PUBLICTOOLS_H

#include <iostream>
#include <string>
#include <fstream>
#include <sstream>
#include <vector>
#include <cmath>
#include <cstdlib>

using namespace std;

/**
* \file publicTools.hpp
* \brief public tools header
* \author Pierre Martinon, Olivier Tissot
* \date 2/2015
*
* This file provides methods which can be used in problem functions definition files.
*/

/**
* \class CSVRow
* \brief Represent a row of a CSV file
*
* This class represent a row of a CSV file. It is used in readCSVFileToVector().
* Please note that the default separator char is ';'. So if the CSV is formated
* with ',' you have to specify the separator or else it won't work.
*
* \author Olivier Tissot
* \date 1/2015
*/
class CSVRow
{
    public:
        CSVRow(const char); /**< Constructor from parsing char. */
        std::string const& operator[](size_t index) const; /**< Acces operator to parsed row. */
        size_t size() const; /**< The size of the row. */
        void readNextRow(std::istream& str); /**< Read and parse a CSV row. */
    private:
        std::vector<std::string>    m_data; /**< CSV row data. */
        const char        m_separator; /**< Parsing char. */
};

istream& operator>>(istream &file, CSVRow &row);
istream& safeGetLine(istream &file, string &line);
int readFileToVector(const string filename, vector<double> &v, const int verbose = 1);
int readCSVToVector(const string filename, vector<double> &v, const int nbCol, const char separator=';');
int readCSVToVector(const string filename, vector<double> &v, const string colName, const char separator=';');
double normalizedTimeInterpolation(const double, const std::vector<double>&);
int locate(const double x_value, const vector<double> &x_data);
int locateInArray(const double x_value, const double* x_data, const int data_size);


// declarations of template functions
template<class Tdouble> Tdouble interpolation(const double x_value, const vector<double> &x_data, const vector<Tdouble> &y_data, const int set_data_size = 0, const int verbose = 1);
template<class Tdouble> Tdouble interpolation2D(const Tdouble x_value, const double y_value, const vector<double>& x_data, const vector<double>& y_data,const vector<vector<double> > &z_data);
template<class Tdouble> Tdouble phia(const double a, const double k, const Tdouble x);
template<class Tdouble> Tdouble phib(const double b, const double k, const Tdouble x);
template<class Tdouble> Tdouble phiab(const double a, const double b, const double k, const Tdouble x);


// definitions of template functions


template<class Tdouble> Tdouble interpolation2D(const Tdouble x_value, const double y_value, const vector<double>& x_data, const vector<double>& y_data,const vector<vector<double> > &z_data)
{
//dummy function for consistency with HJB
return x_value;
}

template<class Tdouble> Tdouble interpolation(const double x_value, const vector<double> &x_data, const vector<Tdouble> &y_data, const int set_data_size, const int verbose)
{
    Tdouble y_value;
    int data_size;

    // check for equal vectors size when size is set to auto
    if (set_data_size == 0 && x_data.size() != y_data.size())
    {
      cout << "Error: interpolation between vectors with different size: " << x_data.size() << " and " << y_data.size() << endl;
      exit(-66);
    }

    // set x data size
    if (set_data_size == 0)
        data_size = (int) x_data.size();
    else
        data_size = set_data_size;

    // locate position of x_value in x_data
    //int index = locate(x_value, x_data, data_size);
    int index = locateInArray(x_value, x_data.data(), data_size);

    // out of bounds; take value of lower / upper bound
    if (index == -1) {
        if (verbose > 0) 
			cout << "Warning: the x_value you specified for interpolation is below upper bound of x_data.\nx_value = " << x_value << "<" << x_data[0] << " = x_data lower bound." << endl;
        y_value = y_data[0];
    }
    else if (index == -2) {
		if (verbose > 0)
			cout << "Warning: the x_value you specified for interpolation is above upper bound of x_data.\nx_value = " << x_value << ">" << x_data[data_size-1] << " = x_data upper bound." << endl;
        y_value = y_data[data_size-1];
    }
    else {
        // Linear interpolation
        double alpha = (x_value - x_data[index]) / (x_data[index+1] - x_data[index]);
        y_value = (1e0 - alpha) * y_data[index] + alpha * y_data[index+1];
    }

    return y_value;
}


template<class Tdouble> Tdouble phia(const double a, const double k, const Tdouble x)
{
    double pi = 3.141592653589793e0;
    Tdouble f = atan(k*(x-a)) / pi + 0.5e0;
    return f;
}

template<class Tdouble> Tdouble phib(const double b, const double k, const Tdouble x)
{
    double pi = 3.141592653589793e0;
    Tdouble f = atan(k*(b-x)) / pi + 0.5e0;
    return f;
}

template<class Tdouble> Tdouble phiab(const double a, const double b, const double k, const Tdouble x)
{
    Tdouble f = phia(a,k,x) * phib(b,k,x);
    return f;
}



#endif
