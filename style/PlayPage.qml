import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtMultimedia 5.15
import QtGraphicalEffects 1.15
import "PlayPageFunc.js" as Func

Item {
    property var musicPlayer

    RowLayout {
        anchors.fill: parent

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 10

            Column {
                Layout.preferredWidth: parent.width
                Layout.topMargin: 20
                spacing: 10

                Label {
                    text: musicPlayer.playlist.currentIndex !== -1 ? musicPlayer.songList[musicPlayer.playlist.currentIndex].songName
                                                                   : ""
                    font.pixelSize: 22
                    color: "#FFFFFF"
                    width: parent.width
                    elide: Label.ElideRight
                    horizontalAlignment: Label.AlignHCenter
                }

                Label {
                    text: musicPlayer.playlist.currentIndex !== -1 ? musicPlayer.songList[musicPlayer.playlist.currentIndex].singer
                                                                   : ""
                    font.pixelSize: 18
                    color: "#FFFFFF"
                    width: parent.width
                    elide: Label.ElideRight
                    horizontalAlignment: Label.AlignHCenter
                }

                Label {
                    text: musicPlayer.playlist.currentIndex !== -1 ? musicPlayer.songList[musicPlayer.playlist.currentIndex].albumName
                                                                   : ""
                    font.pixelSize: 18
                    color: "#FFFFFF"
                    width: parent.width
                    elide: Label.ElideRight
                    horizontalAlignment: Label.AlignHCenter
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.margins: 5

                Rectangle {
                    id: album
                    width: Math.min(parent.width, parent.height) * 4 / 5
                    height: width
                    radius: height / 2
                    color: "transparent"
                    border.color: "#505050"
                    border.width: width * 3 / 16
                    anchors.centerIn: parent

                    Rectangle {
                        width: parent.width * 7 / 8
                        height: width
                        radius: height / 2
                        color: "transparent"
                        border.color: "#000000"
                        anchors.centerIn: parent
                    }

                    Rectangle {
                        width: parent.width * 3 / 4
                        height: width
                        radius: height / 2
                        color: "transparent"
                        border.color: "#000000"
                        anchors.centerIn: parent
                    }

                    Rectangle {
                        width: parent.width * 5 / 8
                        height: width
                        radius: height / 2
                        color: "transparent"
                        border.color: "#000000"
                        anchors.centerIn: parent
                    }

                    Image {
                        id: albumCover
                        source: musicPlayer.playlist.currentIndex !== -1 ? musicPlayer.songList[musicPlayer.playlist.currentIndex].imageSource
                                                                         : "qrc:/images/albumCover.png"
                        fillMode: Image.PreserveAspectFit
                        width: parent.width * 5 / 8
                        height: parent.width * 5 / 8
                        anchors.centerIn: parent
                        z: - 1

                        onStatusChanged: {
                            if(status === Image.Error)
                                source = "qrc:/images/albumCover.png";
                        }

                        RotationAnimation on rotation {
                            running: musicPlayer.playbackState !== Audio.StoppedState
                            paused: musicPlayer.playbackState === Audio.PausedState
                            loops: Animation.Infinite
                            from: 0
                            to: 360
                            duration: 15000
                            direction: RotationAnimation.Clockwise
                        }
                    }

                    Rectangle {
                        width: albumCover.width
                        height: albumCover.height
                        radius: height / 2
                        color: "#60000000"
                        opacity: hoverMouseArea.containsMouse || playButton.hovered ? 1 : 0
                        anchors.centerIn: parent
                        z: -1

                        MouseArea {
                            id: hoverMouseArea
                            anchors.fill: parent
                            hoverEnabled: true

                            onClicked: {
                                if(musicPlayer.playbackState === Audio.PlayingState) musicPlayer.pause();
                                else  musicPlayer.play();
                            }
                        }

                        RoundButton {
                            id: playButton
                            hoverEnabled: true
                            icon.source: musicPlayer.playbackState === Audio.PlayingState ? "qrc:/images/pause.png" : "qrc:/images/play.png"
                            leftPadding: 7                                              // 调节图标使其居中
                            width: 50
                            height: 50
                            anchors.centerIn: parent
                            icon.color: pressed ? "#FFFFFF" : hovered ? "#D0FFFFFF" : "#A0FFFFFF"

                            background: Rectangle {
                                radius: parent.radius
                                color: "transparent"
                                border.color: playButton.pressed ? "#FFFFFF" : playButton.hovered ? "#D0FFFFFF" : "#A0FFFFFF"
                            }

                            layer.enabled: true
                            layer.effect: DropShadow {
                                radius: 3
                                samples: 7
                                spread: 0.1
                                color: playButton.pressed ? "#FFFFFF" : playButton.hovered ? "#D0FFFFFF" : "#A0FFFFFF"
                            }

                            onClicked: {
                                if(musicPlayer.playbackState === Audio.PlayingState) musicPlayer.pause();
                                else  musicPlayer.play();
                            }
                        }
                    }
                }

                Image {
                    id: pointer
                    source: "qrc:/images/phonograph.png"
                    width: album.width / 4
                    fillMode: Image.PreserveAspectFit
                    anchors.left: album.right
                    anchors.leftMargin: -10
                    anchors.top: album.top
                    anchors.topMargin: -10

                    transform: Rotation {
                        origin.x: pointer.width / 2
                        origin.y: pointer.height * 7 / 80
                        angle: musicPlayer.playbackState === Audio.PlayingState ? 20 : 0

                        Behavior on angle { NumberAnimation { duration: 700; easing.type: Easing.OutQuad } }
                    }
                }
            }

            ListView {
                id: listView
                Layout.preferredHeight: parent.height / 5
                Layout.fillWidth: true
                spacing: 10
                headerPositioning: ListView.OverlayHeader
                footerPositioning: ListView.OverlayFooter
                clip: true

                header: Rectangle {
                    z: 2
                    width: listView.width
                    height: 10
                    gradient: Gradient {
                        GradientStop { position: 0; color: "#80000000" }
                        GradientStop { position: 1; color: "#00000000" }
                    }
                }

                model: ListModel {
                    id: lyricModel
                }

                delegate: Label {
                    width: listView.width
                    text: model.content
                    font.pixelSize: 18
                    wrapMode: Label.Wrap
                    horizontalAlignment: Label.AlignHCenter
                    font.bold: model.index === listView.currentIndex
                    color: model.index === listView.currentIndex ? "#37E12A" : "#FFFFFF"
                }

                footer: Rectangle {
                    z: 2
                    width: listView.width
                    height: 10
                    gradient: Gradient {
                        GradientStop { position: 0; color: "#00000000" }
                        GradientStop { position: 1; color: "#80000000" }
                    }
                }

                Connections {
                    target: musicPlayer

                    function onPositionChanged() {
                        let index = Func.getLyricIndex(musicPlayer.position, lyricModel);
                        if(index !== -1) {
                            listView.currentIndex = index;
                            if(!listView.moving)  listView.positionViewAtIndex(index, ListView.Center);
                        }
                    }
                }
            }
        }

        Frame {
            Layout.preferredWidth: parent.width / 3
            Layout.preferredHeight: parent.height - 2 * Layout.margins
            Layout.margins: 10
            leftPadding: 0
            rightPadding: 0
            bottomPadding: 0

            ListView {
                id: musicList
                anchors.fill: parent
                anchors.leftMargin: 1
                anchors.rightMargin: 1
                clip: true
                headerPositioning: ListView.OverlayHeader

                header: Rectangle {
                    z: 2
                    width: musicList.width
                    height: 40
                    color: "#000000"

                    Label {
                        width: musicList.width
                        leftPadding: 10
                        text: qsTr("歌曲列表")
                        elide: Label.ElideRight
                        color: "#A0A0A0"
                        font.pixelSize: 18
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Label.AlignHCenter
                    }
                }


                model: ListModel {
                    id: musicListModel
                }

                delegate: ItemDelegate {
                    id: itemDelegate
                    hoverEnabled: true
                    height: title.height
                    width: musicList.width

                    property color itemColor: model.index % 2 ? "#707070" : "#505050"

                    background: Rectangle {
                        anchors.fill: itemDelegate
                        border.color: model.index === musicPlayer.playlist.currentIndex ? "#37E12A" : "transparent"
                        color: itemDelegate.hovered ? Qt.lighter(itemDelegate.itemColor, 1.3) : itemDelegate.itemColor

                        Behavior on color {
                            ColorAnimation { easing.type: Easing.OutQuad; duration: 500 }
                        }
                    }

                    Column {
                        id: title
                        width: itemDelegate.width - buttons.width

                        Label {
                            width: parent.width
                            topPadding: 10
                            bottomPadding: 10
                            leftPadding: 10
                            text: model.songName
                            elide: Label.ElideRight
                            color: "#FFFFFF"
                            font.pixelSize: 18
                        }

                        Label {
                            width: parent.width
                            bottomPadding: 5
                            leftPadding: 10
                            text: model.singer
                            elide: Label.ElideRight
                            color: "#C0C0C0"
                            font.pixelSize: 14
                        }

                        Label {
                            width: parent.width
                            bottomPadding: 5
                            leftPadding: 10
                            text: model.albumName
                            elide: Label.ElideRight
                            color: "#C0C0C0"
                            font.pixelSize: 14
                        }
                    }

                    Row {
                        id: buttons
                        width: 100
                        opacity: itemDelegate.hovered ? 1 : 0
                        spacing: 5
                        anchors.verticalCenter: itemDelegate.verticalCenter
                        anchors.right: parent.right

                        RoundButton {
                            hoverEnabled: true
                            width: 40
                            height: 40
                            icon.source: musicPlayer.playbackState === Audio.PlayingState && musicPlayer.playlist.currentIndex === model.index
                                            ? "qrc:/images/pause.png" : "qrc:/images/play.png"

                            layer.enabled: hovered
                            layer.effect: DropShadow {
                                radius: 6
                                samples: 13
                                spread: 0.1
                            }

                            onClicked: {
                                if(musicPlayer.playlist.currentIndex === model.index) {
                                    if(musicPlayer.playbackState === Audio.PlayingState)  musicPlayer.pause();
                                    else  musicPlayer.play();
                                }
                                else {
                                    musicPlayer.playlist.currentIndex = model.index;
                                    musicPlayer.play();
                                }
                            }
                        }

                        RoundButton {
                            hoverEnabled: true
                            width: 40
                            height: 40
                            icon.source: "qrc:/images/delete.png"

                            layer.enabled: hovered
                            layer.effect: DropShadow {
                                radius: 6
                                samples: 13
                                spread: 0.1
                            }

                            onClicked: {
                                musicPlayer.songList.splice(model.index, 1);
                                musicPlayer.playlist.removeItem(model.index);
                                musicPlayer.songListChanged();
                            }
                        }
                    }

                    onDoubleClicked: {
                        if(musicPlayer.playlist.currentIndex !== model.index) {
                            musicPlayer.playlist.currentIndex = model.index;
                            musicPlayer.play();
                        }
                    }
                }

                Connections {
                    target: musicPlayer

                    function onSongListChanged() {
                        musicListModel.clear();
                        musicPlayer.songList.forEach(function(item) {
                            musicListModel.append({ songName: item.songName, singer: item.singer, albumName: item.albumName});
                        });
                    }
                }
            }
        }
    }

    Connections {
        target: musicPlayer.playlist

        function onCurrentItemSourceChanged() {
            if(musicPlayer.playlist.currentIndex === -1)  lyricModel.clear();
            else  Func.getLyric(musicPlayer.songList[musicPlayer.playlist.currentIndex].songMid, lyricModel, musicPlayer);
        }
    }
}
