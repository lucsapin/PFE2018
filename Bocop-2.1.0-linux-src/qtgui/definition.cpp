// This code is published under the Eclipse Public License
// File: definition.cpp
// Authors: Vincent Grelard, Daphne Giorgi, Pierre Martinon
// INRIA 2011-2015

#include <iostream>
#include <QDebug>
#include "mainwindow.h"
#include "ui_mainwindow.h"

using namespace std;

void MainWindow::on_definition_toolbox_currentChanged(int index)
{
    int status = 0;

    switch (index) {
    case 0:
        status = loadDefinitionDimensions();
        status = loadDiscretizationTimes();
        status = loadDiscretizationMethod();
        break;
    case 1:
        status = loadDefinitionNames();
        break;
    case 2:
        status = loadDefinitionBounds();
        break;
    case 3:
        status = loadDefinitionConstants();
        break;
    default:
        break;
    }

    if (status !=0)
        cout << "Definition tab: menu " << index << " returned error status " << status << endl;
}


/**
  * \fn int MainWindow::LoadDefinitionDimensions(void)
  * This method is called to display the dimensions in the "parameters
  * and dimensions" sub-part. The values are loaded from BocopDefinition.
  * Only the empty fields are given new values, existing entries stay the
  * same.
  */
int MainWindow::loadDefinitionDimensions(void)
{
    QString value_str;

    if (bocopDef == 0)
        return 0;

    // initial time :
    if (ui->initialTimeLineEdit->text().isEmpty()) {
        value_str.setNum(bocopDef->initialTime(),'g',15);
        ui->initialTimeLineEdit->setText(value_str);
    }

    // final time :
    if (ui->finalTimeLineEdit->text().isEmpty()) {
        if (bocopDef->isFinalTimeFree())
            ui->finalTimeLineEdit->setText("free");
        else {
            value_str.setNum(bocopDef->finalTime(),'g',15);
            ui->finalTimeLineEdit->setText(value_str);
        }
    }

    // State dimension :
    if (ui->stateDimensionLineEdit->text().isEmpty()) {
        value_str.setNum(bocopDef->dimState());
        ui->stateDimensionLineEdit->setText(value_str);
    }

    // Control dimension :
    if (ui->controlDimensionLineEdit->text().isEmpty()) {
        value_str.setNum(bocopDef->dimControl());
        ui->controlDimensionLineEdit->setText(value_str);
    }

    // Algebraic dimension :.
    if (ui->algebraicVariablesDimensionLineEdit->text().isEmpty()) {
        value_str.setNum(bocopDef->dimAlgebraic());
        ui->algebraicVariablesDimensionLineEdit->setText(value_str);
    }

    // Optimization parameters dimension :
    if (ui->optimizationParametersDimensionLineEdit->text().isEmpty()) {
        double dim_optimvars = bocopDef->dimOptimVars();
        if (bocopDef->isFinalTimeFree())
            dim_optimvars--;

        value_str.setNum(dim_optimvars);
        ui->optimizationParametersDimensionLineEdit->setText(value_str);
    }

    // Constants dimension :
    if (ui->constantsDimensionLineEdit->text().isEmpty()) {
        value_str.setNum(bocopDef->dimConstants());
        ui->constantsDimensionLineEdit->setText(value_str);
    }

    // Initial and final conditions dimension :
    if (ui->initialFinalConditionsDimensionLineEdit->text().isEmpty()) {
        value_str.setNum(bocopDef->dimInitFinalCond());
        ui->initialFinalConditionsDimensionLineEdit->setText(value_str);
    }

    // Path constraints dimension :
    if (ui->pathConstraintsDimensionLineEdit->text().isEmpty()) {
        value_str.setNum(bocopDef->dimPathConstraints());
        ui->pathConstraintsDimensionLineEdit->setText(value_str);
    }

    // Solution file :
    if (ui->solutionFileLineEdit->text().isEmpty()) {
        value_str = QString::fromStdString(bocopDef->nameSolutionFile());
        ui->solutionFileLineEdit->setText(value_str);
    }

    // Iteration output frequency : ( it is commented )
//    if (ui->iterationOutputFrequencyLineEdit->text().isEmpty()) {
//        value_str.setNum(bocopDef->iterationOutputFrequency());
//        ui->iterationOutputFrequencyLineEdit->setText(value_str);
//    }

    return 0;
}


/**
  * \fn int MainWindow::loadDefinitionNames(void)
  * This method is called to load the names of all variables into
  * the definition toolbox.
  *
  */
