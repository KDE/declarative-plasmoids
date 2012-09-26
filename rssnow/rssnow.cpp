/***************************************************************************
 *   Copyright 2012 by Giorgos Tsiapaliokas <terietor@gmail.com>                    *
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

#include "rssnow.h"

#include <KConfigDialog>
#include <KDebug>

#include <Plasma/DeclarativeWidget>
#include <Plasma/Package>

#include <QDeclarativeContext>
#include <QDeclarativeEngine>
#include <QGraphicsLinearLayout>

RssNow2::RssNow2(QObject* parent, const QVariantList& args)
    : Plasma::Applet(parent, args),
    m_plasmoidLayout(0),
    m_declarativeWidget(0)
{
    setAspectRatioMode(Plasma::IgnoreAspectRatio);
    configChanged();
}

RssNow2::~RssNow2()
{
}

void RssNow2::init()
{
    Plasma::PackageStructure::Ptr structure = Plasma::PackageStructure::load("Plasma/Generic");
    Plasma::Package *package = new Plasma::Package(QString(), "org.kde.rssnow-qml", structure);
    const QString qmlFile = package->filePath("mainscript");
    delete package;

    kDebug() << " Loading QML File from package: " << qmlFile;
    m_declarativeWidget = new Plasma::DeclarativeWidget(this);

    connectToQML();

    m_declarativeWidget->setQmlPath(qmlFile);

    connect(m_declarativeWidget->rootObject(), SIGNAL(changeConfig(QString)), this, SLOT(emitChangeConfig(QString)));
    connect(this, SIGNAL(reloadConfig(QString, int, int, bool, bool)),
            m_declarativeWidget->rootObject(), SIGNAL(reloadConfig(QString, int, int, bool, bool)));

    connect(m_declarativeWidget->rootObject(), SIGNAL(changeBusy()), this, SLOT(emitChangeBusy()));
    m_declarativeWidget->setMinimumSize(300, 200);

    m_plasmoidLayout = new QGraphicsLinearLayout(this);
    m_plasmoidLayout->addItem(m_declarativeWidget);

    setLayout(m_plasmoidLayout);
}

void RssNow2::createConfigurationInterface(KConfigDialog* parent)
{
    QWidget *generalWidget = new QWidget();
    m_generalConfig.setupUi(generalWidget);

    QWidget *feedsWidget = new QWidget();
    m_feedsConfig.setupUi(feedsWidget);

    KConfigGroup cg = config();

    m_generalConfig.intervalSpinBox->setValue(m_updateInterval);
    m_generalConfig.switchInterval->setValue(m_switchInterval);
    m_generalConfig.logo->setChecked(m_logo);
    m_generalConfig.showDropTarget->setChecked(m_showDropTarget);

    QString feeds = m_feeds;
    QStringList feedList = feeds.split(",");

    m_feedsConfig.feedList->clear();

    foreach(const QString& feed, feedList) {
        m_feedsConfig.feedList->addItem(feed);
    }

    parent->addPage(generalWidget, i18n("General"), "akregator");
    parent->addPage(feedsWidget, i18n("Feeds"), "akregator");

    connect(parent, SIGNAL(applyClicked()), this, SLOT(configAccepted()));
    connect(parent, SIGNAL(okClicked()), this, SLOT(configAccepted()));

    connect(m_generalConfig.showDropTarget, SIGNAL(toggled(bool)), parent, SLOT(settingsModified()));
    connect(m_generalConfig.logo, SIGNAL(toggled(bool)), parent, SLOT(settingsModified()));
    connect(m_generalConfig.intervalSpinBox, SIGNAL(valueChanged(int)), parent, SLOT(settingsModified()));
    connect(m_generalConfig.switchInterval, SIGNAL(valueChanged(int)), parent, SLOT(settingsModified()));
    connect(m_feedsConfig.feedComboBox, SIGNAL(editTextChanged(QString)), parent, SLOT(settingsModified()));
    connect(m_feedsConfig.addFeed, SIGNAL(released()), parent, SLOT(settingsModified()));
    connect(m_feedsConfig.removeFeed, SIGNAL(released()), parent, SLOT(settingsModified()));
    connect(m_feedsConfig.feedList, SIGNAL(itemSelectionChanged()), parent, SLOT(settingsModified()));

    connect(m_feedsConfig.addFeed, SIGNAL(released()), this, SLOT(addFeed()));
    connect(m_feedsConfig.removeFeed, SIGNAL(released()), this, SLOT(removeFeed()));

}

void RssNow2::configAccepted()
{
    QString feedList;
    for (int i = 0; i < m_feedsConfig.feedList->count(); i++) {
        feedList.append(m_feedsConfig.feedList->item(i)->text());

        feedList.append(",");
    }

    KConfigGroup cg = config();

    cg.writeEntry("feeds", feedList);
    cg.writeEntry("interval", m_generalConfig.intervalSpinBox->value());
    cg.writeEntry("switchInterval", m_generalConfig.switchInterval->value());
    cg.writeEntry("logo", m_generalConfig.logo->isChecked());
    cg.writeEntry("droptarget", m_generalConfig.showDropTarget->isChecked());

    configChanged();
}

void RssNow2::configChanged()
{


    KConfigGroup cg = config();

    m_feeds = cg.readEntry("feeds", "http://planetkde.org/rss20.xml");
    m_logo = cg.readEntry("logo", false);
    m_showDropTarget = cg.readEntry("droptarget", false);
    m_updateInterval = cg.readEntry("interval", 10);
    m_switchInterval =  cg.readEntry("switchInterval", 10);

   emit reloadConfig(m_feeds, m_switchInterval, m_updateInterval, m_logo, m_showDropTarget);
}

void RssNow2::connectToQML()
{
    QDeclarativeContext *rootComponent = m_declarativeWidget->engine()->rootContext();

    rootComponent->setContextProperty("_feeds", m_feeds);
    rootComponent->setContextProperty("_updateInterval", m_updateInterval);
    rootComponent->setContextProperty("_switchInterval", m_switchInterval);
    rootComponent->setContextProperty("_logo", m_logo);
    rootComponent->setContextProperty("_dropTarget", m_showDropTarget);
}

void RssNow2::addFeed()
{
    QString newFeed = m_feedsConfig.feedComboBox->currentText();
    m_feedsConfig.feedList->addItem(newFeed);
    m_feedsConfig.feedComboBox->clearEditText();
}

void RssNow2::removeFeed()
{
    delete m_feedsConfig.feedList->currentItem();
}

void RssNow2::emitChangeConfig(const QString& feed)
{
    KConfigGroup cg = config();
    QString feedList = cg.readEntry("feeds", QString());
    feedList.append(",");
    feedList.append(feed);
    cg.writeEntry("feeds", feedList);

    connectToQML();
}

void RssNow2::emitChangeBusy()
{
    setBusy(!isBusy());
}


#include "rssnow.moc"
