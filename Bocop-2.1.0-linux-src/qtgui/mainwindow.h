// This code is published under the Eclipse Public License
// File: mainwindow.h
// Authors: Vincent Grelard, Daphne Giorgi, Pierre Martinon, Jinyan LIU
// INRIA 2011-2017

#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#define VERSION "2.1.0"

#define INFTY 1e20

#include <QFileSystemWatcher>
#include <QMainWindow>
#include <QFileDialog>
#include <QMessageBox>
#include <QProcess>
#include <QSettings>
#include <QScrollArea>
#include <QScrollBar>
#include <QTextStream>
#include <QStandardItemModel>
#include <QLineEdit>
#include <QMap>
#include <QString>
#include <QtSvg/QSvgGenerator>
#include <QPrinter>
#include <QPainter>
#include <QItemSelectionModel>
//#include <QSvgGenerator>

#include "BocopDefinition.hpp"
#include "bocop_solution.hpp"
#include "bocop_save_definition.hpp"
#include "tools.hpp"

#include <qwt_plot.h>
#include <qwt_plot_curve.h>
#include <qwt_plot_zoomer.h>
#include <qwt_symbol.h>
#include <qwt_plot_picker.h>
#include <qwt_picker_machine.h>
#include <qwt_text_label.h>
//#include <qwt_plot_renderer.h>

#include "canvaspicker.hpp"
#include "scalepicker.h"


namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(const qint64 pid, QWidget *parent = 0);
    ~MainWindow();

    void saveTempCanvas();

private slots:
    void CreateActions(void);

    void openProblem(void);
    void openRecentFile();
    void newProblem(void);
    int saveProblem(void);
    void runProblem(void);
    void buildRelease();
    void buildDebug();
    void buildProblem(bool isDebug);
    void callMake();
    void cleanProblem();
    void on_actionAboutBocop_triggered();
    void setRootDir();
    void PrintGraph(void);


    void ReadProcessOutput();
    void ReadProcessError();
    void setCursorBottom(void);
    void runFinished(int, QProcess::ExitStatus);
    void cmakeFinished(int, QProcess::ExitStatus);
    void makeFinished(int, QProcess::ExitStatus);

    void on_MainTabs_currentChanged(int);

    // Definition slots
    void on_definition_toolbox_currentChanged(int index);
    void handleBoundsCheckboxes(QStandardItem*);
    void resizeBoundsTreeview();
    void userChangedDimension(void);

    // Discretization slots
    void om_dimStepretizationmethod_combo_currentIndexChanged(int index);

    // Initialization slots
    void on_constantInitRadioButton_clicked();
    void on_linearInitRadioButton_clicked();
    void on_splinesInitRadioButton_clicked();
    void onInitializationItemClicked(QModelIndex);
    void onInitializationXrangeEditFinished();
    void onInitializationYrangeEditFinished();
    void on_constantInitLineEdit_editingFinished();
    void on_fileInitRadioButton_clicked();
    void on_initFilePushButton_clicked();

    // Optimization slots
    void on_addoption_button_clicked();
    void on_optim_push_batch_clicked();
    void on_optim_push_single_clicked();
    void on_resetIpoptOptions_button_clicked();
    void on_optim_initfile_radio_clicked();
    void on_optim_cold_start_radio_clicked();
    void on_optim_warm_start_radio_clicked();
    void on_reoptimization_pushbutton_clicked();
    void on_paramid_checkBox_clicked();
    void on_obsFile_pushButton_clicked();
    void on_typeComboBox_currentIndexChanged(int index);
    void on_batchComboBox_currentIndexChanged(const QString &arg1);
    void convertToBatchStep(const int range);
    void convertToBatchRange(const double step);
    void on_batchNumberLineEdit_editingFinished();
    void on_batchStepLineEdit_editingFinished();

    // Visualization slots
    void on_loadsolfile_pushButton_clicked();
    void manageVisuClicked(QModelIndex);
    void on_visu_treeView_doubleClicked(const QModelIndex &index);
    void on_constantsDimensionLineEdit_editingFinished();
    void on_print_pushButton_clicked();
    void on_checkBoxControl_clicked();
    void on_checkBoxStageControl_clicked();
    void on_saveAsPushButton_clicked();
    void on_export_pushButton_clicked();
    void onVisuSelectionChanged(QItemSelection selected,QItemSelection deselected);
    void on_checkBoxShowVariablesBounds_clicked();

