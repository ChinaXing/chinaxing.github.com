---
layout: post
title: github 不支持 jekyll 插件的解决方法
category: github
change_frequency: monthly
---

### 问题描述:

为了能够利用jekyll生成blog的文章分类列表.经过网上搜索，得知需要使用插件，使用方法是在jekyll的目录
下面建立_plugins目录，里面放置插件，jekyll会自动调用.

可惜的是github.com并不支持jekyll的插件功能，所以一番折腾白费.

解决方法只有在本地jekyll生成静态页面后再git push到github.com.

github.com约定如果master分支的根目录下有.nojekyll这个文件，就对该目录不做jekyll处理，
直接作为静态页面输出。

### 解决方法:

* __建立2个分支：dev和master.__  

   dev 放置原始文件，供jekyll转换使用，master分支放置jekyll生成的静态页面.

* __在本地搭建jekyll环境，git clone blog网站的内容到本地__.  

   1. 切换到dev分支写文章:  

           git checkout dev

   1. 写文章，写好文章后:  

           jekyll --server --auto 

   1. 在本地浏览器访问看一切正常后.  

      提交新文章到库

           git commit -am '---添加文章---'

   1. 提交静态页面到master分支  

           commitID=$(echo "--添加新文章--" | git commit-tree dev^{tree}:_site)
           git update-ref refs/heads/master $commitID
           git checkout master
           git push -f origin master

