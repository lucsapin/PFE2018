// Copyright (C) 2011-2014 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: BocopOptimize.cpp
// Authors: Vincent Grelard, Daphne Giorgi

//using namespace std; commented in order to avoid warning from the compilation with Mac

#include <BocopOptimize.hpp>

/**
 *\fn BocopOptimize::BocopOptimize(const bocopDefPtr DEF)
 * Constructor.
 */
BocopOptimize::BocopOptimize(const bocopDefPtr DEF)
{
    MyDef = DEF;
}

/**
 *\fn BocopOptimize::~BocopOptimize()
 * Destructor.
 */
BocopOptimize::~BocopOptimize()
{}


// *** solve_problem ***
/**
  *\fn int BocopOptimize::solve_single_problem()
  * Function to solve the current problem. All data are read from the
  * files located in the problem's directory. It means that if one wants
  * to solve the same problem, using different parameters, one must
  * change the values inside the definition files.
  */
int BocopOptimize::solve_single_problem(const bocopDefPtr myBocopDefPtr)
{
    // Create an instance of your nlp
    BocopProblem* BocopProblemInstance = new BocopProblem(myBocopDefPtr);
    SmartPtr<TNLP> MyBocopNLP(BocopProblemInstance);
    // Create an instance of the IpoptApplication
    SmartPtr<IpoptApplication> app = new IpoptApplication();

    // Initialize the IpoptApplication and process the options
    ApplicationReturnStatus status;

    // We set the initial method for ipopt, it can be a new start,  cold start or a warm start
    // We read this information in BocopProblem and we pass it the IpoptApplication
    string m_initMethod_ipopt = BocopProblemInstance->getInitMethod();

    if (m_initMethod_ipopt == "from_sol_file_warm") {
        app->Options()->SetStringValue("warm_start_init_point", "yes");
        //        app->Options()->SetNumericValue("warm_start_bound_push", 1e-6);
        //        app->Options()->SetNumericValue("warm_start_mult_bound_push", 1e-6);
        //        app->Options()->SetNumericValue("mu_init", 1e-6);
    }

    status = app->Initialize();

    if (status != Solve_Succeeded) {
        printf("\n\n*** Error during initialization!\n");
        return (int) status;
    }

    status = app->OptimizeTNLP(MyBocopNLP);

    // Retrieve some statistics about the execution of Ipopt
    Index iter_count = app->Statistics()->IterationCount();
    Number final_obj = app->Statistics()->FinalObjective();
    Number dual_inf, constr_viol, complementarity, kkt_error;
    app->Statistics()->Infeasibilities(dual_inf, constr_viol, complementarity, kkt_error);
    Number total_cpu_time = app->Statistics()->TotalCPUTime();
    this->iter = (int)iter_count;
    this->obj = (double)final_obj;
    this->constr = (double)constr_viol;
    this->cpu = (double)total_cpu_time;

    // We write at the end of solution file the cpu and the iterations
    string solFile = myBocopDefPtr->nameSolutionFile();

    // Open the file where we want to write the results
    ofstream file_out(solFile.c_str(), ios::out | ios::binary | ios::app);

    if (!file_out)  { // if the opening failed
        cerr << endl << " BocopOptimize::solve_single_problem : ERROR! " << endl;
        cerr << " Cannot open solution file (" << solFile << ") to write the Ipopt statistics." << endl << endl;
        exit(1);
    }

    file_out << endl << "# Cpu time : " << endl << this->cpu << endl;
    file_out << endl << "# Iterations : " << endl << this->iter << endl;

    file_out.close();

    return (int) status;
}

/**
  *\fn string BocopOptimize::get_status_string(const int status)
  * This function returns a string giving the status at the end of
  * the optimization process. This string matches IPOPT standard
  * names for status.
  */
string BocopOptimize::get_status_string(const int status)
{
    string status_str;

    switch (status) {
        case Solve_Succeeded:
            status_str = "Solve_Succeeded";
            break;
        case Maximum_Iterations_Exceeded:
            status_str = "Maximum_Iterations_Exceeded";
            break;
        case Maximum_CpuTime_Exceeded:
            status_str = "Maximum_CpuTime_Exceeded";
            break;
        case Search_Direction_Becomes_Too_Small:
            status_str = "Search_Direction_Becomes_Too_Small";
            break;
        case Solved_To_Acceptable_Level:
            status_str = "Solved_To_Acceptable_Level";
            break;
        case Feasible_Point_Found:
            status_str = "Feasible_Point_Found";
            break;
        case Diverging_Iterates:
            status_str = "Diverging_Iterates";
            break;
        case Restoration_Failed:
            status_str = "Restoration_Failed";
            break;
        case Error_In_Step_Computation:
            status_str = "Error_In_Step_Computation";
            break;
        case Infeasible_Problem_Detected:
            status_str = "Infeasible_Problem_Detected";
            break;
        case User_Requested_Stop:
            status_str = "User_Requested_Stop";
            break;
        case Invalid_Number_Detected:
            status_str = "Invalid_Number_Detected";
            break;
        case Internal_Error:
            status_str = "Internal_Error";
            break;
        default :
            status_str = "Unknown";
            break;
    }

    return status_str;
}

