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
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras

Item {
    property alias text: titleItem.text
    property int bottomSpacing: 48
    property string src

    width: 96
    height: 48

    PlasmaExtras.Title {
        //y: 12
        id: titleItem
        anchors { top: parent.top; left: titlespacerleft.right; right: parent.right; }
    }
    Item {
        id: titlespacerleft
        width: 12
        height: 10
        anchors { top: titleItem.top; left: parent.left}
    }
    Item {
        id: titlespacer
        height: bottomSpacing
        anchors { top: titleItem.top; left: parent.left; right: parent.right; }
    }
    PlasmaComponents.ToolButton {
        iconSource: "view-refresh"
        width: 48
        height: 48
        visible: src != ""
        anchors { top: parent.top; right: parent.right; }
        onClicked: {
            //var src = timelineType + ":" + userName + "@" + serviceUrl;
            print("Refresh()" + src + "'");
            function result(job) {
                print("refresh() finished." + job.result);
            }
            var service = microblogSource.serviceForSource(src)
            var operation = service.operationDescription("refresh");
            var j = service.startOperationCall(operation);
            j.finished.connect(result);
        }
    }

}
