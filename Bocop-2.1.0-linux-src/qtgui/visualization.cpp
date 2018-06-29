// This code is published under the Eclipse Public License
// Authors: Vincent Grelard, Daphne Giorgi, Jinyan Liu, Virgile Andreani
// Inria Saclay and CMAP Ecole Polytechnique
// 2011-2017

#include <cstdlib>
#include <iostream>
#include <string>
#include <fstream>
#include <sstream>
#include "mainwindow.h"
#include "ui_mainwindow.h"

using namespace std;

/**
  * \fn void MainWindow::on_loadsolfile_pushButton_clicked(void)
  * This slot is called when the load solution file button is clicked. It allows
  * the user to select a .sol file to load. A box is opened to show the files, and
  * once a .sol file is chosen, its name is displayed in the text field.
  */
void MainWindow::on_loadsolfile_pushButton_clicked(void)
{
    QString starting_path = problem_dir.absolutePath();

    QString new_path = QFileDialog::getOpenFileName(this,
                                                    tr("Please select a solution file to load"),
                                                    starting_path, tr("Solution Files (*.sol)"));
    // If nothing is returned :
    if (new_path.isEmpty())
        return;

    // We check that the file is readable :
    QFileInfo sol_file(new_path);
    if (!sol_file.isReadable()) {
        QMessageBox::critical(this, "Error", "Cannot read the specified solution file");
        return;
    }

    // We set the new path in the line edit :
    ui->solfile_lineEdit->setText(sol_file.absoluteFilePath());

    // We load the file :
    int stat = loadSolutionFile();
    if (stat != 0)
        QMessageBox::critical(this, "Error", "Cannot read the specified solution file. The solution file path in the text field might be invalid...");
}


/**
  *\fn int MainWindow::loadSolutionFileName(void)
  * This method is called when selecting the visualization tab. It gets
  * the name of the solution file to load, and sets it into the text
  * field, unless it already contains another file name.
  */
int MainWindow::loadSolutionFileName(void)
{
    QFileInfo *sol_file;

    // We load the name of the solution file, either from the problem
    // definition or from the text field.
    if (ui->solfile_lineEdit->text().isEmpty()) {
        if (bocopDef) {
            sol_file = new QFileInfo(problem_dir, QString::fromStdString(bocopDef->nameSolutionFile()));
            ui->solfile_lineEdit->setText(sol_file->absoluteFilePath());
        } else {
            return 0;
        }
    } else {
        sol_file = new QFileInfo(ui->solfile_lineEdit->text());
    }

    // We check that the file is readable.
    if (sol_file->isReadable()) {
        delete sol_file;
        return 0;
    } else {
        ui->solfile_lineEdit->setText("Please select a solution file.");
        delete sol_file;
        return 1;
    }
}


/**
  * \fn int MainWindow::loadSolutionFile(void)
  * This method loads the content of the solution file currently selected
  * in the text field. An instance of BocopSolution stores the data read from
  * the solution file.
  */
int MainWindow::loadSolutionFile(void)
{
    //    // We get the name of the solution file :
    //    int stat = loadSolutionFileName();
    //    if (stat != 0)
    //        return 1;

    // We delete the data that might remain from a previous visu :
    if (model_solution != 0) {
        delete model_solution;
        model_solution = 0;
    }

    if (bocopSol != 0) {
        delete bocopSol;
        bocopSol = 0;
    }

    // We delete the current plot (old data) :
    QList<QObject *> visu_child_list = ui->visu_widget->children();
    foreach (QObject *visu_child, visu_child_list)
        delete visu_child;

    //    for (int i=0; i<ui->visu_gridLayout->count(); i++)
    //        ui->visu_gridLayout->removeItem(ui->visu_gridLayout->itemAt(i));

    // We load the file specified in the line edit :
    QString sol_file = ui->solfile_lineEdit->text();
    QFileInfo sol_info(sol_file);

    // Now we check that the file exists, and is readable :
    if (!sol_info.isReadable())
        return 1;

    bocopSol = new BocopSolution(sol_file.toStdString());

    // We need to get the signals from BocopSolution. While loading the solution
    // file, it will tell us about the progress :
    connect(bocopSol, SIGNAL(loading_begin()),ui->solution_progressBar,SLOT(show()));
    connect(bocopSol, SIGNAL(loading_begin()),ui->loadsolfile_pushButton,SLOT(hide()));
    connect(bocopSol, SIGNAL(loading_begin()),ui->export_pushButton,SLOT(hide()));
    connect(bocopSol, SIGNAL(loaded(int)),ui->solution_progressBar,SLOT(setValue(int)));
    connect(bocopSol, SIGNAL(loading_end()),ui->solution_progressBar,SLOT(hide()));
    connect(bocopSol, SIGNAL(loading_end()),ui->loadsolfile_pushButton,SLOT(show()));
    connect(bocopSol, SIGNAL(loading_end()),ui->export_pushButton,SLOT(show()));

    // Now we can read the solution file :
    bocopSol->readSolutionFile();

    // We display a message on the status bar :
    ui->objective_label->setText(QString("Objective = %0").arg(bocopSol->valObjective()));
    ui->constraints_label->setText(QString("Constraint violation = %0").arg(bocopSol->valConstrViol()));
    //    QString tip = QString("Solution loaded. Objective = %0  - Constraint violation = %1").arg(bocopSol->valObjective()).arg(bocopSol->valConstrViol());
    //    ui->visu_treeView->setStatusTip(tip);


    // We load the names of the solution variables :
    setNamesSolutionTreeView();

    ui->print_pushButton->hide();
    ui->checkBoxShowVariablesBounds->hide();

    // We hide and uncheck the buttons to show the control with or without average
    ui->checkBoxControl->hide();
    ui->checkBoxStageControl->hide();

    return 0;
}


/**
  * \fn int MainWindow::setNamesSolutionTreeView(void)
  * This method is called after loading a solution file. It sets the names in the solution
  * treeview, according to the solution file. It creates one category for each type of variable,
  * and one subcategory for each variable. It also displays the values in the treeview for the
  * initial and final conditions, and for the optimization parameters.
  */
