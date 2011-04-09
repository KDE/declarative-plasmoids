/*
 *   Copyright 2010 Marco Martin <notmart@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import Qt 4.7
import org.kde.plasma.core 0.1 as PlasmaCore

import "plasmapackage:/ui/MainUi"
import "plasmapackage:/code/bookkeeping.js" as BookKeeping

Item {
    id: mainWindow;
    width: 250
    height: 400
    state: "items"

    property string source
    signal unreadCountChanged();

    Component.onCompleted: {
        BookKeeping.mainWindow = mainWindow
        BookKeeping.loadReadArticles();
        plasmoid.addEventListener('ConfigChanged', configChanged);
        //FIXME: it's launching a separated shell script: a more automated process is needed
        plasmoid.associatedApplication = "news-tablet"
        plasmoid.busy = true
        configChanged()
    }

    function configChanged()
    {
        source = plasmoid.readConfig("feeds")
        var sourceString = new String(source)
        print("Configuration changed: " + source);
        feedSource.connectedSources = source
    }


    PlasmaCore.DataSource {
        id: feedSource
        engine: "rss"
        interval: 50000
        onDataChanged: {
            plasmoid.busy = false
            BookKeeping.updateUnreadCount(feedSource.data[source].items)
        }
    }

    PlasmaCore.Theme {
        id: theme
    }

    MainUi {
        anchors.fill: parent
    }
}
