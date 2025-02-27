/*
 *   Copyright 2018 Marian Arlt <marianarlt@icloud.com>
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

Button {
    id: keyboardLayoutButton

    property int currentIndex

    visible: keyboard.layouts.length > 1

    flat: true
    
    contentItem: Image {
        id: buttonLabel
        source: "../assets/keyboard.svgz"
        fillMode: Image.PreserveAspectFit
        x: 5
        smooth: false
    }
    
    background: Rectangle {
        radius: 3
        color: keyboardLayoutButton.activeFocus ? "white" : "transparent"
        opacity: keyboardLayoutButton.activeFocus ? 0.3 : 1
    }

    Menu {
        id: keyboardLayoutMenu
        
        y: parent.height
        
        Instantiator {
            id: instantiator
            model: keyboard.layouts
            delegate: MenuItem {
                text: modelData.longName
                property string shortName: modelData.shortName
                onTriggered: {
                    keyboard.currentLayout = model.index
                }
            }
            function onObjectAdded(index, object) {
                keyboardLayoutMenu.insertItem(index, object);
            }
            function onObjectRemoved(object) {
                keyboardLayoutMenu.removeItem(object);
            }
        }
    }
    
    onClicked: keyboardLayoutMenu.open()

    Component.onCompleted: currentIndex = Qt.binding(function() {
        return keyboard.currentLayout
    });

}