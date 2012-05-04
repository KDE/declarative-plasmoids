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
import org.kde.qtextracomponents 0.1 as QtExtraComponents

QtExtraComponents.QImageItem {
    id: userIcon

    property string userId: user
//     property string serviceUrl: main.serviceUrl

    width: 48
    height: 48
    smooth: true

    image: {
        var sourceName = "UserImages:"+serviceUrl;
        //print(" avatar for user: ", userId, sourceName);
        //sourceName = sourceName+"/"
        var d = imageSource.data[sourceName];
        if (typeof(d) != "undefined" &&
            typeof(d[userId]) != "undefined") {
            return d[userId];
        } else {
//             print("returning default image for " + userId + " ");
            //for (k in imageSource.data) print(" K " + k);
            return microblogSource.data["Defaults"]["UserImage"];
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            print("Avatar clicked: " + userId + "@" + serviceUrl);
            //userInfo.login = userId
            sideBar.activePage = "UserInfo"
            sideBar.activeUser = userId
            //userInfo.login = userId
        }
    }
}
