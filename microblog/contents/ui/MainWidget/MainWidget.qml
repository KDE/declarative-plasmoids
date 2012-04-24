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
    PlasmaExtras.Title {
        id: timelineTitle
        text: timelinewithfriends.timelineType
        anchors.top: parent.top
        anchors.topMargin: _s
        anchors.leftMargin: _s
        anchors.left: parent.left
        anchors.right: parent.right
        //height: _s*4
        MouseArea {
            anchors.fill: parent
            onPressed: {
                topItem.state = "expanded"
                accountsButton.checked = false;
                topView.visible = true;
                accountsDialog.visible = false;
                topItem.expandedHeight = 160;
                //enabled = false
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
            //topItem.state = "collapsed";
            postingWidget.visible = checked;
            topView.visible = false;
            accountsDialog.visible = false;
            topItem.expandedHeight = 160;

            //timelinewithfriends.timelineType = "Timeline"
            main.authorized = true; // hack, should be updated also without AuthorizationStatus or Widet
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
            if (checked) {
                topItem.state = "expanded"
                topView.visible = false;
                accountsDialog.visible = true;
                topItem.expandedHeight = 400;
            } else {
                topItem.state = "collapsed";
            }
            //PlasmaExtras.AppearAnimation { targetItem: accountsDialog }
        }
    }

    PlasmaCore.FrameSvgItem {
        id: topItem
        property string expandedHeight: topView.contentHeight + _s*2
        //objectName: "frame"
        enabledBorders: "BottomBorder"
        //anchors.fill: parent
        imagePath: "dialogs/background"
        //color: "yellow"
        anchors.leftMargin: -5
        anchors.rightMargin: -5
        //width: parent.width
        anchors.left: parent.left
        anchors.right: parent.right
        //width: topView.contentWidth
        anchors.top: timelineTitle.bottom
        //height: topView.contentHeight
        height: (state == "collapsed") ? 0 : expandedHeight
        Behavior on height {
            NumberAnimation { duration: 300; easing.type: Easing.OutExpo; }
        }
        visible: height > 20
        z: 1
        state: "collapsed"

        ListView {
            id: topView
            anchors.fill: parent
            anchors.margins: _s
            model: topModel
            interactive: false
        }

        Accounts {
            id: accountsDialog
            anchors.fill: parent
            height: visible ? 400 : 0;
            visible: false
            anchors { left: parent.left; right: parent.right; top: timelineTitle.bottom; bottomMargin: _s}
        }

    }
    VisualItemModel {
        id: topModel

        PlasmaComponents.ToolButton {
            text: i18n("TimeLine");
            font.pointSize: timelineTitle.font.pointSize
            height: _s*4
            onClicked: {
                topItem.state = "collapsed"
                timelinewithfriends.timelineType = "TimelineWithFriends"
            }
            //onPressed: topItem.state = "expanded"
        }
        PlasmaComponents.ToolButton {
            text: i18n("Replies");
            font.pointSize: timelineTitle.font.pointSize
            height: _s*4
            //onPressed: topItem.state = "expanded"
            onClicked: {
                topItem.state = "collapsed"
                timelinewithfriends.timelineType = "Replies"
            }
        }
        PlasmaComponents.ToolButton {
            text: i18n("My tweets");
            font.pointSize: timelineTitle.font.pointSize
            height: _s*4
            onClicked: {
                topItem.state = "collapsed"
                timelinewithfriends.timelineType = "Timeline"
            }
        }
    }

    PostingWidget {
        id: postingWidget;
        height: visible ? 160 : 0

        Behavior on height {
            NumberAnimation { duration: 300; easing.type: Easing.OutExpo; }
        }

        anchors { left: parent.left; right: parent.right; top: timelineTitle.bottom; bottomMargin: _s}
    }

    MessageList {
        id: timelinewithfriends
        clip: true
        title: i18n("Timeline")
        timelineType: "TimelineWithFriends"
        //height: mainFlickable.height - tabBar.height - topItem.height - _s*2
        //width: mainFlickable.width
        anchors { top: postingWidget.bottom; left: parent.left; right: parent.right; bottom: parent.bottom; margins: _s }
        //header: 
//         header: MessageListHeader {
//             text: timelinewithfriends.title
//         }
    }

    Component.onCompleted: accountsDialog.visible = true
//     MessageList {
//         id: timelinewithfriends
//         anchors.left: mainFlickable.left
//         anchors.right: mainFlickable.right
//         height: mainFlickable.height - tabBar.height
//         header: MessageListHeader { }
//         
//     }
}