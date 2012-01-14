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
import org.kde.plasma.mobilecomponents 0.1 as MobileComponents

import "plasmapackage:/ui/ComplexComponents"
import "plasmapackage:/ui/BasicComponents"

Image {
    id: mainWidget
    source: "plasmapackage:/images/background.png"
    fillMode: Image.Tile
    property Component configComponent: Qt.createComponent("ConfigWidget.qml")

    Image {
        source: "plasmapackage:/images/sidebarbackground.png"
        fillMode: Image.Tile
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: mainFlickable.top
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
            var object = configComponent.createObject(mainWidget);
            print(object.errorString())
        }
    }



    PostingWidget {
        id: postingWidget
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 16
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

    Flickable {
        id: mainFlickable
        anchors.top: postingWidget.bottom
        anchors.topMargin: 16
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        clip: true

        contentWidth: messageContainer.width
        contentHeight: height
        Row {
            id: messageContainer
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            //FIXME: use font size
            property int columnWidth: mainWidget.width/Math.min(3, (mainWidget.width/340))

            MessageList {
                id: timelineList
                width: messageContainer.columnWidth
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 20
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
                timelineType: "Replies"
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
                timelineType: "Messages"
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
