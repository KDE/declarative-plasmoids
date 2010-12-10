/*
 *   Copyright 2010 Marco Martin <notmart@gmail.com>
 *   Copyright 2010 Lukas Appelhans <l.appelhans@gmx.de>
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
import org.kde.plasma.graphicslayouts 4.7 as GraphicsLayouts

ListItem {
    id: listItem
    property string text;
    property string iconFile;
    property string feedUrl;

    Row {
        id : delegateLayout
        width: entryList.width
        height: 50
        spacing: 5
        anchors.left: listItem.padding.left
        anchors.right: listItem.padding.right
        anchors.top: listItem.padding.top

        Image {
            id: image
            source: iconFile
            height: parent.height
            width: parent.height / 2
            anchors.horizontalCenter: width / 2
            anchors.verticalCenter: height / 2
            fillMode: Image.PreserveAspectFit
            smooth:true
            opacity: 0.8
        }
        Text {
            id: title
            clip:true
            width: delegateLayout.width - rightArrow.width - image.width - parent.spacing * 2
            height: delegateLayout.height
            color: theme.textColor
            textFormat: Text.RichText
            text: listItem.text
            wrapMode: Text.Wrap
        }
        /*Text {
            color: theme.textColor
            width: delegateLayout.width
            horizontalAlignment: Text.AlignRight
            text: '<em><small>'+listItem.date+'</em></small>&nbsp;'
        }*/
        Column {
            id: column
            spacing: 5
            PlasmaCore.SvgItem {
                id: leftArrow
                width: 20
                height: 20
                elementId: "left"
                opacity: 0
                           
                Behavior on opacity { PropertyAnimation {} }
                svg: PlasmaCore.Svg {
                    imagePath: "rssnow/left"
                }
            }
            PlasmaCore.SvgItem {
                id: rightArrow
                width: 20
                height: 20
                elementId: "right"
                opacity: 0
                           
                Behavior on opacity { PropertyAnimation {} }
                svg: PlasmaCore.Svg {
                    imagePath: "rssnow/right"
                }
            }
        }
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            if (mouse.x < delegateLayout.width && mouse.x > (delegateLayout.width - leftArrow.width)) {
                if (mouse.y > leftArrow.height) {
                    if (entryList.currentIndex == (entryList.count - 1))
                        entryList.currentIndex = 0
                    else 
                        entryList.currentIndex = entryList.currentIndex + 1
                } else
                    if (entryList.currentIndex == 0)
                        entryList.currentIndex = (entryList.count - 1)
                    else
                        entryList.currentIndex = entryList.currentIndex - 1
            } else {
                plasmoid.openUrl(feedUrl)
            }
        }
        onPositionChanged: {
            if (mouse.x < delegateLayout.width && mouse.x > (delegateLayout.width - leftArrow.width)) {
                if (mouse.y > rightArrow.y && mouse.y < (rightArrow.y + rightArrow.height)) {
                    rightArrow.opacity = 0.2
                    leftArrow.opacity = 1
                } else if (mouse.y > leftArrow.y && mouse.y < (leftArrow.y + leftArrow.height)) {
                    leftArrow.opacity = 0.2
                    rightArrow.opacity = 1
                } else {
                    rightArrow.opacity = 1
                    leftArrow.opacity = 1
                }
            } else {
                rightArrow.opacity = 1
                leftArrow.opacity = 1
            }
        }
        onEntered: {
            rightArrow.opacity = 1
            leftArrow.opacity = 1
        }
        onExited: {
            rightArrow.opacity = 0
            leftArrow.opacity = 0
        }
    }
}


//mapFromItem ( Item item, real x, real y )