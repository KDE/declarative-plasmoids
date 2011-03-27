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
import "plasmapackage:/code/utils.js" as Utils

ListView {
    id: list

    property string feedCategory
    signal itemClicked

    snapMode: ListView.SnapToItem

    clip: true
    model: PlasmaCore.SortFilterModel {
        id: postTitleFilter
        filterRole: "title"
        sortRole: "time"
        sortOrder: "DescendingOrder"
        filterRegExp: toolbarFrame.searchQuery
        sourceModel: PlasmaCore.SortFilterModel {
            id: feedCategoryFilter
            filterRole: "feed_url"
            filterRegExp: feedCategory
            sourceModel: PlasmaCore.DataModel {
                dataSource: feedSource
                keyRoleFilter: "items"
            }
        }
    }

    section.property: "feed_title"
    section.criteria: ViewSection.FullString
    section.delegate: ListItem {
        id: sectionDelegate
        state: "section"
        implicitHeight: sectionText.height
        Text {
            id: sectionText
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: sectionDelegate.padding.left
            anchors.right: sectionDelegate.padding.right
            color: theme.textColor
            text: section
            font.bold: true
        }
    }

    delegate: ListItemEntry {
        text: title
        date: Utils.date(time)

        Component.onCompleted: {
            if (BookKeeping.isArticleRead(link)) {
                opacity = 0.5
            } else {
                opacity = 1
            }
        }

        onClicked: {
            BookKeeping.setArticleRead(link, feed_url);
            opacity = 0.5;

            list.currentIndex = index
            bodyView.html = "<body style=\"background:#fff;\">"+description+"</body>"
            list.itemClicked()
        }
    }
}
