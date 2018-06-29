// This code is published under the Eclipse Public License
// File: BocopDefinition.cpp
// Authors: Vincent Grelard, Daphne Giorgi, Stephan Maindrault, Pierre Martinon
// Inria Saclay and Cmap Ecole Polytechnique
// 2011-2016

#include <BocopDefinition.hpp>

#ifdef PATH_DISC
#define default_m_pathToDiscFiles PATH_DISC
#else
#define default_m_pathToDiscFiles "../core/disc/"
#endif

/**
 *\fn BocopDefinition::BocopDefinition()
 * Default constructor.
 */
BocopDefinition::BocopDefinition()
{
    m_flagDefinitionDone = false;
    m_flagBoundariesDone = false;
    m_flagConstantsDone = false;
    m_flagMethodDone =  false;
    m_flagTimesDone = false;

    this->m_defFileName = "";
    this->m_boundsFileName = "";
    this->m_constantsFileName = "";
    this->m_observationFileName = "";
    this->m_solFilename = "";
    this->m_paramIdType = "";

    // No output file for the iterations
    m_iterationOutputFrequency = 0;

    //this->m_pathToDiscFiles = default_m_pathToDiscFiles;

    m_batchType = -1;
    m_batchIndex = -1;
    m_batchRange = -1;
    m_batchStarting = numeric_limits<int>::max();
    m_batchEnding = numeric_limits<int>::min();
    m_batchFolder = "";

    // We reserve space for reading definition file :
    int NRES = 100;

    this->m_stringName.reserve(NRES);
    this->m_stringValue.reserve(NRES);
    this->m_integerName.reserve(NRES);
    this->m_integerValue.reserve(NRES);
    this->m_doubleName.reserve(NRES);
    this->m_doubleValue.reserve(NRES);

    // NULL pointers for the bounds :
    m_lowerVariable = 0;
    m_upperVariable = 0;
    m_typeVariable = 0;
    m_lowerPath = 0;
    m_upperPath = 0;
    m_typePath = 0;
    m_lowerBoundary = 0;
    m_upperBoundary = 0;
    m_typeBoundary = 0;

    // NULL pointer for the constants :
    this->m_constants = 0;

    // NULL pointers for the discretization :
    this->m_discCoeffA = 0;
    this->m_discCoeffB = 0;
    this->m_discCoeffC = 0;

    this->m_timeSteps = 0;
    this->m_timeStages = 0;

    // NULL pointers for the observations :
    this->m_timeObservation = 0;
    this->m_observations = 0;
    this->m_weightObservations = 0;
    this->m_indexObservation = 0;
    this->m_observationSeparator = ',';
    this->m_sizeDataSet = 0;

    this->m_dimStage = -1;

    m_isWarning = false;
    m_errorString = "";
    m_warningString = "";
}



BocopDefinition::BocopDefinition(string name_def, string name_bounds, string name_const)
{
    m_flagDefinitionDone = false;
    m_flagBoundariesDone = false;
    m_flagConstantsDone = false;
    m_flagMethodDone =  false;
    m_flagTimesDone = false;

    this->m_defFileName = name_def;
    this->m_boundsFileName = name_bounds;
    this->m_constantsFileName = name_const;
    this->m_observationFileName = "";
    this->m_solFilename = "";
    this->m_paramIdType = "";

    // No output file for the iterations
    m_iterationOutputFrequency = 0;

    //this->m_pathToDiscFiles = default_m_pathToDiscFiles;

    m_batchType = -1;
    m_batchIndex = -1;
    m_batchRange = -1;
    m_batchStarting = numeric_limits<int>::max();
    m_batchEnding = numeric_limits<int>::min();
    m_batchFolder = "";


    // We reserve space for reading definition file :
    int NRES = 100;

    this->m_stringName.reserve(NRES);
    this->m_stringValue.reserve(NRES);

    this->m_integerName.reserve(NRES);
    this->m_integerValue.reserve(NRES);

    this->m_doubleName.reserve(NRES);
    this->m_doubleValue.reserve(NRES);

    // NULL pointers for the bounds :
    m_lowerVariable = 0;
    m_upperVariable = 0;
    m_typeVariable = 0;

    m_lowerPath = 0;
    m_upperPath = 0;
    m_typePath = 0;

    m_lowerBoundary = 0;
    m_upperBoundary = 0;
    m_typeBoundary = 0;

    // NULL pointer for the constants :
    this->m_constants = 0;

    // NULL pointers for the discretization :
    this->m_discCoeffA = 0;
    this->m_discCoeffB = 0;
    this->m_discCoeffC = 0;

    this->m_timeSteps = 0;
    this->m_timeStages = 0;
    this->m_dimStage = -1;

    // NULL pointer default values for the observations :
    this->m_timeObservation = 0;
    this->m_observations = 0;
    this->m_weightObservations = 0;
    this->m_indexObservation = 0;
    this->m_observationSeparator = ',';
    this->m_sizeDataSet = 0;

    m_isWarning = false;
    m_errorString = "";
    m_warningString = "";
}


/**
  *\fn BocopDefinition::BocopDefinition (const BocopDefinition& DEF)
  * Copy constructor.
  */
