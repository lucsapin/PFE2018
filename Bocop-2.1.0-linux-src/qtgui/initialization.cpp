// This code is published under the Eclipse Public License
// File: initialization.cpp
// Authors: Vincent Grelard, Daphne Giorgi, Pierre Martinon, Jinyan LIU
// Inria 2011-2015

#include "mainwindow.h"
#include "ui_mainwindow.h"


int MainWindow::loadInitialization(void)
{
    int status ;

    status = loadInitializationNames();
    if (status != 0)
        return status;

    status = loadInitializationFiles();
    if (status != 0)
        return status;


    // For constant initialization, hide parts related to the interpolation inits
    if ( ui->constantInitRadioButton->isChecked() || ui->fileInitRadioButton->isChecked() ) {
        ui->constantInitFrame->show();
        ui->initQwtPlot->hide();
        ui->initLinescheckBox->hide();
//        displayInitXminmax(false);
        displayInitYminmax(false);
    }
    else if (ui->linearInitRadioButton->isChecked() || ui->splinesInitRadioButton->isChecked() ){
        ui->initQwtPlot->show();
//        displayInitXminmax(true);
        displayInitYminmax(true);
//        ui->initLinescheckBox->show();
        ui->initLinescheckBox->hide();
        ui->constantInitFrame->hide();
    }
    else
    {
        ui->constantInitRadioButton->hide();
        ui->splinesInitRadioButton->hide();
        ui->linearInitRadioButton->hide();
        // ***
        ui->fileInitRadioButton->hide();
        ui->initFileLineEdit->hide();
        ui->initFilePushButton->hide();

        ui->initQwtPlot->hide();
        ui->constantInitFrame->hide();

        ui->initLinescheckBox->hide();
        displayInitXminmax(false);
        displayInitYminmax(false);
    }

    return 0;
}


/**
  *\fn int MainWindow::loadInitializationNames(void)
  * This method is called to refresh the initialization tree, in case
  * the number of variables has changed. It adds or deletes rows according
  * to the new dimensions.
  */
int MainWindow::loadInitializationNames(void)
{
    // Refresh the names list for the initialization treeview :
    int stat;
    stat = loadDefinitionDimensions();
    if (stat != 0)
        return 2;
    stat = loadDefinitionNames();
    if (stat != 0)
        return 3;

    // If the init model is empty, we initialize it :
    if (model_init == 0) {
        int stat = initializeInitializationNames();
        if (stat != 0)
            return stat;
    }

    QList<int> dims;
    dims << dimState() << dimControl() << dimAlgebraic() << dimOptimVars();

    QStringList default_names;
    default_names << "state" << "control" << "algebraic" << "parameter";

    // Now we check if the dimensions have changed, in order to resize the model :
    for (int i=0; i<4; ++i) {

        if (i>model_init->rowCount())
            break;

        // We get the category in model_init :
        QStandardItem* it_init = model_init->item(i,0);
        it_init->setEditable(false);

        if (it_init != 0) {
            // adding subcategory rows :
            if (it_init->rowCount() < dims.at(i)) {

                for (int j=it_init->rowCount(); j<dims.at(i); ++j) {
                    QString name_item = nameInTreeView(i,j,default_names.at(i));
                    QStandardItem *child_name = new QStandardItem(name_item);
                    child_name->setEditable( false );
                    it_init->setChild(j, 0, child_name );
                }
            }

            // deleting subcategory rows :
            if (it_init->rowCount() > dims.at(i)) {
                for (int j=it_init->rowCount(); j>dims.at(i); --j)
                    it_init->removeRow(j-1);
            }
        }
    }

    // If the names_model has changed, we update the names in init model :
    // In case the above loop was not entered, or for the items that
    // are not affected by this loop, we need to update the names :
    updateNamesInInitTreeView();

    // Finally we pass the model to the treeview :
    ui->initTreeView->setModel(model_init);
    ui->initTreeView->header()->hide();

    return 0;
}


/**
  *\fn int MainWindow::updateNamesInInitTreeView(void)
  * This method gets the names in the names model, and set them
  * in the init model. If users change a name in the name model,
  * the new value will appear in the init model after a call to
  * this function
  */
int MainWindow::updateNamesInInitTreeView(void)
{
    // Default names if a problem occurs while reading names model :
    QStringList default_names;
    default_names << "state" << "control" << "algebraic" << "optimvar";


    // We go through all the bounds model to update the values :
    for (int cat=0; (cat<model_init->rowCount() && cat<model_names->rowCount()); ++cat) {
        QStandardItem * category = model_init->item(cat,0);

        for (int subcat=0; subcat<category->rowCount(); ++subcat) {
            QStandardItem * subcategory = category->child(subcat,0);
            QString name_sub = nameInTreeView(cat, subcat, default_names.at(cat));
            subcategory->setText(name_sub);
        }
    }

    return 0;
}


/**
  *\fn int MainWindow::initializeInitializationNames(void)
  * When first going in the starting point tree, this method
  * allows to initialize the names of the variables.
  */
int MainWindow::initializeInitializationNames(void)
{

    model_init = new QStandardItemModel(4,1);

    QStringList default_names;
    default_names << "state" << "control" << "algebraic" << "optimvar";

    // We set a new list with the increasing sum of the dimensions :
    QList<int> add_dim;
    add_dim << 0 << dimState() << dimState()+dimControl() << dimState()+dimControl()+dimAlgebraic();
    add_dim << dimState()+dimControl()+dimAlgebraic()+dimOptimVars();


    // We get the names, we go through all the categories in the names model :
    for (int i=0; i<4; ++i) {

        if (i>model_names->rowCount())
            break;

        // We get the category in model_names :
        QStandardItem* it = model_names->item(i,0);
        if (it != 0) {

            // We create a new item for the category, with the text from model_names,
            // but which will be used by model_init :
            QStandardItem *category = new QStandardItem(it->text());
            category->setEditable(false);

            model_init->setItem(i,category);

            // We get the children in model_names :
            for (int j=0;j<it->rowCount();++j) {

                // Subcategory (j-th child) :
                QString name_sub = nameInTreeView(i, j, default_names.at(i));

                QStandardItem *subcategory = new QStandardItem(name_sub);
                subcategory->setEditable(false);

                // we add this item to the current category :
                category->setChild(j,0,subcategory);

            } //endfor (j, subcategory)

        } // endif (category exists)

    } // endfor (i, category)

    return 0;
}


/**
  *\fn int MainWindow::loadInitializationFiles()
  * This method loads bocop initialization files of the
  * current problem. It reads the contents of each file, and
  * saves it into the treeview data.
  */
