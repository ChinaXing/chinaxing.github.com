---
layout: post
title: Linux man 命令查找man手册的策略
category: linux
change_frequency: monthly
---

本文的知识是从man man命令得到。在这里记录只为了备忘和方便，可以使用man man
来获得纤细的说明。

man 命令是我们经常使用的一个命令，那么当你执行:`man [command]`的时候，
man命令是如何查找命令的手册呢？

根据man命令的帮助文档，我得到了如下信息:

### 查找策略 

man 命令查找命令帮助手册的策略:  

* 命令行指定**-M**参数，那么man命令使用这个目录搜索。否则,
* 使用**MANPATH**环境变量指定的路径进行搜索.否则,
* 查看/etc/man.config，找到其中的**MANPATH**配置，加入搜索路径. 然后,
* 查看/etc/man.config, 找到其中的**MANPATH_MAP**配置，加入搜索的"Map"路径，然后,
* 遍历**PATH**变量中的每个路径,对不在**MANPATH_MAP**中的路径, 执行"nearby"查找。
* 在搜索路径中进行查找.


### 说明:

1. "Map"路径:  
   这种路径相当于一张hash表，前面是命令所在的PATH搜索路径，后面是man手册的查找路径，man 会根据这个hash表查找该命令的man手册.   
   **举例**:  
   1. 设置:`MANPATH_MAP /home/admin/git/bin /home/admin/git/man/`  
   当执行: `man git` 的时候，**man**会根据**PATH**查找`git`这个命令的位置，在`/home/admin/git/bin`下找到了,
所以根据设置的hash表，在`/home/admin/git/man`这个路径下查找git的手册.

   2. 设置:`MANPATH_MAP /bin /home/admin/git/man`  
   但执行: `man git` 的时候，**man**会根据**PATH**查找`git`命令的位置，在`/home/admin/git/bin`下面找到了，但是根据hash，
没有这个路径对应的man手册搜索路径，所以这条MANPATH_MAP不会被使用.

2. man查找对象:  
    查找对象为`topic.section`,如果没找到，则查找`man[section]/topic.section`,如:`man1/git.1` .

3. nearby查找:  
    nearby查找查找什么呢？  
    通过我实验，会在本目录先查找`man`,如果没找到, 然后查找`man[section]`目录  
    如果找到`man[section]`目录则将当前目录加入搜索路径,找到`man`目录将`当前目录/man`加入搜索路径.


### 其它
查看找到的手册的位置:

    $ man --path cat
    /usr/share/man/man1/cat.1.gz

查看man命令查找手册的过程:

    $ man -D cat
    Reading config file /etc/man.config
    found man directory /usr/man
    found man directory /usr/share/man
    found man directory /usr/local/man
    found man directory /usr/local/share/man
    found man directory /usr/X11R6/man
    found manpath map /bin --> /usr/share/man
    ...

