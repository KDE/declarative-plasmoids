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
//     property string messageId
//     property string user
//     property string source
//     property bool isFavorite
//     property string selectedService
    property int _h: 76

    state: (accountsList.currentIndex == index) ? "new" : "collapsed"
//     state: "new"

    //checked: state == "new"
    enabled: true

    Behavior on height { NumberAnimation { duration: 450; easing.type: Easing.OutExpo; } }

    property bool isTwitter: (serviceUrl.indexOf("twitter") > -1)
    //property alias identifier: currentSource
//                 property string userName: "u"; //data["accountUser"]
//                 property string serviceUrl: "SeRvIcE" //data.split("@")[1]

    //Text { anchors.fill: parent; text: i18n("%1 at %2", userName, serviceUrl)}
    states: [
        State {
            name: "collapsed"
            PropertyChanges { target: accountDelegate; height: _h}
        },
        State {
            name: "new"
            PropertyChanges { target: accountDelegate; height: loginWidget.height; }
        }
    ]
    Item {
        anchors.fill: parent
    visible: accountDelegate.state == "collapsed"
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
            id: subtitleLabel
            anchors { left: serviceIcon.right; top: delegateHead.bottom; leftMargin: _m }
            text: isTwitter ? i18n("Twitter") : i18n("Identi.ca")
            opacity: 0.7
        }
        AuthorizationWidget {
            id: accountAuthWidget
            height: 48
            anchors { top: parent.top; right: parent.right;}
        }
    }

    LoginWidget {
        id: loginWidget
        height: 220
        width: accountDelegate.width
//         anchors { left: parent.left; right: parent.right; top: subtitleLabel.bottom; topMargin: _m; }
        visible: accountDelegate.state == "new"
    }

    Connections {
        target: accountsList
//         onCurrentIndexChanged: accountDelegate.state = accountsList.currentIndex == index ? "new" : "collapsed"
        onCurrentIndexChanged: {
            if (accountsList.currentIndex == index) {
                print("  Checking index: " + index + "(" + accountsList.currentIndex + ")");
                accountDelegate.state = "new"
            } else {
                accountDelegate.state = "collapsed"

                print("Unchecking index: " + index + "(" + accountsList.currentIndex + ")");
            }
        }
    }

    onClicked: {
        state = state == "new" ? "collapsed" : "new"
        print("Index is now: " + index);
        accountsList.currentIndex = index;
    }
    Component.onCompleted: {
        print("DEL: ");
        for (k in accountDelegate.data) {
            print("     - " + k);
        }
        if (serviceUrl == "" || userName == "") {
            state = "new";
        }
    }
}
