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

import QtQuick 1.0
import org.kde.plasma.core 0.1 as PlasmaCore

import "plasmapackage:/ui/BasicComponents"
import "plasmapackage:/code/bookkeeping.js" as BookKeeping

ListView {
    id: feedList

    signal itemClicked;
    property string feedCategory

    snapMode: ListView.SnapToItem

    clip: true
    model: PlasmaCore.SortFilterModel {
        id: feedListFilter
        filterRole: "feed_title"
        filterRegExp: toolbarFrame.searchQuery
        sourceModel: PlasmaCore.DataModel {
            dataSource: feedSource
            keyRoleFilter: "sources"
        }
    }

    header: ListItemSource {
            id: feedListHeader
            text: i18n("Show All")
            unread: BookKeeping.totalUnreadCount
            state: (feedList.feedCategory == "")?"sunken":"normal"
            onClicked: {
                feedList.feedCategory = ""
                feedList.itemClicked()
            }
            Connections {
                target: mainWindow
                onUnreadCountChanged: {
                    feedListHeader.unread = BookKeeping.totalUnreadCount
                }
            }
        }

    delegate: ListItemSource {
        id: listItemSource
        text: feed_title
        icon: model.icon
        unread: BookKeeping.unreadForSource(feed_url)
        state: (feedCategory == feed_url)?"sunken":"normal"

        onClicked: {
            feedCategory = feed_url
            itemClicked()
        }
        Connections {
            target: mainWindow
            onUnreadCountChanged: {
                unread = BookKeeping.unreadForSource(feed_url)
            }
        }
    }
}