int MainWindow::loadInitializationFiles()
{
    bool ok;
    QString name_init_dir = "init";

    // We check that an "init" folder exists in the problem directory :
    if (!problem_dir.exists(name_init_dir)) {
        // if it doesn't exist, we create it :
        ok = problem_dir.mkdir(name_init_dir);
        if (!ok) {
            QMessageBox::critical(this, "Failed to create initialization directory","Attempt to create a new directory for the current problem initialization files failed." ) ;
            return 1;
        }
    }

    // We go to the init directory :
    QDir init_dir(problem_dir);
    ok = init_dir.cd(name_init_dir);
    if (!ok) {
        QMessageBox::critical(this, "Failed to go to initialization directory",QString("Cannot go to %0 in your problem directory.").arg(name_init_dir) ) ;
        return 2;
    }


    QStringList category_names;
    category_names << "state" << "control" << "algebraic" << "optimvars";

    // Browse the treeview model and fetch initialization for each variable.
    for (int cat=0; cat<model_init->rowCount()-1; ++cat) {

        QStandardItem* it = model_init->item(cat,0);

        // we go through all the subcategories (variables) :
        for (int subcat=0; subcat<it->rowCount(); ++subcat) {

            // Subcategory (j-th child) :
            QStandardItem* it_child = it->child(subcat,0);

            if (it_child != 0) {

                // If no data has already been associated with the current item,
                // we load the associated file to get the starting point :
                if (!type_init_map.contains(it_child->index())
                        || !time_init_map.contains(it_child->index())
                        || !value_init_map.contains(it_child->index())) {

                    // We read initialization data for this variable :
                    int status = readInitializationFile(category_names.at(cat), subcat, it_child);

                    // If an error occurred, we set a default (constant) initialization :
                    if (status != 0) {
                        QVector<double> t_default(1);
                        QVector<double> vec_default(1);
                        t_default[0] = -1;
                        vec_default[0] = 0.1; //DO NOT USE 0 AS DEFAULT STARTING VALUE (RISK OF MATH ERRORS) !
                        time_init_map[it_child->index()] = t_default;
                        value_init_map[it_child->index()] = vec_default;
                        type_init_map[it_child->index()] = "constant";
                    }
                }
            }
        }
    }

    // Now we read the starting point for the optimization parameters :
    int ind = model_init->rowCount()-1; // last item
    QStandardItem* it_optimvars = model_init->item(ind,0);

    // we go through all the subcategories (variables) :
    for (int subcat=0; subcat<it_optimvars->rowCount(); ++subcat) {

        // Subcategory (j-th child) :
        QStandardItem* it_child = it_optimvars->child(subcat,0);

        if (it_child != 0) {

            // If no data has already been associated with the current item,
            // we load the associated file to get the starting point :
            if (!type_init_map.contains(it_child->index())
                    || !time_init_map.contains(it_child->index())
                    || !value_init_map.contains(it_child->index())) {

                // We read initialization data for this variable :
                int status = readOptimVarsInitializationFile(it_optimvars, subcat);

                // If an error occurred, we set a default initialization (NOT 0 !)
                if (status != 0) {

                    QVector<double> t_default(1);
                    QVector<double> vec_default(1);
                    t_default[0] = -1;
                    vec_default[0] = 0.1;
                    time_init_map[it_child->index()] = t_default;
                    value_init_map[it_child->index()] = vec_default;
                    type_init_map[it_child->index()] = "optimvar";
                }
            }
        }
    }

    connect(ui->initTreeView, SIGNAL(clicked(QModelIndex)), this, SLOT(onInitializationItemClicked(QModelIndex)));

    return 0;
}


/**
  *\fn int MainWindow::readOptimVarsInitializationFile(QStandardItem * item)
  * This method allows to read current problem optimization parameters starting point
  * file. "item" is the optimization variable parent item in the initialization tree.
  * We set an starting point for each of its children.
  */
int MainWindow::readOptimVarsInitializationFile(QStandardItem * item, const int subcat)
{
    // Name of the initialization file to read :
    QString filename = QString("optimvars.init");

    QDir init_dir(problem_dir);
    bool ok = init_dir.cd("init");
    if (!ok)
        return 1;

    // We open the file to read it :
    QFileInfo f_init_info(init_dir,filename);
    if (!f_init_info.exists())
        return 2;

    QFile f_init(f_init_info.absoluteFilePath());
    f_init.open(QIODevice::ReadOnly);

    QStringList all_in_file;
    QTextStream flux(&f_init);

    while(! flux.atEnd())
        all_in_file << flux.readLine();

    f_init.close();

    // Now we get the data from this file (remove empty and commented lines) :
    for (int i=0; i<all_in_file.size(); ++i) {
        if (all_in_file.at(i).startsWith("#") || all_in_file.at(i).isEmpty()) {
            // we remove this line from the list :
            all_in_file.removeAt(i);
            // we removed i-th line, the i+1-th line takes its place, we
            // have to check it in the next iteration :
            i--;
        }
    }

    // We take the value of the optimization variable corresponding to the item subcat
    // If it doesn't exist we set it to 0.1 (SAME AS ABOVE, DO NOT USE 0: RISK OF MATH ERRORS)
    QVector<double> t(1); t[0] = -1;
    QVector<double> vec(1);

    if (subcat+1 < all_in_file.size())
    {
        QString line = all_in_file.at(subcat+1);
        double val = line.toDouble(&ok);
        if (!ok)
            vec[0] = 0.1;
        else
            vec[0] = val;
    }
    else {
        vec[0] = 0.1;
    }

    // Each child item is associated to an optimization variable,
    // we save the value for this item :
    QStandardItem* it_child = item->child(subcat,0);
    type_init_map[it_child->index()] = "optimvar";
    time_init_map[it_child->index()] = t;
    value_init_map[it_child->index()] = vec;

    return 0;
}


/**
  *\fn int MainWindow::readInitializationFile(const QString name, const int i, QStandardItem * item)
  * This method reads the initialization file for variable type "name", and index "i".
  * The file should have standard name "<name>.<i>.init", be located in "init" folder
  * in the problem directory, and have standard reading format
  */
int MainWindow::readInitializationFile(const QString name, const int i, QStandardItem * item)
{

    QVector<double> t, vec;

    // Name of the initialization file to read :
    QString filename = QString("%0.%1.init").arg(name).arg(i);

    QDir init_dir(problem_dir);
    bool ok = init_dir.cd("init");
    if (!ok)
        return 1;

    // We open the file to read it :
    QFileInfo f_init_info(init_dir,filename);
    if (!f_init_info.exists())
        return 2;

    QFile f_init(f_init_info.absoluteFilePath());
    f_init.open(QIODevice::ReadOnly);

    QStringList all_in_file;
    QTextStream flux(&f_init);

    while(! flux.atEnd())
        all_in_file << flux.readLine();

    f_init.close();

    // Now we get the data from this file (remove empty and commented lines) :
    for (int i=0; i<all_in_file.size(); ++i) {
        if (all_in_file.at(i).startsWith("#") || all_in_file.at(i).isEmpty()) {
            // we remove this line from the list :
            all_in_file.removeAt(i);
            // we removed i-th line, the i+1-th line takes its place, we
            // have to check it in the next iteration :
            i--;
        }
    }

    // The first data line should contain the type of initialization :
    QString init_type = all_in_file.at(0);
    type_init_map[item->index()] = init_type;

    // If the initialization is constant, the value of the constant
    // should be in the 2nd non commented line :
    if (init_type == "constant") {
        double val = all_in_file.at(1).toDouble(&ok);
        if (!ok)
            return 3;

        // We allocate space for the interpolation points, and values :
        t.resize(1);
        vec.resize(1);

        t[0] = -1.0;
        vec[0] = val;
    }

    if (init_type == "linear" || init_type == "splines") {

        int nb_points = all_in_file.at(1).toInt(&ok);
        if (!ok)
            return 4;

        // We check that the number of points is correct :
        if (nb_points != all_in_file.size()-2)
            return 5;

        // We allocate space for the interpolation points, and values :
        t.resize(nb_points);
        vec.resize(nb_points);

        // Now we get the points :
        QStringList splitted_line;

        for (int i=2; i<all_in_file.size(); ++i) {
            splitted_line.clear();
            splitted_line = all_in_file.at(i).split(QRegExp("\\s+"));
            if (splitted_line.size()<2) {
                //                delete[] t;
                //                delete[] vec;
                t.clear();
                vec.clear();
                return 6;
            }

            t[i-2] = splitted_line.at(0).toDouble();
            vec[i-2] = splitted_line.at(1).toDouble();
        }
    }

    // Finally we set these new values in the init maps.
    //    if (t != 0 && vec != 0) {
    time_init_map[item->index()] = t;
    value_init_map[item->index()] = vec;
    //    }
    return 0;
}


