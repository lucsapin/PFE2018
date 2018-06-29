// This code is published under the Eclipse Public License
// Authors: Vincent Grelard, Pierre Martinon, Daphne Giorgi
// Inria Saclay and CMAP Ecole Polytechnique
// 2011-2017

#include <BocopProblem.hpp>

using namespace Ipopt;

#ifndef USE_CPPAD

//***************    ADOL-C part ***********************************
/**
 * \fn void BocopProblem::generateTapes(Index n, Index m, Index& nnz_jac_g, Index& nnz_h_lag)
 *
 * Method to generate ADOL-C tapes.
 * Each block is enclosed in trace_on(label) ... trace_off()
 * 1) First initialize input variables with <<= operator
 * 2) Call function
 * 3) Retrieve results with >>= operator
 *
 */
void BocopProblem::generateTapes(Index n, Index m, Index& nnz_jacobian, Index& nnz_hessian)
{

    cout << "Computing sparse structure for derivatives (Adol-C)..." << endl;

    adouble *x_ad = new adouble[n];
    adouble *g_ad = new adouble[m];
    adouble *lambda_ad = new adouble[m];
    adouble objfactor_ad;
    adouble objvalue_ad;

    // for use in overloaded_from_nlp (keep repeat = 0 for the following calls in generateTapes)
    m_adolc_repeat = 1;

    double dummy;
    int i;

    // array for (x,lambda,objfactor)
    m_xlf = new double[n+m+1];
    for (i=0;i<n+m+1;i++)
        m_xlf[i] = 1.0;

    // Objective
    trace_on(tag_f);
    for(Index idx = 0; idx < n ; idx++)
        x_ad[idx] <<= m_xlf[idx];
    evalObjective(n,x_ad,objvalue_ad);
    objvalue_ad >>= dummy;
    trace_off();

    // Constraints
    trace_on(tag_g);
    for(Index idx = 0 ; idx < n; idx++)
        x_ad[idx] <<= m_xlf[idx];
    evalConstraints(n,x_ad,m,g_ad);
    for(Index idx = 0 ; idx < m; idx++)
        g_ad[idx] >>= dummy;
    trace_off();

    // Lagrangian L = sigma * f + <lambda,g>

    // FULL HESSIAN VERSION
    trace_on(tag_L);
    for(Index idx = 0; idx < n; idx++)
        x_ad[idx] <<= m_xlf[idx];
    for(Index idx = 0; idx < m; idx++)
        lambda_ad[idx] <<= m_xlf[n+idx];
    objfactor_ad <<= m_xlf[n+m];
    evalObjective(n,x_ad,objvalue_ad);
    objvalue_ad *= objfactor_ad;
    evalConstraints(n,x_ad,m,g_ad);
    for(Index idx = 0; idx < m; idx++)
        objvalue_ad += g_ad[idx] * lambda_ad[idx];
    objvalue_ad >>= dummy;
    trace_off();

    // get sparse jacobian for constraints
    m_options_jac[0] = 0;
    m_options_jac[1] = 0; // 0: safe mode (default) 1: tight mode (required for active subscripting)
    m_options_jac[2] = 0;
    m_options_jac[3] = 0;
    sparse_jac(tag_g, m, n, 0, m_xlf, &m_nnz_jac, &m_rind_jac, &m_cind_jac, &m_val_jac, m_options_jac);
    nnz_jacobian = m_nnz_jac;

    // get sparse hessian of the Lagrangian
    
    // full hessian wrt (x,lambda,objfactor)
    // option[0]: graph control flow 0: safe mode (default) 1: tight mode (required for active subscipting) 2: old safe mode
    // option[1]: recovery mode (doc?) 0: direct (default) 1: indirect
    // best choice overall seems to be option_hess[0]=0, option_hess[1]=1
    m_options_hess[0] = 0;
    m_options_hess[1] = 1;
    sparse_hess(tag_L, n+m+1, 0, m_xlf, &m_nnz_hess_total, &m_rind_hess_total, &m_cind_hess_total, &m_val_hess, m_options_hess);

    // extract Hessian wrt x only
    m_nnz_hess = 0;
    m_rind_hess = new unsigned int[m_nnz_hess_total];
    m_cind_hess = new unsigned int[m_nnz_hess_total];
    for (i = 0; i < m_nnz_hess_total; i++)
    {
        if ( (m_rind_hess_total[i] < (unsigned int) n) && (m_cind_hess_total[i] < (unsigned int) n) )
        {
            m_rind_hess[m_nnz_hess] = m_rind_hess_total[i];
            m_cind_hess[m_nnz_hess] = m_cind_hess_total[i];
            m_nnz_hess++;
        }
    }
    nnz_hessian = m_nnz_hess;

    // deallocations
    delete[] x_ad;
    delete[] g_ad;
    delete[] lambda_ad;

    cout << "Done." << endl;
}


