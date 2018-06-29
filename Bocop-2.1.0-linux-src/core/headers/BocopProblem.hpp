// This code is published under the Eclipse Public License
// original code for ipopt interface by Andrea Walther
// Authors: Vincent Grelard, Daphne Giorgi, Pierre Martinon, Olivier Tissot
// Inria Saclay and CMAP Ecole Polytechnique
// 2013-2017


/**
 * \file BocopProblem.hpp
 * \brief Class BocopProblem header.
 * \author Vincent Grelard
 * \date 06/2012
 *
 * Class BocopProblem converts the optimal control problem into a NLP problem, so that
 * it can be solved by a NLP solver. This class derives from Ipopt class TNLP, and it
 * implements virtual methods needed to run the optimization.
 * BocopProblem uses a BocopDefinition instance to set the parameters and options of
 * the problem, the starting point of the optimizer is built from class StartingPoint.
 *
 */

#ifndef __BOCOPPROBLEM_HPP__
#define __BOCOPPROBLEM_HPP__

#include <string>
#include <iostream>
#include <fstream>
#include <sstream>

// AUTOMATIC DIFFERENTIATION: AODLC/COLPACK OR CPPAD
#ifdef USE_CPPAD
#include <cppad/cppad.hpp>
#else
#include <adolc/adolc.h>
#include <adolc/adolc_sparse.h> // SPARSE COLPACK
#define tag_f 1
#define tag_g 2
#define tag_L 3
#endif

// NLP SOLVER: IPOPT
#include <IpTNLP.hpp>
#include <IpIpoptCalculatedQuantities.hpp>
using namespace Ipopt;


#include "BocopDefinition.hpp"
#include "StartingPoint.hpp"
#include "tools.hpp"
#include "GenerationVariable.hpp"
#include "postProcessing.hpp"






/**
 * \class BocopProblem
 * \brief Converts optimal control into NLP
 *
 * BocopProblem gives methods to convert an optimal control problem into a NLP. This class
 * derives from Ipopt's TNLP, and implements virtual methods needed to solve the NLP.
 *
 * This code is based on the file ADOL-C_sparseNLP.cpp contained in the
 * ADOL-C package with the author Andrea Walther. This file itself is based
 * on the file  MyNLP.cpp contained in the Ipopt package with the authors:
 * Carl Laird, Andreas Waechter
 */
class BocopProblem : public TNLP
{

public:
    /** @name Constructors and Destructor	*/

    /** Constructor for class BocopProblem */
    BocopProblem(const bocopDefPtr bocopDef);

    /** Default constructor for class BocopProblem */
    BocopProblem();  //default constructor

    /** Destructor for class BocopProblem */
    ~BocopProblem(); // destructor

    /** @name Overloaded from TNLP
     * @{
     */
    /** Method to return some info about the nlp */
    bool get_nlp_info(Index& n,
                      Index& m,
                      Index& nnz_jac_g,
                      Index& nnz_h_lag,
                      IndexStyleEnum& index_style);

    /** Method to return the bounds for my problem */
    bool get_bounds_info(Index n,
                         Number* x_l,
                         Number* x_u,
                         Index m,
                         Number* g_l,
                         Number* g_u);

    /** Method to return the starting point for the algorithm */
    bool get_starting_point(Index n,
                            bool init_x,
                            Number* x,
                            bool init_z,
                            Number* z_L,
                            Number* z_U,
                            Index m,
                            bool init_lambda,
                            Number* lambda);

    /** Original method from Ipopt to return the objective value */
    /** remains unchanged */
    bool eval_f(Index n, const Number* x, bool new_x, Number& obj_value);

    /** Original method from Ipopt to return the gradient of the objective */
    /** remains unchanged */
    bool eval_grad_f(Index n, const Number* x, bool new_x, Number* grad_f);

    /**  Original method from Ipopt to return the constraint residuals */
    /** remains unchanged */
    bool eval_g(Index n, const Number* x, bool new_x, Index m, Number* g);

    /** Original method from Ipopt to return:
         *   1) The structure of the jacobian (if "values" is NULL)
         *   2) The values of the jacobian (if "values" is not NULL)
         */
    /** remains unchanged */
    virtual bool eval_jac_g(Index n,
                            const Number* x,
                            bool new_x,
                            Index m,
                            Index nele_jac,
                            Index* iRow,
                            Index* jCol,
                            Number* values);

    /** Original method from Ipopt to return:
         *   1) The structure of the hessian of the lagrangian (if "values" is NULL)
         *   2) The values of the hessian of the lagrangian (if "values" is not NULL)
         */
    /** remains unchanged */
    virtual bool eval_h(Index n,
                        const Number* x,
                        bool new_x,
                        Number obj_factor,
                        Index m,
                        const Number* lambda,
                        bool new_lambda,
                        Index nele_hess,
                        Index* iRow,
                        Index* jCol,
                        Number* values);


