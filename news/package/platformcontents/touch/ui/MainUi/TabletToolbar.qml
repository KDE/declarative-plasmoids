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
import org.kde.plasma.mobilecomponents 0.1 as MobileComponents

PlasmaComponents.ToolBar {
    id: toolbarFrame
    width: mainUi.width
    height: Math.max(backButton.height, browserModeButton.height) + margins.top + margins.bottom


    signal openOriginalRequested
    signal backRequested

    property bool backEnabled: false
    property bool searchEnabled: true
    property string searchQuery

    PlasmaComponents.ToolButton {
        id: backButton
        iconSource: "go-previous"
        flat: false

        x: 8
        y: backEnabled?toolbarFrame.height/2-height/2:-height-5
        width: theme.iconSizes.toolbar + 12
        height: width

        onClicked: {
            if (!bodyView.customUrl) {
                if (mainUi.state == "item") {
                    mainUi.state = "items"
                } else if (mainUi.state == "items") {
                    mainUi.state = "feeds"
                }
            } else {
                backRequested()
            }
        }

        Behavior on y {
            NumberAnimation {duration: 250; easing.type: Easing.InOutQuad}
        }
    }

    MobileComponents.ViewSearch {
        id: searchBox
        anchors {
            centerIn: parent
            top:parent.top
        }
        onSearchQueryChanged: {
            if (mainView.currentIndex == 0) {
                toolbarFrame.searchQuery = ".*"+searchBox.searchQuery+".*";
            } else {
                toolbarFrame.searchQuery = ".*"+searchBox.searchQuery+".*";
            }
        }
    }

    PlasmaComponents.ToolButton {
        id: browserModeButton
        width: 32
        height: width
        iconSource: "internet-web-browser"
        checkable: true
        y: backEnabled?toolbarFrame.height/2-height/2:-height-5
        Behavior on y {
            NumberAnimation {duration: 250; easing.type: Easing.InOutQuad}
        }

        anchors {
            //verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 8
        }
        onClicked: mainWindow.browserMode = checked
    }
}
