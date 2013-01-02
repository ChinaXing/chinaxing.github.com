---
layout: post
title: django messages framework
category: django
change_frequency: monthly
---

django 的messages中间件类似其它语言框架(perl mojolicous)的flash功能。目的是
实现一个请求中注入信息，另一个请求中可以读取。

实现方式为cookie存储或者session存储或者其它自定义存储方式。

messages 还有一些功能：

1. 消息的级别(LEVEL) 类型日志级别有__DEBUG~ERROR__。可以设置级别(MESSAGE_LEVEL变量)来过滤低于此级别的消息。
2. 消息有Tags，通常用来在显示消息的时候当做HTML的类。默认的tag和消息的LEVEL同名的小写字符串。
3. 消息的过期。消息在每次读取后便过期，系统自动标记为过期，在请求结束时候回收，可以人为的在读取消息后设置为"未使用"，来让消息不过期。

         storage = messages.get_messages(request)
         for message in storage:
             do_something_with(message)
         storage.used = False # 此处标记消息未被使用，系统便不会回收消息
4. 同一个客户端的请求可能会导致消息被串掉(原因是浏览上下文的重叠)。但大多数浏览器和HTML5中不存在这个问题。