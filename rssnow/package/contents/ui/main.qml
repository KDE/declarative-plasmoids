/*
*   Copyright 2010 Marco Martin <notmart@gmail.com>
*   Copyright 2010 Lukas Appelhans <l.appelhans@gmx.de>
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU Library General Public License as
*   published by the Free Software Foundation; either version 2, or
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
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.draganddrop 1.0 as DragAndDrop

Item {
    id: mainWindow
    property int minimumHeight: 200
    property int minimumWidth: 200
    property string source
    property variant individualSources
    property int scrollInterval
    property int interval
    property bool showLogo
    property bool showDropTarget
    signal changeConfig(string feed)
    signal reloadConfig(string feeds, int switchInterval, int updateInterval, bool logo, bool dropTarget)
    signal changeBusy(bool busy)

    Component.onCompleted: {
        changeBusy(false)
        source = _feeds
        scrollInterval = _switchInterval
        interval = _updateInterval
        showLogo = _logo
        showDropTarget = _dropTarget
        configChanged()
    }

    onReloadConfig: {
        source = feeds
        scrollInterval = switchInterval
        interval = updateInterval
        showLogo = logo
        showDropTarget = dropTarget
        configChanged()
    }

    function configChanged()
    {
        console.log("*********************************")
        console.log("Configuration changed: " + source);
        console.log("*********************************")
        var tmpStr = new String(source)
        tmpStr = tmpStr.split(",")
        feedSource.connectedSources = tmpStr
        individualSources = tmpStr
        repeater.model = individualSources.length
    }

    PlasmaCore.DataSource {
        id: feedSource
        engine: "rss"
        interval: interval
        onDataChanged: {
            changeBusy(true)
        }
    }

    PlasmaCore.Theme {
        id: theme
    }

    Column {
        spacing: 5
        PlasmaCore.SvgItem {
            id: svgItem
            width: naturalSize.width / 1.5
            height: naturalSize.height / 1.5
            elementId: "RSSNOW"
            svg: PlasmaCore.Svg {
                id: headersvg
                imagePath: "rssnow/rssnow"
            }

            states: [
                        State {
                            name: "show"
                            when: showLogo
                            PropertyChanges {
                                target: svgItem
                                visible: true
                            }
                        },
                        State {
                            name: "hide"
                            when: !showLogo
                            PropertyChanges {
                                target: svgItem
                                visible: false
                            }
                        }
            ]
        }

        Repeater {
            id: repeater

            ListView {
                id: entryList
                spacing: 5;
                snapMode: ListView.SnapToItem
                orientation: ListView.Horizontal
                width: mainWindow.width
                height: 50
                clip: true
                highlightMoveDuration: 300
                property int listIndex: index
                model: PlasmaCore.SortFilterModel {
                    filterRole: "feed_url"
                    filterRegExp: individualSources[listIndex]
                    sourceModel: PlasmaCore.DataModel {
                        dataSource: feedSource
                        keyRoleFilter: "items"
                    }
                }
                delegate: ListItemEntry {
                    id: listEntry
                    text: "<B>" + '(' + entryList.currentIndex + '/' + entryList.count + ')' + "</B>" + "<br>" + title + "<br>"//+individualSources[listIndex]
                    iconFile: icon
                    feedUrl: link
                    onClicked: {
                        flickTimer.restart();
                    }
                }

                onFlickEnded: {
                    currentIndex = contentX / contentWidth * count
                }
                Timer {
                    id: flickTimer
                    interval: scrollInterval * 1000
                    running: true
                    repeat: true
                    onTriggered: {
                        if (entryList.currentIndex == (entryList.count - 1)) {
                            entryList.currentIndex = 0
                        } else {
                            entryList.currentIndex = entryList.currentIndex + 1
                        }
                    }
                }
            }//entyList end
        }//repeater end
        DropRssEntry {
            id: dropRssEntry
            width: mainWindow.width
            height: 50
            DragAndDrop.DropArea {
                anchors.fill: parent
                onDrop: {
                    changeConfig(event.mimeData.url);
                    mainWindow.configChanged()
                }
                states: [
                        State {
                            name: "show"
                            when: showDropTarget
                            PropertyChanges {
                                target: dropRssEntry
                                visible: true
                            }
                        },
                        State {
                            name: "hide"
                            when: !showDropTarget
                            PropertyChanges {
                                target: dropRssEntry
                                visible: false
                            }
                        }
                ]
            }
        }
    }// column end
}//root item end
