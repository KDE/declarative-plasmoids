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
    id: toolbarFrame
    width: parent.width
    height: backButton.height + margins.top + margins.bottom

    imagePath: "widgets/frame"
    prefix: "raised"

    property bool backEnabled: false
    property bool searchEnabled: true
    property string searchQuery

    Timer {
        id: searchTimer
        interval: 500;
        running: false
        repeat: false
        onTriggered: {
            if (mainView.currentIndex == 0) {
                searchQuery = ".*"+searchBox.text+".*";
            } else {
                searchQuery = ".*"+searchBox.text+".*";
            }
        }
    }

    PlasmaWidgets.PushButton {
        id: backButton
        text: i18n("Back")
        maximumSize: minimumSize
        visible: backEnabled
        x: toolbarFrame.margins.left
        y: toolbarFrame.margins.top

        onClicked: {
            if (!bodyView.customUrl) {
                if (mainWindow.state == "item") {
                    mainWindow.state = "items"
                } else if (mainWindow.state == "items") {
                    mainWindow.state = "feeds"
                }
            } else {
                bodyView.html = "<body style=\"background:#fff;\">"+feedSource.data['items'][list.currentIndex].description+"</body>";
            }
        }
    }

    PlasmaWidgets.LineEdit {
        id: searchBox
        clearButtonShown: true
        anchors.right: parent.right
        anchors.top: parent.top
        visible: searchEnabled
        anchors.rightMargin: toolbarFrame.margins.right
        anchors.topMargin: toolbarFrame.margins.top
        onTextEdited: {
            searchTimer.running = true
        }
    }
}