void MainWindow::on_constantInitRadioButton_clicked()
{
    // We check the calling button, and uncheck the others :
    showConstantInitRadio();
    // We temporary save the current initialization
    saveTempCanvas();
}


void MainWindow::on_linearInitRadioButton_clicked()
{
    // We check the calling button, and uncheck the others :
    showLinearInitRadio();
    // We temporary save the current initialization
    saveTempCanvas();
    // We replot the curve according to the interpolation chosen
    QModelIndex sender = ui->initTreeView->currentIndex();
    onInitializationItemClicked(sender);

    // We read the the Ymin and Ymax from y axis
    QwtInterval interval = ui->initQwtPlot->axisInterval(QwtPlot::yLeft);
    double default_min = interval.minValue();
    double default_max = interval.maxValue();

    ui->initYmin_lineEdit->setText(QString::number(default_min));
    ui->initYmax_lineEdit->setText(QString::number(default_max));
}


void MainWindow::on_splinesInitRadioButton_clicked()
{
    // We check the calling button, and uncheck the others :
    showSplinesInitRadio();
    // We temporary save the current initialization
    saveTempCanvas();
    // We replot the curve according to the interpolation chosen
    QModelIndex sender = ui->initTreeView->currentIndex();
    onInitializationItemClicked(sender);

    // We read the the Ymin and Ymax from y axis
    QwtInterval interval = ui->initQwtPlot->axisInterval(QwtPlot::yLeft);
    double default_min = interval.minValue();
    double default_max = interval.maxValue();

    ui->initYmin_lineEdit->setText(QString::number(default_min));
    ui->initYmax_lineEdit->setText(QString::number(default_max));
}


void MainWindow::on_fileInitRadioButton_clicked()
{

    // We show the plot and bounds frame
    ui->initQwtPlot->show();
    ui->constantInitFrame->hide();
    displayInitXminmax(false);
    displayInitYminmax(true);
    ui->initFileLineEdit->setEnabled(true);
    ui->initFilePushButton->setEnabled(true);

}


void MainWindow::on_initFilePushButton_clicked()
{

    QString starting_path = problem_dir.absolutePath();

    QString new_path = QFileDialog::getOpenFileName(this,
                                                    tr("Please select a data file to load"),
                                                    starting_path);
    // If nothing is returned :
    if (new_path.isEmpty())
        return;

    // We check that the file is readable :
    QFileInfo init_file(new_path);
    if (!init_file.isReadable()) {
        QMessageBox::critical(this, "Error", "Cannot read the specified data file");
        return;
    }

    // First we get currently selected item
    QModelIndex index;
    getSelectedInitItemIndex(index);

    // Then we retrieve the variable thanks to its position in the tree
    QStringList default_names;
    default_names << "state" << "control" << "algebraic" << "optimvars" ;
    QString varName = default_names.at(index.column());
    varName += "." + QString::number(index.row()) + ".init";
    // We need absolute path
    varName = problem_dir.path() + "/init/" + varName;

    // We copy the file in init directory and rename it (if it exists already we save backup
    if(QFile::exists(varName)) {
        // If .back alread exists
        if(!QFile::rename(varName,varName+".backup")) {
            QFile::remove(varName +".backup");
            QFile::rename(varName, varName+".backup");
        }
    }

    // We set the path in the line edit
    ui->initFileLineEdit->setText(init_file.absoluteFilePath());
    // Copy init file into init respository with right name
    QFile::copy(init_file.absoluteFilePath(),varName);

    // Load this file into memory
    QStandardItem* it = model_init->item(index.column(),0);
    // Subcategory (j-th child) :
    QStandardItem* it_child = it->child(index.row(),0);
    readInitializationFile(default_names.at(index.column()),index.row(),it_child);

//    // Select interpolation type
//    if(type_init_map[index]=="linear") {
//        ui->linearInitRadioButton->setChecked(true);
//        showLinearInitRadio();
//    }
//    else {
//        ui->splinesInitRadioButton->setChecked(true);
//        showSplinesInitRadio();
//    }

    // We temporary save the current initialization
    saveTempCanvas();
    // We replot the curve according to the interpolation chosen
    QModelIndex sender = ui->initTreeView->currentIndex();
    onInitializationItemClicked(sender);

}

/**
  *\fn void MainWindow::onInitializationItemClicked(QModelIndex sender)
  * This method is called when a treeview item is clicked. It loads the
  * item associated data, and displays it in the initialization frame.
  */
