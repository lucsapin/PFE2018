// Copyright (C) 2011-2014 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: optimization.cpp
// Authors: Vincent Grelard, Daphne Giorgi

#include "mainwindow.h"
#include "ui_mainwindow.h"


/**
  *\fn int MainWindow::loadOptimization(void)
  * This method loads the optimization parameters.
  */
int MainWindow::loadOptimization(void)
{
    if (model_ipopt == 0) {
        model_ipopt = new QStandardItemModel();
        readIpoptOptions();
    }

    // We set two headers to the model :
    model_ipopt->setHorizontalHeaderItem( 0, new QStandardItem( "Name" ) );
    model_ipopt->setHorizontalHeaderItem( 1, new QStandardItem( "Value" ) );

    // Finally we pass the model to the tableview :
    ui->ipopt_tableView->setModel(model_ipopt);

    // We hide the numbers on the right :
    ui->ipopt_tableView->verticalHeader()->hide();

    // And we stretch the columns so that they fill the table view :
    QHeaderView *header = ui->ipopt_tableView->horizontalHeader();
#if (QT_VERSION < QT_VERSION_CHECK(5,0,0))
    header->setResizeMode(QHeaderView::Stretch);
#else
    header->setSectionResizeMode(QHeaderView::Stretch);
#endif

    // If the single/batch options have already been loaded,
    // we don't load them again :
    if (!ui->optim_push_batch->isChecked() && !ui->optim_push_single->isChecked()) {

        // Now we get the properties of current bocopDef, if any :
        // Single or batch optimization :
        if (bocopDef == 0) {
            ui->optim_push_batch->setChecked(false);
            ui->optim_push_single->setChecked(true);
        }
        else {
            bool is_single = bocopDef->isSingleOptimization();
            ui->optim_push_batch->setChecked(!is_single);
            ui->optim_push_single->setChecked(is_single);
        }

        // We hide or show the batch frame according to the type of optimization :
        if (ui->optim_push_single->isChecked())
            ui->batchOptionsFrame->setEnabled(false);
        else
            loadBatchOptions();
    }

    // We load re-optimization options

    // If the options haven't already been loaded before
    if (!ui->optim_initfile_radio->isChecked()  && !ui->optim_cold_start_radio->isChecked() && !ui->optim_warm_start_radio->isChecked()) {

        if (bocopDef != 0) {
            if (bocopDef->methodInitialization() == "from_sol_file_cold")
                setOptimFromSolFileCold();
            else if (bocopDef->methodInitialization() == "from_sol_file_warm")
                setOptimFromSolFileWarm();
            else
                setOptimFromInitFile();
        }
        else
            setOptimFromInitFile();
    }

    // We load the parameter identification options

    if (ui->observations_lineEdit->text() == "")
    {
        if  (bocopDef != 0 && !optimTabClicked)
        {
            if (bocopDef->isParamId())
            {
                ui->paramid_checkBox->setChecked(true);
                ui->observation_frame->setEnabled(true);

                // We set the index corresponding to the parameter identification method read by bocopDef
                if (bocopDef->paramIdType() == "LeastSquare")
                    ui->methodComboBox->setCurrentIndex(0);
                else if(bocopDef->paramIdType() == "LeastSquareWithCriterion")
                    ui->methodComboBox->setCurrentIndex(1);
                else if (bocopDef->paramIdType() == "Manual")
                    ui->methodComboBox->setCurrentIndex(2);

                // We set the number corresponding to the parameter identification size of experiments read by bocopDef
                if (ui->lineEditObsFilesNb->text().isEmpty()){
                    QString fileNb;
                    fileNb.setNum(bocopDef->sizeDataSet());
                    ui->lineEditObsFilesNb->setText(fileNb);
                }

                // We set the file corresponding to the parameter identification file read by bocopDef
                if (bocopDef->observationFile()!="")
                    ui->observations_lineEdit->setText(QString(bocopDef->observationFile().c_str()));

                // We set the index corresponding to the parameter identification separator read by bocopDef
                if (bocopDef->observationSeparator() == ',')
                    ui->separator_comboBox->setCurrentIndex(0);
                else if (bocopDef->observationSeparator() == ';')
                    ui->separator_comboBox->setCurrentIndex(1);
                else if (bocopDef->observationSeparator() == ':')
                    ui->separator_comboBox->setCurrentIndex(2);
                else if (bocopDef->observationSeparator() == '\t')
                    ui->separator_comboBox->setCurrentIndex(3);
                else if (bocopDef->observationSeparator() == ' ')
                    ui->separator_comboBox->setCurrentIndex(4);
            }
            else
            {
                ui->paramid_checkBox->setChecked(false);
                ui->observation_frame->setEnabled(false);
            }
        }
    }

    return 0;
}

