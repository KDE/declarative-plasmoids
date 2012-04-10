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

Rectangle {
    id: configWidget
    color: Qt.rgba(0,0,0,0.7)

    anchors.fill: parent

    property string messageId
    property string user
    property string source
    property bool isFavorite
    property string selectedService
    property string status

    Component.onCompleted: {
        appearAnimation.running = true
        //serviceUrlEdit.text = plasmoid.readConfig("serviceUrl")
        selectedService = plasmoid.readConfig("serviceUrl");
        userNameEdit.text = plasmoid.readConfig("userName")
        passwordEdit.text = plasmoid.readConfig("password")
    }

    ParallelAnimation {
        id: appearAnimation
        NumberAnimation {
            targets: configWidget
            properties: "opacity"
            duration: 250
            to: 1
            easing.type: "InOutCubic"
        }
        NumberAnimation {
            targets: mainTranslate
            properties: "y"
            from: -frame.height
            duration: 250
            to: 80
            easing.type: "InOutCubic"
        }
    }

    SequentialAnimation {
        id: disappearAnimation
        ParallelAnimation {
            NumberAnimation {
                targets: configWidget
                properties: "opacity"
                duration: 250
                to: 0
                easing.type: "InOutCubic"
            }
            NumberAnimation {
                targets: mainTranslate
                properties: "y"
                duration: 250
                to: -frame.height
                easing.type: "InOutCubic"
            }
        }
        ScriptAction {
            script: configWidget.destroy()
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: disappearAnimation.running = true;


        PlasmaCore.FrameSvgItem {
            id: frame
            imagePath: "widgets/background"

            //anchors.centerIn: parent
            anchors.horizontalCenter: parent.horizontalCenter
            x: 80
            anchors.margins: 20
            anchors.rightMargin: 48*3
            anchors.bottomMargin: 200
            width: layout.width + margins.left + margins.right + 48*4
            height: layout.height + margins.top + margins.bottom + 48

            transform: Translate { id: mainTranslate; y: 120 }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    mouse.accepted = true
                }
            }

            Column {
                id: layout
                spacing: 20
                anchors.margins: 12
                anchors.rightMargin: 48
                //anchors.leftMargin: 0
                //anchors.fill: parent
                anchors.centerIn: parent
//                 anchors.horizontalCenter: parent.horizontalCenter
                //anchors.verticalCenter: parent.verticalCenter
//                 x: frame.margins.left
//                 y: frame.margins.top
                //width: childrenRect.width

//                 PlasmaExtras.Title {
//                     text: i18n("Sign in...")
//                     width: 200
//                 }

                Grid {
                    id: formGrid
                    columns: 2
                    rows: 3
                    spacing: 12
                    width: 200
                    anchors.horizontalCenter: parent.horizontalCenter

                    PlasmaExtras.Title {
                        text: i18n("Sign in:")
                        horizontalAlignment: Text.AlignRight
                        anchors.right: parent.horizontalCenter
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

                            onCheckedChanged: {
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
                        Keys.onReturnPressed: layout.acceptConfig()
                    }
                }
                PlasmaComponents.Button {
                    id: buttonsRow
                    text: i18n("Sign in")
                    width: 80
                    enabled: userNameEdit.text != "" && selectedService != ""
                    anchors {
                        topMargin: 20
                        left: parent.horizontalCenter
                        leftMargin: 12
                    }
                    onClicked: layout.acceptConfig()
                }
//                     PlasmaComponents.Button {
//                         text: i18n("Cancel")
//                         width: 80
//                         onClicked: {
//                             disappearAnimation.running = true
//                         }
//                     }
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
                    //plasmoid.writeConfig("serviceUrl", serviceUrlEdit.text);
                    plasmoid.writeConfig("userName", u);
                    //plasmoid.writeConfig("password", p);
                    plasmoid.writeConfig("serviceUrl", s);
                    main.password = p;
                    configChanged();
                    sideBar.activeUser = userNameEdit.text;
                    disappearAnimation.running = true;
                }
            }
        }
    }
}