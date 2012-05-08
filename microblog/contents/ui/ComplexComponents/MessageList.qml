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

import QtQuick 1.0
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras

import "plasmapackage:/ui/BasicComponents"

ListView {
    id: entryList

    clip: false
    snapMode: ListView.SnapToItem
    highlightRangeMode: ListView.ApplyRange

    spacing: 2
    currentIndex: -1
    cacheBuffer: 500
    width: mainFlickable.columnWidth
    height: mainFlickable.height - 48

    signal itemClicked(variant item)

    property string timelineType
    property string title: "Tit3l"
    property string url: serviceUrl
    property string source: timelineType+":"+userName+"@"+url
    property string previousSource
    property bool isRefreshing: false
    property bool isLoadingMore: false

    onSourceChanged: {
        if (previousSource && previousSource != source) {
            //print("######################### source changed from " + previousSource + " to " + source);
            microblogSource.disconnectSource(previousSource);
        }
        if (userName && timelineType && url) {
//             print("TL ######## Connecting Timeline source: " + source);
            microblogSource.connectSource(source)
            previousSource = source
        }
    }

    model: PlasmaCore.SortFilterModel {
        id: sortModel
        sortRole: "created_at"
        sortOrder: "DescendingOrder"
        sourceModel: PlasmaCore.DataModel {
            dataSource: microblogSource
            sourceFilter: entryList.source
            keyRoleFilter: "[\\d]*"
        }
    }

    footer: tfoot
    Component {
        id: tfoot
        Item {
            id: footerItem
            height: 96
            width: 300
            PlasmaComponents.ToolButton {
                visible: y > 300 && loadingIndicator.running == false // only show when there are items in the list
                id: loadMoreButton
                text: i18n("load more...")
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: theme.defaultFont.pointSize*1.2
                height: 48
                opacity: 0.6
                onClicked: {
                    timelinewithfriends.loadMore();
//                     print("TODO: load more ... ");
//                     isLoading = true;
//                     //loadingTimer.running = !visible;
//                     //refreshBusy.visible =
//                     //y < 300;
//                     loadingTimer.running = true;
                }
            }
//             PlasmaComponents.BusyIndicator {
//                 id: loadingIndicator
//                 running: false
//                 visible: false
//                 anchors.horizontalCenter: parent.horizontalCenter
// 
//                 Timer {
//                     id: loadingTimer
//                     interval: 4000 // 10 sec timeout
//                     repeat: false
//                     onTriggered: {
//                         isLoading = false
//                         //refreshBusy.visible = false
//                         loadMoreButton.visible = footerItem.y > 300
//                     }
//                 }
//             }
            onYChanged: {
//                 if (y < 300) {
//                     //loadingIndicator.running = true
//                     //loadingIndicator.visible = true
//                 } else {
//                     loadingIndicator.running = false
//                     loadingIndicator.visible = false
//                 }
                loadMoreButton.visible = footerItem.y > 300
            }

        }
    }
    delegate: MessageWidget {
        id: messageWidget
        onClicked: showMessage(messageWidget)
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
    PlasmaComponents.ToolButton {
        id: loadMoreButton
        iconSource: "view-refresh"
        width: 48
        height: 48
        checkable: false
        opacity: (source != "" && atYEnd && !loadMoreBusy.running) ? 0.7 : 0
        anchors { bottom: parent.bottom; right: parent.right; rightMargin: 12; bottomMargin: 12; }
        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }
        onClicked: loadMore()
    }
    PlasmaComponents.BusyIndicator {
        id: loadMoreBusy
        anchors { bottom: parent.bottom; right: parent.right; rightMargin: 12; bottomMargin: 12; }
        running: isLoadingMore
        visible: running

    }

//     onIsLoadingChanged: {
//         print("isLoading : " + isLoading);
//     }
    onContentYChanged: {
        refreshButton.opacity = (source != "" && contentY < 20 && !refreshBusy.running) ? 0.7 : 0
    }

    function refresh() {
        var src = source;
        //var src = timelineType + ":" + userName + "@" + serviceUrl;
        print("TTTTTTL Refreshing" + src + "'");
        function result(job) {
            enabled = true;
            refreshBusy.running = false;
        }
        enabled = false;
        refreshBusy.running = true;
        var service = microblogSource.serviceForSource(src);
        var operation = service.operationDescription("refresh");
        var j = service.startOperationCall(operation);
        j.finished.connect(result);
    }
    function loadMore() {
        var src = source;
        print(" load more: " + contentY + " " + contentHeight + " " + (contentHeight-entryList.height));
        //var src = timelineType + ":" + userName + "@" + serviceUrl;
        return;
        print("loadMore" + src + "'");
        function result(job) {
            enabled = true;
            loadMoreBusy.running = false;
        }
        enabled = false;
        refreshBusy.running = true;
        var service = microblogSource.serviceForSource(src);
        var operation = service.operationDescription("loadMore");
        operation.before_id = "";
        var j = service.startOperationCall(operation);
        j.finished.connect(result);
    }
}