/**
  * \fn int MainWindow::sizeExperiments()
  * This method is a getter for the size of experiments. It returns
  * the value in the line edit "Number of observation files",
  * or a default value if an error occurs
  */
int MainWindow::sizeExperiments()
{
    QString dim_field_str = ui->lineEditObsFilesNb->text();

    if (dim_field_str.isEmpty())
        return -1;

    bool ok;
    int dim_field = dim_field_str.toInt(&ok);

    if (!ok) {
        QMessageBox::warning(this, "Warning", "The experiments number in the parameter identification field is incorrect. Default value from your definition file will be used...");
        if (bocopDef != 0)
            return bocopDef->sizeDataSet();
        else return -1;
    }

    return dim_field;
}


/**
  *\fn int MainWindow::on_obsFile_pushButton_clicked(void)
  * This slot is called when the Choose Observation File button is clicked. It allows
  * the user to select the observations file to load. A box is opened to show the files, and
  * once a  file is chosen, its name is displayed in the text field.
  */
void MainWindow::on_obsFile_pushButton_clicked()
{
    QString starting_path = problem_dir.absolutePath();

    QString new_path = QFileDialog::getOpenFileName(this,
                                                    tr("Please select an observations file"),
                                                    starting_path, tr("Observation Files (*.csv)"));
    // If nothing is returned :
    if (new_path.isEmpty())
        return;

    QString obsFileName = new_path.remove(problem_dir.absolutePath() + QDir::separator());

    // We set the new path in the line edit :
    ui->observations_lineEdit->setText(obsFileName);
}


/**
  *\fn int MainWindow::readIpoptOptions(void)
  * This methods reads ipopt.opt in the current problem
  * directory, and fills model_ipopt accordingly. This
  * model is intented to be displayed in the optimization
  * tab tableview.
  */
int MainWindow::readIpoptOptions(void)
{
    QFileInfo file_opt(problem_dir, "ipopt.opt");

    if (!file_opt.isReadable()) // the model will be empty, not important
        return 1;

    // We read the whole content of .disc file :
    QFile my_file(file_opt.absoluteFilePath());
    my_file.open(QIODevice::ReadOnly);

    QStringList all_in_file;
    QTextStream flux(&my_file);

    while(! flux.atEnd())
        all_in_file << flux.readLine();

    my_file.close();


    // We need to remove the commented and empty lines :
    for (int i=0; i<all_in_file.size(); ++i) {
        if (all_in_file.at(i).startsWith("#") || all_in_file.at(i).isEmpty()) {
            // we remove this line from the list :
            all_in_file.removeAt(i);
            // we removed i-th line, the i+1-th line takes its place, we
            // have to check it in the next iteration :
            i--;
        }
    }

    // Now we have one string for each line of the file,
    // we need to separate the names from the values :
    for (int i=0; i<all_in_file.size(); ++i) {

        QStringList splitted_line = all_in_file.at(i).split(" ");

        if (splitted_line.size()>=2) {

            // name of the entry :
            QStandardItem *name_it = new QStandardItem(splitted_line.at(0));
            model_ipopt->setItem(i,0, name_it);

            // value of the entry :
            QStandardItem *value_it = new QStandardItem(splitted_line.at(1));
            model_ipopt->setItem(i,1, value_it);
        }
    }

    return 0;
}


/**
  *\fn void MainWindow::on_addoption_button_clicked()
  * This slot is called when "add option" button is clicked on the
  * optimization tab. It allows users to add a line in the
  * model for ipopt options.
  */
void MainWindow::on_addoption_button_clicked()
{
    QStandardItem *name_it = new QStandardItem();
    QStandardItem *value_it = new QStandardItem();

    QList<QStandardItem*> both;
    both << name_it << value_it;

    model_ipopt->appendRow(both);
    ui->ipopt_tableView->scrollToBottom();
}