BocopDefinition::BocopDefinition(const BocopDefinition& DEF)
    : m_dimState(DEF.m_dimState), m_dimControl(DEF.m_dimControl), m_dimAlgebraic(DEF.m_dimAlgebraic), m_dimParameter(DEF.m_dimParameter), m_dimConstant(DEF.m_dimConstant), m_dimBoundCond(DEF.m_dimBoundCond), m_dimPathCond(DEF.m_dimPathCond),
      m_freeTime(DEF.m_freeTime), m_t0(DEF.m_t0), m_tF(DEF.m_tF), m_dimStep(DEF.m_dimStep), m_discMethod(DEF.m_discMethod), m_dimStage(DEF.m_dimStage), m_dimStepBeforeMerge(DEF.m_dimStepBeforeMerge),
      m_optimType(DEF.m_optimType), m_batchType(DEF.m_batchType), m_batchIndex(DEF.m_batchIndex), m_batchRange(DEF.m_batchRange), m_batchStarting(DEF.m_batchStarting), m_batchEnding(DEF.m_batchEnding), m_batchFolder(DEF.m_batchFolder),
      m_initMethod(DEF.m_initMethod), m_initFilename(DEF.m_initFilename),
      m_paramIdType(DEF.m_paramIdType), m_observationSeparator(DEF.m_observationSeparator), m_observationFileName(DEF.m_observationFileName), m_sizeDataSet(DEF.m_sizeDataSet),
      m_defFileName(DEF.m_defFileName), m_boundsFileName(DEF.m_boundsFileName), m_constantsFileName(DEF.m_constantsFileName),
      //m_pathToDiscFiles(DEF.m_pathToDiscFiles),
      m_solFilename(DEF.m_solFilename), m_iterationOutputFrequency(DEF.m_iterationOutputFrequency),
      m_flagDefinitionDone(DEF.m_flagDefinitionDone), m_flagBoundariesDone(DEF.m_flagBoundariesDone),
      m_flagConstantsDone(DEF.m_flagConstantsDone), m_flagMethodDone(DEF.m_flagMethodDone), m_flagTimesDone(DEF.m_flagTimesDone),
      m_dimObservation(DEF.m_dimObservation), m_dimTimeObservation(DEF.m_dimTimeObservation)
{
    // NULL pointers for the bounds :
    m_lowerVariable = 0;
    m_upperVariable = 0;
    m_typeVariable = 0;
    m_lowerPath = 0;
    m_upperPath = 0;
    m_typePath = 0;
    m_lowerBoundary = 0;
    m_upperBoundary = 0;
    m_typeBoundary = 0;

    // NULL pointer for the constants :
    this->m_constants = 0;

    // NULL pointers for the discretization :
    this->m_discCoeffA = 0;
    this->m_discCoeffB = 0;
    this->m_discCoeffC = 0;
    this->m_timeSteps = 0;
    this->m_timeStages = 0;

    // std::vector copy :
    if (m_flagDefinitionDone) {
        m_stringName = DEF.m_stringName;
        m_stringValue = DEF.m_stringValue;
        m_integerName = DEF.m_integerName;
        m_integerValue = DEF.m_integerValue;
        m_doubleName = DEF.m_doubleName;
        m_doubleValue = DEF.m_doubleValue;

        m_stateNames = DEF.m_stateNames;
        m_controlNames = DEF.m_controlNames;
        m_algebraicNames = DEF.m_algebraicNames;
        m_optimvarsNames = DEF.m_optimvarsNames;
        m_constantNames = DEF.m_constantNames;
        m_boundcondNames = DEF.m_boundcondNames;
        m_pathcondNames = DEF.m_pathcondNames;
        m_dimTimeObservation = DEF.m_dimTimeObservation;
    }

    // Arrays copy :
    if (m_flagBoundariesDone) {
        allocateBoundsArrays();

        int dim_vars = m_dimState + m_dimControl + m_dimAlgebraic + m_dimParameter;
        for (int i = 0; i < dim_vars; ++i) {
            m_lowerVariable[i] = DEF.m_lowerVariable[i];
            m_upperVariable[i] = DEF.m_upperVariable[i];
            m_typeVariable[i] = DEF.m_typeVariable[i];
        }

        for (int i = 0; i < m_dimPathCond; ++i) {
            m_lowerPath[i] = DEF.m_lowerPath[i];
            m_upperPath[i] = DEF.m_upperPath[i];
            m_typePath[i] = DEF.m_typePath[i];
        }

        for (int i = 0; i < m_dimBoundCond; ++i) {
            m_lowerBoundary[i] = DEF.m_lowerBoundary[i];
            m_upperBoundary[i] = DEF.m_upperBoundary[i];
            m_typeBoundary[i] = DEF.m_typeBoundary[i];
        }
    }

    if (m_flagConstantsDone) {
        this->m_constants = new double[this->m_dimConstant];
        for (int i = 0; i < m_dimConstant; ++i) {
            m_constants[i] = DEF.m_constants[i];
        }
    }

    if (m_flagMethodDone) {
        m_discCoeffA = new double * [this->m_dimStage];
        for (int i = 0; i < this->m_dimStage; ++i) {
            m_discCoeffA[i] = new double[this->m_dimStage];
        }

        m_discCoeffB =  new double[this->m_dimStage];
        m_discCoeffC =  new double[this->m_dimStage];

        for (int i = 0; i < m_dimStage; i++) {
            m_discCoeffB[i] = DEF.m_discCoeffB[i];
            m_discCoeffC[i] = DEF.m_discCoeffC[i];

            for (int j = 0; j < m_dimStage; j++)
                m_discCoeffA[i][j] = DEF.m_discCoeffA[i][j];
        }
    }

    if (m_flagTimesDone) {
        m_timeSteps = new double[this->m_dimStep + 1];
        m_timeStages = new double[this->m_dimStep * this->m_dimStage];

        for (int i = 0; i < m_dimStep + 1; ++i)
            m_timeSteps[i] = DEF.m_timeSteps[i];

        for (int i = 0; i < m_dimStep * m_dimStage; ++i)
            m_timeStages[i] = DEF.m_timeStages[i];
    }

    if (m_paramIdType != "false") {

        m_dimTimeObservation = new int[m_sizeDataSet];
        for (int k = 0; k < m_sizeDataSet; k++) {
            m_dimTimeObservation[k] = DEF.m_dimTimeObservation[k];
        }

        m_timeObservation = new double*[m_sizeDataSet];
        m_indexObservation = new int* [m_sizeDataSet];

        for (int k = 0; k < m_sizeDataSet; k++) {
            m_timeObservation[k] = new  double[m_dimTimeObservation[k]];
            m_indexObservation[k] = new int[m_dimTimeObservation[k]];
            for (int p = 0; p < m_dimTimeObservation[k]; p++) {
                m_timeObservation[k][p] = DEF.m_timeObservation[k][p];
                m_indexObservation[k][p] = DEF.m_indexObservation[k][p];
            }
        }

        m_observations = new double** [m_sizeDataSet];
        m_weightObservations = new double** [m_sizeDataSet];
        for (int k = 0; k < m_sizeDataSet; k++) {
            m_observations[k] = new double*[m_dimObservation[k]];
            m_weightObservations[k] = new double*[m_dimObservation[k]];
            for (int p = 0; p < m_dimObservation[k]; p++) {
                m_observations[k][p] = new double[m_dimTimeObservation[k]];
                m_weightObservations[k][p] = new double[m_dimTimeObservation[k]];
                for (int i = 0; i < m_dimTimeObservation[k]; i++) {
                    m_observations[k][p][i] = DEF.m_observations[k][p][i];
                    m_weightObservations[k][p][i]  = DEF.m_weightObservations[k][p][i];
                }
            }
        }
    } else {
        m_timeObservation = DEF.m_timeObservation;
        m_indexObservation = DEF.m_indexObservation;
        m_observations = DEF.m_observations;
        m_weightObservations = DEF.m_weightObservations;
    }
}



