---
layout: post
title: use github pages to write blog
category: github
---

### jekyll：从标记语言生成HTML页面

Jekyll: <https://github.com/mojombo/jekyll/wiki>

目录结构:

    |-- CNAME
    |-- _config.yml
    |-- _layouts
    |   |-- category_index.html
    |   |-- default.html
    |   `-- post.html
    |-- _plugins
    |   `-- category_index_generator.rb
    |-- _posts
    |   |-- default
    |   |   `-- 2012-12-14-test.md
    |   `-- github
    |       `-- 2012-12-04-use-github-blogging.md
    |-- images
    |   |-- arrow-down.png
    |   `-- octocat-small.png
    |-- index.html
    |-- javascripts
    |   `-- scale.fix.js
    |-- params.json
    `-- stylesheets
        |-- pygment_trac.css
        `-- styles.css


* 非'_'开头的目录jekyll不会进行处理，原样copy进_site目录.

* 生成的网站在_site目录.github会自动将请求转至这里.

* 默认的jekyll功能有限，通过开发插件(在_plugins目录).

### Mardown : 标记语言

Markdown: <http://daringfireball.net/projects/markdown/>

类似HTML是一种标记语言

特色:

* 易写,易读.

* 流行,被多数站点和工具支持(stackoverflow,github等).

* 适合程序员用.

语法:<http://justjavac.com/jekyll/2012/03/31/markdown-syntax.html>


