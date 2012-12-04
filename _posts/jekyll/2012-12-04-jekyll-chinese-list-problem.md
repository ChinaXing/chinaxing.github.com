---
layout: post
title: jekyll markdown中文列表无法解析的问题
category: jekyll
---

### 解决方法
默认的markdown解析引擎有问题

配置_config.yml,将markdown解析引擎换为rdiscount:

    markdown: rdiscount

问题解决:)