BocopDefinition::BocopDefinition(const string timeFree,
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
                                 const double* discCoeffC) :
    m_dimState(stateDim), m_dimControl(controlDim), m_dimAlgebraic(algebraicDim), m_dimParameter(parameterDim), m_dimConstant(constantDim), m_dimBoundCond(boundCondDim), m_dimPathCond(pathCondDim),
    m_freeTime(timeFree), m_t0(t0), m_tF(tF), m_dimStep(discSteps), m_discMethod(discMethod), m_dimStage(dimStage), m_dimStepBeforeMerge(dimStepBeforeMerge),
    m_optimType(optimType), m_batchType(batchType), m_batchIndex(batchIndex), m_batchRange(batchRange), m_batchStarting(lowerBound), m_batchEnding(upperBound), m_batchFolder(batchDir),
    m_initMethod(initType), m_initFilename(initFile),
    m_paramIdType(paramidType), m_observationSeparator(paramidSeparator), m_observationFileName(paramidFile), m_sizeDataSet(paramidDim),
    m_defFileName(defFileName), m_boundsFileName(boundsFileName), m_constantsFileName(constantsFileName),
    //m_pathToDiscFiles(pathToDiscFiles),
    m_solFilename(solFileName), m_iterationOutputFrequency(iterationOutputFrequency),
    m_flagDefinitionDone(flagDefinitionDone), m_stateNames(stateNames), m_controlNames(controlNames), m_algebraicNames(algebraicNames), m_optimvarsNames(parameterNames), m_constantNames(constantNames), m_boundcondNames(boundcondNames), m_pathcondNames(pathcondNames),
    m_flagBoundariesDone(flagBoundariesDone), m_flagConstantsDone(flagConstantsDone), m_flagMethodDone(flagMethodDone)
{
    // NULL pointers for the bounds :
    m_lowerVariable = 0;
    m_upperVariable = 0;
    m_typeVariable = 0;
    m_lowerPath = 0;
    m_upperPath = 0;
    m_typePath = 0;
    m_lowerBoundary = 0;
    m_upperBoundary = 0;
    m_typeBoundary = 0;

    // NULL pointer for the constants :
    this->m_constants = 0;

    // NULL pointers for the discretization :
    this->m_discCoeffA = 0;
    this->m_discCoeffB = 0;
    this->m_discCoeffC = 0;
    this->m_timeSteps = 0;
    this->m_timeStages = 0;

    // Arrays copy :
    if (m_flagBoundariesDone) {

        allocateBoundsArrays();

        int dim_vars = m_dimState + m_dimControl + m_dimAlgebraic + m_dimParameter;
        for (int i = 0; i < dim_vars; ++i) {
            m_lowerVariable[i] = lowerVariable[i];
            m_upperVariable[i] = upperVariable[i];
            m_typeVariable[i] = typeVariable[i];
        }

        for (int i = 0; i < m_dimPathCond; ++i) {
            m_lowerPath[i] = lowerPath[i];
            m_upperPath[i] = upperPath[i];
            m_typePath[i] = typePath[i];
        }

        for (int i = 0; i < m_dimBoundCond; ++i) {
            m_lowerBoundary[i] = lowerBoundary[i];
            m_upperBoundary[i] = upperBoundary[i];
            m_typeBoundary[i] = typeBoundary[i];
        }
    }

    if (m_flagConstantsDone) {
        this->m_constants = new double[this->m_dimConstant];
        for (int i = 0; i < m_dimConstant; ++i) {
            m_constants[i] = constants[i];
        }
    }

    if (m_flagMethodDone) {
        m_discCoeffA = new double * [this->m_dimStage];
        for (int i = 0; i < this->m_dimStage; ++i) {
            m_discCoeffA[i] = new double[this->m_dimStage];
        }

        m_discCoeffB =  new double[this->m_dimStage];
        m_discCoeffC =  new double[this->m_dimStage];

        for (int i = 0; i < m_dimStage; i++) {
            m_discCoeffB[i] = discCoeffB[i];
            m_discCoeffC[i] = discCoeffC[i];

            for (int j = 0; j < m_dimStage; j++)
                m_discCoeffA[i][j] = discCoeffA[i][j];
        }
    }

    int status;

    // NULL pointer default values for the observations :
    this->m_dimObservation = 0;
    this->m_dimTimeObservation = 0;
    this->m_timeObservation = 0;
    this->m_indexObservation = 0;
    this->m_observations = 0;
    this->m_weightObservations = 0;

    if (this->isParamId()) {

        status = readObservations();
        if (status != 0)
            return;
    }

    // NULL pointer default values for times :
    this->m_timeSteps = 0;
    this->m_timeStages = 0;

    status = readTimes();
    if (status != 0)
        return;

    m_flagTimesDone = true;
}


/**
  *\fn BocopDefinition::~BocopDefinition()
  * Destructor.
  */
BocopDefinition::~BocopDefinition()
{
    if (this->m_constants != 0)
        delete[] this->m_constants;

    if (this->m_lowerVariable != 0)
        delete[] this->m_lowerVariable;


    if (this->m_upperVariable != 0)
        delete[] this->m_upperVariable;

    if (this->m_typeVariable != 0)
        delete[] this->m_typeVariable;

    if (this->m_lowerPath != 0)
        delete[] this->m_lowerPath;

    if (this->m_upperPath != 0)
        delete[] this->m_upperPath;

    if (this->m_typePath != 0)
        delete[] this->m_typePath;

    if (this->m_lowerBoundary != 0)
        delete[] this->m_lowerBoundary;

    if (this->m_upperBoundary != 0)
        delete[] this->m_upperBoundary;

    if (this->m_typeBoundary != 0)
        delete[] this->m_typeBoundary;

    if (this->m_discCoeffA != 0) {
        for (int i = 0; i < this->m_dimStage; i++)
            delete[] m_discCoeffA[i];
        delete[] m_discCoeffA;
    }

    if (this->m_discCoeffB != 0)
        delete[] this->m_discCoeffB;
    if (this->m_discCoeffC != 0)
        delete[] this->m_discCoeffC;

    if (this->m_timeSteps != 0)
        delete[] this->m_timeSteps;
    if (this->m_timeStages != 0)
        delete[] this->m_timeStages;

    if (this->m_dimTimeObservation != 0) {
        delete[] this->m_dimTimeObservation;
        this->m_dimTimeObservation  = 0;
    }

    if (this->m_timeObservation != 0) {
        for (int k = 0; k < this->m_sizeDataSet; k++)
            delete[] this->m_timeObservation[k];
        delete[] this->m_timeObservation;
        this->m_timeObservation  = 0;
    }

    if (this->m_indexObservation != 0) {
        for (int k = 0; k < this->m_sizeDataSet; k++)
            delete[] this->m_indexObservation[k];
        delete[] this->m_indexObservation;
        this->m_indexObservation  = 0;
    }

    if (this->m_observations != 0) {
        for (int k = 0; k < this->m_sizeDataSet; k++) {
            for (int p = 0; p < this->m_dimObservation[k]; p++) {
                delete[] this->m_observations[k][p];
            }
            delete[] this->m_observations[k];
        }
        delete[] this->m_observations;
        this->m_observations  = 0;
    }

    if (this->m_weightObservations != 0) {
        for (int k = 0; k < this->m_sizeDataSet; k++) {
            for (int p = 0; p < this->m_dimObservation[k]; p++) {
                delete[] this->m_weightObservations[k][p];
            }
            delete[] this->m_weightObservations[k];
        }
        delete[] this->m_weightObservations;
        this->m_weightObservations  = 0;
    }

    /* this causes errors in valgrind, is the destructor called more than once oO ?
    if (this->m_dimObservation != 0) {
        delete[] this->m_dimObservation;
        this->m_dimObservation  = 0;
    }
    */

}


