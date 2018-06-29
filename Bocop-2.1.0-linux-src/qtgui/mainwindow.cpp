// This code is published under the Eclipse Public License
// File: mainwindow.cpp
// Authors: Vincent Grelard, Daphne Giorgi, Jinyan Liu, Pierre Martinon, Olivier Tissot
// Inria Saclay and Cmap Ecole Polytechnique
// 2011-2015

#include <iostream>
#include <QDebug>
#include "mainwindow.h"
#include "ui_mainwindow.h"

using namespace std;


/**
  *\fn MainWindow::MainWindow(QWidget *parent)
  * Main constructor.
  */
MainWindow::MainWindow(const qint64 pid, QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow),
    version("Bocop-" + QString::fromStdString(VERSION)),
    settings("Inria", version)
{
    this->currentPID = pid;
    ui->setupUi(this);

    // We get Bocop root directories and settings (root and current problem)
    checkBocopDirectories();

    bocopDef = 0;

    bocopSol = 0;
    bocopSave = 0;

    model_names = 0;
    model_bounds = 0;
    model_constants = 0;
    model_init = 0;
    model_ipopt = 0;
    model_solution = 0;

    init_curve = 0;
    multi_qwtPlot = 0;
    multi_curve = 0;
    pick_canvas = 0;
    pick_scale = 0;
    multiSize = 0;

    optimTabClicked = false;

    flagRunInProgress = false;
    flagBuildInProgress = false;
    flagSaveInProgress = false;

    CreateActions();

    // We add the list of recently opened files
    for (int i = 0; i < MaxRecentFiles; ++i)
        ui->menuRecentProblems->addAction(recentFileActs[i]);
    updateRecentFileActions();

    ui->definition_toolbox->setCurrentIndex(0);

    // We save the values of these QDirs for next session of BOCOP :
    writeSettings();

    // We read the current problem's definition :
    clearAllFields();
    loadAll();

}


/**
  *MainWindow::~MainWindow()
  * Destructor
  */
MainWindow::~MainWindow()
{
    if (bocopDef != 0)
        delete bocopDef;

    if (bocopSol != 0)
        delete bocopSol;

    if (bocopSave != 0)
        delete bocopSave;

    if (model_names != 0)
        delete model_names;

    if (model_bounds != 0)
        delete model_bounds;

    if (model_constants != 0)
        delete model_constants;

    if (model_init != 0)
        delete model_init;

    if (multiSize != 0 && multi_qwtPlot!=0) {
        delete[] multi_qwtPlot;
        delete[] multi_curve;
        delete[] multi_zoom;
    }

    if (model_ipopt != 0)
        delete model_ipopt;

    if (model_solution != 0)
        delete model_solution;

    type_init_map.clear();
    time_init_map.clear();
    value_init_map.clear();

    if (init_curve != 0) {
        delete init_curve;
        init_curve = 0;
    }

    if (pick_canvas != 0) {
        delete pick_canvas;
        pick_canvas = 0;
    }

    if (pick_scale != 0) {
        delete pick_scale;
        pick_scale = 0;
    }

    delete ui;
}


/**
  * \fn int MainWindow::clearAllFields(void)
  * This method is used to clear all the fields from the main window, and is called before loading a new problem.
  */
