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
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 1.0
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets

import "plasmapackage:/ui/BasicComponents"

ListView {
    id: entryList

    clip: true

    property string timeline: "TimelineWithFriends"
    property string login: userName
    property string url: serviceUrl
    property string source: timeline+":"+login+"@"+url
    onSourceChanged: {
        timer.running = true
    }
    Timer {
        id: timer
        repeat: false
        running: false
        interval: 500
        onTriggered: {
            dataSource.connectSource(source)
        }
    }

    spacing: 5
    model: PlasmaCore.DataModel {
        dataSource: microblogSource
        sourceFilter: entryList.source
        keyRoleFilter: "[\\d]*"
    }
    header: PostingWidget {}

    delegate: MessageWidget {
        width: entryList.width
    }
}