/**
  *\fn void MainWindow::on_optim_push_batch_clicked()
  * This method is called when user clicks on the radio button
  * for batch optimization. It checks this button, and unchecks
  * single optimization button. Then it displays a menu to select
  * batch options.
  */
void MainWindow::on_optim_push_batch_clicked()
{
    // First we check/uncheck the optimization type buttons :
    ui->optim_push_single->setChecked(false);
    ui->optim_push_batch->setChecked(true);
    ui->batchOptionsFrame->setEnabled(true);

    // Finally we load and display the batch options :
    loadBatchOptions();
}


/**
  *\fn int MainWindow::loadBatchOptions(void)
  * This method is called to set batch options values in the
  * edit fields of optimization tab.
  */
int MainWindow::loadBatchOptions(void)
{
    // We load the "name of the variable to vary" combobox properties :
    loadBatchNames();

    if (bocopDef == 0)
        return 0; // nothing to load

    // Then we load batch properties from bocopDef :
    int range;
    double starting;
    double ending;
    string folder;

    if (!bocopDef->isSingleOptimization()) {

        ui->batchOptionsFrame->setEnabled(true);

        // First we get all the values read from the file :
        range = bocopDef->rangeBatch();
        starting = bocopDef->startingBatch();
        ending = bocopDef->endingBatch();
        folder = bocopDef->folderBatch();

        // We check that these values are correct :
        if (range < 2) {
            QMessageBox::critical(this, "Batch optimization : invalid range", "Batch optimization options in .def are invalid. Number of optimization should be at least 2. Please define batch optimization options...");
            return 3;
        }
        if (folder == "") {
            QMessageBox::critical(this, "Batch optimization : invalid folder name", "Batch optimization options in .def are invalid. Folder's name is empty. Please define batch optimization options...");
            return 5;
        }

        // Finally, we set these values in the batch optimization fields :
        if (ui->batchLowerLineEdit->text().isEmpty())
            ui->batchLowerLineEdit->setText(QString::number(starting));

        if (ui->batchUpperLineEdit->text().isEmpty())
            ui->batchUpperLineEdit->setText(QString::number(ending));

        if (ui->batchNumberLineEdit->text().isEmpty()){
            ui->batchNumberLineEdit->setText(QString::number(range));

            convertToBatchStep(range);
        }

        if (ui->batchFolderLineEdit->text().isEmpty())
            ui->batchFolderLineEdit->setText(QString::fromStdString(folder));
    }

    return 0;
}


/**
  *\fn int MainWindow::loadBatchNames(void)
  * This method manages the content of the batch "constant to vary"
  * combobox. It refreshes the constants names (one entry for each name)
  * according to the constants names treeview.
  */
int MainWindow::loadBatchNames(void)
{
    int type = 0;
    int index = 0;

    bool ok;

    int range;
    double starting;
    double ending;
    string folder;

    QString rangeString;
    QString startingString;
    QString endingString;
    QString folder_path;

    if (ui->batchComboBox->currentIndex() != -1){
        // If the combobox has already been loaded, we keep the current batch informations :
        type = ui->typeComboBox->currentIndex();
        index = ui->batchComboBox->currentIndex();

        rangeString = ui->batchNumberLineEdit->text();
        startingString = ui->batchLowerLineEdit->text();
        endingString = ui->batchUpperLineEdit->text();
        folder_path = ui->batchFolderLineEdit->text();

        range = ui->batchNumberLineEdit->text().toInt(&ok);
        convertToBatchStep(range);

    }
    else {
        // If the index does not exist, we keep the value from .def :
        if (bocopDef!=0 && !bocopDef->isSingleOptimization()) {
            type = bocopDef->typeBatch();
            if (type == 1)
                index = 0;
            else
                index = bocopDef->indexBatch();

            // and we check that the value is correct :
            if (type == 0 && ( index >= bocopDef->dimConstants() || index < 0 ) ) {
                QMessageBox::warning(this, "Batch optimization : invalid index", QString("Index of the batch constant found in .def is invalid: %0. Please define batch optimization options...").arg(index));
                index = 0;
            }

            // We keep the values from .def
            range = bocopDef->rangeBatch();
            starting = bocopDef->startingBatch();
            ending = bocopDef->endingBatch();
            folder = bocopDef->folderBatch();

            rangeString = QString::number(range);
            startingString = QString::number(starting);
            endingString = QString::number(ending);
            folder_path = QString::fromStdString(folder);
        }
        else{
            rangeString = "";
            startingString = "";
            endingString = "";
            folder_path = "";
        }
    }

    // We load the names, in case dimensions or names have changed :
    loadDefinitionDimensions();
    loadDefinitionNames();

    // We set the names in the combobox :
    ui->batchComboBox->clear();

    if (type == 0){
        for (int i=0;i<dimConstants(); ++i)
            ui->batchComboBox->addItem(nameInTreeView(6, i, "constant"));
    }

    // We set the index :
    ui->typeComboBox->setCurrentIndex(type);
    ui->batchComboBox->setCurrentIndex(index);

    ui->batchNumberLineEdit->setText(rangeString);
    ui->batchLowerLineEdit->setText(startingString);
    ui->batchUpperLineEdit->setText(endingString);
    ui->batchFolderLineEdit->setText(folder_path);

    convertToBatchStep(range);

    return 0;
}

