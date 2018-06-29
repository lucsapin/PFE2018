// This code is published under the Eclipse Public License
// File: BocopDefinition.hpp
// Authors: Daphne Giorgi, Vincent Grelard, Pierre Martinon
// Inria Saclay and Cmap Ecole Polytechnique
// 2011-2016



#ifndef __BOCOPDEFINITION_HPP__
#define __BOCOPDEFINITION_HPP__

#define EPSILON 1e-10

#include <vector>
#include <string>
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <sstream>
#include <limits>
#include <algorithm>
#include <typeinfo>

#include <boost/smart_ptr/shared_ptr.hpp>
#include "tools.hpp"

using namespace std;

/**
* \class BocopDefinition
* \brief Defines an optimal control problem
* \author Vincent Grelard, Daphne Giorgi
* \version 1.0.3
* \date 06/2012
*
*Defines the optimal control problem, by providing dimensions and names for the variables,
*as well as the functions for the objective, dynamics and constraints.
*/
class BocopDefinition
{
    private :

        // dimensions
        int m_dimState;     /**< Number of state variables. */
        int m_dimControl;   /**< Number of control variables. */
        int m_dimAlgebraic; /**< Number of algebro-differential variables. */
        int m_dimParameter; /**< Number of parameters. */
        int m_dimConstant;  /**< Number of constants. */
        int m_dimBoundCond; /**< Number of boundary conditions. */
        int m_dimPathCond;  /**< Number of path constraint. */

        // time discretization
        string m_freeTime;
        double m_t0; /**< Initial time. */
        double m_tF; /**< Final time. */
        int m_dimStep; /**< Number of discretization steps. */
        string m_discMethod; /**< Name of the discretization method. */
        int m_dimStage; /**< Number of stages of the discretization method, this value is computed. */
        int m_dimStepBeforeMerge; /**< Number of discretization steps before we merge with the observations times. */

        // batch optimization
        string m_optimType; /**< Single or batch optimization. */
        int m_batchType;
        int m_batchIndex;
        int m_batchRange;
        double m_batchStarting;
        double m_batchEnding;
        string m_batchFolder;

        // starting point for NLP
        string m_initMethod; /**< Starting point created from .init or .sol files. */
        string m_initFilename;

        // parameter identification
        string m_paramIdType;
        char m_observationSeparator;
        string m_observationFileName;
        int m_sizeDataSet;

        // paths and filenames
        string m_defFileName;
        string m_boundsFileName;
        string m_constantsFileName;
       // string m_pathToDiscFiles; /**< Path to .disc files. */
        string m_solFilename;

        int m_iterationOutputFrequency; /** Output file frequency for the iterations. */

        /** @name Definition
          * Values found when reading definition file
          */
        vector<string> m_stringName;
        vector<string> m_stringValue;
        vector<string> m_integerName;
        vector<int> m_integerValue;
        vector<string> m_doubleName;
        vector<double> m_doubleValue;
        bool m_flagDefinitionDone;

        /** @name Names	*/
        vector<string> m_stateNames;
        vector<string> m_controlNames;
        vector<string> m_algebraicNames;
        vector<string> m_optimvarsNames;
        vector<string> m_constantNames;
        vector<string> m_boundcondNames;
        vector<string> m_pathcondNames;

        /** @name Boundary conditions
           * Values found reading bounds file
           */
        double* m_lowerVariable;
        double* m_upperVariable;
        string* m_typeVariable;

        double* m_lowerPath;
        double* m_upperPath;
        string* m_typePath;

        double* m_lowerBoundary;
        double* m_upperBoundary;
        string* m_typeBoundary;

        bool m_flagBoundariesDone;

        /** @name Constants */
        double* m_constants;
        bool m_flagConstantsDone;

        /** @name Discretization */
        bool m_flagMethodDone;
        /** Coefficients of the discretization method */
        double** m_discCoeffA;
        double* m_discCoeffB;
        double* m_discCoeffC;

        /** Normalized vectors for the time discretization */
        double* m_timeSteps; /**< For the nodes l. */
        double* m_timeStages; /**< For the stages s. */
        bool m_flagTimesDone;


        /** @name Parameters Identification */
        int* m_dimObservation;
        int* m_dimTimeObservation;
        double** m_timeObservation;
        int** m_indexObservation;
        double*** m_observations;
        double*** m_weightObservations;

        /** @name Error variables if anything went wrong during the definition */
        string m_errorString;
        string m_warningString;
        bool m_isWarning;

        /** @name Function to read definition file */
        int readDefFile(void);
        bool findInDef(const string, int*) const;
        bool findInDef(const string, double*) const;
        bool findInDef(const string, string*) const;
        template<class valueType> void missingDefinition(const string name_in_def, valueType* var, const valueType default_val, const string typeName);

        /** @name Function set time discretization arrays */
        int setTimeSteps(void);
        int setConstTimeSteps(void);
        int setTimeStepsFromFile(const string);
        int setTimeStages(void);

        /** @name Function to get the bounds */
        int allocateBoundsArrays(void);
        int readBoundsFile(void);
        int generateDefaultBounds(void);

