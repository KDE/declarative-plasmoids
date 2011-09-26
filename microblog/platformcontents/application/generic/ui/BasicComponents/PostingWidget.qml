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

import Qt 4.7
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1 as QtExtraComponents

import "plasmapackage:/code/logic.js" as Logic

Item {
    width: 300
    height: 90

    function refresh()
    {
        postTextEdit.text = ""
        postTextEdit.inReplyToStatusId = ""
        Logic.refresh()
        plasmoid.busy = true
    }

    PlasmaCore.FrameSvgItem {
        id: postWidget
        anchors.fill: parent
        imagePath: "widgets/frame"
        prefix: "plain"

        QtExtraComponents.QImageItem {
            id: profileIcon
            smooth: true
            /*anchors.left: postWidget.padding.left
            anchors.top: postWidget.padding.top*/
            width: 64
            height: 64
            image: microblogSource.data["UserImages:"+serviceUrl][userName]
        }
        Text {
            anchors.top: profileIcon.bottom
            text: userName
        }

        PlasmaCore.FrameSvgItem {
            id: sunkenFrame
            anchors {
                left: profileIcon.right
                right: postWidget.right
                top: postWidget.top
                bottom: postWidget.bottom
                rightMargin: postWidget.margins.right
                topMargin: postWidget.margins.top
            }

            imagePath: "widgets/frame"
            prefix: "sunken"
            TextEdit {
                id: postTextEdit
                anchors {
                    fill: parent
                    leftMargin: sunkenFrame.margins.left
                    topMargin: sunkenFrame.margins.top
                    rightMargin: sunkenFrame.margins.right
                    bottomMargin: sunkenFrame.margins.bottom
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
}
