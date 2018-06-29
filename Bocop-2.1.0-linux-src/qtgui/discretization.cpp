// This code is published under the Eclipse Public License
// File: discretization.cpp
// Authors: Vincent Grelard, Daphne Giorgi, Pierre Martinon, Jinyan LIU
// INRIA 2011-2016

#include <iostream>
#include "mainwindow.h"
#include "ui_mainwindow.h"


using namespace std;


/**
  * \fn int MainWindow::LoadDiscretizationMethod(void)
  * Discretization tab doesn't exit any more.
  * This method is called when the definition tab is selected.
  * It loads all available discretization methods.
  */
int MainWindow::loadDiscretizationMethod(void)
{

    // If the combobox was already filled, we leave :
    if (ui->discretizationmethod_combo->count() > 0)
        return 0;

/*
 *
    // We get to bocop's main discretization directory :
//    QDir dir_disc = root_dir;
    disc_dir = root_dir;
    bool stat;
    stat = disc_dir.cd("core/disc");

    if (stat != true) {
        QMessageBox::critical(this, "Error", "Attempt to get available discretization methods failed. Please give a correct path for Bocop's root directory, it should contain a folder named \"disc\", where .disc files are located.");
        return 1;
    }

    // We list all .disc files in "disc" directory, and sort them by name :
    QStringList filters;
    filters << "*.disc";

    QStringList list_disc;
    list_disc = disc_dir.entryList(filters, QDir::Files | QDir::Readable, QDir::Name);

    if (list_disc.empty()){
        QMessageBox::critical(this, "Error", "Attempt to get available discretization methods failed. Please give a correct path for Bocop's root directory, it should contain a folder named \"disc\", where .disc files are located.");
        return 1;
    }

    ui->discretizationmethod_combo->clear();
    // We need to get information about all the discretization methods.
    // To do so, we read .disc files :
    foreach (QString disc_file, list_disc) {

//        QFileInfo file_info(dir_disc, disc_file); // path/to/dir_disc/disc_file
        QFileInfo file_info(disc_dir, disc_file); // path/to/disc_dir/disc_file
        if (file_info.isReadable()) {

            // We read the whole content of .disc file :
            QFile my_file(file_info.absoluteFilePath());
            my_file.open(QIODevice::ReadOnly);

            QStringList all_in_file;
            QTextStream flux(&my_file);

            while(! flux.atEnd())
                all_in_file << flux.readLine();

            my_file.close();

            // We look for information about the method :
            QRegExp regexp("^\\s?#\\s?method\\s?:(\\s|\\S)+",Qt::CaseInsensitive);
            int index = all_in_file.indexOf(regexp);

            QString itemName;
            if (index == -1)
                itemName = disc_file;
            else {
                // We remove the comment at the beginning of the captured string :
                itemName = regexp.cap().remove(QRegExp("^\\s?#\\s?method\\s?:",Qt::CaseInsensitive));
            }

            QString data_str = disc_file.remove(".disc");
            ui->discretizationmethod_combo->addItem(itemName,data_str);

        } // endif
    } // end foreach

*/

    ui->discretizationmethod_combo->clear();
    ui->discretizationmethod_combo->addItem("Euler (explicit, 1-stage, order 1)","euler");
    ui->discretizationmethod_combo->addItem("Euler (implicit, 1-stage, order 1)","euler_imp");
    ui->discretizationmethod_combo->addItem("[recommended] Midpoint (implicit, 1-stage, order 1)","midpoint");
    ui->discretizationmethod_combo->addItem("Gauss II (implicit, 2-stage, order 4)","gauss");
    ui->discretizationmethod_combo->addItem("Lobatto IIIC (implicit, 4-stage, order 6)","lobatto");

    // Now we get the type of discretization of the current problem :
    QString current_method;
    if (bocopDef == 0)
        current_method = "midpoint";
    else
        current_method = QString::fromStdString(bocopDef->methodDiscretization());

    // We look for the current method among the list of methods :
    int index = ui->discretizationmethod_combo->findData(QVariant(current_method));
    if (index < 0) index = 0;

    // And we set the combo box view on this entry :
    ui->discretizationmethod_combo->setCurrentIndex(index);

    // hide disabled feature: non uniform time discretization...
//    ui->editTimeGridButton->hide();
//    ui->subRangeDiscButton->hide();

    return 0;
}

/**
  * \fn int MainWindow::LoadDiscretizationTimes(void)
  * Discretization tab doesn't exit any more.
  * This method is called when the definition tab is selected.
  * It loads the current number of time steps
  */
int MainWindow::loadDiscretizationTimes(void)
{
    // If the line edit was already given a value, we don't want to modify it :
    if (!ui->timesteps_edit->text().isEmpty())
        return 0;

    // Now we get the number of time steps :
    int m_dimStep = 100;
    if (bocopDef != 0){
        if (bocopDef->isParamId())
            m_dimStep = bocopDef->dimStepsBeforeMerge();
        else
            m_dimStep = bocopDef->dimSteps();
    }

    QString m_dimStep_str; m_dimStep_str.setNum(m_dimStep);
    ui->timesteps_edit->setText(m_dimStep_str);

    // This modification should not be detected as a user's modification :
    ui->timesteps_edit->setModified( false );

    return 0;

}


void MainWindow::om_dimStepretizationmethod_combo_currentIndexChanged(int index)
{
    QVariant filename = ui->discretizationmethod_combo->itemData(index);
    if (filename == QVariant::Invalid)
        return;
}




