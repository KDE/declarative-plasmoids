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

import "plasmapackage:/ui/BasicComponents"
import "plasmapackage:/ui/ComplexComponents"
import "plasmapackage:/code/utils.js" as Utils
import "plasmapackage:/code/bookkeeping.js" as BookKeeping

Item {
    id: mainWindow;
    width: 250
    height: 400
    state: "items"

    property string source
    signal unreadCountChanged();

    states: [
         State {
             name: "feeds"
             PropertyChanges { target: mainView; currentIndex: 0 }
         },
         State {
             name: "items"
             PropertyChanges { target: mainView; currentIndex: 1 }
         },
         State {
             name: "item"
             PropertyChanges { target: mainView; currentIndex: 2 }
         }
     ]

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


    PlasmaCore.DataSource {
        id: feedSource
        engine: "rss"
        interval: 50000
        onDataChanged: {
            plasmoid.busy = false
            BookKeeping.updateUnreadCount(feedSource.data[source].items)
        }
    }

    PlasmaCore.Theme {
        id: theme
    }

    Column {
        Toolbar {
            id: toolbarFrame
            onOpenOriginalRequested: bodyView.url = Url(bodyView.articleUrl)
            onBackRequested: bodyView.html = bodyView.articleHtml
        }

        PlasmaWidgets.TabBar {
            id : mainView
            width : mainWindow.width
            height: mainWindow.height-toolbarFrame.height
            tabBarShown: false

            onCurrentChanged: {
                toolbarFrame.backEnabled = currentIndex > 0
                toolbarFrame.searchEnabled = currentIndex < 2
            }

            QGraphicsWidget {
                id: feedListContainer
                FeedList {
                    id: feedList
                    anchors.fill: feedListContainer
                    onItemClicked: mainWindow.state = "items"
                }
            }
            QGraphicsWidget {
                id: listContainer

                ItemsList {
                    id: itemsList
                    anchors.fill: listContainer
                    feedCategory: feedList.feedCategory
                    onItemClicked: mainWindow.state = "item"
                }
            }

            ArticleView {
                id : bodyView
            }
        }
    }
}