int MainWindow::loadDefinitionNames(void)
{
    if (model_names == 0) {
        int stat = initializeDefinitionNames();
        if (stat != 0)
            return stat;
    }

    // We need to check if the dimensions have changed :

    // State :
    QStandardItem* it_state = model_names->item(0,0);
    if (it_state != 0) {
        int new_nb = dimState();

        // adding rows :
        if (it_state->rowCount() < new_nb) {

            for (int i=it_state->rowCount(); i<new_nb; ++i)
                addSubCategoryInNameModel(it_state, i, "state");
        }

        // deleting rows :
        if (it_state->rowCount() > new_nb) {
            for (int i=it_state->rowCount(); i>new_nb; --i)
                it_state->removeRow(i-1);
        }
    }

    // Control :
    QStandardItem* it_control = model_names->item(1,0);
    if (it_control != 0) {
        int new_nb = dimControl();

        // adding rows :
        if (it_control->rowCount() < new_nb) {

            for (int i=it_control->rowCount(); i<new_nb; ++i)
                addSubCategoryInNameModel(it_control, i, "control");
        }

        // deleting rows :
        if (it_control->rowCount() > new_nb) {
            for (int i=it_control->rowCount(); i>new_nb; --i)
                it_control->removeRow(i-1);
        }
    }

    // Algebraic Variables :
    QStandardItem* it_algebr = model_names->item(2,0);
    if (it_algebr != 0) {
        int new_nb = dimAlgebraic();

        // adding rows :
        if (it_algebr->rowCount() < new_nb) {

            for (int i=it_algebr->rowCount(); i<new_nb; ++i)
                addSubCategoryInNameModel(it_algebr, i, "algebraic");
        }

        // deleting rows :
        if (it_algebr->rowCount() > new_nb) {
            for (int i=it_algebr->rowCount(); i>new_nb; --i)
                it_algebr->removeRow(i-1);
        }
    }

    // Optimization Parameters :
    QStandardItem* it_optim = model_names->item(3,0);
    if (it_optim != 0) {
        int new_nb = dimOptimVars();

        // adding rows :
        if (it_optim->rowCount() < new_nb) {

            // If final time is free we check if we are adding final time
            if (ui->finalTimeLineEdit->text() == "free"){

                if (dimOptimVars() == 1)
                    addSubCategoryInNameModel(it_optim, 0, "parameter");
                else{

                    QString lastParameterName = it_optim->child(it_optim->rowCount()-1,1)->data(Qt::EditRole).toString();

                    // If final time has already been added, we add the other parameters before final time
                    if (lastParameterName == m_finalTimeName){
                        for (int i=it_optim->rowCount(); i<new_nb; ++i)
                            addSubCategoryInNameModel(it_optim, i-1, "parameter");
                        addSubCategoryInNameModel(it_optim, new_nb-1, "parameter");
                    }
                    // If we are adding final time, we have to add it at last
                    else{
                        for (int i=it_optim->rowCount(); i<new_nb; ++i)
                            addSubCategoryInNameModel(it_optim, i, "parameter");
                    }
                }
                // We set the name of the final time parameter
                QStandardItem *child_finalTime = new QStandardItem(m_finalTimeName);
                it_optim->setChild(new_nb-1,1, child_finalTime );
            }
            else{
                for (int i=it_optim->rowCount(); i<new_nb; ++i)
                    addSubCategoryInNameModel(it_optim, i, "parameter");
            }
        }

        // deleting rows :
        if (it_optim->rowCount() > new_nb) {
            // If final time is free we don't have to delete the last parameter, which is finaltime
            if (ui->finalTimeLineEdit->text() == "free"){
                for (int i=it_optim->rowCount(); i>new_nb; --i)
                    it_optim->removeRow(i-2);
                // We set the name and the index of the final time parameter
                addSubCategoryInNameModel(it_optim, new_nb-1, "parameter");
                QStandardItem *child_finalTime = new QStandardItem(m_finalTimeName);
                it_optim->setChild(new_nb-1,1, child_finalTime );
            }
            else{
                for (int i=it_optim->rowCount(); i>new_nb; --i)
                    it_optim->removeRow(i-1);
            }
        }
    }

    // Boundary conditions :
    QStandardItem* it_bound = model_names->item(4,0);
    if (it_bound != 0) {
        int new_nb = ui->initialFinalConditionsDimensionLineEdit->text().toInt();

        // adding rows :
        if (it_bound->rowCount() < new_nb) {

            for (int i=it_bound->rowCount(); i<new_nb; ++i)
                addSubCategoryInNameModel(it_bound, i, "boundarycond");
        }

        // deleting rows :
        if (it_bound->rowCount() > new_nb) {
            for (int i=it_bound->rowCount(); i>new_nb; --i)
                it_bound->removeRow(i-1);
        }
    }

    // Path constraints :
    QStandardItem* it_path = model_names->item(5,0);
    if (it_path != 0) {
        int new_nb = ui->pathConstraintsDimensionLineEdit->text().toInt();

        // adding rows :
        if (it_path->rowCount() < new_nb) {

            for (int i=it_path->rowCount(); i<new_nb; ++i)
                addSubCategoryInNameModel(it_path, i, "constraint");
        }

        // deleting rows :
        if (it_path->rowCount() > new_nb) {
            for (int i=it_path->rowCount(); i>new_nb; --i)
                it_path->removeRow(i-1);
        }
    }

    // Constants :
    QStandardItem* it_const = model_names->item(6,0);
    if (it_const != 0) {
        int new_nb = ui->constantsDimensionLineEdit->text().toInt();

        // adding rows :
        if (it_const->rowCount() < new_nb) {

            for (int i=it_const->rowCount(); i<new_nb; ++i)
                addSubCategoryInNameModel(it_const, i, "constant");
        }

        // deleting rows :
        if (it_const->rowCount() > new_nb) {
            for (int i=it_const->rowCount(); i>new_nb; --i)
                it_const->removeRow(i-1);
        }
    }

    // We set the treeview to display the model we've created :
    ui->names_treeview->setModel(model_names);
    ui->names_treeview->resizeColumnToContents(0);

    return 0;
}


