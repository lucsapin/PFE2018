// Copyright (C) 2011 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: scalepicker.h
// Authors: Vincent Grelard

#include <qobject.h>
#include <qrect.h>

class QwtPlot;
class QwtScaleWidget;

class ScalePicker: public QObject
{
    Q_OBJECT
public:
    ScalePicker(QwtPlot *plot);
    virtual bool eventFilter(QObject *, QEvent *);

Q_SIGNALS:
    void clicked(int axis);

private:
    void mouseClicked(const QwtScaleWidget *);
};
