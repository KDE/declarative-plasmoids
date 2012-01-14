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


ListItem {
    //try to fix the height to 8 lines
    //height: infoLabel.height*6
    height: childrenRect.height
    //implicitHeight: infoLabel.height+bodyText.height

    property string messageId: model["Id"]
    property string user: model["User"]
    property string source: model["Source"]
    property bool isFavorite: model["IsFavorite"]
    property string status: model["Status"]

    QtExtraComponents.QImageItem {
        id: userIcon
        smooth: true
        anchors.left: padding.left
        anchors.top: padding.top
        anchors.topMargin: 12
        width: 32
        height: 32
        //image: microblogSource.data["UserImages:"+serviceUrl][user]
    }
    PlasmaComponents.Label {
        id: infoLabel
        anchors.leftMargin: 5
        anchors.bottomMargin: 12
        anchors.left: userIcon.right
        anchors.right: padding.right
        anchors.top: padding.top
        opacity: 0.5
        style: Text.Sunken
        text: i18n("%1 <font size=\"-2\">from %2</font>", user, source)
    }
    Row {
        id: toolBoxRow
        anchors.right: parent.right
        anchors.rightMargin: 5
        PlasmaComponents.ToolButton {
            id: favoriteButton
            text: "♥"
            width: 24
            height: 24
            checked: isFavorite
            onClicked: {
                main.favoriteAsked(messageId, isFavorite != "true");
            }
        }
        PlasmaComponents.ToolButton {
            id: replyButton
            text: "@"
            width: 24
            height: 24
            onClicked: {
                main.replyAsked(messageId, "@" + user + ": ");
            }
        }
        PlasmaComponents.ToolButton {
            id: repeatButton
            text: "♻"
            width: 24
            height: 24
            onClicked: {
                main.retweetAsked(messageId);
            }
        }
    }
    PlasmaComponents.Label {
        id: bodyText
        anchors.leftMargin: 5
        anchors.left: userIcon.right
        anchors.right: padding.right
        anchors.top: toolBoxRow.bottom
        anchors.topMargin: 8
        anchors.bottomMargin: 20
        text: status
        wrapMode: Text.WordWrap
    }
    Item { height: 12; anchors.top: bodyText.bottom; z: -1 }
}
