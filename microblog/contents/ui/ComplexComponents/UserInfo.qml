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

import QtQuick 1.0
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1 as QtExtraComponents

import "plasmapackage:/ui/BasicComponents"

PlasmaCore.FrameSvgItem {
    id: userInfo
    imagePath: "widgets/frame"
    prefix: "plain"

    clip: true
//     snapMode: ListView.SnapToItem
//     spacing: 2
//     cacheBuffer: 5

    signal itemClicked(variant item)

    property string timelineType: "User"
    property string login: userName
    property string url: serviceUrl
    property string source: timelineType+":"+url
    //property alias data: imageSource.data

    Avatar {
        id: userIcon
        userId: login
        anchors { left: parent.left; top: parent.top }
        width: 96
        height: 96
        anchors.margins: 12
        image: {
            var sourceName = "UserImages:"+serviceUrl;
            if (typeof(imageSource.data[sourceName]) != "undefined" &&
                typeof(imageSource.data[sourceName][login]) != "undefined") {
                //print("set image for sebas");
                return imageSource.data[sourceName][login];
            } else {
                //print("set fallback");
                return microblogSource.data["Defaults"]["UserImage"];
            }
        }
    }

    Text {
        id: headerLabel
        text: "<h1>User " + userInfo.login + "</h1>"
        anchors { left: userIcon.right; right: parent.right; verticalCenter: userIcon.verticalCenter}

    }

    Text {
        id: mainText
        anchors { left: parent.left; right: parent.right; top: userIcon.bottom; bottom: parent.bottom; }
    }

    onSourceChanged: {
        if (url == "" || login == "") {
            print("Invalid source: " + source);
            print(" UserInfo: " + login, url, source);
            //login = "sebas";
            //url = "https://identi.ca/api/"
        }
        //print("Connecting to : " + source);
        source = timelineType+":"+login+"@"+url
        //source = "User:sebas@http://identi.ca/api"
        userSource.connectSource(source);
        //timer.running = true
    }

    Connections {
        target: userSource
        onNewData: {
            //print(" new data for " + sourceName);
            //print(" DATA: " + data);
            var br = "<br/>\n";
            var output = "";
            for (k in data) {
                //print( " Key: " + k + ":" + data[k]);
                output += "<strong>" + k + "</strong>: " + data[k] + br;
            }
            mainText.text = output;
        }
    }

    onLoginChanged: {
        source = timelineType+":"+login+"@"+url
        print("onLoginChanged: " + source);
        userSource.connectSource(source);
    }
    Component.onCompleted: {
        print(" user info loaded: " + login + source);
    }
}
