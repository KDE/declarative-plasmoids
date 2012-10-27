/*
 *   Copyright 2011 Marco Martin <mart@kde.org>
 *   Copyright 2012 Sebastian Kügler <sebas@kde.org>
 *   Copyright 2012 Martin Klapetek <mklapetek@kde.org>
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

import QtQuick 1.0
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras

import "plasmapackage:/ui/BasicComponents"

ListView {
    id: entryList

    clip: false
    snapMode: ListView.SnapToItem
    //highlightRangeMode: ListView.ApplyRange
    highlightMoveDuration: 2000
    spacing: 2
    currentIndex: -1
    cacheBuffer: 500
    width: mainFlickable.columnWidth
    height: mainFlickable.height - 48

    signal itemClicked(variant item)

    property string timelineType
    property string args: ""
    property string title: typeToTitle(timelineType)
    property string url: serviceUrl
    property string source: timelineType+":"+main.userName+"@"+url+":"+args
    property string previousSource
    property bool isRefreshing: false
    property bool isLoadingMore: false

    onArgsChanged: {
        print("new query: " + args);
    }

    model: socialFeed.model
    highlight: PlasmaComponents.Highlight { width: mainFlickable.columnWidth; }
    delegate: MessageWidget {
        id: messageWidget
        onClicked: {
            entryList.currentIndex = index;
            entryList.positionViewAtIndex( index, ListView.Contain)
//             showMessage(messageWidget);
            if (messageWidget.state == "detail") {
                messageWidget.state = "list"
            } else {
                messageWidget.state = "detail"
                socialFeed.onShowPost(messageWidget.akonadiId, messageWidget.messageId);
            }
        }
    }
    PlasmaComponents.ScrollBar {
        id: scrollBar
        orientation: Qt.Vertical
        flickableItem: entryList
        stepSize: 40
        scrollButtonInterval: 50
        z: 10
        anchors {
            top: entryList.top
            right: entryList.right
            bottom: entryList.bottom
        }
    }

    PlasmaComponents.ToolButton {
        id: refreshButton
        iconSource: "view-refresh"
        width: 48
        height: 48
        checkable: false
        opacity: (source != "" && contentY < 20 && !refreshBusy.running) ? 0.7 : 0
        anchors { top: parent.top; right: parent.right; rightMargin: 12; }
        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }
        onClicked: refresh()
    }

    PlasmaComponents.BusyIndicator {
        id: refreshBusy
        anchors { top: parent.top; right: parent.right; rightMargin: 12; }
        running: isRefreshing
        visible: running

    }

    PlasmaComponents.BusyIndicator {
        id: loadMoreBusy
        anchors { bottom: parent.bottom; right: parent.right; rightMargin: 12; bottomMargin: 12; }
        running: isLoadingMore
        visible: running
    }

    onContentYChanged: {
        refreshButton.opacity = (source != "" && contentY < 20 && !refreshBusy.running) ? 0.7 : 0
    }

    function refresh() {
//        refreshBusy.running = true;
        socialFeed.onResfreshCollections()
    }
    function loadMore() {
        var src = source;
        print(" load more: " + contentY + " " + contentHeight + " " + (contentHeight-entryList.height));
        //var src = timelineType + ":" + userName + "@" + serviceUrl;
        //return;
        print("loadMore" + src + "'");
        function result(job) {
            enabled = true;
            loadMoreBusy.running = false;
            loadMoreButton.opacity = 0.7;
            print("loadmore done.");
        }
        enabled = false;
        loadMoreBusy.running = true;
        loadMoreButton.opacity = 0;
        var service = microblogSource.serviceForSource(src);
        var operation = service.operationDescription("loadMore");
        operation.before_id = "";
        var j = service.startOperationCall(operation);
        j.finished.connect(result);
    }
}
