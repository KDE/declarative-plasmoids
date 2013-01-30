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
//import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.plasma.core 0.1 as PlasmaExtras
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.mobilecomponents 0.1 as MobileComponents

import "plasmapackage:/ui/BasicComponents"
import "plasmapackage:/ui/ComplexComponents"
import "plasmapackage:/code/bookkeeping.js" as BookKeeping


Image {
    id: mainWindow
    source: isApplet ? "" : "image://appbackgrounds/contextarea"
    fillMode: Image.Tile
    width: 800
    height: 480
    property bool browserMode: false
    property Component configComponent: Qt.createComponent("ConfigWidget.qml")

    property bool isApplet: mainWindow.width < theme.defaultFont.mSize.width * 60
    Column {
        id: mainUi
        anchors.fill: parent

        state: "items"
        onStateChanged: {
            if (state == "items") {
                itemsList.currentIndex = -1
            }
        }


        states: [
            State {
                name: "feeds"
                PropertyChanges { target: mainFlickable; contentX: 0 }
                PropertyChanges { target: itemsArea; width: isApplet ? mainWindow.width : mainWindow.width/4*3}
                PropertyChanges { target: toolbarFrame; backEnabled: false }
                PropertyChanges { target: bodyView; visible: false}
            },
            State {
                name: "items"
                PropertyChanges { target: mainFlickable; contentX: isApplet ? mainWindow.width : 0 }
                PropertyChanges { target: itemsArea; width: isApplet ? mainWindow.width : mainWindow.width/4*3}
                PropertyChanges { target: toolbarFrame; backEnabled: isApplet }
                PropertyChanges { target: bodyView; visible: false}
            },
            State {
                name: "item"
                PropertyChanges { target: mainFlickable; contentX: isApplet ? mainWindow.width*2 : mainWindow.width/4*3}
                PropertyChanges { target: itemsArea; width: isApplet ? mainWindow.width : mainWindow.width/4}
                PropertyChanges { target: toolbarFrame; backEnabled: true }
                PropertyChanges { target: bodyView; visible: true}
            }
        ]

        //FIXME: hardcoded
        spacing: -toolbarFrame.margins.bottom/2
        TabletToolbar {
            id: toolbarFrame

            z: mainView.z+1
            onOpenOriginalRequested: bodyView.url = Url(bodyView.articleUrl)
            onBackRequested: {
                if (mainWindow.browserMode) {
                    bodyView.back();
                } else {
                    bodyView.html = bodyView.articleHtml
                }
            }
        }

        Flickable {
            id: mainFlickable
            clip: true
            interactive: mainUi.state == "item"
            contentWidth: mainView.width
            contentHeight: mainView.height
            anchors {
                left: parent.left
                right: parent.right
                top: toolbarFrame.bottom
                bottom: parent.bottom
                topMargin: -9
            }

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

                    FeedList {
                        id: feedList
                        clip: false
                        anchors {
                            top: mainView.top
                            bottom: mainView.bottom
                        }
                        width: isApplet ? mainWindow.width : mainWindow.width/4
                        onItemClicked: mainUi.state = "items"

                        Image {
                            width: feedList.width
                            height: 16
                            opacity: 0.5
                            source: "image://appbackgrounds/shadow-bottom"
                        }
                        Image {
                            width: 16
                            opacity: 0.5
                            anchors {
                                top: parent.top
                                right: parent.right
                                bottom: parent.bottom
                            }
                            source: "image://appbackgrounds/shadow-left"
                        }
                        Image {
                            width: 16
                            opacity: 0.5
                            anchors {
                                top: parent.top
                                right: parent.left
                                bottom: parent.bottom
                            }
                            source: "image://appbackgrounds/shadow-left"
                        }
                        PlasmaComponents.ToolButton {
                            id: configButton
                            iconSource: "format-list-unordered"
                            height: 32
                            width: height
//                             iconSize: 22
//                             svg: PlasmaCore.Svg {
//                                 imagePath: "widgets/configuration-icons"
//                             }
//                             elementId: "configure"
                            anchors {
                                bottom: feedList.bottom
                                horizontalCenter: parent.horizontalCenter
                                bottomMargin: 8
                            }
                            onClicked: {
                                var object = configComponent.createObject(mainWindow);
                                print(component.errorString())
                            }
                        }

                    }

                

                Image {
                    id: itemsArea
                    source: isApplet ? "" : "image://appbackgrounds/standard"
                    fillMode: Image.Tile
                    anchors {
                        top: mainView.top
                        bottom: mainView.bottom
                    }
                    width: isApplet ? mainWindow.width : mainWindow.width/4*3
                    Behavior on width {
                        NumberAnimation {duration: 250; easing.type: Easing.InOutQuad}
                    }

                    ItemsList {
                        id: itemsList
                        anchors.fill: parent

                        feedCategory: feedList.feedCategory
                        onItemClicked: mainUi.state = "item"
                    }
                }

                Rectangle {
                    color: "white"
                    width: isApplet ? mainWindow.width : mainWindow.width/4*3
                    height: parent.height
                    ArticleView {
                        id : bodyView
                        anchors.fill: parent
                        anchors.leftMargin: mainWindow.browserMode ? 4 : 16

                        Behavior on anchors.leftMargin {
                            NumberAnimation {duration: 100; easing.type: Easing.InOutQuad}
                        }

                    }
                    Image {
                        width: 16
                        opacity: 0.5
                        height: bodyView.height
                        source: "image://appbackgrounds/shadow-right"
                    }
                }
            }
        }
    }
    Connections {
        target: mainWindow
        onBrowserModeChanged: {
            if (mainWindow.browserMode) {
                bodyView.url = Url(bodyView.articleUrl);
            } else {
                bodyView.html = bodyView.articleHtml;
            }
        }
    }

}
