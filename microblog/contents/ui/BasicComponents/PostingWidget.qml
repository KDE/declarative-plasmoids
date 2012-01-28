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
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1 as QtExtraComponents

import "plasmapackage:/code/logic.js" as Logic
import "plasmapackage:/ui/BasicComponents"
import "plasmapackage:/ui/ComplexComponents"

Item {
    id: pwItem
    //width: 300
    //height: 300
    state: "inactive"
    visible: authStatusWidget.status == "Ok"

    function refresh()
    {
        postTextEdit.text = ""
        postTextEdit.inReplyToStatusId = ""
        Logic.refresh()
        plasmoid.busy = true
    }
    //Rectangle { anchors.fill: postWidget; color: "blue"; opacity: 0.3 }

    AuthorizationWidget {
        id: authStatusWidget
        anchors { left: parent.left; verticalCenter: postWidget.verticalCenter; }
    }

    PlasmaCore.FrameSvgItem {
        id: postWidget
        //width: 520
        anchors.fill: parent
        imagePath: "widgets/frame"
        prefix: "plain"
        property alias textWidth: postTextEdit.width

        Avatar {
            id: profileIcon
            height: 32
            width: height
            anchors.left: postWidget.left
            anchors.verticalCenter: postTextEdit.verticalCenter
            userId: userName
        }
//         PlasmaComponents.Label {
//             anchors.top: profileIcon.bottom
//             text: userName
//         }

        PlasmaComponents.TextArea {
            id: postTextEdit
            placeholderText: i18n("Share your thoughts...")
            height: 90
            interactive: false
            //width: 300

            anchors {
                left: profileIcon.right
                right: postWidget.right
                top: postWidget.top
                bottom: postWidget.bottom
                rightMargin: postWidget.margins.right
                leftMargin: 6
                topMargin: postWidget.margins.top
            }
            wrapMode: TextEdit.WordWrap
            property string inReplyToStatusId: ""

            onTextChanged: {
                var txt = text; // prevent copying text more often than necessary
                characterCountLabel.characterCount = txt.length;
                //yes, TextEdit doesn't have returnPressed sadly
                if (txt[txt.length-1] == "\n") {
                    //Logic.update(txt, inReplyToStatusId);
                    //refresh();
                    print(" RETURN ");
                } else if (txt.length == 0) {
                    inReplyToStatusId = ""
                }
            }

            Keys.onReturnPressed: {
                //Logic.update(txt, inReplyToStatusId);
                //refresh();
                print(" Sending Update: " + txt + " to statusId: " + inReplyToStatusId);
                ///print(" sending update");
            }

            onActiveFocusChanged: {
                print("Focus " + activeFocus);
                activeFocus ? pwItem.state = "active" : pwItem.state = "inactive";
            }

            Connections {
                target: main
                onReplyAsked: {
                    postTextEdit.inReplyToStatusId = id
                    postTextEdit.text = message
                }
                onRetweetAsked: {
                    Logic.retweet(id)
                    refresh()
                }
                onFavoriteAsked: {
                    print(id)
                    print(isFavorite)
                    Logic.setFavorite(id, isFavorite)
                    refresh()
                }
            }
        }
        PlasmaComponents.Label {
            id: characterCountLabel
            anchors { bottom: postTextEdit.bottom; right: postTextEdit.right; rightMargin: 8 }
            property int characterCount: 0
            opacity: 0.6
            visible: (characterCount != 0 && postTextEdit.activeFocus)

            onCharacterCountChanged: {
                text = 140 - characterCount;
                if (characterCount <= 140) {
                    color = "green"
                } else {
                    color = "red"
                }
            }
        }
    }

    states: [
        State {
            name: "active"
            PropertyChanges { target: topItem; height: 120 }
            PropertyChanges { target: pwItem; width: 384 }
            PropertyChanges { target: profileIcon; height: 64 }
        },
        State {
            name: "inactive"
            PropertyChanges { target: topItem; height: 64 }
            PropertyChanges { target: pwItem; width: 320 }
            PropertyChanges { target: profileIcon; height: 32 }
        }
    ]

    property int animation_duration: 150

    transitions: [
        Transition {
            from: "inactive"; to: "active"
            PropertyAnimation { target: topItem; properties: "height"; duration: animation_duration }
            PropertyAnimation { target: pwItem; properties: "width"; duration: animation_duration }
            PropertyAnimation { target: profileIcon; properties: "height"; duration: animation_duration }
        },
        Transition {
            from: "active"; to: "inactive"
            PropertyAnimation { target: topItem; properties: "height"; duration: animation_duration }
            PropertyAnimation { target: pwItem; properties: "width"; duration: animation_duration }
            PropertyAnimation { target: profileIcon; properties: "height"; duration: animation_duration }
        }
    ]
    Component.onCompleted: {
        //topItem.height = 120
    }
}
