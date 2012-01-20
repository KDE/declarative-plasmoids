 
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
import org.kde.qtextracomponents 0.1 as QtExtraComponents

Item {
    id: avatar
    property int borderwidth: 2
    width: 48
    height: 48

    Rectangle {
        width: avatar.width + (avatar.borderwidth)
        height: avatar.height + (avatar.borderwidth)
        anchors.centerIn: userIcon
        //x: parent.x+1
        //y: parent.y+1
        //anchors.left: parent.left+1
        radius: 2
        clip: true
        anchors.margins: 0
        border.color: theme.textColor
        border.width: avatar.borderwidth
        opacity: 0.1
    }

    QtExtraComponents.QImageItem {
        id: userIcon
        //anchors.centerIn: parent
        smooth: true
        anchors.fill: parent

        image: {
            var sourceName = "UserImages:"+serviceUrl;
            var d = imageSource.data[sourceName];
            if (typeof(d) != "undefined" &&
                typeof(d[user]) != "undefined") {
                return d[user];
            } else {
                return microblogSource.data["Defaults"]["UserImage"];
            }
        }
    }
}