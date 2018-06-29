// Copyright (C) 2011-2014 INRIA.
// All Rights Reserved.
// This code is published under the Eclipse Public License
// File: canvaspicker.cpp
// Authors: Vincent Grelard

#include <qapplication.h>
#include <qevent.h>
#include <QKeyEvent>
#include <qwhatsthis.h>
#include <qpainter.h>
#include <qwt_plot.h>
#include <qwt_symbol.h>
#include <qwt_scale_map.h>
#include <qwt_plot_canvas.h>
#include <qwt_plot_curve.h>
#include <qwt_plot_directpainter.h>
#include "canvaspicker.hpp"
#include "mainwindow.h"

CanvasPicker::CanvasPicker(QwtPlot *plot, MainWindow *mainWindow):
    QObject(plot),
    d_selectedCurve(NULL),
    d_selectedPoint(-1),
    m_mainWindow(mainWindow)
{
    //QwtPlotCanvas *canvas = plot->canvas();
    QwtPlotCanvas *canvas = qobject_cast<QwtPlotCanvas*>(plot->canvas());

    canvas->installEventFilter(this);

    // We want the focus, but no focus rect. The
    // selected point will be highlighted instead.

    canvas->setFocusPolicy(Qt::StrongFocus);
#ifndef QT_NO_CURSOR
    canvas->setCursor(Qt::PointingHandCursor);
#endif
    canvas->setFocusIndicator(QwtPlotCanvas::ItemFocusIndicator);
    canvas->setFocus();

    const char *text =
            "All points can be moved using the left mouse button "
            "or with these keys:\n\n"
            "- Up:\t\tSelect next curve\n"
            "- Down:\t\tSelect previous curve\n"
            "- Left, -:\tSelect next point\n"
            "- Right, +:\tSelect previous point\n"
            "- 7, 8, 9, 4, 6, 1, 2, 3:\tMove selected point";
    canvas->setWhatsThis(text);

    shiftCurveCursor(true);
}


void CanvasPicker::clear(void)
{
    showCursor(false);
    d_selectedCurve = NULL;
    d_selectedPoint = -1;
}

bool CanvasPicker::event(QEvent *e)
{
    if ( e->type() == QEvent::User )
    {
        showCursor(true);
        return true;
    }

    return QObject::event(e);
}