// ***************************
// ******  DEFINITION  *******
// ***************************

/**
  *\fn bool BocopDefinition::findInDef (const string name_to_find, string* value_found) const
  * Overloaded function to seek a parameter from the arrays
  * filled with data from definition file. We give the name
  * of the parameter, as it is written in the definition file
  * and the function returns true if it is found or false if
  * it is not.
  */
bool BocopDefinition::findInDef(const string name_to_find, string* value_found) const
{
    *value_found = "";
    bool flag_found = false; // set to true if the entry is found

    for (unsigned int i = 0; i < this->m_stringName.size(); ++i) {
        if (m_stringName.at(i) == name_to_find) {
            *value_found = m_stringValue.at(i);
            flag_found = true;

            return flag_found;
        }
    }

    return flag_found;
}


/**
  *\fn bool BocopDefinition::findInDef (const string name_to_find, int* value_found) const
  * Overloaded function to seek a parameter from the arrays
  * filled with data from definition file. We give the name
  * of the parameter, as it is written in the definition file
  * and the function returns true if it is found or false if
  * it is not.
  */
bool BocopDefinition::findInDef(const string name_to_find, int* value_found) const
{
    *value_found = 0;
    bool flag_found = false; // set to true if the entry is found

    for (unsigned int i = 0; i < this->m_integerName.size(); ++i) {
        if (m_integerName.at(i) == name_to_find) {
            *value_found = m_integerValue.at(i);
            flag_found = true;

            return flag_found;
        }
    }

    return flag_found;
}

/**
  *\fn bool BocopDefinition::findInDef (const string name_to_find, double* value_found) const
  * Overloaded function to seek a parameter from the arrays
  * filled with data from definition file. We give the name
  * of the parameter, as it is written in the definition file
  * and the function returns true if it is found or false if
  * it is not.
  */
bool BocopDefinition::findInDef(const string name_to_find, double* value_found) const
{
    *value_found = 0.0;
    bool flag_found = false; // set to true if the entry is found

    for (unsigned int i = 0; i < this->m_doubleName.size(); ++i) {
        if (m_doubleName.at(i) == name_to_find) {
            *value_found = m_doubleValue.at(i);
            flag_found = true;

            return flag_found;
        }
    }

    return flag_found;
}


/**
  *\fn bool BocopDefinition::isSingleOptimization(void)
  * Public method, returns true if the optimization type
  * is not batch (is single).
  */
bool BocopDefinition::isSingleOptimization(void)
{
    if (m_optimType != "batch")
        return true;
    else
        return false;
}


// ***************************
// ******  BOUNDARIES  *******
// ***************************


/**
  *\fn int BocopDefinition::allocateBoundsArrays (void)
  * This function is called after the definition, in order to
  * allocate space in memory for the arrays containing the bounds
  * of the problem.
  */
int BocopDefinition::allocateBoundsArrays(void)
{
    if (m_flagDefinitionDone == false) {
        m_errorString.append(" BocopDefinition::allocateBoundsArrays() : ERROR \n");
        m_errorString.append(" Cannot allocate space in memory because dimensions");
        m_errorString.append(" are unknown. Please use readDefinition before trying");
        m_errorString.append(" to read the boundary conditions.\n");
        return 1;
    }

    int dim_vars = this->m_dimState + this->m_dimControl + this->m_dimAlgebraic + this->m_dimParameter;
    if (dim_vars > 0) {
        this->m_lowerVariable = new double[dim_vars];
        this->m_upperVariable = new double[dim_vars];
        this->m_typeVariable = new string[dim_vars];
    } else {
        m_errorString.append(" BocopDefinition::allocateBoundsArrays() : ERROR \n");
        m_errorString.append(" Cannot allocate space in memory because dimensions");
        m_errorString.append(" for the variables is lower or equal to zero... \n");
        return 2;
    }

    if (m_dimPathCond > 0) {
        this->m_lowerPath = new double[m_dimPathCond];
        this->m_upperPath = new double[m_dimPathCond];
        this->m_typePath = new string[m_dimPathCond];
    }

    if (m_dimBoundCond > 0) {
        this->m_lowerBoundary = new double[m_dimBoundCond];
        this->m_upperBoundary = new double[m_dimBoundCond];
        this->m_typeBoundary = new string[m_dimBoundCond];
    }

    return 0;
}


/**
  *\fn int BocopDefinition:::processBounds(string type, double* lowerbound, double* upperbound)
  * Function to process lower and upper bounds for 1 variable.
  */
int BocopDefinition::processBounds(string type, double* lowerbound, double* upperbound)
{

    int ret = 0;
    stringstream msg;
    double my_inf = 2e19; /** constant 'inf' bound for ipopt */

    if (type == "0" || type == "free") {
        *lowerbound = -my_inf;
        *upperbound = my_inf;
    } else if (type == "1" || type == "lower")
        *upperbound = my_inf;
    else if (type == "2" || type == "upper")
        *lowerbound = -my_inf;
    else if (type == "3" || type == "both") {
        if (*lowerbound > *upperbound)
            ret = 9;
    } else if (type == "4" || type == "equal") {
        if (*lowerbound != *upperbound)
            ret = 4;
    } else
        ret = 5;

    return ret;
}


/**
  *\fn int BocopDefinition::generateDefaultBounds(void)
  * This function is used when a problem occurs while reading .bounds file.
  * It sets all variables bounds to default (free).
  */
