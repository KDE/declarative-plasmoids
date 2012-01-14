/*
 *   Copyright 2011 Marco Martin <mart@kde.org>
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

import "plasmapackage:/code/logic.js" as Logic

ListItem {
    height: 100

    function refresh()
    {
        postTextEdit.text = ""
        postTextEdit.inReplyToStatusId = ""
        Logic.refresh()
        plasmoid.busy = true
    }

    PlasmaCore.FrameSvgItem {
        id: postWidget
        anchors.left: parent.left
        anchors.right: parent.right
        imagePath: "widgets/frame"
        prefix: "plain"

        QtExtraComponents.QImageItem {
            id: profileIcon
            smooth: true
            anchors {
                left: postWidget.left
                top: postWidget.top
                leftMargin: postWidget.margins.left
                topMargin: postWidget.margins.top
            }
            width: 48
            height: 48
            //image: microblogSource.data["UserImages:"+serviceUrl][userName]
        }
        PlasmaComponents.Label {
            anchors.top: profileIcon.bottom
            text: userName
        }

        PlasmaComponents.TextArea {
            id: postTextEdit
            height: 96
            anchors {
                left: profileIcon.right
                right: postWidget.right
                //verticalCenter: parent.verticalCenter
                //top: parent.top
                //bottom: parent.bottom
                rightMargin: postWidget.margins.right
                //topMargin: postWidget.margins.top
            }
            wrapMode: TextEdit.WordWrap
            property string inReplyToStatusId: ""

            onTextChanged: {
                //yes, TextEdit doesn't have returnPressed sadly
                if (text[text.length-1] == "\n") {
                    Logic.update(text, inReplyToStatusId);
                    refresh()
                } else if (text.length == 0) {
                    inReplyToStatusId = ""
                }
            }
            Connections {
                target: main
                onReplyAsked: {
                    postTextEdit.inReplyToStatusId = id
                    postTextEdit.text = message
                }
                onRetweetAsked: {
                    Logic.retweet(id)
                    refresh()
                }
                onFavoriteAsked: {
                    print(id)
                    print(isFavorite)
                    Logic.setFavorite(id, isFavorite)
                    refresh()
                }
            }
        }
    }
}
