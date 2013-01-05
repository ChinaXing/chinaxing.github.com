---
layout: post
title: Perl DBIx::Class 模块学习笔记
category: Perl
change_frequency: monthly
tag: DBIx::Class
---
### 目录
{:.no_toc}
* 
{:toc}
<hr>

**Perl** 的ORM模块中，DBIx::Class是比较强大和完善的。文档丰富，容易使用。

DBIx::Class的官网:<http://www.dbix-class.org/>,此外也可以在cpan上搜索，它的代码和文档都放在cpan上。

### ORM好处

ORM模块的作用是将数据库操作和表示映射成对象，方便编程，屏蔽数据库层的具体操作。
使用ORM模块/程序操作数据库，通过调用ORM模块提供的函数/方法等完成，不需要写SQL语句（虽然ORM模块也允许直接写SQL），不需要处理复杂的数据库SQL语句和特殊的数据库连接、转换等具体问题。

因为有如此多好处，Web开发框架一帮都会集成ORM功能，如果没有集成，程序员也可以将其引入。

### DBIx::Class介绍
DBIx::Class 的入门介绍可以看[这里](<http://search.cpan.org/~getty/DBIx-Class-0.08204/lib/DBIx/Class/Manual/Intro.pod)

#### DBIx::Class中有如下概念
- Schema
- Result(ResultSource)
- ResultSet
- Row

1. Schema: 表示数据库。  
   1. 连接数据库

          my $schema1 = My::Schema->connect(....)
   2. 取得Result

          $schema1->source('table1')
   3. 取得ResultSet

          $schema1->resultset('table1')
2. Result: 表示表  
   1. 定义在MySchema/Result/下:

          #MySchema/Result/Table1.pm
          package MySchema::Result::Table1;
          use base qw/DBIx::Class:core/;

          __PACKAGE__->table('table1');
          __PACKAGE__->add_columns(qw/col1 col2/);
          ...
3. ResultSet: 表示查询  
   1. 如果有则定义在MySchema/ResultSet/下,表示对默认Resultet类的扩展，如加入自定义的方法。
 [扩展方法](http://search.cpan.org/~getty/DBIx-Class-0.08204/lib/DBIx/Class/ResultSet.pm#CUSTOM_ResultSet_CLASSES_THAT_USE_Moose)
   2. 取得ResultSet/准备查询

          $schema1->resultset('table1')
          resultset执行search方法后还是resultset。并没有真正执行。
   3. 执行查询，取得执行结果(Row)

          @rows=$resultset->all();
          $row=$resultset->find(1);
4. Row: 代表查询结果里面的行。  
   1. 取得row里面的数据:

          $row->get_columns;
          $row->get_column('col1');
          $row->col1;

5. storage: 存储  
   涉及具体数据库的通用存储层，下面的子类是其各个数据库的具体连接实现的DBI。
   1. 取得storage

          $storage = $schema->storage;


### 其它
1. 调试: 

       $schema->storge->debug(1);
   可以打印出SQL语句。
2. 相关连接：
   - DBIx::Class 所有模块的列表:<http://search.cpan.org/dist/DBIx-Class/>
   - DBIx::Class 官网:<http://www.dbix-class.org/>
   - DBIx::Class Manule:<http://search.cpan.org/dist/DBIx-Class/lib/DBIx/Class/Manual.pod>

