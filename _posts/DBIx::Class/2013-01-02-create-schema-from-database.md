---
layout: post
title: 从数据库自动生成DBIx::Class使用的Schema
category: Perl
change_frequency: monthly
tag: DBIx::Class
---

如果数据库和表已经存在，则我们不需要手动创建Schema，可以使用[DBIx::Class::Schema::Loader](http://search.cpan.org/~rkitover/DBIx-Class-Schema-Loader-0.07033/lib/DBIx/Class/Schema/Loader.pm)这个模块来自动生成Schema.

### 下面是几种方法：

- 使用make_schema_at 方法

       perl -MDBIx::Class::Schema::Loader=make_schema_at <<EOF
       make_schema_at({
          'My::Schema',
          { debug =>1, dump_directory => './'},
          [ 'dbi:Pg:dbname="pesystem"','pesystem','pesystem_password' ],
       });
       EOF

- 使用dbicdump工具  
  该工具其实内部使用了DBIx::Class::Schema::Loader模块. 

       dbicdump -o dump_directory='./' My::Schema 'dbi:Pg:dbname="pesystem" "pesystem" "pesystem_password"

- 使用dump_to_dir方法，如果你的Schema模块已经写好.  
  让模块继承DBIx::Class::Schema::Loader,然后执行:

       #My/Schema.pm
       pakcage My::Schema;
       use base qw/DBIx::Class::Schema::Loader/;
       1;

       perl -MDBIx::Class::Schema::Loader=dump_to_dir:./ -MMy::Schema \
           -e 'My::Schema->connection("dbi:Pg:dbname=pesystem","pesystem","pesystem_password")'
       # or 
       use My::Schema;
       My::Schema->dump_to_dir('./');
       My::Schema->connection(...);

   参见:<http://search.cpan.org/~rkitover/DBIx-Class-Schema-Loader-0.07033/lib/DBIx/Class/Schema/Loader.pm#dump_to_dir>

   继承DBIx::Class::Schema::Loader后，每次连接都会进行扫描数据库获取Schema.


### 比较：
使用dbicdump工具比较简单易用.
