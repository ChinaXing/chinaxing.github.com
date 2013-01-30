---
layout: post
title: 用Anyevent监控目录/文件变动
category: Perl
change_frequency: monthly
---

### module: 
[AnyEvent::Filesys::Notify](http://search.cpan.org/~mgrimes/AnyEvent-Filesys-Notify-0.18/lib/AnyEvent/Filesys/Notify.pm)

这个模块可以监控一个或若干目录内文件的变更事件，使用AnyEvent事件处理框架，可以指定后端或者由该模块自动进行选择最优的后端。

### 后端可以是：

* 定时扫描（比较低效，而且费资源）
* 使用内核的inotify机制（linux系统），kqueue机制（BSD）等各个操作系统提供的文件内核事件通知机制。  
  特点是高效，及时，需要相对新版本的内核。
* 其它自定义的。

在Linux平台上，我们一般指定Linux::Inotify2为其后端，这个模块封装了inotify系统特性。

也可以直接使用Linux::Inotify2这个模块进行对文件和目录进行监控，具体使用方法可以参看其cpan描述。

这个模块提供了callback的编程方式和file-handler的编程方式，前者可以进行非组塞的使用，后者可以将其集成到AnyEvent
等事件编程框架中，因为它在被监控文件发生变动时，会触发file-handler可读的事件，从而被监控其file-handler IO的AnyEvent 捕获知晓。


_待补充和完善_