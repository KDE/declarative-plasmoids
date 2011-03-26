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
import org.kde.plasma.graphicslayouts 4.7 as GraphicsLayouts

PlasmaWidgets.Frame {
    id: toolbarFrame
    width: parent.width
    maximumSize: maximumSize.width+"x"+minimumSize.height
    frameShadow: "Raised"
    layout: GraphicsLayouts.QGraphicsLinearLayout {
        PlasmaWidgets.PushButton {
            id: backButton
            text: i18n("Back")
            maximumSize: minimumSize
            visible: false

            onClicked: {
                if (!bodyView.customUrl) {
                    mainView.currentIndex = mainView.currentIndex -1
                } else {
                    bodyView.html = "<body style=\"background:#fff;\">"+feedSource.data['items'][list.currentIndex].description+"</body>";
                }
            }
        }
        QGraphicsWidget {
            GraphicsLayouts.QGraphicsLinearLayout.stretchFactor: 2
        }
        PlasmaWidgets.LineEdit {
            id: searchBox
            clearButtonShown: true
            onTextEdited: {
                searchTimer.running = true
            }
        }
    }
}