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

    onSourceChanged: {
        if (previousSource && previousSource != source) {
            print("######################### source changed from " + previousSource + " to " + source);
            microblogSource.disconnectSource(previousSource);
        }
        if (userName && timelineType && url) {
            print("######## Connecting Timeline source: " + source);
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
                    print("TODO: load more ... " + source);
                }
                onVisibleChanged: {
                    loadingIndicator.running = y < 300;
                    loadingTimer.running = !visible;
                    loadingIndicator.visible = y < 300;
                    loadingTimer.running = loadingIndicator.visible;
                }
            }
            PlasmaComponents.BusyIndicator {
                id: loadingIndicator
                running: true
                visible: true
                anchors.horizontalCenter: parent.horizontalCenter

                Timer {
                    id: loadingTimer
                    interval: 3000 // 10 sec timeout
                    repeat: false
                    onTriggered: {
                        loadingIndicator.running = false
                        loadingIndicator.visible = false
                        loadMoreButton.visible = footerItem.y > 300
                    }
                }
            }
            onYChanged: {
                if (y < 300) {
                    loadingIndicator.running = true
                    loadingIndicator.visible = true
                } else {
                    loadingIndicator.running = false
                    loadingIndicator.visible = false
                }
                loadMoreButton.visible = footerItem.y > 300
            }

        }
    }
    delegate: MessageWidget {
        id: messageWidget
        onClicked: showMessage(messageWidget)
    }
}
