---
layout: post
title: cygwin 下安装jekyll
category: jekyll
---

Windows 下cygwin可以模拟Linux环境.于是打算用cygwin+jekyll 来作写博客的环境.

安装jekyll在cygwin下面没有在linux下那样顺利，下面记录下我的安装过程:

1. __ 从cygwin安装基础软件__

   cygwin安装时候选择安装ruby,rake,gcc4,gcc4-g++,make,git,openssh等开发工具安上.

   安装上工具之后,gem 工具就安装好了.

2. __通过gem 安装jekyll环境__
   首先安装 rake-compiler:

        gem install rake-compiler

   安装posix-spawn这个库，gem自带的有问题，需要从github上安装:

        git clone git://github.com/rtomayko/posix-spawn.git
        cd posix-spawn
        rake gem #此处用到了rake-compiler
        gem install pkg/posix-spwan-0.3.6

   安装好posix-spawn这个库后，安装jekyll:

        gem install jekyll

   jekyll就可以使用了:)