int MainWindow::setNamesSolutionTreeView(void)
{
    // We prepare the model for the tree view

    model_solution = new QStandardItemModel(3,1);

    QStringList category_mainNames;
    category_mainNames << "Variables" << "Constraints" << "Multipliers";
    QStringList category_VariablesNames;
    category_VariablesNames << "State Variables" << "Control Variables" << "Algebraic Variables" << "Optimization Parameters";
    QStringList category_ConstraintsNames;
    category_ConstraintsNames << "Boundary Constraints" << "Path Constraints" << "Dynamic Constraints";
    QStringList category_MultipliersNames;
    category_MultipliersNames << "Boundary Constraints Multipliers" << "Path Constraints Multipliers" << "Adjoint States";


    QStringList default_mainNames;
    default_mainNames << "states" << "constraints" << "multipliers";
    QStringList default_VariablesNames;
    default_VariablesNames << "state" << "control" << "algebraic" << "optimvar";
    QStringList default_ConstraintsNames;
    default_ConstraintsNames << "boundarycond" << "pathcond" << "dynamic";
    QStringList default_MultipliersNames;
    default_MultipliersNames << "boundarycondmult" << "pathcondmult" << "adjointstates";


    QList<int> dim_var, dim_constr, dim_mult;
    dim_var << bocopSol->dimState() << bocopSol->dimControl() << bocopSol->dimAlgebraic() << bocopSol->dimOptimvars() ;
    dim_constr << bocopSol->dimInitFinalCond() << bocopSol->dimPathConstraints() << bocopSol->dimState();
    dim_mult << bocopSol->dimInitFinalCond() << bocopSol->dimPathConstraints() << bocopSol->dimState();

    // Now we set the model
    // For each main category we set its childen
    for (int i=0; i<3; i++){
        // We create a new item for each main category :
        QStandardItem *category = new QStandardItem(category_mainNames.at(i));
        category->setEditable(false);
        model_solution->setItem(i,category);
    }

    // Now for each main category we set the sub categories

    // State variables
    for (int i =0;i<dim_var.size();i++){
        QStandardItem *variableCategory = new QStandardItem(category_VariablesNames.at(i));
        variableCategory->setEditable(false);
        model_solution->item(0)->setChild(i,0,variableCategory);

        // We get the children in model_names :
        for (int j=0;j<dim_var.at(i);++j) {

            // Subcategory (j-th child) :
            // name :
            QString name_sub = QString::fromStdString(bocopSol->nameVar(i,j));

            // default name :
            if (name_sub == "name_not_found")
                name_sub = QString(default_VariablesNames.at(i)+".%0").arg(j);

            QStandardItem *subcategory = new QStandardItem(name_sub);
            subcategory->setEditable(false);
            model_solution->item(0)->child(i)->setChild(j,0,subcategory);
        }
    }

    // Constraints
    for (int i =0;i<dim_constr.size();i++){
        QStandardItem *constraintCategory = new QStandardItem(category_ConstraintsNames.at(i));
        constraintCategory->setEditable(false);
        model_solution->item(1)->setChild(i,0,constraintCategory);

        // We get the children in model_names :
        for (int j=0;j<dim_constr.at(i);++j) {

            // Subcategory (j-th child) :
            // name :
            QString name_sub = QString::fromStdString(bocopSol->nameVar(i+dim_var.size(),j));

            // default name :
            if (name_sub == "name_not_found")
                name_sub = QString(default_ConstraintsNames.at(i)+".%0").arg(j);

            QStandardItem *subcategory = new QStandardItem(name_sub);
            subcategory->setEditable(false);
            model_solution->item(1)->child(i)->setChild(j,0,subcategory);
        }
    }

    // Multipliers
    for (int i =0;i<dim_mult.size();i++){
        QStandardItem *multiplierCategory = new QStandardItem(category_MultipliersNames.at(i));
        multiplierCategory->setEditable(false);
        model_solution->item(2)->setChild(i,0,multiplierCategory);

        // We get the children in model_names :
        for (int j=0;j<dim_mult.at(i);++j) {

            // Subcategory (j-th child) :
            // name :
            QString name_sub = QString::fromStdString(bocopSol->nameVar(i+dim_var.size()+dim_mult.size(),j));

            // default name :
            if (name_sub == "name_not_found")
                name_sub = QString(default_ConstraintsNames.at(i)+".%0").arg(j);

            QStandardItem *subcategory = new QStandardItem(name_sub);
            subcategory->setEditable(false);
            model_solution->item(2)->child(i)->setChild(j,0,subcategory);
        }
    }


    // We rename the optimization parameters to include the value of
    // each one (optimvar.i = value)
    for (int i=0; i<bocopSol->dimOptimvars(); ++i) {
        QStandardItem* item =  model_solution->item(0)->child(3)->child(i);
        QString txt = QString("%0 = %1").arg(item->text()).arg(bocopSol->valOptimVar(i));
        item->setText(txt);
    }

    // We do the same thing for the initial and final conditions, and we set
    // the color depending on if the bounds are respected or not, following the tolerance :
    // +++ NB which level tolerance should be token from IPOPT
    double tolerance = 0;
    QString toleranceString;

    if ( model_ipopt == 0 )
        loadOptimization();
    int modelIpoptRowCount = model_ipopt->rowCount();

    for (int i=0; i<modelIpoptRowCount; i++) {
        if (model_ipopt->item(i,0)->text() == "tol"){
            toleranceString = model_ipopt->item(i,1)->text();
            toleranceString.replace(QLatin1Char('d'), QLatin1Char('e'));
            toleranceString.replace(QLatin1Char('D'), QLatin1Char('e'));
            tolerance = toleranceString.toDouble();
        }
    }

    for (int i=0; i<bocopSol->dimInitFinalCond(); ++i) {
        QStandardItem* item =  model_solution->item(1)->child(0)->child(i);

        double low = bocopSol->valInitFinalCond(i,0);
        double val = bocopSol->valInitFinalCond(i,1);
        double upp = bocopSol->valInitFinalCond(i,2);
        int type = (int)bocopSol->valInitFinalCond(i,3);

        switch (type) {
        case 0 : // free
            item->setData(QColor(Qt::darkGreen), Qt::ForegroundRole);
            break;
        case 1 : // lower bound
            if ( low - val <= tolerance )
                item->setData(QColor(Qt::darkGreen), Qt::ForegroundRole);
            else
                item->setData(QColor(Qt::red), Qt::ForegroundRole);
            break;
        case 2 : // upper bound
            if (val - upp <= tolerance )
                item->setData(QColor(Qt::darkGreen), Qt::ForegroundRole);
            else
                item->setData(QColor(Qt::red), Qt::ForegroundRole);
            break;
        case 3 : // both lower and upper bounds
            if ( low - val <= tolerance && val - upp <= tolerance )
                item->setData(QColor(Qt::darkGreen), Qt::ForegroundRole);
            else
                item->setData(QColor(Qt::red), Qt::ForegroundRole);
            break;
        case 4 : // equality
            double absoluteValue = qAbs (val - low);
            if (absoluteValue <= tolerance )
                item->setData(QColor(Qt::darkGreen), Qt::ForegroundRole);
            else
                item->setData(QColor(Qt::red), Qt::ForegroundRole);
            break;
        }

        QString txt = QString("%0 = %1").arg(item->text()).arg(val);
        item->setText(txt);
    }

    // We do the same thing for the initial and final conditions, and we set
    // the color depending on if the bounds are respected or not :
    for (int i=0; i<bocopSol->dimInitFinalCond(); ++i) {
        QStandardItem* item =  model_solution->item(2)->child(0)->child(i);

        double val = bocopSol->valInitFinalCondMultiplier(i);

        QString txt = QString("%0 = %1").arg(item->text()).arg(val);
        item->setText(txt);
    }

    // We display the model in the treeview :
    ui->visu_treeView->setModel(model_solution);
    ui->visu_treeView->header()->hide();
    //    ui->visu_treeView->resizeColumnToContents(0);

    // to allow users to get more than one item at a time (Ctrl+click)
    ui->visu_treeView->setSelectionMode(QAbstractItemView::ExtendedSelection);

    visuSelectionModel = ui->visu_treeView->selectionModel();
    connect(visuSelectionModel, SIGNAL(selectionChanged(QItemSelection,QItemSelection)),this, SLOT(onVisuSelectionChanged(QItemSelection,QItemSelection)));

    return 0;
}


void MainWindow::onVisuSelectionChanged(QItemSelection selected,QItemSelection deselected)
{
    QModelIndexList indexList = selected.indexes();

    int indexListSize = indexList.size();

    // We treat just the case where the item selected is one
    if (indexListSize == 1)
    {
        visuPlotOneVariable(indexList.at(0));
    }
}

/**
  * \fn void MainWindow::manageVisuClicked(QModelIndex index)
  * This slot is called when an item is clicked in the treeview. It gets the
  * index of the selected item, and does a redirection to y=f(t) if a single
  * variable is selected, or y=f(x) if two variables are selected.
  */
void MainWindow::manageVisuClicked(QModelIndex index)
{
    // We resize the tree to its contents. As its size is fixed, a scrollbar
    // will appear automatically :
    // http://qt-project.org/faq/answer/how_can_i_ensure_that_a_horizontal_scrollbar_and_not_an_ellipse_shows_up_wh
    ui->visu_treeView->header()->setHorizontalScrollMode(QAbstractItemView::ScrollPerPixel);
#if (QT_VERSION < QT_VERSION_CHECK(5,0,0))
    ui->visu_treeView->header()->setResizeMode(0, QHeaderView::ResizeToContents);
#else
    ui->visu_treeView->header()->setSectionResizeMode(0, QHeaderView::ResizeToContents);
#endif


    ui->visu_treeView->header()->setStretchLastSection(false);

    // We hide and uncheck the buttons to show the control with or without average
    ui->checkBoxControl->hide();
    ui->checkBoxStageControl->hide();
    ui->checkBoxControl->setChecked(false);
    ui->checkBoxStageControl->setChecked(false);

    ui->checkBoxShowVariablesBounds->hide();

    // We get the number of selected items :
    QModelIndexList selected_items = ui->visu_treeView->selectionModel()->selectedIndexes();
    int nb_selected_items = selected_items.size();

    if (nb_selected_items > 2) {
        // cannot select more than 2 variables, we erase the plot, and display
        // the variable associated to the last selected index :
        ui->visu_treeView->selectionModel()->clearSelection();
        ui->visu_treeView->selectionModel()->select(index, QItemSelectionModel::NoUpdate);
        visuPlotOneVariable(index);
    }
    else if (nb_selected_items == 2) {
        visuPlotTwoVariables(index, selected_items);
    }
    else if (nb_selected_items == 1) {
        visuPlotOneVariable(index);
    }
}


/**
  * \fn void MainWindow::on_visu_treeView_doubleClicked(const QModelIndex &index)
  * This slot is called when an item is double clicked in the treeview. It gets the
  * index of the selected item, if the item is a parent it plots a grid of graphs of
  * the children of the item double clicked, if the item is a child it plots only the
  * graph for the clicked item.
  */