int BocopDefinition::generateDefaultBounds(void)
{
    int i;

    // boundary conditions :
    for (i = 0; i < m_dimBoundCond; ++i) {
        m_lowerBoundary[i] = 0.0;
        m_upperBoundary[i] = 0.0;
        m_typeBoundary[i] = "";
    }

    // variables :
    int dim_vars = m_dimState + m_dimControl + m_dimAlgebraic + m_dimParameter;
    for (i = 0; i < dim_vars; ++i) {
        m_lowerVariable[i] = 0.0;
        m_upperVariable[i] = 0.0;
        m_typeVariable[i] = "";
    }

    // path constraints :
    for (i = 0; i < m_dimPathCond; ++i) {
        m_lowerPath[i] = 0.0;
        m_upperPath[i] = 0.0;
        m_typePath[i] = "";
    }

    return 0;
}


/**
  *\fn int BocopDefinition::readBoundaries (void)
  * This public function can be called to fill the
  * boundaries arrays with the values defined in
  * the boundary file.
  */
int BocopDefinition::readBoundaries(void)
{
    // allocate memory to store the boundaries
    int status = 0;
    status = allocateBoundsArrays();
    if (status != 0)
        return 1;

    // read the file and fill 3 sets of arrays (variables, boundary conditions and path constraints)
    status = readBoundsFile();
    if (status != 0)
        return 2;

    m_flagBoundariesDone = true;
    return 0;
}


/**
  *\fn int BocopDefinition::lowerBoundVariable(const int i, double& val) const
  * This function gives the lower bound (val) on the i-th variable.
  */
int BocopDefinition::lowerBoundVariable(const int i, double& val) const
{
    if (m_flagBoundariesDone == false)
        return 1;
    if (i < 0 || i >= m_dimState + m_dimControl + m_dimAlgebraic + m_dimParameter)
        return 2;
    val = m_lowerVariable[i];
    return 0;
}


/**
  *\fn int BocopDefinition::upperBoundVariable(const int i, double& val) const
  * This function gives the upper bound (val) on the i-th variable.
  */
int BocopDefinition::upperBoundVariable(const int i, double& val) const
{
    if (m_flagBoundariesDone == false)
        return 1;
    if (i < 0 || i >= m_dimState + m_dimControl + m_dimAlgebraic + m_dimParameter)
        return 2;
    val = m_upperVariable[i];
    return 0;
}


/**
  *\fn int BocopDefinition::typeBoundVariable(const int i, string& val) const
  * This function gives the type of bound (val) on the i-th variable.
  */
int BocopDefinition::typeBoundVariable(const int i, string& val) const
{
    val = -1;
    if (m_flagBoundariesDone == false)
        return 1;
    if (i < 0 || i >= m_dimState + m_dimControl + m_dimAlgebraic + m_dimParameter)
        return 2;
    val = m_typeVariable[i];
    return 0;
}


/**
  *\fn int BocopDefinition::lowerBoundInitFinalCond(const int i, double& val) const
  * This function gives the lower bound (val) on the i-th initial and final condition.
  */
int BocopDefinition::lowerBoundInitFinalCond(const int i, double& val) const
{
    if (m_flagBoundariesDone == false)
        return 1;
    if (i < 0 || i >= m_dimBoundCond)
        return 2;
    val = m_lowerBoundary[i];
    return 0;
}


/**
  *\fn int BocopDefinition::upperBoundInitFinalCond(const int i, double& val) const
  * This function gives the upper bound (val) on the i-th initial and final condition.
  */
int BocopDefinition::upperBoundInitFinalCond(const int i, double& val) const
{
    if (m_flagBoundariesDone == false)
        return 1;
    if (i < 0 || i >= m_dimBoundCond)
        return 2;
    val = m_upperBoundary[i];
    return 0;
}


/**
  *\fn int BocopDefinition::typeBoundInitFinalCond(const int i, string& val) const
  * This function gives the type of bound (val) on the i-th initial and final condition.
  */
int BocopDefinition::typeBoundInitFinalCond(const int i, string& val) const
{
    val = -1;
    if (m_flagBoundariesDone == false)
        return 1;
    if (i < 0 || i >= m_dimBoundCond)
        return 2;
    val = m_typeBoundary[i];
    return 0;
}


/**
  *\fn int BocopDefinition::lowerBoundPathConstraint(const int i, double& val) const
  * This function gives the lower bound (val) on the i-th path constraint.
  */
int BocopDefinition::lowerBoundPathConstraint(const int i, double& val) const
{
    if (m_flagBoundariesDone == false)
        return 1;
    if (i < 0 || i >= m_dimPathCond)
        return 2;
    val = m_lowerPath[i];
    return 0;
}


/**
  *\fn int BocopDefinition::upperBoundPathConstraint(const int i, double& val) const
  * This function gives the upper bound (val) on the i-th path constraint.
  */
int BocopDefinition::upperBoundPathConstraint(const int i, double& val) const
{
    if (m_flagBoundariesDone == false)
        return 1;
    if (i < 0 || i >= m_dimPathCond)
        return 2;
    val = m_upperPath[i];
    return 0;
}


/**
  *\fn int BocopDefinition::typeBoundPathConstraint(const int i, string& val) const
  * This function gives the type of bound (val) on the i-th variable.
  */
int BocopDefinition::typeBoundPathConstraint(const int i, string& val) const
{
    val = -1;
    if (m_flagBoundariesDone == false)
        return 1;
    if (i < 0 || i >= m_dimPathCond)
        return 2;
    val = m_typePath[i];
    return 0;
}


// ***************************
// ******  CONSTANTS   *******
// ***************************


/**
  *\fn string BocopDefinition::getOptimizationType (void) const
  * This function returns the type of optimization found for the current
  * instance of BocopDefinition. It is used to know if we have to solve
  * a single problem, or a series of them.
  */
string BocopDefinition::getOptimizationType(void) const
{
    string single_or_batch = "";

    if (m_flagDefinitionDone == false) {
        cerr << " BocopDefinition::getOptimizationType() : ERROR " << endl;
        cerr << " Cannot get the type of optimization before setting" << endl;
        cerr << " a definition for this instance. Please call readDefinition()..." << endl;
        exit(1);
    }


    if (this->m_optimType == "single")
        single_or_batch = "single";
    else if (this->m_optimType == "batch")
        single_or_batch = "batch";
    else {
        cout << endl << " *** WARNING : optimization type not found in the problem definition. ***" << endl;
        cout << "     Default type will be used, one single optimization will be performed" << endl << endl;
        single_or_batch = "single";
    }

    return single_or_batch;
}


/**
  *\fn bool BocopDefinition::getBatchOptions (int& type, int& index, double& lowerbound, double& upperbound, int& n_batch, string& batch_dir, string& init_type) const
  * This function returns all batch optimization parameters. They can be read from
  * the associated definition file.
  */
