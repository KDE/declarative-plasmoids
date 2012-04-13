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
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras
import org.kde.qtextracomponents 0.1 as QtExtraComponents

import "plasmapackage:/ui/ComplexComponents"

PlasmaComponents.Page {
    id: messageDetails

    property string messageId
    property string user
    property string source
    property string dateTime
    property bool isFavorite
    property string message

    QtExtraComponents.QImageItem {
        id: userIcon
        smooth: true
        x: 24; y: 24;
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.top: parent.top
        anchors.topMargin: 24
        anchors.rightMargin: 12
        width: 96
        height: 96
        image: {
            var sourceName = "UserImages:"+serviceUrl;
            if (typeof(imageSource.data[sourceName]) != "undefined" &&
                typeof(imageSource.data[sourceName][user]) != "undefined") {
                return imageSource.data[sourceName][user];
            } else {
                return microblogSource.data["Defaults"]["UserImage"];
            }
        }

    }
    PlasmaExtras.Heading {
        id: infoLabel
        level: 3
        //anchors.bottomMargin: 5
        anchors.left: userIcon.right
        anchors.leftMargin: 12
        anchors.right: parent.right
        anchors.top: userIcon.top
        text: user
    }

    PlasmaExtras.Heading {
        id: bodyText
        level: 2
        anchors.rightMargin: 12
        anchors.left: userIcon.left
        anchors.right: parent.right
        anchors.top: userIcon.bottom
        anchors.topMargin: 20
        anchors.bottomMargin: 5
        text: {
            findUrls(message);
            return formatMessage(message);
        }
        wrapMode: Text.WordWrap
        onLinkActivated: {
            handleLinkClicked("internal://showuser/PlasmaActive/foobar");
            handleLinkClicked(link);
        }
    }
    PlasmaComponents.Label {
        id: dateTimeLabel
        text: i18n("%1 from %2", friendlyDate(dateTime), source)
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignRight
        height: 20
        opacity: 0.6
        anchors { top: bodyText.bottom; right: bodyText.right; left: bodyText.left; topMargin: 12; }
    }
    Row {
        id: toolBoxRow
        opacity: 0.8
        anchors.left: userIcon.right
        anchors.leftMargin: 12
        anchors.bottom: userIcon.bottom
//         anchors.horizontalCenter: parent.horizontalCenter
//         anchors.top: dateTimeLabel.bottom
        ServiceJobButton {
            id: favoriteButton
            param: messageId
            checked: isFavorite
//             text: "♥"
//             font.pointSize: 24
//             width: 48
//             height: 48
//             checked: isFavorite
//             onClicked: {
//                 main.favoriteAsked(messageId, isFavorite != "true");
//             }
        }
        PlasmaComponents.ToolButton {
            id: replyButton
            text: "@"
            font.pointSize: 24
            width: 48
            height: 48
            onClicked: {
                main.replyAsked(messageId, "@" + user + ": ");
            }
        }
        PlasmaComponents.ToolButton {
            id: repeatButton
            text: "♻"
            font.pointSize: 24
            width: 48
            height: 48
            onClicked: {
                print("message ID: " + messageId);
                main.retweetAsked(messageId);
            }
        }
    }
    function findUrls(txt) {
        print( "full text: " + txt);
        var matches = [];
        //var rgx = /\s(ht|f)tp:\/\/([^ \,\;\:\!\)\(\"\'\\f\n\r\t\v])+/g;
        var rgx = /(http:\/\/\S+)/g;
        txt.replace(rgx, function () {
                //matches.push("https://p.twimg.com/Ao2nGdmCQAEW_IZ.jpg");
                matches.push(arguments[0]);
                //print(" URL found: " + arguments[0]);
                for (a in arguments) {
//                    print("A : " + a);
                }
        });
        if (matches.length) {
//             previewImage.url = matches[0].toString();
        }
        return matches;
    }
}