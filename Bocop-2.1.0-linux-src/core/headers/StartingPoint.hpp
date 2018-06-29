// This code is published under the Eclipse Public License
// File: StartingPoint.hpp
// Authors: Vincent Grelard, Daphne Giorgi, Pierre Martinon
// Inria Saclay and Cmap Ecole Polytechnique
// 2011-2016

/**
 * \file StartingPoint.hpp
 * \brief Class StartingPoint header.
 * \author Vincent Grelard, Daphne Giorgi, Pierre Martinon
 *
 */

#ifndef STARTING_POINT_H
#define STARTING_POINT_H

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <cstdlib>
#include <vector>

#include "BocopInterpolation.hpp"
#include "GenerationVariable.hpp"
#include "tools.hpp"
#include "functions.hpp"

using namespace std;

/**
 * \class StartingPoint
 * \brief Abstract class to define the optimization starting point
 * \author Vincent Grelard, Daphne Giorgi, Pierre Martinon
 *
 * Set the starting point for the discretized NLP problem.
 * It is possible to use an existing solution
 * file as initialization, even with a different discretization.
 * If the discretization of the initialization data  and the problem discretization
 * is not the same, we interpolate.
 */
class StartingPoint
{
    protected :
        /** @name Dimensions of the current problem */
        /** number of discretization steps */
        int m_dimStep;
        /** number of stages of the discretization method */
        int m_dimStage;
        /**  dimension of the state variables */
        int m_dimState;
        /** dimension of the control variables */
        int m_dimControl;
        /**  dimension of the algebraic variables */
        int m_dimAlgebraic;
        /**  dimension of the optimization variables */
        int m_dimParameter;
        /**  dimension of the constants */
        int m_dimConstant;
        /**  dimension of the main vector to initialize */
        int m_dimStartingPoint;

        // Generation variables used to create the starting point. Their number of discre-
        // tization steps might be different from those in the problem which we are
        // currently trying to initialize. In such case, we interpolate.
        /** @name Values before interpolation*/
        GenerationVariable* m_genState; // state before interpolation as read in init files
        GenerationVariable* m_genControl; // control before interpolation as read in init files
        GenerationVariable* m_genAlgebraic; // algebraic vars before interpolation as read in init files

        // Arrays for the starting point after interpolation :
        /** @name Values after interpolation*/
        double* m_timeSteps; // time steps array where we interpolate
        double* m_timeStages; // time stages array where we interpolate
        double** m_state; // state after interpolation
        double** m_control; // control after interpolation
        double** m_algebraic; // algebraic vars after interpolation

        /** @name Non-interpolated arrays */
        double* m_parameter; // optimization parameters
        double* m_constant; // constants

        /** @name Initial and final time */
        double m_t0;
        double m_tF;
        string m_freeTime;

        /** @name Flags */
        bool m_flagAllocGen; // flag to tell if memory was allocated to store generation variables
        bool m_flagAllocInterp; // flag to tell if memory was allocated to store results of the interpolation

        /** @name Read and interpolate methods */
        virtual int readVariables() = 0; // pure virtual function to read the generation variables
        int interpolateVariables(); // function to get the arrays of variables in the current problem's dimension

        int allocateGenerationVars();
        void deallocateGenerationVars();

        int allocateInterpolationVars();
        void deallocateInterpolationVars();

        /** @name Principal method: generates the starting point */
        int generateStartingPoint();

    public :

        /** @name Starting point outputs */
        double* m_startingPoint;
        double* m_startingLambda;
        double* m_startingZL;
        double* m_startingZU;

        /** @name Constructor and destructor
          * @{
          */
        StartingPoint(const int n,
                      const double* m_timeSteps,
                      const double* m_timeStages,
                      const int n_y,
                      const int n_u,
                      const int n_z,
                      const int n_p,
                      const int m_dimStage,
                      const int n_total,
                      const int n_c,
                      const double* constants,
                      const double t0,
                      const double tf,
                      const string m_freeTime);

        virtual ~StartingPoint();
        /** @} */

        void writeStartingPointFile(string);

        virtual int setSolutionFile(string) = 0;
        virtual int setStartingPoint() = 0; // pure virtual function to compute the starting point

        /** @name Getters */
        GenerationVariable* getGenState() const {
            return m_genState;
        }
        GenerationVariable* getGenControl() const {
            return m_genControl;
        }
        GenerationVariable* getGenAlgebraic() const {
            return m_genAlgebraic;
        }
        double* getGenParameter() const {
            return m_parameter;
        }
};


/** \class StartFromPreviousSolution
  * \brief Define the optimization starting point from a previous solution
  * \author Vincent Grelard, Daphne Giorgi, Pierre Martinon
  */