bool BocopDefinition::getBatchOptions(int& type, int& index, double& lowerbound, double& upperbound, int& n_batch, string& batch_dir, string& init_type) const
{
    index = -1;
    lowerbound = numeric_limits<int>::max();
    upperbound = numeric_limits<int>::min();
    n_batch = -1;
    batch_dir = "";

    try {
        findInDef("batch.type", &type);  // name of the discretization method
        findInDef("batch.index", &index);  // name of the discretization method
        findInDef("batch.lowerbound", &lowerbound);
        findInDef("batch.upperbound", &upperbound);
        findInDef("batch.nrange", &n_batch);
        findInDef("batch.directory", &batch_dir);
    } catch (...) {
        cerr << " BocopDefinition::getBatchOptions : ERROR " << endl;
        cerr << " An error occurred when fetching the values in the" << endl;
        cerr << " definition arrays. The source of this error might" << endl;
        cerr << " be that your definition file is incorrectly written." << endl;

        return false;
    }

    // We check that all the values were found :
    if ((index < 0) | (n_batch < 0) | (batch_dir == "")) {
        cerr << " BocopDefinition::getBatchOptions() : ERROR" << endl;
        cerr << " One of the values was not found in the definition." << endl;
        cerr << " Please check that these values are defined in your definition file :" << endl;
        cerr << " batch.type, batch.index, batch.lowerbound, batch.upperbound, batch.directory," << endl;
        cerr << " and batch.nrange." << endl;

        return false;
    }

    init_type = this->m_initMethod;
    return true;
}


/**
  *\fn void BocopDefinition::setOneConstant (const int ind, const double val)
  * This function allows to redefine the value of the constant located
  * at index "ind", with the new value "val". It is useful when running
  * batch optimizations. We can change only this parameter, and run the
  * process again.
  */
void BocopDefinition::setOneConstant(const int ind, const double val)
{
    if (this->m_flagConstantsDone == false) {
        cerr << " BocopDefinition::setOneConstant() : ERROR " << endl;
        cerr << " Cannot set a new value for an element of constants" << endl;
        cerr << " array, because this array is not defined. Please " << endl;
        cerr << " run readConstants() before." << endl;
        exit(1);
    }

    if (ind < 0 || ind > m_dimConstant - 1) {
        cerr << " BocopDefinition::setOneConstant() : ERROR, Invalid index " << endl;
        exit(1);
    }

    this->m_constants[ind] = val;
}


/**
 * \fn int BocopDefinition::valConstant(const int i, double& value)
 * This method returns the value of the constant located at index i.
 * If the constants were not set yet, or the index is out of range,
 * it returns an error.
 */
int BocopDefinition::valConstant(const int i, double& value)
{
    value = 0.0;

    if (m_flagConstantsDone != true) {
        m_errorString.append("Cannot get constant value, as the constants array was not filled yet. Please use readConstants().\n");
        return 1;
    }

    if (i < 0 || i >= m_dimConstant) {
        m_errorString.append("Cannot get constant value, as the index is out of range.\n");
        return 2;
    }

    value = m_constants[i];
    return 0;
}


/**
 * \fn void BocopDefinition::setInOutProperties (const string INIT_FILENAME, const string SOL_FILENAME)
 * This function allows to set new starting point properties for
 * the current definition. It sets a new name for the .sol starting
 * file, a new name for the .sol solution file.
 * If the filename is "...", we do not modify the current value.
 */
void BocopDefinition::setInOutProperties(const string INIT_FILENAME, const string SOL_FILENAME)
{
    if (INIT_FILENAME != "...")
        this->m_initFilename = INIT_FILENAME;

    if (SOL_FILENAME != "...")
        this->m_solFilename  = SOL_FILENAME;

}


void BocopDefinition::setSolutionFile(const string solFileName)
{
    m_solFilename = solFileName;
}

/**
 * \fn string BocopDefinition::getName (const string& basename, const int& ind)
 * This function allows to get a name from the definition array.
 * It looks a lot like findInDef, except when the entry is not
 * found, we do not display a warning, but we return the entry
 * sought.
 */
string BocopDefinition::getName(const string& basename, const int& ind)
{
    // The keyword we are looking for in the file is :
    stringstream sstr;
    sstr << ind;
    string ind_str = sstr.str();

    string name_to_find = basename + "." + ind_str;

    // We now search for this entry in the definition array :
    string value_found = "";

    for (unsigned int i = 0; i < this->m_stringName.size(); ++i) {
        if (m_stringName.at(i) == name_to_find) {
            value_found = m_stringValue.at(i);
            return value_found;
        }
    }

    // If the value was not found, we return the keyword
    // we were looking for :
    return name_to_find;
}


string BocopDefinition::nameState(const int i) const
{
    if (i < 0 || i >= m_dimState || m_flagDefinitionDone != true) {
        stringstream sstr;
        sstr << i;
        string name_default = "state." + sstr.str();

        return name_default;
    }
    //cout << "m_statenames dim " << m_stateNames.size() << endl;
    //return m_stateNames[i];
    return m_stateNames.at(i);
}


string BocopDefinition::nameControl(const int i) const
{
    if (i < 0 || i >= m_dimControl || m_flagDefinitionDone != true) {
        stringstream sstr;
        sstr << i;
        string name_default = "control." + sstr.str();

        return name_default;
    }

    return m_controlNames.at(i);
}


string BocopDefinition::nameAlgebraic(const int i) const
{
    if (i < 0 || i >= m_dimAlgebraic || m_flagDefinitionDone != true) {
        stringstream sstr;
        sstr << i;
        string name_default = "algebraic." + sstr.str();

        return name_default;
    }

    return m_algebraicNames.at(i);
}


string BocopDefinition::nameOptimVar(const int i) const
{
    if (i < 0 || i >= m_dimParameter || m_flagDefinitionDone != true) {
        stringstream sstr;
        sstr << i;
        string name_default = "parameter." + sstr.str();

        return name_default;
    }

    return m_optimvarsNames.at(i);
}


string BocopDefinition::nameConstant(const int i) const
{
    if (i < 0 || i >= m_dimConstant || m_flagDefinitionDone != true) {
        stringstream sstr;
        sstr << i;
        string name_default = "constant." + sstr.str();

        return name_default;
    }

    return m_constantNames.at(i);
}


string BocopDefinition::nameInitFinalCond(const int i) const
{
    if (i < 0 || i >= m_dimBoundCond || m_flagDefinitionDone != true) {
        stringstream sstr;
        sstr << i;
        string name_default = "boundarycond." + sstr.str();

        return name_default;
    }

    return m_boundcondNames.at(i);
}


