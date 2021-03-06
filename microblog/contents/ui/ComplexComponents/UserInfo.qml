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

PlasmaComponents.Page {
    id: userInfo
    opacity: realNameLabel.text != "" ? 1 : 0.1;
    anchors.rightMargin: 12
    clip: true

    property string timelineType: "User"
    property string login
    property string url: serviceUrl
    property string source: timelineType+":"+login+"@"+url
    property bool following: false

    Avatar {
        id: userIcon
        userId: login
        anchors { left: parent.left; top: parent.top }
        width: 96
        height: 96
        anchors.margins: 12
        anchors.topMargin: 24
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
    QtExtraComponents.QIconItem {
        id: verifiedIcon
        icon: "task-complete"
        width: 16
        height: width
        anchors {
            left: realNameLabel.left
            leftMargin: realNameLabel.paintedWidth + 2
            top: realNameLabel.top
        }
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
        onClicked: {
            function result(job) {
                print(" Result: " + job.result + " op: " + job.operationName);
                enabled = true;
                if (!job.result) {
                    return;
                }
                var f = (job.operationName == "friendships/create");
                followButton.iconSource = f ? "list-remove-user" : "list-add-user";
                followButton.text = f ? i18n("Unfollow") : i18n("Follow");
                userInfo.following = f;
            }
            var o = "friendships/create";
            if (userInfo.following) {
                o = "friendships/destroy";
            } else {
                o = "friendships/create";
            }
            enabled = false;

            var src = "TimelineWithFriends:" + userName + "@" + serviceUrl; // FIXME: use current timelinetype
            var service = microblogSource.serviceForSource(src);
            var operation = service.operationDescription(o);
            operation.screen_name = login;
            var j = service.startOperationCall(operation);
            j.finished.connect(result);
        }
    }

    PlasmaComponents.Label {
        id: mainText
        anchors { left: parent.left; right: parent.right; top: followButton.bottom; bottom: parent.bottom; }
        visible: false
    }

    onSourceChanged: {
        if (url == "" || login == "") {
            print("Invalid source: " + source);
            //print(" UserInfo: " + login, url, source);
            //login = "sebas";
            //url = "https://identi.ca/api/"
        }
        print("Connecting to : " + source);
        //source = timelineType+":"+login+"@"+url
        //source = "User:sebas@http://identi.ca/api"
        realNameLabel.text = "";
        descriptonLabel.text = "";
        if (userSource.data[source]) {
            //print(" moving " + source);
            updateData(userSource.data[source]);
        } else {
//             print(" connnecting to user: " + source);
            userSource.connectSource(source);
        }
        //timer.running = true
    }

    function updateData(data) {
        //userInfo.data = data
        realNameLabel.text = data.realName;
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
            labels += i18n("Website:") + br;
        }
//         if (data.location) {
//             info += data.location + br;
//             labels += i18n("Location:") + br;
//         }
        labels += br + i18n("Updates:") + br;
        info += br + data.statuses_count + br;
        // friends
        labels += i18n("Following:") + br;
        info += data.friends_count + br;
        // followers
        labels += i18n("Followers:") + br;
        info += data.followers_count + br;

        infoText.text = info;
        labelText.text = labels
        var f = (typeof(data.following) != "undefined") ? data.following : false;
        //if (typeof(data.following) != "undefined") {
        userInfo.following = f
        //isFollowing.text = data.following ? i18n("Your are following " + login) : "";
        followButton.iconSource = f ? "list-remove-user" : "list-add-user";
        followButton.text = f ? i18n("Unfollow") : i18n("Follow");
        //}
        var output = "";
        for (k in data) {
            output += "<strong>" + k + "</strong>: " + data[k] + br;
        }
        mainText.text = output;
        verifiedIcon.visible = data.verified;
    }

    Connections {
        target: userSource
        onNewData: {
            //print(" new data for " + sourceName);
            //print(" DATA: " + data);
            updateData(data);
        }
    }

    Component.onCompleted: {
        login = userName
    }
}
