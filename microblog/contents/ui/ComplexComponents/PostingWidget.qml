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
    state: "inactive"
    anchors.margins: 12

    property string inReplyToStatusId: ""

    function refresh()
    {
        //postTextEdit.text = ""
        Logic.refresh()
//         plasmoid.busy = true
    }
    function post() {
//         Logic.userName = userName;
//         Logic.serviceUrl = serviceUrl;
//         Logic.update(postTextEdit.text, inReplyToStatusId);
        //Logic.refresh();
        postStatusLabel.text = i18n("Sending tweet...")
        postTextEdit.enabled = false
        sendButton.enabled = false
        //refreshTimer.running = true;

        print("Posting update: " + postTextEdit.text);
        var src = "TimelineWithFriends:" + userName + "@" + serviceUrl;
        var service = microblogSource.serviceForSource(src)
        var operation = service.operationDescription("update");
        operation.status = postTextEdit.text;
        operation.in_reply_to_status_id = inReplyToStatusId

        function result(job) {
            //print(" XXX Post Result: " + job.result + " op: " + job.operationName);
            postStatusLabel.text = job.result ? i18n("Tweet posted. Refreshing timeline...") : i18n("Posting failed.")
            print(" __ " + postStatusLabel.text);
            postTextEdit.enabled = true;
            if (job.result) {
                postTextEdit.text = "";
                inReplyToStatusId = "";
            }
            sendButton.enabled = true;
            refreshTimer.running = true;
        }

        //var operation = service.operationDescription(operation);
//         operation.id = id;
        var serviceJob = service.startOperationCall(operation);
        serviceJob.finished.connect(result);
    }

//     AuthorizationWidget {
//         id: authStatusWidget
//         anchors { left: parent.left; right: postWidget.left; verticalCenter: postWidget.verticalCenter; }
//         //Rectangle { anchors.fill: postWidget; color: "blue"; opacity: 0.3 }
//     }
    //    visible: main.authorized

//     PlasmaCore.FrameSvgItem {
//         id: postWidget
//         height: 200
//         anchors.left: parent.left
//         anchors.right: parent.right
//         //imagePath: "widgets/frame"
//         //prefix: "plain"
//         visible: authStatusWidget.status == "Ok"
//         property alias textWidth: postTextEdit.width
//         anchors.horizontalCenter: parent.horizontalCenter
// 
// //         PlasmaComponents.Label {
// //             anchors.top: profileIcon.bottom
// //             text: userName
// //         }

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

        Connections {
            target: main
            onReplyAsked: {
                inReplyToStatusId = id
                postTextEdit.text = message
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
    PlasmaComponents.Label {
        id: postStatusLabel
        anchors { bottom: parent.bottom; left: parent.left; right: sendButton.left; topMargin: 12; }
    }
    PlasmaComponents.Button {
        id: sendButton
        text: i18n("Post")
        visible: postTextEdit.text != ""
        anchors { bottom: parent.bottom; right: postTextEdit.right; topMargin: 12; }
        onClicked: {
            print("button clicked");
            post();
        }
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

//     states: [
//         State {
//             name: "active"
// //             PropertyChanges { target: topItem; height: 120 }
//             PropertyChanges { target: pwItem; width: 384 }
// //             PropertyChanges { target: authStatusWidget; height: 64 }
//         },
//         State {
//             name: "inactive"
// //             PropertyChanges { target: topItem; height: 64 }
//             PropertyChanges { target: pwItem; width: 320 }
// //             PropertyChanges { target: authStatusWidget; height: 32 }
//         }
//     ]
// 
//     property int animation_duration: 150
// 
//     transitions: [
//         Transition {
//             from: "inactive"; to: "active"
// //             PropertyAnimation { target: topItem; properties: "height"; duration: animation_duration }
//             PropertyAnimation { target: pwItem; properties: "width"; duration: animation_duration }
// //             PropertyAnimation { target: authStatusWidget; properties: "height"; duration: animation_duration }
//         },
//         Transition {
//             from: "active"; to: "inactive"
// //             PropertyAnimation { target: topItem; properties: "height"; duration: animation_duration }
//             PropertyAnimation { target: pwItem; properties: "width"; duration: animation_duration }
// //             PropertyAnimation { target: authStatusWidget; properties: "height"; duration: animation_duration }
//         }
//     ]
//     Component.onCompleted: {
//         //topItem.height = 120
//     }
    Component.onCompleted: {
        print("PostingWidget.onCompleted:");
    }
}