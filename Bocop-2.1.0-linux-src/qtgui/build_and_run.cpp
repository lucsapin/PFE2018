// This code is published under the Eclipse Public License
// File: build_and_run.cpp
// Authors: Vincent Grelard, Daphne Giorgi, Jinyan Liu, Pierre Martinon, Olivier Tissot
// Inria Saclay and Cmap Ecole Polytechnique
// INRIA 2011-2016

#include <iostream>
#include "mainwindow.h"
#include "ui_mainwindow.h"

void MainWindow::buildDebug()
{
    buildProblem(true);
}

void MainWindow::buildRelease()
{
    buildProblem(false);
}

/**
  *\fn void MainWindow::buildProblem(bool isDebug)
  * This method builds the current problem by running cmake in a QProcess, then calling the 'make' method in cmakeFinished()
  */
void MainWindow::buildProblem(bool isDebug)
{

    // save current problem
    saveProblem();

    if (flagBuildInProgress != true)
    {
        flagBuildInProgress = true;

        // Set focus on first tab for output
        ui->MainTabs->setCurrentIndex(0);
        ui->mainTextBrowser->setAlignment(Qt::AlignLeft);
        ui->mainTextBrowser->append(QString::fromStdString("Call Cmake to generate Makefile..."));

        // set build folder (create if needed)
        QDir buildDir(problem_dir.path() + QString(QDir::separator()) + "build");
        if (!buildDir.exists())
            buildDir.mkpath(".");

        // create process and connect signals
        this->cmake = new QProcess;
        this->cmake->setWorkingDirectory(buildDir.path());
        QObject::connect( cmake, SIGNAL( readyReadStandardOutput() ), this, SLOT(ReadProcessOutput() ));
        QObject::connect( cmake, SIGNAL( readyReadStandardError() ), this, SLOT(ReadProcessError() ));
        QObject::connect( cmake, SIGNAL( finished(int, QProcess::ExitStatus)), this, SLOT(cmakeFinished(int, QProcess::ExitStatus)) );

        // set command according to OS and build options
        QString commandString = "cmake";

        // msys makefiles for windows
#ifdef Q_OS_WIN
        commandString += " -G \"MSYS Makefiles\"";
#endif

        // debug or release build
        if (isDebug)
            commandString += " -DCMAKE_BUILD_TYPE=Debug";
        else
            commandString += " -DCMAKE_BUILD_TYPE=Release";

        // problem path +++ should not be needed anymore
        //commandString += " -DPROBLEM_DIR:PATH=" + problem_dir.path();

        // package path (location of CMakeLists.txt)
        commandString += " " + root_dir.path();

        // launch process for cmake
        cmake->start(commandString);

        // if process did not launch
        if (!cmake->waitForStarted()){
            QString msg = "Error when trying to execute the command \"%0 \" \nProcess output: %1";
            QMessageBox::critical(this, "Error while building Bocop (Cmake)", msg.arg(commandString).arg(cmake->errorString()));
        }

    }

}

/**
  *\fn void MainWindow::cmakeFinished(int, QProcess::ExitStatus)
  * This slot is called when the build process is finished.
  */

void MainWindow::cmakeFinished(int status, QProcess::ExitStatus exitstatus)
{

    if (exitstatus != QProcess::NormalExit) {
        ui->mainTextBrowser->setTextColor(Qt::red);
        ui->mainTextBrowser->append("Failed to launch cmake process.");
    }
    else if (status != 0) {
        ui->mainTextBrowser->setTextColor(Qt::red);
        ui->mainTextBrowser->append("Cmake FAILED.");
    }
    else {
        ui->mainTextBrowser->setTextColor(Qt::darkGreen);
        ui->mainTextBrowser->append("Cmake SUCCEEDED!");

        // launch make
        callMake();
    }

    ui->mainTextBrowser->append("");
    ui->mainTextBrowser->setTextColor(Qt::black);
    setCursorBottom();
    flagBuildInProgress = false;
    if (cmake != 0)
        delete cmake;

    if (status != 0) {
        QMessageBox msgBox;
        QString msg = "Build: Cmake FAILED.\nDo you want to rebuild the problem?";
        msgBox.setIcon(QMessageBox::Critical);
        msgBox.setText(msg);
        QAbstractButton* mButtonYes = msgBox.addButton(tr("Rebuild"), QMessageBox::YesRole);
        msgBox.addButton(tr("Cancel"), QMessageBox::NoRole);
        msgBox.exec();
        if (msgBox.clickedButton()== mButtonYes) {
            cleanProblem();
            buildRelease();
        }
    }

}

/**
  *\fn void MainWindow::callMake(void)
  * This method builds the current problem by running make, and is called after cmake by buildBocop
  */