class StartFromPreviousSolution : public StartingPoint
{
    protected :
        /** @name Dimensions
         * @{
         */
        /** Dimension of the variables before interpolation */
        int m_dimGenStep;
        int m_dimGenStage;

        // dimension of the constraints :
        /** Dimension of the constraints */
        int m_dimBoundaryCond;
        int m_dimPathCond;

        /** @} */

        // vector of multipliers read from solution file
        /** @name Multipliers read from solution file */
        double* m_boundaryCondLambda;
        GenerationVariable* m_genPathCondLambda;
        GenerationVariable* m_genDynCondLambda;

        /** @name Bound multipliers read from solution file */
        GenerationVariable* m_genStateZL;
        GenerationVariable* m_genStateZU;
        GenerationVariable* m_genControlZL;
        GenerationVariable* m_genControlZU;
        GenerationVariable* m_genAlgebraicZL;
        GenerationVariable* m_genAlgebraicZU;
        double* m_parameterZL;
        double* m_parameterZU;

        /** @name Multipliers calculated with the new time grid and the new discretization method */
        double** m_dynCondLambda;
        double** m_pathCondLambda;

        /** @name Bound multipliers calculated with the new time grid and the new discretization method */
        double** m_stateZL;
        double** m_stateZU;
        double** m_controlZL;
        double** m_controlZU;
        double** m_algebraicZL;
        double** m_algebraicZU;

        /**  @name New discretization coefficients for the calculation of the new multipliers */
        double* m_discCoeffB;

        /**  @name Solution file */
        string m_solutionFile;

        /**  @name Boolean to tell if it's a warm start or a cold start
         * @{
         */
        /** Its value comes from ipopt options, it's true if it's a warm start, false if it's a cold start */
        bool m_initLambda;
        /** @} */

        bool m_flagAllocGenLambda; // flag to tell if memory was allocated to store generation multipliers
        bool m_flagAllocInterpLambda; // flag to tell if memory was allocated to store interpolation multipliers

        bool m_flagAllocGenZ; // flag to tell if memory was allocated to store generation bound multipliers
        bool m_flagAllocInterpZ; // flag to tell if memory was allocated to store interpolation bound multipliers

        /**  @name Read methods
         * @{
         */
        int readDimensions();
        int readVariables();
        /** @} */

        /**  @name Methods to get the arrays of multipliers in the current problem's dimension */
        int interpolateMultipliers();
        int interpolateBoundMultipliers();

        /**  @name Methods to generate the starting point multipliers
         *@{ */
        int generateStartingLambda();
        int generateStartingZ();
        /** @} */

        int allocateGenMultipliers();
        void deallocateGenMultipliers();
        int allocateInterpMultipliers();
        void deallocateInterpMultipliers();

        int allocateGenBoundMultipliers();
        void deallocateGenBoundMultipliers();
        int allocateInterpBoundMultipliers();
        void deallocateInterpBoundMultipliers();

    public:

        /** @name Constructors and destructor */
        StartFromPreviousSolution(const int n,
                                  const double* m_timeSteps,
                                  const double* m_timeStages,
                                  const int n_y,
                                  const int n_u,
                                  const int n_z,
                                  const int n_p,
                                  const int n_if,
                                  const int n_path,
                                  const int m_dimStage,
                                  const int n_total,
                                  const int n_c,
                                  const double* constants,
                                  const double t0,
                                  const double tf,
                                  const string m_freeTime,
                                  const bool init_lambda,
                                  const double* b = 0);

        ~StartFromPreviousSolution();


        int setSolutionFile(string);
        int setStartingPoint();

};

/** \class StartFromInitFile
  * \brief Define the optimization starting point from a dedicated initialization file
  * \author Vincent Grelard, Daphne Giorgi, Pierre Martinon
  */
class StartFromInitFile : public StartingPoint
{
    protected :
        /**  @name Read methods
         * @{
         */
        int readVariables();
        int readOptimVars();
        /** @} */
        int default_optimvars_init_file(const string, const int) const;
    public:
        StartFromInitFile(const int n,
                          const double* m_timeSteps,
                          const double* m_timeStages,
                          const int n_y,
                          const int n_u,
                          const int n_z,
                          const int n_p,
                          const int m_dimStage,
                          const int n_total,
                          const int n_c,
                          const double* constants,
                          const double t0,
                          const double tf,
                          const string m_freeTime) :
            StartingPoint(n, m_timeSteps, m_timeStages, n_y, n_u, n_z, n_p, m_dimStage, n_total, n_c, constants, t0, tf, m_freeTime) {};

        ~StartFromInitFile();

        int setSolutionFile(string);
        int setStartingPoint();
};

#endif