void MainWindow::on_visu_treeView_doubleClicked(const QModelIndex &index)
{
    // We take the unnormalized time vectors
    double* pointerSteps = new double[bocopSol->dimStepsAfterMerge()+1];
    double* pointerStages = new double[bocopSol->dimStages()*bocopSol->dimStepsAfterMerge()];

    int unnorm = unNormTimevectors(pointerSteps, pointerStages, bocopSol->dimStepsAfterMerge()+1, bocopSol->dimStages()*bocopSol->dimStepsAfterMerge());

    if (unnorm != 0)
        QMessageBox::critical(this, "Multiplot : unnormalize time vectors.", "Something went wrong in the calculation of the unnormalized time vectors");

    //QwtText test;

    // Current item parent :
    QModelIndex index_parent = index.parent();

    // If the item clicked has no parent, we are on a top-category :
    if (index_parent == QModelIndex())
    {
        // We visualize all the variabes of the top-category
        switch (index.row()){
        case 0: // Variables
            ui->checkBoxShowVariablesBounds->show();
            multiplotAllVariables(bocopSol->dimState()+bocopSol->dimControl()+bocopSol->dimAlgebraic(), 0);
            break;
        case 1: // Constraints
            multiplotAllVariables(bocopSol->dimPathConstraints()+bocopSol->dimState(), 1);
            break;
        case 2: // Multipliers
            multiplotAllVariables(bocopSol->dimPathConstraints()+bocopSol->dimState(), 2);
            break;
        }
    }
    else
    {
        QModelIndex index_grandparent = index_parent.parent();
        // If the parent of the item clicked has no parent, we are on one of the three main categories :
        if (index_grandparent == QModelIndex())
        {
            switch (index_parent.row()) {
            case 0 : // State variables
                switch (index.row()) {
                case 0 : //State
                    ui->checkBoxShowVariablesBounds->show();
                    multiplotOneVariable(pointerSteps, bocopSol->pointerAllState(), bocopSol->dimState(), 0, bocopSol->dimStepsAfterMerge()+1);
                    break;
                case 1 : //Control
                    ui->checkBoxShowVariablesBounds->show();
                    multiplotOneVariable(pointerSteps, bocopSol->pointerAllAverageControl(), bocopSol->dimControl(), 1, bocopSol->dimStepsAfterMerge());
                    break;
                case 2 : //Algebraic
                    multiplotOneVariable(pointerStages, bocopSol->pointerAllAlgebraic(), bocopSol->dimAlgebraic(), 2, bocopSol->dimStepsAfterMerge()*bocopSol->dimStages());
                    break;
                case 3 : //Optimvars
                    // We don't display a multiplot for the optimvars
                    break;
                }
                break;
            case 1 : // Constraints
                switch (index.row()) {
                case 0 : // Bound
                    // We don't display a multiplot for the bounds
                    break;
                case 1 : // Path
                    multiplotOneVariable(pointerStages, bocopSol->pointerAllPathConstraint(), bocopSol->dimPathConstraints(), 5, bocopSol->dimStepsAfterMerge()*bocopSol->dimStages());
                    break;
                case 2 : // Dynamic
                    multiplotOneVariable(pointerSteps, bocopSol->pointerAllDynamicConstraint(), bocopSol->dimState(), 6, bocopSol->dimStepsAfterMerge());
                    break;
                }
                break;
            case 2 : // Multipliers
                switch (index.row()) {
                case 0 : // Bound
                    // We don't display a multiplot for the bounds
                    break;
                case 1 : // Path
                    multiplotOneVariable(pointerStages, bocopSol->pointerAllPathConstrMultiplier(), bocopSol->dimPathConstraints(), 8, bocopSol->dimStepsAfterMerge()*bocopSol->dimStages());
                    break;
                case 2 : // Dynamic
                    multiplotOneVariable(pointerSteps, bocopSol->pointerAllDynamicConstrMultiplier(), bocopSol->dimState(), 9, bocopSol->dimStepsAfterMerge());
                    break;
                }
                break;
            }
        }
        // else we visualize one variable
        else
            visuPlotOneVariable(index);
    }

    delete[] pointerSteps;
    delete[] pointerStages;
}


/**
  *\fn int MainWindow::visuPlotOneVariable(const QModelIndex&)
  * This method plots the selected tree variable solution y=f(t). It works
  * only for a single index associated to a single variable y.
  */
int MainWindow::visuPlotOneVariable(const QModelIndex& index)
{
    QList<QObject *> visu_child_list = ui->visu_widget->children();
    foreach (QObject *visu_child, visu_child_list)
        delete visu_child;

    QGridLayout* visu_gridLayout = new QGridLayout(ui->visu_widget);

    QwtPlot* mainvisu_qwtPlot = new QwtPlot(QwtText("c1"), ui->visu_widget);
    visu_gridLayout->addWidget(mainvisu_qwtPlot);

    // If a zoom was previously provided to the plot, it disabled the autoscaling. We reset it :
    mainvisu_qwtPlot->setAxisAutoScale(QwtPlot::yLeft,true);
    mainvisu_qwtPlot->setAxisAutoScale(QwtPlot::xBottom,true);

    // Current item parent :
    QModelIndex index_parent = index.parent();

    int indice;

    // we set a temporary empty plot title :
    QString name_y;
    mainvisu_qwtPlot->titleLabel()->clear();

    // If the item clicked has no parent, we are on a top-category :
    if (index_parent == QModelIndex()){
        // do nothing
        mainvisu_qwtPlot->titleLabel()->clear();
        mainvisu_qwtPlot->titleLabel()->hide();
        ui->print_pushButton->hide();
        return 0;
    }
    // Else we could be on one of the three main categories
    else {
        QModelIndex index_grandparent = index_parent.parent();
        // If the parent of the item clicked has no parent, we are on one of the three main categories :
        if (index_grandparent == QModelIndex()){
            // do nothing
            mainvisu_qwtPlot->titleLabel()->clear();
            mainvisu_qwtPlot->titleLabel()->hide();
            ui->print_pushButton->hide();
            return 0;
        }
        // else subcategory
        else {

            QVariant val;
            QString val_str;

            // We create a new item to display :
            QwtPlotCurve *curve1 = new QwtPlotCurve("Solution Visualization");

            // We take the unnormalized time vectors
            double* pointerSteps = new double[bocopSol->dimStepsAfterMerge()+1];
            double* pointerStages = new double[bocopSol->dimStages()*bocopSol->dimStepsAfterMerge()];

            int unnorm = unNormTimevectors(pointerSteps, pointerStages, bocopSol->dimStepsAfterMerge()+1, bocopSol->dimStages()*bocopSol->dimStepsAfterMerge());

            if (unnorm != 0)
                QMessageBox::critical(this, "Multiplot of one variable: unnormalize time vectors.", "Something went wrong in the calculation of the unnormalized time vectors");

            switch (index_grandparent.row()) {
            case 0 : // Variables
                switch (index_parent.row()) {
                case 0 : //State
                    ui->checkBoxShowVariablesBounds->show();

                    name_y = QString::fromStdString(bocopSol->nameVar(0,index.row()));
                    curve1->setSamples(pointerSteps, bocopSol->pointerState(index.row()), bocopSol->dimStepsAfterMerge()+1 );
                    if(ui->checkBoxShowVariablesBounds->isChecked())
                        addVariableBoundsOnPlot(index.row(), mainvisu_qwtPlot, pointerStages[0], pointerStages[bocopSol->dimStepsAfterMerge()*bocopSol->dimStages()-1]);
                    break;
                case 1 : //Control
                    ui->checkBoxControl->show();
                    ui->checkBoxStageControl->show();
                    ui->checkBoxControl->setChecked(true);
                    ui->checkBoxStageControl->setChecked(false);
                    ui->checkBoxShowVariablesBounds->show();

                    name_y = QString::fromStdString(bocopSol->nameVar(1,index.row()));
                    curve1->setSamples(pointerSteps, bocopSol->pointerAverageControl(index.row()), bocopSol->dimStepsAfterMerge() );

                    indice = index.row() + dimState();
                    if(ui->checkBoxShowVariablesBounds->isChecked())
                        addVariableBoundsOnPlot(indice, mainvisu_qwtPlot, pointerStages[0], pointerStages[bocopSol->dimStepsAfterMerge()*bocopSol->dimStages()-1]);

                    break;
                case 2 : //Algebraic
                    name_y = QString::fromStdString(bocopSol->nameVar(2,index.row()));
                    curve1->setSamples(pointerStages, bocopSol->pointerAlgebraic(index.row()), bocopSol->dimStepsAfterMerge()*bocopSol->dimStages() );

                    indice = index.row() + dimState() + dimControl();
                    if(ui->checkBoxShowVariablesBounds->isChecked())
                        addVariableBoundsOnPlot(indice, mainvisu_qwtPlot, pointerStages[0], pointerStages[bocopSol->dimStepsAfterMerge()*bocopSol->dimStages()-1]);
                    break;
                case 3 : //Optimvars
                    val = index.data(Qt::DisplayRole);
                    val_str = val.toString();
                    ui->print_pushButton->hide();
                    delete[] pointerSteps;
                    delete[] pointerStages;
                    return 0;
                }
                break;
            case 1 : // Constraints
                switch (index_parent.row()) {
                case 0 : // Bound
                    val = index.data(Qt::DisplayRole);
                    val_str = val.toString();
                    ui->print_pushButton->hide();
                    delete[] pointerSteps;
                    delete[] pointerStages;
                    return 0;
                case 1 : // Path
                    name_y = QString::fromStdString(bocopSol->nameVar(5,index.row()));
                    curve1->setSamples(pointerStages, bocopSol->pointerPathConstraint(index.row()), bocopSol->dimStepsAfterMerge()*bocopSol->dimStages() );
                    addPathConstraintBoundsOnPlot(index.row(), mainvisu_qwtPlot,pointerStages[0], pointerStages[bocopSol->dimStepsAfterMerge()*bocopSol->dimStages()-1] );

                    break;
                case 2 : // Dynamic
                    name_y = QString::fromStdString(bocopSol->nameVar(6,index.row()));
                    curve1->setSamples(pointerSteps, bocopSol->pointerDynamicConstraint(index.row()), bocopSol->dimStepsAfterMerge() );
                    addBoundsOnPlot (0.0, 0.0, "equal", mainvisu_qwtPlot,pointerSteps[0], pointerSteps[bocopSol->dimStepsAfterMerge()]); // dynamic constraints always equal to zero
                    break;
                }
                break;
            case 2 : // Multipliers
                switch (index_parent.row()) {
                case 0 : // Bound
                    val = index.data(Qt::DisplayRole);
                    val_str = val.toString();
                    ui->print_pushButton->hide();
                    delete[] pointerSteps;
                    delete[] pointerStages;
                    return 0;
                case 1 : // Path
                    name_y = QString::fromStdString(bocopSol->nameVar(8,index.row()));
                    curve1->setSamples(pointerStages, bocopSol->pointerPathConstrMultiplier(index.row()), bocopSol->dimStepsAfterMerge()*bocopSol->dimStages() );
                    break;
                case 2 : // Dynamic
                    name_y = QString::fromStdString(bocopSol->nameVar(9,index.row()));
                    curve1->setSamples(pointerSteps, bocopSol->pointerDynamicConstrMultiplier(index.row()), bocopSol->dimStepsAfterMerge() );
                    break;
                }
                break;
            }

            QPen pen(Qt::blue);
            pen.setWidth(2);
            curve1->setPen(pen);
            curve1->attach(mainvisu_qwtPlot);

            QBrush main_brush(Qt::white);
            mainvisu_qwtPlot->setCanvasBackground(main_brush);

            // We set a title on the graph :
            QString plot_title = QString("%0 = f( t )").arg(name_y);
            mainvisu_qwtPlot->setTitle(plot_title);

            // finally, refresh the plot
            mainvisu_qwtPlot->replot();
            mainvisu_qwtPlot->updateAxes();

            // associate zoom with the current plot :
            QwtPlotZoomer *zoom = new QwtPlotZoomer(mainvisu_qwtPlot->canvas());
            ui->print_pushButton->show();

            delete[] pointerSteps;
            delete[] pointerStages;
        }
    }

    //    QwtPlotRenderer renderer;
    //    renderer.renderDocument( mainvisu_qwtPlot, "/home/dgiorgi/bocop/trunk/test.pdf", QSizeF(200, 150), 300);

    return 0;
}


