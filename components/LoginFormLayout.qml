/*
 *   Copyright 2018 Marian Alexander Arlt <marianarlt@icloud.com>
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

    default property alias _children: innerLayout.children
    property alias actionItems: actionItemsLayout.children
    property alias faceSize: userListView.avatarSize
    property alias notificationMessage: notificationsLabel.text
    property bool showUserList: true
    property alias userList: userListView
    property alias userListCurrentIndex: userListView.currentIndex
    property var userListCurrentModelData: userListView.currentItem === null ? [] : userListView.currentItem.m
    property alias userListModel: userListView.model
    property alias usernameFontColor: userListView.rootFontColor
    property alias usernameFontSize: userListView.rootFontSize

    UserList {
        id: userListView

        visible: showUserList && y > 0

        anchors {
            bottom: parent.verticalCenter
            left: parent.left
            right: parent.right
        }
    }
    ColumnLayout {
        id: prompts

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.verticalCenter

        ColumnLayout {
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter

            ColumnLayout {
                id: innerLayout

                Layout.topMargin: faceSize * 0.5
            }
            Label {
                id: notificationsLabel

                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: usernameFontSize / 2
                color: usernameFontColor
                font.italic: true
                opacity: notificationMessage ? 1 : 0

                Behavior on opacity {
                    OpacityAnimator {
                        duration: 100
                    }
                }
            }
        }
        RowLayout {
            id: actionItemsLayout

            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: actionItemsLayout.height * 4
            spacing: usernameFontSize * 2
        }
    }
}
