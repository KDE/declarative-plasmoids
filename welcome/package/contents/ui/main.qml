/*
*   Copyright 2010 Marco Martin <notmart@gmail.com>
*   Copyright 2010 Lukas Appelhans <l.appelhans@gmx.de>
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
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets

Item {
    id: mainWindow

    property string source
    property variant individualSources
    property int scrollInterval


    PlasmaCore.DataSource {
        id: feedSource
        engine: "rss"
        connectedSources: [plasmoid.file("data", "welcome.rss")]
        interval: 50000
        onDataChanged: {
            plasmoid.busy = false
        }
    }

    PlasmaCore.Theme {
        id: theme
    }

    ListView {
        id: entryList
        spacing: 5;
        snapMode: ListView.SnapToItem
        orientation: ListView.Horizontal
        anchors.fill: parent
        clip: true
        highlightMoveDuration: 300
        property int listIndex: index
        model: PlasmaCore.DataModel {
            dataSource: feedSource
            keyRoleFilter: "items"
        }

        delegate: Item {
            width: entryList.width
            height: entryList.height
            PlasmaWidgets.WebView {
                anchors.fill: parent
                html: description
            }
        }

        onFlickEnded: {
            currentIndex = contentX / contentWidth * count
        }
        Timer {
            id: flickTimer
            interval: scrollInterval * 1000
            running: true
            repeat: true
            onTriggered: {
                if (entryList.currentIndex == (entryList.count - 1))
                    entryList.currentIndex = 0
                else
                    entryList.currentIndex = entryList.currentIndex + 1
            }
        }
    }
}
