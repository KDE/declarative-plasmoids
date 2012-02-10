
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

        cellWidth: 200; cellHeight: 200

        focus: true
    }

    Component {
        id: tasksDelegate

        Item {
            width: 200
            height: 200
//            clip: true

            QIconItem {
                anchors { left: parent.left; verticalCenter: parent.verticalCenter }
                id: icon
                icon: model.icon
                width: 32
                height: 32
            }

            Text {
//                anchors { top: parent.top; horizontalCenter: parent.horizontalCenter }

                anchors { left: icon.right; top: icon.top; bottom: icon.bottom }

                text: model.name
//                width: tasksGrid.cellWdith
                width: 100
               clip: true
                height: tasksGrid.cellHeight
            }
        }
    }

    
//    PlasmaCore.Svg {
//        id: lineSvg
//        imagePath: "widgets/line"
//    }
//    
//        QIconItem {
//            icon: QIcon("utilities-terminal")
//            width: 32
//            height: 32
//        }
//        
//        PlasmaComponents.Label {
//            id: header
//            text: i18n("Konsole Profiles")
//            anchors { horizontalCenter: parent.horizontalCenter }
//            horizontalAlignment: Text.AlignHCenter
//        }
//    
//    PlasmaCore.SvgItem {
//        id: separator
//        
//        anchors { left: headerRow.left; right: headerRow.right; top: headerRow.bottom }
//        svg: lineSvg
//        elementId: "horizontal-line"
//        height: lineSvg.elementSize("horizontal-line").height
//    }
//    
//    Text {
//        id: textMetric
//        visible: false
//        // translated but not used, we just need length/height
//        text: i18n("Arbitrary String Which Says The Something")
//    }
//    
}
