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
import org.kde.plasma.core 0.1 as PlasmaCore

PlasmaCore.FrameSvgItem {
    id : background
    imagePath: "widgets/frame"
    prefix: "plain"

    width: entryList.width
    height: entryList.height

    property alias padding: paddingRectangle;
    signal clicked;

    Item {
        id: paddingRectangle
        anchors.fill: parent
        anchors.leftMargin: background.margins.left
        anchors.topMargin: background.margins.top
        anchors.rightMargin: background.margins.right
        anchors.bottomMargin: background.margins.bottom
    }

    MouseArea {
        id: itemMouse
        anchors.fill: background
        onClicked: background.clicked()
    }
}
