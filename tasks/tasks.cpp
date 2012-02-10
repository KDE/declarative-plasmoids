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

#include <Plasma/Containment>
#include <Plasma/Corona>

#include <QGraphicsView>
#include <QDeclarativeEngine>
#include <QDeclarativeView>
#include <QDeclarativeComponent>
#include <QGraphicsLinearLayout>
#include <QUrl>

#include <KDebug>

#include <Plasma/DeclarativeWidget>
#include <Plasma/Package>

#include <plasmagenericshell/taskmanager/tasksmodel.h>
//    libs/taskmanager/tasksmodel.h
K_EXPORT_PLASMA_APPLET(tasks, Tasks)

Tasks::Tasks(QObject *parent, const QVariantList &args)
    : Plasma::Applet(parent, args)
{
    resize(192, 128);

    setAspectRatioMode(Plasma::IgnoreAspectRatio);
    setHasConfigurationInterface(false);

    QGraphicsLinearLayout *lay = new QGraphicsLinearLayout(this);
    m_declarativeWidget = new Plasma::DeclarativeWidget(this);
    lay->addItem(m_declarativeWidget);

    Plasma::PackageStructure::Ptr structure = Plasma::PackageStructure::load("Plasma/Generic");
    m_package = new Plasma::Package(QString(), "org.kde.tasks", structure);
    m_declarativeWidget->setQmlPath(m_package->filePath("mainscript"));
}

Tasks::~Tasks()
{

}

#include "tasks.moc"
