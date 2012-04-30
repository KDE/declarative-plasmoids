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

import "plasmapackage:/ui/ComplexComponents"
import "plasmapackage:/ui/BasicComponents"

Item {
    id: mainFlickable

//     PlasmaComponents.TabBar {
//         id: tabBar
//         anchors.left: parent.left
//         anchors.right: parent.right
//         PlasmaComponents.TabButton {
//             text: i18n("TimeLine");
//             onClicked: timelinewithfriends.timelineType = "TimelineWithFriends"
//         }
//         PlasmaComponents.TabButton {
//             text: i18n("Replies");
//             onClicked: timelinewithfriends.timelineType = "Replies"
//         }
//         PlasmaComponents.TabButton {
//             text: i18n("My tweets");
//             onClicked: timelinewithfriends.timelineType = "Timeline"
//         }
//     }
//
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
        //height: _s*4
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

                    topView.visible = true;
                    accountsDialog.visible = false;
                    topItem.expandedHeight = 160;
                    //enabled = false
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
        checked: postingWidget.visible
        anchors.verticalCenter: timelineTitle.verticalCenter
        anchors.right: accountsButton.left
//         anchors.rightMargin: _s
        checkable: true
        onClicked: {
            accountsButton.checked = false;
            topItem.state = checked ? "post" : "collapsed"
            return;
            //topItem.state = "collapsed";
            if (checked) {
                topItem.visible = true;
                postingWidget.visible = true;
                topView.visible = false;
                accountsDialog.visible = false;
                topItem.expandedHeight = 160;
                topItem.state = "expanded";
            } else {
                topItem.state = "collapsed"
            }
            //timelinewithfriends.timelineType = "Timeline"
            main.authorized = true; // hack, should be updated also without AuthorizationStatus or Widget
        }
    }

    PlasmaComponents.ToolButton {
        id: accountsButton
        width: 48
        height: 48
        iconSource: "system-users"
        checkable: true
        //checked: postingWidget.visible
        anchors.verticalCenter: timelineTitle.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: _s
        onClicked: {
            postButton.checked = false;
            topItem.state = checked ? "accounts" : "collapsed";
            return;
//             if (checked) {
//                 topItem.visible = true;
//                 topItem.state = "expanded"
//                 topView.visible = false;
//                 accountsDialog.visible = true;
//                 topItem.expandedHeight = 400;
//                 postingWidget.visible = false;
// 
//             } else {
//                 topItem.state = "collapsed";
//             }
            //PlasmaExtras.AppearAnimation { targetItem: accountsDialog }
        }
    }

    Item {
        id: topItem
        property string expandedHeight: topView.contentHeight + _s*2
        clip: true
        //visible: state != "collapsed"
        //objectName: "frame"
        //enabledBorders: "BottomBorder"
        //anchors.fill: parent
        //imagePath: "dialogs/background"
        //color: "yellow"
        anchors.leftMargin: -5
        anchors.rightMargin: -5
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: timelineTitle.bottom
        Behavior on height {
            NumberAnimation { duration: 3000; easing.type: Easing.OutExpo; }
        }
        //visible: height > 20
        z: 1
        state: "collapsed"

        states: [
            State {
                name: "collapsed"
                PropertyChanges { target: topItem; height: 0}
            },
            State {
                name: "accounts"
                PropertyChanges { target: topItem; height: 400}
            },
            State {
                name: "timelines"
                PropertyChanges { target: topItem; height: 180}
            },
            State {
                name: "post"
                PropertyChanges { target: topItem; height: 180 }
            }
        ]

        onStateChanged: {
            clearPsTimer.running = false
            print("State changed to:::: " + state);
            if (state != "collapsed") {
                topStack.clear();
            }
            print(" is accounts?????? " + (topStack.currentPage == accountsComponent));
            if (state == "accounts") {
                if (topStack.currentPage != accountsComponent) topStack.push(accountsComponent);
                print(" is accounts?????? " + (topStack.currentPage == accountsComponent));
            } else if (state == "post") {
                if (topStack.currentPage != postComponent) topStack.push(postComponent);
//                 topStack.replace(postingWidget);
            } else if (state == "timelines") {
                if (topStack.currentPage != timelinesComponent) topStack.push(timelinesComponent);
//                 topStack.replace(timelinesList);
            } else {
//                 print("clear()");
                //topStack.clear();
                clearPsTimer.running = true
            }
        }

        Timer {
            id: clearPsTimer
            interval: 3000
            onTriggered: {
                print("clear()");
                topStack.clear();
            }
        }

        PlasmaComponents.PageStack {
            id: topStack
            anchors.fill: parent
            initialPage: Item {}
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
            Component {
                id: postComponent
                PostingWidget {
                    id: postingWidget;
                }
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
//                 topItem.visible = false;
                topItem.state = "collapsed"
                timelinewithfriends.timelineType = "TimelineWithFriends"
            }
            //onPressed: topItem.state = "expanded"
        }
        PlasmaComponents.ToolButton {
            text: typeToTitle("Replies");
            font.pointSize: timelineTitle.font.pointSize
            height: _s*4
            //onPressed: topItem.state = "expanded"
            onClicked: {
//                 topItem.visible = false;
                topItem.state = "collapsed"
                timelinewithfriends.timelineType = "Replies"
            }
        }
        PlasmaComponents.ToolButton {
            text: typeToTitle("Timeline");
            font.pointSize: timelineTitle.font.pointSize
            height: _s*4
            onClicked: {
//                 topItem.visible = false;
                topItem.state = "collapsed"
                timelinewithfriends.timelineType = "Timeline"
            }
        }
    }


    MessageList {
        id: timelinewithfriends
        clip: true
        title: i18n("Timeline")
        timelineType: "TimelineWithFriends"
        //height: mainFlickable.height - tabBar.height - topItem.height - _s*2
        //width: mainFlickable.width
        anchors { top: topItem.bottom; left: parent.left; right: parent.right; bottom: parent.bottom; margins: _s }
        //header: 
//         header: MessageListHeader {
//             text: timelinewithfriends.title
//         }
    }

    //Component.onCompleted: accountsDialog.visible = true
//     MessageList {
//         id: timelinewithfriends
//         anchors.left: mainFlickable.left
//         anchors.right: mainFlickable.right
//         height: mainFlickable.height - tabBar.height
//         header: MessageListHeader { }
//         
//     }
}