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
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 1.0
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.plasma.core 0.1 as PlasmaExtras
import org.kde.plasma.core 0.1 as PlasmaCore

import "plasmapackage:/ui/BasicComponents"
import "plasmapackage:/ui/ComplexComponents"
import "plasmapackage:/code/bookkeeping.js" as BookKeeping


Image {
    id: mainWidget
    source: "image://appbackgrounds/standard"
    fillMode: Image.Tile
    width: 800
    height: 480
    property Component configComponent: Qt.createComponent("ConfigWidget.qml")

    Column {
        id: mainUi
        anchors.fill: parent

        state: "items"
        onStateChanged: {
            if (state == "items") {
                itemsList.currentIndex = -1
            }
        }

        PlasmaCore.Svg {
            id: shadowSvg
            imagePath: plasmoid.file("images", "shadow.svgz")
        }

        states: [
            State {
                name: "feeds"
                PropertyChanges { target: mainFlickable; contentX: 0 }
                PropertyChanges { target: itemsList; width: mainWindow.width/4*3}
                PropertyChanges { target: toolbarFrame; backEnabled: false }
                PropertyChanges { target: bodyView; visible: false}
            },
            State {
                name: "items"
                PropertyChanges { target: mainFlickable; contentX: 0 }
                PropertyChanges { target: itemsList; width: mainWindow.width/4*3}
                PropertyChanges { target: toolbarFrame; backEnabled: false }
                PropertyChanges { target: bodyView; visible: false}
            },
            State {
                name: "item"
                PropertyChanges { target: mainFlickable; contentX: mainWindow.width/4}
                PropertyChanges { target: itemsList; width: mainWindow.width/4}
                PropertyChanges { target: toolbarFrame; backEnabled: true }
                PropertyChanges { target: bodyView; visible: true}
            }
        ]

        //FIXME: hardcoded
        spacing: -toolbarFrame.margins.bottom/2
        TabletToolbar {
            id: toolbarFrame
            imagePath: "widgets/toolbar"
            enabledBorders: "BottomBorder"
            z: mainView.z+1
            onOpenOriginalRequested: bodyView.url = Url(bodyView.articleUrl)
            onBackRequested: bodyView.html = bodyView.articleHtml
        }

        Flickable {
            id: mainFlickable
            interactive: mainUi.state == "item"
            contentWidth: mainView.width
            contentHeight: mainView.height
            width: mainWindow.width/4
            height: mainWindow.height - toolbarFrame.height +9

            Behavior on contentX {
                NumberAnimation {duration: 250; easing.type: Easing.InOutQuad}
            }

            onMovementEnded: {
                if (contentX < mainWindow.width/8) {
                    mainUi.state = "items"
                } else {
                    contentX = mainWindow.width/4
                }
            }

            Row {
                id: mainView
                //width: mainWindow.width
                height: mainFlickable.height

                Image {
                    source: "image://appbackgrounds/contextarea"
                    fillMode: Image.Tile
                    anchors.top: mainView.top
                    anchors.bottom: mainView.bottom
                    width: mainWindow.width/4

                    FeedList {
                        id: feedList
                        anchors.fill:parent

                        PlasmaCore.SvgItem {
                            width: feedList.width
                            height: 32
                            svg: shadowSvg
                            elementId: "bottom"
                        }
                        PlasmaCore.SvgItem {
                            width: 32
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            svg: shadowSvg
                            elementId: "left"
                        }
                    }
                }

                ItemsList {
                    id: itemsList
                    anchors.top: mainView.top
                    anchors.bottom: mainView.bottom
                    width: mainWindow.width/4*3

                    feedCategory: feedList.feedCategory
                    onItemClicked: mainUi.state = "item"
                    Behavior on width {
                        NumberAnimation {duration: 250; easing.type: Easing.InOutQuad}
                    }

                }

                Rectangle {
                    color: "white"
                    width: mainWindow.width/4*3
                    height: parent.height
                    ArticleView {
                        id : bodyView
                        anchors.fill: parent

                        PlasmaCore.SvgItem {
                            width: 32
                            height: bodyView.height
                            svg: shadowSvg
                            elementId: "right"
                        }
                    }
                }
            }
        }
    }
}