void MainWindow::onInitializationItemClicked(QModelIndex sender)
{
    // If the calling item is a top category, we leave :
    QModelIndex index_parent;
    index_parent = sender.parent();
    if (index_parent == QModelIndex())
    {
        ui->constantInitRadioButton->hide();
        ui->splinesInitRadioButton->hide();
        ui->linearInitRadioButton->hide();
        // hide import file option
        ui->fileInitRadioButton->hide();
        ui->initFileLineEdit->hide();
        ui->initFilePushButton->hide();

        ui->initQwtPlot->hide();
        ui->constantInitFrame->hide();
        displayInitXminmax(false);
        displayInitYminmax(false);

        return;
    }

    QString type = type_init_map[sender];
    if (type == "linear" || type == "splines") {
        if (type == "linear")
            showLinearInitRadio();
        if (type == "splines")
            showSplinesInitRadio();

        // We detach existing items from the plot :
        ui->initQwtPlot->detachItems(QwtPlotItem::Rtti_PlotItem,false);

        // We create a new item to display :
        if (init_curve != 0)
            delete init_curve;

        init_curve = new QwtPlotCurve("Initialization Curve");

        if (pick_canvas != 0)
        {
            delete pick_canvas;
            pick_canvas = 0;
        }

        if (pick_scale != 0)
        {
            delete pick_scale;
            pick_scale = 0;
        }

        if (ui->splinesInitRadioButton->isChecked())
        {
            init_curve->setStyle(QwtPlotCurve::Lines);
            init_curve->setCurveAttribute(QwtPlotCurve::Fitted, true);
        }

        QBrush main_brush(Qt::white);
        ui->initQwtPlot->setCanvasBackground(main_brush);

        pick_canvas = new CanvasPicker(ui->initQwtPlot, this);
        pick_scale = new ScalePicker(ui->initQwtPlot);

        // We show the frames related to the plot bounds :
//        displayInitXminmax(true);
        displayInitYminmax(true);

        // Now we have to load item associated data :
        if (time_init_map.contains(sender) && value_init_map.contains(sender)) {
            QVector<double> t = time_init_map[sender];
            QVector<double> val = value_init_map[sender];

            init_curve->setSamples(t,val);

            QPen pen(Qt::blue);
            pen.setWidth(2);
            init_curve->setPen(pen);

            QColor c(0,0,1);
            init_curve->setPen(c);
            init_curve->setSymbol(new QwtSymbol(QwtSymbol::Ellipse,Qt::lightGray, QColor(Qt::blue), QSize(8, 8)));

            init_curve->attach(ui->initQwtPlot);

            setBoundsOnStartingPoint(sender);

            // finally, refresh the plot
            ui->initQwtPlot->setAxisAutoScale(QwtPlot::yLeft, false);
            ui->initQwtPlot->replot();

            // We update the axes to fit the new plot :
            ui->initQwtPlot->setAxisAutoScale(QwtPlot::yLeft,true);
            ui->initQwtPlot->setAxisAutoScale(QwtPlot::xBottom,true);
            ui->initQwtPlot->setAxisTitle(QwtPlot::xBottom, "Normalized time");
            ui->initQwtPlot->setAxisTitle(QwtPlot::yLeft, model_init->itemFromIndex(sender)->text());
            ui->initQwtPlot->updateAxes();

            // we disable autoscaling, because it interfers with CanvasPicker (when
            // a point is moved, the scale is adjusted, which is hard to manipulate
            // for the user) :
            ui->initQwtPlot->setAxisAutoScale(QwtPlot::yLeft,false);
            ui->initQwtPlot->setAxisAutoScale(QwtPlot::xBottom,false);
        }
    }
    else {
        // We load the associated data :
        if (value_init_map.contains(sender)) {
            QVector<double> val = value_init_map[sender];
            ui->constantInitLineEdit->setText(QString::number(val[0],'g',15));
        }
        else
            ui->constantInitLineEdit->setText(QString::number(0.0));

        showConstantInitRadio();

        ui->initQwtPlot->setAxisTitle(QwtPlot::xBottom, "Normalized time");
        ui->initQwtPlot->setAxisTitle(QwtPlot::yLeft, model_init->itemFromIndex(sender)->text());
        ui->initQwtPlot->updateAxes();

        if (type == "optimvar") {
            ui->constantInitRadioButton->hide();
            ui->splinesInitRadioButton->hide();
            ui->linearInitRadioButton->hide();
            // hide import file option
            ui->fileInitRadioButton->hide();
            ui->initFileLineEdit->hide();
            ui->initFilePushButton->hide();

            ui->initQwtPlot->hide();
        }
    }
}


/**
  *\fn int MainWindow::showConstantInitRadio(void)
  * This method is called when the current variable has
  * constant initialization, to show only constant
  * related frames
  */
int MainWindow::showConstantInitRadio(void)
{
    ui->constantInitRadioButton->show();
    ui->splinesInitRadioButton->show();
    ui->linearInitRadioButton->show();
    // comment it to hide import file option
//    ui->fileInitRadioButton->show();
//    ui->initFileLineEdit->show();
//    ui->initFilePushButton->show();
    ui->fileInitRadioButton->setChecked(false);
//    ui->fileInitRadioButton->setEnabled(false);
    ui->initFileLineEdit->setEnabled(false);
    ui->initFilePushButton->setEnabled(false);
    ui->initFileLineEdit->clear();

    ui->constantInitRadioButton->setChecked(true);
    ui->linearInitRadioButton->setChecked(false);
    ui->splinesInitRadioButton->setChecked(false);

    // If the current initialization is an interpolation, we
    // have to make a guess...
    // First we get currently selected item :
    QModelIndex index;
    int stat = getSelectedInitItemIndex(index);
    if (stat != 0)
        return 1;

    // If selected item is unknown in the map :
    if (!type_init_map.contains(index)) {
        setConstantFromInterp(0.0);
    }
    // If current type is not "constant", we guess a constant value :
    else if (type_init_map[index] != "constant") {
        QVector<double> values = value_init_map[index];
        double average=0.0;

        // average over all the vector elements :
        foreach(double val, values)
            average += val;
        average /= values.size();

        setConstantFromInterp(average);
    }

    ui->initLinescheckBox->hide();

    displayInitXminmax(false);
    displayInitYminmax(false);

    ui->constantInitFrame->show();

    // We show the constant plot
    // We get the value in the line edit :
    double val;
    bool ok;
    val = ui->constantInitLineEdit->text().toDouble(&ok);
    if (!ok) {
        QMessageBox::critical(this, "Cannot save constant initialization",
                              "Attempt to save the current initialization (constant) failed, "
                              "because line edit value could not be converted to double...");
        return 2;
    }

    plotConstantInitialization(val);

    return 0;
}


/**
  *\fn int MainWindow::plotConstantInitialization(const double val)
  * This method plot a constant initialization
  */
int MainWindow::plotConstantInitialization(const double val)
{
    // We allocate two vectors to store the interpolation values :
    QVector<double> t_default(2);
    QVector<double> vec_default(2);

    // We give default values :
    t_default[0] = 0;
    t_default[1] = 1;

    vec_default[0] = val;
    vec_default[1] = val;

    // We detach existing items from the plot :
    ui->initQwtPlot->detachItems(QwtPlotItem::Rtti_PlotItem,false);

    // We create a new item to display :
    if (init_curve != 0)
        delete init_curve;

    init_curve = new QwtPlotCurve("Initialization Curve");

    // we delete existing event handlers :
    if (pick_canvas != 0)
    {
        delete pick_canvas;
        pick_canvas = 0;
    }

    if (pick_scale != 0)
    {
        delete pick_scale;
        pick_scale = 0;
    }

    QBrush main_brush(Qt::white);
    ui->initQwtPlot->setCanvasBackground(main_brush);

    init_curve->setSamples(t_default,vec_default);

    QPen pen(Qt::blue);
    pen.setWidth(2);
    init_curve->setPen(pen);

    QColor c(0,0,1);
    init_curve->setPen(c);

    init_curve->attach(ui->initQwtPlot);

    // finally, refresh the plot
    ui->initQwtPlot->replot();

    ui->initQwtPlot->setAxisAutoScale(QwtPlot::yLeft,true);
    ui->initQwtPlot->updateAxes();
    ui->initQwtPlot->setAxisAutoScale(QwtPlot::yLeft,false);

    // Finally, we set the new axis scale on the plot :
    ui->initQwtPlot->setAxisAutoScale(QwtPlot::xBottom, false);
    ui->initQwtPlot->setAxisScale(QwtPlot::xBottom,0,1);
    ui->initQwtPlot->replot();

    ui->initQwtPlot->show();

    return 0;
}

/**
  *\fn int MainWindow::setConstantFromInterp(const double)
  * This method sets a constant initialization from an existing
  * interpolation. It simply computes the average.
  */
int MainWindow::setConstantFromInterp(const double val)
{

    //    QVector<double> t_default(1); t_default[0] = -1;
    //    QVector<double> vec_default(1); vec_default[0] = val;

    //    time_init_map[index] = t_default;
    //    value_init_map[index] = vec_default;
    //    type_init_map[index] = "constant";

    //    // We refresh the plot with the new value found :
    //    onInitializationItemClicked(index);

    ui->constantInitLineEdit->setText(QString::number(val,'g',15));

    return 0;
}


/**
  *\fn int MainWindow::showLinearInitRadio(void)
  * This method is called when the current variable has
  * linear interpolation initialization, to show only
  * linear related frames
  */
