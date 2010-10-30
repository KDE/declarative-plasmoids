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
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.plasma.graphicslayouts 4.7 as GraphicsLayouts

Item {
    id: mainWidget
    width: 200
    height: 300

    property string query: ""
    property int page: 0

    Component.onCompleted: {
        plasmoid.busy = true
    }

    PlasmaWidgets.LineEdit {
        id: searchBox
        width: mainWidget.width
        clearButtonShown: true
        onTextEdited: {
            timer.running = true
        }
    }


    PlasmaWidgets.Frame {
          id: statusBar
          width: mainWidget.width
          frameShadow: "Raised"
          anchors.bottom: mainWidget.bottom
          layout: GraphicsLayouts.QGraphicsLinearLayout {
              PlasmaWidgets.ToolButton {
                text: "<"
                enabled: page>0
                onClicked: {
                      plasmoid.busy = true
                      --page
                }
              }
              QGraphicsWidget{}
              PlasmaWidgets.Label {
                  id: statusMessage
                  text: if (kbSource.data["itemsperpage"]) i18n("Page %1 of %2", page+1, Math.ceil(kbSource.data["totalitems"]/kbSource.data["itemsperpage"]))
              }
              QGraphicsWidget{}
              PlasmaWidgets.ToolButton {
                text: ">"
                enabled: page+1 < (kbSource.data["totalitems"]/kbSource.data["itemsperpage"])
                onClicked: {
                      plasmoid.busy = true
                      ++page
                }
              }
          }
    }

    Timer {
       id: timer
       running: false
       repeat: false
       interval: 500
       onTriggered: {
            plasmoid.busy = true
            page = 0
            query = searchBox.text
       }
    }

    PlasmaCore.DataSource {
        id: kbSource
        engine: "ocs"
        source: "KnowledgeBaseList\\provider:https://api.opendesktop.org/v1/\\query:"+query+"\\sortMode:new\\page:"+page+"\\pageSize:20"
        interval: 120000
        onDataChanged: {
            plasmoid.busy = false
        }
    }

    ListView {
        id: list
        anchors.left: parent.left
        anchors.top: searchBox.bottom
        anchors.right:parent.right
        anchors.bottom: statusBar.top
        spacing: 5
        snapMode: ListView.SnapToItem
        clip:true


        model: PlasmaCore.DataModel {
            dataSource: kbSource
            key: "KnowledgeBase-[\\d]*"
        }

        delegate: PlasmaCore.FrameSvgItem {
          id: delegateItem
          imagePath: "widgets/frame"
          prefix: "plain"
          width: list.width
          height: childrenRect.height

          Column {
              id: delegateLayout
              Text {
                  id: title
                  text: Name
                  width: delegateItem.width
              }
              Text {
                  id: cat
                  text: "<em>Category: "+category+"</em>"
                  width: delegateItem.width
              }
              Column {
                  id: detailsLayout
                  opacity: 0
                  height: 0
                  state: "collapsed"
                  Text {
                      id: description
                      width: delegateItem.width
                      wrapMode: Text.Wrap
                      text: "<b>Question:</b> "+Description
                  }
                  Text {
                      id: answer
                      width: delegateItem.width
                      wrapMode: Text.Wrap
                      text: "<b>Answer:</b> "+Answer
                  }
                  states: [
                      State {
                          name: "collapsed"
                          PropertyChanges {
                              target: detailsLayout
                              opacity: 0
                              height: 0
                          }
                      },
                      State {
                          name: "expanded"
                          PropertyChanges {
                              target: detailsLayout
                              opacity: 1
                              height: detailsLayout.childrenRect.height
                          }
                      }
                  ]

                  transitions: Transition {
                      PropertyAnimation { properties: "opacity, height"; duration: 250 }
                  }
              }
          }
          MouseArea {
              anchors.fill: delegateLayout
              onClicked: {
                  print(detailsLayout.state)
                  if (detailsLayout.state == "collapsed") {
                      detailsLayout.state = "expanded"
                  } else {
                      detailsLayout.state = "collapsed"
                  }
              }
          }
        }
    }
}