/**
  * \fn int MainWindow::addSubCategoryInNameModel(QStandardItem* it, const int i, const QString& name_var)
  * This method allows to add a row in the names model. The row is added as the i-th item of child "it",
  * and has default names...
  */
int MainWindow::addSubCategoryInNameModel(QStandardItem* it, const int i, const QString& name_var)
{
    QString name_left = QString(name_var+" #%0").arg(i);
    QStandardItem *child_var = new QStandardItem(name_left);

    QString name_right = QString(name_var+".%0").arg(i);
    QStandardItem *child_name = new QStandardItem(name_right);

    child_var->setEditable( false );

    it->setChild(i,0, child_var );
    it->setChild(i,1, child_name );

    return 0;
}


/**
  *\fn int MainWindow::addCategoryInNameModel(const int ind, const int dim, const QString& cat_name, const QString& subcat_default, const QStringList& subcat_names)
  * This method adds an item at ind-th row on the names model. The item is a main category of variables
  * together with branches containing the variables names.
  */
int MainWindow::addCategoryInNameModel(const int ind, const int dim, const QString& cat_name, const QString& subcat_default, const QStringList& subcat_names)
{

    // item for the top category :
    QStandardItem *new_item = new QStandardItem(dim,2);
    new_item->setText(cat_name);
    new_item->setEditable(false);

    // we add a branch for each variable in this category :
    for( int i=0; i<dim; i++ )
    {
        QStandardItem *child_var = new QStandardItem(QString("%0 #%1").arg(subcat_default).arg(i));
        QStandardItem *child_name = new QStandardItem(subcat_names.at(i));

        child_var->setEditable( false );

        new_item->setChild(i,0, child_var );
        new_item->setChild(i,1, child_name );
    }

    // we add the newly created item to the names model :
    model_names->setItem(ind, 0, new_item);

    // We add an empty item so that user cannot edit the item
    // right next to the category :
    QStandardItem *empty_item = new QStandardItem();
    empty_item->setEditable(false);
    model_names->setItem(ind, 1, empty_item);

    return 0;
}


/**
  * \fn int MainWindow::newDefinitionNames(void)
  * This method is called to initialize the model for
  * the variables names. It sets this models with the values
  * found in bocopDef.
  */
int MainWindow::initializeDefinitionNames(void)
{
    model_names = new QStandardItemModel(7,2);

    // We first check if final time is free and set the name of final time
    if (bocopDef != 0){
        if (bocopDef->isFinalTimeFree())
            m_finalTimeName = nameOptimVar(bocopDef->dimOptimVars()-1);
        else
            m_finalTimeName = "finalTime";
    }
    else
        m_finalTimeName = "finalTime";


    // State :
    QStringList m_stateNames;
    for (int i=0; i<dimState(); ++i)
        m_stateNames << nameState(i) ;

    addCategoryInNameModel(0, dimState(), "State", "state", m_stateNames);

    // Control :
    QStringList m_controlNames;
    for (int i=0; i<dimControl(); ++i)
        m_controlNames << nameControl(i) ;

    addCategoryInNameModel(1, dimControl(), "Control", "control", m_controlNames);

    // Algebraic :
    QStringList m_algebraicNames;
    for (int i=0; i<dimAlgebraic(); ++i)
        m_algebraicNames << nameAlgebraic(i) ;

    addCategoryInNameModel(2, dimAlgebraic(), "Algebraic Variables", "agebraic", m_algebraicNames);

    // Optimvars :
    QStringList names_optimvar;
    for (int i=0; i<dimOptimVars(); ++i)
        names_optimvar << nameOptimVar(i) ;

    addCategoryInNameModel(3, dimOptimVars(), "Optimization Parameters", "parameter", names_optimvar);

    // Initial and final conditions :
    QStringList names_ifcond;
    for (int i=0; i<dimInitFinalCond(); ++i)
        names_ifcond << nameInitFinalCond(i) ;

    addCategoryInNameModel(4, dimInitFinalCond(), "Boundary Conditions", "boundarycond", names_ifcond);

    // Path constraints :
    QStringList names_path;
    for (int i=0; i<dimPathConstraints(); ++i)
        names_path << namePathConstraint(i) ;

    addCategoryInNameModel(5, dimPathConstraints(), "Path Constraints", "constraint", names_path);

    // Constants :
    QStringList m_constantNames;
    for (int i=0; i<dimConstants(); ++i)
        m_constantNames << nameConstant(i) ;

    addCategoryInNameModel(6, dimConstants(), "Constants", "constant", m_constantNames);

    // Now we set the headers names :
    model_names->setHorizontalHeaderItem( 0, new QStandardItem( "Variables" ) );
    model_names->setHorizontalHeaderItem( 1, new QStandardItem( "Names" ) );

    return 0;
}


/**
  *\fn QString MainWindow::nameState(const int i)
  * Returns the name of the i-th state variable :
  */
QString MainWindow::nameState(const int i)
{
    QString name;

    if (bocopDef != 0)
        name = QString::fromStdString(bocopDef->nameState(i)) ;

    else
        name = QString("state.%0").arg(i);

    return name;
}


