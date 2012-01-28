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
import org.kde.plasma.mobilecomponents 0.1 as MobileComponents
import org.kde.qtextracomponents 0.1 as QtExtraComponents

import "plasmapackage:/ui/ComplexComponents"
import "plasmapackage:/ui/BasicComponents"

Image {
    id: mainWidget
    source: "plasmapackage:/images/background.png"
    fillMode: Image.Tile
    property Component configComponent: Qt.createComponent("ConfigWidget.qml")

    Item {
        id: topItem
        anchors { left: parent.left; right: parent.right; top: parent.top }
        height: childrenRect.height
        //height: 64
        //height: postingWidget.state == "active" ? 200 : 64;

        Image {
            source: "plasmapackage:/images/sidebarbackground.png"
            fillMode: Image.Tile
            anchors {
                fill: parent
//                 left: parent.left
//                 right: parent.right
//                 top: parent.top
//                 bottom: mainFlickable.top
            }
        }
        MobileComponents.ActionButton {
            svg: PlasmaCore.Svg {
                imagePath: "widgets/configuration-icons"
            }
            elementId: "configure"
            anchors {
                top: parent.top
                topMargin: 8
                right: parent.right
                rightMargin: 8
            }
            onClicked: {
                var componentObject = configComponent.createObject(mainWidget);
                //print(componentObject.errorString())
            }



        }
        
        PostingWidget {
            id: postingWidget
//             anchors.horizontalCenter: parent.horizontalCenter
//             anchors.top: topItem.top
//             anchors.bottom: topItem.bottom
//             //height: 200
//             width: 400
            anchors.fill: topItem
            anchors.topMargin: 8
            anchors.bottomMargin: 16
        }

    /*
        MobileComponents.ActionButton {
            svg: PlasmaCore.Svg {
                imagePath: "widgets/configuration-icons"
            }
            elementId: "configure"
            anchors {
                top: parent.top
                topMargin: 8
                right: parent.right
                rightMargin: 8
            }
            onClicked: {
                var object = configComponent.createObject(mainWidget);
                print(configComponent.errorString())
            }
        }
    */
    }
    PlasmaCore.Svg {
        id: shadowSvg
        imagePath: plasmoid.file("images", "shadow.svgz")
    }

    PlasmaCore.SvgItem {
        height: 32
        anchors {
            left: parent.left
            right: parent.right
            top: mainFlickable.top
        }
        svg: shadowSvg
        elementId: "bottom"
    }

    QtExtraComponents.MouseEventListener {
        id: mouseEventListener
        z: 100
        x: 0
        y: 0
        width: 200
        height: topItem.height
        //anchors.bottom: mainFlickable.top
        //anchors.fill: mainFlickable
        onPressed: {
//             mainFlickable.forceActiveFocus();
            postingWidget.state == "inactive" ? postingWidget.state = "active" : postingWidget.state = "inactive"
            print("focus " + postingWidget.state);
        }
    }
    //Rectangle { anchors.fill: mouseEventListener; color: "green"; opacity: 0.3 }

    Flickable {
        id: mainFlickable
        //focus: true
        //parent: mouseEventListener
        //anchors.fill: parent
        anchors.top: topItem.bottom
        //anchors.topMargin: 16
        anchors.left: mainWidget.left
        anchors.bottom: mainWidget.bottom
        anchors.right: mainWidget.right
        clip: true

        contentWidth: messageContainer.width
        contentHeight: height
        Row {
            id: messageContainer
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            //FIXME: use font size
            spacing: 4
            property int columnWidth: (mainWidget.width/Math.min(3, (mainWidget.width/340)) - 18)

            UserInfo {
                id: userInfo
                width: messageContainer.columnWidth
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 24
                clip: false
            }

            MessageList {
                id: timelineList
                width: messageContainer.columnWidth
                anchors.top: parent.top
                anchors.topMargin: 24
                anchors.bottom: parent.bottom
                anchors.rightMargin: 20
                clip: false
                header: Item {
                    anchors.margins: 12
                    height: 48
                    PlasmaComponents.Label {
                        text: i18n("Timeline");
                        font.pointSize: theme.defaultFont.pointSize*2
                        anchors.fill: parent
                        anchors.leftMargin: 12
                    }
                }

                onItemClicked: {
                    messageDetails.messageId = item.messageId
                    messageDetails.user = item.user
                    messageDetails.source = item.source
                    messageDetails.isFavorite = item.isFavorite
                    messageDetails.status = item.status
                    messageDetails.state = "visible"
                }
            }
            MessageList {
                id: repliesList
                width: messageContainer.columnWidth
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 20
                anchors.topMargin: 24
                timelineType: "Replies"
                clip: false
                header: Item {
                    anchors.margins: 12
                    height: 48
                    PlasmaComponents.Label {
                        text: i18n("Replies");
                        font.pointSize: theme.defaultFont.pointSize*2
                        anchors.fill: parent
                        anchors.leftMargin: 12
                    }
                }
                onItemClicked: {
                    messageDetails.messageId = item.messageId
                    messageDetails.user = item.user
                    messageDetails.source = item.source
                    messageDetails.isFavorite = item.isFavorite
                    messageDetails.status = item.status
                    messageDetails.state = "visible"
                }
            }
            MessageList {
                id: messageList
                width: messageContainer.columnWidth
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 24
                clip: false
                timelineType: "Messages"
                header: Item {
                    anchors.margins: 12
                    height: 48
                    PlasmaComponents.Label {
                        text: i18n("Messages");
                        font.pointSize: theme.defaultFont.pointSize*2
                        anchors.fill: parent
                        anchors.leftMargin: 12
                    }
                }
                onItemClicked: {
                    messageDetails.messageId = item.messageId
                    messageDetails.user = item.user
                    messageDetails.source = item.source
                    messageDetails.isFavorite = item.isFavorite
                    messageDetails.status = item.status
                    messageDetails.state = "visible"
                }
            }
        }
    }

    MessageWidgetDetails {
        id: messageDetails
        anchors.fill: parent
        state: "hidden"
    }
}