/**
  *\fn int MainWindow::visuPlotTwoVariables(const QModelIndex&, const QModelIndexList&)
  * This method is called when two variables are selected in the solution treeview. It
  * plots the second against the first.
  */

int MainWindow::visuPlotTwoVariables(const QModelIndex& last_item, const QModelIndexList& all_items)
{
    QList<QObject *> visu_child_list = ui->visu_widget->children();
    foreach (QObject *visu_child, visu_child_list)
        delete visu_child;

    QGridLayout* visu_gridLayout = new QGridLayout(ui->visu_widget);
    QwtPlot* mainvisu_qwtPlot = new QwtPlot(QwtText("c1"), ui->visu_widget);
    visu_gridLayout->addWidget(mainvisu_qwtPlot);

    // If a zoom was previously provided to the plot, it disabled the autoscaling. We reset it :
    mainvisu_qwtPlot->setAxisAutoScale(QwtPlot::yLeft,true);
    mainvisu_qwtPlot->setAxisAutoScale(QwtPlot::xBottom,true);

    // we set a temporary empty plot title :
    mainvisu_qwtPlot->setTitle("");

    mainvisu_qwtPlot->replot();

    // We check that selected items are valid for using this function :
    if (!all_items.contains(last_item))
        return 1;

    if (!(all_items.size() == 2))
        return 2;

    // The first item clicked is the abscisse, the second is the ordinate
    QModelIndex index_x;
    QModelIndex index_y = last_item;
    if (!(all_items.at(0) == last_item))
        index_x = all_items.at(0);
    else
        index_x = all_items.at(1);

    // Current item parent :
    QModelIndex index_x_parent = index_x.parent();
    QModelIndex index_y_parent = index_y.parent();

    // If the item clicked has no parent, we are on a top-category :
    if (index_x_parent == QModelIndex() || index_y_parent == QModelIndex())
        return 3;

    QModelIndex index_x_grandparent = index_x_parent.parent();
    QModelIndex index_y_grandparent = index_y_parent.parent();

    // If the parent of the item clicked has no parent, we are on a main category :
    if (index_x_grandparent == QModelIndex() || index_y_grandparent == QModelIndex())
        return 3;

    // We plot just the states, the controls and the adjoint states
    if (!( (index_x_grandparent.row() == 0 && index_y_grandparent.row() == 0 && index_x_parent.row() == 0 && index_y_parent.row() == 0 ) ||
           (index_x_grandparent.row() == 0 && index_y_grandparent.row() == 0 && index_x_parent.row() == 1 && index_y_parent.row() == 1 ) ||
           (index_x_grandparent.row() == 2 && index_y_grandparent.row() == 2 && index_x_parent.row() == 2 && index_y_parent.row() == 2 ) ) )
        return 3;

    // We get the number of points to display :
    int dimension = bocopSol->dimStepsAfterMerge()+1;

    // Then we get the arrays :
    double* x = 0;
    double* y = 0;

    // names of the variables to plot :
    QString name_x;
    QString name_y;

    // Index for states or controls plot
    // If we plot the states it's 0 if we plot the controls it's 1 and if we plot the adjoint states it's 2
    int index_var = index_x_parent.row();

    switch (index_var)
    {
    case 0:
        x = bocopSol->pointerState(index_x.row());
        y = bocopSol->pointerState(index_y.row());
        name_x = QString::fromStdString(bocopSol->nameVar(index_var,index_x.row()));
        name_y = QString::fromStdString(bocopSol->nameVar(index_var,index_y.row()));
        break;
    case 1:
        x = bocopSol->pointerAverageControl(index_x.row());
        y = bocopSol->pointerAverageControl(index_y.row());
        name_x = QString::fromStdString(bocopSol->nameVar(index_var,index_x.row()));
        name_y = QString::fromStdString(bocopSol->nameVar(index_var,index_y.row()));
        break;
    case 2:
        x = bocopSol->pointerDynamicConstrMultiplier(index_x.row());
        y = bocopSol->pointerDynamicConstrMultiplier(index_y.row());
        name_x = QString::fromStdString(bocopSol->nameVar(9,index_x.row()));
        name_y = QString::fromStdString(bocopSol->nameVar(9,index_y.row()));
        break;
    }

    if (x==0 || y == 0)
        return 7;

    QwtPlotCurve* xy_curve = new QwtPlotCurve("Solution Visualization");
    if (index_var == 0)
        xy_curve->setSamples(x, y, dimension);
    else
        xy_curve->setSamples(x, y, dimension-1);

    QPen pen(Qt::blue);
    pen.setWidth(2);
    xy_curve->setPen(pen);
    xy_curve->attach(mainvisu_qwtPlot);

    // We set a title on the plot :
    QString plot_title;
    plot_title = QString("%0 = f( %1 )").arg(name_y).arg(name_x);
    mainvisu_qwtPlot->setTitle(plot_title);

    // finally, refresh the plot
    mainvisu_qwtPlot->replot();
    mainvisu_qwtPlot->updateAxes();

    QBrush main_brush(Qt::white);
    mainvisu_qwtPlot->setCanvasBackground(main_brush);

    // associate zoom with the current plot :
    QwtPlotZoomer *zoom = new QwtPlotZoomer(mainvisu_qwtPlot->canvas());

    return 0;
}

