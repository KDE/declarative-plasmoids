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
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.qtextracomponents 0.1 as QtExtraComponents


ListItem {
    //try to fix the height to 8 lines
    height: infoLabel.height*6
    implicitHeight: infoLabel.height+bodyText.height

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
        width: 32
        height: 32
        image: microblogSource.data["UserImages:"+serviceUrl][user]
    }
    Text {
        id: infoLabel
        anchors.leftMargin: 5
        anchors.left: userIcon.right
        anchors.right: padding.right
        anchors.top: padding.top
        text: i18n("%1 from %2", user, source)
    }
    Row {
        id: toolBoxRow
        anchors.right: parent.right
        anchors.rightMargin: 5
        PlasmaWidgets.ToolButton {
            id: favoriteButton
            text: "♥"
            width: 24
            height: 24
            down: isFavorite
            onClicked: {
                main.favoriteAsked(messageId, isFavourite != "true");
            }
        }
        PlasmaWidgets.ToolButton {
            id: replyButton
            text: "@"
            width: 24
            height: 24
            onClicked: {
                main.replyAsked(messageId, "@" + user + ": ");
            }
        }
        PlasmaWidgets.ToolButton {
            id: repeatButton
            text: "♻"
            width: 24
            height: 24
            onClicked: {
                main.retweetAsked(messageId);
            }
        }
    }
    Text {
        id: bodyText
        anchors.leftMargin: 5
        anchors.left: userIcon.right
        anchors.right: padding.right
        anchors.top: toolBoxRow.bottom
        anchors.bottomMargin: 5
        text: status
        wrapMode: Text.WordWrap
    }
}