string BocopDefinition::namePathConstraint(const int i) const
{
    if (i < 0 || i >= m_dimPathCond || m_flagDefinitionDone != true) {
        stringstream sstr;
        sstr << i;
        string name_default = "constraint." + sstr.str();

        return name_default;
    }

    return m_pathcondNames.at(i);
}


// *************************************
// ********* DISCRETIZATION ************
// *************************************


// allocate coefficients for the generalized Runge Kutta method (using Butcher notations)
void BocopDefinition::allocateDiscCoeffs()
{
  m_discCoeffA = new double * [m_dimStage];
  for (int i = 0; i < m_dimStage; ++i) {
      m_discCoeffA[i] = new double[m_dimStage];
  }
  m_discCoeffB =  new double[m_dimStage];
  m_discCoeffC =  new double[m_dimStage];
}

// set coefficients for the generalized Runge Kutta method (using Butcher notations)
// c1   a11 ... a1s
// .    .       .
// cs   as1 ... ass
//       b1 ... bs
int BocopDefinition::setDiscMethod()
{

  //NB. cannot use switch on strings...
  if (m_discMethod == "euler")
  {
    // Euler explicit (1-stage, order 1)
    // 0 0
    //   1
    m_dimStage = 1;
    allocateDiscCoeffs();
    m_discCoeffA[0][0] = 0e0;
    m_discCoeffB[0] = 1e0;
    m_discCoeffC[0] = 0e0;
  }
  else if (m_discMethod == "euler_imp")
  {
    // Euler implicit (1-stage, order 1)
    // 1 1
    //   1
    m_dimStage = 1;
    allocateDiscCoeffs();
    m_discCoeffA[0][0] = 1e0;
    m_discCoeffB[0] = 1e0;
    m_discCoeffC[0] = 1e0;
  }

  else if (m_discMethod == "midpoint")
  {
    // Midpoint implicit (1-stage, order 2)
    // 1/2  1/2
    //        1
    m_dimStage = 1;
    allocateDiscCoeffs();
    m_discCoeffA[0][0] = 0.5e0;
    m_discCoeffB[0] = 1e0;
    m_discCoeffC[0] = 0.5e0;
  }
  else if (m_discMethod == "gauss")
  {
    // Gauss II (2-stage, order 4)
    // 1/2 - sqrt(3)/6   1/4              1/4 - sqrt(3)/6
    // 1/2 + sqrt(3)/6   1/4 + sqrt(3)/6  1/4
    //                   1/2              1/2
    m_dimStage = 2;
    allocateDiscCoeffs();
    m_discCoeffA[0][0] = 0.25e0;
    m_discCoeffA[0][1] = 0.25e0 - sqrt(3e0)/6e0;
    m_discCoeffA[1][0] = 0.25e0 + sqrt(3e0)/6e0;
    m_discCoeffA[1][1] = 0.25e0;
    m_discCoeffB[0] = 0.5e0;
    m_discCoeffB[1] = 0.5e0;
    m_discCoeffC[0] = 0.5e0 - sqrt(3e0)/6e0;
    m_discCoeffC[1] = 0.5e0 + sqrt(3e0)/6e0;
  }
  else if (m_discMethod == "lobatto")
  {
    // Lobatto IIIC (4-stage, order 6)
    //              0   1/12       -sqrt(5)/12        sqrt(5)/12        -1/12
    // (5-sqrt(5))/10   1/12               1/4  (10-7sqrt(5))/60   sqrt(5)/60
    // (5+sqrt(5))/10   1/12  (10+7sqrt(5))/60               1/4  -sqrt(5)/60
    //              1   1/12              5/12              5/12         1/12
    //                  1/12              5/12              5/12         1/12
    m_dimStage = 4;
    allocateDiscCoeffs();
    m_discCoeffA[0][0] = 1e0/12e0;
    m_discCoeffA[0][1] = -sqrt(5e0)/12e0;
    m_discCoeffA[0][2] = sqrt(5e0)/12e0;
    m_discCoeffA[0][3] = -1e0/12e0;
    m_discCoeffA[1][0] = 1e0/12e0;
    m_discCoeffA[1][1] = 0.25e0;
    m_discCoeffA[1][2] = (10e0-7e0*sqrt(5e0))/60e0;
    m_discCoeffA[1][3] = sqrt(5e0)/60e0;
    m_discCoeffA[2][0] = 1e0/12e0;
    m_discCoeffA[2][1] = (10e0+7e0*sqrt(5e0))/60e0;
    m_discCoeffA[2][2] = 0.25e0;
    m_discCoeffA[2][3] = -sqrt(5e0)/60e0;
    m_discCoeffA[3][0] = 1e0/12e0;
    m_discCoeffA[3][1] = 5e0/12e0;
    m_discCoeffA[3][2] = 5e0/12e0;
    m_discCoeffA[3][3] = 1e0/12e0;
    m_discCoeffB[0] = 1e0/12e0;
    m_discCoeffB[1] = 5e0/12e0;
    m_discCoeffB[2] = 5e0/12e0;
    m_discCoeffB[3] = 1e0/12e0;
    m_discCoeffC[0] = 0e0;
    m_discCoeffC[1] = (5e0-sqrt(5e0))/10e0;
    m_discCoeffC[2] = (5e0+sqrt(5e0))/10e0;
    m_discCoeffC[3] = 1e0;//+++is this really used ??
  }
  else
  {
    m_errorString.append("ERROR >>> BocopDefinition::setDiscMethod()\n");
    m_errorString.append("An error occurred while setting Runge Kutta method's coefficients.\n");
    m_errorString.append("The name of the method given was: ");
    m_errorString.append(m_discMethod);
    return 1;
  }

    m_flagMethodDone = true;
  return 0;
}




/*
void BocopDefinition::setPathDiscretization(string PATH)
{
    this->m_pathToDiscFiles = PATH;
}
*/

/**
 * \fn int BocopDefinition::setTimeSteps (void)
 * Function to write the discretized times at the NODES
 * in the corresponding vector. The number of nodes do
 * not depend on the chosen discretization method. It is
 * the division of the main time interval. Each of these
 * steps is then divided into stages according to the
 * discretization method.
 */
int BocopDefinition::setTimeSteps(void)
{
    string name_f_times = "problem.times";
    ifstream file_times(name_f_times.c_str(), ios::in | ios::binary);

    if (!file_times) { // if the opening failed
        // then we fill this->m_timeSteps with the file values :
        int status = setConstTimeSteps();
        if (status != 0)
            return 1;

    } else {
        // First we close the file :
        file_times.close();

        // then we fill this->m_timeSteps with the file values :
        int status = setTimeStepsFromFile(name_f_times);
        if (status != 0)
            return 2;
    }

    return 0;
}