/**
  *\fn QString MainWindow::nameControl(const int i)
  * Returns the name of the i-th control variable :
  */
QString MainWindow::nameControl(const int i)
{
    QString name;

    if (bocopDef != 0)
        name = QString::fromStdString(bocopDef->nameControl(i)) ;

    else
        name = QString("control.%0").arg(i);

    return name;
}


/**
  *\fn QString MainWindow::nameAlgebraic(const int i)
  * Returns the name of the i-th algebraic variable :
  */
QString MainWindow::nameAlgebraic(const int i)
{
    QString name;

    if (bocopDef != 0)
        name = QString::fromStdString(bocopDef->nameAlgebraic(i)) ;

    else
        name = QString("algebraic.%0").arg(i);

    return name;
}


/**
  *\fn QString MainWindow::nameOptimVar(const int i)
  * Returns the name of the i-th optimization variable :
  */
QString MainWindow::nameOptimVar(const int i)
{
    QString name;

    if (bocopDef != 0)
        name = QString::fromStdString(bocopDef->nameOptimVar(i)) ;

    else
        name = QString("parameter.%0").arg(i);

    return name;
}


/**
  *\fn QString MainWindow::nameConstant(const int i)
  * Returns the name of the i-th optimization variable :
  */
QString MainWindow::nameConstant(const int i)
{
    QString name;

    if (bocopDef != 0)
        name = QString::fromStdString(bocopDef->nameConstant(i)) ;

    else
        name = QString("constant.%0").arg(i);

    return name;
}


/**
  *\fn QString MainWindow::nameInitFinalCond(const int i)
  * Returns the name of the i-th initial or final condition :
  */
QString MainWindow::nameInitFinalCond(const int i)
{
    QString name;

    if (bocopDef != 0)
        name = QString::fromStdString(bocopDef->nameInitFinalCond(i)) ;

    else
        name = QString("boundarycond.%0").arg(i);

    return name;
}


/**
  *\fn QString MainWindow::namePathConstraint(const int i)
  * Returns the name of the i-th path constraint :
  */
QString MainWindow::namePathConstraint(const int i)
{
    QString name;

    if (bocopDef != 0)
        name = QString::fromStdString(bocopDef->namePathConstraint(i)) ;

    else
        name = QString("constraint.%0").arg(i);

    return name;
}


/**
  * \fn int MainWindow::dimState()
  * This method is a getter for the state dimension. It returns
  * the value in the edit field in part "parameters and dimensions",
  * or a default value if an error occurs
  */
int MainWindow::dimState()
{
    QString dim_field_str = ui->stateDimensionLineEdit->text();

    if (dim_field_str.isEmpty())
        return -1;

    bool ok;
    int dim_field = dim_field_str.toInt(&ok);

    if (!ok) {
        QMessageBox::warning(this, "Warning", "State dimension field value is incorrect. Default value from your definition file will be used...");
        if (bocopDef != 0)
            return bocopDef->dimState();
        else return -1;
    }

    return dim_field;
}


/**
  * \fn int MainWindow::dimControl()
  * This method is a getter for the control dimension. It returns
  * the value in the edit field in part "parameters and dimensions",
  * or a default value if an error occurs
  */
int MainWindow::dimControl()
{
    QString dim_field_str = ui->controlDimensionLineEdit->text();

    if (dim_field_str.isEmpty())
        return -1;

    bool ok;
    int dim_field = dim_field_str.toInt(&ok);

    if (!ok) {
        QMessageBox::warning(this, "Warning", "Control dimension field value is incorrect. Default value from your definition file will be used...");
        if (bocopDef != 0)
            return bocopDef->dimControl();
        else return -1;
    }

    return dim_field;
}


/**
  * \fn int MainWindow::dimAlgebraic()
  * This method is a getter for the algebraic variables dimension. It returns
  * the value in the edit field in part "parameters and dimensions",
  * or a default value if an error occurs
  */
int MainWindow::dimAlgebraic()
{
    QString dim_field_str = ui->algebraicVariablesDimensionLineEdit->text();

    if (dim_field_str.isEmpty())
        return -1;

    bool ok;
    int dim_field = dim_field_str.toInt(&ok);

    if (!ok) {
        QMessageBox::warning(this, "Warning", "Algebraic variables dimension field value is incorrect. Default value from your definition file will be used...");
        if (bocopDef != 0)
            return bocopDef->dimAlgebraic();
        else return -1;
    }

    return dim_field;
}


/**
  * \fn int MainWindow::dimOptimVars()
  * This method is a getter for the optimization parameters dimension. It returns
  * the value in the edit field in part "parameters and dimensions",
  * or a default value if an error occurs
  */
int MainWindow::dimOptimVars()
{
    QString dim_field_str = ui->optimizationParametersDimensionLineEdit->text();

    if (dim_field_str.isEmpty())
        return -1;

    bool ok;
    int dim_field = dim_field_str.toInt(&ok);

    if (!ok) {
        QMessageBox::warning(this, "Warning", "Optimization parameters dimension value is incorrect. Default value from your definition file will be used...");
        if (bocopDef != 0)
            return bocopDef->dimOptimVars();
        else return -1;
    }

    // If the final time is free, there is a hidden optimization variable for the final time :
    if (ui->finalTimeLineEdit->text() == "free")
        dim_field++;

    return dim_field;
}


