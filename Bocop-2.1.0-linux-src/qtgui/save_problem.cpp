// This code is published under the Eclipse Public License
// File: save_problem.cpp
// Authors: Vincent Grelard, Daphne Giorgi, Pierre Martinon, Virgile Andreani
// Inria Saclay and CMAP Ecole Polytechnique
// 2011-2017

#include <iostream>
#include "mainwindow.h"
#include "ui_mainwindow.h"

#ifdef _WINDOWS
#include <windows.h>
#else
#include <unistd.h>
#define Sleep(x) usleep((x)*1000)
#endif

using namespace std;


/**
  *\fn int MainWindow::saveProblem(void)
  * This function collects all the data from definition areas of the main window to get all modified values,
  * and save them in bocop definition files (.def, .bounds, .constants, ipopt.opt)
  */
int MainWindow::saveProblem(void)
{
    bool save = true;

    // Force dimension change (slot userChangedDimension() isn't triggered yet if we just changed dimension)
    userChangedDimension();

    // Force on starting point tab (slot on_constantInitLineEdit_editingFinished isn't triggered when we click 'Save')
    if (ui->MainTabs->currentIndex() == 3)
        saveTempCanvas();

    if (save == true){
        // We create a new instance of BocopSaveDefinition
        // to store the new options and parameters :
        if (bocopSave != 0)
            delete bocopSave;

        bocopSave = new BocopSaveDefinition();

        QString problem_path = problem_dir.absolutePath() + QDir::separator();
        bocopSave->setProblemPath(problem_path.toStdString());

        // If a table view is currently being edited, we close
        // the editor. If we don't, the new value will not be saved.
        foreach(QTableView *widget, this->findChildren<QTableView*>()) {
            widget->setDisabled(true);
            widget->setDisabled(false);
        }
        // Same thing for the treeviews :
        foreach(QTreeView *widget, this->findChildren<QTreeView*>()) {
            widget->setDisabled(true);
            widget->setDisabled(false);
        }


        // Then we go through all the tabs to save data :
        int status;
        status = saveDimensions();
        if (status != 0) {
            QMessageBox::critical(this, "Error while saving dimensions",
                                  "An error occurred while saving current problem's dimensions."
                                  " Please check that the definition is correct (variables dimensions, format).");
            return 1;
        }

        status = saveBounds();
        if (status != 0) {
            QMessageBox::critical(this, "Error while saving bounds",
                                  "An error occurred while saving current problem's bounds."
                                  " Please check that the definition is correct.");
            return 4;
        }

        status = saveConstants();
        if (status != 0) {
            QMessageBox::critical(this, "Error while saving constants",
                                  "An error occurred while saving current problem's constants."
                                  " Please check that the definition is correct.");
            return 5;
        }

        status = saveIpoptOptions();
        if (status != 0) {
            QMessageBox::critical(this, "Error while writing ipopt.opt",
                                  "An error occurred while writing ipopt options."
                                  " Please check that the options are correct.");
            return 6;
        }

        status = saveBatchOptions();
        if (status != 0) {
            QMessageBox::critical(this, "Error while saving batch options",
                                  "An error occurred while saving batch optimization options."
                                  " Please check that the options are correct.");
            return 7;
        }

        status = saveReOptimOptions();
        if (status != 0) {
            QMessageBox::critical(this, "Error while saving reoptimization options",
                                  "An error occurred while saving starting point generation options."
                                  " Please check that the options are correct.");
            return 8;
        }

        status = saveParamId();
        if (status != 0) {
            QMessageBox::critical(this, "Error while saving parameter identification options",
                                  " Please check that the options are correct.");
            return 12;
        }

        status = saveNames();
        if (status != 0) {
            QMessageBox::critical(this, "Error while saving names",
                                  "An error occurred while saving current problem's variables names."
                                  " Please check that the definition is correct.");
            return 2;
        }

        status = saveSolution();
        if (status != 0) {
            QMessageBox::critical(this, "Error while saving solution file name",
                                  "An error occurred while saving current problem's solution file name."
                                  " Please check that the file is correct.");
            return 2;
        }

        // Once all the values are saved in bocopSave, we can write the files :
        status = bocopSave->writeFiles();
        if (status != 0) {
            QMessageBox::critical(this, "Error while writing files",
                                  "An error occurred while writing the current problem definition files. Please check that the definition is correct (variables dimensions, format).\n The following error was thrown : "
                                  +QString::fromStdString(bocopSave->errorString()));
            return 9;
        }

        status = saveInitialization();
        if (status != 0) {
            QMessageBox::critical(this, "Error while writing init files",
                                  "An error occurred while writing initialization files."
                                  " Please check that the initialization is correct.");
            return 10;
        }

        setCursorBottom();
    }

    Sleep(1000);


    bocopDef = new BocopDefinition(bocopDef->nameDefFile(),
                                   bocopDef->nameBoundsFile(),
                                   bocopDef->nameConstantsFile());
//                                   bocopDef->nameTimesFile(),
//                                   problem_dir.absolutePath().toStdString());
/*
    // Path to .disc files :
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
        QMessageBox::critical(this, "Error after save",
                              QString("An error occurred while instanciating a new element of Bocop Definition, after having saved the new problem.\n%0").arg(QString::fromStdString(bocopDef->errorString())));
        return 10;
    }

    return 0;
}


/**
  *\fn int MainWindow::saveDimensions(void)
  * This method goes through the first box of the definition
  * tab (dimensions and parameters), to get the values
  */
int MainWindow::saveDimensions(void)
{
    bool ok;
    QString value_str;
    int value_int;

    // First we load the dimensions (only if it has not yet been done) :
    loadDefinitionDimensions();

    // We read all the edit fields in the first box of the
    // definition tab :

    // initial time :
    value_str = ui->initialTimeLineEdit->text();
    double initial_time = value_str.toDouble(&ok);
    if (!ok) {
        QMessageBox::critical(this, "Conversion error", "Initial time field value is incorrect (positive double expected)...");
        return 1;
    }

    // final time :
    double final_time;
    value_str = ui->finalTimeLineEdit->text();
    if (value_str == "free") {
        //        initial_time = 0.0;
        //        final_time = 1.0;
        final_time = initial_time + 1.0;

        bocopSave->addDefinitionEntry("time.free","string","final");
    }
    else {
        bocopSave->addDefinitionEntry("time.free","string","none");

        final_time = value_str.toDouble(&ok);
        if (!ok) {
            QMessageBox::critical(this, "Conversion error", "Final time field value is incorrect (positive double expected)...");
            return 2;
        }
    }

    // We check that the initial and final time are valid
    if (initial_time >= final_time) {
        QMessageBox::critical(this, "Invalid times", "Initial time should be lesser than final time...");
        return 3;
    }
    if (initial_time < 0.0) {
        QMessageBox::critical(this, "Invalid initial time", "Initial time should be greater or equal to zero...");
        return 3;
    }
    if (final_time <= 0.0) {
        QMessageBox::critical(this, "Invalid final time", "Final time should be greater than zero...");
        return 3;
    }

    // We save the times in bocopSave :
    bocopSave->setInitialTime(initial_time);
    bocopSave->setFinalTime(final_time);

    bocopSave->addDefinitionEntry("time.initial","double",QString::number(initial_time,'g',15).toStdString());
    bocopSave->addDefinitionEntry("time.final","double",QString::number(final_time,'g',15).toStdString());


    // state dimension :
    value_str = ui->stateDimensionLineEdit->text();
    value_int = value_str.toInt(&ok);
    if (!ok || value_int < 0) {
        QMessageBox::critical(this, "Conversion error", "State dimension field value is incorrect (positive int expected) or you didn't enter any dimension.");
        return 4;
    }
    bocopSave->setDimState(value_int);
    bocopSave->addDefinitionEntry("state.dimension","integer",value_str.toStdString());

    // control dimension :
    value_str = ui->controlDimensionLineEdit->text();
    value_int = value_str.toInt(&ok);
    if (!ok || value_int < 0) {
        QMessageBox::critical(this, "Conversion error", "Control dimension field value is incorrect (positive int expected) or you didn't enter any dimension.");
        return 5;
    }
    bocopSave->setDimControl(value_int);
    bocopSave->addDefinitionEntry("control.dimension","integer",value_str.toStdString());

    // algebraic dimension :
    value_str = ui->algebraicVariablesDimensionLineEdit->text();
    value_int = value_str.toInt(&ok);
    if (!ok || value_int < 0) {
        QMessageBox::critical(this, "Conversion error", "Algebraic variables dimension field value is incorrect (positive int expected) or you didn't enter any dimension.");
        return 6;
    }
    bocopSave->setDimAlgebraic(value_int);
    bocopSave->addDefinitionEntry("algebraic.dimension","integer",value_str.toStdString());

    // optimvars dimension :
    value_str = ui->optimizationParametersDimensionLineEdit->text();
    value_int = value_str.toInt(&ok);
    if (!ok || value_int < 0) {
        QMessageBox::critical(this, "Conversion error", "optimization parameters dimension field value is incorrect (positive int expected)...");
        return 7;
    }

    // if the final time is free, there's an optimization variable to add (final time) :
    if (ui->finalTimeLineEdit->text() == "free")
        value_int++;

    // we refresh value_str with the new value :
    value_str.setNum(value_int);

    bocopSave->setDimOptimVars(value_int);
    bocopSave->addDefinitionEntry("parameter.dimension","integer",value_str.toStdString());

    // constants dimension :
    value_str = ui->constantsDimensionLineEdit->text();
    value_int = value_str.toInt(&ok);
    if (!ok || value_int < 0) {
        QMessageBox::critical(this, "Conversion error", "Constants dimension field value is incorrect (positive int expected)...");
        return 8;
    }
    bocopSave->setDimConstants(value_int);
    bocopSave->addDefinitionEntry("constant.dimension","integer",value_str.toStdString());


    // initial and final conditions dimension :
    value_str = ui->initialFinalConditionsDimensionLineEdit->text();
    value_int = value_str.toInt(&ok);
    if (!ok || value_int < 0) {
        QMessageBox::critical(this, "Conversion error", "Initial and final conditions dimension field value is incorrect (positive int expected)...");
        return 8;
    }
    bocopSave->setDimInitFinalCond(value_int);
    bocopSave->addDefinitionEntry("boundarycond.dimension","integer",value_str.toStdString());

    // path constraints dimension :
    value_str = ui->pathConstraintsDimensionLineEdit->text();
    value_int = value_str.toInt(&ok);
    if (!ok || value_int < 0) {
        QMessageBox::critical(this, "Conversion error", "Path constraints dimension field value is incorrect (positive int expected)...");
        return 8;
    }
    bocopSave->setDimPathCond(value_int);
    bocopSave->addDefinitionEntry("constraint.dimension","integer",value_str.toStdString());

    // number of time steps :
    loadDiscretizationTimes();

    value_str = ui->timesteps_edit->text();
    value_int = value_str.toInt(&ok);
    if (!ok || value_int < 0) {
        QMessageBox::critical(this, "Conversion error", "Number of time steps field value is incorrect (positive int expected)...");
        return 9;
    }
    bocopSave->setDimSteps(value_int);
    bocopSave->addDefinitionEntry("discretization.steps","integer",value_str.toStdString());


    // discretization method :
    // the name of the file is stored in the current index data of the
    // discretization method combobox.
    loadDiscretizationMethod();

    QString filename_qstr;
    filename_qstr.clear(); // the string is set empty

    int index = ui->discretizationmethod_combo->currentIndex();
    if (index != -1) {

        QVariant filename = ui->discretizationmethod_combo->itemData(index);
        if (filename != QVariant::Invalid)
            filename_qstr = filename.toString();

    }

    // We check that the process went well, the string should not be empty anymore :
    if (filename_qstr.isEmpty()) {
        QMessageBox::critical(this, "Wrong discretization method", "Cannot get the discretization method. Combo-box data is invalid. Please select a valid discretization method...");
        return 10;
    }

    bocopSave->addDefinitionEntry("discretization.method","string",filename_qstr.toStdString());

    return 0;
}


/**
  *\fn int MainWindow::saveNames(void)
  * This method is used to save the names defined by users in the 2nd box of
  * the definition tab. The names are stored in model_names, we need to store them
  * in a standard format to be able to write them in .def file.
  */
int MainWindow::saveNames(void)
{

    // If the user never opened the names box, model_names is
    // not defined, we don't save names :
    if (model_names == 0) {
        return 0;
    }

    QStringList default_names;
    default_names << "state" << "control" << "algebraic" << "parameter" << "boundarycond" << "constraint" << "constant" ;

    QString default_name;
    QString name;

    // we go through all the categories (types of variable) in the names model :
    for (int cat=0; cat<7; ++cat) {

        QStandardItem* it = model_names->item(cat,0);

        // we go through all the subcategories (variables) :
        for (int subcat=0; subcat<it->rowCount(); ++subcat) {

            // default name for the current subcategory (<category name>.<index of the subcategory>)
            default_name = QString("%0.%1").arg(default_names.at(cat)).arg(subcat);
            name = default_name;

            // Subcategory (j-th child) :
            QStandardItem* it_child = it->child(subcat,1);

            if (it_child != 0) {
                // we get the text of the line :
                name = it_child->data(Qt::EditRole).toString();
            }

            // If the current name is not the default value, we write it in the definition file
            // else we write the default name :
            if (name != default_name && !name.isEmpty())
                bocopSave->addDefinitionEntry(default_name.toStdString(),"string",name.toStdString());
            else
                bocopSave->addDefinitionEntry(default_name.toStdString(),"string",default_name.toStdString());
        }
    }
    return 0;
}


/**
  *\fn int MainWindow::saveSolution(void)
  * This method is used to save the name of the solution file and iteration output frequency
  */
int MainWindow::saveSolution(void)
{
    // Solution file name
    if (ui->solutionFileLineEdit->text().toStdString()!="")
        bocopSave->addDefinitionEntry("solution.file","string",ui->solutionFileLineEdit->text().toStdString());
    else
        bocopSave->addDefinitionEntry("solution.file","string","problem.sol");

    // Iteration output frequency (do not exist in GUI any more)
//    if (ui->iterationOutputFrequencyLineEdit->text().toStdString()!="")
//        bocopSave->addDefinitionEntry("iteration.output.frequency","integer",ui->iterationOutputFrequencyLineEdit->text().toStdString());
//    else
        bocopSave->addDefinitionEntry("iteration.output.frequency","integer","0");

    return 0;
}



/**
  *\fn int MainWindow::copyDefaultBocopFile(QFileInfo& file, const QString& description_name)
  * This method copies a default file from directory <root_dir>/examples/default.
  * It can be used when "file" does not exist, to create it, with default values.
  */
int MainWindow::copyBocopDefaultFile(QFileInfo& file, const QString& description_name)
{
    QDir default_problem_dir = root_dir;
    bool ok = default_problem_dir.cd("examples"+QString(QDir::separator())+"default");
    if (!ok) {
        QMessageBox::critical(this, "Invalid path", QString("An error occurred trying to copy %0 default file. Cannot reach <bocop_root_dir>/examples/default.").arg(description_name));
        return 2;
    }

    QString name_default_file = default_problem_dir.absolutePath() + QString(QDir::separator()) + file.fileName();
    QFile default_file(name_default_file);

    if (!default_file.exists()) {
        QMessageBox::critical(this, "Invalid file", QString("An error occurred trying to copy %0 default file. File %1 does not seem to exist.").arg(description_name).arg(name_default_file));
        return 3;
    }

    ok = default_file.copy(file.absoluteFilePath());
    if (!ok) {
        QMessageBox::critical(this, "Copy failed", QString("Cannot copy %0 default file in your problem directory.").arg(description_name));
        return 4;
    }

    // we refresh the fileinfo, to check if it is readable :
    file.setFile(file.absoluteFilePath());
    if (!file.isReadable()){
        QMessageBox::critical(this, "File not readable", QString("After copying %0 default file in your problem directory, the file is still not readable.").arg(description_name));
        return 5;
    }

    return 0;
}



/**
  *\fn int MainWindow::saveBounds(void)
  * This method collects the values of the bounds found in model_bounds,
  * and saves it in bocopSave, for a future file writing.
  */
int MainWindow::saveBounds(void)
{
    double lower, upper;
    string type;

    bool ok;
    int counter=0;

    if (model_bounds == 0) {
        int stat = loadDefinitionBounds();
        if (stat != 0)
            return 1;
    }

    // we go through all the categories (types of variable) in the bounds model :
    for (int cat=0; cat<6; ++cat) {

        QStandardItem* it = model_bounds->item(cat,0);

        // we go through all the subcategories (variables) :
        for (int subcat=0; subcat<it->rowCount(); ++subcat) {

            lower = 0.0;
            upper = 0.0;
            type = "";

            // Subcategory (j-th child) :
            QStandardItem* it_equ = it->child(subcat,1);
            QStandardItem* it_low = it->child(subcat,2);
            QStandardItem* it_upp = it->child(subcat,3);

            if (it_equ == 0) {
                QMessageBox::critical(this, "Item not found", QString("Bounds model item [%0;%1] for equality not found").arg(cat).arg(subcat));
                return 1;
            }
            if (it_low == 0) {
                QMessageBox::critical(this, "Item not found", QString("Bounds model item [%0;%1] for lower value not found").arg(cat).arg(subcat));
                return 2;
            }
            if (it_upp == 0) {
                QMessageBox::critical(this, "Item not found", QString("Bounds model item [%0;%1] for upper value not found").arg(cat).arg(subcat));
                return 3;
            }

            // we get the equality bound properties :
            if (it_equ->checkState() == Qt::Checked) {
                lower = it_equ->data(Qt::EditRole).toDouble(&ok);
                if (!ok) {
                    QMessageBox::critical(this, "Invalid value", QString("Invalid equality bound for variable [%0;%1]. Make sure you entered a numerical value and not a formula (ex: type 0.5 instead of 1/2).").arg(cat).arg(subcat));
                    return 4;
                }

                upper = lower;
                type = "equal"; // equality
            }
            else {

                // we get the lower bound properties :
                if (it_low->checkState() == Qt::Checked) {
                    lower = it_low->data(Qt::EditRole).toDouble(&ok);
                    if (!ok) {
                        QMessageBox::critical(this, "Invalid value", QString("Invalid lower bound for variable [%0;%1]. Make sure you entered a numerical value and not a formula (ex: type 0.5 instead of 1/2).").arg(cat).arg(subcat));
                        return 5;
                    }

                    type = "lower"; // lower bound
                }
                else
                    type = "free"; // free

                // we get the upper bound properties :
                if (it_upp->checkState() == Qt::Checked) {
                    upper = it_upp->data(Qt::EditRole).toDouble(&ok);
                    if (!ok) {
                        QMessageBox::critical(this, "Invalid value", QString("Invalid upper bound for variable [%0;%1]. Make sure you entered a numerical value and not a formula (ex: type 0.5 instead of 1/2).").arg(cat).arg(subcat));
                        return 6;
                    }

                    // the type depends on whether the lower bound is active or not :
                    if (type == "lower")
                        type = "both"; // both lower and upper
                    else if (type == "free")
                        type = "upper"; // upper bound only

                }
            }

            // We save the bound in bocopSave :
            bocopSave->setBound(counter, lower, upper, type);
            counter++;
        }
    }

    return 0;
}


/**
  *\fn int MainWindow::saveConstants(void)
  * This method allows to save the values of the constants defined in the
  * last box of the definition tab. It collects the values and save them in
  * bocopSave.
  */
int MainWindow::saveConstants(void)
{
    QString val_str;
    double val;

    if (model_constants == 0) {
        int stat = loadDefinitionConstants();
        if (stat != 0)
            return 1;
    }



    // We get the values in the constants model :
    for (int i=0; i<model_constants->rowCount(); ++i) {

        // We get the item of the i-th child :
        QStandardItem* it = model_constants->item(i,1);
        val_str = it->text();

        // if the edit field is empty :
        if (val_str.isEmpty()) {
            ui->mainTextBrowser->append(QString("Text field for constant %0 value was found empty. Default zero value will be saved...").arg(i));
            val_str = "0.0";
        }

        // we convert the string in the field to double :
        bool ok;
        val = val_str.toDouble(&ok);
        if (!ok) {
            ui->mainTextBrowser->append(QString("Cannot convert the value for constant %0 in the text field from QString to double. Make sure you entered a numerical value and not a formula (ex: type 0.5 instead of 1/2). Default zero value will be used...").arg(i));
            val = 0.0;
        }

        // we save the value :
        bocopSave->setConstant(i, val);

    }

    return 0;
}


/**
  *\fn int MainWindow::saveIpoptOptions(void)
  * This method allows to save ipopt options as they are found in
  * model_ipot (visible in optimization tab treeview). The method
  * writes ipopt.opt in the current problem directory
  */
int MainWindow::saveIpoptOptions(void)
{
    // If the model is empty, we don't save anything
    // If ipopt.opt already exists, it will remain the same.
    if (model_ipopt == 0)
        return 0;

    // We create a list of strings containing the values :
    QStringList names;
    QStringList values;
    for (int i=0; i<model_ipopt->rowCount(); ++i) {

        // We get the items on the current row :
        QStandardItem* it_name = model_ipopt->item(i,0);
        QStandardItem* it_value = model_ipopt->item(i,1);

        // If the items were found, we read their texts :
        if (it_name != 0 && it_value != 0) {
            QString name_str = it_name->text();
            QString value_str = it_value->text();

            // If the text is not empty we add it to the lists :
            if (!name_str.isEmpty() && !value_str.isEmpty()) {
                names << name_str;
                values << value_str;
            }
        }
    }

    // Finally, we have to write the file :
    QFileInfo f_opt(problem_dir, "ipopt.opt");
    QFile wfile(f_opt.absoluteFilePath());

    wfile.open(QIODevice::WriteOnly);
    QTextStream out(&wfile);
    for(int i=0; (i<names.size() && i<values.size()); ++i)
        out << names.at(i) << " " << values.at(i) << endl;

    wfile.close();

    return 0;
}


/**
  *\fn int MainWindow::saveBatchOptions(void)
  * This method allows to save bocop optimization options
  * The result is saved in bocopSol, depending on the type
  * of optimization (single or batch), we write or delete
  * entries in .def file.
  */
int MainWindow::saveBatchOptions(void)
{

    // Batch :
    if (!ui->optim_push_single->isChecked() && ui->optim_push_batch->isChecked()) {

        // We have to get batch options in the line edit fields :
        int type = ui->typeComboBox->currentIndex();
        if (type<0 || type>=2 ) {
            QMessageBox::critical(this, "Batch optimization : invalid type", "Please select a valid type of batch.");
            return 1;
        }

        int index = ui->batchComboBox->currentIndex();
        if ((index<0 && type != 1) || index>=dimConstants() ) {
            QMessageBox::critical(this, "Batch optimization : invalid index", "Please select a valid index for the  vary.");
            return 1;
        }
        bool ok;
        int range = ui->batchNumberLineEdit->text().toInt(&ok);
        if (!ok || range < 0) {
            QMessageBox::critical(this, "Batch optimization : invalid range", "Please give a valid integer.");
            return 2;
        }

        double lower = ui->batchLowerLineEdit->text().toDouble(&ok);
        if (!ok) {
            QMessageBox::critical(this, "Batch optimization : invalid lower bound", "Please give a valid double. Make sure you entered a numerical value and not a formula (ex: type 0.5 instead of 1/2).");
            return 3;
        }

        double upper = ui->batchUpperLineEdit->text().toDouble(&ok);
        if (!ok) {
            QMessageBox::critical(this, "Batch optimization : invalid upper bound", "Please give a valid double. Make sure you entered a numerical value and not a formula (ex: type 0.5 instead of 1/2).");
            return 4;
        }

        QString folder_path = ui->batchFolderLineEdit->text();
        if (folder_path.isEmpty()){
            QMessageBox::critical(this, "Batch optimization : invalid folder name", "Please give a valid string for the name of the folder. This folder will be created in your problem's directory...");
            return 5;
        }

        // We have to create a new directory to save batch solution files :
        QDir new_dir(problem_dir);
        if (!new_dir.exists(folder_path)) {
            bool ok = new_dir.mkdir(folder_path);
            if (!ok)
                QMessageBox::warning(this, "Batch optimization : failed to create folder", "An error occurred while creating a new directory. Please give a valid name, and try again");

        }

        // If the batch optimization is done on the number of discretization steps
        // we check that the lower and upper values are integers
        if (type == 1){
            ui->batchLowerLineEdit->text().toInt(&ok);
            if (!ok){
                QMessageBox::critical(this, QString("Batch optimization : invalid lower value."), QString("The current value is not an integer: %0. Please give an integer value.").arg(ui->batchLowerLineEdit->text()));
                return 6;
            }
            ui->batchUpperLineEdit->text().toInt(&ok);
            if (!ok){
                QMessageBox::critical(this, QString("Batch optimization : invalid upper value."), QString("The current value is not an integer: %0. Please give an integer value.").arg(ui->batchUpperLineEdit->text()));
                return 7;
            }

        }

        bocopSave->addDefinitionEntry("optimization.type","string","batch");
        bocopSave->addDefinitionEntry("batch.type","integer",QString::number(type).toStdString());
        bocopSave->addDefinitionEntry("batch.index","integer",QString::number(index).toStdString());
        bocopSave->addDefinitionEntry("batch.nrange","integer",QString::number(range).toStdString());
        bocopSave->addDefinitionEntry("batch.lowerbound","double",QString::number(lower,'g',15).toStdString());
        bocopSave->addDefinitionEntry("batch.upperbound","double",QString::number(upper,'g',15).toStdString());
        bocopSave->addDefinitionEntry("batch.directory","string",folder_path.toStdString());

        return 0;
    }

    // Single :
    // we set the optimization type to "single" :
    bocopSave->addDefinitionEntry("optimization.type","string","single");
    bocopSave->addDefinitionEntry("batch.type","integer","0");
    bocopSave->addDefinitionEntry("batch.index","integer","0");
    bocopSave->addDefinitionEntry("batch.nrange","integer","1");
    bocopSave->addDefinitionEntry("batch.lowerbound","double","0");
    bocopSave->addDefinitionEntry("batch.upperbound","double","0");
    bocopSave->addDefinitionEntry("batch.directory","string","none");

    return 0;
}


/**
  *\fn int MainWindow::saveReOptimOptions(void)
  * This method saves all options related to reoptimization.
  * Bocop needs to know if the starting point must be generated
  * from init files created with initialization tab, or from a
  * solution file written at the end of a previous optimization
  * of the same problem.
  */
int MainWindow::saveReOptimOptions(void)
{
    // If we want to reoptimize (start from previous solution) :
    if (!ui->optim_initfile_radio->isChecked()){
        // cold start, we initialize the variables
        if( ui->optim_cold_start_radio->isChecked()) {

            // We need to get the solution file from which we want to
            // generate the starting point :
            QString in_lineedit = ui->reoptimization_lineEdit->text();
            QFileInfo sol_file(problem_dir, in_lineedit);
            if (sol_file.exists()) {
                bocopSave->addDefinitionEntry("initialization.type","string","from_sol_file_cold");
                bocopSave->addDefinitionEntry("initialization.file","string",in_lineedit.toStdString());

                return 0;
            }
        }
        // warm start, we initialize the variables and the multipliers
        else if (ui->optim_warm_start_radio->isChecked())
        {
            // We need to get the solution file from which we want to
            // generate the starting point :
            QString in_lineedit = ui->reoptimization_lineEdit->text();
            QFileInfo sol_file(problem_dir, in_lineedit);
            if (sol_file.exists()) {
                bocopSave->addDefinitionEntry("initialization.type","string","from_sol_file_warm");
                bocopSave->addDefinitionEntry("initialization.file","string",in_lineedit.toStdString());

                return 0;
            }
        }
    }

    // else, start from initialization files :
    //    bocopSave->removeDefinitionEntry("initialization.file");
    bocopSave->addDefinitionEntry("initialization.type","string","from_init_file");
    bocopSave->addDefinitionEntry("initialization.file","string","none");

    return 0;
}


/**
  *\fn int MainWindow::saveParamId(void)
  * This method saves all options related to parameter identification.
  * Bocop needs to know if we are doing a parameter identification,
  * and if yes, where the observations file is located.
  */
int MainWindow::saveParamId(void)
{
    // If we want to make a parameter identification :
    if (ui->paramid_checkBox->isChecked()){

        // We get the method
        int methodIndex = ui->methodComboBox->currentIndex();
        switch (methodIndex)
        {
        case 0:
            bocopSave->addDefinitionEntry("paramid.type","string","LeastSquare");
            break;
        case 1:
            bocopSave->addDefinitionEntry("paramid.type","string","LeastSquareWithCriterion");
            break;
        case 2:
            bocopSave->addDefinitionEntry("paramid.type","string","Manual");
            break;
        }

        // We get the data set size (number of observation files)
        bool ok;
        QString sizeDataSetString = ui->lineEditObsFilesNb->text();
        int dataSetSize = sizeDataSetString.toInt(&ok);
        if (!ok || dataSetSize < 0) {
            QMessageBox::critical(this, "Conversion error", "Number of observation files is incorrect (positive int expected) or you didn't enter any dimension.");
            return 1;
        }

        bocopSave->addDefinitionEntry("paramid.dimension","integer",sizeDataSetString.toStdString());

        bocopSave->addDefinitionEntry("paramid.separator","string",ui->separator_comboBox->currentText().toStdString());

        // We get the observations file
        QString observationFileName = ui->observations_lineEdit->text();

        // First we check if the file name contains the char '-', that is needed to separate the file name from the file number
        if ( dataSetSize>1 && !observationFileName.contains('-')){
            QMessageBox::critical(this, "Missing separator in file name", QString("The observation file %0 doesn't contain the separator '-', which is needed to separate the file name from the file number. Please make sure that the observation file names have the form \"name\"-\"integer\".").arg(observationFileName));
            return 1;
        }

        // First we check that it is a .csv file
        // We extract the extension of the observation file
        QString extension = observationFileName;
        reverse(extension.begin(), extension.end());
        int index = extension.indexOf(".");
        extension.remove(index, extension.length()-index);

        // We check that the extension of the file is csv
        if (extension != "vsc"){
            QMessageBox::critical(this, "Wrong observation file", QString("The file %0 should be a .csv file. Please make sure that you saved the observations in the right format and that you selected a valid observation file.").arg(observationFileName));
            return 1;
        }

        // If there is only one observation file we just check if it exists and is readable
        if (dataSetSize == 1){
            QString fileName = observationFileName;
            if (!QFileInfo(fileName).exists()){
                // We try to add the problem_dir
                QString oldFileName = observationFileName;
                fileName = problem_dir.absolutePath() + QString(QDir::separator()) + oldFileName;
                if (!QFileInfo(fileName).exists()){
                    QMessageBox::critical(this, "Missing observation file", QString("Neither file %0 or file %1 were found. Please make sure that you selected an observation file.").arg(fileName).arg(oldFileName));
                    return 1;
                }
            }
            if (!QFileInfo(fileName).isReadable()){
                QMessageBox::critical(this, "Observation file not readable", QString("The observation file %0 isn't readable. Please check the status of this file.").arg(fileName));
                return 1;
            }
        }
        // If there are several observation files, we check taht they all exist and are readable
        else{

            // We extract the file base name (without number)
            QString baseName = observationFileName;
            reverse(baseName.begin(), baseName.end());
            baseName.remove(0,index);

            index = baseName.indexOf("-");
            baseName.remove(0,index);
            reverse(baseName.begin(), baseName.end());

            QString fileName;

            // We check if all the files exist and are readable
            for (int i=0;i<dataSetSize; i++){
                fileName = baseName + QString::number(i) + ".csv";
                if (!QFileInfo(fileName).exists()){
                    // We try to add the problem_dir
                    QString oldFileName = fileName;
                    fileName = problem_dir.absolutePath() + QString(QDir::separator()) + oldFileName;
                    if (!QFileInfo(fileName).exists()){
                        QMessageBox::critical(this, "Missing observation file", QString("Neither file %0 or file %1 were found. Please make sure that you selected an observation file.").arg(fileName).arg(oldFileName));
                        return 1;
                    }
                    else if (!QFileInfo(fileName).isReadable()){
                        QMessageBox::critical(this, "Observation file not readable", QString("The observation file %0 isn't readable. Please check the status of this file.").arg(fileName));
                        return 1;
                    }
                }
            }

            // We check that the files are located in the problem folder (if the use typed the absolute path to an external folder we return an error)
            if (!fileName.contains(problem_dir.absolutePath())){
                QMessageBox::critical(this, "Observation file not valid", QString("The observation files should be located in your problem directory, or in some subdirectory of your problem directory. Please move the observation files to the right place."));
                return 1;
            }
        }

        // If all the files exist, we save the observation file
        // We take only the relative path, in order to avoid local information in the problem.def
        QString fileForDef = observationFileName.remove(problem_dir.absolutePath());
        bocopSave->addDefinitionEntry("paramid.file", "string", fileForDef.toStdString() );

        return 0;
    }
    // else, we don't do a parameter identification :
    bocopSave->addDefinitionEntry("paramid.type","string","false");
    bocopSave->addDefinitionEntry("paramid.separator","string",ui->separator_comboBox->currentText().toStdString());
    bocopSave->addDefinitionEntry("paramid.file","string","no_directory");
    bocopSave->addDefinitionEntry("paramid.dimension","integer","0");

    return 0;
}
