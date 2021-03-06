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

.pragma library

var storageService = loadService("org.kde.servicestorage")

var readArticles = new Array;
var unreadCount = new Array;
var totalUnreadCount = 0

var mainWindow = 0

function setArticleRead(id, feedUrl)
{
    var unread = !isArticleRead(id)
    var markOperation = storageService.operationDescription("save")

    markOperation.group = "read"
    markOperation.key = id
    var job = storageService.startOperationCall(markOperation);
    var data = new Object
    data[id] = 1
    job.data = data
    readArticles.push(id)

    if (unread) {
        --totalUnreadCount
        --unreadCount[feedUrl]
        mainWindow.unreadCountChanged()
    }
}

function isArticleRead(id)
{
    return readArticles.indexOf(id) > -1;
}

readJobFinished = function(job)
{
    for (prop in job.result) {
        if (prop) {
            readArticles.push(prop)
        }
    }
}

function loadReadArticles()
{
    var queryOperation = storageService.operationDescription("retrieve")
    queryOperation.group = "read"
    var job = storageService.startOperationCall(queryOperation);
    job.finished.connect(readJobFinished)
}

function unreadForSource(feedUrl)
{
    return unreadCount[feedUrl]
}

function updateUnreadCount(items)
{
    for (i in items) {
        var feedUrl = items[i]['feed_url']
        if (!isArticleRead(items[i]['link'])) {
            ++totalUnreadCount
            if (unreadCount[feedUrl]) {
                ++unreadCount[feedUrl]
            } else {
                unreadCount[feedUrl] = 1
            }
        }
    }
    mainWindow.unreadCountChanged()
}