/**
  * \fn int MainWindow::dimConstants()
  * This method is a getter for the constants dimension. It returns
  * the value in the edit field in part "parameters and dimensions",
  * or a default value if an error occurs
  */
int MainWindow::dimConstants()
{
    QString dim_field_str = ui->constantsDimensionLineEdit->text();

    if (dim_field_str.isEmpty())
        return -1;

    bool ok;
    int dim_field = dim_field_str.toInt(&ok);

    if (!ok) {
        QMessageBox::warning(this, "Warning", "Constants dimension field value is incorrect. Default value from your definition file will be used...");
        if (bocopDef != 0)
            return bocopDef->dimConstants();
        else return -1;
    }

    return dim_field;
}


/**
  * \fn int MainWindow::dimInitFinalCond()
  * This method is a getter for the initial and final conditions dimension. It returns
  * the value in the edit field in part "parameters and dimensions",
  * or a default value if an error occurs
  */
int MainWindow::dimInitFinalCond()
{
    QString dim_field_str = ui->initialFinalConditionsDimensionLineEdit->text();

    if (dim_field_str.isEmpty())
        return -1;

    bool ok;
    int dim_field = dim_field_str.toInt(&ok);

    if (!ok) {
        QMessageBox::warning(this, "Warning", "Boundary conditions dimension field value is incorrect. Default value from your definition file will be used...");
        if (bocopDef != 0)
            return bocopDef->dimInitFinalCond();
        else return -1;
    }

    return dim_field;
}


/**
  * \fn int MainWindow::dimInitFinalCond()
  * This method is a getter for the initial and final conditions dimension. It returns
  * the value in the edit field in part "parameters and dimensions",
  * or a default value if an error occurs
  */
int MainWindow::dimPathConstraints()
{
    QString dim_field_str = ui->pathConstraintsDimensionLineEdit->text();

    if (dim_field_str.isEmpty())
        return -1;

    bool ok;
    int dim_field = dim_field_str.toInt(&ok);

    if (!ok) {
        QMessageBox::warning(this, "Warning", "Path constraints dimension field value is incorrect. Default value from your definition file will be used...");
        if (bocopDef != 0)
            return bocopDef->dimPathConstraints();
        else return -1;
    }

    return dim_field;
}


/**
  * \fn int MainWindow::loadDefinitionBounds(void)
  * This method is called to load and display the bounds on the variables and constraints.
  * They are loaded from bocopDef. The names to display are taken from the edit fields
  * in the names part.
  */
int MainWindow::loadDefinitionBounds(void)
{
    // We refresh the names list, as we need it to set the name
    // of each variable of constraint in the bounds treeview
    int stat = loadDefinitionNames();
    if (stat != 0)
        return 2;

    // If the bounds model is empty, we initialize it :
    if (model_bounds == 0) {
        int stat = initializeDefinitionBounds();
        if (stat != 0)
            return stat;

        // Items behaviour is handled by a slot :
        QObject::connect(model_bounds, SIGNAL(itemChanged(QStandardItem*)),this, SLOT(handleBoundsCheckboxes(QStandardItem*)));
    }

    QList<int> dims;
    dims << dimState() << dimControl() << dimAlgebraic() << dimOptimVars();
    dims << dimInitFinalCond() << dimPathConstraints();

    QStringList default_names;
    default_names << "state" << "control" << "algebraic" << "parameter" << "boundarycond" << "pathcond";


    // We update the names in the bounds treeview, looking for
    // new values in names treeview :
    updateNamesInBoundsTreeView();

    // Now we check if the dimensions have changed, in order to resize the model :
    for (int i=0; i<6; ++i) {

        if (i>model_bounds->rowCount())
            break;

        // We get the category in mode_bounds :
        QStandardItem* it_bound = model_bounds->item(i,0);
        it_bound->setEditable(false);

        if (it_bound != 0) {
            // adding subcategory rows :
            if (it_bound->rowCount() < dims.at(i)) {

                for (int j=it_bound->rowCount(); j<dims.at(i); ++j) {
                    QString name_item = nameInTreeView(i,j,default_names.at(i));
                    addRowDefinitionBounds(it_bound, j, name_item);
                }
            }

            // deleting subcategory rows :
            if (it_bound->rowCount() > dims.at(i)) {
                for (int j=it_bound->rowCount(); j>dims.at(i); --j)
                    it_bound->removeRow(j-1);
            }
        }
    }

    // Finally we pass the model to the treeview :
    model_bounds->setHorizontalHeaderItem( 0, new QStandardItem( "" ) );
    model_bounds->setHorizontalHeaderItem( 1, new QStandardItem( "Equality" ) );
    model_bounds->setHorizontalHeaderItem( 2, new QStandardItem( "Lower Bound" ) );
    model_bounds->setHorizontalHeaderItem( 3, new QStandardItem( "Upper Bound" ) );

    ui->bounds_treeView->setModel(model_bounds);
    ui->bounds_treeView->resizeColumnToContents(0);
    ui->bounds_treeView->resizeColumnToContents(1);
    ui->bounds_treeView->resizeColumnToContents(2);
    ui->bounds_treeView->resizeColumnToContents(3);

    // The edition of the item text starts as soon as a key is pressed :
    ui->bounds_treeView->setEditTriggers(QAbstractItemView::AnyKeyPressed | QAbstractItemView::DoubleClicked);

    return 0;
}


