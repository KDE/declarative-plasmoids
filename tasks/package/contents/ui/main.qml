
/*****************************************************************************
 *   Copyright (C) 2011, 2012 by Shaun Reich <shaun.reich@kdemail.net>        *
 *                                                                            *
 *   This program is free software; you can redistribute it and/or            *
 *   modify it under the terms of the GNU General Public License as           *
 *   published by the Free Software Foundation; either version 2 of           *
 *   the License, or (at your option) any later version.                      *
 *                                                                            *
 *   This program is distributed in the hope that it will be useful,          *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of           *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            *
 *   GNU General Public License for more details.                             *
 *                                                                            *
 *   You should have received a copy of the GNU General Public License        *
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.    *
 *****************************************************************************/

import QtQuick 1.1
import org.kde.qtextracomponents 0.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.components 0.1

Item {
    id: tasks

    property int minimumWidth: 300
    property int minimumHeight: 300

    PlasmaCore.DataSource {
        id: tasksSource
        engine: "tasks"
        onSourceAdded: connectSource(source)
        onSourceRemoved: disconnectSource(source)

        Component.onCompleted: connectedSources = sources
    }

    PlasmaCore.DataModel {
        id: tasksModel
        dataSource: tasksSource
    }

    Component.onCompleted: {
//        plasmoid.popupIcon = "utilities-terminal";
 //       plasmoid.aspectRatioMode = IgnoreAspectRatio;
    }

    GridView {
        id: tasksGrid

        anchors.fill: parent

        model: tasksModel
        delegate: tasksDelegate

        cellWidth: 300; cellHeight: 30

        focus: true
        interactive: false



        MouseArea {
            property string currentId: "-1"                       // Original position in model
            property int newIndex                            // Current Position in model
            property int index: tasksGrid.indexAt(mouseX, mouseY) // Item underneath cursor
            id: loc
            anchors.fill: parent
            onPressAndHold: currentId =tasksModel.get(1).name //tasksModel.get(newIndex = index).gridId.
            onReleased: currentId = -1
            onMousePositionChanged:
            if (loc.currentId != "-1" && index != -1 && index != newIndex) {
                
                console.log("DEBUG" + "newindex: " + newIndex + " INDEX: " + index)
                tasksModel.move(0 , 1, 1)//newIndex, newIndex = index, 1)
            }
        }
    }

    Component {
        id: contextMenuComponent
        PlasmaComponents.ContextMenu {
            PlasmaComponents.MenuItem {
                text: "White"
              //  onClicked: {
                    //contentMenuButton.parent.color = "White"
               // }
            }
            PlasmaComponents.MenuItem {
                text: "Red"
 //               onClicked: contentMenuButton.parent.color = "Red"
            }
            PlasmaComponents.MenuItem {
                text: "LightBlue"
  //              onClicked: contentMenuButton.parent.color = "LightBlue"
            }
            PlasmaComponents.MenuItem {
                text: "LightGreen"
   //             onClicked: contentMenuButton.parent.color = "LightGreen"
            }
        }
    }

    Component {
        id: tasksDelegate

        Item {
            id: wrapper
            width: 300
            height: 30

            //FIXME: make it not be created in the first place..
            visible: model.onCurrentDesktop

            GridView.onRemove: SequentialAnimation {
                PropertyAction { target: wrapper ; property: "GridView.delayRemove"; value: true }
                NumberAnimation { target: taskBackground; property: "opacity"; to: 0; duration: 2500; easing.type: Easing.InOutQuad }
                PropertyAction { target: wrapper; property: "GridView.delayRemove"; value: false }
            }

            states: [
                State {
                    name: "none"
                    when: !hovered && !model.minimized

                    PropertyChanges {
                        target: taskBackground
                        prefix: "normal"
                    }
                },
                State {
                    name: "hovered"
                    when: hovered && !model.minimized

                    PropertyChanges {
                        target: taskBackground
                        prefix: "hover"
                    }
                },
                State {
                    name: "minimized"
                    when: model.minimized

                    PropertyChanges {
                        target: taskBackground
                        prefix: "focus"
                    }
                }
            ]

            property bool hovered: false
            property ContextMenu contextMenu
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true

  

                onClicked: {
                   // if (!contextMenu) {
                    if (mouse.button == Qt.RightButton) {
                        contextMenu = contextMenuComponent.createObject(wrapper)
                        contextMenu.open()
                    }
                   // }
                }

                onEntered: {
                    hovered = true;
                }

                onExited: {
                    hovered = false;
                }
            }

            PlasmaCore.FrameSvgItem {
                id: taskBackground

                anchors { left: icon.left; right: text.right; top: icon.top; bottom: icon.bottom }

                imagePath: "widgets/tasks"
//                prefix: {
//                    if (model.minimized) {
//                        "focus"
//                    } else {
//                        if (hovered) {
//                            "hover"
//                        } else {
//                            "normal"
//                        }
//                    }
//                }
            }

            QIconItem {
                id: icon

                anchors { left: taskBackground.left; verticalCenter: taskBackground.verticalCenter }

                icon: model.icon
                width: 22
                height: 22
            }

            PlasmaComponents.Label {
                id: text

                anchors { left: icon.right; top: icon.top; bottom: icon.bottom }

                height: tasksGrid.cellHeight
                width: 200

                verticalAlignment: Text.AlignVCenter

                clip: true
                text: model.name
            }
        }
    }


//        PlasmaComponents.Label {
//            id: header
//            text: i18n("Konsole Profiles")
//            anchors { horizontalCenter: parent.horizontalCenter }
//            horizontalAlignment: Text.AlignHCenter
//        }
//

//
//    Text {
//        id: textMetric
//        visible: false
//        // translated but not used, we just need length/height
//        text: i18n("Arbitrary String Which Says The Something")
//    }
//
}
