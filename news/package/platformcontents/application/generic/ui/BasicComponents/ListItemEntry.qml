/*
 *   Copyright 2010 Marco Martin <notmart@gmail.com>
 *   Copyright 2012 Sebastian Kügler <sebas@kde.org>
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
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.core 0.1 as PlasmaCore

PlasmaComponents.ListItem {
    id: listItem
    property string text
    property string date
    //property string author
    property bool articleRead: false
    enabled: true
    opacity: articleRead?0.5:1

    PlasmaComponents.Label  {
        id: titleLabel
        width: parent.width - 24
        wrapMode: Text.WordWrap
        textFormat: Text.RichText
        text: listItem.text
        anchors { leftMargin: 12; bottomMargin: 12; }
    }
    PlasmaComponents.Label  {
        width: parent.width
        horizontalAlignment: Text.AlignRight
        font.pointSize: theme.smallestFont.pointSize
        text: listItem.date
        opacity: 0.5
        anchors { top: titleLabel.bottom; right: titleLabel.right; }
    }
    PlasmaComponents.Label  {
        width: parent.width
        font.pointSize: theme.smallestFont.pointSize
        text: i18n("by %1", author)
//         opacity: 0.5
        anchors { top: titleLabel.bottom; left: titleLabel.left; }
    }
}