/**
  * \fn int MainWindow::addBoundsOnPlot(double lower_bound, double upper_bound, double type_bound, QwtPlot *visu_qwtPlot, double time_min, double time_max)
  * This function is called when there are bounds to display (bounded variable). According to the
  * type of bound, it shows lower and/or upper, or equality bounds as a red line on the current plot.
  */

int MainWindow::addBoundsOnPlot(double lower_bound, double upper_bound, string type, QwtPlot *visu_qwtPlot, double time_min, double time_max)
{
    QPen pen(Qt::red);
    pen.setWidth(2);

    QwtPlotCurve* lower_curve = 0;
    QwtPlotCurve* upper_curve = 0;

    double* lower_array = 0;
    double* upper_array = 0;


    double *time_minmax = new double[2];
    time_minmax[0] = time_min;
    time_minmax[1] = time_max;


    if (type == "0" || type == "free") {
        // no bounds
        ;
    }
    else if (type == "1" || type == "lower"){
        // lower bound
        lower_array = new double[2];
        lower_array[0] = lower_bound; lower_array[1] = lower_bound;

        lower_curve = new QwtPlotCurve("Lower bound");
        lower_curve->setSamples(time_minmax, lower_array, 2);

        lower_curve->setPen(pen);
        lower_curve->attach(visu_qwtPlot);
    }
    else if (type == "2" || type == "upper"){
        // upper bound
        upper_array = new double[2];
        upper_array[0] = upper_bound; upper_array[1] = upper_bound;

        upper_curve = new QwtPlotCurve("Upper bound");
        upper_curve->setSamples(time_minmax, upper_array, 2);

        upper_curve->setPen(pen);
        upper_curve->attach(visu_qwtPlot);
    }
    else if (type == "3" || type == "both") {
        // both lower and upper bounds
        lower_array = new double[2];
        lower_array[0] = lower_bound; lower_array[1] = lower_bound;

        lower_curve = new QwtPlotCurve("Lower bound");
        lower_curve->setSamples(time_minmax, lower_array, 2);

        lower_curve->setPen(pen);
        lower_curve->attach(visu_qwtPlot);


        upper_array = new double[2];
        upper_array[0] = upper_bound; upper_array[1] = upper_bound;

        upper_curve = new QwtPlotCurve("Upper bound");
        upper_curve->setSamples(time_minmax, upper_array, 2);

        upper_curve->setPen(pen);
        upper_curve->attach(visu_qwtPlot);
    } else if (type == "4" || type == "equal") {
        // equality
        lower_array = new double[2];
        lower_array[0] = lower_bound; lower_array[1] = lower_bound;

        lower_curve = new QwtPlotCurve("Equality");
        lower_curve->setSamples(time_minmax, lower_array, 2);

        lower_curve->setPen(pen);
        lower_curve->attach(visu_qwtPlot);
    }

    delete[] time_minmax;
    return 0;
}


/**
  * \fn int MainWindow::addVariableBoundsOnPlot(int indice, QwtPlot *visu_qwtPlot, double time_min, double time_max)
  * This function is called when there are bounds to display (bounded variable). According to the
  * type of bound, it shows lower and/or upper, or equality bounds as a red line on the current plot.
  */
int MainWindow::addVariableBoundsOnPlot(int indice, QwtPlot *visu_qwtPlot, double time_min, double time_max)
{
    int ok = 0;
    double lower_bound;
    double upper_bound;
    string type;

    ok |= bocopDef->lowerBoundVariable(indice, lower_bound);
    ok |= bocopDef->upperBoundVariable(indice, upper_bound);
    ok |= bocopDef->typeBoundVariable(indice, type);

    if(ok == 0)
        addBoundsOnPlot(lower_bound, upper_bound, type, visu_qwtPlot, time_min, time_max);
    else
        QMessageBox::critical(this, "ERROR", "cant find variable bounds!");

    return 0;
}


/**
  * \fn int MainWindow::addPathConstraintBoundsOnPlot(int indice, QwtPlot *visu_qwtPlot, double time_min, double time_max)
  * This function is called when there are bounds to display (bound PathConstraint). According to the
  * type of bound, it shows lower and/or upper, or equality bounds as a red line on the current plot.
  */
int MainWindow::addPathConstraintBoundsOnPlot(int indice, QwtPlot *visu_qwtPlot, double time_min, double time_max)
{
    int ok = 0;
    double lower_bound;
    double upper_bound;
    string type;

    ok |= bocopDef->lowerBoundPathConstraint(indice, lower_bound);
    ok |= bocopDef->upperBoundPathConstraint(indice, upper_bound);
    ok |= bocopDef->typeBoundPathConstraint(indice, type);

    if(ok == 0)
        addBoundsOnPlot(lower_bound, upper_bound, type, visu_qwtPlot, time_min, time_max);
    else
        QMessageBox::critical(this, "ERROR", "cant find PathConstraint bounds!");

    return 0;
}


/**
  * \fn int MainWindow::on_print_pushButton_clicked()
  * This function prints and saves the graph in the current plot.
  */
void MainWindow::on_print_pushButton_clicked()
{
    QString selectedFilter;
    QString filename = QFileDialog::getSaveFileName(this,"Choose save file for graph...","","(*.png)", &selectedFilter);
    QFileInfo file(filename);

    if (!filename.isEmpty())
    {
        if(file.suffix().isEmpty())
        {
            if (selectedFilter == "")
            {
                QMessageBox::critical(this, "Error", "The file suffix is not defined, the default one will be .png.");
                filename.append(".png");
            }

            else if(selectedFilter == "(*.png)")
                filename.append(".png");
        }
        QPixmap picture;
        picture = QPixmap::grabWidget(ui->visu_widget);
        bool ret = picture.save(filename);
        QStatusBar *status;
        status = statusBar();
        if (ret)
            status->showMessage("Graph successfully saved");
        else
            status->showMessage("ERROR: Graph could not be saved");
    }

}


/**
  * \fn int MainWindow::on_checkBoxControl_clicked()
  * This function plots the graph of the control if the checkBoxControl is checked, if not it hides the graph.
  */
void MainWindow::on_checkBoxControl_clicked()
{   
    bool isChecked = ui->checkBoxControl->isChecked();
    if ( !isChecked ){
        foreach(QwtPlot *widget, ui->visu_widget->findChildren<QwtPlot*>()) {
            QwtPlotItemList itemListPlot = widget->itemList();
            for (int i = 0; i<itemListPlot.size(); i++){
                if (itemListPlot.at(i)->title().text() == "Solution Visualization"){
                    itemListPlot.at(i)->detach();
                    widget->replot();
                }
            }
        }
    }
    else{
        // We take the unnormalized time vectors
        double* pointerSteps = new double[bocopSol->dimStepsAfterMerge()+1];
        double* pointerStages = new double[bocopSol->dimStages()*bocopSol->dimStepsAfterMerge()];

        int unnorm = unNormTimevectors(pointerSteps, pointerStages, bocopSol->dimStepsAfterMerge()+1, bocopSol->dimStages()*bocopSol->dimStepsAfterMerge());

        if (unnorm != 0)
            QMessageBox::critical(this, "Multiplot of one variable: unnormalize time vectors.", "Something went wrong in the calculation of the unnormalized time vectors");

        QModelIndex index = ui->visu_treeView->currentIndex();
        QwtPlotCurve *curve1 = new QwtPlotCurve("Solution Visualization");
        curve1->setSamples(pointerSteps, bocopSol->pointerAverageControl(index.row()), bocopSol->dimStepsAfterMerge() );

        QList<QwtPlot*> widgets =  ui->visu_widget->findChildren<QwtPlot*>();

        QPen pen(Qt::blue);
        pen.setWidth(2);
        curve1->setPen(pen);
        curve1->attach(widgets.at(0));
        widgets.at(0)->replot();
    }
}


/**
  * \fn int MainWindow::on_checkBoxAverageControl_clicked()
  * This function plots the graph of the Stage control if the checkBoxStageControl is checked, if not it hides the graph.
  */
