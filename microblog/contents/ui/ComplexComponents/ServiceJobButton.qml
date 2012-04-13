/*
 *   Copyright 2012 Sebastian Kügler <sebas@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
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

import QtQuick 1.1
import org.kde.plasma.components 0.1 as PlasmaComponents
//import org.kde.plasma.extras 0.1 as PlasmaExtras
import "plasmapackage:/code/logic.js" as Logic

PlasmaComponents.ToolButton {
    id: favoriteButton
    property string param
    //property bool isFavorite

    text: "♥"
    font.pointSize: 24
    width: 48
    height: 48
    checked: isFavorite
    checkable: true
    onClicked: {
        enabled = false;
        var src = "TimelineWithFriends:" + userName + "@" + serviceUrl;
        var service = microblogSource.serviceForSource(src)
        var operation;
        if (isFavorite) {
            operation = "favorites/create";
        } else {
            operation = "favorites/destroy";
        }

        function result(job) {
            print(" Result: " + job.result + " op: " + job.operationName);
            print("  Favorite? " + checked);
            //text = job.result ? "OK" : ":("
            //isFavorite = checked;
            enabled = true;
        }

        var operation = service.operationDescription(operation);
        operation.id = messageId;
        var serviceJob = service.startOperationCall(operation);
        serviceJob.finished.connect(result);
        //main.favoriteAsked(messageId, isFavorite != "true");
    }
}

