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
//#include "../../../../../contents/ui/main.qml"

import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras
import org.kde.qtextracomponents 0.1 as QtExtraComponents

//     Component.onCompleted: {
//         appearAnimation.running = true
//         selectedService = plasmoid.readConfig("serviceUrl");
//         userNameEdit.text = plasmoid.readConfig("userName")
//         passwordEdit.text = plasmoid.readConfig("password")
//     }

PlasmaCore.FrameSvgItem {
    id: accountsWidget
    imagePath: "widgets/background"

    property string messageId
    property string user
    property string source
    property bool isFavorite
    property string selectedService
    property string status
    anchors.centerIn: parent
    anchors.margins: _m
    width: (parent.width) > 540 ? 540 : parent.width

    PlasmaCore.DataSource {
        id: accountsSource
        engine: "microblog"
        interval: 0
        //connectedSources: ["Accounts"]
        Component.onCompleted: connectSource("Accounts")
        onDataChanged: {
            print("Data changed." + data)
            accountsModel.clear();
            for (d in data["Accounts"]) {
//                 print("  d: " + d + " " + data["Accounts"][d]);
                var _d = d.split('@');
                var u = _d[0];
                var s = _d[1];
                accountsModel.append({"userName": u, "serviceUrl": s, "identifier": d})
                print("  U: " + d + " " + u + " " + s);

            }
        }
        onDataUpdated: print("Data updated.")
    }
//     PlasmaCore.DataModel {
//         id: accountsModel
//         dataSource: accountsSource.data["Accounts"]
// //         sourceFilter: "Accounts"
// //         keyRoleFilter: "[\\d]*"
//     }
    MouseArea {
        anchors.fill: parent
        onPressed: {
            mouse.accepted = true
        }
    }
    ListModel {
        id: accountsModel
        ListElement { serviceUrl: "https://api.twitter.com/"; userName: "Fakz0r"; identifier: "" }
//         ListElement { service: "Grapefruit.com"; user: "primo" }
    }
    
    PlasmaComponents.ToolButton {
        anchors { right: parent.right; top: parent.top; topMargin: _m; rightMargin: _m }
        iconSource: "dialog-close"
        onClicked: PlasmaExtras.DisappearAnimation { targetItem: accountsWidget }
    }
    Column {
        spacing: _m
        anchors { fill: parent; margins: _m*2; }
        PlasmaExtras.Title {
            text: i18n("Accounts")
            width: parent.width
        }
        ListView {
            width: parent.width
            height: 400
            interactive: height < contentHeight
            spacing: _m
            model: accountsModel
//             model: accountsSource.data["Accounts"]["Groups"]
//             model: accountsSource.data["Accounts"]["PlasmaActive@https://identi.ca/api/"]

            delegate: Item {
                height: 76
                id: accountDelegate
                property bool isTwitter: (serviceUrl.indexOf("twitter") > -1) 
                //property alias identifier: currentSource
//                 property string userName: "u"; //data["accountUser"]
//                 property string serviceUrl: "SeRvIcE" //data.split("@")[1]
                
                //Text { anchors.fill: parent; text: i18n("%1 at %2", userName, serviceUrl)}
                Image {
                    id: serviceIcon
                    source: isTwitter ? "plasmapackage:/images/twitter.png" : "plasmapackage:/images/identica.png"
                    height: 48; width: height
                }
                PlasmaExtras.Heading {
                    id: delegateHead
                    anchors { left: serviceIcon.right; top: serviceIcon.top; leftMargin: _m }
                    text: userName
                    level: 3
                }
                PlasmaComponents.Label {
                    anchors { left: serviceIcon.right; top: delegateHead.bottom; leftMargin: _m }
                    text: isTwitter ? i18n("Twitter") : i18n("Identi.ca")
                    opacity: 0.7
                }
                Component.onCompleted: {
                    print("DEL: ");
                    for (k in accountDelegate.data) {
                        print("     - " + k);
                    }
                }
            }
            footer: PlasmaComponents.ToolButton {
                iconSource: "list-add-user";
                width: 48; height: 48;
                anchors.right: parent.right
                
            }
        }
    }
}
