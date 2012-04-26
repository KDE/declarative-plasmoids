/*
 *   Copyright 2011 Marco Martin <mart@kde.org>
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

// Rectangle {
//     id: configWidget
//     color: Qt.rgba(0,0,0,0.7)
// 
//     anchors.fill: parent
// 
//     property string messageId
//     property string source
//     property bool isFavorite

Column {
    id: loginWidget
    property string selectedService
    property string user
    property string status
    spacing: _m

    Component.onCompleted: {
//         appearAnimation.running = true
        //serviceUrlEdit.text = plasmoid.readConfig("serviceUrl")
        selectedService = plasmoid.readConfig("serviceUrl");
//         userNameEdit.text = plasmoid.readConfig("userName")
//         passwordEdit.text = plasmoid.readConfig("password")
    }

    Grid {
        id: formGrid


        columns: 2
        rows: 3
        spacing: 12
        //width: 200
        //anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width

        PlasmaExtras.Heading {
            text: i18n("Sign in:")
            level: 2
            horizontalAlignment: Text.AlignRight
            anchors.right: parent.horizontalCenter
            anchors.left: parent.left
            anchors.rightMargin: 24
            //text: i18n("Service URL:")
        }
    //                     PlasmaComponents.TextField {
    //                         id: serviceUrlEdit
    //                         text: "https://identi.ca/api/"
    //                         Keys.onTabPressed: userNameEdit.forceActiveFocus()
    //                     }
        Column {
            id: radioCol
            PlasmaComponents.RadioButton {
                id: twitterRadio
                width: 140
                height: 30
                text: "Identi.ca"
                property string apiUrl: "https://identi.ca/api/"
                checked: (selectedService == apiUrl)

                onClicked: {
                    identicaRadio.checked = !checked;
                    if (checked) {
                        console.log(text + " selected" + selectedService);
                        selectedService = apiUrl;
                    } else {
                        console.log(text + " Unchecked" + selectedService);
                    }
                }
            }
            PlasmaComponents.RadioButton {
                id: identicaRadio
                width: 140
                height: 30
                text: "Twitter"
                property string apiUrl: "https://twitter.com/"
                checked: (selectedService == apiUrl)

                onCheckedChanged: {
                    twitterRadio.checked = !checked;
                    if (checked) {
                        console.log(text + " selected" + selectedService);
                        selectedService = apiUrl;
                    } else {
                        console.log(text + " Unchecked" + selectedService);
                    }
                }
            }
        }

        PlasmaComponents.Label {
            text: i18n("User name:")
            horizontalAlignment: Text.AlignRight
            anchors.right: parent.horizontalCenter
            anchors.rightMargin: 24
        }
        PlasmaComponents.TextField {
            id: userNameEdit
            Keys.onTabPressed: passwordEdit.forceActiveFocus()
        }

        PlasmaComponents.Label {
            text: i18n("Password:")
            horizontalAlignment: Text.AlignRight
            anchors.right: parent.horizontalCenter
            anchors.rightMargin: 24
        }
        PlasmaComponents.TextField {
            id: passwordEdit
            echoMode: TextInput.Password
            Keys.onReturnPressed: loginWidget.acceptConfig()
        }
    }
    PlasmaComponents.Button {
        id: buttonsRow
        text: i18n("Sign in")
        width: 80
        enabled: userNameEdit.text != "" && selectedService != ""
        anchors {
            topMargin: 20
            //left: parent.horizontalCenter
//             leftMargin: 2
        }
        x: passwordEdit.x + 2
        onClicked: loginWidget.acceptConfig()
    }
    function acceptConfig() {
        //var s = serviceUrlEdit.text;
        //var s = selectedService;
        var s = selectedService;
        var u = userNameEdit.text;
        var p = passwordEdit.text;
        print(" Writing config: ------------------- " );
        print("     user: " + u);
        print("     surl: " + s);
        print("     pass: " + p);
//         plasmoid.writeConfig("serviceUrl", serviceUrlEdit.text);
        plasmoid.writeConfig("userName", u);
        //plasmoid.writeConfig("password", p);
        plasmoid.writeConfig("serviceUrl", s);
        print("+++++++++++++ Stuff setting " + u + "@" + s);
        accountDelegate.accountUserName = u;
        accountDelegate.accountServiceUrl = s;
        accountDelegate.identifier = u+"@"+s;
        main.userName = u;
        main.serviceUrl = s;
        main.password = p;
        configChanged();
        //sideBar.activeUser = userNameEdit.text;
//         disappearAnimation.running = true;
    }

}