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

import Qt 4.7
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.qtextracomponents 0.1 as QtExtraComponents

Rectangle {
    id: messageWidgetDetails
    color: Qt.rgba(0,0,0,0.7)
    state: hidden

    property string messageId
    property string user
    property string source
    property bool isFavorite
    property string status

    states: [
        State {
            name: "visible"
            PropertyChanges { target: messageWidgetDetails; opacity: 1 }
            PropertyChanges { target: mainTranslate; y: 0 }
        },
        State {
            name: "hidden"
            PropertyChanges { target: messageWidgetDetails; opacity: 0 }
            PropertyChanges { target: mainTranslate; y: -messageWidgetDetails.height }
        }
    ]

    transitions: [
        Transition {
            ParallelAnimation {
            NumberAnimation { properties: "opacity"; duration: 500 }
            NumberAnimation { properties: "y"; duration: 500 }
            }
        }
    ]

    MouseArea {
        anchors.fill: parent
        onClicked: messageWidgetDetails.state = "hidden"

        PlasmaCore.FrameSvgItem {
            id: frame
            imagePath: "widgets/background"

            anchors.centerIn: parent
            width: parent.width/1.5
            height: parent.height/1.5

            transform: Translate { id: mainTranslate; y: 0 }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    mouse.accepted = true
                }
            }

            Item {
                id: padding
                anchors.fill: parent
                anchors.leftMargin: frame.margins.left
                anchors.topMargin: frame.margins.top
                anchors.rightMargin: frame.margins.right
                anchors.bottomMargin: frame.margins.bottom
            }

            QtExtraComponents.QImageItem {
                id: userIcon
                smooth: true
                anchors.left: padding.left
                anchors.verticalCenter: parent.verticalCenter
                width: 64
                height: 64
                // FIXME: [bla][bla] doesn't work :/
                //image: microblogSource.data["UserImages:"+serviceUrl][user]
            }
            Text {
                id: infoLabel
                anchors.leftMargin: 5
                anchors.left: userIcon.right
                anchors.right: padding.right
                anchors.top: padding.top
                text: i18n("%1 from %2", user, source)
                font.pointSize: 15
            }
            Row {
                id: toolBoxRow
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: padding.bottom
                PlasmaWidgets.ToolButton {
                    id: favoriteButton
                    text: "♥"
                    //font.pointSize: 30
                    width: 24
                    height: 24
                    down: isFavorite
                    onClicked: {
                        main.favoriteAsked(id, isFavorite != "true");
                    }
                }
                PlasmaWidgets.ToolButton {
                    id: replyButton
                    text: "@"
                    //font.pointSize: 30
                    width: 24
                    height: 24
                    onClicked: {
                        main.replyAsked(id, "@" + user + ": ");
                    }
                }
                PlasmaWidgets.ToolButton {
                    id: repeatButton
                    text: "♻"
                    //font.pointSize: 30
                    width: 24
                    height: 24
                    onClicked: {
                        main.retweetAsked(id);
                    }
                }
            }
            Text {
                id: bodyText
                anchors.leftMargin: 5
                anchors.left: userIcon.right
                anchors.right: padding.right
                anchors.top: infoLabel.bottom
                anchors.bottomMargin: 5
                text: status
                font.pointSize: 20
                wrapMode: Text.WordWrap
            }
        }
    }
}