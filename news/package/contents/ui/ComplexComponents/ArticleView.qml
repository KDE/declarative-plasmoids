/*
 *   Copyright 2011 Marco Martin <notmart@gmail.com>
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

import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets

PlasmaWidgets.WebView {
    id : bodyView

    dragToScroll : true
    property string articleUrl
    property string articleHtml
    onArticleHtmlChanged: html = articleHtml
    property bool customUrl: false
    onUrlChanged: {
        customUrl = ((url != "about:blank") && (articleUrl != url))
    }

    onLoadProgress: {
        progressBar.y = parent.height - progressBar.height
        progressBar.value = percent
    }
    onLoadFinished: {
        progressBar.y = parent.height
    }

    PlasmaComponents.ProgressBar {
        id: progressBar
        minimumValue: 0
        maximumValue: 100
        anchors.left: bodyView.left
        anchors.right: bodyView.right
        height: 32

        Behavior on y {
            NumberAnimation {duration: 150; easing.type: Easing.InOutQuad}
        }
    }
}
