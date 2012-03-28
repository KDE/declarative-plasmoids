/*
 *   Copyright 2011 Marco Martin <mart@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 1.0
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras

import "plasmapackage:/ui/BasicComponents"

ListView {
    id: entryList

    clip: true
    snapMode: ListView.SnapToItem
    spacing: 2
    //cacheBuffer: 500

    signal itemClicked(variant item)

    property string timelineType: "TimelineWithFriends"
    property string title: "bla"
    property string url: serviceUrl
    property string source: timelineType+":"+userName+"@"+url
    property string previousSource

    onSourceChanged: {
        if (previousSource) {
            print("source changed from " + previousSource + " to " + source);
            microblogSource.disconnectSource(previousSource);
        }
        if (userName) {
            microblogSource.connectSource(source)
        }
        previousSource = source
    }


    model: PlasmaCore.SortFilterModel {
        id: sortModel
        sortRole: "Date"
        sortOrder: "DescendingOrder"
        sourceModel: PlasmaCore.DataModel {
            dataSource: microblogSource
            sourceFilter: entryList.source
            keyRoleFilter: "[\\d]*"
        }
    }
    header: Component {
        PlasmaExtras.Title {
            anchors.margins: 12
            x: 24
            anchors.leftMargin: 24
            height: 48
            text: entryList.title
        }
    }

    delegate: MessageWidget {
        id: messageWidget
        width: entryList.width
        onClicked: itemClicked(messageWidget)
    }
}
