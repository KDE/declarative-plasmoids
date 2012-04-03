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
//#include "../../../platformcontents/application/generic/ui/BasicComponents/PostingWidget.qml"

import QtQuick 1.0
//import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
//import org.kde.plasma.extras 0.1 as PlasmaExtras

MessageList {
    id: msgList

    //timelineType: customTimeline
    timelineType: "SearchTimeline"
    //source: timelineType+":"+userName+"@"+url

    property string src: timelineType+":"+userName+"@"+url+":president"
    source : src

    header: searchHeader

    Item {
        id: searchHeader
        height: childrenRect.height
        Item {
            height: 48
            PlasmaComponents.TextField {
                id: txtEdit
                height: searchButton.height*1.1
                anchors { left: parent.left;
                        leftMargin: 24; rightMargin: 12 }
                Keys.onReturnPressed: loadTimeline(txtEdit.text);
            }
            PlasmaComponents.Button {
                id: searchButton
                text: i18n("Search")
                width: 96
                height: 32
                anchors { left: txtEdit.right;
                        leftMargin: 12; rightMargin: 24 }
                onClicked: loadTimeline(txtEdit.text)
            }
        }
    }
    function loadTimeline(txt) {
        //print("Loading timeline: " + txt);
        var tl = "SearchTimeline:"+userName+"@"+serviceUrl+":"+txt;
        src = tl;
    }

    Timer {
        id: timer
        interval: 2000
        running: false
        repeat: false
        //onTriggered: loadTimeline("foobar")
    }

    Component.onCompleted: timer.running = true

    onItemClicked: showMessage(item)

}