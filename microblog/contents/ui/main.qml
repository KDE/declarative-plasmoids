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
import org.kde.qtextracomponents 0.1 as QtExtraComponents

import "plasmapackage:/code/logic.js" as Logic
import "plasmapackage:/ui/MainWidget"

Item {
    id: main
    width: 200
    height: 300

    property string serviceUrl: "https://identi.ca/api"
    property string userName: "sebas"
    property string password

    signal replyAsked(string id, string message)
    signal retweetAsked(string id)
    signal favoriteAsked(string id, bool isFavorite)

    Component.onCompleted: {
        plasmoid.addEventListener('ConfigChanged', configChanged);
        plasmoid.configurationRequired = true
        Logic.messagesDataSource = microblogSource
        configChanged()
    }

    function configChanged()
    {
        print(" XXX COnnnecting");
        serviceUrl = plasmoid.readConfig("serviceUrl")
        if (!serviceUrl) {
            serviceUrl = "https://identi.ca/api/"
            serviceUrl = "https://twitter.com/"
        }
        userName = plasmoid.readConfig("userName")
        password = plasmoid.readConfig("password")
        print( "Read user and password from config: " + userName + ":" + password);
        if (!serviceUrl || !userName || !password) {
            return
        }

        microblogSource.connectSource("TimelineWithFriends:"+userName+"@"+serviceUrl)
        //microblogSource.connectSource("UserImages:"+serviceUrl)
        imageSource.connectSource("UserImages:"+serviceUrl)

        authTimer.running = true
    }

    Timer {
        id: authTimer
        interval: 100
        repeat: false
        onTriggered: {
            //print(" Logging in ..." + password);
            var service = microblogSource.serviceForSource(microblogSource.connectedSources[0])
            var operation = service.operationDescription("auth");
            operation.password = password
            service.startOperationCall(operation);
            plasmoid.configurationRequired = false
            plasmoid.busy = true
        }
    }

    PlasmaCore.DataSource {
        id: microblogSource
        engine: "microblog"
        interval: 50000

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
}
