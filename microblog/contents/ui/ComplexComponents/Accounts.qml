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
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras
import org.kde.qtextracomponents 0.1 as QtExtraComponents

PlasmaComponents.Page {
    id: accountsWidget

    property string messageId
    property string user
    property string source
    property bool isFavorite
    property string selectedService
    property string status
    property bool isInitial: true

    PlasmaCore.DataSource {
        id: accountsSource
        engine: "microblog"
        interval: 0
        Component.onCompleted: connectSource("Accounts")

        onDataChanged: {
            accountsModel.clear();
            for (d in data["Accounts"]) {
                if (isInitial) {
                    topItem.state = "collapsed";
                    isInitial = false;
                }
                var _d = d.split('@');
                var u = _d[0];
                var s = _d[1];
                accountsModel.append({"userName": u, "serviceUrl": s, "identifier": d})
                if (main.serviceUrl == s && main.userName == u) {
                    accountsList.currentIndex = accountsList.count -1;
                }
            }
        }
    }
    MouseArea {
        anchors.fill: parent
        onPressed: {
            mouse.accepted = true
        }
    }
    ListModel {
        id: accountsModel
        // We have to define at least one item to fix property names
        // these can't be changed afterwards. The list is cleared though,
        // so none of this data should ever end up in the UI.
        ListElement { serviceUrl: ""; userName: ""; identifier: "" }
    }

    Column {
        spacing: _m
        anchors { fill: parent; margins: _m*2; }
        PlasmaExtras.Heading {
            level: 3
            text: i18n("Accounts")
            width: parent.width
            height: 20
        }
        ListView {
            id: accountsList
            width: parent.width
            height: parent.height
            clip: true
            cacheBuffer: 800
            highlightRangeMode: ListView.ApplyRange
            interactive: height < contentHeight
            model: accountsModel
            delegate: AccountDelegate {}
            currentIndex: -1
            footer: PlasmaComponents.ToolButton {
                iconSource: "list-add-user";
                width: 48; height: 48;
                anchors.right: parent.right
                anchors.rightMargin: 8
                onClicked: {
                    accountsModel.append({"userName": "", "serviceUrl": "", "identifier": ""});
                    //accountsList.currentIndex = accountsModel.count-1;
                }
            }
        }
    }
    Component.onCompleted: {
//         print(" =====> Accounts.qml completed");
        state = "expanded";
    }
}
