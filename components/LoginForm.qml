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
import QtQuick.Layouts 6.2
import QtQuick.Controls 6.2

LoginFormLayout {
    property int inputSpacing: 8
    property string lastUserName
    property bool passwordFieldOutlined: config.PasswordFieldOutlined == "true"

    signal loginRequest(string username, string password)

    function startLogin() {
        var username = userList.selectedUser;
        var password = passwordField.text;
        loginRequest(username, password);
    }

    Component.onCompleted: {
        passwordField.forceActiveFocus();
    }

    RowLayout {
        Layout.leftMargin: loginButton.width + inputSpacing * 2
        Layout.minimumWidth: passwordField.width + loginButton.width + inputSpacing * 2

        TextField {
            id: passwordField

            color: passwordFieldOutlined ? "white" : "black"
            echoMode: TextInput.Password
            focus: true
            font.pointSize: Math.max(1, usernameFontSize * 0.9)
            implicitHeight: usernameFontSize * 2.75
            implicitWidth: root.width / 5
            opacity: 0.5
            placeholderText: textConstants.password
            placeholderTextColor: passwordFieldOutlined ? "white" : "black"

            background: Rectangle {
                border.color: "white"
                border.width: 1
                color: passwordFieldOutlined ? "transparent" : "white"
                radius: 3
            }

            Keys.onEscapePressed: {
                loginFormStack.currentItem.forceActiveFocus();
            }
            Keys.onPressed: {
                if (event.key == Qt.Key_Left && !text) {
                    userList.decrementCurrentIndex();
                    event.accepted = true;
                }
                if (event.key == Qt.Key_Right && !text) {
                    userList.incrementCurrentIndex();
                    event.accepted = true;
                }
            }
            Keys.onReleased: {
                if (loginButton.opacity == 0 && length > 0) {
                    showLoginButton.start();
                }
                if (loginButton.opacity > 0 && length == 0) {
                    hideLoginButton.start();
                }
            }
            onAccepted: startLogin()

            Connections {
                function onLoginFailed() {
                    passwordField.selectAll();
                    passwordField.forceActiveFocus();
                }

                target: sddm
            }
        }
        Image {
            id: loginButton

            Layout.leftMargin: inputSpacing
            opacity: 0
            smooth: true
            source: "../assets/login.svgz"
            sourceSize: Qt.size(passwordField.height, passwordField.height)
            visible: opacity > 0

            MouseArea {
                anchors.fill: parent

                onClicked: startLogin()
            }
            PropertyAnimation {
                id: showLoginButton

                duration: 100
                properties: "opacity"
                target: loginButton
                to: 0.75
            }
            PropertyAnimation {
                id: hideLoginButton

                duration: 80
                properties: "opacity"
                target: loginButton
                to: 0
            }
        }
    }
}
