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


//     PlasmaCore.Svg {
//         id: shadowSvg
//         imagePath: plasmoid.file("images", "shadow.svgz")
//     }

//     PlasmaCore.SvgItem {
//         height: 32
//         //y: myApp.navigationWidth
//         anchors {
//             left: parent.left
//             right: parent.right
//             top: myApp.top
//         }
//         z: 10
//         svg: shadowSvg
//         elementId: "bottom"
//     }

//     QtExtraComponents.MouseEventListener {
//         id: mouseEventListener
//         z: 100
//         x: 0
//         y: 0
//         width: 200
//         height: topItem.height
//         onPressed: {
//             postingWidget.state == "inactive" ? postingWidget.state = "active" : postingWidget.state = "inactive"
//             //print("focus " + postingWidget.state);
//         }
//     }
    //Rectangle { anchors.fill: mouseEventListener; color: "green"; opacity: 0.3 }

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
            //height: postingWidget.state == "active" ? 200 : 64;

//                 Image {
//                     source: "plasmapackage:/images/sidebarbackground.png"
//                     fillMode: Image.Tile
//                     anchors.fill: parent
//                 }
//             MobileComponents.ActionButton {
//                 svg: PlasmaCore.Svg {
//                     imagePath: "widgets/configuration-icons"
//                 }
//                 elementId: "configure"
// /*                anchors {
//                     top: parent.top
//                     topMargin: 8
//                     right: parent.right
//                     rightMargin: 8
//                 }
//    */
//                 onClicked: {
//                     var componentObject = configComponent.createObject(mainWidget);
//                 }
//             }
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
                //anchors.verticalCenter: parent.verticalCenter
//                 anchors { left: parent.left; right: postWidget.left; verticalCenter: postWidget.verticalCenter; }
                //Rectangle { anchors.fill: postWidget; color: "blue"; opacity: 0.3 }
            }
/*
            PostingWidget {
                id: postingWidget
//                 anchors.fill: topItem
//                 anchors.topMargin: 8
//                 anchors.bottomMargin: 16
            }*/
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

            //contentWidth: feedsList.width
            //contentHeight: height
            ListView {
                id: feedsList
                orientation: ListView.Horizontal
                snapMode: ListView.SnapOneItem
//                 cacheBuffer: mainFlickable.columnWidth
                cacheBuffer: 2000
                boundsBehavior: Flickable.DragOverBounds

                //boundsBehavior: Flickable.StopAtBounds
//                 anchors.top: parent.top
//                 anchors.bottom: parent.bottom
                anchors.fill: parent
                spacing: 4
                model: feedsModel
                delegate: messageListDelegate
                Component {
                    id: messageListDelegate
                    MessageList {
                        id: messageList
                        timelineType: tlType
                        title: tlTitle
                        height: mainFlickable.height
                    }
                }
            }
            function colWidth(mainWidth) {
                var cols = Math.round(Math.max(1, (mainWidth/450)));
                var w = (mainWidth/cols);
                //print(" Columns: " + cols + " (" + w + ")");
                return w;
            }

            ListModel {
                id: feedsModel
//                 ListElement {
//                     tlTitle: "My timeline"
//                     tlType: "TimelineWithFriends"
//                 }
                ListElement {
                    tlTitle: "Replies"
                    tlType: "Replies"
                }
                ListElement {
                    tlTitle: "My tweets"
                    tlType: "Timeline"
                }
                ListElement {
                    tlTitle: "My other timeline"
                    tlType: "TimelineWithFriends"
                }
            }
        }
    }

    function showMessage(item) {
//         messageDetails.messageId = item.messageId
//         messageDetails.user = item.user
//         messageDetails.dateTime = item.dateTime
//         messageDetails.source = item.source
//         messageDetails.isFavorite = item.isFavorite
//         messageDetails.status = item.status
//         messageDetails.state = "visible"
            sideBar.user = item.user
            sideBar.dateTime = item.dateTime
            sideBar.source = item.source
            sideBar.isFavorite = item.isFavorite
            sideBar.activePage = "MessageDetails"
            sideBar.messageId = item.messageId
            sideBar.message = item.message
            //sideBar.state = "visible"
    }

    MessageWidgetDetails {
        id: messageDetails
        anchors.fill: parent
        state: "hidden"
    }
}
