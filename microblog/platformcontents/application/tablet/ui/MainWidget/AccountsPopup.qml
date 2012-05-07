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

import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore

import "plasmapackage:/ui/ComplexComponents"

PlasmaCore.FrameSvgItem {
    id: topItem
    property int expandedHeight: 440 + _s*2
    clip: true
    imagePath: "widgets/background"
    width: 400
    height: expandedHeight
    //y: -expandedHeight
    enabledBorders: "BottomBorder|LeftBorder"
    state: "expanded"

    Behavior on y {
        NumberAnimation { duration: 450; easing.type: Easing.OutExpo; }
    }

    states: [
        State {
            name: "collapsed"
            PropertyChanges { target: topItem; y: -expandedHeight; }
            PropertyChanges { target: accountsWidget; visible: true; }
        },
        State {
            name: "expanded"
            PropertyChanges { target: topItem; y: 64; }
            PropertyChanges { target: accountsWidget; visible: true; }
        }
    ]

    Accounts {
        anchors.fill: accountsPopup;
        id: accountsWidget
//         visible: true
    }

    Component.onCompleted: {
        //y = -expandedHeight;
    }
}