int MainWindow::showLinearInitRadio(void)
{
    ui->constantInitRadioButton->show();
    ui->splinesInitRadioButton->show();
    ui->linearInitRadioButton->show();

    ui->constantInitRadioButton->setChecked(false);
    ui->linearInitRadioButton->setChecked(true);
    ui->splinesInitRadioButton->setChecked(false);

    // comment it to hide import file button
//    ui->fileInitRadioButton->show();
//    ui->initFileLineEdit->show();
//    ui->initFilePushButton->show();
    ui->fileInitRadioButton->setChecked(false);
    ui->initFileLineEdit->setEnabled(false);
    ui->initFilePushButton->setEnabled(false);
//    ui->initFileLineEdit->clear();


   // displayInitXminmax(true);
    displayInitYminmax(true);

    //    ui->initLinescheckBox->show();

    // If the current initialization is not an interpolation, we
    // have to make a guess...
    // First we get currently selected item :
    QModelIndex index;
    int stat = getSelectedInitItemIndex(index);
    if (stat != 0)
        return 1;

    if (!type_init_map.contains(index)) {
        setInterpFromConstant(0.5);
    }
    else if (type_init_map[index] == "constant") {
        QVector<double> values = value_init_map[index];
        double val = 0.5;
        if (!values.isEmpty())
            val = values.at(0);
        setInterpFromConstant(val);
    }

    // We hide the constant init field, and show the plot :
    ui->initQwtPlot->show();
    //    ui->initLinescheckBox->show();
    ui->constantInitFrame->hide();

    return 0;
}


/**
  *\fn int MainWindow::showSplinesInitRadio(void)
  * This method is called when the current variable has
  * splines interpolation initialization, to show only
  * splines related frames
  */
int MainWindow::showSplinesInitRadio(void)
{
    ui->constantInitRadioButton->show();
    ui->splinesInitRadioButton->show();
    ui->linearInitRadioButton->show();

    ui->constantInitRadioButton->setChecked(false);
    ui->linearInitRadioButton->setChecked(false);
    ui->splinesInitRadioButton->setChecked(true);

    // comment it to hide import file button
//    ui->fileInitRadioButton->show();
//    ui->initFileLineEdit->show();
//    ui->initFilePushButton->show();
    ui->fileInitRadioButton->setChecked(false);
    ui->initFileLineEdit->setEnabled(false);
    ui->initFilePushButton->setEnabled(false);
//    ui->initFileLineEdit->clear();

//    displayInitXminmax(true);
    displayInitYminmax(true);

    //    ui->initLinescheckBox->show();

    // If the current initialization is not an interpolation, we
    // have to make a guess...
    // First we get currently selected item :
    QModelIndex index;
    int stat = getSelectedInitItemIndex(index);
    if (stat != 0)
        return 1;

    if (!type_init_map.contains(index)) {
        setInterpFromConstant(0.5);
    }
    else if (type_init_map[index] == "constant") {
        QVector<double> values = value_init_map[index];
        double val = 0.5;
        if (!values.isEmpty())
            val = values.at(0);
        setInterpFromConstant(val);
    }

    // We hide the constant init field, and show the plot :
    ui->initQwtPlot->show();
    //    ui->initLinescheckBox->show();
    ui->constantInitFrame->hide();


    return 0;
}


/**
  *\fn int MainWindow::setInterpFromConstant(const double)
  * This method sets a default interpolation initialization from an existing
  * constant initialization. It sets two interpolation points with the same
  * value taken from the constant initialization.
  */
int MainWindow::setInterpFromConstant(const double val)
{
    // We allocate two vectors to store the interpolation values :
    QVector<double> t_default(2);
    QVector<double> vec_default(2);

    // We give default values :
    t_default[0] = 0;
    t_default[1] = 1;

    vec_default[0] = val;
    vec_default[1] = val;

    // We detach existing items from the plot :
    ui->initQwtPlot->detachItems(QwtPlotItem::Rtti_PlotItem,false);

    // We create a new item to display :
    if (init_curve != 0)
    {
        delete init_curve;
        init_curve = 0;
    }

    init_curve = new QwtPlotCurve("Initialization Curve");

    // we delete existing event handlers :
    if (pick_canvas != 0)
    {
        delete pick_canvas;
        pick_canvas = 0;
    }

    if (pick_scale != 0)
    {
        delete pick_scale;
        pick_scale = 0;
    }

    QBrush main_brush(Qt::white);
    ui->initQwtPlot->setCanvasBackground(main_brush);

    // We create new event handlers
    pick_canvas = new CanvasPicker(ui->initQwtPlot, this);
    pick_scale = new ScalePicker(ui->initQwtPlot);

    // We hide the frames related to the plot bounds :
    //    displayInitXminmax(false);
    //    displayInitYminmax(false);

    // When users click on the scales, we display plot bounds :
    //    connect(pick_scale,SIGNAL(clicked(int)),this,SLOT(onInitializationScaleClicked(int)));

    init_curve->setSamples(t_default,vec_default);

    QPen pen(Qt::blue);
    pen.setWidth(2);
    init_curve->setPen(pen);

    QColor c(0,0,1);
    init_curve->setPen(c);
    init_curve->setSymbol(new QwtSymbol(QwtSymbol::Ellipse,
                                        Qt::lightGray, QColor(Qt::blue), QSize(8, 8)));

    init_curve->attach(ui->initQwtPlot);

    // finally, refresh the plot
    ui->initQwtPlot->replot();

    ui->initQwtPlot->setAxisAutoScale(QwtPlot::yLeft,true);
    ui->initQwtPlot->setAxisAutoScale(QwtPlot::xBottom,true);
    ui->initQwtPlot->updateAxes();

    ui->initQwtPlot->setAxisAutoScale(QwtPlot::yLeft,false);
    ui->initQwtPlot->setAxisAutoScale(QwtPlot::xBottom,false);

    return 0;
}


/**
  *\fn void MainWindow::saveTempCanvas()
  * This method is called whenever we change the initialization. It saves the current plot, or constant value
  * in the associated array. File writing is not included...
  */
void MainWindow::saveTempCanvas()
{

    // Optimization parameters :
    if (ui->constantInitRadioButton->isHidden()
            && ui->linearInitRadioButton->isHidden()
            && ui->splinesInitRadioButton->isHidden())
        saveTempInitConstant(1);
    else {

        // Constant initialization
        if (ui->constantInitRadioButton->isChecked()
                && !ui->linearInitRadioButton->isChecked()
                && !ui->splinesInitRadioButton->isChecked())
            saveTempInitConstant(0);

        // Linear interpolation :
        else if (!ui->constantInitRadioButton->isChecked()
                 && ui->linearInitRadioButton->isChecked()
                 && !ui->splinesInitRadioButton->isChecked())
            saveTempInitInterp(0);

        // Splines interpolation :
        else if (!ui->constantInitRadioButton->isChecked()
                 && !ui->linearInitRadioButton->isChecked()
                 && ui->splinesInitRadioButton->isChecked())
            saveTempInitInterp(1);
    }
}

/**
  *\fn int MainWindow::saveTempInitConstant(int type)
  * This method gets the constant currently displayed in the
  * initialization frame, and saves it in the associated array
  * for a later display. The method doesn't write any file, it
  * does a temporary save. This method works to save either a
  * constant or optimization variable initialization.
  */
