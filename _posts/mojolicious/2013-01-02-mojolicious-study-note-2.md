---
layout: post
title: Mojolicious 学习笔记
category: Perl
change_frequency: monthly
tag: Mojolicious
---

**Mojolicous** : <http://mojolicio.us/>

### Mojolicous结构：
- route 路由，  
   根据request进行路由，可以根据：url,param,format,method等进行路由

- controller,   
   路由的目的地是controller中的某个action，由此action来处理。一个controller一个perl模块，包含多个action作为subrutine。  
   controller是Mojolicious::Controller的子类。  
   默认的controller是Mojolicious::Controller,通过$app->controller_class('PeSystem::Controller') 设定$app的默认controller.  
   controller获得app:`$self->app`  
   controller获得请求:`$self->req`  
   controller获得路由匹配的参数:`$self->stash('id')`  
   controller的一些helpers:Mojolicious::Plugin::Defaulthelps，它包含dumper,stash,url_encode等方法方便使用(`$self->stash('a'=>'b')`)

- action  
   action是controller内的子过程。操作都是在action内进行的.  
   渲染页面:`$self->render('...'),$self->render_exception,$self->redirect_to(...),$self->render `,如果controller没有显式渲染，controller返回后页面会被自动渲染。

- template  
  模版，根据format的不通会自动选择不通的模版:$namespace/$controller/$action.$format.ep, ep结尾表示mojo的内置模版类型（可以嵌入perl）  
  异常模版: exception.$mode.$format.ep,exception.$format.ep, $mode为mojo运行的模式（如production,development）
  404模版:not_found.$mode.$format.ep,not_found.$format.ep

- 异常:
  Mojo::Exception 是其异常类  
  Mojo是通过local $SIG{__DIE__}来注册自己的异常捕获的。  
  主动抛出异常用die "string",用Mojo::Exception->throw('string')不会携带上下文信息.  
  controller的render_exception用来渲染异常页面，它会示例化Mojo::Exception类，然后渲染，同样也不会带上下文信息，所以建议不主动使用.  
  捕获异常: 

       eval {code } or do { die "xxx" }

- helper,  
  辅助工具，默认的/自带的Mojolicious::Plugin::DefaultHelpers 包含stash,dumper等方法.  
  也可以自己方便地写helper。

- plugin,  
  插件，许多功能通过插件来添加到Mojo.如Config插件，  
  使用插件：

       $self->app->plugin('Config',{file => 'pesystem.conf')

- hook,  
  埋点和回调，可以在请求处理和响应的各个阶段进行回调函数的挂入来完成高级自定义。如Exception的处理就是hook来实现的。

- command 模块，提供命令行选项功能和启动app的功能。

- daemon 模块，实现daemon，继承了command模块。

- Hypnotoad模块，实现服务器进程，热部署，websocket支持，非阻塞服务器。

- websocket,mojo支持websocket

- CGI，PSGI，mojo 支持部署方式为PSGI。

- Test::Mojo, 测试模块

- Useragetn模块

- morbo 检测代码变化，自动重起，开发环境使用


### Web开发实践:
1. 数据库：DBIx::Class
2. Form: HTML::FormHandler可以完成很多，很强大。 HTML::FormHandler::TraitFor::Model::DBIC实现和数据库关联