int MainWindow::clearAllFields(void)
{

    foreach(QLineEdit *widget, this->findChildren<QLineEdit*>()) {
        widget->clear();
    }

    QStringList comboBoxes;
    comboBoxes << "separator_comboBox" << "methodComboBox" << "typeComboBox";

    foreach(QComboBox *widget, this->findChildren<QComboBox*>()) {
        if ( !comboBoxes.contains(widget->objectName()))
            widget->clear();
    }

    // We un-select all radio-buttons. setChecked doesn't work if the
    // autoExclusive option is turned on, because it handles exclusivity
    // for items inside a same group :
    foreach(QRadioButton *widget, this->findChildren<QRadioButton*>()) {
        widget->setAutoExclusive(false);
        widget->setChecked(false);
    }

    // We un-select the parameter identification check box
    ui->paramid_checkBox->setChecked(false);

    // Models (trees and table views) :
    if (model_names != 0) {
        delete model_names;
        model_names = 0;
    }

    if (model_bounds != 0) {
        delete model_bounds;
        model_bounds = 0;
    }

    if (model_constants != 0) {
        delete model_constants;
        model_constants = 0;
    }

    if (model_init != 0) {
        delete model_init;
        model_init = 0;
    }

    if (model_ipopt != 0) {
        delete model_ipopt;
        model_ipopt = 0;
    }

    if (model_solution != 0) {
        delete model_solution;
        model_solution = 0;
    }

    // Bocop related instances :
    if (bocopDef != 0) {
        delete bocopDef;
        bocopDef = 0;
    }

    if (bocopSol != 0) {
        delete bocopSol;
        bocopSol = 0;
    }

    if (bocopSave != 0) {
        delete bocopSave;
        bocopSave = 0;
    }

    if (multiSize != 0)
    {
        delete[] multi_qwtPlot;
        delete[] multi_curve;
        delete[] multi_zoom;
        multi_qwtPlot = 0;
        multi_curve = 0;
        multi_zoom = 0;
        multiSize = 0;
    }

    if (init_curve != 0) {
        delete init_curve;
        init_curve = 0;
    }

    if (pick_canvas != 0) {
        delete pick_canvas;
        pick_canvas = 0;
    }

    optimTabClicked = false;

    foreach(QwtPlot *widget, this->findChildren<QwtPlot*>()) {
        widget->detachItems();
        widget->titleLabel()->clear();
        widget->titleLabel()->hide();
        widget->replot();
    }

    // Starting point maps ;
    type_init_map.clear();
    time_init_map.clear();
    value_init_map.clear();

    return 0;
}


/**
  * \fn void MainWindow::checkBocopRootDir()
  * This method is called in the constructor to check the folders for Bocop install and current problem
  */
void MainWindow::checkBocopDirectories()
{
    // We get the folder from where the current application was launched
    QString gui_path = QCoreApplication::applicationDirPath();
    gui_dir.setPath(gui_path);

    // We check that the folder exists
    if (!gui_dir.exists()) {
        QMessageBox err(QMessageBox::Warning,tr("Invalid folder (")+gui_path+tr(")"),tr("Bocop folder was not set because the current application folder does not seem to exist."),QMessageBox::Ok );
        err.exec(); //display message box
        return;
    }

    // We get the settings of the previous Bocop session (problem_dir) :
    readSettings();

    // +++ redo this: if problem does not exist simply display warning then empty window
    // We check that problem_dir and root_dir are correct :
    if (problem_dir.exists() && problem_dir.exists("problem.def")) {

        ui->MainTabs->setCurrentIndex(0);
        ui->mainTextBrowser->setHtml(tr("BOCOP Directories : <ul><li> Root folder : ")+
                                     root_dir.path()+tr("</li><li> Current Problem : ")+
                                     problem_dir.path()+tr("</li></ul></html>"));

        dispMissingProblemFiles();

        refreshStatusTipProblem();

        return;
    }

    // If not valid, we load default directories and select the goddard problem
    bool stat = true;
    if (problem_dir.cd(root_dir.path())) {
        if (problem_dir.cd("examples")) {
            if (problem_dir.cd("goddard")) {}
            else {stat = false;}
        }
        else {stat = false;}
    }
    else {stat = false;}

    if (stat == false) {
        QMessageBox err(QMessageBox::Warning,tr("Cannot reach default problem folder"),
                        tr("The default problem folder (<root>/examples/goddard) cannot be accessed. You need to create a new problem, or select an existing one, using buttons in the main toolbar."),
                        QMessageBox::Ok );
        err.exec(); //display message box
        return;
    }

    ui->MainTabs->setCurrentIndex(0);
    ui->mainTextBrowser->setHtml(tr("BOCOP Directories : <ul><li> Root folder : ")+
                                 root_dir.path()+tr("</li><li> Current Problem : ")+
                                 problem_dir.path()+tr("</li></ul></html>"));

    // Check disc_dir here
    disc_dir = root_dir;
    stat = false;
    stat = disc_dir.cd(tr("core/disc"));

    if (stat == false){
        QMessageBox err(QMessageBox::Warning,tr("Cannot reach discretisation folder"),
                        tr("The discretisation folder: ")+disc_dir.path()+ tr(" cannot be accessed. "),
                        QMessageBox::Ok );
        err.exec(); //display message box
        return;
    }
    refreshStatusTipProblem();
}


/**
  * \fn int LoadBocopDefinition(void)
  * This function reads the definition files of the current problem, in order
  * to get all the parameters.
  */
