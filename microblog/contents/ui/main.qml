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

Item {
    id: main
    width: 200
    height: 300

    property string serviceUrl
    property string userName
    property string password

    signal replyAsked(string id, string message)
    signal retweetAsked(string id, string message)

    Component.onCompleted: {
        plasmoid.addEventListener('ConfigChanged', configChanged);
        plasmoid.configurationRequired = true
    }

    function configChanged()
    {
        serviceUrl = plasmoid.readConfig("serviceUrl")
        userName = plasmoid.readConfig("userName")
        password = plasmoid.readConfig("password")

        messagesDataSource.connectedSources = ["TimelineWithFriends:"+userName+"@"+serviceUrl]
        imagesDataSource.connectedSources = ["UserImages:"+serviceUrl]
        var service = messagesDataSource.serviceForSource(messagesDataSource.connectedSources[0])
        var operation = service.operationDescription("auth");
        operation.password = plasmoid.readConfig("password")
        service.startOperationCall(operation);
        plasmoid.configurationRequired = false
        plasmoid.busy = true
    }


    PlasmaCore.DataSource {
        id: messagesDataSource
        engine: "microblog"
        interval: 50000

        onDataChanged: {
            plasmoid.busy = false
        }
    }

    //Split images and messages: even if a datasource can take multiple sources, their data must have the same keys
    PlasmaCore.DataSource {
        id: imagesDataSource
        engine: "microblog"
        interval: 5000
    }

    ListView {
        id: entryList
        anchors.fill: parent
        clip: true
        spacing: 5
        model: PlasmaCore.DataModel {
            dataSource: messagesDataSource
            keyRoleFilter: "[\\d]*"
        }
        header: PostingWidget {}

        delegate: MessageWidget {
            width: entryList.width
        }
    }
}