/**
  *\fn void MainWindow::on_typeComboBox_currentIndexChanged(int index)
  * Slot called when the index of combo box for the type of optimization changed.
  * If the new type is the number of discretization steps it disable the indexes to vary.
  * If the new type is constant it enable the indexes and put the list of the constants names.
  *
  */
void MainWindow::on_typeComboBox_currentIndexChanged(int index)
{
    ui->batchNumberLineEdit->clear();
    ui->batchStepLineEdit->clear();
    ui->batchLowerLineEdit->clear();
    ui->batchUpperLineEdit->clear();
    ui->batchFolderLineEdit->clear();

    switch (index){
    case 0 : // constant
    {
        ui->batchComboBox->setEnabled(true);
        ui->labelVaryingIndex->setEnabled(true);

        loadDefinitionDimensions();
        loadDefinitionNames();

        // We set the names in the combobox :
        ui->batchComboBox->clear();

        for (int i=0;i<dimConstants(); ++i)
            ui->batchComboBox->addItem(nameInTreeView(6, i, "constant"));
        break;

    }
    case 1 : // number of discretization steps
    {
        ui->batchComboBox->setEnabled(false);
        ui->labelVaryingIndex->setEnabled(false);

        // We set the names in the combobox :
        ui->batchComboBox->clear();
        break;
    }
    }
}

/**
  *\fn void MainWindow::on_batchComboBox_currentIndexChanged()
  * This slot is called when we change an index of the constants for the batch otpimization.
  * It clears the fields for the batch.
  */
void MainWindow::on_batchComboBox_currentIndexChanged(const QString &arg1)
{
    ui->batchNumberLineEdit->clear();
    ui->batchStepLineEdit->clear();
    ui->batchLowerLineEdit->clear();
    ui->batchUpperLineEdit->clear();
    ui->batchFolderLineEdit->clear();

}


/**
  *\fn void MainWindow::on_optim_push_single_clicked()
  * This method is called when user clicks on the radio button
  * for single optimization. It checks this button, and unchecks
  * batch optimization button. Then it hides the menu to select
  * batch options.
  */
void MainWindow::on_optim_push_single_clicked()
{
    ui->optim_push_single->setChecked(true);
    ui->optim_push_batch->setChecked(false);
    ui->batchOptionsFrame->setEnabled(false);
}


/**
  *\fn int MainWindow::checkBatchDirectory(void)
  * This method is used when a batch optimization is launched. It
  * checks that the batch directory exists, and that it is empty.
  * Bocop solution files will then be saved in this directory.
  */
