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

        for (var i=0; i < feedSource.connectedSources.length; ++i) {
            feedsModel.append({'url': feedSource.connectedSources[i]})
        }
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


                Row {
                    spacing: 8
                    Text {
                        text: i18n("Feed URL:")
                        color: theme.color
                    }
                    PlasmaWidgets.LineEdit {
                        id: feedUrlEdit
                    }
                    PlasmaWidgets.PushButton {
                        text: i18n("Add")
                        onClicked: {
                            feedsModel.append({'url': feedUrlEdit.text})
                        }
                    }
                }

                Text {
                    text: i18n("Feeds:")
                    color: theme.color
                }
                ListView {
                    id: currentFeedsView
                    width: Math.max(300, parent.width)
                    height: 300

                    model: ListModel {
                        id: feedsModel
                    }
                    delegate: Item {
                        width: currentFeedsView.width
                        height: removeButton.height + 10
                        Text {
                            text: url
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        PlasmaWidgets.PushButton {
                            id: removeButton
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            text: i18n("Remove")
                            onClicked: {
                                feedsModel.remove(index)
                            }
                        }
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
                            var feeds
                            var first = true
                            for (var i = 0; i < feedsModel.count; ++i) {
                                if (!first) {
                                    feeds += ","
                                } else {
                                    first = false
                                }
                                feeds += feedsModel.get(i).url
                            }
                            plasmoid.writeConfig("feeds", feeds)
                            mainWindow.configChanged()
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