/**
 * \fn int BocopDefinition::setConstTimeSteps (void)
 * This function allows to set all values of the times for the discretization steps.
 * It gives equally spaced values between 0 and 1 (constant time step).
 */
int BocopDefinition::setConstTimeSteps(void)
{
    if (this->m_dimStep <= 0) {
        m_errorString.append("Error in setConstTimeSteps : number of time steps is invalid.\n");
        return 1;
    }

    if (this->m_t0 >= this->m_tF)
        m_errorString.append("Error in setConstTimeSteps : t0 > tf.\n");

    if (m_timeSteps != 0) {
        delete[] m_timeSteps;
    }

    this->m_timeSteps = new double[this->m_dimStep + 1];
    double time = 0.0;
    double h = 1.0 / m_dimStep;

    for (int i = 0; i < this->m_dimStep; i++) {
        m_timeSteps[i] = time;
        time += h;
    }

    m_timeSteps[m_dimStep] = 1.0;

    return 0;
}


/**
 * \fn int BocopDefinition::setTimeStages (void)
 * Function to write the discretized times at the STAGES
 * of the method in the corresponding vector. Between two
 * nodes of the discretization, we can find s stages, s
 * value depends on the discretization method.
 * This function is used when calling the constructor.
 * In this method, the time-step is constant.
 */
int BocopDefinition::setTimeStages(void)
{
    if (m_flagMethodDone != true) {
        m_errorString.append("Discretization method must be defined before calling setTimeStages.\n");
        return 1;
    }

    if (this->m_timeSteps == 0) {
        m_errorString.append("Time nodes vector must be defined before calling setTimeStages.\n");
        return 2;
    }

    if ((this->m_dimStage <= 0) | (this->m_dimStep <= 0)) {
        m_errorString.append("Number of discretization steps, or stages, is incorrect.\n");
        return 3;
    }


    // Memory allocation for the discretization time stages :
    this->m_timeStages = new double[this->m_dimStep * this->m_dimStage];
    int ind = 0;
    double h = 0;

    // We have to set "m_dimStage" stages of discretization between two nodes.
    for (int i = 0; i < this->m_dimStep; i++) {
        h = m_timeSteps[i + 1] - m_timeSteps[i]; // current time step
        for (int j = 0; j < this->m_dimStage; j++) {
            m_timeStages[ind] = this->m_timeSteps[i] + this->m_discCoeffC[j] * h;
            ind++;
        }
    }

    return 0;
}


/**
 * \fn void BocopDefinition::getParamId(double* timeObs, double** obs, double** weights) const
 * This function allows to get all properties of the
 * problem's parameter identification.
 */
void BocopDefinition::getParamId(double** timeObs, int** indexObs, double** * obs, double** * weights, int k) const
{
    for (int i = 0; i < m_dimTimeObservation[k]; i++) {
        timeObs[k][i] = m_timeObservation[k][i];
        indexObs[k][i] = m_indexObservation[k][i];
    }

    for (int i = 0; i < m_dimObservation[k]; i++) {
        for (int j = 0; j < m_dimTimeObservation[k]; j++) {
            obs[k][i][j] = m_observations[k][i][j];
            weights[k][i][j] = m_weightObservations[k][i][j];
        }
    }
}


/**
 * \fn void BocopDefinition::merge(const double* timesToAdd,
                            const int dimTimesToAdd,
                            double*& times,
                            int& dimTimes,
                            int* indexAdded)
 * This function allows to merge two ordered vectors in ascending order, keeping memory of the indexes of the newly added elements.
 */

int BocopDefinition::merge(double** timesToAdd,
                           int* dimTimesToAdd,
                           double*& times,
                           int& dimTimes,
                           int** indexAdded)

{
    // We make a loop on the time arrays, for each experiment we have its time array
    for (int k = 0; k < m_sizeDataSet; k++) {

        int i = 0, j = 0, ktmp = 0, l = 0, m, n;
        double* tmp = new double[dimTimes + dimTimesToAdd[k]];

        // We explore the global time array and the experiment time array and we copy the elements in a temporary array tmp in ascending order
        while (i < dimTimes && j < dimTimesToAdd[k]) {

            if (times[i] < timesToAdd[k][j] - EPSILON)
                tmp[ktmp] = times[i++];
            else {
                // If we add an experiment time, we memorize the related index
                if (times[i] > timesToAdd[k][j] + EPSILON) {
                    tmp[ktmp] = timesToAdd[k][j++];
                    indexAdded[k][l++] = ktmp;

                    // We also have to increment the times of the previous experiments
                    for (m = 0; m < k ; m++) {
                        for (n = 0; n < m_dimTimeObservation[m]; n++) {
                            if (indexAdded[m][n] >= ktmp)
                                indexAdded[m][n]++;
                        }
                    }
                }
                // Equality case. We simply insert the observation time.
                else {
                    i++;
                    tmp[ktmp] = timesToAdd[k][j++];
                    indexAdded[k][l++] = ktmp;
                }
            }
            ktmp++;
        }

        // We add the remaining discretization times, if there  are still some
        if (i < dimTimes) {
            for (int p = i; p < dimTimes; p++)
                tmp[ktmp++] = times[p];
        }
        // We add the remaining observation times, if there  are still some
        else {
            if (i != dimTimes) {
                m_errorString.append("BocopDefinition::merge : ERROR. \n");
                m_errorString.append("Final time smaller than observation time in data set of index ");
                stringstream ss;
                ss << k;
                m_errorString.append(ss.str());
                m_errorString.append(".\nPlease make sure that the final times in the observation files are smaller than the final time of the problem.\n");
                return 1;
            }
            for (int p = j; p < dimTimesToAdd[k] ; p++) {
                tmp[ktmp++] = timesToAdd[k][p];
                j++;
                indexAdded[k][l++] = ktmp;

                // Update previous index lists
                for (m = 0; m < k - 1 ; m++) {
                    for (n = 0; n < m_dimTimeObservation[m]; n++) {
                        if (indexAdded[m][n] >= ktmp)
                            indexAdded[m][n]++;
                    }
                }
            }
        }

        // We finally copy tmp in times
        dimTimes = ktmp;
        delete[] times;
        times = new double[dimTimes];
        for (i = 0; i < dimTimes; i++)
            times[i] = tmp[i];
        delete[] tmp;
    }

    return 0;
}


/**
 * \fn void BocopDefinition::isParamId()
 * This function allows to merge two ordered vectors in ascending order, keeping memory of the indexes of the newly added elements.
 *
 */
bool BocopDefinition::isParamId()
{
    if (m_paramIdType == "LeastSquare" || m_paramIdType == "LeastSquareWithCriterion" || m_paramIdType == "Manual")
        return true;
    else
        return false;
}

