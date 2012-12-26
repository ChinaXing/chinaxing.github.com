---
layout: post
title: figlet 一个ascii字符字体的字符串打印工具
category: linux
change_frequency: monthly
---

### figlet 介绍

**figlet** -- print string use Figlet Font

看个例子就能明白了:

<pre style="line-height:1em">
     _   _      _ _        __        __         _     _   _ 
    | | | | ___| | | ___   \ \      / /__  _ __| | __| | | |
    | |_| |/ _ \ | |/ _ \   \ \ /\ / / _ \| '__| |/ _` | | |
    |  _  |  __/ | | (_) |   \ V  V / (_) | |  | | (_| | |_|
    |_| |_|\___|_|_|\___/     \_/\_/ \___/|_|  |_|\__,_| (_)
</pre>

**Figlet Font** 就是指用ascii字符拼出来的字体，在figlet的[官网][Figlet]
上我们可以看到字体的示例.

**figlet**有windows(MS-DOS),unix,Macintosh(mac os),等等的版本，都可以在其官网上下载.

字体也有很多我们也可以从其官网上下载得到.

### 实例演示：

    $ figlet china xing !


<pre style="line-height:1em">
          _     _                    _               _ 
      ___| |__ (_)_ __   __ _  __  _(_)_ __   __ _  | |
     / __| '_ \| | '_ \ / _` | \ \/ / | '_ \ / _` | | |
    | (__| | | | | | | | (_| |  >  <| | | | | (_| | |_|
     \___|_| |_|_|_| |_|\__,_| /_/\_\_|_| |_|\__, | (_)
                                         |___/     
</pre>

_-f_ 指定字体:

    $ figlet -w 104 -f script  ChinaXing !


<pre style="line-height:1em">
      ___  _                      _                         
     / (_)| |    o               (_\  /  o                 |
    |     | |        _  _    __,    \/       _  _    __,   |
    |     |/ \   |  / |/ |  /  |    /\   |  / |/ |  /  |   |
     \___/|   |_/|_/  |  |_/\_/|_/_/  \_/|_/  |  |_/\_/|/  o
                                                  /|    
                                                  \|
</pre>

[Figlet]: http://www.figlet.org/
