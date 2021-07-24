## 基于Qt Quick的在线音乐播放器

### 简要说明

​		本项目是一个在线音乐播放器的简单练习项目，主要使用`Qt Quick`和少量的`javascript`，实现了搜索歌曲，查看最新的推荐音乐列表和播放控制等基础功能。

​		**本项目使用的接口已失效，现在可以搜索歌曲但无法播放。**

### 工具

`Qt Creator 4.14.0` `+` `Qt 5.15.2`

### 界面和逻辑

界面使用`QML`编写，使用的控件都是经常用的。逻辑使用`javascript`，主要是网络请求需要用到`javascript`，也可以在`C++`中实现网络功能后导入到`QML`中，本项目通过`javascript`实现网络请求。

### 音乐接口

音乐接口使用的是`QQ`音乐`API`，下面列出用到的接口：

新歌排行榜：用来获取最新的`Top100`音乐

```
https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?g_tk=5381&uin=0&format=json&inCharset=utf-8"
        + "&outCharset=utf-8¬ice=0&platform=h5&needNewCode=1&tpl=3&page=detail&type=top&topid=27&_=1519963122923
```



随机推荐：获取随机推荐列表

```
https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?g_tk=5381&uin=0&format=json&inCharset=utf-8"
        + "&outCharset=utf-8¬ice=0&platform=h5&needNewCode=1&tpl=3&page=detail&type=top&topid=36&_=1520777874472
```



搜索：其中`%1`需换成请求的页数，`%2`需换成请求的数量，`%3`需换成搜索关键字，该请求在测试时每页最多返回`60`首歌曲信息，故项目中搜索时每页请求数最多为`60`。

```
https://c.y.qq.com/soso/fcgi-bin/client_search_cp?p=%1&n=%2&w=%3
```



专辑图片：通过以上三个接口可以获得歌曲信息，其中有个`albumid`属性，将下面地址的`%1`换成`albumid % 100`，`%2`换成`albumid`即可获取专辑图片。

```
http://imgcache.qq.com/music/photo/album_300/%1/300_albumpic_%2_0.jpg
```



歌曲地址：将`%1`换成歌曲信息中的`songmid`属性即可。

```
https://api.zsfmyz.top/music/song?songmid=%1&guid=126548448
```



关于接口的更多描述可以参考：

[https://www.siediyer.cn/?p=1165](https://www.siediyer.cn/?p=1165)

[https://github.com/lunhui1994/node-music-api](https://github.com/lunhui1994/node-music-api)

[http://www.bubuko.com/infodetail-3480251.html](http://www.bubuko.com/infodetail-3480251.html)

其中有些接口已经失效

### 问题

​		在使用`https`请求时很可能出现`TLS initialization failed`或类似错误，解决方法在[这里](https://blog.csdn.net/ypp240124016/article/details/111057879)可以找到。在获取到歌曲地址后传递给播放器时可能出现`[DirectShowPlayerService::doRender: Unresolved error code 0x80040266 ()]`或类似错误，好像是由于无法解码，如果会用一些音频库的话应该可以解决，或者下载` K-lite codecs`并安装也可解决，可参考[这里](https://stackoverflow.com/questions/53328979/directshowplayerservicedorender-unresolved-error-code-0x80040266)。