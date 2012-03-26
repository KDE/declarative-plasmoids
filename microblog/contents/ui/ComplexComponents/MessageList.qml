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

import "plasmapackage:/ui/BasicComponents"

ListView {
    id: entryList

    clip: true
    snapMode: ListView.SnapToItem
    spacing: 2
    //cacheBuffer: 500

    signal itemClicked(variant item)

    property string timelineType: "TimelineWithFriends"
    //property string login: userName
    property string url: serviceUrl
    property string source: timelineType+":"+userName+"@"+url

    onSourceChanged: {
        microblogSource.connectSource(source)
//         timer.running = true
    }

//     Timer {
//         id: timer
//         repeat: false
//         running: false
//         interval: 500
//         onTriggered: {
//             if (userName == "" || password == "") {
//                 print("user empty");
//                 return;
//             }
//             var s = timelineType+":"+userName+"@"+url;
//             print(" Source: " + s + "USER: " + userName);
//             var service = microblogSource.serviceForSource(s)
//             var operation = service.operationDescription("auth");
//             operation.password = password
//             service.startOperationCall(operation);
//         }
//     }

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

    delegate: MessageWidget {
        id: messageWidget
        width: entryList.width
        onClicked: itemClicked(messageWidget)
    }
}