int MainWindow::saveTempInitConstant(int type)
{
    // We get the type of initialization :
    QString type_str;
    if (type == 0)
        type_str = "constant";
    else if (type == 1)
        type_str = "optimvar";
    else {
        return 1;
    }


    // We check that the constant initialization frame is visible :
    if (ui->constantInitFrame->isHidden()) {
        return 1;
    }

    // Now we get the value in the line edit :
    double val;
    bool ok;
    val = ui->constantInitLineEdit->text().toDouble(&ok);
    if (!ok) {
        QMessageBox::critical(this, "Cannot save constant initialization",
                              "Attempt to save the current initialization (constant) failed, "
                              "because line edit value could not be converted to double...");
        return 2;
    }

    // We need to know which variable is currently selected in the tree :
    QModelIndexList ind_list = ui->initTreeView->selectionModel()->selectedIndexes();
    if (ind_list.isEmpty()) {
        return 3;
    }

    QModelIndex index = ind_list.at(0);
    if (!value_init_map.contains(index)) {
        return 4;
    }

    // Finally we can create vectors to store the values for the new
    // constant initialization :
    QVector<double> t(1);
    QVector<double> vec(1);

    t[0] = -1.0;
    vec[0] = val;

    // We store the new initialization in the dedicated maps :
    time_init_map[index] = t;
    value_init_map[index] = vec;
    type_init_map[index] = type_str;

    return 0;
}


/**
  *\fn int MainWindow::getSelectedInitItemIndex(QModelIndex*)
  * This method returns the item which is currently selected
  * in the initialization tree.
  */
int MainWindow::getSelectedInitItemIndex(QModelIndex& ind)
{
    QModelIndexList ind_list = ui->initTreeView->selectionModel()->selectedIndexes();
    if (ind_list.isEmpty()) {
        QMessageBox::warning(this, "Cannot get selected item",
                             "Attempt to get currently selected initialization item "
                             "failed. Please select an item in the tree...");
        return 1;
    }

    ind =  ind_list.at(0);
    return 0;
}


/**
  *\fn int MainWindow::saveTempInitInterp(int interp_type)
  * This method gets the values currently plotted in the initialization
  * frame, and saves it in the dedicated map. The method doesn't write any file, it
  * does a temporary save.
  */
int MainWindow::saveTempInitInterp(int interp_type)
{
    // First we need to get the type of interpolation :
    QString interp_type_str;
    if (interp_type == 0)
        interp_type_str = "linear";
    else if (interp_type == 1)
        interp_type_str = "splines";
    else {
        return 1;
    }

    // We check that the constant initialization frame is visible :
    if (ui->initQwtPlot->isHidden()) {
        return 2;
    }

    // Then we have to get the current plot values :
    size_t nb_items = init_curve->dataSize();
    QwtSeriesData< QPointF > * list = init_curve->data();

    if (nb_items < 2) {
        return 3;
    }


    if (nb_items != list->size()) {
        return 4;
    }

    // We store these points in vectors :
    QVector<double> t(nb_items);
    QVector<double> vec(nb_items);

    for(size_t i=0; i<nb_items; ++i) {
        QPointF plot_item = list->sample(i);

        t[i] = plot_item.x();
        vec[i] = plot_item.y();
    }

    // We check that the items are in ascending order :
    for (int i=1; i<(int)t.size(); ++i) {
        if (t[i] <= t[i-1]) {
            QMessageBox::warning(this, "Cannot save interpolation initialization",
                                 "Attempt to save the current initialization failed, "
                                 "because x coordinates are not in ascending order...");
            return 5;
        }
    }

    QModelIndex index;
    int stat = getSelectedInitItemIndex(index);
    if (stat != 0) return 6;

    if (!value_init_map.contains(index)) {
        return 7;
    }

    // We store the new initialization in the dedicated maps :
    time_init_map[index] = t;
    value_init_map[index] = vec;
    type_init_map[index] = interp_type_str;

    return 0;
}


/**
  *\fn int MainWindow::saveInitialization(void)
  * This method gets the initialization values from the dedicated
  * maps, and write bocop initialization files with these values.
  */
int MainWindow::saveInitialization(void)
{
    if (model_init == 0)
        loadInitialization();

    // We get the dimensions of the problem :
    QList<int> dims;
    dims << dimState() << dimControl() << dimAlgebraic() << dimOptimVars();

    QStringList default_names;
    default_names << "state" << "control" << "algebraic" << "optimvars" ;

    // We check that the init model is filled :
    if (model_init == 0) {
        QMessageBox::critical(this, "Cannot write starting point files",
                              "Attempt to write the current initialization failed, "
                              "because initialization tree seems to be empty...");
        return 1;
    }

    // Text to write in the init file :
    QStringList text;

    // We skip through all initialization items in the init model,
    // to get the data associated to each variable :
    for (int cat=0; cat<3; cat++) {

        if (cat>model_init->rowCount())
            break;

        // We get the category in model_init :
        QStandardItem* it_init = 0;
        it_init = model_init->item(cat,0);

        if (it_init == 0) {
            for (int i=0; i<dims.at(cat);++i)
                writeInitDefaultFile(default_names.at(cat),i);
            return 2;
        }

        for (int subcat=0; subcat<it_init->rowCount(); ++subcat) {
            QString name_var = nameInTreeView(cat, subcat, default_names.at(cat));

            text << "# Starting point file.";
            text << "# This file contains the values of the initial points";
            text << QString("# for variable %0").arg(name_var);
            text << "";
            text << "# Type of initialization :";

            // Each subcategory should be associated to a variable :
            QStandardItem* it_child = it_init->child(subcat,0);

            if (!type_init_map.contains(it_child->index())
                    || !time_init_map.contains(it_child->index())
                    || !value_init_map.contains(it_child->index()))
                writeInitDefaultFile(default_names.at(cat),subcat);
            else {

                // Type of initialization of the current variable :
                QString type = type_init_map[it_child->index()];

                // If invalid type :
                if (type != "constant" && type != "linear" && type != "splines")
                    writeInitDefaultFile(default_names.at(cat),subcat);
                else {
                    // We write the type of initialization :
                    text << type;
                    text << "";

                    QVector<double> t = time_init_map[it_child->index()];
                    QVector<double> vec = value_init_map[it_child->index()];

                    // If constant starting point, we simply write one value :
                    if (type == "constant") {
                        text << "# Constant value for the starting point :";
                        text << QString::number(vec.at(0),'g',15);
                    }

                    // Else : interpolation, we write all points :
                    else {
                        if (t.size() != vec.size())
                            writeInitDefaultFile(default_names.at(cat),subcat);
                        else {
                            text << "# Number of interpolation points :";
                            text << QString::number(t.size());
                            text << "";

                            text << "# Interpolation points for the starting point :";
                            for (int i=0; i<time_init_map[it_child->index()].size();++i)
                                text << QString::number(t.at(i),'g',15) + " " + QString::number(vec.at(i),'g',15);
                        }
                    }

                    // Now we have to write the init files (if text has been filled with values) :
                    if (text.size() >= 8) {
                        int stat = writeInitFile(default_names.at(cat), subcat, text );
                        if (stat != 0) {
                            QMessageBox::critical(this, "Cannot write starting point files",
                                                  "Attempt to write the current initialization failed, "
                                                  "Please check an init folder exists (and is writable) "
                                                  "in your problem directory...");
                            return 2;
                        }
                    }
                }

            }

            text.clear();

        }
    }

    // Now we write the optimvars :
    // We get the category in model_init :
    if (dimOptimVars() != 0 )
    {
        QStandardItem* it_optimvar = 0;
        it_optimvar = model_init->item(3,0);

        int stat = writeInitOptimvarsFile(it_optimvar);
        if (stat != 0) {
            QMessageBox::critical(this, "Cannot write starting point files",
                                  "Attempt to write optimization parameters initialization failed");
            return 2;
        }
    }

    return 0;
}