int MainWindow::loadBocopDefinition(void)
{
    ui->MainTabs->setCurrentIndex(0);

    ui->mainTextBrowser->setAlignment(Qt::AlignCenter);
    ui->mainTextBrowser->append("<center><img src=\":/images/logo_400.png\" /></center>");

    ui->mainTextBrowser->append(QString::fromStdString("Loading problem definition..."));

    QFileInfo def(problem_dir,"problem.def");
    if (!def.isReadable()) {
        QMessageBox::critical(this, "Error", QString("Cannot read .def file in your problem folder: %0.").arg(problem_dir.path()));
        return 1;
    }

    QFileInfo bounds(problem_dir,"problem.bounds");
    if (!bounds.isReadable()) {
        QMessageBox::critical(this, "Error", "Cannot read .bounds file in your problem folder.");
        return 2;
    }

    QFileInfo constants(problem_dir,"problem.constants");
    if (!constants.isReadable()) {
        QMessageBox::critical(this, "Error", "Cannot read .constants file in your problem folder.");
        return 3;
    }

    //QFileInfo times(problem_dir,"problem.times");

    bocopDef = new BocopDefinition(def.absoluteFilePath().toStdString(),
                                   bounds.absoluteFilePath().toStdString(),
                                   constants.absoluteFilePath().toStdString());
//                                   times.absoluteFilePath().toStdString(),
//                                   problem_dir.absolutePath().toStdString());
/*
    // Path to .disc files :
//    QDir dir_disc = root_dir;
    disc_dir = root_dir;
    bool stat = disc_dir.cd(tr("core/disc"));

    if (stat == true){
//        QString m_pathToDiscFiles = dir_disc.absolutePath()+QDir::separator();
        QString m_pathToDiscFiles = disc_dir.absolutePath()+QDir::separator();
        bocopDef->setPathDiscretization(m_pathToDiscFiles.toStdString());
    }
*/
    // Now we can read all files :
    int status = bocopDef->readAll();

    if (status != 0) {
        QString error = QString::fromStdString(bocopDef->errorString());

        ui->MainTabs->setCurrentIndex(0);
        ui->mainTextBrowser->setTextColor(Qt::red);
        ui->mainTextBrowser->append(QString::fromStdString("ERROR IN BOCOP DEFINITION!"));
        ui->mainTextBrowser->append(error);
        ui->mainTextBrowser->setTextColor(Qt::black);
        // return below was commented to avoid freezing the GUI in case of bad input files
        // or csv file for param Identification -> commit to trunk
        // possible regression : failed execution in case of bad csv files leads to
        // a final message "Optimization successful"
        return 4;
    }

    if (bocopDef->isWarning()){
        QString warning = QString::fromStdString(bocopDef->warningString());

        ui->MainTabs->setCurrentIndex(0);
        ui->mainTextBrowser->setTextColor(Qt::blue);
        ui->mainTextBrowser->append(warning);
        ui->mainTextBrowser->setTextColor(Qt::black);
    }

    ui->mainTextBrowser->append(QString::fromStdString("Problem loaded."));
    ui->mainTextBrowser->append(QString::fromStdString(""));

    setCursorBottom();

    return 0;
}


/**
  * \fn void MainWindow::loadAll()
  * This method is called to load all the informations of the problem, corresponding to each tab in the interface.
  */
void MainWindow::loadAll()
{
    int status = 0;

    // Load definition
    status = loadBocopDefinition();
    if (status != 0){
        QMessageBox::critical(this, "Error", "Cannot load Bocop definition.");
        return;
    }
    else{
        status = loadDefinitionDimensions();
        if (status != 0)
            QMessageBox::critical(this, "Error", "Cannot load definition dimensions.");
        status = loadDefinitionNames();
        if (status != 0)
            QMessageBox::critical(this, "Error", "Cannot load definition names.");
        status = loadDefinitionBounds();
        if (status != 0)
            QMessageBox::critical(this, "Error", "Cannot load definition bounds.");
        status = loadDefinitionConstants();
        if (status != 0)
            QMessageBox::critical(this, "Error", "Cannot load definition constants.");
    }

    // Load discretization
    status = loadDiscretizationMethod();
    if (status != 0)
        QMessageBox::critical(this, "Error", "Cannot load discretization method.");
    status = loadDiscretizationTimes();
    if (status != 0)
        QMessageBox::critical(this, "Error", "Cannot load discretization times.");

    // Load initialization
    status = loadInitialization();
    if (status != 0)
        QMessageBox::critical(this, "Error", "Cannot load initialization.");

    // Load optimization
    status = loadOptimization();
    if (status != 0)
        QMessageBox::critical(this, "Error", "Cannot load optimization.");
    //    status = 0;
    //    status = loadBatchOptions();
    //    if (status != 0)
    //        QMessageBox::critical(this, "Error", "Cannot load batch options.");
    //    status = 0;
    //    status = loadBatchNames();
    //    if (status != 0)
    //        QMessageBox::critical(this, "Error", "Cannot load batch names.");

    // Load solution
    status = loadSolutionFileName();
    //    if (status != 0)
    //        QMessageBox::critical(this, "Error", "Cannot load solution file name.");

    status = loadSolutionFile();
    //    if (status != 0)
    //        QMessageBox::critical(this, "Error", "Cannot load solution file.");
}


