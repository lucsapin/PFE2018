// This code is published under the Eclipse Public License
// File: about.cpp
// Authors: Vincent Grelard, Daphne Giorgi, Pierre Martinon, Olivier Tissot, Jinyan LIU
// INRIA 2011-2016

#include <iostream>
#include "mainwindow.h"
#include "ui_mainwindow.h"


/**
  * \fn void MainWindow::checkRootDir(QString root_path)
  * This method is called to check if the root folder corresponding to root_path contains a folder "core" and a file "VERSION".
  * Then the version number registered in the interface must correspond to the version number written in the VERSION file.
  */
int MainWindow::checkRootDir(QString root_path)
{
    QDir testRootDir(root_path);

    // We check that the root_dir is a valid bocop root_dir
    if(!testRootDir.exists("core") || !testRootDir.exists("VERSION")) {
        QString msg = "Currently saved Bocop path: %0 seems incorrect.\nPlease select a valid Bocop install folder (should contain core/ and VERSION).";
        switch(QMessageBox::warning(this, "Wrong Bocop install folder", msg.arg(root_path),"Continue", "Quit", 0,0,1)){
        case 1:
            return 1;
            break;
        case 0:
            // prompt user for Bocop package folder
            root_path = QFileDialog::getExistingDirectory(this,QString("Select Bocop install folder"),testRootDir.absolutePath());

            // If root_path is empty it means that we pressed cancel:
            if (root_path.isEmpty() || root_path.isNull()) {
                return 2;
                break;
            }
            else{
                testRootDir.setPath(root_path);

                // ask until we get a valid Bocop install path
                if(!testRootDir.exists("core") || !testRootDir.exists("VERSION")) {
                    QMessageBox::warning(this, "Wrong Bocop install folder", "Install folder should contain a folder core/ and a file VERSION.");
                    int ok = checkRootDir(root_path);
                    if (ok != 0)
                        return 3;
                }
            }
            break;
        }
    }

    this->root_dir.setPath(root_path);

    return 0;
}



/**
  * \fn void MainWindow::checkVersionNumber()
  * This method is called to check if the version number registered in the interface
  * corresponds to the version number written in the README file.
  */
int MainWindow::checkVersionNumber()
{
    QString root_path = this->root_dir.absolutePath();

    // Read file VERSION
    string versionFromPackage;
    string fileName = root_dir.absolutePath().toStdString() + QString(QDir::separator()).toStdString()  + "VERSION";
    ifstream fileVERSION (fileName.c_str(), ios::in | ios::binary);

    if (!fileVERSION) {
        // if the opening failed
        QString msg = "Unable to open VERSION file in %0. Please check that file is readable.";
        QMessageBox::critical(this, "Opening failed",msg.arg(QString(fileName.c_str())));
        return 1;
    }

    fileVERSION >> versionFromPackage;
    fileVERSION.close();

    // version form GUI
    QString versionFromGui =  QString::fromStdString(VERSION);

    // Check that both versions match
    if (versionFromGui != QString::fromStdString(versionFromPackage)){
        QString msg = "WARNING: Version number mismatch between Package: %1 and Gui : %0 \n Please check which GUI is running, and the package folder (menu Help > Set root directory)";
        switch (QMessageBox::critical(this, "Version number mismatch", msg.arg(QString::fromStdString(VERSION))
                                      .arg(QString::fromStdString(versionFromPackage)),
                                      "Set package folder", "Continue anyway", 0,0,1))
        {
        case 1:
            return 3;
            break;
        case 0 :
            QString root_path;
            root_path = QFileDialog::getExistingDirectory(this,QString("Select a valid Bocop install folder, corresponding to version %0").arg(QString::fromStdString(VERSION)),
                                                          root_dir.absolutePath());
            int ok = checkRootDir(root_path);
            if (ok!=0)
                return 4;
            ok = checkVersionNumber();
            if (ok!=0)
                return 5;
            break;
        }
    }

    return 0;
}


/**
  * \fn void MainWindow::setRootDir()
  * This method is called to change the root folder, in the case we have multiple
  * Bocop versions installed (with the same release number).
  */
void MainWindow::setRootDir()
{
    // We change the root_path
    QString root_path = QFileDialog::getExistingDirectory(this,QString("Select a valid Bocop root folder"), root_dir.absolutePath());

    // If we pressed Cancel we interrupt
    if (root_path.isEmpty() || root_path.isNull()) {
        return;
    }

    // We check if the root dir is a valid root folder
    int ok = checkRootDir(root_path);
    if(ok!=0)
        return;

    // Finally we check that the release version number is the same of the gui
    // We open README file and read the first line, which should be BOCOP-X.X.X
    ok = checkVersionNumber();
    if(ok!=0)
        return;

    ui->MainTabs->setCurrentIndex(0);
    ui->mainTextBrowser->append(QString("<br> Root dir changed : <b>%0</b>").arg(root_dir.path()));
    ui->mainTextBrowser->append("<center><img src=\":/images/logo_400.png\" /></center>");
    setCursorBottom();

    // We save the values of these QDirs for next session of BOCOP :
    writeSettings();
}



/**
  *\fn void MainWindow::on_actionAboutBocop_triggered()
  * Show a message box which gives all the informations about the current Bocop version
  */
void MainWindow::on_actionAboutBocop_triggered()
{
    QMessageBox msgBox(this);
    msgBox.setWindowTitle("About Bocop");
    msgBox.setTextFormat(Qt::RichText); //this is what makes the links clickable
    QString l1 = QString("<b><big>Bocop %0</big></b> <br>").arg((QString::fromStdString(VERSION)));
    QString l2 = "A toolbox for optimal control problems <br>";
    QString l3 = "INRIA 2011-2016, code under Eclipse Public License <br>";
    QString l4 = "Website : <a href=\"http://bocop.org\" target=\"windows2\">bocop.org</a>";
    QString text = l1 + l2 + l3 + l4;
    msgBox.setText(text);
    msgBox.exec();
}
