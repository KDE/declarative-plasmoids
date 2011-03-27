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
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
import Qt 4.7
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.graphicslayouts 4.7 as GraphicsLayouts

PlasmaCore.FrameSvgItem {
    id : background
    imagePath: plasmoid.file("images", "listitem.svgz")
    state: "normal"
    prefix: state

    property alias padding: paddingRectangle
    signal clicked;

    width: parent.width
    height: paddingRectangle.height + background.margins.top + background.margins.bottom

    Item {
        id: paddingRectangle
        anchors.fill: background
        anchors.left:parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.leftMargin: background.margins.left
        anchors.topMargin: background.margins.top
        anchors.rightMargin: background.margins.right
        height: childrenRect.height + background.margins.bottom
        //anchors.bottomMargin: background.margins.bottom
    }

    MouseArea {
        id: itemMouse
        anchors.fill: background
        onClicked: background.clicked()
    }
}