// Copyright (C) 2011-2014 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: canvaspicker.hpp
// Authors: Vincent Grelard, Daphne Giorgi

#ifndef CANVASPICKER_H
#define CANVASPICKER_H

#include <qobject.h>
#include <QPointF>

//#include "mainwindow.h"

class QPoint;
class QCustomEvent;
class QwtPlot;
class QwtPlotCurve;
class MainWindow;

class CanvasPicker: public QObject
{
    Q_OBJECT
public:
    CanvasPicker(QwtPlot *plot, MainWindow *mainWindow);
    virtual bool eventFilter(QObject *, QEvent *);
    virtual bool event(QEvent *);

    void clear(void);


private:
    void select(const QPoint &);
    void remove_point(const QPoint &);
    void add_point(const QPointF &);
    void move(const QPoint &);
    void moveBy(int dx, int dy);

    void showCursor(bool enable);
    void shiftPointCursor(bool up);
    void shiftCurveCursor(bool up);

    QwtPlot* plot() { return (QwtPlot *)parent(); }
    const QwtPlot* plot() const { return (QwtPlot *)parent(); }

    QwtPlotCurve *d_selectedCurve;
    int d_selectedPoint;
    MainWindow *m_mainWindow;
    bool m_isCtrlDown;
};

#endif