        /** @name Functions to read names and misc options */
        int readNames(void);
        int readBatchOptions(void);
        int readParamIdOptions();

    public:
        /** @name Constructors and Destructor */
        BocopDefinition(); /**< Default Constructor. */
        BocopDefinition(const string name_def,
                        const string name_bounds,
                        const string name_const);

        BocopDefinition(const string timeFree,
                        const double t0,
                        const double tF,
                        const int stateDim,
                        const int controlDim,
                        const int algebraicDim,
                        const int parameterDim,
                        const int constantDim,
                        const int boundCondDim,
                        const int pathCondDim,
                        const int discSteps,
                        const string discMethod,
                        const int dimStage,
                        const int dimStepBeforeMerge,
                        const string optimType,
                        const int batchType,
                        const int batchIndex,
                        const int batchRange,
                        const double lowerBound,
                        const double upperBound,
                        const string batchDir,
                        const string initType,
                        const string initFile,
                        const string paramidType,
                        const char paramidSeparator,
                        const string paramidFile,
                        const int paramidDim,
                        const string defFileName,
                        const string boundsFileName,
                        const string constantsFileName,
                        //const string pathToDiscFiles,
                        const string solFileName,
                        const int iterationOutputFrequency,
                        const bool flagDefinitionDone,
                        const vector<string> stateNames,
                        const vector<string> controlNames,
                        const vector<string> algebraicNames,
                        const vector<string> parameterNames,
                        const vector<string> constantNames,
                        const vector<string> boundcondNames,
                        const vector<string> pathcondNames,
                        const bool flagBoundariesDone,
                        const double* lowerVariable,
                        const double* upperVariable,
                        const string* typeVariable,
                        const double* lowerPath,
                        const double* upperPath,
                        const string* typePath,
                        const double* lowerBoundary,
                        const double* upperBoundary,
                        const string* typeBoundary,
                        const bool flagConstantsDone,
                        const double* constants,
                        const bool flagMethodDone,
                        double const* const* const discCoeffA,
                        const double* discCoeffB,
                        const double* discCoeffC); /**< Constructor. */
        BocopDefinition(const BocopDefinition&); /**< Copy constructor. */
        ~BocopDefinition(); /**< Destructor. */

        /** @name Main function to read all files */
        int readAll(void);

        /** @name Definition methods	*/
        int readDefinition(void);

        string getName(const string& name, const int& index);

        /** @name Boundaries methods	*/
        int readBoundaries(void);
        int readBoundsBlock(ifstream& file_bounds, string block_name, int block_dim, string* block_type, double* block_lowerbound, double* block_upperbound);
        int readBoundsSetBlock(ifstream& file_bounds, string block_name, int block_dim, string* block_type, double* block_lowerbound, double* block_upperbound);
        int processBounds(string type, double* lowerbound, double* upperbound);

        /** @name Constants methods	*/
        int readConstants(void);

        /** @name Discretization methods	*/
        //void setPathDiscretization(const string);
        //int readMethod(void);
        void allocateDiscCoeffs();
        int setDiscMethod();

        int readTimes(void);

        /** @name Solution file method	*/
        void setSolutionFile(const string solFileName);

        /** @name Batch optimization methods	*/
        string getOptimizationType(void) const;
        bool getBatchOptions(int& type, int& index, double& lowerBound, double& upperBound, int& n_batch, string& batch_dir, string& init_type) const;
        void setOneConstant(const int, const double);
        void setInOutProperties(const string, const string);

        /** @name Parameter identification methods */
        int readObservations();
        void getParamId(double**, int**, double***, double***, int) const;
        int merge(double**, int*, double*&, int&, int**);


        /** @name Getters	*/
        /** @name Time Getters	*/
        double initialTime(void) const {
            return m_t0;
        }
        double finalTime(void) const {
            return m_tF;
        }
        bool isFinalTimeFree(void) const {
            if (m_freeTime == "final") return true;
            else return false;
        }

        double* timeSteps() const {
            return m_timeSteps;
        } /**< For the nodes l. */
        double* timeStages() const {
            return m_timeStages;
        } /**< For the stages s. */

        string freeTime() const {
            return m_freeTime;
        }

        /** @name Dimension Getters	*/
        int dimState(void) const {
            return m_dimState;
        }
        int dimControl(void) const {
            return m_dimControl;
        }
        int dimAlgebraic(void) const {
            return m_dimAlgebraic;
        }
        int dimOptimVars(void) const {
            return m_dimParameter;
        }
        int dimConstants(void) const {
            return m_dimConstant;
        }
        int dimInitFinalCond(void) const {
            return m_dimBoundCond;
        }
        int dimPathConstraints(void) const {
            return m_dimPathCond;
        }

        int dimSteps(void) const {
            return m_dimStep;
        }
        int dimStages(void) const {
            return m_dimStage;
        }
        int dimStepsBeforeMerge(void) const {
            return m_dimStepBeforeMerge;
        }
        int* dimObservation(void)  {
            return m_dimObservation;
        }
        int* sizeObservation(void) {
            return m_dimTimeObservation;
        }

