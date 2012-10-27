/*
 *   Copyright 2011 Marco Martin <mart@kde.org>
 *   Copyright 2012 Sebastian Kügler <sebas@kde.org>
 *   Copyright 2012 Martin Klapetek <mklapetek@kde.org>
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
import org.kde.qtextracomponents 0.1 as QtExtraComponents

PlasmaComponents.ListItem {
    id: messageWidget
    width: entryList.width-scrollBar.width-4

    enabled: true

    property bool isFavorite: model.statusLike
    property int akonadiId: model.akonadiId
    property string dateTime: model.statusTime
    property string info: model.statusInfo
    property string messageId: model.statusId
    property string message: model.statusMessage
    property string realName: model.screenName
    property string source: model.networkString
    property string user: model.screenName
    property variant avatar: model.avatar
    property variant replies: model.statusReplies

    state: "list"

    states: [
        State {
            name: "list"
        },
        State {
            name: "detail"
        }
    ]

    Avatar {
        id: userIcon
        y: 12
        anchors.left: parent.left
        anchors.leftMargin: 12
        image: avatar
    }

    PlasmaComponents.Label {
        id: timeLabel
        anchors.right: itemColumn.right
        anchors.top: itemColumn.top
        anchors.rightMargin: 12
        opacity: 0.3
        font.pointSize: theme.smallestFont.pointSize
        styleColor: theme.backgroundColor
        text: dateTime
    }

    Column {
        id: itemColumn
        anchors.top: userIcon.top
        anchors.left: userIcon.right
        anchors.right: parent.right
        anchors.leftMargin: 12
        spacing: 4

        PlasmaComponents.Label {
            id: fromLabel
            opacity: 0.6
            style: Text.Sunken
            elide: Text.ElideRight
            font.pointSize: theme.defaultFont.pointSize + 2
            styleColor: theme.backgroundColor
            text: realName + " " + source + ":"
            MouseArea {
                anchors.fill: parent
                onClicked: showUserInfo(user);

            }

        }

        PlasmaComponents.Label {
            id: bodyText
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottomMargin: 6
            text: formatMessage(message)
            wrapMode: Text.Wrap
            onLinkActivated: handleLinkClicked(link)
            visible: text.length > 0
        }

        Item {
            id: linkRect
            height: statusImageItem.height > statusLinkTitleText.height ? statusImageItem.height : statusLinkTitleText.height
            width: 240
            visible: statusImageItem.null ? false : true

            QtExtraComponents.QImageItem
            {
                id: statusImageItem
                width: nativeWidth > 100 ? 100 : nativeWidth
                height: nativeWidth > 100 ? (nativeHeight / nativeWidth) * 100 : nativeHeight

                image: model.statusImage
            }

            PlasmaComponents.Label {
                id: statusLinkTitleText
                anchors {
    //                 topMargin: 8
                    leftMargin: 4
                    rightMargin: 4
                    top: linkRect.top
                    left: statusImageItem.right
                    right: linkRect.right
                }
                font.bold: true
                text: model.statusLinkTitle.length == 0 ? "" : "<a href=\"" + model.statusLink + "\">" + model.statusLinkTitle + "</a>"
                wrapMode: Text.Wrap
                visible: text.length > 0
            }
            PlasmaComponents.Label {
                id: statusLink
                anchors {
                    top: statusLinkTitleText.bottom
                    left: statusImageItem.right
                    right: linkRect.right
                    bottom: linkRect.bottom
                }
                text: "<a href=\"" + model.statusLink + "\">" + model.statusLink + "</a>"
                wrapMode: Text.Wrap
                visible: statusImageItem.null
            }
        }

        PlasmaComponents.Label {
            id: infoLabel
            opacity: 0.3
            font.pointSize: theme.smallestFont.pointSize
            styleColor: theme.backgroundColor
            text: info
            visible: infoLabel.text.length > 0
        }

        Row {
            id: toolBoxRow
            opacity: 0.8
    //         visible: false
            height: 24

            PlasmaComponents.ToolButton {
                id: favoriteButton
                checked: isFavorite
                text: "♥"
                font.pointSize: 12
                width: 24
                height: 24
                onClicked: {
                    print("Like...");
                    socialFeed.onLikePost(akonadiId, messageId, isFavorite != "true");
                }

                anchors.verticalCenter: parent.verticalCenter
            }
            PlasmaComponents.ToolButton {
                id: replyButton
                text: "@"
                font.pointSize: 12
                width: 24
                height: 24
                onClicked: {
                    print("MessageDetails.reply(" + messageId + ", " + "@"+user+": " + ")");
                    main.replyAsked(messageId, "@" + user + ": ");
                    showPostingWidget();
                }

                anchors.verticalCenter: parent.verticalCenter
            }
            PlasmaComponents.ToolButton {
                id: repeatButton
                text: "♻"
                font.pointSize: 12
                width: 24
                height: 24
                onClicked: {
                    print("message ID: " + messageId);
                    main.retweetAsked(messageId);
                }

                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ListView {
            id: repliesList
            height: 200
            clip: true
            width: parent.width
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 12
            anchors.rightMargin: 12
            anchors.bottomMargin: 12
            visible: messageWidget.state == "detail" && repliesList.count > 0

            model: replies
            delegate {
                PlasmaComponents.ListItem {
                    id: commentsList
                    //height: childrenRect.height
                    width: repliesList.width

                    Image {
                        id: commentAvatar
                        //FIXME: only facebook now has support for replies, but once microblog/whatever else will have, this will
                        //       need to be done properly
                        source: "https://graph.facebook.com/" + model.modelData.userId + "/picture?type=square"
                        asynchronous: true
                        cache: true
                        width: 32
                        height: 32
                    }

                    Column {
                        anchors.left: commentAvatar.right
                        anchors.top: commentAvatar.top
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right

                        anchors.leftMargin: 12
                        anchors.bottomMargin: 100

                        width: parent.width

                        PlasmaComponents.Label {
                            id: replyUsernamLabel
                            text: model.modelData.userName
                            font.pointSize: theme.defaultFont.pointSize + 2
                        }
                        PlasmaComponents.Label {
                            text: model.modelData.replyText
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }
        }
    }

    //spacer
    Item { height: 12; anchors.top: itemColumn.bottom; z: -1 }
}