bool CanvasPicker::eventFilter(QObject *object, QEvent *e)
{

    if ( object != (QObject *)plot()->canvas() ) {
        return false;
    }

    //    // We check if the event is a sequence Ctrl+D, which
    //    // is used to delete an existing point :
    //    if (e->type() == QEvent::KeyPress) {
    //        QKeyEvent *keyEvent = static_cast<QKeyEvent*>(e);
    //        if (keyEvent->modifiers() == Qt::ControlModifier)
    //            if (keyEvent->key() == Qt::Key_D)
    //                remove_point(((QMouseEvent *)e)->pos());

    //        //        QKeySequence ctrl_d(Qt::CTRL + Qt::Key_D);
    //    }

    switch(e->type())
    {
    case QEvent::FocusIn:
    {
        showCursor(true);
    }
    case QEvent::FocusOut:
    {
        showCursor(false);
    }
    case QEvent::Paint:
    {
        QApplication::postEvent(this, new QEvent(QEvent::User));
        break;
    }
    case QEvent::MouseButtonPress:
    {
        if (m_isCtrlDown){
#if (QT_VERSION < QT_VERSION_CHECK(5,0,0))
            add_point(((QMouseEvent *)e)->posF());
#else
            add_point(((QMouseEvent *)e)->localPos());
#endif
            m_isCtrlDown = false;
        }
        else
            select(((QMouseEvent *)e)->pos());
        return true;
    }
    case QEvent::ContextMenu:
    {
        // old version, not working with qt5
        // in the new version the combination to add a point is ctrl + button press
        //#if (QT_VERSION < QT_VERSION_CHECK(5,0,0))
        //        add_point(((QMouseEvent *)e)->posF());
        //#else
        //        add_point(((QMouseEvent *)e)->localPos());
        //#endif
    }
    case QEvent::MouseMove:
    {
        move(((QMouseEvent *)e)->pos());
        return true;
    }
    case QEvent::KeyPress:
    {
        const int delta = 5;
        switch(((const QKeyEvent *)e)->key())
        {
        case Qt::Key_Control :
            m_isCtrlDown = true;
            break;
        case Qt::Key_D:
        case Qt::Key_Backspace :
        case Qt::Key_Delete:
            remove_point(((QMouseEvent *)e)->pos());

        case Qt::Key_Up:
            shiftCurveCursor(true);
            return true;

        case Qt::Key_Down:
            shiftCurveCursor(false);
            return true;

        case Qt::Key_Right:
        case Qt::Key_Plus:
            if ( d_selectedCurve )
                shiftPointCursor(true);
            else
                shiftCurveCursor(true);
            return true;

        case Qt::Key_Left:
        case Qt::Key_Minus:
            if ( d_selectedCurve )
                shiftPointCursor(false);
            else
                shiftCurveCursor(true);
            return true;

            // The following keys represent a direction, they are
            // organized on the keyboard.

        case Qt::Key_1:
            moveBy(-delta, delta);
            break;
        case Qt::Key_2:
            moveBy(0, delta);
            break;
        case Qt::Key_3:
            moveBy(delta, delta);
            break;
        case Qt::Key_4:
            moveBy(-delta, 0);
            break;
        case Qt::Key_6:
            moveBy(delta, 0);
            break;
        case Qt::Key_7:
            moveBy(-delta, -delta);
            break;
        case Qt::Key_8:
            moveBy(0, -delta);
            break;
        case Qt::Key_9:
            moveBy(delta, -delta);
            break;
        default:
            break;
        }
    }
//    case QEvent::KeyRelease:
//    {
//        switch(((const QKeyEvent *)e)->key())
//        {
//        case Qt::Key_Control :
//            m_isCtrlDown = false;
//            break;
//        }
//    }

    default:
        break;
    }
    return QObject::eventFilter(object, e);
}



/** \fn void CanvasPicker::add_point(const QPoint &)
  * This method allows to add a point when right clicking
  * on the initialization plot.
  */
void CanvasPicker::add_point(const QPointF & point)
{

    // First we get the curve currently plotted (there
    // should be only one at a time) :
    const QwtPlotItemList& itmList = plot()->itemList();
    for ( QwtPlotItemIterator it = itmList.begin();
          it != itmList.end(); ++it ) {
        if ( (*it)->rtti() == QwtPlotItem::Rtti_PlotCurve )
            d_selectedCurve = (QwtPlotCurve*)(*it);
    }

    // If no curve is displayed :
    if (!d_selectedCurve)
        return;

    // We need to transform the given point x and y coordinates
    // in the drawing region into a position on the plot :
    double x_point = plot()->invTransform(QwtPlot::xBottom,point.x());
    double y_point = plot()->invTransform(QwtPlot::yLeft,point.y());


    // We have to know where to add the new point :
    int pos = 0;
    double x_plot = x_point-1; // to get into the loop
    while (x_point > x_plot) {
        if (pos >= (int)d_selectedCurve->dataSize())
            return;

        QPointF point_plot = d_selectedCurve->sample(pos);
        x_plot = point_plot.x();
        ++pos;
    }
    --pos;

    // We add the new point :
    QVector<double> xData(d_selectedCurve->dataSize()+1);
    QVector<double> yData(d_selectedCurve->dataSize()+1);

    for ( int i=0; i<pos; i++ )
    {
        const QPointF sample = d_selectedCurve->sample(i);
        xData[i] = sample.x();
        yData[i] = sample.y();
    }

    xData[pos] = x_point;
    yData[pos] = y_point;

    for ( int i=pos; i<(int)d_selectedCurve->dataSize(); i++ )
    {
        const QPointF sample = d_selectedCurve->sample(i);
        xData[i+1] = sample.x();
        yData[i+1] = sample.y();
    }


    d_selectedCurve->setSamples(xData, yData);

    /*
       Enable QwtPlotCanvas::ImmediatePaint, so that the canvas has been
       updated before we paint the cursor on it.
     */
    QwtPlotCanvas *canvas = qobject_cast<QwtPlotCanvas*>(plot()->canvas());
    canvas->setPaintAttribute( QwtPlotCanvas::ImmediatePaint, true);
    plot()->replot();
    canvas->setPaintAttribute( QwtPlotCanvas::ImmediatePaint, false);

    //        plot()->canvas()->setPaintAttribute( QwtPlotCanvas::ImmediatePaint, true);
    //        plot()->replot();
    //        plot()->canvas()->setPaintAttribute( QwtPlotCanvas::ImmediatePaint, false);

    showCursor(true);

    m_mainWindow->saveTempCanvas();

    m_isCtrlDown = false;

}


