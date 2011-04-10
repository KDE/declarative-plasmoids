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

Column {
    id: mainWidget

    PlasmaWidgets.TabBar {
        id: tabBar
        anchors.left: parent.left
        anchors.right: parent.right
        Component.onCompleted: {
            tabBar.addTab(i18n("Timeline"))
            tabBar.addTab(i18n("Replies"))
            tabBar.addTab(i18n("Messages"))
        }
        onCurrentChanged: {
            switch (index) {
            case 0:
                messageList.timelineType = "TimelineWithFriends"
                break;
            case 1:
                messageList.timelineType = "Replies"
                break;
            case 2:
            default:
                messageList.timelineType = "Messages"
                break;
            }
        }
    }

    MessageList {
        id: messageList
        anchors.left: mainWidget.left
        anchors.right: mainWidget.right
        height: mainWidget.height - tabBar.height
        header: PostingWidget {}
    }
}