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
import org.kde.qtextracomponents 0.1 as QtExtraComponents

import "plasmapackage:/code/logic.js" as Logic
import "plasmapackage:/ui/MainWidget"
import "plasmapackage:/ui/BasicComponents"

Item {
    id: main
    width: 200
    height: 300

    property string serviceUrl: "https://identi.ca/api/"
    property string userName//: "sebasje" // FIXME: remove until config doesn't get nuked all the time
    property string password
    property bool authorized: false

    signal replyAsked(string id, string message)
    signal retweetAsked(string id)
    signal favoriteAsked(string id, bool isFavorite)

    Component.onCompleted: {
        plasmoid.addEventListener('ConfigChanged', configChanged);
        plasmoid.configurationRequired = true
        Logic.messagesDataSource = microblogSource
        //print("MDS: " + Logic.messagesDataSource);
        configChanged()
    }

    function configChanged()
    {
//         print(" configChanged()");
        //serviceUrl = plasmoid.readConfig("serviceUrl");
        var u = plasmoid.readConfig("userName");
        var s = plasmoid.readConfig("serviceUrl");

        if (u) {
            userName = u;
        }
        if (s) {
            serviceUrl = s;
            imageSource.connectSource("UserImages:"+serviceUrl)
        } else {
            serviceUrl = "https://identi.ca/api/"
            //serviceUrl = "https://twitter.com/"
        }
//         print( "    Read serviceUrl user and password from config: " + serviceUrl + " : "  + userName + " : " + password);
        if (serviceUrl != "" && userName != "") {
//             print("Requesting ... " + userName + "@" + serviceUrl);
            microblogSource.connectSource("TimelineWithFriends:"+userName+"@"+serviceUrl)
        }
        //microblogSource.connectSource("UserImages:"+serviceUrl)

        Logic.userName = userName;
        Logic.serviceUrl = serviceUrl;

        if (serviceUrl && userName && password) {
            authTimer.running = true
        }
    }

    Timer {
        id: authTimer
        interval: 100
        repeat: false
        onTriggered: {
            if (userName == "" || password == "") return;
            var src = "TimelineWithFriends:" + userName + "@" + serviceUrl;
            print(" XXXX Logging in ..." + password + " source: " + src);
            var service = microblogSource.serviceForSource(src);
            var operation = service.operationDescription("auth");
            operation.password = password
            service.startOperationCall(operation);
            plasmoid.configurationRequired = false
            //plasmoid.busy = true
        }
    }

    PlasmaCore.DataSource {
        id: microblogSource
        engine: "microblog"
        interval: 600000 // 10 minutes

        onDataUpdated: {
            plasmoid.busy = false
        }
        Component.onCompleted: {
            microblogSource.connectSource("Defaults")
        }
    }

    PlasmaCore.DataSource {
        id: imageSource
        engine: "microblog"
        interval: 0

        Component.onCompleted: {
            serviceUrl = plasmoid.readConfig("serviceUrl")
            imageSource.connectSource("UserImages:"+serviceUrl)
        }
    }

    PlasmaCore.DataSource {
        id: userSource
        engine: "microblog"
        interval: 0
    }


    MainWidget {
        anchors.fill: main
    }

    function friendlyDate(date) {
        var d = new Date(date);
        var now = new Date();
        var dout = Qt.formatDateTime(d, "hh:mm");
        var ago = (now - d) / 1000;
        var output = "";
        if (ago < 60) {
            output = i18np("%1 second ago", "%1 seconds ago", ago);
        } else if (ago < 3600) {
            output = i18np("%1 minute ago", "%1 minutes ago", Math.round(ago/60));
        } else if (ago < 84600) {
            output = i18np("%1 hour ago", "%1 hours ago", Math.round(ago/3600));
        } else {
            output = i18np("%1 day ago", "%1 days ago", Math.round(ago/86400));
        }
        return output;
    }

    function formatMessage(msg) {
        if (msg.indexOf("<a") > -1) {
            print("bla .. ." + msg);
            return msg;
        }
        return msg.replace(/(http:\/\/\S+)/g, " <a href='$1'>$1</a>").replace("'>http://", "'>")
    }
    
}
