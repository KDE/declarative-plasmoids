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
    
    property bool listdictionaries: false;

    Component.onCompleted: {
        plasmoid.addEventListener('ConfigChanged', configChanged);
        plasmoid.busy = true
        icon.setIcon("accessories-dictionary")
    }

    function configChanged()
    {
    }

    PlasmaCore.DataSource {
        id: feedSource
        engine: "dict"
        connectedSources: ["freedom"]
        interval: 0
        onDataChanged: {
            plasmoid.busy = false
        }
    }

    PlasmaCore.DataModel {
        id: dataModel
        dataSource: feedSource
        keyRoleFilter: "[\\d]*"
    }

    PlasmaCore.Theme {
        id: theme
    }

    Column {
        width: mainWindow.width
        height: mainWindow.height
        Row {
            id: searchRow
            width: parent.width
            PlasmaWidgets.IconWidget {
                id: icon
                onClicked: {
                    mainWindow.listdictionaries = true
                    timer.running = true
                }
            }
            PlasmaWidgets.LineEdit {
                id: searchBox
                clearButtonShown: true
                width: parent.width - icon.width - parent.spacing
                onTextChanged: {
                    timer.running = true
                    mainWindow.listdictionaries = false
                }
            }
        }
        Flickable {
            width: parent.width - parent.spacing
            height: parent.height - searchRow.height - parent.spacing
            contentWidth: childrenRect.width
            contentHeight: textBrowser.height
            clip: true
            Text {
                id: textBrowser
                wrapMode: Text.Wrap
                width: parent.parent.width
                clip: true
                text: {
                    if (mainWindow.listdictionaries) {
                        var data = feedSource.data["list-dictionaries"]
                        var temp = ""
                        for (var line in data) {
                            temp = temp + line + ":" + data[line] + "<br>"
                        }
                        temp
                    } else {
                        if (feedSource.data[searchBox.text])
                            feedSource.data[searchBox.text]["text"]
                        else
                            "This is the dictionary plasmoid"
                    }
                }
            }
        }
    }
    Timer {
       id: timer
       running: false
       repeat: false
       interval: 500
       onTriggered: {
            plasmoid.busy = true
            if (mainWindow.listdictionaries) {
                feedSource.connectedSources = "list-dictionaries"
            } else {
                feedSource.connectedSources = [searchBox.text]
            }
       }
    }
}
