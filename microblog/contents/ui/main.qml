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
    property int minimumWidth: 300
    property int minimumHeight: 300
    property int _s: 12
    property int _m: 12

    property string serviceUrl
    property string userName//: "sebasje" // FIXME: remove until config doesn't get nuked all the time
    property string password
    property bool authorized: false
    property string authorizationStatus: "Idle"
    property string searchQuery

    signal replyAsked(string id, string message)
    signal retweetAsked(string id)
    signal favoriteAsked(string id, bool isFavorite)

    property string __previousUrl

    Component.onCompleted: {
        plasmoid.addEventListener('ConfigChanged', configChanged);
        plasmoid.configurationRequired = true
        Logic.messagesDataSource = microblogSource
        configChanged()
    }

    function configChanged()
    {
        //serviceUrl = plasmoid.readConfig("serviceUrl");
        var u = plasmoid.readConfig("userName");
        var s = plasmoid.readConfig("serviceUrl");
        print(" @@@@@@@@@@@@@@@@@@ configChanged()" + u + " s: " + s);

        if (u != "") {
            userName = u;
        }
        if (s != "") {
            serviceUrl = s;
            imageSource.connectSource("UserImages:"+s)
        } else {
            serviceUrl = "https://identi.ca/api/"
            //serviceUrl = "https://twitter.com/"
            print("fallbk eserice identi");
        }
        if (serviceUrl != "" && userName != "") {
            microblogSource.connectSource("TimelineWithFriends:"+userName+"@"+serviceUrl);
            main.authorizationStatus = "Ok"; // fixme: should only be done once authTimer returns
        }

        Logic.userName = userName;
        Logic.serviceUrl = serviceUrl;

        if (serviceUrl && userName && password) {
            print("start authtimer");
            authTimer.running = true
        }
        if (typeof(userInfo) != "undefined") { 
            userInfo.login = userName;
        }
        imageSource.connectSource("UserImages:"+s)
    }

    Timer {
        id: authTimer
        interval: 100
        repeat: false
        onTriggered: {
            if (userName == "" || password == "") return;
            print("starting authTimer" + userName + ":" + password);
            var src = "TimelineWithFriends:" + userName + "@" + serviceUrl;
            var service = microblogSource.serviceForSource(src);
            var operation = service.operationDescription("auth");
            operation.password = password
            operation.user = userName
            service.startOperationCall(operation);
            plasmoid.configurationRequired = false
            main.password = "";
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
            if (serviceUrl != "") {
                __previousUrl = "UserImages:"+serviceUrl;
            }
        }
        onSourceAdded: {
            if ("UserImages:"+serviceUrl == source) {
                imageSource.connectSource(source);

            }
        }
    }

    onServiceUrlChanged: {
        if (serviceUrl != "") {
            if (__previousUrl) {
                imageSource.disconnectSource(__previousUrl);
            }
//             imageSource.connectSource("UserImages:"+serviceUrl)
            __previousUrl = "UserImages:"+serviceUrl;
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
            //print("bla .. ." + msg);
            return msg;
        }
        return msg.replace(/(http:\/\/\S+)/g, " <a href='$1'>$1</a>").replace("'>http://", "'>")
    }

    function stripHtml(html) {
        print("html:" + html);
        html = html.replace(/<\/?[a-z][a-z0-9]*[^<>]*>/ig, "");
        return html;
    }

    function handleLinkClicked(link) {
        print("Link clicked:" + link);
        if (link.indexOf("internal://") == 0) {
            var tmplink = link.replace("internal://", "").split('/');
            var action = tmplink[0];
            var parameter = tmplink[1];
            print("  Internal link: " + link);
            print("         action: " + action);
            print("          param: " + parameter);
        } else {
            //print("doing nothing for now");
            Qt.openUrlExternally(link);
        }
    }
    function typeToTitle(tType) {
        if (tType == "TimelineWithFriends") {
            return i18n("Home");
        } else if (tType == "Timeline") {
            return i18n("My tweets");
        } else if (tType == "Replies") {
            return i18n("Mentions");
        } else if (tType == "SearchTimeline") {
            return i18n("Search for " + main.searchQuery);
        } else {
            return i18n("Tweets");
        }
    }
    function typeToDescription(tType) {
        if (tType == "TimelineWithFriends") {
            return i18n("Timeline of followed users");
        } else if (tType == "Timeline") {
            return i18n("Sent tweets");
        } else if (tType == "Replies") {
            return i18n("Tweets mentioning you");
        } else if (tType == "SearchTimeline") {
            return i18n("Find Tweets");
        } else {
            return i18n("");
        }
    }
}