/**
  * \fn void MainWindow::writeSettings()
  * This method saves the settings of the current session
  * NB. on linux, will be saved in .config/Inria/Bocop-x.x.x.conf
  */
void MainWindow::writeSettings()
{

    settings.beginGroup("Directories");
    settings.setValue("problem_dir", this->problem_dir.path());
    settings.setValue("root_dir", this->root_dir.path());

    QStringList recentFileList = settings.value("recentFileList").toStringList();
    recentFileList.removeAll(this->problem_dir.path());
    recentFileList.prepend(this->problem_dir.path());
    while(recentFileList.size() > MaxRecentFiles)
        recentFileList.removeLast();
    settings.setValue("recentFileList", recentFileList);
    settings.endGroup();

    updateRecentFileActions();
}

/**
  * \fn void MainWindow::readSettings()
  * This method reads the settings from last session
  * NB. on linux, will be saved in .config/Inria/Bocop-x.x.x.conf
  */
void MainWindow::readSettings()
{
    const int COMMAND_NOT_FOUND = 127;

    settings.beginGroup("Directories");
    QString problem_path = settings.value("problem_dir", QString()).toString();
    QString root_path = settings.value("root_dir", QString()).toString();
    settings.endGroup();

    // Set problem path
    this->problem_dir.setPath(problem_path);

    // Set bocop package root path +++ check env var BOCOP_PATH here
    if (root_path != "")
        this->root_dir.setPath(root_path);
    else {
        // try parent of GUI folder
        root_dir = gui_dir;
        root_dir.cdUp();
        root_path = root_dir.absolutePath();
    }

    // check if root dir is valid +++ needs to be checked (systematic error at new install)
    int ok = checkRootDir(root_path);

    if (ok!=0) {
       //cout << "ERROR: Cannot find Bocop package at " << root_path << endl;
       cout << "ERROR: Cannot find Bocop package ..." << endl;
       cout << "Please set correct path in Help > Set Bocop package folder " << endl;
    }
    else {
        // check version number match between GUI and package
        ok = checkVersionNumber();

        // We check that cmake is available
        QProcess testPrerequisites;
        testPrerequisites.start("sh -c cmake");
        testPrerequisites.waitForFinished();
        if (testPrerequisites.exitCode() == COMMAND_NOT_FOUND) {
            QMessageBox::warning(this, "Wrong Bocop folder",
                                 QString("The 'cmake' command is not recognized in the shell.\nPlease check if you have correctly installed cmake on your computer."),
                                 "Continue", 0);

        }
    }
}


void MainWindow::dispMissingProblemFiles(void)
{
    /** \todo Implement */
}


/**
  * \fn void MainWindow::refreshStatusTipProblem(void)
  * This function is called each time the current problem changes.
  * It updates all status tips to display the problem path.
  */
void MainWindow::refreshStatusTipProblem(void)
{
    QString disp_str = QString("Current Problem : %0").arg(problem_dir.path());
    ui->actionOpenProblem->setStatusTip(disp_str);
    ui->actionNewProblem->setStatusTip(disp_str);
    ui->actionSaveProblem->setStatusTip(disp_str);
    ui->mainTextBrowser->setStatusTip(disp_str);

    this->setWindowTitle(QString("Bocop - %0 (%1)").arg(problem_dir.dirName()).arg(problem_dir.path()));

}


/**
  *\fn void MainWindow::CreateActions(void)
  * This method connects all the buttons in the main action toolbar to the
  * associated slots (open, save, ...)
  */
