

import QtQuick 1.1
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras
import org.kde.plasma.mobilecomponents 0.1 as MobileComponents
import org.kde.qtextracomponents 0.1 as QtExtraComponents

Item {

    width: 800
    height: _s*2.5+96

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
                onClicked: feedsModel.clear()
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
                    var _i = Math.floor((Math.random()*clrs.length))-1;
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
        id: feedsList
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
            radius: 10
            id: messageList
            color: bgcolor
            property int mouseX: x
            width: _s; height: _s*2.4
            x: {
                if (!ListView.isCurrentItem) {
                    index * dragArea.itemWidth;
                }
            }

            PlasmaExtras.Title {
                rotation: 90
                text: "T: " + label
                anchors.centerIn: parent
            }
            Behavior on x {
                NumberAnimation {
                    id: bouncebehavior
                    easing {
                        type: Easing.OutElastic
                        amplitude: 1.0
                        period: 0.5
                    }
                    duration: 800
                }
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
                    property int itemWidth: (messageList.width+feedsList.spacing)
                    property int positionsMoved: Math.round((positionEnded - positionStarted)/itemWidth);
                    property int newPosition: index + positionsMoved
                    property bool held: false
                    drag.axis: Drag.XAxis

                    //onPressed: PlasmaExtras.PressedAnimation { targetItem: messageList }
                    //onReleased: PlasmaExtras.ReleasedAnimation { targetItem: messageList }

                    onPositionsMovedChanged: {
                        //var _m = Math.floor((positionEnded - positionStarted)/(messageList.width+feedsList.spacing));
                        var _m = Math.round((positionEnded - positionStarted)/itemWidth);
                        //var _m = Math.floor((positionEnded - positionStarted - itemWidth/2)/itemWidth)
                        //print("*********** posEnd - posStart " + (positionEnded - positionStarted));
                        print("itemWidth " + itemWidth + " end: " + positionEnded);
                        print("moved: " + (positionEnded - positionStarted))
                        print(" index offset: " + _m);
                    }

                    onPressed: {
                        feedsList.currentIndex = index;
                        messageList.z = 2,
                        positionStarted = messageList.x;
                        positionEnded = messageList.x;
                        print(" start pos: " + positionStarted + " mouse.x" + mouse.x);
                        dragArea.drag.target = messageList,
                        messageList.opacity = 0.5,
                        feedsList.interactive = false,
                        held = true
                        drag.maximumX = (feedsList.contentWidth - messageList.width + messageList.spacing + feedsList.contentX),
                        drag.minimumX = - messageList.spacing
                        timer.running = true
                    }

                    onNewPositionChanged: {
                        timer.restart();

                    }
                    onPositionChanged: {

//                         print("messageList.x" + positionEnded);
                        positionEnded = messageList.x;
                        messageList.mouseX = mouse.x;
                        //print("moved: " + (positionEnded - positionStarted))
                        //print('posEnd: ' + positionEnded + " " + mouse.x);
                    }
                    onReleased: { 
                        feedsList.currentIndex = -1;
                        messageList.z = 1,
                        messageList.opacity = 1,
                        feedsList.interactive = true,
                        dragArea.drag.target = null,
                        dragArea.held = false
                        timer.running = false
                        timer.restart();

                    }
//                     onReleased: {
//                         print(" - - - - - Released - - - - ");
//                         if (Math.abs(positionsMoved) < 1 && held == true) {
//                             print("not moved");
//                             messageList.x = positionStarted,
//                             messageList.opacity = 1,
//                             feedsList.interactive = true,
//                             dragArea.drag.target = null,
//                             held = false
//                         } else {
//                             if (held == true) {
//                                 print("new position: " + newPosition + "/"+ feedsList.count);
//                                 if (newPosition < 1) {
//                                     print("start of list");
//                                     messageList.z = 1,
//                                     feedsModel.move(index,0,1),
//                                     messageList.opacity = 1,
//                                     feedsList.interactive = true,
//                                     dragArea.drag.target = null,
//                                     held = false
//                                 } else if (newPosition > feedsList.count - 1) {
//                                     print("middel");
//                                     messageList.z = 1,
//                                     feedsModel.move(index,feedsList.count - 1,1),
//                                     messageList.opacity = 1,
//                                     feedsList.interactive = true,
//                                     dragArea.drag.target = null,
//                                     held = false
//                                 } else {
//                                     print("end of list");
//                                     messageList.z = 1,
//                                     feedsModel.move(index,newPosition,1),
//                                     messageList.opacity = 1,
//                                     feedsList.interactive = true,
//                                     dragArea.drag.target = null,
//                                     held = false
//                                 }
//                             }
//                             print(" Item: " + bgcolor + " moved to " + index);
//                         }
                    //}

                    Timer {
                        id: timer
                        interval: 200
                        running: false

                        onTriggered: {
                            print(" - - - - - triggered - - - - " + dragArea.positionsMoved + " new: " + dragArea.newPosition);
                            if (Math.abs(dragArea.positionsMoved) < 1 && dragArea.held == true) {
                                print("not moved");
//                                 messageList.x = dragArea.positionStarted,
//                                 messageList.opacity = 1,
//                                 feedsList.interactive = true,
//                                 dragArea.drag.target = null,
//                                 held = false
                            } else {
                                if (dragArea.held == true) {
                                    print("new position: " + dragArea.newPosition + "/"+ feedsList.count);
                                    if (dragArea.newPosition < 1) {
                                        print("start of list");
                                        feedsModel.move(index,0,1);
//                                         messageList.z = 1,
//                                         messageList.opacity = 1,
//                                         feedsList.interactive = true,
//                                         dragArea.drag.target = null,
//                                         dragArea.held = false
                                    } else if (dragArea.newPosition > feedsList.count - 1) {
                                        print("middel");
//                                         messageList.z = 1,
                                        feedsModel.move(index,feedsList.count - 1,1);
//                                         messageList.opacity = 1,
//                                         feedsList.interactive = true,
//                                         dragArea.drag.target = null,
//                                         dragArea.held = false
                                    } else {
                                        print("end of list");
                                        feedsModel.move(index,dragArea.newPosition,1);
//                                         messageList.z = 1,
//                                         messageList.opacity = 1,
//                                         feedsList.interactive = true,
//                                         dragArea.drag.target = null,
//                                         dragArea.held = false
                                    }
                                }
                                dragArea.positionEnded = messageList.x;
                                // FixmE: upate messagelist.x

                                print(" Item: " + bgcolor + " moved to " + index);
                            }
                        }
                    }
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