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

PlasmaComponents.ListItem {
    id: accountDelegate
    enabled: true
    property string accountServiceUrl: serviceUrl
    property string accountUserName: userName
    property string identifier: userName+"@"+serviceUrl
    property string __previousStatusSource

//     onAccountServiceUrlChanged: print("Acount Srvice url changed: " + accountServiceUrl + accountUserName) ;
    property int _h: 76

    state: "Idle"

    Behavior on height { NumberAnimation { duration: 450; easing.type: Easing.OutExpo; } }

    property bool isTwitter: (accountServiceUrl.indexOf("twitter") > -1)
    //property alias identifier: currentSource
//                 property string userName: "u"; //data["accountUser"]
//                 property string serviceUrl: "SeRvIcE" //data.split("@")[1]

    //Text { anchors.fill: parent; text: i18n("%1 at %2", userName, serviceUrl)}
    states: [
        State {
            name: "Ok"
            PropertyChanges { target: accountDelegate; height: _h}
            PropertyChanges { target: statusIcon; icon: "task-complete"}
            PropertyChanges { target: busyWidget; running: false; }
        },
        State {
            name: "Busy"
            PropertyChanges { target: accountDelegate; height: _h}
            PropertyChanges { target: busyWidget; running: true; }
        },
        State {
            name: "Waiting"
            PropertyChanges { target: accountDelegate; height: _h}
            PropertyChanges { target: busyWidget; running: true; }
        },
        State {
            name: "Error"
            PropertyChanges { target: accountDelegate; height: loginWidget.height;}
            PropertyChanges { target: statusIcon; icon: "task-reject"}
            PropertyChanges { target: busyWidget; running: false; }
        },
        State {
            name: "Idle"
            PropertyChanges { target: accountDelegate; height: loginWidget.height; }
            PropertyChanges { target: statusIcon; icon: "task-ongoing"}
            PropertyChanges { target: busyWidget; running: false; }
        }
    ]

    Item {
        anchors.fill: parent
        visible: accountDelegate.state != "Idle"
        Avatar {
            id: accountAvatar
            userId: accountUserName
            height: 48; width: height
        }
        Image {
            id: serviceIcon
            source: isTwitter ? "plasmapackage:/images/twitter.png" : "plasmapackage:/images/identica.png"
            anchors { right: accountAvatar.right; bottom: accountAvatar.bottom; rightMargin: -4; bottomMargin: -4; }
            height: 24; width: height
        }
        PlasmaExtras.Heading {
            id: delegateHead
            anchors { left: accountAvatar.right; top: accountAvatar.top; leftMargin: _m }
            text: accountUserName
            level: 3
        }
        PlasmaComponents.Label {
            id: subtitleLabel
            anchors { left: accountAvatar.right; top: delegateHead.bottom; leftMargin: _m }
            text: isTwitter ? i18n("Twitter") : i18n("Identi.ca")
            opacity: 0.7
        }
    }
//     AuthorizationWidget {
//         id: accountAuthWidget
//         height: 48
//         width: 200
//         visible: true
//         anchors { top: parent.top; right: parent.right;}
//     }

    PlasmaComponents.Label {
        id: accountAuthWidget
        height: 48
        width: 48
        visible: false
        text: accountDelegate.state
        anchors { top: parent.top; right: parent.right;}
    }
    PlasmaComponents.BusyIndicator {
        id: busyWidget
        height: 48
        width: 48
        visible: accountDelegate.state == "Busy" || accountDelegate.state == "Waiting"
        //text: accountDelegate.state
        anchors { top: parent.top; right: parent.right;}
    }
    QtExtraComponents.QIconItem {
        id: statusIcon
        height: 24
        width: 24
        //icon: ""
        visible: accountDelegate.state == "Ok" || accountDelegate.state == "Error"
        //text: accountDelegate.state
        anchors { verticalCenter: parent.verticalCenter; right: parent.right;}
    }

    LoginWidget {
        id: loginWidget
        height: 220
        width: accountDelegate.width
        visible: accountDelegate.state == "Idle" || accountDelegate.state == "Error"
    }

    Connections {
        target: accountsList
        onCurrentIndexChanged: {
            if (accountsList.currentIndex == index) {
                checked = true;
            } else {
                checked = false;
            }
        }
    }

    function activate() {
        print(" =========================================");
        main.userName = accountUserName;
        main.serviceUrl = accountServiceUrl;
        plasmoid.writeConfig("userName", accountUserName);
        plasmoid.writeConfig("serviceUrl", accountServiceUrl);
        configChanged();
        print("Index is now: " + index);
        accountsList.currentIndex = index;
        topItem.state = "collapsed";
        accountsWidget.visible = true;
        if (typeof(accountsButton) != "undefined") {
            accountsButton.checked = false;
        }
        print("TTTTTTTL wrote config" + accountUserName + "@" + accountServiceUrl);

    }

    onClicked: ParallelAnimation {
        ScriptAction { script: activate() }
        PlasmaExtras.DisappearAnimation { targetItem: accountsWidget }
    }

    PlasmaCore.DataSource {
        id: statusSource
        engine: "microblog"
        interval: 0
        onSourceAdded: {
//             print("     New Source appeared: " + source);
            var src = "Status:"+accountDelegate.identifier;
            if (accountDelegate.identifier != "@" && source == src) {
                print("sourceAdded " + source);
                //connectSource(src);
                print(" cs: " + connectedSources);
            }
        }
        onDataChanged: {
            //print("++++> Datachanged:" + accountDelegate.identifier + " S " + connectedSources);
            if (statusSource.data["Status:" + accountDelegate.identifier]) {
                var src = "Status:"+accountDelegate.identifier;
                var st = statusSource.data[src]["Authorization"];
                var msg = statusSource.data[src]["AuthorizationMessage"];
                accountDelegate.state = st;
                print(" == > Datachanged: " + src + " " + st + " " + msg);
            }
        }
        //Component.onCompleted:     statusSource.connectSource("Status:"+accountDelegate.accountUserName+"@"+accountDelegate.accountServiceUrl);

//         Connections {
//             target: accountDelegate
//             onAccountServiceUrlChanged: statusSource.connectSource("Status:"+accountDelegate.accountUserName+"@"+accountDelegate.accountServiceUrl);
//         }
    }

    onIdentifierChanged: {
        if (accountDelegate.identifier == "@") {
            print("invalid identifier : " + accountDelegate.identifier);
            return;
        }
        if (__previousStatusSource) {
            print("disconnectSource: " + "Status:"+__previousStatusSource);
            statusSource.disconnectSource("Status:"+__previousStatusSource);
            __previousStatusSource = accountDelegate.identifier;
            //__userName = accountDelegate.accountUserName;
        }
        var src = "Status:"+accountDelegate.identifier;
        print("AccountDelegate.IdentifierChanged: " + src);
        statusSource.connectSource(src);
    }

    
//     Connections {
//         target: accountAuthWidget
//         onStateChanged: accountAuthWidget.state == accountDelegate.state
//     }
    onStateChanged: {
        print("state changed: " + accountDelegate.state);
        accountAuthWidget.state == accountDelegate.state;
    }

    Component.onCompleted: {
        print("New One: " + accountUserName + " " + accountServiceUrl + " " + identifier);
        if (accountUserName == "" || accountServiceUrl == "") {
            state = "Idle";
        }
        ///state = "Ok";
        print("Accountdelegate.qml completed: " + identifier);
    }
}
