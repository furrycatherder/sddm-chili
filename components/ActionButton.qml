/*
 *   Copyright 2018 Marian Arlt <marianarlt@icloud.com>
 *   Copyright 2016 David Edmundson <davidedmundson@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 3 or
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

import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts 6.2

Item {
    id: root

    property alias font: label.font
    property int iconSize
    property alias iconSource: icon.source
    property alias text: label.text

    signal clicked

    Accessible.name: label.text
    Accessible.role: Accessible.Button
    Layout.alignment: Qt.AlignHCenter
    activeFocusOnTab: true
    implicitHeight: Math.max(icon.implicitHeight + label.height * 2, label.height)
    implicitWidth: Math.max(icon.implicitWidth, label.contentWidth)
    opacity: activeFocus ? 1 : 0.6

    Accessible.onPressAction: clicked()
    Keys.onEnterPressed: clicked()
    Keys.onReturnPressed: clicked()
    Keys.onSpacePressed: clicked()

    Image {
        id: icon

        height: config.PowerIconSize || iconSize
        width: config.PowerIconSize || iconSize

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }
    }
    Label {
        id: label

        color: "white"
        font.pointSize: Math.max(1, iconSize / 3)
        font.underline: root.activeFocus
        horizontalAlignment: Text.AlignHCenter
        renderType: Text.QtRendering
        wrapMode: Text.WordWrap

        anchors {
            left: parent.left
            right: parent.right
            top: icon.bottom
            topMargin: label.height / 2
        }
    }
    MouseArea {
        id: mouseArea

        anchors.fill: root
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: root.clicked()
        onEntered: fadeIn.start()
        onExited: fadeOut.start()
    }
    PropertyAnimation {
        id: fadeIn

        duration: 200
        properties: "opacity"
        target: root
        to: 1
    }
    PropertyAnimation {
        id: fadeOut

        duration: 200
        properties: "opacity"
        target: root
        to: 0.6
    }
}