void MainWindow::on_checkBoxStageControl_clicked()
{
    bool isChecked = ui->checkBoxStageControl->isChecked();
    if ( !isChecked ){
        foreach(QwtPlot *widget, ui->visu_widget->findChildren<QwtPlot*>()) {
            QwtPlotItemList itemListPlot = widget->itemList();
            for (int i = 0; i<itemListPlot.size(); i++){
                if (itemListPlot.at(i)->title().text() == "Stage control"){
                    itemListPlot.at(i)->detach();
                    widget->replot();
                }
            }
        }
    }
    else{
        // We take the unnormalized time vectors
        double* pointerSteps = new double[bocopSol->dimStepsAfterMerge()+1];
        double* pointerStages = new double[bocopSol->dimStages()*bocopSol->dimStepsAfterMerge()];

        int unnorm = unNormTimevectors(pointerSteps, pointerStages, bocopSol->dimStepsAfterMerge()+1, bocopSol->dimStages()*bocopSol->dimStepsAfterMerge());

        if (unnorm != 0)
            QMessageBox::critical(this, "Multiplot of one variable: unnormalize time vectors.", "Something went wrong in the calculation of the unnormalized time vectors");

        QModelIndex index = ui->visu_treeView->currentIndex();
        QwtPlotCurve *curve1 = new QwtPlotCurve("Stage control");
        curve1->setSamples(pointerStages, bocopSol->pointerControl(index.row()), bocopSol->dimStepsAfterMerge()*bocopSol->dimStages() );

        QList<QwtPlot*> widgets =  ui->visu_widget->findChildren<QwtPlot*>();

        QPen pen(Qt::red);
        pen.setWidth(2);
        curve1->setPen(pen);
        curve1->attach(widgets.at(0));
        widgets.at(0)->replot();
    }
}


/**
  * \fn int MainWindow::multiplotOneVariable(const double *xData, const double *yData, int size)
  * This function is used to plot a matrix of variables
  */
int MainWindow::multiplotOneVariable(const double *xData, double **yData, const int dimVar, const int indexVar, const int size)
{
    if (multiSize != 0 && multi_qwtPlot != 0)
    {
        // We don't delete the single plots, curves and zooms
        // Since they are automatically deleted from Qt
        delete[] multi_qwtPlot;
        delete[] multi_curve;
        delete[] multi_zoom;
        multiSize = 0;
        multi_curve = 0;
        multi_qwtPlot = 0;
        multi_zoom = 0;
    }

    // We delete the old plots
    QList<QObject *> visu_child_list = ui->visu_widget->children();
    foreach (QObject *visu_child, visu_child_list)
        delete visu_child;

    // We prepare a new grid layout
    QGridLayout* visu_gridLayout = new QGridLayout(ui->visu_widget);

    // We prepare an array of plots pointers and an array of curves pointers
    multiSize = dimVar;
    multi_qwtPlot = new QwtPlot*[multiSize];
    multi_curve = new QwtPlotCurve*[multiSize];
    multi_zoom = new QwtPlotZoomer*[multiSize];

    // Dimensions of the grid layout
    int n=0;
    int m=0;
    double sq=0;

    // Plot title, it will be the name of the variable
    QString name_y;

    QPen pen(Qt::blue);
    pen.setWidth(2);
    QBrush main_brush(Qt::white);

    // We get the number of columns and rows to display
    sq = sqrt(dimVar);
    sq = round(sq);
    if (sq*sq < dimVar)
    {
        n = sq+1;
        m = sq;
    }
    else
    {
        n = sq;
        m = sq;
    }

    // We make a loop on the rows dimension
    for (int i=0; i<m; i++)
    {
        // We make a loop on the columns dimension
        for (int j=0; j<n; j++)
        {
            // After the variables dimension we leave empty widgets in the grid layout
            if (i*n+j<=dimVar-1)
            {
                QString name = "c" + QString::number(i*n+j);
                multi_qwtPlot[i*n+j] = new QwtPlot(QwtText(name), ui->visu_widget);
                name = "Solution Visualization" + QString::number(i*n+j);
                multi_curve[i*n+j] = new QwtPlotCurve(name);

                multi_curve[i*n+j]->setSamples(xData, yData[i*n+j], size);
                multi_curve[i*n+j]->setPen(pen);
                multi_curve[i*n+j]->attach(multi_qwtPlot[i*n+j]);

                int indice;


                // We display also the state bounds plotted in red
                if (indexVar == 0)
                {
                    ui->checkBoxShowVariablesBounds->show();
                    // we display the state bounds plotted in red
                    if(ui->checkBoxShowVariablesBounds->isChecked())
                        addVariableBoundsOnPlot(i*n+j,  multi_qwtPlot[i*n+j], xData[0], xData[size-1]);
                }
                else if (indexVar == 1){
                    ui->checkBoxShowVariablesBounds->show();

                    // we display the control bounds plotted in red
                    indice = dimState()+ i*n+j;
                    if(ui->checkBoxShowVariablesBounds->isChecked())
                        addVariableBoundsOnPlot(indice,  multi_qwtPlot[i*n+j], xData[0], xData[size-1]);
                }
                else if (indexVar == 2){
                    ui->checkBoxShowVariablesBounds->show();

                    // we display the control bounds plotted in red
                    indice = dimControl()+ dimState()+ i*n+j;
                    if(ui->checkBoxShowVariablesBounds->isChecked())
                        addVariableBoundsOnPlot(indice,  multi_qwtPlot[i*n+j], xData[0], xData[size-1]);
                }

                // If we display the path conditions or the dynamic constraints, we display also the bounds plotted in red
                else if (indexVar == 5)
                {
                    addPathConstraintBoundsOnPlot(i*n+j, multi_qwtPlot[i*n+j], xData[0], xData[size-1]);
                }
                else if (indexVar == 6){
                    addBoundsOnPlot (0.0, 0.0, "equal",  multi_qwtPlot[i*n+j], xData[0], xData[size-1]); // dynamic constraints always equal to zero
                    //addBoundsOnPlot (0.0, 0.0, 4.0,  multi_qwtPlot[i*n+j], bocopSol->valStage(0), bocopSol->valStage(bocopSol->dimSteps()*bocopSol->dimStages()-1)); // dynamic constraints always equal to zero
                }

                // We set a title on the graph :
                name_y = QString::fromStdString(bocopSol->nameVar(indexVar,i*n+j));
                QString plot_title = QString("%0").arg(name_y);
                multi_qwtPlot[i*n+j]->setTitle(plot_title);

                multi_qwtPlot[i*n+j]->setCanvasBackground(main_brush);
                multi_qwtPlot[i*n+j]->setMinimumSize(1,1);

                visu_gridLayout->addWidget(multi_qwtPlot[i*n+j], i,j);

                // finally, refresh the plot
                multi_qwtPlot[i*n+j]->replot();
                multi_qwtPlot[i*n+j]->updateAxes();

                // associate zoom with the current plot :
                multi_zoom[i*n+j] = new QwtPlotZoomer(multi_qwtPlot[i*n+j]->canvas());

                ui->print_pushButton->show();
            }
        }
    }
    ui->visu_widget->adjustSize();

    return 0;
}

/**
  * \fn int MainWindow::multiplotAllVariables(const double *xData, const double *yData, int size)
  * This function is used to plot a matrix of variables
  */