/** \fn void CanvasPicker::delete_item(const QPoint &)
  * This method is called when detecting a right click on the
  * initialization plot. It deletes currently selected point.
  * If user pushes right click button, QEvent::MouseButtonPress
  * is first sent, therefore function "select" is called. Then
  * QEvent::ContextMenu will call "delete_item" on the selected item.
  */
void CanvasPicker::remove_point(const QPoint &)
{

    // If no point is selected :
    if (d_selectedPoint < 0)
        return;

    // If no curve is selected :
    if (!d_selectedCurve)
        return;

    QVector<double> xData(d_selectedCurve->dataSize()-1);
    QVector<double> yData(d_selectedCurve->dataSize()-1);
    int pos = 0;

    for ( int i=0; i<(int)d_selectedCurve->dataSize(); i++ )
    {
        if (pos >= (int)xData.size() || pos >= (int)yData.size() )
            return;

        if ( i != d_selectedPoint )
        {
            const QPointF sample = d_selectedCurve->sample(i);
            xData[pos] = sample.x();
            yData[pos] = sample.y();

            pos++;
        }
    }
    d_selectedCurve->setSamples(xData, yData);

    /*
       Enable QwtPlotCanvas::ImmediatePaint, so that the canvas has been
       updated before we paint the cursor on it.
     */
    QwtPlotCanvas *canvas = qobject_cast<QwtPlotCanvas*>(plot()->canvas());
    canvas->setPaintAttribute( QwtPlotCanvas::ImmediatePaint, true);
    plot()->replot();
    canvas->setPaintAttribute( QwtPlotCanvas::ImmediatePaint, false);

    //        plot()->canvas()->setPaintAttribute( QwtPlotCanvas::ImmediatePaint, true);
    //        plot()->replot();
    //        plot()->canvas()->setPaintAttribute( QwtPlotCanvas::ImmediatePaint, false);

    showCursor(true);

    m_mainWindow->saveTempCanvas();
}



// Select the point at a position. If there is no point
// deselect the selected point

void CanvasPicker::select(const QPoint &pos)
{

    QwtPlotCurve *curve = NULL;
    double dist = 10e10;
    int index = -1;

    const QwtPlotItemList& itmList = plot()->itemList();
    for ( QwtPlotItemIterator it = itmList.begin();
          it != itmList.end(); ++it )
    {
        if ( (*it)->rtti() == QwtPlotItem::Rtti_PlotCurve )
        {
            QwtPlotCurve *c = (QwtPlotCurve*)(*it);

            double d;
            int idx = c->closestPoint(pos, &d);
            if ( d < dist )
            {
                curve = c;
                index = idx;
                dist = d;
            }
        }
    }

    showCursor(false);
    d_selectedCurve = NULL;
    d_selectedPoint = -1;

    if ( curve && dist < 10 ) // 10 pixels tolerance
    {
        d_selectedCurve = curve;
        d_selectedPoint = index;
        showCursor(true);
    }
}

// Move the selected point
void CanvasPicker::moveBy(int dx, int dy)
{
    if ( dx == 0 && dy == 0 )
        return;

    if ( !d_selectedCurve )
        return;

    const QPointF sample =
            d_selectedCurve->sample(d_selectedPoint);

    const double x = plot()->transform(
                d_selectedCurve->xAxis(), sample.x());
    const double y = plot()->transform(
                d_selectedCurve->yAxis(), sample.y());

    move( QPoint(qRound(x + dx), qRound(y + dy)) );
}

