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
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import Qt 4.7
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.plasma.core 0.1 as PlasmaCore

import "plasmapackage:/ui/BasicComponents"
import "plasmapackage:/ui/ComplexComponents"
import "plasmapackage:/code/bookkeeping.js" as BookKeeping

Column {
    id: mainUi

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
    spacing: -9
    Toolbar {
        id: toolbarFrame
        imagePath: "widgets/background"
        prefix: ""
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

            FeedList {
                id: feedList
                anchors.top: mainView.top
                anchors.bottom: mainView.bottom
                width: mainWindow.width/4

                PlasmaCore.SvgItem {
                    width: 32
                    height: feedList.height
                    svg: shadowSvg
                    elementId: "right"
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

                PlasmaCore.SvgItem {
                    width: 32
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    svg: shadowSvg
                    elementId: "right"
                }
            }

            ArticleView {
                id : bodyView
                width: mainWindow.width/4*3
                height: parent.height

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