void MainWindow::CreateActions(void)
{
    // 1) From menu bar: File, Build&Run, Help

    // File: New, Open, Recent, Save, Quit
    connect(ui->actionNewProblem, SIGNAL(triggered()), this, SLOT(newProblem()));
    connect(ui->actionOpenProblem, SIGNAL(triggered()), this, SLOT(openProblem()));
    for (int i = 0; i < MaxRecentFiles; ++i) {
        recentFileActs[i] = new QAction(this);
        recentFileActs[i]->setVisible(false);
        connect(recentFileActs[i], SIGNAL(triggered()),this, SLOT(openRecentFile()));
    }
    connect(ui->actionSaveProblem, SIGNAL(triggered()), this, SLOT(saveProblem()));
    connect(ui->actionQuit, SIGNAL(triggered()), this, SLOT(close()));

    // Build and Run: Clean, Build, Build (debug), Run
    connect(ui->actionCleanProblem, SIGNAL(triggered()), this, SLOT(cleanProblem()));
    connect(ui->actionBuildProblem, SIGNAL(triggered()), this, SLOT(buildRelease()));
    connect(ui->actionBuildDebug, SIGNAL(triggered()), this, SLOT(buildDebug()));
    connect(ui->actionRunProblem, SIGNAL(triggered()), this, SLOT(runProblem()));

    // Help: set root directory
    connect(ui->actionSetRootDirectory, SIGNAL(triggered()), this, SLOT(setRootDir()) );

    // 2) From main toolbar: New, Open, Save, Build, Run, Stop
    connect(ui->actionNewProblem_toolbar, SIGNAL(triggered()), this, SLOT(newProblem()));
    connect(ui->actionOpenProblem_toolbar, SIGNAL(triggered()), this, SLOT(openProblem()));
    connect(ui->actionSaveProblem_toolbar, SIGNAL(triggered()), this, SLOT(saveProblem()));
    connect(ui->actionBuildProblem_toolbar, SIGNAL(triggered()), this, SLOT(buildRelease()));
    connect(ui->actionRunProblem_toolbar, SIGNAL(triggered()), this, SLOT(runProblem()));

    // Dimension changes
    connect(ui->stateDimensionLineEdit, SIGNAL(editingFinished()), this, SLOT(userChangedDimension()));
    connect(ui->controlDimensionLineEdit, SIGNAL(editingFinished()), this, SLOT(userChangedDimension()));
    connect(ui->algebraicVariablesDimensionLineEdit, SIGNAL(editingFinished()), this, SLOT(userChangedDimension()));
    connect(ui->optimizationParametersDimensionLineEdit, SIGNAL(editingFinished()), this, SLOT(userChangedDimension()));
    connect(ui->finalTimeLineEdit, SIGNAL(editingFinished()), this, SLOT(userChangedDimension()));
    connect(ui->initialFinalConditionsDimensionLineEdit, SIGNAL(editingFinished()), this, SLOT(userChangedDimension()));
    connect(ui->pathConstraintsDimensionLineEdit, SIGNAL(editingFinished()), this, SLOT(userChangedDimension()));
    connect(ui->constantsDimensionLineEdit, SIGNAL(editingFinished()), this, SLOT(userChangedDimension()));

    // Bounds (for init with interpolation) changes
    connect(ui->initXmin_lineEdit,SIGNAL(editingFinished()),this, SLOT(onInitializationXrangeEditFinished()));
    connect(ui->initXmax_lineEdit,SIGNAL(editingFinished()),this, SLOT(onInitializationXrangeEditFinished()));
    connect(ui->initYmin_lineEdit,SIGNAL(editingFinished()), this, SLOT(onInitializationYrangeEditFinished()));
    connect(ui->initYmax_lineEdit,SIGNAL(editingFinished()), this, SLOT(onInitializationYrangeEditFinished()));

    // Visualization
    connect(ui->visu_treeView, SIGNAL(pressed(QModelIndex)),this, SLOT(manageVisuClicked(QModelIndex)));
    connect(ui->bounds_treeView, SIGNAL(expanded(QModelIndex)),this, SLOT(resizeBoundsTreeview()));
    connect(ui->actionPrint, SIGNAL(triggered()), this, SLOT(PrintGraph()));

}


/**
  *\fn void MainWindow::userChangedDimension(void)
  * This slot is called whenever the user modifies one of the dimension
  * related line edits text. It reloads the bounds and constants fields so
  * that the bounds and constants models are always up to date.
  */
