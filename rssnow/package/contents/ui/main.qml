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
*   GNU General Public License for more details
*
*   You should have received a copy of the GNU Library General Public
*   License along with this program; if not, write to the
*   Free Software Foundation, Inc.,
*   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

import Qt 4.7
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.graphicslayouts 4.7 as GraphicsLayouts

QGraphicsWidget {
    id: mainWindow;
    preferredSize: "250x600"
    minimumSize: "200x200"

    property string source
    property variant individualSources
    property int scrollInterval

    Component.onCompleted: {
        plasmoid.addEventListener('ConfigChanged', configChanged);
        plasmoid.busy = true
    }

    function configChanged()
    {
        source = plasmoid.readConfig("feeds")
        scrollInterval = plasmoid.readConfig("interval")
        var sourceString = new String(source)
        print("Configuration changed: " + source);
        feedSource.connectedSources = source

        individualSources = String(source).split(" ")
        repeater.model = individualSources.length
    }

    Item {
        PlasmaCore.DataSource {
            id: feedSource
            engine: "rss"
            interval: 50000
            onDataChanged: {
                plasmoid.busy = false
            }
        }

        PlasmaCore.Theme {
            id: theme
        }
    }

    layout: GraphicsLayouts.QGraphicsLinearLayout {
        orientation: "Vertical"
        PlasmaWidgets.SvgWidget {
            width: mainWindow.width
            height: 50
            elementID: "RSSNOW"
            svg: PlasmaCore.Svg {
                id: headersvg
                imagePath: "rssnow/rssnow"
            }
        }


        QGraphicsWidget {
            id: feedListContainer
            Column {
                Repeater {
                    id: repeater
                
                    ListView {
                        id: entryList
                        anchors.fill: feedListContainer
                        spacing: 5;
                        snapMode: ListView.SnapToItem
                        orientation: ListView.Horizontal
                        width: feedListContainer.width
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
                            text: title//+individualSources[listIndex]
                            iconFile: icon
                            feedUrl: link
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
                                if (entryList.currentIndex == (entryList.count - 1))
                                    entryList.currentIndex = 0
                                else 
                                    entryList.currentIndex = entryList.currentIndex + 1
                            }
                        }
                    }
                }
            }
        }
    }
}
