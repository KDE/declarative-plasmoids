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
import org.kde.plasma.components 0.1 as PlasmaComponents

import "plasmapackage:/ui/ComplexComponents"
import "plasmapackage:/ui/BasicComponents"

Item {
    id: authStatusWidget
    width: 140
    state: "Idle"
//     height: 48
    property alias statusMessage: statusLabel.text
//     property string status: "Idle"
    property string accountServiceUrl
    property string __serviceUrl
    property string __userName

    onStateChanged: {
        main.authorized = authStatusWidget.state == "Ok" // TODO remove and make unnecessary
    }
    states: [
        State {
            name: "Ok"
        },
        State {
            name: "Busy"
        },
        State {
            name: "Idle"
            //PropertyChanges { target: accountDelegate; height: loginWidget.height; }
        }
    ]

    PlasmaComponents.BusyIndicator {
        id: busyIndicator
        width: authStatusWidget.height/1.5
        height: authStatusWidget.height/1.5
        visible: authStatusWidget.state == "Busy"
        anchors { right: avispacer.left; verticalCenter: parent.verticalCenter; leftMargin: 12;}
        running: authStatusWidget.state == "Busy"
    }
    Item {
        id: avispacer
        width: 18
        height: 48
        anchors { right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: 12;}
    }
    Avatar {
        id: profileIcon
        height: parent.height/1.5
        width: parent.height/1.5
        anchors { right: avispacer.left; verticalCenter: parent.verticalCenter; leftMargin: 12;}
        visible: authStatusWidget.state == "Ok"
        userId: accountDelegate.accountUserName
    }

    PlasmaComponents.Label {
        id: statusLabel
        height: parent.height
        anchors { right: busyIndicator.left; verticalCenter: busyIndicator.verticalCenter; rightMargin: 8; }
        text: authStatusWidget.state == "Busy" ? i18n("Logging in...") : authStatusWidget.state == "Ok" ? accountDelegate.accountUserName : "Idle";
    }

//     MouseArea {
//         anchors.fill: parent
//         onClicked: {
//             var componentObject = configComponent.createObject(mainWidget);
//         }
//         onPressed: PlasmaExtras.PressedAnimation { targetItem: authStatusWidget }
//         onReleased: PlasmaExtras.ReleasedAnimation { targetItem: authStatusWidget }
//     }
}

