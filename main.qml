import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia 5.15
import "./style"
import "./style/RankPageFunc.js" as Func

ApplicationWindow {
    id: window
    minimumWidth: 1200
    minimumHeight: 800
    visible: true
    flags: Qt.CustomizeWindowHint | Qt.Window

    background: Rectangle {
        anchors.fill: parent
        color: "#000000"
    }

    header: Header {
        id: tabHeader
        window: window
        height: 70
    }

    footer: Footer {
        id: tabFooter
        height: 60
        musicPlayer: musicPlayer
    }

    StackLayout {
        id: stackLayout
        anchors.fill: parent
        currentIndex: 0

        RankPage {
            id: rankPage
            footer: tabFooter
            header: tabHeader
            musicPlayer: musicPlayer
        }

        PlayPage {
            musicPlayer: musicPlayer
        }

        Connections {
            target: tabHeader

            function onCurrentPageChanged(index) {
                stackLayout.currentIndex = index;
            }
        }
    }

    Audio {
        id: musicPlayer
        volume: tabFooter.volume
        notifyInterval: 300

        playlist: Playlist {}

        property var songList: new Array

        signal musicUrlUpdate(string url, string songMid)

        onError: {
            if(error !== Audio.NoError) {
                Func.getMusicAddress(songList[playlist.currentIndex].songMid, musicPlayer);
            }
        }

        onMusicUrlUpdate: {
            let index = songList.map(function(item) {
                return item.songMid;
            }).indexOf(songMid);
            if(index !== -1) {
                stop();
                playlist.removeItem(index);
                playlist.insertItem(index, url);
                play();
            }
        }
    }
}
