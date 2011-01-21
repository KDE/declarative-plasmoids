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
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import Qt 4.7
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1 as QtExtraComponents

Item {
    width: entryList.width
    height: postWidget.height + 5
    PlasmaComponents.Frame {
        id: postWidget
        anchors.left: parent.left
        anchors.right: parent.right

        QtExtraComponents.QImageItem {
            id: profileIcon
            smooth: true
            anchors.left: padding.left
            anchors.top: padding.top
            width: 48
            height: 48
            image: imagesDataSource.data["UserImages:"+serviceUrl][userName]
        }
        Text {
            anchors.top: profileIcon.bottom
            text: userName
        }

        PlasmaComponents.Frame {
            anchors.left: profileIcon.right
            anchors.right: postWidget.padding.right
            anchors.top: postWidget.padding.top
            height: 90

            prefix: "sunken"
            TextEdit {
                id: postTextEdit
                anchors.fill: parent.padding
                wrapMode: TextEdit.WordWrap
                property string inReplyToStatusId: ""

                onTextChanged: {
                    //yes, TextEdit doesn't have returnPressed sadly
                    if (text[text.length-1] == "\n") {
                        var service = messagesDataSource.serviceForSource(messagesDataSource.connectedSources[0])
                        var operation = service.operationDescription("update");
                        operation.password = password
                        operation.status = text;
                        operation.inReplyToStatusId = inReplyToStatusId
                        print(inReplyToStatusId)
                        service.startOperationCall(operation);
                        text = ""
                        inReplyToStatusId = ""

                        operation = service.operationDescription("refresh");
                        service.startOperationCall(operation);
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
                        postTextEdit.text = message
                    }
                }
            }
        }
    }
}
