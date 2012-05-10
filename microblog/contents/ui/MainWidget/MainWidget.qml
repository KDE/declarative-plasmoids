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

import "plasmapackage:/ui/ComplexComponents"
import "plasmapackage:/ui/BasicComponents"

Item {
    id: mainFlickable

    function typeToTitle(tType) {
        if (tType == "TimelineWithFriends") {
            return i18n("Timeline");
        } else if (tType == "Timeline") {
            return i18n("My tweets");
        } else if (tType == "Replies") {
            return i18n("Replies");
        } else if (tType == "SearchTimeline") {
            return i18n("Search for " + main.searchQuery);
        } else {
            return i18n("Tweets");
        }
    }
    PlasmaExtras.Title {
        id: timelineTitle
        text: typeToTitle(timelinewithfriends.timelineType)
        anchors.top: parent.top
        anchors.topMargin: _s
        anchors.leftMargin: _s
        anchors.left: parent.left
        anchors.right: parent.right
        MouseArea {
            anchors.fill: parent
            onPressed: {
                accountsButton.checked = false;
                postButton.checked = false;
                topItem.state = (topItem.state != "timelines") ? "timelines" : "collapsed"
                return;
                if (topItem.state == "collapsed") {
                    topItem.visible = true;
                    topItem.state = "expanded"
                    accountsButton.checked = false;
                    postingWidget.visible = false;
                    userInfo.visible = false;
                    messageDetails.visible = false;

                    topView.visible = true;
                    accountsDialog.visible = false;
//                     topItem.expandedHeight = 160;
                } else {
                    topItem.visible = false;
                    topItem.state = "collapsed"
                }
            }
        }
    }
    PlasmaComponents.ToolButton {
        id: postButton
        width: 48
        height: 48
        iconSource: "story-editor"
        opacity: main.authorizationStatus == "Ok" ? 1.0 : 0.0
        Behavior on opacity {
            NumberAnimation { duration: 200; }
        }
        checked: {
            if (typeof(postingWidget) != "undefined") {
                postingWidget.visible;
            } else {
                false;
            }
        }
        anchors.verticalCenter: timelineTitle.verticalCenter
        anchors.right: accountsButton.left
        checkable: true
        onClicked: {
            accountsButton.checked = false;
            topItem.state = checked ? "post" : "collapsed"
            return;
        }
    }

    PlasmaComponents.ToolButton {
        id: accountsButton
        width: 48
        height: 48
        iconSource: "system-users"
        checkable: true
        opacity: main.authorizationStatus != "Ok" ? 1.0 : 0.0
        Behavior on opacity {
            NumberAnimation { duration: 200; }
        }
        anchors.verticalCenter: timelineTitle.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: _s
        onClicked: {
            postButton.checked = false;
            topItem.state = checked ? "accounts" : "collapsed";
            return;
        }
    }
    Avatar {
        id: accountsAvatar
        width: 32
        height: 32
        userId: main.userName
        opacity: main.authorizationStatus == "Ok" ? 1.0 : 0.0
        Behavior on opacity {
            NumberAnimation { duration: 200; }
        }
        anchors.verticalCenter: timelineTitle.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: _s
        MouseArea {
            anchors.fill: parent
            onClicked: {
                postButton.checked = false;
                topItem.state = topItem.state != "accounts" ? "accounts" : "collapsed";
                return;
            }
        }
        
    }
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
        property string activeUser: "PlasmaActive"
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
            State {
                name: "accounts"
                PropertyChanges { target: topItem; height: 400 }
            },
            State {
                name: "timelines"
                PropertyChanges { target: topItem; height: 180 }
            },
            State {
                name: "message"
                PropertyChanges { target: topItem; height: 280}
            },
            State {
                name: "post"
                PropertyChanges { target: topItem; height: 180 }
            },
            State {
                name: "userinfo"
                PropertyChanges { target: topItem; height: 420 }
            }
        ]

        onStateChanged: {
            clearPsTimer.running = false
            //print("State changed to:::: " + state);
            if (state != "collapsed") {
                topStack.clear();
            }
            if (state == "accounts") {
                if (topStack.currentPage != accountsComponent) topStack.push(accountsComponent);
                //print(" is accounts?????? " + (topStack.currentPage == accountsComponent));
            } else if (state == "message") {
                if (topStack.currentPage != messageDetails) topStack.push(messageDetails);
            } else if (state == "post") {
                if (topStack.currentPage != postingWidget) topStack.push(postingWidget);
            } else if (state == "timelines") {
                if (topStack.currentPage != timelinesComponent) topStack.push(timelinesComponent);
            } else if (state == "userinfo") {
                if (topStack.currentPage != userInfo) topStack.push(userInfo);
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
            Component {
                id: timelinesComponent
                PlasmaComponents.Page {
                    id: timelinesList
                    ListView {
                        id: topView
                        anchors.fill: parent
                        anchors.margins: _s
                        model: topModel
                        interactive: false
                    }
                }
            }
            Component {
                id: accountsComponent
                Accounts {
                    id: accountsDialog
                }
            }
            PostingWidget {
                id: postingWidget;
            }
            UserInfo {
                id: userInfo
                anchors.margins: _s
                //login: topItem.activeUser
            }
            MessageDetails {
                id: messageDetails
                anchors.margins: _s
                //login: topItem.activeUser
            }
        }
    }
    VisualItemModel {
        id: topModel

        PlasmaComponents.ToolButton {
            text: typeToTitle("TimelineWithFriends")
            font.pointSize: timelineTitle.font.pointSize
            height: _s*4
            onClicked: {
                topItem.state = "collapsed"
                timelinewithfriends.timelineType = "TimelineWithFriends"
            }
        }
        PlasmaComponents.ToolButton {
            text: typeToTitle("Replies");
            font.pointSize: timelineTitle.font.pointSize
            height: _s*4
            onClicked: {
                topItem.state = "collapsed"
                timelinewithfriends.timelineType = "Replies"
            }
        }
        PlasmaComponents.ToolButton {
            text: typeToTitle("Timeline");
            font.pointSize: timelineTitle.font.pointSize
            height: _s*4
            onClicked: {
                topItem.state = "collapsed"
                timelinewithfriends.timelineType = "Timeline"
            }
        }
    }

    function showPostingWidget() {
        topItem.state = "post";
    }

    function showMessage(item) {
            topItem.state = "message"
            messageDetails.user = item.user
            messageDetails.dateTime = item.dateTime
            messageDetails.source = stripHtml(item.source)
            messageDetails.isFavorite = item.isFavorite
            //messageDetails.activePage = "MessageDetails"
            messageDetails.messageId = item.messageId
            messageDetails.message = item.message
    }

    function showUserInfo(userId) {
        if (topItem.state == "userinfo" && userInfo.login == userId) {
            //topItem.state = "collapsed";
            return;
        }
        print("ShowUserInfo(" + userId + ")");
        //topItem.activeUser = userId;
        userInfo.login = userId;
        topItem.state = "userinfo";
    }


    MessageList {
        id: timelinewithfriends
        clip: true
        title: i18n("Timeline")
        timelineType: "TimelineWithFriends"
        //height: mainFlickable.height - tabBar.height - topItem.height - _s*2
        //width: mainFlickable.width
        anchors { top: topItem.bottom; left: parent.left; right: parent.right; bottom: parent.bottom; margins: _s }
    }

}