int MainWindow::checkBatchDirectory(void)
{
    // We get the directory name :
    loadBatchOptions();
    QString folder_name = ui->batchFolderLineEdit->text();
    if (folder_name.isEmpty()){
        QMessageBox::critical(this, "Batch optimization : invalid folder name", "Please give a valid string for the name of the folder. This folder will be created in your problem's directory...");
        return 1;
    }

    // batch directory :
    QDir batch_dir(problem_dir);

    // If the directory does not exist, we create it :
    if (!batch_dir.exists(folder_name)) {
        bool ok = batch_dir.mkdir(folder_name);
        if (!ok) {
            QMessageBox::critical(this, "Batch optimization : failed to create folder",
                                  "An error occurred while creating a new directory. Please give a valid name, save, and try again");
            return 2;
        }
    }
    // If the directory already exists, we check that it is empty :
    else {
        bool ok = batch_dir.cd(folder_name); // <problem_dir>/folder_name
        if (!ok) {
            QMessageBox::critical(this, "Batch optimization : error",
                                  "Cannot reach batch directory. Please give a valid name, save, and try again...");
            return 3;
        }

        // We check that the directory is empty
        QStringList ls_dir = batch_dir.entryList(QDir::Files);

        if (!ls_dir.isEmpty()) {
            QString msg = "Batch folder %0 is not empty. All .sol and .log files inside will be deleted.";
            int answer = QMessageBox::question(this, QString("Batch folder not empty"),
                                               msg.arg(folder_name), QMessageBox::Ok | QMessageBox::Cancel );

            switch (answer) {
            case QMessageBox::Ok :

                foreach (QString file_str, ls_dir) {
                    if (file_str.endsWith("sol") || file_str.endsWith("log"))
                    {
                        QFileInfo file_info(batch_dir, file_str);
                        QFile file(file_info.absoluteFilePath());
                        file.remove();
                    }
                }
                break;
            case QMessageBox::Cancel :
                return 4;
                break;
            }
        }
    }

    return 0;
}


/**
  *\fn void MainWindow::convertToBatchStep(const int range)
  * This slot is called the line edit for batch range changesits value.
  * It converts the batch range in the equivalent batch step
  * and fill the step line edit with the computed value.
  */
void MainWindow::convertToBatchStep(const int range)
{
    // If on of the necessary field is empty we don't make the convertion
    if (ui->batchUpperLineEdit->text().isEmpty() || ui->batchLowerLineEdit->text().isEmpty())
        return;

    bool ok;
    double upper = ui->batchUpperLineEdit->text().toDouble(&ok);
    if (!ok ) {
        QMessageBox::critical(this, "Batch optimization : invalid upper bound", "Please give a valid double. Make sure you entered a numerical value and not a formula (ex: type 0.5 instead of 1/2).");
        return;
    }

    double lower = ui->batchLowerLineEdit->text().toDouble(&ok);
    if (!ok) {
        QMessageBox::critical(this, "Batch optimization : invalid lower bound", "Please give a valid double. Make sure you entered a numerical value and not a formula (ex: type 0.5 instead of 1/2).");
        return;
    }

    double step = (upper-lower)/double(range-1);

    // If it's an batch on the number of discretization steps, we convert the step to an integer
    if(ui->typeComboBox->currentIndex() == 1){
        int intStep = int(step);
        ui->batchStepLineEdit->setText(QString::number(intStep));
    }
    else
        ui->batchStepLineEdit->setText(QString::number(step));
}


/**
  *\fn void MainWindow::convertToBatchRange(const double step)
  * This slot is called the line edit for batch step changes its value.
  * It converts the batch step in the equivalent batch range
  * and fill the range line edit with the computed value.
  */
void MainWindow::convertToBatchRange(const double step)
{
    // If on of the necessary field is empty we don't make the convertion
    if (ui->batchUpperLineEdit->text().isEmpty() || ui->batchLowerLineEdit->text().isEmpty())
        return;

    bool ok;

    double upper = ui->batchUpperLineEdit->text().toDouble(&ok);
    if (!ok) {
        QMessageBox::critical(this, "Batch optimization : invalid upper bound", "Please give a valid double. Make sure you entered a numerical value and not a formula (ex: type 0.5 instead of 1/2).");
        return;
    }

    double lower = ui->batchLowerLineEdit->text().toDouble(&ok);
    if (!ok) {
        QMessageBox::critical(this, "Batch optimization : invalid lower bound", "Please give a valid double. Make sure you entered a numerical value and not a formula (ex: type 0.5 instead of 1/2).");
        return;
    }

    int batch = int((upper - lower)/step) + 1;

    ui->batchNumberLineEdit->setText(QString::number(batch));
}

void MainWindow::on_batchNumberLineEdit_editingFinished()
{
    bool ok;

    int range = ui->batchNumberLineEdit->text().toInt(&ok);
    if ((!ok &&  !ui->batchNumberLineEdit->text().isEmpty() ) || range < 0) {
        QMessageBox::critical(this, "Batch optimization : invalid range", "Please give a valid integer.");
        return;
    }

    if (range != 0)
        convertToBatchStep(range);
    else{
        if (!ui->batchStepLineEdit->text().isEmpty()){
            on_batchStepLineEdit_editingFinished();
        }
    }
}