void MainWindow::callMake(void)
{

    // We set the focus on the first tab (textbrowser) :
    ui->MainTabs->setCurrentIndex(0);
    ui->mainTextBrowser->setAlignment(Qt::AlignLeft);

    // We create a process to host our command :
    QDir buildDir(problem_dir.path() + QString(QDir::separator()) + "build");
    if (!buildDir.exists())
        buildDir.mkpath(".");

    this->make = new QProcess;
    this->make->setWorkingDirectory(buildDir.path());

    QObject::connect( make, SIGNAL( readyReadStandardOutput() ), this, SLOT(ReadProcessOutput() ));
    QObject::connect( make, SIGNAL( readyReadStandardError() ), this, SLOT(ReadProcessError() ));
    QObject::connect( make, SIGNAL( finished(int, QProcess::ExitStatus)), this, SLOT(makeFinished(int, QProcess::ExitStatus)) );

    // Build the executable by invoking make
    QString commandString = "make -j";
    make->start(commandString);

    // if process did not launch
    if (!make->waitForStarted()){
        QString msg = "Error when trying to execute the command \"%0 \" \nProcess output: %1";
        QMessageBox::critical(this, "Error while building Bocop (make)", msg.arg(commandString).arg(make->errorString()));
    }
}


void MainWindow::makeFinished(int status, QProcess::ExitStatus exitstatus)
{

    if (exitstatus != QProcess::NormalExit) {
        ui->mainTextBrowser->setTextColor(Qt::red);
        ui->mainTextBrowser->append("Failed to launch make process.");
    }
    else if (status != 0) {
        ui->mainTextBrowser->setTextColor(Qt::red);
        ui->mainTextBrowser->append("make FAILED.");

        QMessageBox msgBox;
        QString msg = "Build: make FAILED.\nDo you want to rebuild the problem?";
        msgBox.setIcon(QMessageBox::Critical);
        msgBox.setText(msg);
        QAbstractButton* mButtonYes = msgBox.addButton(tr("Rebuild"), QMessageBox::YesRole);
        msgBox.addButton(tr("Cancel"), QMessageBox::NoRole);
        msgBox.exec();
        if (msgBox.clickedButton()== mButtonYes) {
            cleanProblem();
            buildRelease();
        }
    }
    else {
        ui->mainTextBrowser->setTextColor(Qt::darkGreen);
        ui->mainTextBrowser->append("make SUCCEEDED!");
    }

    ui->mainTextBrowser->append("");
    ui->mainTextBrowser->setTextColor(Qt::black);
    setCursorBottom();

    if (make != 0)
        delete make;
}

/**
  * \fn void MainWindow::runProblem(void)
  * This function launches the optimization for the current problem
  */
void MainWindow::runProblem(void)
{

    // save current problem (required to take into account updated values !)
    saveProblem();

    if (flagRunInProgress != true)
    {
        flagRunInProgress = true;

        // Set focus on first tab for ouptut
        ui->MainTabs->setCurrentIndex(0);
        ui->mainTextBrowser->setAlignment(Qt::AlignLeft);

        // For batch optimisation: check that destination folder exists and is empty
        if (!ui->optim_push_single->isChecked() && ui->optim_push_batch->isChecked()) {
            int status = checkBatchDirectory();
            // Batch directory already exists
            if (status == 4) {
                flagRunInProgress = false;
                return;
            }
            else if (status != 0)
                return;
        }

        // create process and connect signals
        this->run = new QProcess;

        // upload problem path
        QDir runDir(problem_dir.path());
        this->run->setWorkingDirectory(runDir.path());

        // create process and connect signals
        QObject::connect(run, SIGNAL( readyReadStandardOutput() ), this, SLOT(ReadProcessOutput()), Qt::DirectConnection);
        QObject::connect(run, SIGNAL( readyReadStandardError() ), this, SLOT(ReadProcessError() ), Qt::DirectConnection );
        QObject::connect(run, SIGNAL( finished(int, QProcess::ExitStatus) ), this, SLOT( runFinished(int, QProcess::ExitStatus) ), Qt::DirectConnection );
        QObject::connect(ui->actionStopProblem_toolbar, SIGNAL(triggered()), run, SLOT(kill()), Qt::DirectConnection);

        // launch command in process

#ifdef Q_OS_WIN
        QString exec = "/bocop.exe";
#else
        QString exec = "/bocop";
#endif
        QString commandString = runDir.path()+ exec;
//        run->setWorkingDirectory(problem_dir.path());
        run->start(commandString);

        // if process did not start
        if (!run->waitForStarted()) {

            runFinished(-66,QProcess::CrashExit);

            //QString msg = run->errorString() + "\nDid you build the problem ?";
            QString msg = "Bocop executable not found.\nDid you build the problem ?";
            QMessageBox msgBox;
            msgBox.setIcon(QMessageBox::Critical);
            msgBox.setText(msg);
            QAbstractButton* mButtonYes = msgBox.addButton(tr("Rebuild"), QMessageBox::YesRole);
            msgBox.addButton(tr("Cancel"), QMessageBox::NoRole);

            msgBox.exec();

            if (msgBox.clickedButton()== mButtonYes) {
                cleanProblem();
                buildProblem(false);
//                runFinished(0,QProcess::NormalExit);
            }
//            else{
//                runFinished(-66,QProcess::CrashExit);
                //return;
//            }

        }
    }
}


