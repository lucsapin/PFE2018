// Copyright (C) 2011 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: bocop_solution.hpp
// Authors: Vincent Grélard, Daphne Giorgi

#ifndef __BOCOPSOLUTION_HPP__
#define __BOCOPSOLUTION_HPP__

#include <QObject>
#include <vector>
#include <string>
#include <fstream>


using namespace std;

class BocopSolution : public QObject
{
    Q_OBJECT

private :

    string sol_file;
    
    int dim_state;
    int dim_control;
    int dim_algebraic;
    int dim_optimvars;
    int dim_constants;
    int dim_ifcond;
    int dim_pathcond;
    
    int dim_steps;
    int dim_stepsAfterMerge;
    int dim_stages;

    double objective;
    double constr_viol;

    string m_timeFree;
    double m_initialTime;
    double m_finalTime;
    
    double* time_steps;
    double* time_stages;
    
    double** state;
    double** control;
    double** averageControl;
    double** algebraic;
    double* optimvars;
    double* constants;

    double** ifcond;
    double** bound_pathcond;
    double** pathcond;
    double** dyncond;

    double* ifcondMultipliers;
    double** pathcondMultipliers;
    double** dyncondMultipliers;

    double* coeff_b_i;

    // names :
    vector<string> names;
    
    
    // error variables :
    string m_errorString;
    string m_warningString;
    bool m_isWarning;
    
    // functions :
    int readDefinitionComments(void);
    int readDimensions(void);
    int allocateVectors(void);
    int readVariablesAndConstraints(void);
    int calculateAverageControl(void);
    void skipComments(ifstream&);
    
    
public :
    BocopSolution(string);
    ~BocopSolution();

    int readSolutionFile(void);
    
    int dimState(void) const {return dim_state;}
    int dimControl() const {return dim_control;}
    int dimAlgebraic() const {return dim_algebraic;}
    int dimOptimvars() const {return dim_optimvars;}
    int dimConstants() const {return dim_constants;}
    int dimInitFinalCond() const {return dim_ifcond;}
    int dimPathConstraints() const {return dim_pathcond;}
    int dimSteps() const {return dim_steps;}
    int dimStepsAfterMerge() const {return dim_stepsAfterMerge;}
    int dimStages() const {return dim_stages;}

    double valObjective() const {return objective;}
    double valConstrViol() const {return constr_viol;}

    string timeFree() const {return m_timeFree;}
    double initialTime() const {return m_initialTime;}
    double finalTime() const {return m_finalTime;}

    double* pointerSteps() const {return time_steps;}
    double* pointerStages() const {return time_stages;}

    double* pointerState(int i) const {return state[i];}
    double* pointerControl(int i) const {return control[i];}
    double* pointerAverageControl(int i) const {return averageControl[i];}
    double* pointerAlgebraic(int i) const {return algebraic[i];}
    double* pointerPathConstraint(int i) const {return pathcond[i];}
    double* pointerDynamicConstraint(int i) const {return dyncond[i];}
    double* pointerPathConstrMultiplier(int i) const {return pathcondMultipliers[i];}
    double* pointerDynamicConstrMultiplier(int i) const {return dyncondMultipliers[i];}

    double** pointerAllState() const {return state;}
    double** pointerAllControl() const {return control;}
    double** pointerAllAverageControl() const {return averageControl;}
    double** pointerAllAlgebraic() const {return algebraic;}
    double** pointerAllPathConstraint() const {return pathcond;}
    double** pointerAllDynamicConstraint() const {return dyncond;}
    double** pointerAllPathConstrMultiplier() const {return pathcondMultipliers;}
    double** pointerAllDynamicConstrMultiplier() const {return dyncondMultipliers;}

    double lowerBoundPathConstraint(int i) const {return bound_pathcond[i][0];}
    double upperBoundPathConstraint(int i) const {return bound_pathcond[i][1];}
    double typeBoundPathConstraint(int i) const {return bound_pathcond[i][2];}

// Pass bound variable???
//    double lowerBoundVariable(int i) const {return ifcond[i][0];}
//    double upperBoundVariable(int i) const {return ifcond[i][1];}
//    double typeBoundVariable(int i) const {return ifcond[i][2];}

    double valStep(int i) const {return time_steps[i];}
    double valStage(int i) const {return time_stages[i];}
    double valOptimVar(int i) const {return optimvars[i];}
    double valInitFinalCond(int i, int j) const {return ifcond[i][j];}
    double valState(int i, int j) const {return state[i][j];}
    double valInitFinalCondMultiplier(int i) const {return ifcondMultipliers[i];}

    double getCoeff_b(int i) const {return coeff_b_i[i];}

    string nameState(int i) const {return names[i];}
    //    string nameControl(int i) const {return names[dim_state+i];}
    //    string nameAlgebraic(int i) const {return names[dim_state+dim_control+i];}
    //    string nameOptimVar(int i) const {return names[dim_state+dim_control+dim_algebraic+i];}
    string nameVar(int, int) const;
    
    string errorString(void) const {return m_errorString;}
    string warningString(void) const {return m_warningString;}
    bool isWarning(void) const {return m_isWarning;}

signals :
    void loading_begin(void);
    void loading_end(void);
    void loaded(int);
    
};

#endif
