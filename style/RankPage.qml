import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import QtMultimedia 5.15
import QtQml 2.15
import "RankPageFunc.js" as Func

Item {
    id: page

    property var header
    property var footer
    property var musicPlayer
    property var tempSongList: new Array
    property int musicCount

    signal musicUrlReady(string url, string songMid, string behavior)
    signal musicCountReady(int totalCount)

    Container {
        id: container
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width / 4
        height: parent.height + footer.height
        spacing: 0
        currentIndex: 0

        background: Rectangle {
            anchors.fill: parent
            color: "#303030"

            Rectangle {
                width: 2
                color: "#37E12A"
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
            }
        }

        contentItem: Column {
            anchors.fill: parent
            spacing: 0

            Label {
                text: qsTr("榜单")
                color: "#A460C7"
                width: parent.width
                height: 60
                font.pixelSize: 23
                font.bold: true
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
            }

            Rectangle {
                height: 1
                width: parent.width - 2
                color: "#FFFFFF"
            }

            TabButton {
                id: button1
                text: qsTr("新歌榜")
                width: parent.width
                checkable: true
                checked: container.currentIndex === 0
                autoExclusive: true
                hoverEnabled: true

                onToggled: {
                    container.currentIndex = 0;
                    Func.getMusicList(container.currentIndex, 0, musicListModel, busyIndicator, errorLabel)
                }

                background: Rectangle {
                    anchors.fill: button1
                    border.width: 2
                    border.color: "#37E12A"
                    color: button1.checked || button1.hovered ? "#000000" : "#303030"

                    Rectangle {
                        anchors.fill: parent
                        color: parent.color
                        anchors.leftMargin: button1.checked ? parent.border.width : 0
                        anchors.rightMargin: button1.checked ? 0 : parent.border.width
                        anchors.topMargin: button1.checked ? parent.border.width : 0
                        anchors.bottomMargin: button1.checked ? parent.border.width : 0

                        Behavior on color {
                            ColorAnimation { easing.type: Easing.OutQuad; duration: 500 }
                        }
                    }
                }

                contentItem: Text {
                    text: button1.text
                    font.pixelSize: 20
                    verticalAlignment: Text.AlignVCenter
                    color: button1.checked ? "#37E12A" : "#FFFFFF"
                    leftPadding: 100
                    padding: 5
                }
            }

            Rectangle {
                height: 1
                width: parent.width - 2
                color: "#FFFFFF"
            }

            TabButton {
                id: button2
                text: qsTr("随机推荐")
                width: parent.width
                checkable: true
                checked: container.currentIndex === 1
                autoExclusive: true
                hoverEnabled: true

                onToggled: {
                    container.currentIndex = 1;
                    Func.getMusicList(container.currentIndex, 0, musicListModel, busyIndicator, errorLabel)
                }

                background: Rectangle {
                    anchors.fill: button2
                    border.width: 2
                    border.color: "#37E12A"
                    color: button2.checked || button2.hovered ? "#000000" : "#303030"

                    Rectangle {
                        anchors.fill: parent
                        color: parent.color
                        anchors.leftMargin: button2.checked ? parent.border.width : 0
                        anchors.rightMargin: button2.checked ? 0 : parent.border.width
                        anchors.topMargin: button2.checked ? parent.border.width : 0
                        anchors.bottomMargin: button2.checked ? parent.border.width : 0

                        Behavior on color {
                            ColorAnimation { easing.type: Easing.OutQuad; duration: 500 }
                        }
                    }
                }

                contentItem: Text {
                    text: button2.text
                    font.pixelSize: 20
                    verticalAlignment: Text.AlignVCenter
                    color: button2.checked ? "#37E12A" : "#FFFFFF"
                    leftPadding: 100
                    padding: 5
                }
            }

            Rectangle {
                height: 1
                width: parent.width - 2
                color: "#FFFFFF"
            }
        }
    }

    ListView {
        id: listView
        anchors.left: container.right
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.bottom: container.bottom
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        headerPositioning: ListView.OverlayHeader

        model: ListModel {
            id: musicListModel
        }

        header: Rectangle {
            color: container.currentIndex === -1 ? "#000000" : "#303030"
            width: listView.width
            height: container.currentIndex === -1 ? 70 : 30
            z: 2

            property alias searchKeyword: textField.text

            RowLayout {
                visible: container.currentIndex !== -1
                width: parent.width
                height: parent.height
                spacing: 0

                Label {
                    Layout.minimumWidth: parent.width * 2 / 3
                    text: qsTr("歌曲")
                    elide: Label.ElideRight
                    leftPadding: 10
                    color: "#FFFFFF"
                }

                Label {
                    Layout.minimumWidth: parent.width * 2 / 9
                    text: qsTr("歌手")
                    elide: Label.ElideRight
                    color: "#FFFFFF"
                }

                Label {
                    Layout.minimumWidth: parent.width / 9
                    text: qsTr("时长")
                    elide: Label.ElideRight
                    color: "#FFFFFF"
                }
            }

            ColumnLayout {
                visible: container.currentIndex === -1
                spacing: 0
                anchors.fill: parent

                Row {
                    height: 40
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 10

                    TextField {
                        id: textField
                        width: listView.width / 2
                        height: parent.height
                        verticalAlignment: TextField.AlignVCenter
                        leftPadding: 15
                        topPadding: 3
                        bottomPadding: 3
                        placeholderText: qsTr("搜索")
                        selectByMouse: true
                        selectionColor: "#27AFE1"
                        font.pixelSize: 18

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
                            if(textField.text.length > 0)
                                Func.getSearchCount(textField.text, page, busyIndicator, errorLabel);
                            else  colorAnimation.running = true;
                        }
                    }

                    Button {
                        hoverEnabled: true
                        icon.source: "qrc:/images/search.png"
                        padding: 6
                        icon.color: pressed ? "#37E12A" : hovered ? "#B037E12A" : "#FFFFFF"
                        width: 60
                        height: parent.height

                        background: Rectangle {
                            radius: height / 2
                            color: "#E15868"
                        }

                        HoverHandler {
                            cursorShape: Qt.PointingHandCursor
                        }

                        onClicked: {
                            if(textField.text.length > 0)
                                Func.getSearchCount(textField.text, page, busyIndicator, errorLabel);
                            else  colorAnimation.running = true;
                        }
                    }

                    Connections {
                        target: header

                        function onSearch(keyword) {
                            if(keyword.length > 0)  {
                                container.currentIndex = -1;
                                textField.text = keyword;
                                Func.getSearchCount(keyword, page, busyIndicator, errorLabel);
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.fillHeight: true
                    width: parent.width
                    spacing: 0

                    Label {
                        Layout.minimumWidth: parent.width * 1 / 3
                        text: qsTr("歌曲")
                        elide: Label.ElideRight
                        leftPadding: 10
                        color: "#FFFFFF"
                        verticalAlignment: Label.AlignVCenter
                    }

                    Label {
                        Layout.minimumWidth: parent.width * 2 / 9
                        text: qsTr("歌手")
                        elide: Label.ElideRight
                        color: "#FFFFFF"
                        verticalAlignment: Label.AlignVCenter
                    }

                    Label {
                        Layout.minimumWidth: parent.width * 1 / 3
                        text: qsTr("专辑")
                        elide: Label.ElideRight
                        color: "#FFFFFF"
                        verticalAlignment: Label.AlignVCenter
                    }

                    Label {
                        Layout.minimumWidth: parent.width / 9
                        text: qsTr("时长")
                        elide: Label.ElideRight
                        color: "#FFFFFF"
                        verticalAlignment: Label.AlignVCenter
                    }
                }
            }
        }

        delegate: Item {
            width: listView.width
            height: 50

            ItemDelegate {
                id: item
                anchors.fill: parent
                visible: model.songMid !== undefined
                hoverEnabled: true
                enabled: visible && model.songMid.length > 0

                property color itemColor: model.index % 2 ? "#707070" : "#505050"

                background: Rectangle {
                    anchors.fill: item
                    color: item.hovered ? Qt.lighter(item.itemColor, 1.3) : item.itemColor

                    Behavior on color {
                        ColorAnimation { easing.type: Easing.OutQuad; duration: 500 }
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    Image {
                        id: image
                        visible: container.currentIndex !== -1
                        Layout.preferredHeight: parent.height - 5
                        Layout.preferredWidth: parent.height - 5
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        source: model.imageSource.length > 0 ? model.imageSource : "qrc:/images/footerCover.png"

                        onStatusChanged: {
                            if(status === Image.Error)
                                source = "qrc:/images/footerCover.png";
                        }
                    }

                    Label {
                        Layout.preferredWidth: container.currentIndex !== -1 ? parent.width * 2 / 3 - image.width - buttons.width
                                               : parent.width * 1 / 3 - buttons.width
                        leftPadding: 10
                        elide: Label.ElideRight
                        text: model.songName
                        color: item.visible && model.songMid.length <= 0 ? "#000000" : "#FFFFFF"
                    }

                    Row {
                        id: buttons
                        Layout.preferredWidth: 100
                        opacity: item.hovered ? 1 : 0
                        spacing: 5

                        RoundButton {
                            id: playButton
                            hoverEnabled: true
                            width: 40
                            height: 40
                            icon.source: "qrc:/images/play.png"
                            enabled: item.visible && model.songMid.length > 0

                            layer.enabled: hovered
                            layer.effect: DropShadow {
                                radius: 6
                                samples: 13
                                spread: 0.1
                            }

                            onClicked: {
                                let index = musicPlayer.songList.map(function(item) {
                                    return item.songMid;
                                }).indexOf(model.songMid);

                                if(index !== -1) {
                                    if(musicPlayer.playlist.currentIndex !== index)  playMusic(index);
                                    else if(musicPlayer.playbackState !== Audio.PlayingState)  musicPlayer.play();
                                    else  musicPlayer.pause();
                                }
                                else  {
                                    if(model.songMid !== undefined && !model.vip) {
                                        musicPlayer.stop();
                                        page.tempSongList.push({ imageSource: model.imageSource, songName: model.songName,
                                                                   singer: model.singer, albumName: model.albumName, songMid: model.songMid});
                                        Func.getMusicAddress(model.songMid, page, errorLabel, "play");
                                    }
                                }
                            }

                            Binding {
                                target: playButton
                                property: "icon.source"
                                when: musicPlayer.playbackState === Audio.PlayingState && musicPlayer.playlist.currentIndex !== -1 && musicPlayer.songList[musicPlayer.playlist.currentIndex].songMid === model.songMid
                                value: "qrc:/images/pause.png"
                                restoreMode: Binding.RestoreBindingOrValue
                            }
                        }

                        RoundButton {
                            hoverEnabled: true
                            width: 40
                            height: 40
                            icon.source: "qrc:/images/add.png"
                            enabled: item.visible && model.songMid.length > 0

                            layer.enabled: hovered
                            layer.effect: DropShadow {
                                radius: 6
                                samples: 13
                                spread: 0.1
                            }

                            onClicked: {
                                if(musicPlayer.songList.map(function(item) {
                                    return item.songMid;
                                }).indexOf(model.songMid) === -1) {
                                    if(model.songMid !== undefined && !model.vip) {
                                        page.tempSongList.push({ imageSource: model.imageSource, songName: model.songName,
                                                                   singer: model.singer, albumName: model.albumName, songMid: model.songMid});
                                        Func.getMusicAddress(model.songMid, page, errorLabel, "");
                                    }
                                }
                            }
                        }
                    }                   

                    Label {
                        Layout.preferredWidth: parent.width * 2 / 9
                        elide: Label.ElideRight
                        text: model.singer
                        color: item.visible && model.songMid.length <= 0 ? "#000000" : "#FFFFFF"
                    }

                    Label {
                        visible: container.currentIndex === -1
                        Layout.preferredWidth: parent.width / 3
                        elide: Label.ElideRight
                        text: model.albumName
                        color: item.visible && model.songMid.length <= 0 ? "#000000" : "#FFFFFF"
                    }

                    Label {
                        Layout.preferredWidth: parent.width / 9
                        elide: Label.ElideRight
                        text: model.duration
                        color: item.visible && model.songMid.length <= 0 ? "#000000" : "#FFFFFF"

                        Image {
                            visible: model.vip
                            height: item.height - 30
                            width: item.height - 30
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            fillMode: Image.PreserveAspectFit
                            asynchronous: true
                            source: "qrc:/images/vip.png"
                        }
                    }
                }

                onDoubleClicked: {
                    let index = musicPlayer.songList.map(function(item) {
                        return item.songMid;
                    }).indexOf(model.songMid);
                    if(index !== -1) {
                        if(musicPlayer.playlist.currentIndex !== index)  playMusic(index);
                        else if(musicPlayer.playbackState !== Audio.PlayingState)  musicPlayer.play();
                    }
                    else {
                        if(model.songMid !== undefined && !model.vip) {
                            musicPlayer.stop();
                            page.tempSongList.push({ imageSource: model.imageSource, songName: model.songName,
                                                       singer: model.singer, albumName: model.albumName, songMid: model.songMid});
                            Func.getMusicAddress(model.songMid, page, errorLabel, "play");
                        }
                    }
                }
            }

            Row {
                id: row
                visible: model.songMid === undefined
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                spacing: 10

                property int pageCount: model.pageCount
                property int currentPage: model.currentPage

                onVisibleChanged: {
                    if(visible && musicListModel.count > model.index + 1)
                        musicListModel.remove(0, model.index + 1);
                }

                Repeater {
                    model: Math.min(row.pageCount, 5)
                    delegate: Item {
                        width: 30
                        height: 30

                        Button {
                            visible: !elideLabel.visible
                            hoverEnabled: true
                            anchors.fill: parent

                            background: Rectangle {
                                color: parent.pressed ? Qt.darker("#5168B2", 1.5) : parent.hovered ? "#5168B2" : "transparent"
                                border.color: row.currentPage + 1 === parseInt(pageText.text) ? "#37E12A" : "#FFFFFF"
                            }

                            contentItem: Text {
                                id: pageText
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                color: row.currentPage + 1 === parseInt(pageText.text) ? "#37E12A" : "#FFFFFF"

                                Component.onCompleted: {
                                    if(model.index < 2)  text = (model.index + 1).toString()
                                    else if(row.pageCount <= 5)  text = (model.index + 1).toString()
                                    else if(row.currentPage < 4)  text = (model.index + 1).toString()
                                    else text = (row.currentPage + model.index - 2).toString()
                                }
                            }

                            onClicked: {
                                if(parseInt(pageText.text) !== row.currentPage + 1) {
                                    if(container.currentIndex === -1)
                                        Func.getSearchList(parseInt(pageText.text), listView.headerItem.searchKeyword, musicListModel, busyIndicator, errorLabel, page.musicCount);
                                    else
                                        Func.getMusicList(container.currentIndex, parseInt(pageText.text) - 1, musicListModel, busyIndicator, errorLabel)
                                }
                            }
                        }

                        Label {
                            id: elideLabel
                            anchors.fill: parent
                            visible: row.pageCount > 5 && row.currentPage >= 4 && model.index === 1
                            text: qsTr("···")
                            font.pixelSize: 12
                            color: "#FFFFFF"
                            verticalAlignment: Label.AlignVCenter
                            horizontalAlignment: Label.AlignHCenter
                        }
                    }
                }
            }
        }

        ScrollBar.vertical: ScrollBar {
            parent: listView.parent
            anchors.top: listView.top
            anchors.bottom: listView.bottom
            anchors.right: listView.right
            anchors.topMargin: listView.headerItem.height
            anchors.bottomMargin: 50
        }

        BusyIndicator {
            id: busyIndicator
            anchors.centerIn: listView
            width: 100
            height: 100
        }

        Label {
            id: errorLabel
            text: qsTr("数据加载失败")
            color: "red"
            font.pixelSize: 25
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 50
            opacity: 0

            OpacityAnimator {
                id: opacityAnimator
                target: errorLabel
                from: 1
                to: 0
                duration: 1000
                easing.type: Easing.OutQuad
            }
        }
    }

    Connections {
        target: musicPlayer.playlist

        function onCurrentItemSourceChanged() {
            if(musicPlayer.playlist.currentIndex !== -1) {}
        }
    }

    onMusicUrlReady: {
        let index = -1;
        tempSongList.forEach(function(item, i) {
            if(songMid === item.songMid) {
                index = i;
                musicPlayer.songList.push(item);
                musicPlayer.songListChanged();
            }
        });
        if(index !== -1)  tempSongList = tempSongList.slice(index + 1);

        musicPlayer.playlist.addItem(url);

        if(behavior === "play") {
            musicPlayer.playlist.currentIndex = musicPlayer.playlist.itemCount - 1;
            musicPlayer.play();
        }
    }

    onMusicCountReady: {
        musicCount = totalCount;
        Func.getSearchList(1, listView.headerItem.searchKeyword, musicListModel, busyIndicator, errorLabel, totalCount);
    }

    function playMusic(index) {
        musicPlayer.playlist.currentIndex = index;
        musicPlayer.play();
    }

    Component.onCompleted: Func.getMusicList(container.currentIndex, 0, musicListModel, busyIndicator, errorLabel)
}
