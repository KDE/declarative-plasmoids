

import QtQuick 1.1
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras
import org.kde.plasma.mobilecomponents 0.1 as MobileComponents
import org.kde.qtextracomponents 0.1 as QtExtraComponents

Item {

    width: 800
    height: 400

    property int _s: 180

    PlasmaExtras.Title {
        id: pageTitle
        text: "Drag & Drop Model Test"
    }
    
    Row {
        id: iconRow
        spacing: 8
        anchors { top: pageTitle.bottom; right: parent.right; }
        QtExtraComponents.QIconItem {
            id: iconItemRemove
            width: 48
            height: 48
            icon: QIcon("list-remove")
            MouseArea {
                anchors.fill: parent
                onClicked: { if (feedsModel.count > 0) feedsModel.remove(feedsModel.count-1) }
            }
        }

        QtExtraComponents.QIconItem {
            id: iconItemAdd
            width: 48
            height: 48
            icon: QIcon("list-add")
            MouseArea {
                anchors.fill: parent
                onClicked:  {
                    var clrs = ["green", "blue", "orange", "red", "yellow", "blue", "grey", "cyan", "magenta", "#000"];
                    var _i = Math.floor((Math.random()*clrs.length)+1);
                    print(" ++ " + _i + " colors: " + clrs.length + " => " + clrs[_i]);
                    var c =
                    feedsModel.append({
                        "label": "New Item",
                        "sourceName":"Newitem:PlasmaActive@https://api.twitter.com/1/",
                        bgcolor: clrs[_i]
                    })
                }
            }
        }
    }

    ListView {
        width: parent.width
        anchors.top: iconRow.bottom
        height: parent.height-y
        spacing: 8
        orientation: Qt.Horizontal
        model: feedsModel
        delegate: messageListDelegate
    }

    Component {
        id: messageListDelegate
        Rectangle {
            id: messageList
            color: bgcolor
            //opacity: 0.3;
            width: _s; height: _s*2.4
            PlasmaExtras.Title {
                rotation: 90
                text: "T: " + label
                anchors.centerIn: parent
            }

            QtExtraComponents.QIconItem {
                id: removeButton
                anchors { top: parent.top; right: parent.right; }
                width: 48
                height: 48
                icon: QIcon("list-remove")
                MouseArea {
                    anchors.fill: parent
                    onClicked: feedsModel.remove(index)
                }

            }
            QtExtraComponents.QIconItem {
                id: dragHandle
                anchors { top: parent.top; right: removeButton.left; rightMargin: 20; }
                width: 48
                height: 48
                icon: QIcon("transform-move")

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    property int positionStarted: 0
                    property int positionEnded: 0
                    //property int positionsMoved: Math.floor((positionEnded - positionStarted)/starwarsNumberText.height)
                    //property int newPosition: index + positionsMoved
                    property bool held: false
                    drag.axis: Drag.YAxis
//                     onPressAndHold: {
//                         starwarsDelegateBorder.z = 2,
//                         positionStarted = starwarsDelegateBorder.y,
//                         dragArea.drag.target = starwarsDelegateBorder,
//                         starwarsDelegateBorder.opacity = 0.5,
//                         starwarsList.interactive = false,
//                         held = true
//                         drag.maximumY = (wholeBody.height - starwarsNumberText.height - 1 + starwarsList.contentY),
//                         drag.minimumY = 0
//                     }
//                     onPositionChanged: {
//                         positionEnded = starwarsDelegateBorder.y;
//                     }
// 
//                     onReleased: {
//                         if (Math.abs(positionsMoved) < 1 && held == true) {
//                             starwarsDelegateBorder.y = positionStarted,
//                             starwarsDelegateBorder.opacity = 1,
//                             starwarsList.interactive = true,
//                             dragArea.drag.target = null,
//                             held = false
//                         } else {
//                             if (held == true) {
//                                 if (newPosition < 1) {
//                                     starwarsDelegateBorder.z = 1,
//                                     starwarsModel.move(index,0,1),
//                                     starwarsDelegateBorder.opacity = 1,
//                                     starwarsList.interactive = true,
//                                     dragArea.drag.target = null,
//                                     held = false
//                                 } else if (newPosition > starwarsList.count - 1) {
//                                     starwarsDelegateBorder.z = 1,
//                                     starwarsModel.move(index,starwarsList.count - 1,1),
//                                     starwarsDelegateBorder.opacity = 1,
//                                     starwarsList.interactive = true,
//                                     dragArea.drag.target = null,
//                                     held = false
//                                 }
//                                 else {
//                                     starwarsDelegateBorder.z = 1,
//                                     starwarsModel.move(index,newPosition,1),
//                                     starwarsDelegateBorder.opacity = 1,
//                                     starwarsList.interactive = true,
//                                     dragArea.drag.target = null,
//                                     held = false
//                                 }
//                             }
//                         }
//                     }
                }
            }

        }
    }

    ListModel {
        id: feedsModel
        ListElement {
            label: "Timeline"
            sourceName: "Timeline:PlasmaActive@https://api.twitter.com/1/" // made up.
            bgcolor: "green"
        }
        ListElement {
            label: "Friends"
            sourceName: "Friends:PlasmaActive@https://api.twitter.com/1/" // made up.
            bgcolor: "blue"
        }
        ListElement {
            label: "Replies"
            sourceName: "Replies:PlasmaActive@https://api.twitter.com/1/" // made up.
            bgcolor: "yellow"
        }
        ListElement {
            label: "Search"
            sourceName: "Search:PlasmaActive@https://api.twitter.com/1/" // made up.
            bgcolor: "red"
        }
    }
    
    
}