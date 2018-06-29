// This code is published under the Eclipse Public License
// File: new_and_open.cpp
// Authors: Vincent Grelard, Daphne Giorgi, Pierre Martinon, Olivier Tissot, Jinyan LIU
// INRIA 2011-2016

#include <iostream>
#include "mainwindow.h"
#include "ui_mainwindow.h"


/**
  * \fn void MainWindow::OpenProblem(void)
  * This method loads an existing problem
  */
void MainWindow::openProblem(void)
{
    QString starting_path = "";
    QDir up_to_problems = problem_dir;
    if (up_to_problems.cdUp())
        starting_path = up_to_problems.absolutePath();

    QString new_def_file = QFileDialog::getOpenFileName(this,
                                                        tr("Please select the definition file of an existing problem"),
                                                        starting_path, tr("Definition Files (*.def)"));

    // If the user has not pressed cancel button
    if (new_def_file != NULL) {
        QFileInfo new_file_info(new_def_file);
        QString new_path = new_file_info.absolutePath();

        // We check that the folder exists :
        QFileInfo new_dir_info(new_path);
        if (!new_dir_info.isDir() || !new_dir_info.exists()) {
            this->problem_dir = "";
            QMessageBox::critical(this, QString("Invalid folder (%0)").arg(new_path),
                                  "Chosen folder does not seem to exist. Please try again.") ;
            return;
        }

        // We check if the folder contains a file named problem.def, if not it returns an error message
        QDir directory;
        directory.setPath(new_path);
        if (!directory.exists("problem.def") ) {
            this->problem_dir = "";
            QMessageBox::critical(this, QString("Invalid folder (%0)").arg(new_path),
                                  "Chosen folder does not seem to be a problem folder. No problem.def file found in the problem folder. Please try again.") ;
            return;
        }

        // We set the new value for the folder, keeping the previous value in memory :
        this->problem_dir.setPath(new_path);

        // We save the values of these QDirs for next session of BOCOP :
        writeSettings();

        refreshStatusTipProblem();
        ui->mainTextBrowser->append(QString("<br> Current problem has changed : <b>%0</b>").arg(problem_dir.path()));

        // We clear main window's fields :
        clearAllFields();

        // We try to load al the problem informations
        loadAll();

        setCursorBottom();

        ui->definition_toolbox->setCurrentIndex(0);
        if (!bocopDef->isParamId()){
            ui->separator_comboBox->setCurrentIndex(0);
            ui->methodComboBox->setCurrentIndex(0);
        }
    }
}


/**
  * \fn void MainWindow::openRecentFile()
  * This method opens an recent problem, and loads all
  * the information about the definition.
  */
void MainWindow::openRecentFile()
{
    QAction *action = qobject_cast<QAction *>(sender());
    if (action)
    {
        QString new_path  = action->data().toString();
        // If nothing is returned :
        if (new_path.isEmpty())
            return;

        // We check that the directory exists :
        QFileInfo new_dir_info(new_path);
        if (!new_dir_info.isDir() || !new_dir_info.exists())  {
            this->problem_dir = "";
            QMessageBox::critical(this, QString("Invalid directory (%0)").arg(new_path),
                                  "Chosen directory does not seem to exist. Please try again.") ;
            return;
        }

        // We check if the folder contains a file named problem.def, if not it returns an error message
        QDir directory;
        directory.setPath(new_path);
        if (!directory.exists("problem.def") )  {
            this->problem_dir = "";
            QMessageBox::critical(this, QString("Invalid directory (%0)").arg(new_path),
                                  "Chosen directory does not seem to be a problem directory. No problem.def file found in the problem directory. Please try again.") ;
            return;
        }

        // We set the new value for the directory, keeping the previous value in memory :
        this->problem_dir.setPath(new_path);

        // We save the values of these QDirs for next session of BOCOP :
        writeSettings();

        refreshStatusTipProblem();
        ui->mainTextBrowser->append(QString("<br> Current problem has changed : <b>%0</b>").arg(problem_dir.path()));

        // We clear main window's fields :
        clearAllFields();

        // We try to load all the problem informations
        loadAll();

        setCursorBottom();

        ui->definition_toolbox->setCurrentIndex(0);
        if (!bocopDef->isParamId()){
            ui->separator_comboBox->setCurrentIndex(0);
            ui->methodComboBox->setCurrentIndex(0);
        }
    }
}


