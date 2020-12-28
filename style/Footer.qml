import QtQuick 2.15
import QtGraphicalEffects 1.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtMultimedia 5.15
import "." as Style
import "RankPageFunc.js" as Func

Rectangle {
    id: tabFooter

    property var musicPlayer

    property real volume: QtMultimedia.convertVolume(volumeSlider.value, QtMultimedia.LogarithmicVolumeScale, QtMultimedia.LinearVolumeScale)

    color: "#F0000000"

    Rectangle {
        x: parent.height / 2
        width: parent.height
        height: parent.height
        transformOrigin: Item.Right
        rotation: 45
        color: "#37E12A"
        z: -1

        HoverHandler {
            id: hoverHandlerHint
        }
    }

    Rectangle {
        width: parent.width
        anchors.top: parent.top
        height: 2
        color: "#37E12A"

        layer.enabled: true
        layer.effect: DropShadow {
            verticalOffset: -2
            radius: 15
            samples: 31
            spread: 0.7
            color: "#37E12A"
        }
    }

    transform: Translate {
        Behavior on y { NumberAnimation { easing.type: Easing.InOutQuad; duration: 500 } }
        y: hoverHandlerHint.hovered || hoverHandler.hovered ? 0 : tabFooter.height
    }

    HoverHandler {
        id: hoverHandler
    }

    TapHandler {}   // 阻止点击事件传递

    RowLayout {
        width: parent.width * 2 / 3
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter

        RoundButton {
            id: previousButton
            hoverEnabled: true
            icon.source: "qrc:/images/previous.png"
            Layout.preferredHeight: parent.height * 1 / 2
            Layout.preferredWidth: Layout.preferredHeight
            icon.color: pressed ? "#FFFFFF" : hovered ? "#D0FFFFFF" : "#A0FFFFFF"

            background: Rectangle {
                radius: parent.radius
                color: "transparent"
                border.color: previousButton.pressed ? "#FFFFFF" : previousButton.hovered ? "#D0FFFFFF" : "#A0FFFFFF"
            }

            layer.enabled: true
            layer.effect: DropShadow {
                radius: 3
                samples: 7
                spread: 0.1
                color: previousButton.pressed ? "#FFFFFF" : previousButton.hovered ? "#D0FFFFFF" : "#A0FFFFFF"
            }

            onClicked: musicPlayer.playlist.previous()
        }

        RoundButton {
            id: playButton
            hoverEnabled: true
            icon.source: musicPlayer.playbackState === Audio.PlayingState ? "qrc:/images/pause.png" : "qrc:/images/play.png"
            leftPadding: 7                                              // 调节图标使其居中
            Layout.preferredHeight: parent.height * 2 / 3
            Layout.preferredWidth: Layout.preferredHeight
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

        RoundButton {
            id: nextButton
            hoverEnabled: true
            icon.source: "qrc:/images/next.png"
            Layout.preferredHeight: parent.height * 1 / 2
            Layout.preferredWidth: Layout.preferredHeight
            icon.color: pressed ? "#FFFFFF" : hovered ? "#D0FFFFFF" : "#A0FFFFFF"

            background: Rectangle {
                radius: parent.radius
                color: "transparent"
                border.color: nextButton.pressed ? "#FFFFFF" : nextButton.hovered ? "#D0FFFFFF" : "#A0FFFFFF"
            }

            layer.enabled: true
            layer.effect: DropShadow {
                radius: 3
                samples: 7
                spread: 0.1
                color: nextButton.pressed ? "#FFFFFF" : nextButton.hovered ? "#D0FFFFFF" : "#A0FFFFFF"
            }

            onClicked: musicPlayer.playlist.next()
        }

        Image {
            id: albumCover
            source: "qrc:/images/footerCover.png"
            fillMode: Image.PreserveAspectFit
            Layout.preferredHeight: parent.height * 4 / 5
            Layout.preferredWidth: Layout.preferredHeight

            onStatusChanged: {
                if(status === Image.Error)
                    source = "qrc:/images/footerCover.png";
            }

            Connections {
                target: musicPlayer.playlist

                function onCurrentItemSourceChanged() {
                    if(musicPlayer.playlist.currentIndex !== -1)
                        albumCover.source = musicPlayer.songList[musicPlayer.playlist.currentIndex].imageSource;
                }
            }
        }

        ColumnLayout {
            Layout.preferredHeight: parent.height
            spacing: 0

            Row {
                id: label
                Layout.fillWidth: true
                spacing: 20
                topPadding: 5
                leftPadding: 5

                property real velocity: 0.05

                Item {
                    width: parent.width / 2
                    height: songNameLabel.implicitHeight
                    clip: true

                    Label {
                        id: songNameLabel
                        width: parent.width
                        font.pixelSize: 17
                        color: "#BBBBBB"

                        SequentialAnimation {
                            running: songNameLabel.implicitWidth > songNameLabel.width
                            loops: Animation.Infinite

                            PauseAnimation { duration: 500 }

                            XAnimator {
                                target: songNameLabel
                                from: 0
                                to: -songNameLabel.implicitWidth
                                duration: Math.ceil(songNameLabel.implicitWidth / label.velocity)
                            }

                            XAnimator {
                                target: songNameLabel
                                from: songNameLabel.width
                                to: 0
                                duration: Math.ceil(songNameLabel.width / label.velocity)
                            }
                        }

                        Connections {
                            target: musicPlayer.playlist

                            function onCurrentItemSourceChanged() {
                                if(musicPlayer.playlist.currentIndex !== -1) {
                                    songNameLabel.text = "";
                                    songNameLabel.x = 0;
                                    songNameLabel.text = musicPlayer.songList[musicPlayer.playlist.currentIndex].songName;
                                }
                            }
                        }
                    }
                }

                Item{
                    width: parent.width / 3
                    height: singerLabel.implicitHeight
                    clip: true

                    Label {
                        id: singerLabel
                        width: parent.width
                        font.pixelSize: 15
                        color: "#888888"

                        SequentialAnimation {
                            running: singerLabel.implicitWidth > singerLabel.width
                            loops: Animation.Infinite

                            PauseAnimation { duration: 500 }

                            XAnimator {
                                target: singerLabel
                                from: 0
                                to: -singerLabel.implicitWidth
                                duration: Math.ceil(singerLabel.implicitWidth / label.velocity)
                            }

                            XAnimator {
                                target: singerLabel
                                from: singerLabel.width
                                to: 0
                                duration: Math.ceil(singerLabel.width / label.velocity)
                            }
                        }

                        Connections {
                            target: musicPlayer.playlist

                            function onCurrentItemSourceChanged() {
                                if(musicPlayer.playlist.currentIndex !== -1) {
                                    singerLabel.text = "";
                                    singerLabel.x = 0;
                                    singerLabel.text = musicPlayer.songList[musicPlayer.playlist.currentIndex].singer;
                                }
                            }
                        }
                    }
                }

            }

            RowLayout {
                Layout.bottomMargin: 5

                Style.Slider {
                    id: durationSlider
                    height: 8
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    value: 0
                    live: false
                    enabled: musicPlayer.playbackState === Audio.PlayingState

                    onValueChanged: musicPlayer.seek(value)

                    Connections {
                        target: musicPlayer

                        function onPositionChanged() {
                            if(!durationSlider.pressed)  durationSlider.value = musicPlayer.position;
                        }

                        function onDurationChanged() {
                            durationSlider.value = 0;
                            durationSlider.from = 0;
                            durationSlider.to = musicPlayer.duration;
                        }
                    }
                }

                Label {
                    id: durationLabel
                    text: qsTr("00:00/00:00")
                    color: "#BBBBBB"
                    font.pixelSize: 18

                    Connections {
                        target: musicPlayer

                        function onPositionChanged() {
                            durationLabel.text = Func.formatDuration(Math.floor(musicPlayer.position / 1000))
                                    + "/" + Func.formatDuration(Math.floor(musicPlayer.duration / 1000));
                        }
                    }
                }
            }
        }

        Item {
            width: 20
        }

        ToolButton {
            id: playModeButton
            hoverEnabled: true
            icon.source: {
                switch(musicPlayer.playlist.playbackMode) {
                case Playlist.Loop:  return "qrc:/images/loop.png";
                case Playlist.CurrentItemInLoop:  return "qrc:/images/singleLoop.png";
                case Playlist.Random:  return "qrc:/images/random.png";
                default:  return "qrc:/images/sequential.png"
                }
            }
            icon.color: pressed ? "#FFFFFF" : hovered ? "#D0FFFFFF" : "#A0FFFFFF"
            icon.width: parent.height * 1 / 2 - padding * 2
            icon.height: parent.height * 1 / 2 - padding * 2
            padding: 2

            background: Rectangle {
                color: "transparent"
            }

            layer.enabled: true
            layer.effect: DropShadow {
                radius: 3
                samples: 7
                spread: 0.1
                color: playModeButton.pressed ? "#FFFFFF" : playModeButton.hovered ? "#D0FFFFFF" : "#A0FFFFFF"
            }

            onClicked: {
                switch(musicPlayer.playlist.playbackMode) {
                case Playlist.Sequential:
                    musicPlayer.playlist.playbackMode = Playlist.Loop;
                    break;

                case Playlist.Loop:
                    musicPlayer.playlist.playbackMode = Playlist.CurrentItemInLoop;
                    break;

                case Playlist.CurrentItemInLoop:
                    musicPlayer.playlist.playbackMode = Playlist.Random;
                    break;

                default:
                    musicPlayer.playlist.playbackMode = Playlist.Sequential;
                    break;
                }
            }
        }

        ToolButton {
            id: volumeButton
            hoverEnabled: true
            icon.source: musicPlayer.muted ? "qrc:/images/mutedVolume.png" : "qrc:/images/volume.png"
            icon.color: pressed ? "#FFFFFF" : hovered ? "#D0FFFFFF" : "#A0FFFFFF"
            icon.width: parent.height / 2 - padding * 2
            icon.height: parent.height / 2 - padding * 2
            padding: 0

            background: Rectangle {
                color: "transparent"
            }

            layer.enabled: true
            layer.effect: DropShadow {
                radius: 3
                samples: 7
                spread: 0.1
                color: volumeButton.pressed ? "#FFFFFF" : volumeButton.hovered ? "#D0FFFFFF" : "#A0FFFFFF"
            }

            onClicked: musicPlayer.muted = !musicPlayer.muted
        }

        Style.Slider {
            id: volumeSlider
            height: 8
            from: 0
            to: 1
            value: 0.8
            width: 80


        }
    }
}
