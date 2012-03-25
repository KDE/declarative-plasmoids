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
    //imagePath: "widgets/frame"
    //prefix: "plain"
    opacity: realNameLabel.text != "" ? 1 : 0.1;

    clip: true
//     snapMode: ListView.SnapToItem
//     spacing: 2
//     cacheBuffer: 5

    //signal itemClicked(variant item)

    property string timelineType: "User"
    property string login: userName
    property string url: serviceUrl
    property string source: timelineType+":"+login+"@"+url

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

    PlasmaComponents.Label {
        id: realNameLabel
        wrapMode: Text.Wrap
        font.pointSize: theme.defaultFont.pointSize * 1.5
        anchors { left: userIcon.right; right: parent.right;  top: userIcon.top; leftMargin: 12; }
    }
    PlasmaComponents.Label {
        id: userIdLabel
        text: userInfo.login ? "@" + userInfo.login : ""
        anchors { left: userIcon.right; right: parent.right; top: realNameLabel.bottom; leftMargin: 12; }
    }
    PlasmaComponents.Label {
        id: descriptonLabel
        wrapMode: Text.Wrap
        opacity: 0.6
        //text: userInfo.login ? "@" + userInfo.login : ""
        anchors { left: userIcon.left; right: parent.right; top: userIcon.bottom; topMargin: 12;}
    }

    PlasmaComponents.Label {
        id: labelText
        horizontalAlignment: Text.AlignRight
        anchors { right: userIcon.right; left: parent.left; top: descriptonLabel.bottom; topMargin: 12; }
    }
    PlasmaComponents.Label {
        id: infoText
        anchors { left: userIdLabel.left; right: parent.right; top: descriptonLabel.bottom; topMargin: 12;  }
    }

//     PlasmaComponents.Label {
//         id: isFollowing
//         anchors { left: userIdLabel.left; right: parent.right; top: infoText.bottom; topMargin: 12;  }
//     }
    PlasmaComponents.Button {
        id: followButton
        visible: login != userName
        width: parent.width /3
        anchors { left: userIdLabel.left; right: parent.right; top: infoText.bottom; topMargin: 12; rightMargin: 12 *4  }
    }

    PlasmaComponents.Label {
        id: mainText
        anchors { left: parent.left; right: parent.right; top: followButton.bottom; bottom: parent.bottom; }
        visible: false
    }

    onSourceChanged: {
        if (url == "" || login == "") {
            //print("Invalid source: " + source);
            //print(" UserInfo: " + login, url, source);
            //login = "sebas";
            //url = "https://identi.ca/api/"
        }
        //print("Connecting to : " + source);
        //source = timelineType+":"+login+"@"+url
        //source = "User:sebas@http://identi.ca/api"
        realNameLabel.text = "";
        descriptonLabel.text = "";
        if (userSource.data[source]) {
            //print(" moving " + source);
            updateData(userSource.data[source]);
        } else {
            //print(" connnecting " + source);
            userSource.connectSource(source);
        }
        //timer.running = true
    }

    function updateData(data) {
        //userInfo.data = data
        realNameLabel.text = data.realname;
        descriptonLabel.text = data.description ? data.description : "";
        //print("DESC:" + data.description);
        var br = "<br/>\n";
        var info = "";
        var labels = "";
        if (data.location) {
            info += data.location + br;
            labels += i18n("Location:") + br;
        }
        if (data.website) {
            info += "<a href=\"http://" + data.website + "\">" + data.website + "</a>" + b//list-remove-user
r;
            labels += i18n("Website:") + br;
        }
//         if (data.location) {
//             info += data.location + br;
//             labels += i18n("Location:") + br;
//         }
        labels += br + i18n("Updates:") + br;
        info += br + data.tweets + br;
        // friends
        labels += i18n("Following:") + br;
        info += data.friends + br;
        // followers
        labels += i18n("Followers:") + br;
        info += data.followers + br;

        infoText.text = info;
        labelText.text = labels

        //isFollowing.text = data.following ? i18n("Your are following " + login) : "";
        followButton.iconSource = data.following ? "list-remove-user" : "list-add-user";
        followButton.text = data.following ? i18n("Unfollow") : i18n("Follow");

        var output = "";
        for (k in data) {
            //print( " Key: " + k + ":" + data[k]);
            output += "<strong>" + k + "</strong>: " + data[k] + br;
        }
        mainText.text = output;
    }

    Connections {
        target: userSource
        onNewData: {
            //print(" new data for " + sourceName);
            //print(" DATA: " + data);
            updateData(data);
        }
    }

    onLoginChanged: {
        source = timelineType+":"+login+"@"+url
        //print("onLoginChanged: " + source);
        //userSource.connectSource(source);
    }
    Component.onCompleted: {
        login = userName
        //print(" user info loaded: " + login + source);
    }
}
