// This code is published under the Eclipse Public License
// File: main.cpp
// Authors:  Daphne Giorgi, Vincent Grelard, Pierre Martinon
// Inria Saclay and Cmap Ecole Polytechnique
// 2011-2016

#ifndef MAIN
#define MAIN
#include <qglobal.h>

#if (QT_VERSION < QT_VERSION_CHECK(5,0,0))
#include <QtGui>
#include <QPlastiqueStyle>
#else
#include <QtWidgets>
#endif

#include <QApplication>
#include "mainwindow.h"
#include <QDebug>


int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

#if (QT_VERSION < QT_VERSION_CHECK(5,0,0))
    a.setStyle(new QPlastiqueStyle());
#endif

    qint64 thisWindowPID = a.applicationPid();

    MainWindow w(thisWindowPID);

    w.show();

    w.menuBar()->setNativeMenuBar(false);

    return a.exec();
}

#endif