/**
  *\fn int MainWindow::updateNamesInBoundsTreeView(void)
  * This method gets the names in the names model, and set them
  * in the bounds model. If users change a name in the name model,
  * the new value will appear in the bounds model.
  */
int MainWindow::updateNamesInBoundsTreeView(void)
{
    // Default names if a problem occurs while reading names model :
    QStringList default_names;
    default_names << "state" << "control" << "algebraic";
    default_names<< "optimvar" << "boundarycond" << "pathcond";

    // We go through all the bounds model to update the values :
    for (int cat=0; (cat<model_bounds->rowCount() && cat<model_names->rowCount()); ++cat) {
        QStandardItem * category = model_bounds->item(cat,0);

        for (int subcat=0; subcat<category->rowCount(); ++subcat) {
            QStandardItem * subcategory = category->child(subcat,0);
            QString name_sub = nameInTreeView(cat, subcat, default_names.at(cat));
            subcategory->setText(name_sub);
        }
    }

    return 0;
}


/**
  *\fn int MainWindow::initializeDefinitionBounds()
  * This method initializes the bounds model values. It reads current problem
  * .bounds file, and sets the values that will later be displayed in the
  * treeview.
  */
int MainWindow::initializeDefinitionBounds()
{
    model_bounds = new QStandardItemModel(6,4);

    QStringList default_names;
    default_names << "state" << "control" << "algebraic" << "optimvar";
    default_names << "constant" << "boundarycond"<< "pathcond";

    // We set a new list with the increasing sum of the dimensions :
    QList<int> add_dim;
    add_dim << 0 << dimState() << dimState()+dimControl() << dimState()+dimControl()+dimAlgebraic();
    add_dim << dimState()+dimControl()+dimAlgebraic()+dimOptimVars();


    // We get the names, we go through all the categories in the names model :
    for (int i=0; i<6; ++i) {

        if (i>model_names->rowCount())
            break;

        // We get the category in model_names :
        QStandardItem* it = model_names->item(i,0);
        if (it != 0) {

            if (it->text() != "Constants") {

                // We create a new item for the category, with the text from model_names,
                // but which will be used by model_bounds :
                QStandardItem *category = new QStandardItem(it->text());
                category->setEditable(false);

                model_bounds->setItem(i,category);

                // We get the children in model_names :
                for (int j=0;j<it->rowCount();++j) {

                    // Subcategory (j-th child) :
                    QString name_sub = nameInTreeView(i, j, default_names.at(i));

                    QStandardItem *subcategory = new QStandardItem(name_sub);
                    subcategory->setEditable(false);

                    string type = "";
                    double lower, upper;

                    // We get the bounds information for this subcategory :
                    if (bocopDef == 0) {
                        lower = 0; upper = 0; type = "free"; // default type is "free"
                    }
                    else {
                        // - type of bound
                        int stat1=-1, stat2=-1, stat3=-1;

                        if (i<4) { // Variables
                            stat1 = bocopDef->typeBoundVariable(add_dim.at(i) + j, type);
                            stat2 = bocopDef->lowerBoundVariable(add_dim.at(i)+j, lower);
                            stat3 = bocopDef->upperBoundVariable(add_dim.at(i)+j, upper);
                        }
                        else if (i == 4) { // Initial and final conditions
                            stat1 = bocopDef->typeBoundInitFinalCond(j, type);
                            stat2 = bocopDef->lowerBoundInitFinalCond(j, lower);
                            stat3 = bocopDef->upperBoundInitFinalCond(j, upper);
                        }
                        else if (i == 5) { // Path constraints
                            stat1 = bocopDef->typeBoundPathConstraint(j, type);
                            stat2 = bocopDef->lowerBoundPathConstraint(j, lower);
                            stat3 = bocopDef->upperBoundPathConstraint(j, upper);
                        }

                        if (stat1 != 0 || stat2 != 0 || stat3 != 0) {
                            qDebug() << "MainWindow::initializeDefinitionBounds() : error";
                        }
                    }

                    QStandardItem *equal_item = new QStandardItem();
                    QStandardItem *lower_item = new QStandardItem();
                    QStandardItem *upper_item = new QStandardItem();
                    initializeBoundFields(equal_item, lower_item, upper_item, type, lower, upper);

                    // we add this item to the current category :
                    category->setChild(j,0,subcategory);
                    category->setChild(j,1,equal_item);
                    category->setChild(j,2,lower_item);
                    category->setChild(j,3,upper_item);

                } //endfor (j, subcategory)

            } // endif (not constants)

        } // endif (category exists)

    } // endfor (i, category)

    return 0;
}