int MainWindow::multiplotAllVariables(const int dimVar, const int indexCategory)
{
    if (multiSize != 0 && multi_qwtPlot != 0)
    {
        // We don't delete the single plots, curves and zooms
        // Since they are automatically deleted from Qt
        delete[] multi_qwtPlot;
        delete[] multi_curve;
        delete[] multi_zoom;
        multiSize = 0;
        multi_curve = 0;
        multi_qwtPlot = 0;
        multi_zoom = 0;
    }

    // We delete the old plots
    QList<QObject *> visu_child_list = ui->visu_widget->children();
    foreach (QObject *visu_child, visu_child_list)
        delete visu_child;

    // We prepare a new grid layout
    QGridLayout* visu_gridLayout = new QGridLayout(ui->visu_widget);

    // We prepare an array of plots pointers and an array of curves pointers
    multiSize = dimVar;
    multi_qwtPlot = new QwtPlot*[multiSize];
    multi_curve = new QwtPlotCurve*[multiSize];
    multi_zoom = new QwtPlotZoomer*[multiSize];

    // We take the unnormalized time vectors
    double* pointerSteps = new double[bocopSol->dimStepsAfterMerge()+1];
    double* pointerStages = new double[bocopSol->dimStages()*bocopSol->dimStepsAfterMerge()];

    int unnorm = unNormTimevectors(pointerSteps, pointerStages, bocopSol->dimStepsAfterMerge()+1, bocopSol->dimStages()*bocopSol->dimStepsAfterMerge());

    if (unnorm != 0)
        QMessageBox::critical(this, "Multiplot : unnormalize time vectors.", "Something went wrong in the calculation of the unnormalized time vectors");

    // Dimensions of the grid layout
    int n=0;
    int m=0;
    double sq=0;

    // Plot title, it will be the name of the variable
    QString name_y;

    QPen pen(Qt::blue);
    pen.setWidth(2);
    QBrush main_brush(Qt::white);

    // We get the number of columns and rows to display
    sq = sqrt(dimVar);
    sq = round(sq);
    if (sq*sq < dimVar)
    {
        n = sq+1;
        m = sq;
    }
    else
    {
        n = sq;
        m = sq;
    }

    // We make a loop on the rows dimension
    for (int i=0; i<m; i++)
    {
        // We make a loop on the columns dimension
        for (int j=0; j<n; j++)
        {
            int indice = i*n+j;
            // After the variables dimension we leave empty widgets in the grid layout
            //            if (i*n+j<=dimVar-1)
            if (indice<=dimVar-1)
            {
                QString name = "c" + QString::number(indice);
                multi_qwtPlot[indice] = new QwtPlot(QwtText(name), ui->visu_widget);
                name = "Solution Visualization" + QString::number(indice);
                multi_curve[indice] = new QwtPlotCurve(name);

                switch (indexCategory){
                case 0: // Variables
                    if (indice<bocopSol->dimState())
                    {
                        multi_curve[indice]->setSamples(pointerSteps, bocopSol->pointerAllState()[indice], bocopSol->dimStepsAfterMerge()+1);
                        name_y = QString::fromStdString(bocopSol->nameVar(0,indice));

                        // we display the state bounds plotted in red
                        if(ui->checkBoxShowVariablesBounds->isChecked())
                            addVariableBoundsOnPlot(indice,  multi_qwtPlot[indice], pointerStages[0], pointerStages[bocopSol->dimStepsAfterMerge()*bocopSol->dimStages()-1]);
                    }
                    else if (i*n+j<bocopSol->dimState()+bocopSol->dimControl())
                    {
                        multi_curve[i*n+j]->setSamples(pointerSteps, bocopSol->pointerAllAverageControl()[i*n+j-bocopSol->dimState()], bocopSol->dimStepsAfterMerge());
                        name_y = QString::fromStdString(bocopSol->nameVar(1,i*n+j-bocopSol->dimState()));

                        // we display the control bounds plotted in red
                        if(ui->checkBoxShowVariablesBounds->isChecked())
                            addVariableBoundsOnPlot(i*n+j,  multi_qwtPlot[i*n+j], pointerStages[0], pointerStages[bocopSol->dimStepsAfterMerge()*bocopSol->dimStages()-1]);

                    }
                    else if (i*n+j<bocopSol->dimState()+bocopSol->dimControl()+bocopSol->dimAlgebraic())
                    {
                        multi_curve[i*n+j]->setSamples(pointerStages, bocopSol->pointerAllAlgebraic()[i*n+j-bocopSol->dimState()-bocopSol->dimControl()],bocopSol->dimStepsAfterMerge()*bocopSol->dimStages());
                        name_y = QString::fromStdString(bocopSol->nameVar(2,i*n+j-bocopSol->dimState()-bocopSol->dimControl()));

                        // we display the control bounds plotted in red
                        addVariableBoundsOnPlot(i*n+j, multi_qwtPlot[i*n+j], pointerStages[0], pointerStages[bocopSol->dimStepsAfterMerge()*bocopSol->dimStages()-1]);
                    }
                    break;
                case 1: // Constraints
                    if (i*n+j<bocopSol->dimPathConstraints())
                    {
                        multi_curve[i*n+j]->setSamples(pointerStages, bocopSol->pointerAllPathConstraint()[i*n+j], bocopSol->dimStepsAfterMerge()*bocopSol->dimStages());
                        name_y = QString::fromStdString(bocopSol->nameVar(5,i*n+j));

                        // we display also the bounds plotted in red
                       addPathConstraintBoundsOnPlot(i*n+j, multi_qwtPlot[i*n+j], pointerStages[0], pointerStages[bocopSol->dimStepsAfterMerge()*bocopSol->dimStages()-1]);
                    }
                    else if (i*n+j<bocopSol->dimPathConstraints()+bocopSol->dimState())
                    {
                        multi_curve[i*n+j]->setSamples(pointerSteps, bocopSol->pointerAllDynamicConstraint()[i*n+j-bocopSol->dimPathConstraints()], bocopSol->dimStepsAfterMerge());
                        name_y = QString::fromStdString(bocopSol->nameVar(6,i*n+j-bocopSol->dimPathConstraints()));
                        // we display also the bounds plotted in red
                        addBoundsOnPlot (0.0, 0.0, "equal",  multi_qwtPlot[i*n+j], pointerStages[0], pointerStages[bocopSol->dimStepsAfterMerge()*bocopSol->dimStages()-1]); // dynamic constraints always equal to zero
                    }
                    break;
                case 2: // Multipliers
                    if (i*n+j<bocopSol->dimPathConstraints())
                    {
                        multi_curve[i*n+j]->setSamples(pointerStages, bocopSol->pointerAllPathConstrMultiplier()[i*n+j], bocopSol->dimStepsAfterMerge()*bocopSol->dimStages());
                        name_y = QString::fromStdString(bocopSol->nameVar(8,i*n+j));
                    }
                    else if (i*n+j<bocopSol->dimPathConstraints()+bocopSol->dimState())
                    {
                        multi_curve[i*n+j]->setSamples(pointerSteps, bocopSol->pointerAllDynamicConstrMultiplier()[i*n+j-bocopSol->dimPathConstraints()], bocopSol->dimStepsAfterMerge());
                        name_y = QString::fromStdString(bocopSol->nameVar(9,i*n+j-bocopSol->dimPathConstraints()));
                    }
                    break;
                }

                multi_curve[i*n+j]->setPen(pen);
                multi_curve[i*n+j]->attach(multi_qwtPlot[i*n+j]);

                // We set a title on the graph :
                QString plot_title = QString("%0").arg(name_y);
                multi_qwtPlot[i*n+j]->setTitle(plot_title);

                multi_qwtPlot[i*n+j]->setCanvasBackground(main_brush);
                multi_qwtPlot[i*n+j]->setMinimumSize(1,1);

                visu_gridLayout->addWidget(multi_qwtPlot[i*n+j], i,j);

                // finally, refresh the plot
                multi_qwtPlot[i*n+j]->replot();
                //multi_qwtPlot[i*n+j]->updateAxes();

                // associate zoom with the current plot :
                multi_zoom[i*n+j] = new QwtPlotZoomer(multi_qwtPlot[i*n+j]->canvas());

                ui->print_pushButton->show();
            }
        }
    }
    ui->visu_widget->adjustSize();

    delete[] pointerSteps;
    delete[] pointerStages;

    return 0;
}


/**
  * \fn void MainWindow::on_saveAsPushButton_clicked()
  * This function is used to save problem.sol as it is.
  */
void MainWindow::on_saveAsPushButton_clicked()
{
    QString starting_path = problem_dir.absolutePath();

    QString filters( "Bocop solution file (*.sol)" );
    QString selectedFilter;

    //QString usrSolFile = QFileDialog::getSaveFileName(this, tr("Please select a data file to save"), starting_path,"Bocop solution file (*.sol)");
    QString usrSolFile = QFileDialog::getSaveFileName(this, tr("Please select a data file to save"), starting_path,
                                                      filters, &selectedFilter, QFileDialog::DontConfirmOverwrite);
    // If nothing is returned :
    if (usrSolFile.isEmpty())
        return;

    if (QFile::exists(usrSolFile))
    {
        QMessageBox::StandardButton reply;
        reply = QMessageBox::warning(this, "Attention",
                                     tr("%0 already exists. \nDo you really want to overwrite it?").arg(usrSolFile),
                                     QMessageBox::Yes|QMessageBox::No);
        if (reply == QMessageBox::Yes) QFile::remove(usrSolFile);
    }

    // Copy Bocop .sol file
    QString solFile = problem_dir.path() + "/" + (QString::fromStdString(bocopDef->nameSolutionFile()));

    QFile::copy(solFile,usrSolFile);

}


/**
  * \fn void MainWindow::on_export_pushButton_clicked()
  * This function is used to export each variable in a separate file
  * So that the user can easily used them, for example for personal plots
  */