#else

//***************  CppAD part ***********************************
/**
 * \fn void BocopProblem::generateOpSeq_CppAD(Index n, Index m, Index& nnz_jac_g, Index& nnz_h_lag)
 *
 * Method to generate operation sequences for CppAD.
 * Type for (in)dependent variables is CppAD<double>   (will fit template type Tdouble)
 * Each block is enclosed in CppAD::Independant(X) ... CppAD::ADFun<double> f(X,Y)
 * Derivatives are then available as f.Jacobian(x) etc...
 *
 */
void BocopProblem::generateOpSeq(Index n, Index m, Index& nnz_jacobian, Index& nnz_hessian)
{
    cout << "Computing sparse structure for derivatives (CppAD)..." << endl;

    int i,j;

    //change rien...
    //CppAD::thread_alloc::hold_memory(true);


    // generic inits
    m_x_ad.resize(n);
    m_g_ad.resize(m);
    m_objvalue_ad.resize(1);
    m_lagvalue_ad.resize(1);
    for(i=0; i < n; i++)
        m_x_ad[i] = 1e0;


    // Objective gradient
    Independent(m_x_ad);
    evalObjective(n,&m_x_ad[0],m_objvalue_ad[0]);
    f_obj.Dependent(m_x_ad,m_objvalue_ad);
    f_obj.optimize();
    m_grad.resize(n);


    // Constraints
    Independent(m_x_ad);
    evalConstraints(n,&m_x_ad[0],m,&m_g_ad[0]);
    g_con.Dependent(m_x_ad,m_g_ad);
    g_con.optimize();

    // initialize sparse structure for jacobian
    int dim = min(n,m);
    CppAD::vector<std::set<size_t> > r(dim);
    for (i=0; i<dim;i++)
        r[i].insert(i);
    if (n <= m)
        m_pattern_jac = g_con.ForSparseJac(n,r);
    else
        m_pattern_jac = g_con.RevSparseJac(m,r);

    // retrieve index sets and nnz for jacobian
    std::set<size_t> :: const_iterator itr,end;
    for (i=0;i<m;i++)
    {
        itr = m_pattern_jac[i].begin();
        end = m_pattern_jac[i].end();
        while (itr != end)
        {
            j=*itr++;
            m_row_jac.push_back(i);
            m_col_jac.push_back(j);
        }
    }
    nnz_jacobian = m_col_jac.size();
    m_jac.resize(nnz_jacobian);
    m_x2.resize(n);


    // Lagrangian L = sigma * f + <lambda,g>

    // FULL HESSIAN VERSION

    // init
    vector< CppAD::AD<double> > xlf_ad(n+m+1);
    for(i=0; i < n+m+1; i++)
        xlf_ad[i] = 1e0;

    // Lagrangian as function of (x,lambda,objfactor)
    Independent(xlf_ad);
    evalObjective(n,&xlf_ad[0],m_objvalue_ad[0]);
    m_lagvalue_ad[0] = m_objvalue_ad[0] * xlf_ad[n+m];
    evalConstraints(n,&xlf_ad[0],m,&m_g_ad[0]);
    for(i=0; i < m; i++)
        m_lagvalue_ad[0] += m_g_ad[i] * xlf_ad[n+i];
    h_lag.Dependent(xlf_ad,m_lagvalue_ad);
    h_lag.optimize();

    // initialize sparse structure for hessian
    dim = n+m+1;
    CppAD::vector<std::set<size_t> > r_set(dim);
    for(i = 0; i < dim; i++)
        r_set[i].insert(i);
    h_lag.ForSparseJac(dim, r_set);

    CppAD::vector<std::set<size_t> > s_set(1);
    s_set[0].insert(0);
    m_pattern_hess = h_lag.RevSparseHes(dim,s_set);

    // retrieve index sets and nnz for hessian
    m_row_hess.clear();
    m_col_hess.clear();
    for (i=0;i<dim;i++)
    {
        itr = m_pattern_hess[i].begin();
        end = m_pattern_hess[i].end();
        while (itr != end)
        {
            j=*itr++;
            // keep only the upper triangular n x n part of the hessian !
            if (j<n && i<=j)
            {
                m_row_hess.push_back(i);
                m_col_hess.push_back(j);
            }
        }
    }

    //  m_nnz_hess = m_col_hess.size();
    nnz_hessian = m_col_hess.size();
    m_hess.resize(nnz_hessian);
    m_xlf2.resize(dim);

    //check for reused structures (DEBUG)
#ifndef NDEBUG
    cout << "In generate OpSeq" << endl;
    cout << "pattern " << m_pattern_hess.size() << " row " << m_row_hess.size() << " col " << m_col_hess.size() << " work " << m_work_hess.color.size() << endl;
#endif

    cout << "Done." << endl;
}

#endif