/**
  *\fn int MainWindow::writeInitFile(const QString &, const int)
  * This method writes standard initialization file with the given text.
  */
int MainWindow::writeInitFile(const QString & category, const int i, const QStringList& text)
{
    // Name of the initialization file to write :
    QString filename = QString("%0.%1.init").arg(category).arg(i);

    QDir init_dir(problem_dir);
    bool ok = init_dir.cd("init");
    if (!ok)
        return 1;

    // We open the file to read it :
    QFileInfo f_init_info(init_dir,filename);

    QFile f_init(f_init_info.absoluteFilePath());
    if (!f_init.open(QIODevice::WriteOnly | QIODevice::Text))
        return 2;

    QTextStream out(&f_init);
    for (int j=0; j<text.size(); ++j)
        out << text.at(j) << endl;

    f_init.close();

    return 0;
}


/**
  *\fn int MainWindow::writeInitDefaultFile(const QString &, const int)
  * THis method allows to write a default initialization (starting point)
  * file for the current problem. It sets the starting point for i-th variable
  * of category "cat".
  */
int MainWindow::writeInitDefaultFile(const QString & cat, const int i)
{

    QString name_var = QString("%0.%1").arg(cat).arg(i);

    // We set a default text to write in the init file :
    QStringList default_text;
    default_text << "# This is a DEFAULT starting point file.";
    default_text << "# This file contains a default constant";
    default_text << QString("#  initialization for variable %0").arg(name_var);
    default_text << "";
    default_text << "# Type of initialization :";
    default_text << "constant";
    default_text << "";
    default_text << "# Constant value :";
    default_text << "0.0";

    // Finally we can write the file :
    int stat = writeInitFile(cat, i, default_text);

    return stat;

}


/**
  *\fn int MainWindow::writeInitOptimvarsFile(QStandardItem*)
  * This function gets the values of the optimization parameters
  * starting point, and writes it in "optimvar.init". The format
  * of "optimvar.init" is slightly different from other init files,
  * that's why we use a dedicated function.
  */
int MainWindow::writeInitOptimvarsFile(QStandardItem* item)
{
    // Text to write in the optimvars initialization file :
    QStringList text;

    text << "# Optimization parameters starting point file.";
    text << "# This file contains initialization values";
    text << "# for all optimization parameters";
    text << "";
    text << "# Number of optimization parameters :";

    // We get the number of optimization parameters :
    int dim_optimvars = dimOptimVars();
    if (dim_optimvars < 0)
        return 1;

    text << QString::number(dim_optimvars);
    text << "";

    // Then we get initial values for all optimization parameters :
    text << "# Initial values :";

    for (int i=0; i<dimOptimVars(); ++i) {
        if (i<item->rowCount()) {
            QStandardItem* it_child = item->child(i,0);

            if (!type_init_map.contains(it_child->index())
                    || !time_init_map.contains(it_child->index())
                    || !value_init_map.contains(it_child->index()))
                text << "0.0";
            else {
                if (type_init_map[it_child->index()] != "optimvar")
                    text << "0.0";
                else {
                    QVector<double> vec = value_init_map[it_child->index()];
                    if (!vec.isEmpty())
                        text << QString::number(vec[0],'g',15);
                }
            }
        }
        else
            text << "0.0";
    }

    // Now we can write this text in the optimvars init file :

    // Name of the initialization file to write :
    QString filename = QString("optimvars.init");

    QDir init_dir(problem_dir);
    bool ok = init_dir.cd("init");
    if (!ok)
        return 2;

    // We open the file to read it :
    QFileInfo f_init_info(init_dir,filename);

    QFile f_init(f_init_info.absoluteFilePath());
    if (!f_init.open(QIODevice::WriteOnly | QIODevice::Text))
        return 3;

    QTextStream out(&f_init);
    for (int j=0; j<text.size(); ++j)
        out << text.at(j) << endl;

    f_init.close();


    return 0;
}


void MainWindow::on_constantInitLineEdit_editingFinished()
{
    saveTempCanvas();

    showConstantInitRadio();

    QModelIndex index;
    int stat = getSelectedInitItemIndex(index);
    if (stat != 0)
        return;

    ui->initQwtPlot->setAxisTitle(QwtPlot::xBottom, "Normalized time");
    ui->initQwtPlot->setAxisTitle(QwtPlot::yLeft, model_init->itemFromIndex(index)->text());
    ui->initQwtPlot->updateAxes();

}


/**
  *\fn int MainWindow::displayInitXminmax(bool on)
  * This method shows/hide all items related to x scale values
  * (xmin and xmax labels and lineedits) in the initialization
  * tab.
  */
int MainWindow::displayInitXminmax(bool on)
{
    ui->initXmax_lineEdit->clear();
    ui->initXmin_lineEdit->clear();

    ui->initXmin_lineEdit->setText(QString::number(0));
    ui->initXmax_lineEdit->setText(QString::number(1));
    ui->initXmin_lineEdit->setEnabled(false);
    ui->initXmax_lineEdit->setEnabled(false);

    ui->initXmax_label->setVisible(on);
    ui->initXmax_lineEdit->setVisible(on);
    ui->initXmin_label->setVisible(on);
    ui->initXmin_lineEdit->setVisible(on);

    return 0;
}

/**
  *\fn int MainWindow::displayInitYminmax(bool on)
  * This method shows/hides all items related to y scale values
  * (ymin and ymax labels and lineedits) in the initialization
  * tab.
  */
int MainWindow::displayInitYminmax(bool on)
{
    ui->initYmax_lineEdit->clear();
    ui->initYmin_lineEdit->clear();

    ui->initYmax_label->setVisible(on);
    ui->initYmax_lineEdit->setVisible(on);
    ui->initYmin_label->setVisible(on);
    ui->initYmin_lineEdit->setVisible(on);


    return 0;
}


/**
  *\fn void MainWindow::onInitializationXrangeEditFinished()
  * This slot is called when user has finished editing a lineedit
  * related to x bounds (xmin or xmax) on the initialization plot.
  * it sets the new scale on the plot according to the new value.
  */
