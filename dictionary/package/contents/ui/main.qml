/*
*   Copyright (C) 2012 Shaun Reich <shaun.reich@kdemail.net>
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
*   GNU Library General Public License for more details
*
*   You should have received a copy of the GNU Library General Public
*   License along with this program; if not, write to the
*   Free Software Foundation, Inc.,
*   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

import QtQuick 1.1
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.core 0.1 as PlasmaCore

Item {
    id: mainWindow
    property int minimumWidth: 200
    property int minimumHeight: 200

    property bool listdictionaries: false;

    Component.onCompleted: {
        plasmoid.addEventListener('ConfigChanged', configChanged);
        icon.setIcon("accessories-dictionary")
    }

    function configChanged() {

    }

    PlasmaCore.DataSource {
        id: feedSource
        engine: "dict"
        connectedSources: ["freedom"]
        interval: 0
        onDataChanged: {
            plasmoid.busy = false
        }
    }

    PlasmaCore.DataModel {
        id: dataModel
        dataSource: feedSource
        keyRoleFilter: "[\\d]*"
    }

    PlasmaCore.Theme {
        id: theme
    }

    Column {
        width: mainWindow.width
        height: mainWindow.height

        Row {
            id: searchRow

            width: parent.width

            PlasmaWidgets.IconWidget {
                id: icon
                onClicked: {
                    mainWindow.listdictionaries = true
                    timer.running = true
                }
            }

            PlasmaComponents.TextField {
                id: searchBox

                clearButtonShown: true
                placeholderText: i18n("Type a word...")
                width: parent.width - icon.width - parent.spacing

                onTextChanged: {
                    timer.running = true
                    mainWindow.listdictionaries = false
                }
            }
        }

        Flickable {
            id: flickable

            width: parent.width
            height: parent.height
            contentHeight: textBrowser.paintedHeight
            clip: true

            TextEdit {
                id: textBrowser
                anchors {
                    fill: parent
                }

                wrapMode: TextEdit.Wrap
                readOnly: true
                clip: true

                text: computeHtml()

            }
        }

        PlasmaComponents.ScrollBar {
            id: scrollBar

            anchors { bottom: parent.bottom }

            orientation: Qt.Vertical
            stepSize: textBrowser.lineCount / 4
            scrollButtonInterval: textBrowser.lineCount / 4

            flickableItem: flickable
        }
    }

    Timer {
        id: timer
        running: false
        repeat: false
        interval: 500
        onTriggered: {
                plasmoid.busy = true
                if (mainWindow.listdictionaries) {
                    feedSource.connectedSources = "list-dictionaries"
                } else {
                    feedSource.connectedSources = [searchBox.text]
                }
        }
    }

    function computeHtml() {
        if (mainWindow.listdictionaries) {
            var data = feedSource.data["list-dictionaries"]
            var temp = i18n("<b>This is a list of Dictionaries. You can type 'dictionaryname:' in front of your search term to pick from a certain one.</b><br/><br/>")

            for (var line in data) {
                temp = temp + line + ": " + data[line] + "<br><br>"
            }

            return temp;
        } else {
            var styledHtml = "";

            if (feedSource.data[searchBox.text]) {
                var dictText = feedSource.data[searchBox.text]["text"];

                if (typeof feedSource.data[searchBox.text] == "undefined" || typeof dictText == "undefined") {
                    dictText = i18n("Loading...");
                }

                styledHtml += "<html><head><style type=\"text/css\">";
                styledHtml += theme.styleSheet + "</style></head>";
                styledHtml += "<body>" + dictText;
                styledHtml += "</body></html>";

            } else {
                styledHtml += "<html><head><style type=\"text/css\">";
                styledHtml += theme.styleSheet + "</style></head>";
                styledHtml += "<body>" + i18n("This is the dictionary app. Type a word in the search field above to get a definition.");
                styledHtml += "</body></html>";
            }
            return styledHtml;
        }
    }
}