/**
  * \fn void MainWindow::updateRecentFileActions()
  * This method updates the list of recently opened problems.
  */
void MainWindow::updateRecentFileActions()
{

    settings.beginGroup("Directories");
    QStringList files = settings.value("recentFileList").toStringList();

    int numRecentFiles = qMin(files.size(), (int)MaxRecentFiles);

    for (int i = 0; i < numRecentFiles; ++i) {
        QString text = tr("&%1 %2").arg(i + 1).arg(files[i]);
        recentFileActs[i]->setText(text);
        recentFileActs[i]->setData(files[i]);
        recentFileActs[i]->setVisible(true);
    }
    for (int j = numRecentFiles; j < MaxRecentFiles; ++j)
        recentFileActs[j]->setVisible(false);
    settings.endGroup();

}

QString MainWindow::strippedName(const QString &fullFileName)
{
    return QFileInfo(fullFileName).fileName();
}

/**
  *\fn bool MainWindow::CreateDefaultFiles(QDir& new_dir)
  * This method copies all bocop default files (found in
  * <root_dir>/examples/default into a new directory. It
  * is mainly used when creating a new problem.
  */
bool MainWindow::createBocopDefaultFiles(QDir& new_dir)
{
    if (!new_dir.exists())
        return false;

    // We create a list of files to copy :
    QStringList filenames;
    filenames << "criterion.tpp" << "dynamics.tpp" << "boundarycond.tpp" << "pathcond.tpp" << "measure.tpp"
              << "dependencies.tpp" << "dependencies.hpp" << "dependencies.cpp" << "problem.def" << "problem.bounds"
              << "problem.constants" << "ipopt.opt" << ".adolcrc" ;


    // We copy these files in the new directory :
    foreach(QString name, filenames) {

        QFileInfo file(new_dir,name);
        int stat = copyBocopDefaultFile(file, name);

        if (stat != 0)
            return false;
    }

    return true;
}

/**
  * \fn void MainWindow::newProblem(void)
  * This function creates a new problem. User has to give a new empty directory
  * where the definition files of the new problem will be stored. The method checks that
  * the new directory is empty, and writes default bocop files in it.
  */
void MainWindow::newProblem(void)
{
    // default location :
    QString starting_path = "";
    QDir up_to_problems = problem_dir;
    if (up_to_problems.cdUp())
        starting_path = up_to_problems.absolutePath();

    // We ask for a new empty directory
    QString new_path;
    new_path = QFileDialog::getExistingDirectory(this,"Please create a new (empty) directory to store your problem definition", starting_path);

    // If nothing is returned :
    if (new_path.isEmpty())
        return;

    // We check that the chosen directory is empty :
    QDir new_dir(new_path);
    QStringList lsdir = new_dir.entryList(QDir::Files);
    if (!lsdir.isEmpty())  {
        QMessageBox::critical(this,QString("Directory %0 is not empty").arg(new_path),"The directory for the new problem should be empty. Please try again : create a directory to store your new problem's files, and select it.");
        return;
    }

    // We copy default bocop files in this directory :
    bool ok;
    ok = this->createBocopDefaultFiles(new_dir);

    // We set the new values :
    if (ok != true) {
        QMessageBox::critical(this,"Failed to copy files","An error occurred when trying to copy default files into the new problem directory.");
        return;
    }

    // If we get to this point, everything worked, the new directory
    // can be used as the problem directory :
    problem_dir = new_dir;

    // We save the values of these QDirs for next session of BOCOP :
    writeSettings();

    refreshStatusTipProblem();
    ui->mainTextBrowser->append(QString("<br> Current problem has changed : <b>%0</b>").arg(problem_dir.path()));

    // We clear main window's fields :
    clearAllFields();

    setCursorBottom();

    ui->definition_toolbox->setCurrentIndex(0);
    ui->separator_comboBox->setCurrentIndex(0);
    ui->methodComboBox->setCurrentIndex(0);
}