void MainWindow::onInitializationXrangeEditFinished()
{

    // We get the current interval on the x axis :
    QwtInterval interval = ui->initQwtPlot->axisInterval(QwtPlot::xBottom);
    double default_min = interval.minValue();
    double default_max = interval.maxValue();

    // Then we get the new values (in the lineedits) :
    double x_min = default_min;
    QString x_min_str = ui->initXmin_lineEdit->text();

    double x_max = default_max;
    QString x_max_str = ui->initXmax_lineEdit->text();

    // We convert these new values into double :
    bool ok;
    if (!x_min_str.isEmpty()) {
        x_min = x_min_str.toDouble(&ok);
        if (!ok)
            x_min = default_min;
        else{
            if (x_min < 0)
            {
                ui->initXmin_lineEdit->blockSignals(true);
                QMessageBox::warning(this, "Minimum abscissa lower than zero", "Only the normalized interval time [0,1] will be taken into account.");
                ui->initXmin_lineEdit->clear();
                ui->initXmin_lineEdit->blockSignals(false);
            }
        }
    }

    if (!x_max_str.isEmpty()) {
        x_max = x_max_str.toDouble(&ok);
        if (!ok)
            x_max = default_max;
        else{
            if (x_max > 1)
            {
                ui->initXmax_lineEdit->blockSignals(true);
                QMessageBox::warning(this, "Maximum abscissa greater than one", "Only the normalized interval time [0,1] will be taken into account.");
                ui->initXmax_lineEdit->clear();
                ui->initXmax_lineEdit->blockSignals(false);
            }
        }
    }

    // If lower bound greater than upper bound, we leave :
    if (x_min >= x_max) {
        ui->initXmin_lineEdit->clear();
        ui->initXmax_lineEdit->clear();

        QMessageBox::warning(this, "Invalid bounds", "Lower bound is greater or equal to upper bound...");
        return;
    }

    // Finally, we set the new axis scale on the plot :
    ui->initQwtPlot->setAxisAutoScale(QwtPlot::xBottom, false);
    ui->initQwtPlot->setAxisScale(QwtPlot::xBottom,x_min,x_max);
    ui->initQwtPlot->replot();
}


/**
  *\fn void MainWindow::onInitializationYrangeEditFinished()
  * This slot is called when user has finished editing a lineedit
  * related to y bounds (ymin or ymax) on the initialization plot.
  * it sets the new scale on the plot according to the new value.
  */
void MainWindow::onInitializationYrangeEditFinished()
{
    // We get the current interval on the y axis :
    QwtInterval interval = ui->initQwtPlot->axisInterval(QwtPlot::yLeft);
    double default_min = interval.minValue();
    double default_max = interval.maxValue();

    // Then we get the new values (in the lineedits) :
    double y_min = default_min;
    QString y_min_str = ui->initYmin_lineEdit->text();

    double y_max = default_max;
    QString y_max_str = ui->initYmax_lineEdit->text();

    // We convert these new values into double :
    bool ok;
    if (!y_min_str.isEmpty()) {
        y_min = y_min_str.toDouble(&ok);
        if (!ok)
            y_min = default_min;
    }

    if (!y_max_str.isEmpty()) {
        y_max = y_max_str.toDouble(&ok);
        if (!ok)
            y_max = default_max;
    }

    // If lower bound greater than upper bound, we leave :
    if (y_min > y_max) {
        ui->initYmin_lineEdit->clear();
        ui->initYmax_lineEdit->clear();
        QMessageBox::warning(this, "Invalid bounds","Lower bound is greater or equal to upper bound...");
        return;
    }

    // Finally, we set the new axis scale on the plot :
    ui->initQwtPlot->setAxisAutoScale(QwtPlot::yLeft, false);
    ui->initQwtPlot->setAxisScale(QwtPlot::yLeft,y_min,y_max);
    ui->initQwtPlot->replot();
}


/**
  *\fn void MainWindow::setBoundsOnStartingPoint(QModelIndex sender)
  * This method is called to add bounds on a plot for starting point.
  * It changes the values of the Ymin and the Ymax and enables or not the line editing
  */
void MainWindow::setBoundsOnStartingPoint(QModelIndex sender)
{
    // We add the bounds : we set the Ymin and Ymax values if there are bounds on the variables

    // If the bounds model is empty, we initialize it :
    if (model_bounds == 0) {
        int stat = initializeDefinitionBounds();
        if (stat != 0)
            return ;

        // Items behaviour is handled by a slot :
        QObject::connect(model_bounds, SIGNAL(itemChanged(QStandardItem*)),this, SLOT(handleBoundsCheckboxes(QStandardItem*)));
    }

    // We search first for the bounds in model_bounds
    //QStandardItem* item =  model_bounds->itemFromIndex(sender);
    int parent_row = sender.parent().row();
    int sender_row = sender.row();
    QStandardItem* parent = model_bounds->item(parent_row);

    // We define the items where we will find the informations about the bounds (if it's checked and what is its value)
    QStandardItem* it_equ = parent->child(sender_row,1);
    QStandardItem* it_low = parent->child(sender_row,2);
    QStandardItem* it_upp = parent->child(sender_row,3);

    bool ok;

    double lower, upper;

    if (it_equ->checkState() == Qt::Checked) // if there is an equality bound
    {
        lower = it_equ->data(Qt::EditRole).toDouble(&ok);

        if (!ok) {
            QMessageBox::critical(this, "Invalid value", QString("Invalid equality bound for variable [%0;%1]. Make sure you entered a numerical value and not a formula (ex: type 0.5 instead of 1/2).").arg(parent_row).arg(sender_row));
            return;
        }

        upper = lower;

        ui->initYmin_lineEdit->setText(QString::number(lower));
        ui->initYmax_lineEdit->setText(QString::number(upper));
    }
    else if (it_low->checkState() == Qt::Checked && it_upp->checkState() == Qt::Checked) // if there is a lower and a upper bound
    {
        lower = it_low->data(Qt::EditRole).toDouble(&ok);
        if (!ok) {
            QMessageBox::critical(this, "Invalid value", QString("Invalid lower bound for variable [%0;%1]. Make sure you entered a numerical value and not a formula (ex: type 0.5 instead of 1/2).").arg(parent_row).arg(sender_row));
            return;
        }
        upper = it_upp->data(Qt::EditRole).toDouble(&ok);
        if (!ok) {
            QMessageBox::critical(this, "Invalid value", QString("Invalid upper bound for variable [%0;%1]. Make sure you entered a numerical value and not a formula (ex: type 0.5 instead of 1/2).").arg(parent_row).arg(sender_row));
            return;
        }
        ui->initYmin_lineEdit->setText(QString::number(lower));
        ui->initYmax_lineEdit->setText(QString::number(upper));
    }
    else
    {
        if (it_low->checkState() == Qt::Checked ) // if there is just a lower bound
        {
            lower = it_low->data(Qt::EditRole).toDouble(&ok);
            if (!ok) {
                QMessageBox::critical(this, "Invalid value", QString("Invalid lower bound for variable [%0;%1]. Make sure you entered a numerical value and not a formula (ex: type 0.5 instead of 1/2).").arg(parent_row).arg(sender_row));
                return;
            }

            upper = lower + 1;

            ui->initYmin_lineEdit->setText(QString::number(lower));
            ui->initYmax_lineEdit->setText(QString::number(upper));
        }
        else if (it_upp->checkState() == Qt::Checked )
        {
            upper = it_upp->data(Qt::EditRole).toDouble(&ok);
            if (!ok) {
                QMessageBox::critical(this, "Invalid value", QString("Invalid upper bound for variable [%0;%1]. Make sure you entered a numerical value and not a formula (ex: type 0.5 instead of 1/2).").arg(parent_row).arg(sender_row));
                return;
            }
            lower = upper -1;

            ui->initYmin_lineEdit->setText(QString::number(lower));
            ui->initYmax_lineEdit->setText(QString::number(upper));
        }
    }
    //    onInitializationYrangeEditFinished();
}