    /** Solution Method */
    /** This method is called when the algorithm is complete so the TNLP can store/write the solution. */
    virtual void finalize_solution(SolverReturn status,
                                   Index n,
                                   const Number* x,
                                   const Number* z_L,
                                   const Number* z_U,
                                   Index m,
                                   const Number* g,
                                   const Number* lambda,
                                   Number obj_value,
                                   const IpoptData* ip_data,
                                   IpoptCalculatedQuantities* ip_cq);

    /** @} */

        /** Method to return the initial method (new start, cold start or warm start). */
        string getInitMethod() {
            return m_bocopDefPtr->methodInitialization();   // remove +++?
        }

        /** Template to return the objective value. */
        template<class Tdouble> bool evalObjective(Index n, const Tdouble* x, Tdouble& obj_value);

        /** Template to compute contraints. */
        template<class Tdouble> bool evalConstraints(Index n, const Tdouble* x, Index m, Tdouble* g);

        // Function to write the definition in a file
        /** Bocop output method to write the definition in a file. */
        void writeDefinition(ofstream& file_out);

        // Functions to write the solution in a file
        void extractVariables(const Number* x, double **state, double **control, double **kstage, double ** algvars, double *parameters);
        void extractDataBlock1D(const Number* x, int begin, int stride, int dim, double* datablock);
        void writeDataBlock1D(ofstream& file_out, string label, int dim, double* datablock);
        void writeDataBlock2D(ofstream& file_out, string header, int dim1, int dim2, double** datablock);

        /** Bocop output method to write the discretized times in a file. */
        void writeDiscretizedTimes(ofstream& file_out);
        /** Bocop output method to write the discretized variables in a file. */
        void writeDiscretizedVariables(ofstream& file_out,
                                       const Number* x,
                                       bool is_postprocessing,
                                       double** state,
                                       double** control,
                                       double** algebraic,
                                       double* parameter);
        void writeDiscretizedMultipliers(ofstream& file_out,
                                         Index m,
                                         const Number* lambda,
                                         bool is_postprocessing,
                                         double* boundaryCondMultiplier,
                                         double** pathConstrMultiplier,
                                         double** adjointState);
        /** Bocop output method to write the iteration solution in a file. */
        void writeIterSolution(int iter_index,
                               Index m,
                               const Number* x,
                               const Number* lambda);
        /** Bocop output method to write the solution in a file. */
        void writeSolution(Index n,
                           const Number* x,
                           const Number* z_L,
                           const Number* z_U,
                           Index m,
                           const Number* g,
                           Number obj_value,
                           const Number* lambda,
                           const IpoptData* ip_data,
                           IpoptCalculatedQuantities* ip_cq,
                           double** state,
                           double** control,
                           double** algebraic,
                           double* parameter,   // si tf libre, j'enleve le dernier element?
                           double* boundaryCondMultiplier,
                           double** pathConstrMultiplier,
                           double** adjointState);

#ifndef USE_CPPAD

        //***************    start ADOL-C part ***********************************
        /** @name ADOL-C automatic differentiation */
        /** Method to generate the required tapes. */
        virtual void generateTapes(Index n, Index m, Index& nnz_jac_g, Index& nnz_h_lag);
        //***************    end   ADOL-C part ***********************************

#else

    //***************    start CppAD part ***********************************
    /** @name CppAD automatic differentiation */
    /** Method to generate the operation sequences */
    virtual void generateOpSeq(Index n, Index m, Index& nnz_jac_g, Index& nnz_h_lag);
    //***************    end   CppAD part ***********************************


#endif


    protected :

        /** @name BOCOP : extraction from main vector of variables */

        /** Method to get the vector of variables (state, control and algebraic, and optimization variables) at a given stage. */
        template<class Tdouble> void getX(const Tdouble* VEC, const int l, const int i, Tdouble* x_stage);
        /** Method to get the state variables vector at a given stage of the discretization method. */
        template<class Tdouble> void getStateAtStage(const Tdouble* VEC, const Tdouble dt, const int l, const int i, Tdouble* y_stage);
        /** Method to get the control variables vector at a given stage of the discretization method. */
        template<class Tdouble> void getControl(const Tdouble* VEC, const int l, const int i, Tdouble* u_stage);
        /** Method to get the algebraic variables vector at a given stage of the discretization method. */
        template<class Tdouble> void getAlgebraic(const Tdouble* VEC, const int l, const int i, Tdouble* z_stage);
        /**  Method to get the state variables vector at a given time discretization step. */
        template<class Tdouble> void getStateAtStep(const Tdouble* VEC, const int l, Tdouble* y_step);

