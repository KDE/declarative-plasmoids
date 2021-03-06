/*
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
import org.kde.plasma.components 0.1 as PlasmaComponents

import "plasmapackage:/ui/BasicComponents"

PlasmaComponents.PageStack {
    id: sideBar
    initialPage: userInfo
    property real contentOpacity: myApp.navigationWidth > 72 ? 1.0 : 0.0

    // Forward props of UserInfo
    property alias activeUser: userInfo.login

    // Forward properties of messageDetails widget
    property string activePage: "UserInfo"
    property bool open: myApp.navigationWidth > 72
    property alias messageId: messageDetails.messageId
    property alias user: messageDetails.user
    property alias source: messageDetails.source
    property alias dateTime: messageDetails.dateTime
    property alias isFavorite: messageDetails.isFavorite
    property alias message: messageDetails.message
    property alias realName: messageDetails.realName
    property alias retweetCount: messageDetails.retweetCount

    Behavior on contentOpacity {
        NumberAnimation { duration: 250; easing.type: Easing.InOutExpo; }
    }
    Behavior on width {
        NumberAnimation { duration: 250; easing.type: Easing.InOutExpo; }
    }
    UserInfo {
        id: userInfo
        width: myApp.navigationWidth - 12
        opacity: contentOpacity
    }

    MessageDetails {
        id: messageDetails
        opacity: contentOpacity
    }

    PostingWidget {
        id: postingWidget
        title: i18n("Posting as " + userName)
        visible: false
        opacity: contentOpacity
    }

    onActivePageChanged: {
        print("Sidebar.qml: activePage: " + activePage);
        if (activePage == "UserInfo") {
            sideBar.replace(userInfo);
        } else if (activePage == "MessageDetails") {
            sideBar.replace(messageDetails);
        } else if (activePage == "PostingWidget") {
            sideBar.replace(postingWidget);
        } else {
            print("Sidebar.qml: Unknown Page: " + activePage);
        }
    }

    onActiveUserChanged: activePage = "UserInfo"
    onMessageIdChanged: activePage = "MessageDetails"

    Component.onCompleted: {
        login = userName
    }
}
