/*
 *   Copyright 2011 Marco Martin <mart@kde.org>
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

import QtQuick 1.0
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1 as QtExtraComponents

import "plasmapackage:/ui/BasicComponents"

ListItem {
    id: messageWidget
    height: childrenRect.height
    width: entryList.width-scrollBar.width-4
    state: (entryList.currentIndex == index) ? "expanded" : "collapsed"

    property string messageId: model["Id"]
    property string user: model["User"]
    property string source: model["source"]
    property string dateTime: model["created_at"]
    property bool isFavorite: model["favorited"]
    property string message: model["Status"]

    states: [
        State {
            name: "collapsed"
            PropertyChanges { target: contextBar; height: 0; }
            PropertyChanges { target: contextBar; opacity: 0; }
        },
        State {
            name: "expanded"
            PropertyChanges { target: contextBar; height: 72; }
            PropertyChanges { target: contextBar; opacity: 1.0; }
        }
    ]


    Avatar {
        id: userIcon
        y: 12
        anchors.left: parent.left
        anchors.leftMargin: 12
    }

    PlasmaComponents.Label {
        id: fromLabel
        anchors.leftMargin: 11
        anchors.rightMargin: 12
        anchors.left: userIcon.right
        anchors.right: infoLabel.left
        anchors.top: userIcon.top
        opacity: 0.6
        style: Text.Sunken
        elide: Text.ElideRight
        font.pointSize: theme.defaultFont.pointSize + 4
        styleColor: theme.backgroundColor
        text: user
        MouseArea {
            anchors.fill: parent
            onClicked: sideBar.activeUser = user
        }

    }
    PlasmaComponents.Label {
        id: bodyText
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.left: userIcon.right
        anchors.right: parent.right
        anchors.top: fromLabel.bottom
        anchors.bottomMargin: 6
        text: formatMessage(message)
        wrapMode: Text.WordWrap
        onLinkActivated: handleLinkClicked(link)
    }
    PlasmaComponents.Label {
        id: infoLabel
        anchors.right: bodyText.right
        anchors.bottom: fromLabel.bottom
        anchors.rightMargin: 12
        opacity: 0.3
        font.pointSize: theme.smallestFont.pointSize
        styleColor: theme.backgroundColor
        text: friendlyDate(dateTime)
    }

    Item { height: 12; anchors.top: bodyText.bottom; z: -1 }
    Row {
        id: contextBar
        anchors.right: parent.right
        anchors.top: bodyText.bottom
        anchors.rightMargin: _m
        spacing: 12
        visible: messageWidget.state == "expanded"
        ServiceJobButton {
            id: favoriteButton
//                     text: "♥"
//                     font.pointSize: 24
//                     width: 48
//                     height: 48
//                     checked: isFavorite
//                     onClicked: {
//                         main.favoriteAsked(messageId, isFavorite != "true");
//                     }
        }
        PlasmaComponents.ToolButton {
            id: replyButton
            text: "@"
            font.pointSize: 24
            width: 48
            height: 48
            onClicked: {
                main.replyAsked(messageId, "@" + user + ": ");
            }
        }
        PlasmaComponents.ToolButton {
            id: repeatButton
            text: "♻"
            font.pointSize: 24
            width: 48
            height: 48
            onClicked: {
                print("message ID: " + messageId);
                main.retweetAsked(messageId);
            }
        }
    }
}
