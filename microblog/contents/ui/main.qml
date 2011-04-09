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

import Qt 4.7
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1 as QtExtraComponents

import "plasmapackage:/ui/MainWidget"

Item {
    id: main
    width: 200
    height: 300

    property string serviceUrl
    property string userName
    property string password

    signal replyAsked(string id, string message)
    signal retweetAsked(string id)
    signal favoriteAsked(string id, bool isFavorite)

    Component.onCompleted: {
        plasmoid.addEventListener('ConfigChanged', configChanged);
        plasmoid.configurationRequired = true
        configChanged()
    }

    function configChanged()
    {
        serviceUrl = plasmoid.readConfig("serviceUrl")
        userName = plasmoid.readConfig("userName")
        password = plasmoid.readConfig("password")

        if (!serviceUrl || !userName || !password) {
            return
        }

        microblogSource.connectedSources = ["TimelineWithFriends:"+userName+"@"+serviceUrl, "UserImages:"+serviceUrl]
        var service = microblogSource.serviceForSource(microblogSource.connectedSources[0])
        var operation = service.operationDescription("auth");
        operation.password = plasmoid.readConfig("password")
        service.startOperationCall(operation);
        plasmoid.configurationRequired = false
        plasmoid.busy = true
    }

    PlasmaCore.DataSource {
        id: microblogSource
        engine: "microblog"
        interval: 50000

        onDataChanged: {
            plasmoid.busy = false
        }
    }

    MainWidget {
        anchors.fill: main
    }
}
