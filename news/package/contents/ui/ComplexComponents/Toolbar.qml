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
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.graphicslayouts 4.7 as GraphicsLayouts

PlasmaCore.FrameSvgItem {
    id: toolbarFrame
    width: mainUi.width
    height: backButton.height + margins.top + margins.bottom
    clip: true

    imagePath: "widgets/toolbar"

    signal openOriginalRequested
    signal backRequested

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

    PlasmaComponents.ToolButton {
        id: backButton
        iconSource: "go-previous-view"

        x: toolbarFrame.margins.left
        y: backEnabled?toolbarFrame.margins.top:-height-5

        onClicked: {
            if (!bodyView.customUrl) {
                if (mainUi.state == "item") {
                    mainUi.state = "items"
                } else if (mainUi.state == "items") {
                    mainUi.state = "feeds"
                }
            }
            backRequested()
        }

        Behavior on y {
            NumberAnimation {duration: 250; easing.type: Easing.InOutQuad}
        }
    }

    PlasmaComponents.ToolButton {
        id: openOriginalButton
        iconSource: "internet-web-browser"

        anchors.right: parent.right
        anchors.rightMargin: 12

        y: (mainUi.state == "item")?toolbarFrame.margins.top:-height-5

        onClicked: Qt.openUrlExternally(bodyView.articleUrl)

        Behavior on y {
            NumberAnimation {duration: 250; easing.type: Easing.InOutQuad}
        }
    }

    PlasmaComponents.TextField {
        id: searchBox
        clearButtonShown: true
        anchors.right: parent.right
        //anchors.top: parent.top
        y: searchEnabled?toolbarFrame.margins.top:-height-50
        anchors.rightMargin: toolbarFrame.margins.right
        anchors.topMargin: toolbarFrame.margins.top
        onTextChanged: {
            searchTimer.running = true
        }
        Behavior on y {
            NumberAnimation {duration: 250; easing.type: Easing.InOutQuad}
        }
    }
}