// Move the selected point
void CanvasPicker::move(const QPoint &pos)
{
    if ( !d_selectedCurve )
        return;

    QVector<double> xData(d_selectedCurve->dataSize());
    QVector<double> yData(d_selectedCurve->dataSize());

    for ( int i = 0; i < (int)d_selectedCurve->dataSize(); i++ )
    {
        if ( i == d_selectedPoint )
        {
            xData[i] = plot()->invTransform(
                        d_selectedCurve->xAxis(), pos.x());
            yData[i] = plot()->invTransform(
                        d_selectedCurve->yAxis(), pos.y());
        }
        else
        {
            const QPointF sample = d_selectedCurve->sample(i);
            xData[i] = sample.x();
            yData[i] = sample.y();
        }
    }
    d_selectedCurve->setSamples(xData, yData);

    /*
       Enable QwtPlotCanvas::ImmediatePaint, so that the canvas has been
       updated before we paint the cursor on it.
     */
    QwtPlotCanvas *canvas = qobject_cast<QwtPlotCanvas*>(plot()->canvas());
    canvas->setPaintAttribute( QwtPlotCanvas::ImmediatePaint, true);
    plot()->replot();
    canvas->setPaintAttribute( QwtPlotCanvas::ImmediatePaint, false);

    //        plot()->canvas()->setPaintAttribute( QwtPlotCanvas::ImmediatePaint, true);
    //        plot()->replot();
    //        plot()->canvas()->setPaintAttribute( QwtPlotCanvas::ImmediatePaint, false);

    showCursor(true);

    m_mainWindow->saveTempCanvas();
}

// Hightlight the selected point
void CanvasPicker::showCursor(bool showIt)
{
    if ( !d_selectedCurve )
        return;

    //    if (d_selectedCurve->symbol() == NULL) {
    //        qDebug() << "BLA!!!";
    //        return;
    //    }

    QwtSymbol *symbol = const_cast<QwtSymbol *>( d_selectedCurve->symbol() );


    const QBrush brush = symbol->brush();
    if ( showIt )
        symbol->setBrush(symbol->brush().color().dark(180));

    QwtPlotDirectPainter directPainter;
    directPainter.drawSeries(d_selectedCurve, d_selectedPoint, d_selectedPoint);

    if ( showIt )
        symbol->setBrush(brush); // reset brush
}

// Select the next/previous curve 
void CanvasPicker::shiftCurveCursor(bool up)
{
    QwtPlotItemIterator it;

    const QwtPlotItemList &itemList = plot()->itemList();

    QwtPlotItemList curveList;
    for ( it = itemList.begin(); it != itemList.end(); ++it )
    {
        if ( (*it)->rtti() == QwtPlotItem::Rtti_PlotCurve )
            curveList += *it;
    }
    if ( curveList.isEmpty() )
        return;

    it = curveList.begin();

    if ( d_selectedCurve )
    {
        for ( it = curveList.begin(); it != curveList.end(); ++it )
        {
            if ( d_selectedCurve == *it )
                break;
        }
        if ( it == curveList.end() ) // not found
            it = curveList.begin();

        if ( up )
        {
            ++it;
            if ( it == curveList.end() )
                it = curveList.begin();
        }
        else
        {
            if ( it == curveList.begin() )
                it = curveList.end();
            --it;
        }
    }

    showCursor(false);
    d_selectedPoint = 0;
    d_selectedCurve = (QwtPlotCurve *)*it;
    showCursor(true);
}

// Select the next/previous neighbour of the selected point
void CanvasPicker::shiftPointCursor(bool up)
{
    if ( !d_selectedCurve )
        return;

    int index = d_selectedPoint + (up ? 1 : -1);
    index = (index + d_selectedCurve->dataSize()) % d_selectedCurve->dataSize();

    if ( index != d_selectedPoint )
    {
        showCursor(false);
        d_selectedPoint = index;
        showCursor(true);
    }
}
