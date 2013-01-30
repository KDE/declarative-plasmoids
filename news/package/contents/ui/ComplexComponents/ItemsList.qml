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
import "plasmapackage:/code/bookkeeping.js" as BookKeeping
import "plasmapackage:/code/utils.js" as Utils

PlasmaExtras.ScrollArea {
    id: root
    property alias feedCategory: list.feedCategory
    signal itemClicked

    ListView {
        id: list

        property string feedCategory

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
                filterRegExp: feedCategory.replace(/\?/, "\\?")
                sourceModel: PlasmaCore.DataModel {
                    dataSource: feedSource
                    keyRoleFilter: "items"
                }
            }
        }

        section.property: "feed_title"
        section.criteria: ViewSection.FullString
        section.delegate: PlasmaComponents.ListItem {
            id: sectionDelegate
            state: "section"
            PlasmaExtras.Heading {
                id: sectionText
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: sectionDelegate.padding.left
                anchors.right: sectionDelegate.padding.right
                anchors.leftMargin: 8
                text: section
                level: 3
            }
        }

        delegate: ListItemEntry {
            id: feedItem
            text: title
            date: Utils.date(time)
            state: (list.currentIndex == index)?"sunken":"normal"

            Component.onCompleted: {
                if (BookKeeping.isArticleRead(link)) {
                    articleRead = true
                } else {
                    articleRead = false
                }
            }

            onClicked: {
                BookKeeping.setArticleRead(link, feed_url);
                articleRead = true;

                list.currentIndex = index;
                bodyView.articleUrl = link;
                var parsedHtml = "<html><head><style type=\"text/css\">" + theme.styleSheet + " h1 {   font-weight: normal; }; p { text-align: \"justify\" } </style></head><body><h1>" + title + "</h1><em>by " + author + "</em><br /><p>"  + description + "</p></body></html>";
                bodyView.articleHtml = parsedHtml;
                if (mainWindow.browserMode) {
                    bodyView.url = Url(bodyView.articleUrl)
                }
                root.itemClicked();
            }
        }
    }
}
