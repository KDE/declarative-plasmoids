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
import QtQuick 1.0
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.graphicslayouts 4.7 as GraphicsLayouts

PlasmaComponents.ListItem {
    id: listItem
    property string text
    property string icon
    property int unread
    enabled: true

    Row{
        id: delegateLayout
        anchors.left: listItem.padding.left
        anchors.right: listItem.padding.right
        anchors.verticalCenter: listItem.verticalCenter

        Image {
            source: icon
        }
        PlasmaComponents.Label  {
            text: listItem.text
        }
    }

    PlasmaComponents.Label {
        text: unread
        anchors {
            right: parent.right
            rightMargin: 10
            verticalCenter: listItem.verticalCenter
        }
    }
}