int MainWindow::initializeBoundFields(QStandardItem* equ, QStandardItem* low, QStandardItem* upp, const string type, const double low_val, const double upp_val)
{
    QString equ_val_str;
    QString low_val_str;
    QString upp_val_str;

    equ->setCheckable(true);
    low->setCheckable(true);
    upp->setCheckable(true);

    if (type == "free" || type == "0")
    {
        equ->setCheckState(Qt::Unchecked);
        equ->setText("");
        low->setCheckState(Qt::Unchecked);
        low->setText("");
        upp->setCheckState(Qt::Unchecked);
        upp->setText("");
    }
    else if (type == "lower" || type == "1")
    {
        equ->setCheckState(Qt::Unchecked);
        equ->setText("");

        low->setCheckState(Qt::Checked);
        low_val_str.setNum(low_val,'g',15);
        low->setText(low_val_str);

        upp->setCheckState(Qt::Unchecked);
        upp->setText("");
    }
    else if (type == "upper" || type == "2")
    {
        equ->setCheckState(Qt::Unchecked);
        equ->setText("");

        low->setCheckState(Qt::Unchecked);
        low->setText("");

        upp->setCheckState(Qt::Checked);
        upp_val_str.setNum(upp_val,'g',15);
        upp->setText(upp_val_str);
    }
    else if (type == "both" || type == "3")
    {
        equ->setCheckState(Qt::Unchecked);
        equ->setText("");

        low->setCheckState(Qt::Checked);
        low_val_str.setNum(low_val,'g',15);
        low->setText(low_val_str);

        upp->setCheckState(Qt::Checked);
        upp_val_str.setNum(upp_val,'g',15);
        upp->setText(upp_val_str);
    }
    else if (type == "equal" || type == "4")
    {
        equ->setCheckState(Qt::Checked);
        equ_val_str.setNum(low_val,'g',15);
        equ->setText(equ_val_str);

        low->setCheckState(Qt::Unchecked);
        low->setText("");
        upp->setCheckState(Qt::Unchecked);
        upp->setText("");
    }
    else
    {
        equ->setCheckState(Qt::Unchecked);
        equ->setText("");
        low->setCheckState(Qt::Unchecked);
        low->setText("");
        upp->setCheckState(Qt::Unchecked);
        upp->setText("");
    }

    return 0;
}


/**
  * \fn int MainWindow::addRowDefinitionBounds(QStandardItem* it, const int i, const QString& name_var)
  * This method allows to add a row in the bounds model. The row is added as the i-th item of child "it",
  * and has default name...
  */
int MainWindow::addRowDefinitionBounds(QStandardItem* it, const int i, const QString& name_var)
{
    // First column : name of the variable or constraint
    QStandardItem *child_name = new QStandardItem(name_var);
    child_name->setEditable( false );

    // We set the bounds to be free (default)
    // Second column : equality?
    QStandardItem *child_equal = new QStandardItem();
    child_equal->setCheckable(true);
    child_equal->setCheckState(Qt::Unchecked);
    child_equal->setText("");

    // Third column : lower bound
    QStandardItem *child_lower = new QStandardItem();
    child_lower->setCheckable(true);
    child_lower->setCheckState(Qt::Unchecked);
    child_lower->setText("");

    // Fourth column : upper bound
    QStandardItem *child_upper = new QStandardItem();
    child_upper->setCheckable(true);
    child_upper->setCheckState(Qt::Unchecked);
    child_upper->setText("");

    // Now we set the newly created child to the current node :
    it->setChild(i,0, child_name );
    it->setChild(i,1, child_equal );
    it->setChild(i,2, child_lower );
    it->setChild(i,3, child_upper );

    return 0;
}


/**
  * \fn void MainWindow::handleBoundsCheckboxes(QStandardItem*)
  * This method sets the properties in the bounds treeview,
  * in order to prevent the user from selecting non-compatible
  * checkboxes, or entering text where it's useless, or forbidden.
  */
void MainWindow::handleBoundsCheckboxes(QStandardItem* it)
{
    model_bounds->blockSignals(true);

    int col = it->column();

    // if the user edited the item, we might need to resize the column
    // to fit the new content :
    ui->bounds_treeView->resizeColumnToContents(col);

    // We handle only the columns related with the bounds definition
    if (col < 1 || col > 3){
        model_bounds->blockSignals(false);
        return;
    }

    if (it->checkState() == Qt::Checked) {
        // the value can be edited by the user, the default value is 0
        it->setEditable(true);
        if (it->text() == "")
            it->setText("0");

        if (col == 1) { // Equality constraint
            // lower bound is disabled :
            QStandardItem* sibling_low = it->parent()->child(it->row(),2);
            sibling_low->setCheckState(Qt::Unchecked);
            sibling_low->setText("");
            sibling_low->setEditable(false);

            // upper bound is disabled :
            QStandardItem* sibling_upp = it->parent()->child(it->row(),3);
            sibling_upp->setCheckState(Qt::Unchecked);
            sibling_upp->setText("");
            sibling_upp->setEditable(false);
        }
        else  { // Lower bound or upper bound
            // equality constraint is disabled :
            QStandardItem* sibling_equ = it->parent()->child(it->row(),1);
            sibling_equ->setCheckState(Qt::Unchecked);
            sibling_equ->setText("");
            sibling_equ->setEditable(false);
        }
    }
    else {
        // if the box is unchecked it can't be edited
        it->setEditable(false);
        it->setText("");
    }

    model_bounds->blockSignals(false);

    return;
}


