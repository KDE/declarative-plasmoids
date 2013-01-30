/*
 *   Copyright 2010 Marco Martin <notmart@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
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
import org.kde.plasma.extras 0.1 as PlasmaExtras
import org.kde.plasma.components 0.1 as PlasmaComponents

PlasmaComponents.ListItem {
    id: listItem
    enabled: true
    property string text
    property string icon
    property int unread

    Item {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        height: childrenRect.height
        Row {
            id: delegateLayout
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: listItem.verticalCenter
            }

            Image {
                source: icon
            }
            PlasmaExtras.Heading {
                level: 4
                text: listItem.text
            }
        }
        PlasmaComponents.Label {
            text: unread
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