void MainWindow::userChangedDimension(void)
{
    // If there are dimensions that are still not defined, we leave :
    if (dimState()<0 || dimControl()<0 || dimAlgebraic()<0 || dimOptimVars()<0
            || dimConstants()<0 || dimInitFinalCond()<0 || dimPathConstraints()<0) {
        return;
    }

    // Else, we update bounds and constants models :
    loadDefinitionBounds();
    //    loadDefinitionConstants(); why commented ?
}


/**
  * \fn void MainWindow::PrintGraph()
  * This function is called to print a graph from the visualization window.
  */
void MainWindow::PrintGraph()
{
    QString filename = QFileDialog::getSaveFileName(this,"Choose save file for graph...","","(*.png)");
    QFileInfo file(filename);
    if(file.suffix().isEmpty()) filename += ".png";
}


/**
  * \fn void MainWindow::ReadProcessOutput()
  * This is a slot called whenever a process sends text to the standard output.
  * The output is read and displayed in the main text browser.
  */
void MainWindow::ReadProcessOutput()
{

    QProcess *p = dynamic_cast<QProcess *>( sender() );

    if (p) {
        QFont font = QFont ("Courier");
        //        font.setStyleHint (QFont::Monospace); // DO NOT WORK ON OLDER VERSIONS OF QT
        font.setFixedPitch (true);
        ui->mainTextBrowser->setFont(font);
        ui->mainTextBrowser->setTextColor(Qt::black);
        // remove last character (\n) as append adds a newline as paragraph separator ...
        QByteArray output = p->readAllStandardOutput();
        output.chop(1); //calling chop directly on readAll does not work
        ui->mainTextBrowser->append(output);
    }

    setCursorBottom();
}


/**
  * \fn void MainWindow::ReadProcessError()
  * This is a slot called whenever a process sends text to the standard error.
  * The output is read and displayed in the main text browser (in red).
  */
void MainWindow::ReadProcessError()
{
    QProcess *p = dynamic_cast<QProcess *>( sender() );

    if (p)
    {
        ui->mainTextBrowser->setTextColor(Qt::blue);
        ui->mainTextBrowser->append( p->readAllStandardError() );
        ui->mainTextBrowser->setTextColor(Qt::black);
    }

    setCursorBottom();
}


/**
  * \fn void MainWindow::setCursorBottom(void)
  * Set the value of the  vertical scroll bar in the main window to its maximum value.
  */
void MainWindow::setCursorBottom(void)
{
    ui->mainTextBrowser->verticalScrollBar()->setValue(ui->mainTextBrowser->verticalScrollBar()->maximum());
}


/**
  *\fn void MainWindow::on_MainTabs_currentChanged(int index)
  * Slot run when the main tabs current item is changed. It loads the
  * data needed to display the newly selected tab.
  */
void MainWindow::on_MainTabs_currentChanged(int index)
{
    int status = 0;

    switch (index) {
    case 0:
        break;
    case 1:
    {
        status = loadDefinitionDimensions();
        if (status != 0)
            QMessageBox::critical(this, "Error", "Cannot load definition dimensions.");
//        int index = ui->definition_toolbox->currentIndex();
//        on_definition_toolbox_currentChanged(index);
//        break;
//    }
//    case 2:
//        status = loadDiscretizationMethod();
//        if (status != 0)
//            QMessageBox::critical(this, "Error", "Cannot load discretization method.");
        status = loadDiscretizationTimes();
        if (status != 0)
            QMessageBox::critical(this, "Error", "Cannot load discretization times.");
        status = loadDiscretizationMethod();
        if (status != 0)
            QMessageBox::critical(this, "Error", "Cannot load discretization method.");
        int index = ui->definition_toolbox->currentIndex();
        on_definition_toolbox_currentChanged(index);
        break;
    }
    //case 3:
    case 2:
        status = loadInitialization();
        if (status != 0)
            QMessageBox::critical(this, "Error", "Cannot load initialization.");
        break;
    case 3:
    //case 4:
        status = loadOptimization();
        if (status != 0)
            QMessageBox::critical(this, "Error", "Cannot load optimization.");
        if (!optimTabClicked)
            optimTabClicked = true;
        break;
    //case 5 :
    case 4 :
        status = loadSolutionFileName();
        //        if (status != 0)
        //            QMessageBox::critical(this, "Error", "Cannot load solution file name.");
        status = loadSolutionFile();
        //        if (status != 0)
        //            QMessageBox::critical(this, "Error", "Cannot load solution file.");
        break;
    default:
        qDebug() << "value of index unknown";
    }
}