/**
  * \fn void MainWindow::runFinished(int status, QProcess::ExitStatus exitstatus)
  * This method is called when an optimization terminates, or when it is killed by user.
  * It displays information about the exit status of the optimization in the main text browser.
  */
void MainWindow::runFinished(int status, QProcess::ExitStatus exitstatus)
{

    // check exit status
    if (exitstatus != QProcess::NormalExit)
    {
        ui->mainTextBrowser->setTextColor(Qt::red);
        ui->mainTextBrowser->append("\nBocop process exited abnormally");
    }
    else if(!bocopDef->isSingleOptimization())
    {
        ui->mainTextBrowser->setTextColor(Qt::blue);
        ui->mainTextBrowser->append("Batch optimization COMPLETE! See batch log for details");
    }
    else
    {
        // Handy transtype from [0:255] to [-128:127] because Ipopt error code can be negative
        // but the process return value is in [0:255] (8 bits code)
        if(status > pow(2,7)) status -= pow(2,8);
        QString strMessage = QString("Ipopt solver returns %1:").arg(status);
        switch (status) {
        case 0: ui->mainTextBrowser->setTextColor(Qt::darkGreen);
            strMessage += " solve SUCCEEDED!";
            break;
        case 1: ui->mainTextBrowser->setTextColor(Qt::darkGreen);
            strMessage += " solved to acceptable level!";
            break;
        case 3: ui->mainTextBrowser->setTextColor(Qt::blue);
            strMessage += " search direction too small.\n"
                    "This indicates that IPOPT is calculating very small step sizes and making very little progress.\n"
                    "This could happen if the problem has been solved to the best numerical accuracy possible given the current scaling. ).";
            break;
        case -1: ui->mainTextBrowser->setTextColor(Qt::red);
            strMessage += " max iteration exceeded!";
            break;
        case  2: ui->mainTextBrowser->setTextColor(Qt::red);
            strMessage += " infeasible problem.\n"
                    "The restoration phase converged to a point that is a minimizer for the constraint violation (in the l_1-norm), but is not feasible for the original problem.\n"
                    "This indicates that the problem may be infeasible (or at least that the algorithm is stuck at a locally infeasible point).\n"
                    "The returned point (the minimizer of the constraint violation) might help you to find which constraint is causing the problem.\n"
                    "If you believe that the NLP is feasible, it might help to start the optimization from a different point.";
            break;
        default: ui->mainTextBrowser->setTextColor(Qt::red);
            strMessage += " see Ipopt documentation.";
            break;
        }
        ui->mainTextBrowser->append(strMessage);
    }

    //ui->mainTextBrowser->append("");
    ui->mainTextBrowser->setTextColor(Qt::black);
    setCursorBottom();

    if (run != 0)
        delete run;

    flagRunInProgress = false;
}


/**
  * \fn void MainWindow::cleanProblem(void)
  * This function deletes the bocop executable and the build folder
  */
void MainWindow::cleanProblem(void)
{
    // Set focus on first tab for ouptut
    ui->MainTabs->setCurrentIndex(0);
    ui->mainTextBrowser->setAlignment(Qt::AlignLeft);

    // create process and connect signals
    QProcess *clean = new QProcess;
    QObject::connect(clean, SIGNAL( readyReadStandardOutput() ), this, SLOT(ReadProcessOutput()), Qt::DirectConnection);
    QObject::connect(clean, SIGNAL( readyReadStandardError() ), this, SLOT(ReadProcessError() ), Qt::DirectConnection );

    QString exec;
#ifdef Q_OS_WIN
    exec = "bocop.exe";
#else
    exec = "bocop";
#endif

    // launch command in process
    QString commandString = "rm -r " + exec + " build";
    QString commandString1 = "rm -r " + exec;
    QString commandString2 = "rm -r build";
    QDir test_file;
    QString build_folder = problem_dir.path()+ "/build";
    QString exec_path = problem_dir.path()+ "/" + exec;

    clean->setWorkingDirectory(problem_dir.path());

    if (test_file.exists(exec_path) && test_file.exists(build_folder))
        clean->start(commandString);
    else if (test_file.exists(exec_path)){
        clean->start(commandString1);
    }
    else if (test_file.exists(build_folder)){
        clean->start(commandString2);
    }

//    clean->setWorkingDirectory(problem_dir.path());

//    clean->start(commandString);
}

