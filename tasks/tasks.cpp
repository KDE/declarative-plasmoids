/***************************************************************************
 *   Copyright (C) 2012 by Shaun M. Reich <shaun.reich@kdemail.net>        *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

#include "tasks.h"

#include <QGraphicsView>
#include <QDeclarativeEngine>
#include <QDeclarativeView>
#include <QDeclarativeComponent>
#include <QUrl>

#include <KDebug>

Tasks::Tasks(QObject *parent, const QVariantList &args)
    : Plasma::Applet(parent, args)
{
    resize(192, 128);

    setAspectRatioMode(Plasma::IgnoreAspectRatio);
    setHasConfigurationInterface(false);

    QDeclarativeEngine *engine = new QDeclarativeEngine;
    QDeclarativeComponent component(engine, QUrl::fromLocalFile("qml/contents/ui/main.qml"));
    QGraphicsObject *object = qobject_cast<QGraphicsObject *>(component.create());
    scene()->addItem(object);
}

Tasks::~Tasks()
{

}

#include "tasks.moc"
