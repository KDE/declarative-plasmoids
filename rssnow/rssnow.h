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

#ifndef RSSNOWAPPLET_H
#define RSSNOWAPPLET_H

#include <Plasma/Applet>

#include "ui_feedsConfig.h"
#include "ui_generalConfig.h"

namespace Plasma {
    class DeclarativeWidget;
}

class QGraphicsLinearLayout;

static const QString DEFAULTFEED("http://planetkde.org/rss20.xml");

class RssNow : public Plasma::Applet
{
Q_OBJECT
public:
    RssNow(QObject *parent, const QVariantList &args);
    ~RssNow();

    void init();

public Q_SLOTS:
    void configChanged();

Q_SIGNALS:
    void reloadConfig(const QString &feeds, int switchInterval, int updateInterval, bool logo, bool dropTarget);

protected:
    void createConfigurationInterface(KConfigDialog *parent);
    void connectToQML();

protected Q_SLOTS:
    void configAccepted();
    void addFeed();
    void toogleAddFeed(const QString& text);
    void removeFeed();
    void feedAdded(const QString& feed);
    void busyChanged(bool busy);

private:
    QGraphicsLinearLayout *m_plasmoidLayout;
    Plasma::DeclarativeWidget *m_declarativeWidget;
    Ui::feedsConfig m_feedsConfig;
    Ui::generalConfig m_generalConfig;
    QString m_feeds;
    bool m_logo;
    bool m_showDropTarget;
    int m_updateInterval;
    int m_switchInterval;
};

K_EXPORT_PLASMA_APPLET(rssnow, RssNow)

#endif
