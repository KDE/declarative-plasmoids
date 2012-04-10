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
import org.kde.plasma.extras 0.1 as PlasmaExtras

import "plasmapackage:/ui/ComplexComponents"
import "plasmapackage:/ui/BasicComponents"

Item {
    id: authStatusWidget
    width: 300 
    height: 48
    property alias statusMessage: statusLabel.text
    property string status: "Idle"

    property string __serviceUrl

    onStatusChanged: {
        main.authorized = status == "Ok"
    }

    PlasmaComponents.BusyIndicator {
        id: busyIndicator
        width: authStatusWidget.height/1.5
        height: authStatusWidget.height/1.5
        visible: status == "Busy"
        anchors { right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: 12;}
        running: status == "Busy"
    }
    Avatar {
        id: profileIcon
        height: parent.height/1.5
        width: parent.height/1.5
        anchors { right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: 12;}
        visible: status == "Ok"
        userId: userName
    }

    PlasmaExtras.Heading {
        id: statusLabel
        level: 3
        height: parent.height
        anchors { right: busyIndicator.left; verticalCenter: busyIndicator.verticalCenter; rightMargin: 8; }
        text: status == "Busy" ? i18n("Logging in...") : status == "Ok" ? userName : "";
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
        onServiceUrlChanged: {
            if (__serviceUrl) {
                statusSou.disconnectSource("Status:"+__serviceUrl);
                __serviceUrl = serviceUrl;
            }
            statusSource.connectSource("Status:"+serviceUrl);
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            var componentObject = configComponent.createObject(mainWidget);
        }
        onPressed: PlasmaExtras.PressedAnimation { targetItem: authStatusWidget }
        onReleased: PlasmaExtras.ReleasedAnimation { targetItem: authStatusWidget }
    }
}

