function getLyric(songMid, listModel, musicPlayer) {
    let url = "https://api.zsfmyz.top/music/lyric?songmid=%1";

    let xhr = new XMLHttpRequest;
    xhr.onreadystatechange = function() {
        if(xhr.readyState === XMLHttpRequest.DONE) {
            listModel.clear();

            if(xhr.status >= 200 && xhr.status < 300 || xhr.status === 304) {
                let text = xhr.responseText;
                if(text.startsWith("callback"))
                    text = text.substring(9, text.length - 1);

                let data = JSON.parse(text);

                if(songMid === musicPlayer.songList[musicPlayer.playlist.currentIndex].songMid) {
                    let rex = /(\[\d+:\d+(\.\d+)?\])+(.*)/g;
                    let text = data.data.lyric;
                    let result;
                    while((result = rex.exec(text)) !== null) {
                        let content = result[3];
                        if(content !== null)
                            content = content.trim();

                        if(content !== undefined && content.length > 0) {
                            let times = result[1].split(/\[|\]/);
                            times.forEach(function(item) {
                                let re = /(\d+):(\d+)(\.(\d+))?/;
                                let ret = re.exec(item);
                                if(ret !== null) {
                                    let time = parseInt(ret[1]) * 60000 + parseInt(ret[2]) * 1000;
                                    if(ret[4] !== null)  time += parseInt(ret[4]) * 10;

                                    let count = listModel.count;
                                    for(let i = 0; i < count; i ++) {
                                        if(time < listModel.get(i).time) {
                                            listModel.insert({ time: time, content: content });
                                            break;
                                        }
                                    }

                                    if(count === listModel.count)
                                        listModel.append({ time: time, content: content});
                                }
                            });
                        }
                    }
                }
            }
        }
    };

    xhr.open("GET", url.arg(songMid), true);
    xhr.send(null);
}

function getLyricIndex(time, listModel) {
    let index = -1;
    for(let i = listModel.count - 1; i >= 0; i --) {
        if(time >= listModel.get(i).time) {
            index = i;
            break;
        }
    }

    return index;
}
