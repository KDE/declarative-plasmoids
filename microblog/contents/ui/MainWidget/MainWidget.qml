/*
 *   Copyright 2011 Marco Martin <mart@kde.org>
 *   Copyright 2012 Sebastian Kügler <sebas@kde.org>
 * 
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
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
import org.kde.plasma.components 0.1 as PlasmaComponents

import "plasmapackage:/ui/ComplexComponents"
import "plasmapackage:/ui/BasicComponents"

Column {
    id: mainWidget

    PlasmaComponents.TabBar {
        id: tabBar
        anchors.left: parent.left
        anchors.right: parent.right
        PlasmaComponents.TabButton {
            text: i18n("TimeLine");
            onClicked: messageList.timelineType = "TimelineWithFriends"
        }
        PlasmaComponents.TabButton {
            text: i18n("Replies");
            onClicked: messageList.timelineType = "Replies"
        }
        PlasmaComponents.TabButton {
            text: i18n("Messages");
            onClicked: messageList.timelineType = "Messages"
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