        /** Method to get a state variables matrix at a given set of time discretization steps. */
        template<class Tdouble> void getStateAtSteps(const Tdouble* VEC, const int* indexes, const int dimIndexes, Tdouble** y_step);

        /**  Method to get the optimization variables vector. */
        // Function to get optimization variables :
        template<class Tdouble> void getParameter(const Tdouble* VEC, Tdouble* vec_p);

        /** @name BOCOP : time extraction */

        /** Method to get the width of a given time step. */
        // Function to get the value of the time step :
        template<class Tdouble> Tdouble getTimeStep(const int i, const Tdouble* VEC);
        /** Method to get the unnormalized time value from a normalized one. */
        // Get the unnormalized time value from a normalized one :
        template<class Tdouble> Tdouble UnnormalizedTime(const double normalized_time, const Tdouble T_F);

        /** @name BOCOP : constraints */
        // Functions for the discretization method :
        /** Method to compute the dynamic f() at all stages of the discretization method. */
        template<class Tdouble> void computeDynamics(const Tdouble* VEC, Tdouble* vec_dyn);
        /** Method to compute the dynamic constraint y'-f() at all stages of the discretization method. */
        template<class Tdouble> void computeDynConstraints(const Tdouble* VEC, Tdouble* vec_dyn_constr);

        /** @name BOCOP : pointer to definition */
        bocopDefPtr m_bocopDefPtr;

        /** @name BOCOP : pointers to generation variables used to write the init files */
        GenerationVariable* m_genState;
        GenerationVariable* m_genControl;
        GenerationVariable* m_genAlgebraic;

        double* m_genParameter;

        /** Size of the problem (at one time step) :
          * dimState + dimStage*(dimControl + dimState + dimAlgebraic). */
        int m_dimProblem;

        /** Total size of the discretized problem. */
        int m_dimX;
        /** Total size of the constraints. */
        int m_dimConstraints;

        /** Current iteration index. */
        int m_currentIteration;

#ifndef USE_CPPAD
    /** @name ADOL-C variables for sparsity exploitation */
    int m_adolc_repeat;
    double *m_xlf;  /**< Input variables (x,lambda,objfactor). */

    /* Jacobian of constraints (row indices, column indices, values, non zero elements). */
    unsigned int *m_rind_jac; /**< Row index (CSR format). */
    unsigned int *m_cind_jac; /**< Column index (CSR format). */
    double *m_val_jac; /**< Values of Jacobian (CSR format). */
    int m_nnz_jac; /**< Non-zero values number in Jacobian. */
    int m_options_jac[4]; /**< ADOL-C options for Jacobian computation. */

    /* Hessian of Lagrangian (full wrt (x,lambda,objfactor) or only wrt variables x). */
    unsigned int *m_rind_hess; /**< Row index (CSR format) partial Hess (wrt x only). */
    unsigned int *m_cind_hess; /**< Column index (CSR format) partial Hess (wrt x only). */
    unsigned int *m_rind_hess_total; /**< Row index (CSR format) full Hess (wrt [x,lambda,objfactor]). */
    unsigned int *m_cind_hess_total; /**< Column index (CSR format) full Hess (wrt [x,lambda,objfactor]). */
    double *m_val_hess; /**< Values of Hessian (CSR format). */
    int m_nnz_hess; /**< Non-zero values number in partial Hessian (wrt x only). */
    int m_nnz_hess_total; /**< Non-zero values number in full Hessian (wrt [x,lambda,objfactor]). */
    int m_options_hess[2]; /**< ADOL-C options for Hessian computation. */

#else
    /** @name CppAD variables for sparsity exploitation */
    // active variables (ADvector)
    vector< CppAD::AD<double> > m_x_ad;
    vector< CppAD::AD<double> > m_g_ad;
    vector< CppAD::AD<double> > m_objvalue_ad;
    vector< CppAD::AD<double> > m_lagvalue_ad;

    CppAD::ADFun<double> f_obj, g_con, h_lag;
    vector<double> m_grad;

    CppAD::vector<std::set<size_t> > m_pattern_jac;
    CppAD::vector<size_t> m_col_jac, m_row_jac;
    CppAD::sparse_jacobian_work m_work_jac;
    vector<double> m_x2, m_jac;

    CppAD::vector<std::set<size_t> > m_pattern_hess;
    CppAD::vector<size_t> m_col_hess, m_row_hess;
    CppAD::sparse_hessian_work m_work_hess;
    vector<double> m_xlf2, m_hess;

#endif

};

#include "evalNLPFunctions.tpp"
#include "discTools.tpp"
#include "computeDynConstraints.tpp"

#endif

