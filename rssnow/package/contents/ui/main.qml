/*
*   Copyright 2010 Marco Martin <notmart@gmail.com>
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

import "plasmapackage:/code/utils.js" as Utils
import "plasmapackage:/code/bookkeeping.js" as BookKeeping

QGraphicsWidget {
    id: mainWindow;
    preferredSize: "250x600"
    minimumSize: "200x200"

    property string source
    signal unreadCountChanged();

    Component.onCompleted: {
        BookKeeping.mainWindow = mainWindow
        BookKeeping.loadReadArticles();
        plasmoid.addEventListener('ConfigChanged', configChanged);
        plasmoid.busy = true
    }

    function configChanged()
    {
        source = plasmoid.readConfig("feeds")
        var sourceString = new String(source)
        print("Configuration changed: " + source);
        feedSource.connectedSources = source
    }

    Item {
        PlasmaCore.DataSource {
            id: feedSource
            engine: "rss"
            interval: 50000
            onDataChanged: {
                plasmoid.busy = false
                BookKeeping.writeItems(feedSource.data[source].items)
            }
        }

        PlasmaCore.Theme {
            id: theme
        }

        /*Timer {
            id: searchTimer
            interval: 500;
            running: false
            repeat: false
            onTriggered: {
                if (mainView.currentIndex == 0) {
                    feedListFilter.filterRegExp = ".*"+searchBox.text+".*";
                } else {
                    postTitleFilter.filterRegExp = ".*"+searchBox.text+".*";
                }
            }
        }*/
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
                /*ListView {
                    id: feedList
                    anchors.fill: feedListContainer
                    signal itemClicked;
                    spacing: 5;
                    snapMode: ListView.SnapToItem
                    //width: mainWindow.width
                    //height: mainWindow.height

                    clip: true
                    model: PlasmaCore.SortFilterModel {
                        id: feedListFilter
                        filterRole: "feed_title"
                        sourceModel: PlasmaCore.DataModel {
                            dataSource: feedSource
                            keyRoleFilter: "sources"
                        }
                    }
                    delegate: */ListView {
                        id: entryList
                        anchors.fill: feedListContainer
                        spacing: 5;
                        snapMode: ListView.SnapToItem
                        orientation: ListView.Horizontal
                        width: feedListContainer.width
                        height: 50
                        
                        clip: true
                        model: PlasmaCore.SortFilterModel {
                            filterRole: "feed_title"
                            sourceModel: PlasmaCore.DataModel {
                                dataSource: feedSource
                                keyRoleFilter: "items"
                            }
                        } /*PlasmaCore.SortFilterModel {
                        filterRole: "feed_title"
                        sourceModel: PlasmaCore.DataModel {
                            dataSource: feedSource
                            keyRoleFilter: "sources"
                        }
                    }*//*ListModel {
     id: fruitModel

     ListElement {
         name: "Apple"
         cost: 2.45
     }
     ListElement {
         name: "Orange"
         cost: 3.25
     }
     ListElement {
         name: "Banana"
         cost: 1.95
     }
 }*/ /*PlasmaCore.SortFilterModel {
                            id: postTitleFilter
                            filterRole: "title"
                            sortRole: "time"
                            sortOrder: "DescendingOrder"
                            sourceModel: PlasmaCore.SortFilterModel {
                                id: feedCategoryFilter
                                filterRole: "feed_url"
                                filterRegExp: "http://planetkde.org/rss20.xml"
                                sourceModel: PlasmaCore.DataModel {
                                    dataSource: feedSource
                                    keyRoleFilter: "items"
                                }*/
                            //}
                        //}
                        
                        /*section.property: "feed_title"
                        section.criteria: ViewSection.FullString
                        section.delegate: ListItem {
                            Text {
                                color: theme.textColor
                                text: section
                                font.bold: true
                            }
                        }*/
                                          
                        delegate: ListItemEntry {
                            id: listEntry
                            text: title
                            date: Utils.date(time)
                        }
                    }
                //}
            }
        }
}
