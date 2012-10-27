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

import "plasmapackage:/ui/BasicComponents"
import "plasmapackage:/ui/ComplexComponents"

PlasmaComponents.Page {
    id: messageDetails

    property string messageId
    property string user
    property string realName
    property int retweetCount
    property string source
    property string dateTime
    property string info
    property bool isFavorite
    property variant replies
    property string message
    property int akonadiId
    property variant avatar

    Avatar {
        id: userIcon
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 24
        anchors.rightMargin: 12
        anchors.leftMargin: 12
        image: avatar

        width: 96
        height: 96
    }

    PlasmaExtras.Heading {
        id: nameLabel
        level: 3
        //anchors.bottomMargin: 5
        anchors.left: userIcon.right
        anchors.leftMargin: 12
        anchors.right: dateTimeLabel.left
        anchors.top: userIcon.top
        text: realName + " " + source + ":"
    }

    PlasmaExtras.Heading {
        id: bodyText
        level: 4
        anchors.left: userIcon.right
        anchors.right: parent.right
        anchors.top: nameLabel.bottom
//         anchors.topMargin: 20
        anchors.bottomMargin: 5
        anchors.leftMargin: 12
        anchors.rightMargin: 12

        text: {
            findUrls(message);
            return formatMessage(message);
        }
        wrapMode: Text.Wrap
        onLinkActivated: {
            handleLinkClicked("internal://showuser/PlasmaActive/foobar");
            handleLinkClicked(link);
        }
    }
    PlasmaComponents.Label {
        id: dateTimeLabel
        text: dateTime
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignRight
        height: 20
        opacity: 0.6
        anchors.top: userIcon.top;
        anchors.right: parent.right;
//         anchors.left: nameLabel.right;
//         anchors.topMargin: 12;
    }
    PlasmaComponents.Label {
        id: postInfoLabel
        text: info
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignLeft
        opacity: 0.6
        anchors.top: bodyText.bottom;
        anchors.right: bodyText.right;
        anchors.left: userIcon.right;
        anchors.topMargin: 12;
        anchors.leftMargin: 12;
    }
    Row {
        id: toolBoxRow
        opacity: 0.8
        anchors.left: userIcon.right
        anchors.leftMargin: 12
        //anchors.bottom: userIcon.bottom
        anchors.top: postInfoLabel.bottom
//         anchors.horizontalCenter: parent.horizontalCenter
//         anchors.top: dateTimeLabel.bottom
        PlasmaComponents.ToolButton {
            id: favoriteButton
            checked: isFavorite
            text: "♥"
            font.pointSize: 24
            width: 48
            height: 48
            onClicked: {
                print("Like...");
                socialFeed.onLikePost(akonadiId, messageId, isFavorite != "true");
                //main.favoriteAsked(akonadiId, isFavorite != "true");
            }
        }
        PlasmaComponents.ToolButton {
            id: replyButton
            text: "@"
            font.pointSize: 24
            width: 48
            height: 48
            onClicked: {
                print("MessageDetails.reply(" + messageId + ", " + "@"+user+": " + ")");
                main.replyAsked(messageId, "@" + user + ": ");
                showPostingWidget();
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

    ListView {
        id: repliesList
        anchors.top: postInfoLabel.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 12
        anchors.leftMargin: 12

        model: replies
        delegate {
            ListItem {
                height: childrenRect.height
                width: parent.width
                Rectangle {
                    id: commentAvatar
                    width: 32
                    height: 32
                    border.color: "black"
                    anchors.leftMargin: 12
                    anchors.topMargin: 12
                }
                PlasmaComponents.Label {
                    id: replyUsernamLabel
                    text: model.modelData.userName
                    //height: 20
                    anchors.left: commentAvatar.right
                    anchors.leftMargin: 12
//                     anchors.top: parent.top
                    anchors.right: parent.right
                    font.pointSize: theme.defaultFont.pointSize + 2
                }
                PlasmaComponents.Label {
                    text: model.modelData.replyText
                    wrapMode: Text.WordWrap
                    //height: 20
                    //width: 50
                    anchors.left: commentAvatar.right
                    anchors.top: replyUsernamLabel.bottom
                    anchors.right: parent.right
                    anchors.leftMargin: 12
                }
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