// This code is published under the Eclipse Public License
// File: BocopOptimizeBatch.cpp
// Authors: Vincent Grelard, Daphne Giorgi, Pierre Martinon
// Inria Saclay and Cmap Ecole Polytechnique
// 2011-2016

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <limits>
#include <cstdlib>

using namespace std;

#include <BocopDefinition.hpp>
#include <BocopOptimize.hpp>

#if defined(_WIN32)
#include <direct.h>  // for _mkdir
#endif


/**
 * \fn BocopOptimizeBatch::BocopOptimizeBatch(const bocopDefPtr DEF)
 * \param DEF
 * Constructor
 */
BocopOptimizeBatch::BocopOptimizeBatch(const bocopDefPtr DEF) :
    BocopOptimize(DEF)
{
    this->type = DEF->typeBatch();
    this->index = DEF->indexBatch();
    this->startingbound = DEF->startingBatch();
    this->endingbound = DEF->endingBatch();
    this->n_batch = DEF->rangeBatch();
    this->batch_dir = DEF->folderBatch();
    this->init_type = DEF->methodInitialization();

    switch (this->type) {
        case 0 : // constants
            this->name_const = MyDef->getName("constant", DEF->indexBatch());
            break;
        case 1 :  // steps
            this->name_const = "discSteps";
            break;
        default :
            this->name_const = "Unknown";
            break;
    }
}

/**
 * \fn BocopOptimizeBatch::~BocopOptimizeBatch()
 * Destructor
 */
BocopOptimizeBatch::~BocopOptimizeBatch() {}

/**
 * \fn BocopOptimizeBatch::SolveProblem()
 * \return status
 * Perform a batch of optimizations on the same problem by repeated calls to BocopOptimizeSingle.
 * The different runs can have a different value for one of the problem constants, or for the time steps.
 */