/**
  *\fn void MainWindow::resizeBoundsTreeview(QModelIndex item)
  * This slot is called to resize bounds treeview to its contents.
  * This is useful when displaying new items in the tree, so that
  * all content stays visible.
  */
void MainWindow::resizeBoundsTreeview()
{
    // We resize the tree to its contents :
    ui->bounds_treeView->resizeColumnToContents(0);
    ui->bounds_treeView->resizeColumnToContents(1);
    ui->bounds_treeView->resizeColumnToContents(2);
    ui->bounds_treeView->resizeColumnToContents(3);
}


/**
  * \fn QString MainWindow::nameInTreeView(const int cat, const int subcat, const QString default_name)
  * This function returns the name found in model_names at index "sub" and subindex "subcat".
  * If there is no name at this entry, a default name is returned.
  */
QString MainWindow::nameInTreeView(const int cat, const int subcat, const QString default_name)
{
    // Default name of the subcategory :
    QString name_sub = QString(default_name+" #%0").arg(subcat);

    if (cat>=model_names->rowCount())
        return name_sub;

    // We get the category in model_names :
    QStandardItem* it = model_names->item(cat,0);
    if (it != 0) {

        // Subcategory (j-th child) :
        QStandardItem* it_child = it->child(subcat,1);

        if (it_child != 0) {
            // we get the text of the line :
            name_sub = it_child->data(Qt::EditRole).toString();
        }
    }

    return name_sub;
}



/**
  *\fn void MainWindow::on_constantsDimensionLineEdit_editingFinished()
  * This slot is called when user has finished editing the constants
  * dimension field. It loads the model for the constants according to
  * the new dimension...
  */
void MainWindow::on_constantsDimensionLineEdit_editingFinished()
{
    // If there are dimensions that are still not defined, we leave :
    if (dimState()<0 || dimControl()<0 || dimAlgebraic()<0 || dimOptimVars()<0
            || dimConstants()<0 || dimInitFinalCond()<0 || dimPathConstraints()<0) {
        return;
    }

    loadDefinitionConstants();
}


/**
  *\fn int MainWindow::loadDefinitionConstants(void)
  * This method is called to load the constants model, which
  * gives the names and values of the constants. The model
  * is then set in the table view.
  */
int MainWindow::loadDefinitionConstants(void)
{
    // First we get the number of constants to display.
    // we check the value in the edit line, if it's empty
    // we take it from bocopDef.
    int nb_to_display = dimConstants();

    if (model_constants == 0) {
        model_constants = new QStandardItemModel();

        // Every time a model_constants item content is changed, we
        // resize the table view it populates :
        connect(model_constants,SIGNAL(itemChanged(QStandardItem*)),ui->constants_tableView, SLOT(resizeColumnsToContents()));
    }

    // We refresh the names list, as we need it to set the name
    // of each variable of constraint in the constants view
    int stat = loadDefinitionNames();
    if (stat != 0)
        return 2;


    // We get the values of the constants :
    QList<double> constants_val;
    QStringList constants_num;

    for (int i=0; i<dimConstants(); ++i) {

        if  (bocopDef == 0)
            constants_val << 0.0;

        else {
            int stat = 1;
            double val;

            stat = bocopDef->valConstant(i, val);
            if (stat != 0)
                val = 0.0;

            constants_val << val;
        }
        constants_num << QString::number(i);
    }

    int nb_displayed = model_constants->rowCount();

    // If there are less displayed rows than needed :
    // We create the children :
    for (int j=nb_displayed;j<nb_to_display;++j) {

        // category (j-th child) :
        QString name_cat = nameInTreeView(6, j, "constant");
        QStandardItem *name_it = new QStandardItem(name_cat);
        name_it->setEditable(false);

        model_constants->setItem(j,0, name_it);

        // value of the constant :
        QString val_str;
        val_str.setNum(constants_val.at(j),'g',15);

        QStandardItem *value_it = new QStandardItem(val_str);
        model_constants->setItem(j,1, value_it);

    }

    // If there are more displayed items than needed, we remove
    // the last rows :
    for (int j=nb_displayed;j>nb_to_display;--j) {
        model_constants->removeRow(j-1);
    }

    // If the above loops were not entered, the names might not be up
    // to date with those in model_names. We update the names :
    updateNamesInConstantsListView();

    // Finally we pass the model to the tableview :
    model_constants->setHorizontalHeaderItem( 0, new QStandardItem( "Name" ) );
    model_constants->setHorizontalHeaderItem( 1, new QStandardItem( "Value" ) );
    model_constants->setVerticalHeaderLabels(constants_num);

    ui->constants_tableView->setModel(model_constants);
    ui->constants_tableView->resizeColumnToContents(0); // names
    ui->constants_tableView->resizeColumnToContents(1); // values

    return 0;
}


/**
  *\fn int MainWindow::updateNamesInConstantsListView(void)
  * This method gets the names in the names model, and set them
  * in the constants model. If users change a name in the name model,
  * the new value will appear in the constants model.
  */
int MainWindow::updateNamesInConstantsListView()
{
    // We go through all the constants model to update the values :
    for (int cat=0; cat<model_constants->rowCount(); ++cat) {
        QStandardItem * category = model_constants->item(cat,0);

        QString name_cat = nameInTreeView(6, cat, "constant");
        category->setText(name_cat);
    }

    return 0;
}
