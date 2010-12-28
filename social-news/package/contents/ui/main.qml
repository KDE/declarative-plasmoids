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

Item {
    id: mainWindow

    property string source
    //property variant individualSources
    //property int scrollInterval

    Component.onCompleted: {
        plasmoid.addEventListener('ConfigChanged', configChanged);
        plasmoid.busy = true
    }

    function configChanged()
    {
        //source = plasmoid.readConfig("feeds")
        //scrollInterval = plasmoid.readConfig("interval")
        //var sourceString = new String(source)
        //print("Configuration changed: " + source);
        feedSource.connectedSources = "Providers"
        //feedSource.connectSource("Activities\\provider:https://api.opendesktop.org/v1/activity")

        //individualSources = String(source).split(" ")
        //repeater.model = individualSources.length
    }

    PlasmaCore.DataSource {
        id: feedSource
        engine: "ocs"
        interval: 5000
        onDataChanged: {
            plasmoid.busy = false
           // if (source = "Providers") {
            //    connectSource("Activities\\provider:https://api.opendesktop.org/v1/activity")
            //    print("Provider updated");
            //}
            if (source = "Providers") {
                for (var i in data) {
                    connectSource("Activities\\provider:" + data.key(i));
                }
            }
        }
    }
    
    
    /*PlasmaCore.DataModel {
        id: dataModel
        dataSource: feedSource
        keyRoleFilter: "timestamp"
    }*/
    
    ListModel {
        id: dataModel
        
        ListElement {
            message: "bla has visited your profile page"
            userAvatarUrl: "/home/kde-devel/kde/share/icons/oxygen/32x32/actions/address-book-new.png"
        }
    }

    PlasmaCore.Theme {
        id: theme
    }
    
    ListView {
        model: dataModel
        delegate: Row {
            spacing: 5
            Image {
                source: userAvatarUrl
            }
            Text {
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                text: message
            }
        }
    }

    /*Column {
        PlasmaCore.SvgItem {
            id: svgItem
            width: naturalSize.width / 1.5
            height: naturalSize.height / 1.5
            elementId: "RSSNOW"
            svg: PlasmaCore.Svg {
                id: headersvg
                imagePath: "rssnow/rssnow"
            }
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
    }*/
}