        /** @name Discretization Getters	*/
        string methodDiscretization(void) const {
            return m_discMethod;
        }
        string methodInitialization(void) const {
            return m_initMethod;
        }

        double** discCoeffA() const {
            return m_discCoeffA;
        }
        double* discCoeffB() const {
            return m_discCoeffB;
        }
        double* discCoeffC() const {
            return m_discCoeffC;
        }

        bool flagMethodDone() const {
            return m_flagMethodDone;
        }

        /** @name File Getters	*/
        string nameSolutionFile(void) const {
            return m_solFilename;
        }
        string nameDefFile(void) const {
            return m_defFileName;
        }
        string nameBoundsFile(void) const {
            return m_boundsFileName;
        }
        string nameConstantsFile(void) const {
            return m_constantsFileName;
        }
        string nameInitializationFile(void) const {
            return m_initFilename;
        }
        int iterationOutputFrequency(void) const {
            return m_iterationOutputFrequency;
        }

        /** @name Path to dir and disc getters */
        //string pathToDiscFiles() const {
        //    return m_pathToDiscFiles;
        //}

        /** @name Constants Getters	*/
        double* constants() const {
            return m_constants;
        }
        int valConstant(const int i, double& value);

        bool flagConstantsDone() const {
            return m_flagConstantsDone;
        }

        /** @name Names Getters	*/
        string nameState(const int i) const;
        string nameControl(const int i) const;
        string nameAlgebraic(const int i) const;
        string nameOptimVar(const int i) const;
        string nameConstant(const int i) const;
        string nameInitFinalCond(const int i) const;
        string namePathConstraint(const int i) const;

        vector<string> stateNames() const {
            return m_stateNames;
        }
        vector<string> controlNames() const {
            return m_controlNames;
        }
        vector<string> algebraicNames() const {
            return m_algebraicNames;
        }
        vector<string> optimVarNames() const {
            return m_optimvarsNames;
        }
        vector<string> constantNames() const {
            return m_constantNames;
        }
        vector<string> initFinalCondNames() const {
            return m_boundcondNames;
        }
        vector<string> pathConstraintNames() const {
            return m_pathcondNames;
        }

        bool flagDefinitionDone() const {
            return m_flagDefinitionDone;
        }

        /** @name Batch Getters	*/
        bool isSingleOptimization(void);
        string optimType() const {
            return m_optimType;
        }
        int typeBatch(void) const {
            return m_batchType;
        }
        int indexBatch(void) const {
            return m_batchIndex;
        }
        int rangeBatch(void) const {
            return m_batchRange;
        }
        double startingBatch(void) const {
            return m_batchStarting;
        }
        double endingBatch(void) const {
            return m_batchEnding;
        }
        string folderBatch(void) const {
            return m_batchFolder;
        }

        /** @name Parameter identification Getters	*/
        bool isParamId();
        string paramIdType() const {
            return m_paramIdType;
        }
        string observationFile() const {
            return m_observationFileName;
        }
        char observationSeparator() const {
            return m_observationSeparator;
        }
        int sizeDataSet(void)  {
            return m_sizeDataSet;
        }

        double*** observations() {
            return m_observations;
        }
        double*** weightObservations() {
            return m_weightObservations;
        }
        int** indexObservation()  {
            return  m_indexObservation;
        }
        double** timeObservation()  {
            return m_timeObservation;
        }


        /** @name Bounds Getters	*/
        int lowerBoundVariable(const int i, double& val) const;
        int upperBoundVariable(const int i, double& val) const;
        int typeBoundVariable(const int i, string& val) const;
        int lowerBoundInitFinalCond(const int i, double& val) const;
        int upperBoundInitFinalCond(const int i, double& val) const;
        int typeBoundInitFinalCond(const int i, string& val) const;
        int lowerBoundPathConstraint(const int i, double& val) const;
        int upperBoundPathConstraint(const int i, double& val) const;
        int typeBoundPathConstraint(const int i, string& val) const;

        double* lowerVariable() const {
            return m_lowerVariable;
        }
        double* upperVariable() const {
            return m_upperVariable;
        }
        string* typeVariable() const {
            return m_typeVariable;
        }
        double* lowerPath() const {
            return m_lowerPath;
        }
        double* upperPath() const {
            return m_upperPath;
        }
        string* typePath() const {
            return m_typePath;
        }
        double* lowerBoundary() const {
            return m_lowerBoundary;
        }
        double* upperBoundary() const {
            return m_upperBoundary;
        }
        string* typeBoundary() const {
            return m_typeBoundary;
        }

        bool flagBoundariesDone() const {
            return m_flagBoundariesDone;
        }


        /** @name Message Getters	*/
        string errorString(void) const {
            return m_errorString;
        }
        string warningString(void) const {
            return m_warningString;
        }
        bool isWarning(void) const {
            return m_isWarning;
        }
};

// typedef of a smart pointer to BocopDefinition objects
typedef boost::shared_ptr<BocopDefinition> bocopDefPtr;

#endif

