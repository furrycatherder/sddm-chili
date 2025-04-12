/*
 *   Copyright 2018 Marian Alexander Arlt <marianarlt@icloud.com>
 *   Copyright 2014 David Edmundson <davidedmundson@kde.org>
 *   Copyright 2014 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
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
import Qt5Compat.GraphicalEffects

Item {
    id: wrapper

    property string avatarPath
    property bool constrainText: true
    property real faceSize
    property string iconSource
    property bool isCurrent: true
    readonly property var m: model
    property string name
    property string userName
    property string usernameFontColor
    property int usernameFontSize

    signal clicked

    function accessiblePressAction() {
        wrapper.clicked();
    }

    Accessible.name: name
    Accessible.role: Accessible.Button
    opacity: isCurrent ? 1.0 : 0.3

    Behavior on opacity {
        OpacityAnimator {
            duration: 150
        }
    }

    Item {
        id: imageSource

        anchors.horizontalCenter: parent.horizontalCenter
        height: faceSize
        width: faceSize

        // Image takes priority, taking a full path to a file, if that doesn't exist we show an icon
        Image {
            id: face

            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            smooth: true
            source: wrapper.avatarPath
            sourceSize: Qt.size(faceSize, faceSize)
            visible: false
        }
        Image {
            id: mask

            smooth: true
            source: "../assets/mask.svgz"
            sourceSize: Qt.size(faceSize, faceSize)
        }
        OpacityMask {
            anchors.fill: face
            cached: true
            maskSource: mask
            source: face
        }
    }
    Label {
        id: usernameLabel

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: imageSource.bottom
        anchors.topMargin: usernameLabel.height / 1.2
        color: usernameFontColor
        font.capitalization: Font.Capitalize
        font.pointSize: Math.max(1, usernameFontSize * 1.2)
        // Make an indication that this has active focus, this only happens when reached with keyboard navigation
        font.underline: wrapper.activeFocus
        horizontalAlignment: Text.AlignHCenter
        renderType: Text.QtRendering
        text: wrapper.name
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: wrapper.clicked()
    }
}
