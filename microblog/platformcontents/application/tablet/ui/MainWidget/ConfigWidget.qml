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

import QtQuick 1.0
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.qtextracomponents 0.1 as QtExtraComponents

Rectangle {
    id: configWidget
    color: Qt.rgba(0,0,0,0.7)

    anchors.fill: parent

    property string messageId
    property string user
    property string source
    property bool isFavorite
    property string status

    Component.onCompleted: {
        appearAnimation.running = true
        serviceUrlEdit.text = plasmoid.readConfig("serviceUrl")
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
            duration: 250
            to: 0
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
        onClicked: configWidget.state = "hidden"

        PlasmaCore.FrameSvgItem {
            id: frame
            imagePath: "widgets/background"

            anchors.centerIn: parent
            width: layout.width + margins.left + margins.right
            height: layout.height + margins.top + margins.bottom

            transform: Translate { id: mainTranslate; y: -frame.height }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    mouse.accepted = true
                }
            }

            Column {
                id: layout
                spacing: 8
                x: frame.margins.left
                y: frame.margins.top

                Grid {
                    id: formGrid
                    columns: 2
                    rows: 3
                    spacing: 8


                    Text {
                        text: i18n("Seervice URL:")
                        color: theme.color
                    }
                    PlasmaWidgets.LineEdit {
                        id: serviceUrlEdit
                        text: "https://identi.ca/api/"
                    }

                    Text {
                        text: i18n("User name:")
                        color: theme.color
                    }
                    PlasmaWidgets.LineEdit {
                        id: userNameEdit
                    }

                    Text {
                        text: i18n("Password:")
                        color: theme.color
                    }
                    PlasmaWidgets.LineEdit {
                        id: fakePasswordEdit
                    }
                    MouseArea {
                        anchors.fill: fakePasswordEdit
                        anchors.margins: -5
                        onPressed: mouse.accepted = true
                    }
                    TextInput {
                        id: passwordEdit
                        anchors.fill: fakePasswordEdit
                        anchors.margins: 5
                        echoMode: TextInput.Password
                    }
                }
                Row {
                    id: buttonsRow
                    spacing: 8
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }
                    PlasmaWidgets.PushButton {
                        text: i18n("Ok")
                        onClicked: {
                            plasmoid.writeConfig("serviceUrl", serviceUrlEdit.text)
                            plasmoid.writeConfig("userName", userNameEdit.text)
                            plasmoid.writeConfig("password", passwordEdit.text)
                            disappearAnimation.running = true
                        }
                    }
                    PlasmaWidgets.PushButton {
                        text: i18n("Cancel")
                        onClicked: {
                            disappearAnimation.running = true
                        }
                    }
                }
            }
        }
    }
}