void MainWindow::on_export_pushButton_clicked()
{
    // We choose or create a directory where we make the export
    QString starting_path = problem_dir.absolutePath();
    QString exportDirectory = QFileDialog::getExistingDirectory(this,
                                                                tr("Choose Or Create the Export Directory"),
                                                                starting_path,
                                                                QFileDialog::DontResolveSymlinks);

    if (exportDirectory==starting_path){
        int isDefaultPath = QMessageBox::warning(this,
                                                 QString("Choose or create an export directory"),
                                                 tr("If you don't choose or create an export directory, the export will be done in the default folder %0/solution_export. \nAre you sure you want to continue?").arg(exportDirectory),
                                                 QMessageBox::Yes | QMessageBox::Cancel);
        if (isDefaultPath == QMessageBox::Yes){
            exportDirectory = starting_path + "/solution_export";
            QDir().mkdir(exportDirectory);
        }
        else
            return;
    }

    // If the directory is not empty we ask if the user wants to replace the existing files
    QDir expdir = QDir(exportDirectory);
    int nbSubDir =  expdir.count();

    if (nbSubDir > 2)
    {
        int ret = QMessageBox::warning(this,
                                       QString("The export directory is not empty "),
                                       tr(" The existing files in the directory %0 will be replaced with the export. \nAre you sure you want to continue?").arg(exportDirectory),
                                       QMessageBox::Yes | QMessageBox::Cancel);
        switch(ret)
        {
        case QMessageBox::Yes:
            break;
        case QMessageBox::Cancel:
            return;
            break;
        }
    }

    // We start to export the data
    QString namefile;
    ofstream file_out;

    // We take the unnormalized time vectors
    double* pointerSteps = new double[bocopSol->dimStepsAfterMerge()+1];
    double* pointerStages = new double[bocopSol->dimStages()*bocopSol->dimStepsAfterMerge()];

    int unnorm = unNormTimevectors(pointerSteps, pointerStages, bocopSol->dimStepsAfterMerge()+1, bocopSol->dimStages()*bocopSol->dimStepsAfterMerge());

    if (unnorm != 0)
        QMessageBox::critical(this, "Multiplot : unnormalize time vectors.", "Something went wrong in the calculation of the unnormalized time vectors");



    // +++ todo: move this part in core/sources/IO, and try to reuse the 2 generic function data1D and data2D ?

    // We export the unnormalized step time vector
    namefile = exportDirectory + "/discretization_times.export";
    file_out.open(namefile.toStdString().c_str(), ios::out | ios::binary);
    if (!file_out)
        QMessageBox::critical(this,QString("Cannot open file %0").arg(QString("state_times")), QString("Export for this variable fails"));

    for (int i=0; i<bocopSol->dimStepsAfterMerge()+1; i++)
        file_out << pointerSteps[i] << endl;
    file_out.close();


    // We export the unnormalized stage time vector
    namefile = exportDirectory + "/stage_times.export";
    file_out.open(namefile.toStdString().c_str(), ios::out | ios::binary);
    for (int i=0; i<(bocopSol->dimStages()*bocopSol->dimStepsAfterMerge()); i++)
        file_out << pointerStages[i] << endl;
    file_out.close();

    // We export the variables
    // We make a loop on the variables dimension
    for (int i=0; i<bocopSol->dimState(); i++)
    {
        QString name = QString::fromStdString(bocopSol->nameVar(0,i));
        namefile = exportDirectory+ "/" + name + ".export";
        file_out.open(namefile.toStdString().c_str(), ios::out | ios::binary);
        for (int j=0; j<bocopSol->dimStepsAfterMerge()+1; j++)
            file_out << bocopSol->pointerState(i)[j] << endl;
        file_out.close();
    }

    // We export the stage controls
    // We make a loop on the controls dimension
    for (int i=0; i<bocopSol->dimControl(); i++)
    {
        QString name = QString::fromStdString(bocopSol->nameVar(1,i));
        namefile = exportDirectory+ "/stage_" + name + ".export";
        file_out.open(namefile.toStdString().c_str(), ios::out | ios::binary);
        for (int j=0; j<(bocopSol->dimStages()*bocopSol->dimStepsAfterMerge()); j++)
            file_out << bocopSol->pointerControl(i)[j] << endl;
        file_out.close();
    }

    // We export the average controls
    // We make a loop on the controls dimension
    for (int i=0; i<bocopSol->dimControl(); i++)
    {
        QString name = QString::fromStdString(bocopSol->nameVar(1,i));
        namefile = exportDirectory+ "/" + name + ".export";
        file_out.open(namefile.toStdString().c_str(), ios::out | ios::binary);
        for (int j=0; j<(bocopSol->dimStepsAfterMerge()); j++)
            file_out << bocopSol->pointerAverageControl(i)[j] << endl;
        file_out << bocopSol->pointerAverageControl(i)[bocopSol->dimStepsAfterMerge()-1] << endl; // we repeat the last element of the average control
        file_out.close();
    }

    // We export the algebraic variables
    // We make a loop on the algebraic variables dimension
    for (int i=0; i<bocopSol->dimAlgebraic(); i++)
    {
        QString name = QString::fromStdString(bocopSol->nameVar(2,i));
        namefile = exportDirectory+ "/" + name + ".export";
        file_out.open(namefile.toStdString().c_str(), ios::out | ios::binary);
        for (int j=0; j<(bocopSol->dimStages()*bocopSol->dimStepsAfterMerge()); j++)
            file_out << bocopSol->pointerAlgebraic(i)[j] << endl;
        file_out.close();
    }

    // We export the optimization parameters
    // We make a loop on the optimization parameters
    namefile = exportDirectory+ "/parameters.export";
    file_out.open(namefile.toStdString().c_str(), ios::out | ios::binary);
    for (int i=0; i<bocopSol->dimOptimvars(); i++)
        file_out << bocopSol->valOptimVar(i) << endl;
    file_out.close();

    // We export the path constraints
    // We make a loop on the path constraints dimension
    for (int i=0; i<bocopSol->dimPathConstraints(); i++)
    {
        QString name = QString::fromStdString(bocopSol->nameVar(5,i));
        namefile = exportDirectory+ "/" + name + ".export";
        file_out.open(namefile.toStdString().c_str(), ios::out | ios::binary);
        for (int j=0; j<(bocopSol->dimStages()*bocopSol->dimStepsAfterMerge()); j++)
            file_out << bocopSol->pointerPathConstraint(i)[j] << endl;
        file_out.close();
    }

    // We export the path constraints multipliers
    // We make a loop on the path constraints dimension
    for (int i=0; i<bocopSol->dimPathConstraints(); i++)
    {
        QString name = QString::fromStdString(bocopSol->nameVar(5,i));
        namefile = exportDirectory+ "/" + name + "_multipliers.export";
        file_out.open(namefile.toStdString().c_str(), ios::out | ios::binary);
        for (int j=0; j<(bocopSol->dimStages()*bocopSol->dimStepsAfterMerge()); j++)
            file_out << bocopSol->pointerPathConstraint(i)[j] << endl;
        file_out.close();
    }

    // We export the adjoint states
    // We make a loop on the states dimension
    for (int i=0; i<bocopSol->dimState(); i++)
    {
        QString name = QString::fromStdString(bocopSol->nameVar(0,i));
        namefile = exportDirectory+ "/" + name + "_adjoint_state.export";
        file_out.open(namefile.toStdString().c_str(), ios::out | ios::binary);
        for (int j=0; j<bocopSol->dimStepsAfterMerge(); j++)
            file_out << bocopSol->pointerDynamicConstrMultiplier(i)[j] << endl;
        file_out.close();
    }

    QMessageBox::information(this, "Solution successfully exported", QString("The solution was exported in the folder %0.").arg(exportDirectory));
}


/**
  * \fn int MainWindow::unNormTimevectors(double* pointerSteps, double* pointerStages, const int dimSteps, const int dimStages)
  * This function is used to calculate the unnormalized time vectors.
  * If the final time is free it takes as final time the calculated final time, that shoulmd be the first element of the parameters to optimize vector (optimvars)
  */
int MainWindow::unNormTimevectors(double* pointerSteps, double* pointerStages, const int dimSteps, const int dimStages)
{
    double t0, tf;

    t0 = bocopSol->initialTime();

    if (bocopSol->timeFree() == "none")
        tf = bocopSol->finalTime();
    else
        tf = bocopSol->valOptimVar(bocopSol->dimOptimvars()-1);

    // We unnormalize the steps
    for (int i=0; i<dimSteps; i++)
        pointerSteps[i] = t0 + bocopSol->pointerSteps()[i]*(tf-t0);

    // we unnormalize the stages
    for (int i=0; i<dimStages; i++)
        pointerStages[i] = t0 + bocopSol->pointerStages()[i]*(tf-t0);

    return 0;
}


void MainWindow::on_checkBoxShowVariablesBounds_clicked()
{
    QModelIndex index = ui->visu_treeView->currentIndex();
    on_visu_treeView_doubleClicked(index);
}
