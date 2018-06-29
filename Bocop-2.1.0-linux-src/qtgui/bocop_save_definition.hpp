// Copyright (C) 2011-2014 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: bocop_save_definition.hpp
// Authors: Vincent Grelard, Daphne Giorgi


#ifndef BOCOP_SAVE_DEFINITION_H
#define BOCOP_SAVE_DEFINITION_H

#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <sstream>
#include <QFile>
#include <QTextStream>

using namespace std;

#define MY_INF 2.0e20

class BocopSaveDefinition
{

private :
    string problem_path;

    int dim_state;
    int dim_control;
    int dim_algebraic;
    int dim_optimvars;
    int dim_constants;
    int dim_ifcond;
    int dim_pathcond;

    int dim_steps;
    int dim_stages;

    double t_0;
    double t_f;

    vector<string> name_def;
    vector<string> type_def;
    vector<string> value_def;
    vector<string> delete_def;

    vector<double> constants;

    vector<double> lower_bound, upper_bound;
    vector<string> type_bound;

    // error variables :
    string m_errorString;
    string m_warningString;
    bool m_isWarning;

public :
    BocopSaveDefinition();
    BocopSaveDefinition(string);
    ~BocopSaveDefinition();

    void setProblemPath(string path) {problem_path = path;}

    void setDimState(int dim) {dim_state = dim;}
    void setDimControl(int dim) {dim_control = dim;}
    void setDimAlgebraic(int dim) {dim_algebraic = dim;}
    void setDimOptimVars(int dim) {dim_optimvars = dim;}
    void setDimConstants(int dim) {dim_constants = dim;}
    void setDimInitFinalCond(int dim) {dim_ifcond = dim;}
    void setDimPathCond(int dim) {dim_pathcond = dim;}
    void setDimSteps(int dim) {dim_steps = dim;}
    void setDimStages(int dim) {dim_stages = dim;}

    void setInitialTime(double t) {t_0 = t;}
    void setFinalTime(double t) {t_f = t;}

    int setConstant(const int, const double);

    int setBound(const int, const double, const double, const string);

    int addDefinitionEntry(string, string, string);
    int removeDefinitionEntry(string);
    void showAddedEntries(void) const;


    int writeFiles(void);
    int writeDefinition(void);
    int writeBounds(void);
    int writeConstants(void);
    void skipComments(ifstream&);


    int dimState(void) const {return dim_state;}
    int dimControl() const {return dim_control;}
    int dimAlgebraic() const {return dim_algebraic;}
    int dimOptimvars() const {return dim_optimvars;}
    int dimConstants() const {return dim_constants;}
    int dimInitFinalCond() const {return dim_ifcond;}
    int dimPathConstraints() const {return dim_pathcond;}
    int dimSteps() const {return dim_steps;}
    int dimStages() const {return dim_stages;}

    double initialTime() const {return t_0;}
    double finalTime() const {return t_f;}


    string errorString(void) const {return m_errorString;}
    string warningString(void) const {return m_warningString;}
    bool isWarning(void) const {return m_isWarning;}
};


#endif // BOCOP_SAVE_DEFINITION_H
