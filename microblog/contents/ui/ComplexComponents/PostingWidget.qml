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
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras
import org.kde.qtextracomponents 0.1 as QtExtraComponents

import "plasmapackage:/code/logic.js" as Logic
import "plasmapackage:/ui/BasicComponents"
import "plasmapackage:/ui/ComplexComponents"

PlasmaComponents.Page {
    id: pwItem
    //width: 300
    //height: 300

    property string title
    property string inReplyToStatusId: ""

    state: "inactive"
    anchors.margins: 12

    function refresh() {
//         socialFeed.onResfreshCollections()
    }
    function post() {
        postTextOverlay.visible= true
        postTextEdit.enabled = false
        sendButton.enabled = false
        netsList.enabled = false

        print("Posting update: " + postTextEdit.text);
        socialFeed.onPostMessage(postTextEdit.text)
    }
    function postDone() {
        postTextOverlay.visible = false
        postTextEdit.enabled = true
        postTextEdit.text = ""
        sendButton.enabled = true
        netsList.enabled = true
        topItem.state = "collapsed"
    }

    PlasmaExtras.Heading {
        height: text != "" ? 32 : 0
        id: heading
        level: 2
        text: title
        anchors {
                left: parent.left
                right: parent.right
                top: parent.top
        }
    }

    PlasmaComponents.TextArea {
        id: postTextEdit
        placeholderText: i18n("Share your thoughts...")
        height: 140
        interactive: false

        anchors {
            left: parent.left
            right: parent.right
            top: heading.bottom
            bottom: sendButton.top
        }
        wrapMode: TextEdit.WordWrap

        onTextChanged: {
            var txt = text; // prevent copying text more often than necessary
            characterCountLabel.characterCount = txt.length;
            //yes, TextEdit doesn't have returnPressed sadly
            if (txt[txt.length-1] == "\n") {
                //Logic.userName = userName;
                //Logic.serviceUrl = serviceUrl;
                //Logic.update(txt, inReplyToStatusId);
                //unfocus
                //refresh();
                //print(" should lose focus here: imlement");
                print("Enter");
                //post();
            } else if (txt.length == 0) {
                inReplyToStatusId = ""
            }
        }

        onActiveFocusChanged: {
            print("Focus " + activeFocus);
            activeFocus ? pwItem.state = "active" : pwItem.state = "inactive";
        }

        Timer {
            id: focusTimer
            interval: 200
            onTriggered: {
                print("Focusing");
                postTextEdit.forceActiveFocus();
                postTextEdit.cursorPosition = postTextEdit.text.length;
            }
        }

        Connections {
            target: main
            onReplyAsked: {
                inReplyToStatusId = id;
                print("PostingWidget Message: " + message + " " + id);
                postTextEdit.text = message;
                showPostingWidget();
                //postTextEdit.forceActiveFocus();
                focusTimer.running = true;
            }
            onRetweetAsked: {
                Logic.retweet(id)
                //refresh()
                refreshTimer.running = true
            }
//             onFavoriteAsked: {
//                 print(id)
//                 print(isFavorite)
//                 var j = Logic.setFavorite(id, isFavorite)
//                 refresh()
//             }
        }
    }

    Item {
        id: postTextOverlay
        anchors.centerIn: postTextEdit
        visible: false
        height: 32
        width: postSpinner.width + postStatusLabel.implicitWidth

        PlasmaComponents.BusyIndicator {
            id: postSpinner
            height: 32
            width: 32
            running: true
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
            }
        }
        PlasmaComponents.Label {
            id: postStatusLabel
            font.pointSize: theme.defaultFont.pointSize + 4
            text: i18n("Updating status...")
            height: 32
            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
                left: postSpinner.right
                verticalCenter: parent.verticalCenter
            }
        }
    }

    PlasmaComponents.Label {
        id: characterCountLabel
        anchors { bottom: postTextEdit.bottom; right: postTextEdit.right; rightMargin: 8 }
        property int characterCount: 0
        property int maxLength: 65535
        opacity: 0.6
        visible: (maxLength - characterCount < 200) //display the counter only if we have less than 200 chars left

        onCharacterCountChanged: {
            text = maxLength - characterCount;
            if (characterCount <= maxLength) {
                color = "green"
            } else if (maxLength - characterCount < 30) {
                color = "orange"
            } else if (characterCount > maxLength) {
                color = "red"
            }
        }
    }

    PlasmaComponents.Button {
        id: sendButton
        text: i18n("Post")
        //visible: postTextEdit.text != ""
        enabled: characterCountLabel.characterCount <= characterCountLabel.maxLength && characterCountLabel.characterCount > 0
        anchors {
            bottom: filler.top;
            right: postTextEdit.right;
            topMargin: 12;
        }
        onClicked: {
            post();
        }
    }

    ListView {
        id: netsList;
        orientation: ListView.Horizontal
        height: 50
        width: parent.width

        anchors {
            top: postTextEdit.bottom
            bottom: filler.top;
            left: postTextEdit.left;
            right: sendButton.left;
        }
        model: socialFeed.collectionsList
        delegate {
            PlasmaComponents.Button {
                id: iconButton
                checkable: true
                checked: model.modelData.checked
                width: sendButton.height
                height: sendButton.height
                property int maxPostLength: 0

                QtExtraComponents.QIconItem {
                    id: netIcon
                    icon: model.modelData.icon
                    width: sendButton.height - 4
                    height: sendButton.height - 4
                    state: QtExtraComponents.QIconItem.DisabledState
                    anchors {
                        centerIn: parent
                    }
                }
                onClicked: {
                    socialFeed.smallestMaxPostLength()
                    netIcon.state = netIcon.state == QtExtraComponents.QIconItem.DisabledState ? QtExtraComponents.QIconItem.DefaultState : QtExtraComponents.QIconItem.DisabledState
                    model.modelData.checked = iconButton.checked
                    characterCountLabel.maxLength = socialFeed.smallestMaxPostLength();
                    characterCountLabel.characterCountChanged();
                }
                PlasmaCore.ToolTip {
                    target: netIcon
                    mainText: model.modelData.name
                    //image: model.decoration //FIXME: 4.9 takes only icon name, not QIcon object
                }
                Component.onCompleted: {
                    characterCountLabel.maxLength = socialFeed.smallestMaxPostLength();
                    characterCountLabel.characterCountChanged();
                }
            }
        }
    }

    Item {
        id: filler
        height: parent.height-160
        anchors { bottom: parent.bottom; right: postTextEdit.right; topMargin: 12; }

    }
    Timer {
        id: refreshTimer
        interval: 5000
        repeat: false
        onTriggered: {
            //print("Refreshtimer triggered: , refreshing now.");
            //postStatusLabel.text = ""
            postTextEdit.enabled = true
            sendButton.enabled = true
            refresh();
        }
    }

    Connections {
        target: socialFeed
        onStatusUpdated: {
            postDone();
        }
    }

    Component.onCompleted: {
        print("PostingWidget.onCompleted:");
    }
}