void MainWindow::on_batchStepLineEdit_editingFinished()
{
    // If on of the necessary field is empty we don't make the convertion
    if (ui->batchUpperLineEdit->text().isEmpty() || ui->batchLowerLineEdit->text().isEmpty())
        return;

    double upper, lower;

    bool ok = getLowAndUp(lower, upper);

    if(!ok)
        return;

    double step = ui->batchStepLineEdit->text().toDouble(&ok);
    if (!ok && !ui->batchStepLineEdit->text().isEmpty()) {
        QMessageBox::critical(this, "Batch optimization : invalid step", "Please give a valid double.");
        return;
    }

    // We first check that the step is smaller than the interval
    double maxStep = upper - lower;
    if (fabs(step) > fabs(maxStep)){
        QMessageBox::critical(this, "Batch optimization : invalid step", QString("The step has to be smaller than the batch interval (%0 - %1) = %2. Please give a valid step.").arg(upper).arg(lower).arg(maxStep));
        return;
    }

    if (step != 0)
        convertToBatchRange(step);
    else{
        if (!ui->batchNumberLineEdit->text().isEmpty()){
            on_batchNumberLineEdit_editingFinished();
        }
    }
}

/**
  *\fn int MainWindow::getLowAndUp(double& low, double& up)
  * This method reads the lower and the upper value given for the batch optimization
  * and checks that they are double values.
  */
bool MainWindow::getLowAndUp(double& low, double& up)
{
    bool ok;
    up = ui->batchUpperLineEdit->text().toDouble(&ok);
    if (!ok ) {
        QMessageBox::critical(this, "Batch optimization : invalid upper bound", "Please give a valid double. Make sure you entered a numerical value and not a formula (ex: type 0.5 instead of 1/2).");
        return false;
    }

    low = ui->batchLowerLineEdit->text().toDouble(&ok);
    if (!ok) {
        QMessageBox::critical(this, "Batch optimization : invalid lower bound", "Please give a valid double. Make sure you entered a numerical value and not a formula (ex: type 0.5 instead of 1/2).");
        return false;
    }

    return true;
}

/**
  *\fn void MainWindow::on_resetIpoptOptions_button_clicked()
  * This slot is called when "reset default options" button is clicked
  * on the optimization tab. It set default values in model_ipopt, and
  * displays it in "ipopt options" tableview.
  */
void MainWindow::on_resetIpoptOptions_button_clicked()
{
    // First we erase ipopt options model :
    if (model_ipopt != 0) {
        delete model_ipopt;
        model_ipopt = 0;
    }

    // Then we set default keys and values :
    QStringList ipopt_keys;
    ipopt_keys << "max_iter" << "tol" << "print_level";
    ipopt_keys << /*"file_print_level" <<*/ "output_file" << "mu_strategy";

    QStringList ipopt_values;
    ipopt_values << "1000" << "1.0e-10" << "5";
    ipopt_values << /*"6" <<*/ "result.out" << "adaptive";

    if (ipopt_keys.size() != ipopt_values.size())
        qDebug() << "Ipopt options reset : dimensions mismatch";

    // We allocate memory for the model :
    model_ipopt = new QStandardItemModel();

    // We fill the model with default values :
    for (int i=0; i<ipopt_keys.size(); ++i) {

        QStandardItem *name_it = new QStandardItem(ipopt_keys.at(i));
        QStandardItem *value_it = new QStandardItem(ipopt_values.at(i));

        QList<QStandardItem*> both;
        both << name_it << value_it;

        model_ipopt->appendRow(both);
    }

    // We set two header to the model :
    model_ipopt->setHorizontalHeaderItem( 0, new QStandardItem( "Name" ) );
    model_ipopt->setHorizontalHeaderItem( 1, new QStandardItem( "Value" ) );

    // Finally we pass the model to the tableview :
    ui->ipopt_tableView->setModel(model_ipopt);

    // We hide the numbers on the right :
    ui->ipopt_tableView->verticalHeader()->hide();

    // And we stretch the columns so that they fill the table view :
    QHeaderView *header = ui->ipopt_tableView->horizontalHeader();

#if (QT_VERSION < QT_VERSION_CHECK(5,0,0))
    header->setResizeMode(QHeaderView::Stretch);
#else
    header->setSectionResizeMode(QHeaderView::Stretch);
#endif
}