int BocopOptimizeBatch::SolveProblem(void)
{
    string name_f_sol = "";
    string name_f_init = "";

    int status = 0;
    int status_all = 0;

    this->n_success = 0;

    double value;
    string value_str;

    // Batch optimization with varying number of time steps: check starting/ending values as positive integers
    if (this->type == 1)
        if (int(startingbound) != startingbound || int(endingbound) != endingbound || startingbound < 0 || endingbound < 0) {
            cerr << "BocopOptimizeBatch::SolveProblem ERROR >>> Both bounds for the number of time steps must be positive integer \n";
            return 1;
        }

    // Compute step for the varying value of the batch (constant or number of time steps)
    double h = 0e0;
    if (n_batch > 1)
         h = (endingbound - startingbound) / (n_batch - 1);

    // For the first optimization, we use the user-defined init files anyway, so we don't change the name
    name_f_init = "..."; // ... means the value will not be changed
    //+++FAIRE 2 FONCTIONS SEPAREES IN ET OUT ?

    for (int i = 0; i < n_batch; i++) {
        bocopDefPtr batchMyDef;

        // set specific value for current problem
        value = startingbound + h * i;

        // set constants for current problem
        double* batch_constants = new double[MyDef->dimConstants()];
        for (int j = 0; j < MyDef->dimConstants(); j++)
            batch_constants[j] = MyDef->constants()[j];
        bool batch_flagConstantsDone = MyDef->flagConstantsDone();
        if (this->type == 0)
        {
            batch_constants[MyDef->indexBatch()] = value;
            batch_flagConstantsDone = true;
        }

        // set time steps for current problem
        int batch_timesteps = MyDef->dimSteps();//BeforeMerge();
        if (this->type == 1)
            batch_timesteps = int(value);

        // set initialization type for current problem
        string batch_methodInitialization = MyDef->methodInitialization();
        if ((MyDef->methodInitialization() == "from_sol_file_cold" || MyDef->methodInitialization() == "from_sol_file_warm") && i == 0)
            batch_methodInitialization = "from_init_file";

        // construct a new BocopDefinition instance for current problem
        batchMyDef = bocopDefPtr(new BocopDefinition(MyDef->freeTime(), MyDef->initialTime(), MyDef->finalTime(),
                                 MyDef->dimState(), MyDef->dimControl(), MyDef->dimAlgebraic(), MyDef->dimOptimVars(), MyDef->dimConstants(), MyDef->dimInitFinalCond(), MyDef->dimPathConstraints(),
                                 batch_timesteps, MyDef->methodDiscretization(), MyDef->dimStages(), batch_timesteps,
                                 MyDef->optimType(), MyDef->typeBatch(), MyDef->indexBatch(), MyDef->rangeBatch(), MyDef->startingBatch(), MyDef->endingBatch(), MyDef->folderBatch(),
                                 batch_methodInitialization, MyDef->nameInitializationFile(), MyDef->paramIdType(), MyDef->observationSeparator(), MyDef->observationFile(), MyDef->sizeDataSet(),
                                 MyDef->nameDefFile(), MyDef->nameBoundsFile(), MyDef->nameConstantsFile(),
                                 //MyDef->pathToDiscFiles(),
                                 MyDef->nameSolutionFile(), MyDef->iterationOutputFrequency(),
                                 MyDef->flagDefinitionDone(), MyDef->stateNames(), MyDef->controlNames(), MyDef->algebraicNames(), MyDef->optimVarNames(), MyDef->constantNames(), MyDef->initFinalCondNames(), MyDef->pathConstraintNames(),
                                 MyDef->flagBoundariesDone(), MyDef->lowerVariable(), MyDef->upperVariable(), MyDef->typeVariable(), MyDef->lowerPath(), MyDef->upperPath(), MyDef->typePath(), MyDef->lowerBoundary(), MyDef->upperBoundary(), MyDef->typeBoundary(),
                                 batch_flagConstantsDone, batch_constants, MyDef->flagMethodDone(), MyDef->discCoeffA(), MyDef->discCoeffB(), MyDef->discCoeffC()));


        // Set name for solution file :
        stringstream sstr;
        sstr.setf(ios::scientific);
        sstr << value;
        value_str = sstr.str();
        name_f_sol = batch_dir + "/" + name_const + "-" + value_str + ".sol";

        // If the directory for batch doesn't exist we create it (The mkdir() function shall fail if the directory exists)
#if defined(_WIN32)
        _mkdir(batch_dir.c_str());
#else
        //read/write/search permissions for owner and group, and with read/search permissions for others
        mkdir(batch_dir.c_str(),  S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
#endif

        // We set the input/ouput properties :
        batchMyDef->setInOutProperties(name_f_init, name_f_sol);
        // +++ FAIRE 2 fonctions separees et appeler le In que si cold/warm start

        // Solve current problem
        status = solve_single_problem(batchMyDef);

        // Detect success or failure for current problem
        if (status == 0 || status == 1)
        {
            this->n_success += 1;
            // Set current solution as initialization for next problem
            name_f_init = name_f_sol;
        }
        else
            status_all = 1;

        // Update log file
        write_log_file(i, value, status, this->n_success);
    }

    // Print brief summary
//    cout << endl << "Successful optimizations : " << n_success << "/" << n_batch << endl;
//    cout << "Read .log for more details." << endl;

    // Print complete log
    cout << endl;
    stringstream logFileNameSt("");
    string line;
    // <file>.log name
    logFileNameSt << batch_dir << "/" << batch_dir << ".log";
    ifstream logFile(logFileNameSt.str().c_str());
    // getline is not safe if you read a file from another OS (which is not the case here)
    while(getline(logFile,line))
        cout << line << endl;
    logFile.close();

    return status_all;
}


// *** write_log_file ***
/**
  *\fn void BocopOptimizeBatch::write_log_file(const int i, const double value, const int stat, const int n_success)
  * This function prints a quick summary of an optimization into
  * log file. It is useful to quickly see if all optimizations
  * from a batch were successful.
  */
void BocopOptimizeBatch::write_log_file(const int i, const double value, const int stat, const int n_success)
{
    ofstream file_log;

    // After each optimization, we will write a quick outline in log file :
    string log_filename = this->batch_dir + "/batch-" + this->name_const + ".log";

    // If this is the first optimization in the batch process,
    // we clean the file, else, we append the new summary :
    if (i == 0) {
        file_log.open(log_filename.c_str(), ios::out | ios::trunc);
        file_log << "# ** Batch optimization parameters **" << endl;
        file_log << "# Index of the varying constant : " << this->index << endl;
        file_log << "# Starting value of this constant : " << this->startingbound << endl;
        file_log << "# Ending value of this constant : " << this->endingbound << endl;
        file_log << "# Number of steps in this interval (number of optimizations) : " << this->n_batch << endl << endl;
        file_log << "# ** Optimization results **" << endl;
        file_log << "#  n   | constant value  |  final objective  |  constraint viol. |  nb iter. | status |" << endl;
    } else
        file_log.open(log_filename.c_str(), ios::out | ios::app);

    // Finally we write the file with this data :
    file_log.width(7);
    file_log << left << (i + 1) << "  " ;
    file_log.width(17);
    file_log << left << value << "  " ;
    file_log.width(18);
    file_log << left << this->obj << "  ";
    file_log.width(18);
    file_log << left << this->constr << "  ";
    file_log.width(9);
    file_log << left <<  this->iter << "  ";
    file_log.width(7);
    file_log << left <<  stat << "  " << endl;


    if (i == this->n_batch - 1)
        file_log << endl << "# Successful optimizations : " << n_success << "/" << n_batch << endl;

    file_log.close();
}

