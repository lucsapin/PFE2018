// Copyright (C) 2011-2014 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: scalepicker.cpp
// Authors: Vincent Grelard

#include <qevent.h>
#include <qwt_plot.h>
#include <qwt_scale_widget.h>
#include "scalepicker.h"

ScalePicker::ScalePicker(QwtPlot *plot):
    QObject(plot)
{
    for ( uint i = 0; i < QwtPlot::axisCnt; i++ )
    {
        QwtScaleWidget *scaleWidget = (QwtScaleWidget *)plot->axisWidget(i);
        if ( scaleWidget )
            scaleWidget->installEventFilter(this);
    }
}

bool ScalePicker::eventFilter(QObject *object, QEvent *e)
{
    if ( object->inherits("QwtScaleWidget") &&
         e->type() == QEvent::MouseButtonPress )
    {
        mouseClicked((const QwtScaleWidget *)object);
        return true;
    }

    return QObject::eventFilter(object, e);
}


/** \fn void ScalePicker::mouseClicked(const QwtScaleWidget *scale, const QPoint &pos)
  * This function is called by the event filter whenever a scale is clicked.
  * It gets the alignement of the clicked scale, and emits a "clicked" signal with
  * argument 0 if the scale is horizontal, or 1 if it is vertical.
  * Then this signal must be handled by user ScalePicker (see initialization.cpp).
  */
void ScalePicker::mouseClicked(const QwtScaleWidget *scale)
{
    int align = scale->alignment();

    if (align == QwtScaleDraw::TopScale
            || align == QwtScaleDraw::BottomScale) {
        emit clicked(0);
    }
    else if (align == QwtScaleDraw::LeftScale
             || align == QwtScaleDraw::RightScale) {
        emit clicked(1);
    }

}
