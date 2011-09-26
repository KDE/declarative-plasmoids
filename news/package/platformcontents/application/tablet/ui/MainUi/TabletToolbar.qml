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

import Qt 4.7
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.graphicslayouts 4.7 as GraphicsLayouts
import org.kde.plasma.mobilecomponents 0.1 as MobileComponents

PlasmaCore.FrameSvgItem {
    id: toolbarFrame
    width: mainUi.width
    height: childrenRect.height + margins.top + margins.bottom
    clip: true

    imagePath: "widgets/frame"
    prefix: "raised"

    signal openOriginalRequested
    signal backRequested

    property bool backEnabled: false
    property bool searchEnabled: true
    property string searchQuery

    PlasmaWidgets.PushButton {
        id: backButton
        text: i18n("Back")
        maximumSize: minimumSize

        x: toolbarFrame.margins.left + 8
        y: backEnabled?toolbarFrame.height/2-height/2:-height-5

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

    PlasmaWidgets.PushButton {
        id: openOriginalButton
        text: i18n("Website")
        width: 128
        maximumSize: minimumSize

        anchors {
            left: backButton.right
            leftMargin: 12
        }
        y: (mainUi.state == "item")?toolbarFrame.height/2-height/2:-height-5

        onClicked: {
            openOriginalRequested();
        }

        Behavior on y {
            NumberAnimation {duration: 250; easing.type: Easing.InOutQuad}
        }
    }

    MobileComponents.ViewSearch {
        id: searchBox
        anchors {
            horizontalCenter: parent.horizontalCenter
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

    MobileComponents.ActionButton {
        iconSize: 22
        svg: PlasmaCore.Svg {
            imagePath: "widgets/configuration-icons"
        }
        elementId: "configure"
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 8
        }
        onClicked: {
            var object = configComponent.createObject(mainWidget);
            print(component.errorString())
        }
    }
}
