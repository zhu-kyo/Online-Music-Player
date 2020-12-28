import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ToolBar {
    id: control

    property var window
    property alias currentIndex: tabBar.currentIndex

    signal currentPageChanged(int index)
    signal search(string keyword)

    background: Rectangle {
        color: "#000000"
    }

    RowLayout {
        id: titleLayout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 28
        spacing: 5

        Image {
            source: "qrc:/app.ico"
            fillMode: Image.PreserveAspectFit
            smooth: true
            Layout.leftMargin: 15
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            Layout.preferredHeight: parent.height - Layout.topMargin - Layout.bottomMargin
            Layout.preferredWidth: Layout.preferredHeight
        }

        Item {
            id: titleSpacer
            Layout.fillWidth: true
        }

        RoundButton {
            hoverEnabled: true
            icon.source: "qrc:/images/minimize.png"
            padding: 2
            icon.color: pressed ? "#37E12A": hovered ? "#F037E12A" : "#FFFFFF"
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: parent.height

            background: Rectangle {
                radius: parent.radius
                color: parent.pressed ? "#806AE1DD" : parent.hovered ? "#80FFFFFF" : "transparent"
            }

            onClicked: window.showMinimized();
        }

        RoundButton {
            hoverEnabled: true
            icon.source: "qrc:/images/power.png"
            padding: 5
            icon.color: pressed ? "#37E12A" : hovered ? "#F037E12A" : "#FFFFFF"
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: parent.height

            background: Rectangle {
                radius: parent.radius
                color: parent.pressed ? "#806AE1DD" : parent.hovered ? "#80FFFFFF" : "transparent"
            }

            onClicked: Qt.quit();
        }
    }

    Label {
        text: qsTr("Online Music Player")
        font.pixelSize: 20
        color: "#FFFFFF"
        width: titleSpacer.width
        elide: Label.ElideRight
        horizontalAlignment: Label.AlignHCenter
        anchors.centerIn: titleLayout

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton

            property point before

            onPressed: before = Qt.point(mouse.x, mouse.y)

            onPositionChanged: {
                if(pressed)
                {
                    let after = Qt.point(mouse.x, mouse.y);
                    window.setX(window.x + after.x - before.x);
                    window.setY(window.y + after.y - before.y);
                }
            }
        }
    }

    Rectangle {
        id: separator
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: titleLayout.bottom
        height: 2
        color: "#FFFFFF"
    }

    Row {
        anchors.top: separator.bottom
        topPadding: 4
        anchors.bottom: parent.bottom
        bottomPadding: 4
        anchors.left: parent.left
        leftPadding: 15
        spacing: 10

        TextField {
            id: searchField
            width: titleLayout.width * 1 / 4
            height: parent.height - parent.topPadding - parent.bottomPadding
            verticalAlignment: TextField.AlignVCenter
            leftPadding: 15
            topPadding: 3
            bottomPadding: 3
            placeholderText: qsTr("新歌榜")
            selectByMouse: true
            selectionColor: "#27AFE1"

            background: Rectangle {
                width: parent.width
                height: parent.height
                radius: height / 2
                border.color: parent.focus ? "#37E12A" : "transparent"
                color: "#FFFFFF"

                SequentialAnimation on color {
                    id: colorAnimation
                    running: false
                    ColorAnimation { from: "#FFFFFF"; to: Qt.darker("#FFFFFF", 3); }
                    ColorAnimation { to: "#FFFFFF" }
                    loops: 3
                }
            }

            onAccepted: {
                focus = false;
                if(searchField.text.length > 0)  {
                    search(searchField.text);
                    searchField.text = "";
                    tabBar.currentIndex = 0;
                }
                else  colorAnimation.running = true;
            }
        }

        Button {
            hoverEnabled: true
            icon.source: "qrc:/images/search.png"
            padding: 6
            icon.color: pressed ? "#37E12A" : hovered ? "#B037E12A" : "#FFFFFF"
            width: 50
            height: parent.height - parent.topPadding - parent.bottomPadding

            background: Rectangle {
                radius: height / 2
                color: "#E15868"
            }

            HoverHandler {
                cursorShape: Qt.PointingHandCursor
            }


            onClicked: {
                if(searchField.text.length > 0)  {
                    search(searchField.text);
                    searchField.text = "";
                    tabBar.currentIndex = 0;
                }
                else  colorAnimation.running = true;
            }
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: tabBar.currentIndex === 0 ? parent.width / 4 : 0
        anchors.right: parent.right
        anchors.top: parent.bottom
        height: 2
        color: "#37E12A"
    }

    TabBar {
        id: tabBar
        anchors.top: separator.bottom
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 0
        width: Math.max(button1.implicitWidth, button2.implicitWidth) * 2
        currentIndex: 0

        onCurrentIndexChanged: control.currentPageChanged(currentIndex)

        TabButton {
            id: button1
            text: qsTr("榜单");
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            background: Rectangle {
                width: button1.width
                height: button1.height
                border.color: "#37E12A"
                border.width: 2
                color: "#000000"

                Rectangle {
                    color: parent.color
                    anchors.fill: parent
                    anchors.leftMargin: tabBar.currentIndex === button1.TabBar.index ? parent.border.width : 0
                    anchors.rightMargin: tabBar.currentIndex === button1.TabBar.index ? parent.border.width : 0
                    anchors.topMargin: tabBar.currentIndex === button1.TabBar.index ? parent.border.width : 0
                    anchors.bottomMargin: tabBar.currentIndex === button1.TabBar.index ? -2 : 0
                }
            }

            contentItem: Text {
                text: button1.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: tabBar.currentIndex === button1.TabBar.index ? "#37E12A" : "#FFFFFF"
                font.pixelSize: 20
            }
        }

        TabButton {
            id: button2
            text: qsTr("播放列表");
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            background: Rectangle {
                width: button2.width
                height: button2.height
                border.color: "#37E12A"
                border.width: 2
                color: "#000000"

                Rectangle {
                    color: parent.color
                    anchors.fill: parent
                    anchors.leftMargin: tabBar.currentIndex === button2.TabBar.index ? parent.border.width : 0
                    anchors.rightMargin: tabBar.currentIndex === button2.TabBar.index ? parent.border.width : 0
                    anchors.topMargin: tabBar.currentIndex === button2.TabBar.index ? parent.border.width : 0
                    anchors.bottomMargin: tabBar.currentIndex === button2.TabBar.index ? -2 : 0
                }
            }

            contentItem: Text {
                text: button2.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: tabBar.currentIndex === button2.TabBar.index ? "#37E12A" : "#FFFFFF"
                font.pixelSize: 20
            }
        }
    }
}
