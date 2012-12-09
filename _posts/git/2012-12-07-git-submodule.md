---
layout: post
title: git submodule 学习笔记
category: git
change_frequency: monthly
---

### git help 解释:
    git-submodule - Initialize, update or inspect submodules

### 说明:

  git 中的submodule是为了解决项目中依赖别的库，submodule即为依赖的库，方便库的更新，管理。

  每个submodule都是一个库，这样可以看到一个大的仓库中包含小的若干仓库，在实际开发中是常见的。

### 命令:

    git submodule add 
    git submodule init
    git submodule update
    
    git submodule summary
    ...

  这些命令完成submodule的添加，初始化(注册到本仓库，然后可以被跟踪到)，更新仓库内容，查看摘要等。纤细的命令可以通过
`git submodule --help`获得

### 内部机制：
   git 的主仓库对于submodule的管理是通过如下文件来进行:`.gitmodules`,`.git/config`,`.git/modules/`

  * .gitmodules 内容如下:   

    [submodule "libs/lib2"]
            path = libs/lib2
            url = ../../repos/lib2.git

   这个文件在git submodule add的时候生成

  * .git/config 在git submodule init 的时候生成

  * .git/modules/ 在git submodule add的时候生成，里面是submodule的内容

  主仓库根据submodule的commit ID来跟踪submodule。

  当submodule做了commit的或者work tree改动的时候，主仓库能够通过git status查看到。需要在主仓库再commit一下，
更新主仓库引用的submodule的 commit ID。

