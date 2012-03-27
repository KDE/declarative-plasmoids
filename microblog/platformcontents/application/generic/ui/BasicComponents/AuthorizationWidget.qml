/*
 *   Copyright 2012 Sebastian Kügler <sebas@kde.org>
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

import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents

import "plasmapackage:/ui/ComplexComponents"
import "plasmapackage:/ui/BasicComponents"

Item {
    id: authStatusWidget
    width: 800
    height: 200
    property alias statusMessage: statusLabel.text
    property string status: "Idle"

    onStatusChanged: {
        main.authorized = status == "Ok"
    }

    PlasmaComponents.BusyIndicator {
        id: busyIndicator
        width: authStatusWidget.height; height: width
        visible: status == "Busy"
        anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 12; topMargin: 12}
        running: status == "Busy"
    }
    Avatar {
        id: profileIcon
        height: parent.height
        width: height
        anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 12; topMargin: 6}
        visible: status == "Ok"
        userId: userName
    }

    PlasmaComponents.Label {
        id: statusLabel
        width: 300
        height: 48
        font.pointSize: theme.defaultFont.pointSize+3
        anchors { left: busyIndicator.right; verticalCenter: busyIndicator.verticalCenter; leftMargin: 12; }
        text: status == "Busy" ? i18n("Logging in...") : status == "Ok" ? "@" + userName : "";
    }
    PlasmaCore.DataSource {
        id: statusSource
        engine: "microblog"
        interval: 0
        onDataChanged: {
            if (statusSource.data["Status:"+serviceUrl]) {
                authStatusWidget.status = statusSource.data["Status:"+serviceUrl]["Authorization"]
            }
        }
        Component.onCompleted: statusSource.connectSource("Status:"+serviceUrl);
    }

    Connections {
        target: main
        onServiceUrlChanged: statusSource.connectSource("Status:"+serviceUrl);
    }
}