private:
    qint64 currentPID;
    Ui::MainWindow *ui;

    QDir problem_dir;
    QDir gui_dir;  // gui directory
    QDir root_dir; // bocop root directory
    QDir disc_dir; // disc directory
    QString version;
    QSettings settings;

    // process for Build and Run
    QProcess *cmake;
    QProcess *make;
    QProcess *run;


    bool flagRunInProgress;
    bool flagBuildInProgress;
    bool flagSaveInProgress;

    BocopDefinition *bocopDef;
    BocopSolution *bocopSol;
    BocopSaveDefinition *bocopSave;

    QStandardItemModel *model_names;
    QStandardItemModel *model_bounds;
    QStandardItemModel *model_constants;
    QStandardItemModel *model_init;
    QStandardItemModel *model_ipopt;
    QStandardItemModel *model_solution;

    QItemSelectionModel *visuSelectionModel;

    QString m_finalTimeName;

    QMap<QModelIndex, QString> type_init_map;
    QMap<QModelIndex, QVector<double> > time_init_map;
    QMap<QModelIndex, QVector<double> > value_init_map;

    QwtPlotZoomer **multi_zoom;
    QwtPlot **multi_qwtPlot;
    QwtPlotCurve *init_curve;
    QwtPlotCurve **multi_curve;
    CanvasPicker *pick_canvas;
    ScalePicker *pick_scale;
    int multiSize;

    bool optimTabClicked;

    enum { MaxRecentFiles = 10 };
    QAction *recentFileActs[MaxRecentFiles];

    void checkBocopDirectories(void);
    int loadBocopDefinition(void);
    int clearAllFields(void);

    void readSettings(void);
    void writeSettings(void);
    int checkRootDir(QString rootPath);
    int checkVersionNumber();

    void loadAll();

    bool createBocopDefaultFiles(QDir&);
    int copyBocopDefaultFile(QFileInfo&, const QString&);
    void dispMissingProblemFiles(void);
    void refreshStatusTipProblem(void);

    /** @name Saving */
    int saveDimensions(void);
    int saveNames(void);
    int saveBounds(void);
    int saveConstants(void);
    int saveIpoptOptions(void);
    int saveBatchOptions(void);
    int saveReOptimOptions(void);
    int saveParamId(void);
    int saveSolution(void);

    /** @name Dimensions */
    int loadDefinitionDimensions(void);
    int dimState();
    int dimControl();
    int dimAlgebraic();
    int dimOptimVars();
    int dimConstants();
    int dimInitFinalCond();
    int dimPathConstraints();
    int sizeExperiments();

    /** @name Names */
    int loadDefinitionNames(void);
    int initializeDefinitionNames(void);
    QString nameInTreeView(const int, const int, const QString);
    int addCategoryInNameModel(const int, const int, const QString&, const QString&, const QStringList&);
    int addSubCategoryInNameModel(QStandardItem*, const int, const QString&);
    QString nameState(const int i);
    QString nameControl(const int i);
    QString nameAlgebraic(const int i);
    QString nameOptimVar(const int i);
    QString nameConstant(const int i);
    QString nameInitFinalCond(const int i);
    QString namePathConstraint(const int i);

    /** @name Bounds */
    int loadDefinitionBounds(void);
    int initializeDefinitionBounds(void);
    int updateNamesInBoundsTreeView(void);
    int initializeBoundFields(QStandardItem*, QStandardItem*, QStandardItem*, const string, const double, const double);
    int addRowDefinitionBounds(QStandardItem*, const int, const QString&);

    /** @name Constants */
    int loadDefinitionConstants(void);
    int updateNamesInConstantsListView(void);

    /** @name Discretization */
    int loadDiscretizationMethod(void);
    int loadDiscretizationTimes(void);

    /** @name Initialization */
    int loadInitialization(void);
    int loadInitializationFiles(void);
    int loadInitializationNames(void);
    int initializeInitializationNames(void);
    int updateNamesInInitTreeView(void);
    int readInitializationFile(const QString, const int, QStandardItem*);
    int readOptimVarsInitializationFile(QStandardItem*, const int);

    int displayInitXminmax(bool);
    int displayInitYminmax(bool);

    int showConstantInitRadio(void);
    int showLinearInitRadio(void);
    int showSplinesInitRadio(void);
    int getSelectedInitItemIndex(QModelIndex&);
    int setInterpFromConstant(const double);
    int setConstantFromInterp(const double);

    int saveTempInitConstant(int);
    int saveTempInitInterp(int);
    int saveInitialization(void);
    int writeInitFile(const QString&, const int, const QStringList&);
    int writeInitDefaultFile(const QString&, const int);
    int writeInitOptimvarsFile(QStandardItem*);
    void setBoundsOnStartingPoint(QModelIndex sender);
    int plotConstantInitialization(const double);

    /** @name Optimization */
    int readIpoptOptions(void);
    int loadBatchOptions(void);
    int loadBatchNames(void);
    int checkBatchDirectory(void);
    int loadOptimization(void);
    int setOptimFromInitFile(void);
    int setOptimFromSolFileCold(void);
    int setOptimFromSolFileWarm(void);
    bool getLowAndUp(double& low, double& up);

    /** @name Solution */
    int loadSolutionFileName(void);
    int loadSolutionFile(void);
    int setNamesSolutionTreeView(void);
//    int addBoundsOnPlot(double lower, double upper, double type, QwtPlot * qwtplot, double time_min, double time_max);
    int addBoundsOnPlot(double lower, double upper, string type, QwtPlot * qwtplot, double time_min, double time_max);
    int addVariableBoundsOnPlot(int indice, QwtPlot * qwtplot, double time_min, double time_max);
    int addPathConstraintBoundsOnPlot(int indice, QwtPlot *visu_qwtPlot, double time_min, double time_max);
    int visuPlotTwoVariables(const QModelIndex&, const QModelIndexList& );
    int visuPlotOneVariable(const QModelIndex& );
    int multiplotOneVariable(const double *xData, double **yData, const int dimVar,const int indexVar, const int size);
    int multiplotAllVariables(const int dimVar, const int indexCategory);
    int unNormTimevectors(double* pointerSteps, double* pointerStages, const int dimSteps, const int dimStages);

    void updateRecentFileActions();
    QString strippedName(const QString &fullFileName);

};

#endif // MAINWINDOW_H
