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

        tools: toolbarlayout
        content: mainFlickable
        navigation: sideBar
        navigationWidth: 300

        PlasmaComponents.ToolBarLayout {
            id: toolbarlayout
            spacing: 5
            height: 48
            QtExtraComponents.QIconItem {
                id: iconItem
                width: 32
                height: 32
                icon: QIcon("story-editor")
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: sideBar.activePage = "PostingWidget"
                    onPressed: PlasmaExtras.PressedAnimation { targetItem: iconItem }
                    onReleased: PlasmaExtras.ReleasedAnimation { targetItem: iconItem }
                }
            }

            AuthorizationWidget {
                id: authStatusWidget
            }
        }
        Component.onCompleted: {
            myApp.tools = toolbarlayout
        }
        SideBar {
            id: sideBar
            width: myApp.navigationWidth
            clip: false
        }

        Item {
            id: mainFlickable
            clip: false
            width: myApp.contentWidth
            height: myApp.height-toolbarlayout.height
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
                    title: "Timeline"
                    timelineType: "TimelineWithFriends"
                    height: mainFlickable.height
                    header: PlasmaExtras.Title { height: 64; text: timelinewithfriends.title; anchors.bottomMargin: 12 }
                }
                MessageList {
                    id: mytimeline
                    title: "My tweets"
                    timelineType: "Timeline"
                    height: mainFlickable.height
                    header: PlasmaExtras.Title { height: 64; text: mytimeline.title; anchors.bottomMargin: 12 }
                }
                MessageList {
                    id: repliestimeline
                    title: "Replies"
                    timelineType: "Replies"
                    height: mainFlickable.height
                    header: PlasmaExtras.Title { height: 64; text: repliestimeline.title; anchors.bottomMargin: 12 }
                }
                MessageList {
                    id: searchtimeline
                    title: "Search"
                    timelineType: "SearchTimeline"
                    source: timelineType+":"+userName+"@"+url+":linux"
                    height: mainFlickable.height
                    header: PlasmaExtras.Title { height: 64; text: searchtimeline.title; anchors.bottomMargin: 12 }
                }
            }
        }
    }

    function showMessage(item) {
            sideBar.user = item.user
            sideBar.dateTime = item.dateTime
            sideBar.source = item.source
            sideBar.isFavorite = item.isFavorite
            sideBar.activePage = "MessageDetails"
            sideBar.messageId = item.messageId
            sideBar.message = item.message
    }

    MessageWidgetDetails {
        id: messageDetails
        anchors.fill: parent
        state: "hidden"
    }
}
