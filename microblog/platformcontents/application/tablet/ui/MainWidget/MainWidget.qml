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
import org.kde.plasma.mobilecomponents 0.1 as MobileComponents
import org.kde.qtextracomponents 0.1 as QtExtraComponents

import "plasmapackage:/ui/ComplexComponents"
import "plasmapackage:/ui/BasicComponents"

Image {
    id: mainWidget
    source: "plasmapackage:/images/background.png"
    fillMode: Image.Tile
    property Component configComponent: Qt.createComponent("ConfigWidget.qml")

    PlasmaExtras.App {
        id: myApp
        anchors.top: parent.top
        anchors.left: mainWidget.left
        anchors.bottom: mainWidget.bottom
        anchors.right: mainWidget.right
        clip: true

//         tools: toolbarlayout
        content: mainFlickable
        navigation: sideBar
        navigationWidth: 0

        PlasmaComponents.ToolBarLayout {
            id: toolbarlayout
            width: myApp.width
            z: 10
            PlasmaComponents.ToolButton {
                id: postButton
                width: 48
                height: 48
                iconSource: "story-editor"
                checked: sideBar.activePage == "PostingWidget" && myApp.navigationWidth > 72
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        myApp.navigationWidth = 300;
                        sideBar.activePage = "PostingWidget";
                    }
                    onPressed: PlasmaExtras.PressedAnimation { targetItem: postButton }
                    onReleased: PlasmaExtras.ReleasedAnimation { targetItem: postButton }
                }
            }

            Item {
                id: searchHeader
                x: postButton.width + _m
                height: childrenRect.height
                anchors.verticalCenter: parent.verticalCenter
                //anchors.left: postButton.right
                PlasmaComponents.ToolButton {
                    id: searchToolButton
                    iconSource: "edit-find"
                    checkable: true
                    width: 48
                    height: 48
                    anchors { left: parent.left;
                            leftMargin: 12; rightMargin: 12 }
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: feedsList.positionViewAtIndex(feedsList.count-1, ListView.Visible)

                }
                PlasmaComponents.TextField {
                    id: txtEdit
                    height: searchButton.height*1.1
                    visible: searchToolButton.checked
                    anchors { left: searchToolButton.right;
                            leftMargin: 24; rightMargin: 12 }
                    anchors.verticalCenter: parent.verticalCenter
                    Keys.onReturnPressed: searchTimeline(txtEdit.text);
                }
                PlasmaComponents.Button {
                    id: searchButton
                    text: i18n("Search")
                    visible: searchToolButton.checked
                    width: 96
                    height: 32
                    anchors { left: txtEdit.right;
                            leftMargin: 12; rightMargin: 24 }
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: searchTimeline(txtEdit.text)
                }
            }
            AuthorizationWidget {
                id: authStatusWidget
                //anchors { top: parent.top; right: parent.right; rightMargin: -12; }
                height: 48
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        accountsPopup.state = accountsPopup.state == "expanded" ? "collapsed" : "expanded"
                    }
                    onPressed: PlasmaExtras.PressedAnimation { targetItem: authStatusWidget }
                    onReleased: PlasmaExtras.ReleasedAnimation { targetItem: authStatusWidget }
                }
            }
            Component.onCompleted: myApp.tools = toolbarlayout
        }

        SideBar {
            id: sideBar
            width: myApp.navigationWidth
            clip: false
            PlasmaComponents.ToolButton {
                property bool exp: myApp.navigationWidth > 72
                width: 48
                height: 48
                anchors { right: parent.right; bottom: parent.bottom; }
                iconSource: "arrow-left"
                onClicked: myApp.navigationWidth = exp ? 0 : 300
            }
        }

        Item {
            id: mainFlickable
            clip: false
            width: myApp.contentWidth
            height: myApp.height-toolbarlayout.height-48
            property int columnWidth: colWidth(mainFlickable.width)

            ListView {
                id: feedsList
                orientation: ListView.Horizontal
                snapMode: ListView.SnapOneItem
                cacheBuffer: mainFlickable.columnWidth
                boundsBehavior: Flickable.DragOverBounds

                anchors.fill: parent
                spacing: 12
                model: feedsModel
                PlasmaComponents.ScrollBar {
                    id: scrollBar
                    orientation: Qt.Horizontal
                    flickableItem: feedsList
//                     stepSize: 100
//                     scrollButtonInterval: 100
                    interactive: true
                    z: 10
                    anchors {
                        left: feedsList.left
                        right: feedsList.right
                        top: feedsList.bottom
                    }
                }
            }

            function colWidth(mainWidth) {
                var cols = Math.round(Math.max(1, (mainWidth/450)));
                var w = (mainWidth/cols);
                return w;
            }

            VisualItemModel {
                id: feedsModel
                MessageList {
                    id: timelinewithfriends
                    timelineType: "TimelineWithFriends"
                    height: mainFlickable.height
                    header: MessageListHeader {
                        text: timelinewithfriends.title
                    }
                }
                MessageList {
                    id: mytimeline
                    timelineType: "Timeline"
                    height: mainFlickable.height
                    header: MessageListHeader {
                        text: mytimeline.title
                    }
                }
                MessageList {
                    id: repliestimeline
                    timelineType: "Replies"
                    height: mainFlickable.height
                    header: MessageListHeader {
                        text: repliestimeline.title
                    }
                }
                MessageList {
                    id: searchtimeline
                    title: searchQuery == "" ? i18n("Search") : searchQuery
                    timelineType: "SearchTimeline"
                    source: timelineType+":"+userName+"@"+url+":q=" + searchQuery
                    height: mainFlickable.height
                    visible: searchQuery != ""
                    header: MessageListHeader {
                        text: searchtimeline.title
                    }
                }
            }
        }

        AccountsPopup {
            id: accountsPopup
            anchors { right: parent.right; top: toolbarlayout.bottom; }
        }

    }
    function showPostingWidget() {
        sideBar.activePage = "PostingWidget";
    }

    function showMessage(item) {
        myApp.navigationWidth = 300;
        sideBar.user = item.user
        sideBar.dateTime = item.dateTime
        sideBar.source = stripHtml(item.source)
        sideBar.isFavorite = item.isFavorite
        sideBar.activePage = "MessageDetails"
        sideBar.messageId = item.messageId
        sideBar.message = item.message
    }

    function showUserInfo(userId) {
        myApp.navigationWidth = 300;
        sideBar.activePage = "UserInfo"
        sideBar.activeUser = userId
    }

    function searchTimeline(txt) {
        //print("Loading timeline: " + txt);
        var tl = "SearchTimeline:"+userName+"@"+serviceUrl+":q="+txt;
        //src = tl;
        searchtimeline.source = tl;
        searchQuery = txt;
//         feedsList.positionViewAtIndex(feedsList.count-1, ListView.Visible);
    }
    MessageWidgetDetails {
        id: messageDetails
        anchors.fill: parent
        state: "hidden"
    }
}
