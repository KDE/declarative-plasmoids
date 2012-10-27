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

import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras
import org.kde.qtextracomponents 0.1 as QtExtraComponents

import org.kde.socialfeed 0.1 as SocialFeedObject

import "plasmapackage:/ui/ComplexComponents"
import "plasmapackage:/ui/BasicComponents"

Item {
    id: mainFlickable

    SocialFeedObject.SocialFeed {
        id: socialFeed
    }

    PlasmaExtras.Title {
        id: timelineTitle
        text: "Social Feed"
        anchors.top: parent.top
        anchors.topMargin: _s
        anchors.leftMargin: _s
        anchors.left: parent.left
        anchors.right: parent.right

//         MouseArea {
//             anchors.fill: parent
//             onPressed: {
//                 accountsButton.checked = false;
//                 postButton.checked = false;
//                 topItem.state = (topItem.state != "timelines") ? "timelines" : "collapsed"
//             }
//         }
    }

    PlasmaComponents.ToolButton {
        id: postButton
        width: 48
        height: 48
        iconSource: "story-editor"

        checked: {
            if (typeof(postingWidget) != "undefined") {
                postingWidget.visible;
            } else {
                false;
            }
        }
        anchors.verticalCenter: timelineTitle.verticalCenter
        anchors.right: parent.right
        checkable: true
        onClicked: {
            topItem.state = checked ? "post" : "collapsed"
            return;
        }
    }

//TODO: integrate with webaccounts once ready
//     PlasmaComponents.ToolButton {
//         id: accountsButton
//         width: 48
//         height: 48
//         iconSource: "system-users"
//         checkable: true
//         opacity: main.authorizationStatus != "Ok" ? 1.0 : 0.0
//         Behavior on opacity {
//             NumberAnimation { duration: 200; }
//         }
//         anchors.verticalCenter: timelineTitle.verticalCenter
//         anchors.right: parent.right
//         anchors.rightMargin: _s
//         onClicked: {
//             postButton.checked = false;
//             topItem.state = checked ? "accounts" : "collapsed";
//             return;
//         }
//     }
    QtExtraComponents.QIconItem {
        width: 32; height: width
        icon: "arrow-up"
        opacity: topItem.state == "userinfo" || topItem.state == "message" ? 1.0 : 0
        anchors { top: accountsButton.bottom; horizontalCenter: accountsButton.horizontalCenter; margins: 12 }
        Behavior on opacity {
            NumberAnimation { duration: 200; }
        }
        MouseArea {
            anchors.fill: parent;
            onClicked: topItem.state = "collapsed"
        }
    }

    Item {
        id: topItem
//         property string expandedHeight: topView.contentHeight + _s*2
        property string activeUser: main.userName
        clip: true
        anchors.leftMargin: -10
        anchors.rightMargin: -10
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: timelineTitle.bottom
        Behavior on height {
            NumberAnimation { duration: 300; easing.type: Easing.OutExpo; }
        }
        z: 1
        state: "collapsed"

        states: [
            State {
                name: "collapsed"
                PropertyChanges { target: topItem; height: 0 }
            },
//             State {
//                 name: "accounts"
//                 PropertyChanges { target: topItem; height: 400 }
//             },
            State {
                name: "post"
                PropertyChanges { target: topItem; height: 180 }
            }
        ]

        onStateChanged: {
            clearPsTimer.running = false
            //print("State changed to:::: " + state);
            if (state != "collapsed") {
                topStack.clear();
            }
            if (state == "post") {
                if (topStack.currentPage != postingWidget) topStack.push(postingWidget);
            } else {
                clearPsTimer.running = true
            }
        }
        onActiveUserChanged: {
            print("Active user: " + topItem.activeUser);
        }

        Timer {
            id: clearPsTimer
            interval: 300
            onTriggered: {
                //print("clear()");
                topStack.clear();
            }
        }

        PlasmaComponents.PageStack {
            id: topStack
            anchors.fill: parent
            initialPage: Item {}
            anchors.rightMargin: _s
            anchors.leftMargin: _s
//             Component {
//                 id: accountsComponent
//                 Accounts {
//                     id: accountsDialog
//                 }
//             }
            PostingWidget {
                id: postingWidget;
            }
        }
    }

    Component {
        id: timelineDelegate
        PlasmaComponents.ListItem {
            enabled: true
            PlasmaExtras.Heading {
                level: 3
                text: typeToTitle(timelineType)
            }
            onClicked: {
                topItem.state = "collapsed";
                timelinewithfriends.timelineType = timelineType
            }
        }
    }

    function showPostingWidget() {
        topItem.state = "post";
    }

    MessageList {
        id: timelinewithfriends
        clip: true
        title: i18n("Timeline")
        timelineType: "TimelineWithFriends"
        anchors { top: topItem.bottom; left: parent.left; right: parent.right; bottom: parent.bottom; margins: _s }
    }

}
