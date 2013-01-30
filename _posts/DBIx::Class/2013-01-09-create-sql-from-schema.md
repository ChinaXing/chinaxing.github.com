---
layout: post
title: 从DBIx::Class的Schema类生成SQL语句
category: Perl
change_frequency: monthly
---

[DBIx::Class::Admin](http://search.cpan.org/perldoc?DBIx%3A%3AClass%3A%3AAdmin) 模块提供了数据库管理的一些功能，如：部署,升级版本，更新数据，插入数据，删除，查询和生成数据库SQL表。

这个模块还附带了一个命令行的工具：__dbicadmin__,帮助我们不必写perl脚本就可以使用它的功能。

### 从Schema生成SQL语句

    dbicadmin --schema=PeSystem::Schema \
    --connect='["db:Pg:dbname=pesystem","dbuser","dbpassword"]' \
    --op=create --sql-type=PostgreSQL --sql-dir=./sql/

这条命令在`./sql/`下生成`PeSystem::Schema`的SQL语句`PeSystem-Schema-1.x-PostgreSQL.sql`。