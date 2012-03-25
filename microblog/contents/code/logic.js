/*
 *   Copyright 2011 Marco Martin <mart@kde.org>
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

var messagesDataSource
var userName
var serviceUrl

function refresh()
{
    var src = "TimelineWithFriends:" + userName + "@" + serviceUrl;
    var service = messagesDataSource.serviceForSource(src)
    var operation = service.operationDescription("refresh");
    service.startOperationCall(operation);
}

function update(status, inReplyToStatusId)
{
    var src = "TimelineWithFriends:" + userName + "@" + serviceUrl;
    var service = messagesDataSource.serviceForSource(src)
    var operation = service.operationDescription("update");
    operation.status = status;
    operation.in_reply_to_status_id = inReplyToStatusId
    print(" ... > messagesDataSource: " + src)
    service.startOperationCall(operation);
}

function retweet(id)
{
    var src = "TimelineWithFriends:" + userName + "@" + serviceUrl;
    
    var service = messagesDataSource.serviceForSource(src)
    var operation = service.operationDescription("statuses/retweet");
    operation.id = id;
    service.startOperationCall(operation);
}

function setFavorite(id, isFavorite)
{
    var src = "TimelineWithFriends:" + userName + "@" + serviceUrl;
    var service = messagesDataSource.serviceForSource(src)
    var operation;
    if (isFavorite) {
        operation = "favorites/create";
    } else {
        operation = "favorites/destroy";
    }

    var operation = service.operationDescription(operation);
    operation.id = id;
    service.startOperationCall(operation);
}

