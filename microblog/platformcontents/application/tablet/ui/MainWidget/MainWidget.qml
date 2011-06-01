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
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 1.0
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets

import "plasmapackage:/ui/ComplexComponents"
import "plasmapackage:/ui/BasicComponents"

Item {
    id: mainWidget

    PostingWidget {
        id: postingWidget
        width: timelineList.width
    }

    Flickable {
        anchors.top: postingWidget.bottom
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        contentWidth: messageContainer.width
        contentHeight: height
        Row {
            id: messageContainer
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            //FIXME: use font size
            property int columnWidth: mainWidget.width/Math.min(3, (mainWidget.width/320))

            MessageList {
                id: timelineList
                width: messageContainer.columnWidth
                anchors.top: parent.top
                anchors.bottom: parent.bottom
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