/**
  *\fn int MainWindow::setOptimFromInitFile()
  * This method sets enables/disables items in the optimization
  * tab, depending if they are associated or not, with an init
  * file generated starting point.
  */
int MainWindow::setOptimFromInitFile()
{
    // We handle radiobuttons exclusivity :
    ui->optim_initfile_radio->setChecked(true);
    ui->optim_cold_start_radio->setChecked(false);
    ui->optim_warm_start_radio->setChecked(false);

    // We hide reoptimization frame :
    ui->reoptimization_frame->setEnabled(false);

    return 0;
}


/**
  *\fn int MainWindow::setOptimFromSolFileCold()
  * This method sets enables/disables items in the optimization
  * tab, depending if they are associated or not, with a solution
  * file generated starting point.
  */
int MainWindow::setOptimFromSolFileCold()
{
    // We handle radiobuttons exclusivity :
    ui->optim_initfile_radio->setChecked(false);
    ui->optim_warm_start_radio->setChecked(false);
    ui->optim_cold_start_radio->setChecked(true);

    // We show reoptimization frame :
    ui->reoptimization_frame->setEnabled(true);


    // We have to give a default solution file to use
    // for starting point generation :
    if (ui->reoptimization_lineEdit->text().isEmpty()) {
        QFileInfo default_sol(problem_dir,"problem.sol");
        if (default_sol.exists())
            ui->reoptimization_lineEdit->setText(default_sol.fileName());
        else {
            QStringList list_sol = problem_dir.entryList(QStringList("*.sol"), QDir::Files | QDir::Readable);
            if (!list_sol.isEmpty()) {
                default_sol.setFile(problem_dir,list_sol.at(0));
                ui->reoptimization_lineEdit->setText(default_sol.fileName());
            }
        }
    }

    return 0;
}

/**
  *\fn int MainWindow::setOptimFromSolFileWarm()
  * This method sets enables/disables items in the optimization
  * tab, depending if they are associated or not, with a solution
  * file generated starting point.
  */
int MainWindow::setOptimFromSolFileWarm()
{
    // We handle radiobuttons exclusivity :
    ui->optim_initfile_radio->setChecked(false);
    ui->optim_warm_start_radio->setChecked(true);
    ui->optim_cold_start_radio->setChecked(false);


    // We show reoptimization frame :
    ui->reoptimization_frame->setEnabled(true);


    // We have to give a default solution file to use
    // for starting point generation :
    if (ui->reoptimization_lineEdit->text().isEmpty()) {
        QFileInfo default_sol(problem_dir,"problem.sol");
        if (default_sol.exists())
            ui->reoptimization_lineEdit->setText(default_sol.fileName());
        else {
            QStringList list_sol = problem_dir.entryList(QStringList("*.sol"), QDir::Files | QDir::Readable);
            if (!list_sol.isEmpty()) {
                default_sol.setFile(problem_dir,list_sol.at(0));
                ui->reoptimization_lineEdit->setText(default_sol.fileName());
            }
        }
    }

    return 0;
}


/**
  *\fn void MainWindow::on_optim_cold_start_radio_clicked()
  * This slot is called when user clicks "cold start" button in optimization tab. It displays apropriate options for
  * this type of initialization.
  */
void MainWindow::on_optim_cold_start_radio_clicked()
{
    setOptimFromSolFileCold();
}

/**
  *\fn void MainWindow::on_optim_warm_start_radio_clicked()
  * This slot is called when user clicks "warm start" button in optimization tab. It displays apropriate options for
  * this type of initialization.
  */
void MainWindow::on_optim_warm_start_radio_clicked()
{
    setOptimFromSolFileWarm();
}


/**
  *\fn void MainWindow::on_optim_solfile_radio_clicked()
  * This slot is called when user clicks "start from init file"
  * button in optimization tab. It displays apropriate options for
  * this type of initialization.
  */
void MainWindow::on_optim_initfile_radio_clicked()
{
    setOptimFromInitFile();
}


void MainWindow::on_reoptimization_pushbutton_clicked()
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
    ui->reoptimization_lineEdit->setText(sol_file.fileName());
}


void MainWindow::on_paramid_checkBox_clicked()
{
    bool isChecked = ui->paramid_checkBox->isChecked();

    if (isChecked)
    {
        ui->observation_frame->setEnabled(true);
    }
    else
        ui->observation_frame->setEnabled(false);
}
