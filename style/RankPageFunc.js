function getMusicList(index, currentPage, listModel, busyIndicator, errorLabel) {
    let newListUrl = "https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?g_tk=5381&uin=0&format=json&inCharset=utf-8"
        + "&outCharset=utf-8¬ice=0&platform=h5&needNewCode=1&tpl=3&page=detail&type=top&topid=27&_=1519963122923";

    let randomListUrl = "https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?g_tk=5381&uin=0&format=json&inCharset=utf-8"
        + "&outCharset=utf-8¬ice=0&platform=h5&needNewCode=1&tpl=3&page=detail&type=top&topid=36&_=1520777874472";

    let imageSourceUrl = "http://imgcache.qq.com/music/photo/album_300/%1/300_albumpic_%2_0.jpg";
    let itemsPerPage = 20;

    busyIndicator.running = true;
    errorLabel.visible = false;

    let xhr = new XMLHttpRequest;
    xhr.onreadystatechange = function() {
        if(xhr.readyState === XMLHttpRequest.DONE) {
            if(xhr.status >= 200 && xhr.status < 300 || xhr.status === 304) {
                listModel.clear();

                let text = xhr.responseText;
                if(text.startsWith("callback"))
                    text = text.substring(9, text.length - 1);

                let data = JSON.parse(text);
                let pageCount = Math.ceil(data.songlist.length / itemsPerPage);

                let begin = currentPage * itemsPerPage;
                for(let i = begin ; i < itemsPerPage + begin && i < data.songlist.length; i ++) {
                    let song = data.songlist[i].data;
                    let imageSource = song.albumid === 0 ? "" : imageSourceUrl.arg(song.albumid % 100).arg(song.albumid);
                    let songName = song.songname;
                    let singer = song.singer.map(function(item) {
                        return item.name;
                    }).join(" | ");

                    let duration = song.interval > 0 ? formatDuration(song.interval) : "--";
                    let songMid = song.songmid;
                    let albumName = song.albumname;
                    let vip = song.pay.payplay;

                    listModel.append({ imageSource: imageSource, songName: songName, singer: singer, songMid: songMid,
                                         duration: duration, albumName: albumName, vip: vip, pageCount: pageCount, currentPage: currentPage });

                }

                listModel.append({ imageSource: "", songName: "", singer: "", /*songMid: undefined,*/ duration: "", albumName: "",
                                     pageCount: pageCount, currentPage: currentPage });

                busyIndicator.running = false;
                errorLabel.parent.positionViewAtBeginning();
            }
            else {
                busyIndicator.running = false;
                errorLabel.visible = true;
                errorLabel.opacityAnimator.running = true;
            }
        }
    }

    let url;
    switch(index)
    {
    case 0:
        url = newListUrl;
        break;

    default:
        url = randomListUrl;
        break;
    }

    xhr.open("GET", url, true);
    xhr.send(null);
}

function formatDuration(duration) {
    let minutes = Math.floor(duration / 60);
    let seconds = duration - minutes * 60;

    let result = "";
    if(minutes < 10)  result += "0" + minutes.toString();
    else  result += minutes.toString();

    if(seconds < 10)  result += ":0" + seconds.toString();
    else  result += ":" + seconds.toString();

    return result;
}

function getMusicAddress(songMid, page, errorLabel, behavior) {
    let addressUrl = "https://api.zsfmyz.top/music/song?songmid=%1&guid=126548448";

    let xhr = new XMLHttpRequest;
    xhr.onreadystatechange = function() {
        if(xhr.readyState === XMLHttpRequest.DONE) {
            if(xhr.status >= 200 && xhr.status < 300 || xhr.status === 304) {
                let data = JSON.parse(xhr.responseText);

                if(errorLabel !== undefined)  page.musicUrlReady(data.data.musicUrl, songMid, behavior);
                else  page.musicUrlUpdate(data.data.musicUrl, songMid, behavior);
            }
            else if(errorLabel !== undefined) errorLabel.opacityAnimator.running = true;;
        }
    };

    xhr.open("GET", addressUrl.arg(songMid), true);
    xhr.send(null);
}

function getSearchList(currentPage, keyword, listModel, busyIndicator, errorLabel, totalCount) {
    let itemsPerPage = 60;
//    let searchUrl = "https://c.y.qq.com/soso/fcgi-bin/client_search_cp?aggr=1&cr=1&flag_qc=0&p=%1&n=" + itemsPerPage + "&w=%2";
    let searchUrl = "https://c.y.qq.com/soso/fcgi-bin/client_search_cp?p=%1&n=%2&w=%3";
    let imageSourceUrl = "http://imgcache.qq.com/music/photo/album_300/%1/300_albumpic_%2_0.jpg";

    busyIndicator.running = true;
    errorLabel.visible = false;
    listModel.clear();

    let xhr = new XMLHttpRequest;
    xhr.onreadystatechange = function() {
        if(xhr.readyState === XMLHttpRequest.DONE) {
            if(xhr.status >= 200 && xhr.status < 300 || xhr.status === 304) {
                let text = xhr.responseText;
                if(text.startsWith("callback"))
                    text = text.substring(9, text.length - 1);

                let data = JSON.parse(text);
                let songList = data.data.song.list;
                let pageCount = Math.ceil(totalCount / itemsPerPage);

                songList.forEach(function(song) {
                    let imageSource = song.albumid === 0 ? "" : imageSourceUrl.arg(song.albumid % 100).arg(song.albumid);
                    let songName = song.songname;

                    let singer = song.singer.map(function(item) {
                        return item.name;
                    }).join(" | ");

                    let duration = song.interval > 0 ? formatDuration(song.interval) : "--";
                    let songMid = song.songmid;
                    let albumName = song.albumname;
                    let vip = song.pay.payplay;

                    listModel.append({ imageSource: imageSource, songName: songName, singer: singer, songMid: songMid,
                                         duration: duration, albumName: albumName, vip: vip, pageCount: pageCount, currentPage: currentPage-1 });
                });

                listModel.append({ imageSource: "", songName: "", singer: "", /*songMid: undefined,*/ duration: "", albumName: "",
                                     pageCount: pageCount, currentPage: currentPage-1 });

                busyIndicator.running = false;
                errorLabel.parent.positionViewAtBeginning();
            }
            else {
                busyIndicator.running = false;
                errorLabel.visible = true;
                errorLabel.opacityAnimator.running = true;
            }
        }
    };

    xhr.open("GET", searchUrl.arg(currentPage).arg(Math.min(itemsPerPage, totalCount - (currentPage-1) * itemsPerPage)).arg(keyword), true);
    xhr.send(null);
}

function getSearchCount(keyword, page, busyIndicator, errorLabel) {
    let url = "https://c.y.qq.com/soso/fcgi-bin/client_search_cp?p=0&n=0&w=%1";

    busyIndicator.running = true;
    errorLabel.visible = false;

    let xhr = new XMLHttpRequest;
    xhr.onreadystatechange = function() {
        if(xhr.readyState === XMLHttpRequest.DONE) {
            if(xhr.status >= 200 && xhr.status < 300 || xhr.status === 304) {
                let text = xhr.responseText;
                if(text.startsWith("callback"))
                    text = text.substring(9, text.length - 1);

                let data = JSON.parse(text);
                let totalCount = data.data.song.totalnum;

                if(totalCount > 0)  page.musicCountReady(totalCount)
                else busyIndicator.running = false;
            }
            else {
                busyIndicator.running = false;
                errorLabel.visible = true;
                errorLabel.opacityAnimator.running = true;
            }
        }
    };

    xhr.open("GET", url.arg(keyword), true);
    xhr.send(null);
}
