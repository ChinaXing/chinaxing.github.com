---
layout: post
title: Hight availability in postgresql
category: postgres
change_frequency: monthly
---
### 目录
{:.no_toc}
* 
{:toc}
<hr>


本文概要: Postgresql 的备份,恢复,热备,复制等机制的说明.


### Postgresql的数据库备份

#### 使用pg_dump进行备份

pg_dump类似mysql的mysql_dump工具，可以对数据库中的一个和若干数据库进行备份生成一个sql文件。

pg_dumpall是对整个数据库进行备份。


**注意**使用pg_dump生成的备份在恢复后，不能使用原来数据库的archive WAL日志进行replay。

#### 使用linux工具对数据库进行整体备份

1. 在数据库上执行命令: 

       select pg_start_backup('备份标签')

   此步骤让wal的写出变成以记录为单位写，并且执行一次checkpoint，主要是为了wal日志的一致性.
2. 使用cp或者tar之类的linux命令工具备份整个数据集群的目录.如:

       tar czf pgsql_DB.tar pgsql_DB  

   可以不备份pg_xlog下面的文件,而且这个目录下面的日志可能是和备份的数据库不一致的。
3. 在数据库上执行命令:

       select pg_stop_backup()

   此步骤生成一个标记文件,格式为:`段名.段内位置.backup`，`段名`表示进行备份时候数据库正写入的wal日志段.通过这个文件可以知道一次备份的位置.

   `pg_stop_backup()`还执行了一次"**段切换**",切换到新的段,如果设置了归档(archive_mode = on),则等待上一段完成归档。

   这样被归档的段和备份一起构成了一个和当前数据库一致的备份.

#### 使用pg_basebackup

`pg_basebackup` 命令执行整体备份，作用和上面的**linux工具备份**一样。相对于上一个备份比较容易，不过有一个要求:需要一个具有`replication`权限的用户，pg_basebackup是用这个用户链接数据库，完成备份。

### 恢复
#### 恢复类型:
1. 若备份采用pg_dump/pg_dumpall 来进行，恢复的时候只能恢复到备份时刻的状态.
2. 若备份使用的是pg_basebackup或者和其功能一样的方法生成的备份,恢复时候可以通过回放wal日志恢复到_"最近"_的状态。

#### pg_dump备份的恢复:
1. 新建立数据库: 

       pg_ctl init -D pgsql_DB

2. 从备份文件执行备份的sql: 

       psql pgdql.backup.sql

#### pg_basebackup备份的恢复:
1. 解压缩备份: 

       tar xzf pgbackup.tar

2. 在数据集目录新建`recovery.conf`文件,此文件指导postmaster完成恢复:

       cp /usr/local/pgsql/share/recovery.conf.sample pgsql_DB/recovery.conf

3. 编辑此文件,指定归档日志的位置(/home/admin/tmp/pg_archive/):
 
       restore_command = 'cp /home/admin/tmp/pg_archive/%f %p'

   postmaster 启动后执行此命令将归档日志copy到pg_xlog目录，然后进行加载回放.

   在recovery.conf 中还可以指定恢复的点，默认是latest(恢复到最近).
4. 归档日志回放完成后(restore_command 返回非0),pgmaster 查找pg_xlog下面的日志，如果有则进行回放。
5. 所有日志都回放完成。postmaster将recovery.conf改名为recovery.conf.done 然后启动新的postgresql服务器，此时恢复就完成了。
新的服务器可以正常接收请求了。

### 热备

热备:warm-standby 和 hot-standby

hot-standby 除了做备份外，还可以提供readonly的查询服务。

热备是指master和slave都处于running状态，master的更新被扩散到slave。slave和master保证一致的状态。当master失效后我们可以启动slave来继续提供服务。

### postgres 的热备配置:

posgres的热备有2中方式:

* **基于日志归档和加载的叫做log-ship**  
  故名思议就是将master的日志加载到slave中，从而保证一致。  
  实现上可以由多种方式，只要master产生wal日志后，copy到slave的pg_xlog下面，slave就会加载。  
  postgres服务器提供了 archive_command 和 restore_command ，这样我们就只需要配置对这两个命令即可. master 执行archive_command将日志归档到一个地方，slave执行restore_command 目的是拿master的日志到自己手中.

   比如: 如果master和slave在同一台服务器,则只要配置master的归档地址和slave的加载源地址一致即可保证slave与master热备.  
   如果master和slave处于2台服务器上，可以配置rsync命令将归档日志移动到slave所在机器等等。实现上非常灵活。
* **基于stream的热备**  
  这种方式是slave和master通过tcp链接slave和master进行replication协议，进行wal记录的同步。  
  由于采用直接链接，同步状态比较好，一致性高。

#### 热备的slave准备:

热备要始于一个起点，从这个起点开始进行主备间的一致性同步（因为之前的日志等已经没有或者根本没有配置），从master产生一个slave必须通过执行一个基础备份来生成。即使用pg_basebackup或者具有相同功能的工具和方法来生成。

如:

    pg_basebackup -D pgsql_DB -f t -x -z -l "my backup for slave" -U repl 

#### 基于日志归档的配置:
* master 配置:  
  1. postgresql.conf 中设置:  
`wal_level = archive` #日志格式要archive以上.  
`archive_command = 'cp -i %p /home/admin/tmp/pg_archive3/%f </dev/null'` #日志归档  
* slaver 配置:  
  1. recovery.conf 中配置:  
`standby_mode = on` # 此处表示进入slave模式，而不是recovery完成后成为可读可写的库。  
`restore_command = 'cp /home/admin/tmp/pg_archive/%f %p'` # 加载master的归档日志  

#### 基于stream的热备配置:

* master 配置:  
  1. postgresql.conf 中设置:  
`wal_level = hot_standby` #日志格式必须hot_standby  
`max_wal_senders = 1`  # 此处根据slaver的数量设置  
* slaver 配置:  
  1. postgresql.conf 中设置:  
`hot_standby = on` # 此处可选，打开表示slaver上可以执行read-only的查询。默认不可以。  
  2. recovery.conf 中配置:  
`standby_mode = on` # 此处表示进入slave模式，循环地与master同步。  
`primary_conninfo = 'host=localhost port=5432 user=repl password=repl_213456'` # 使用stream 方式进行同步。  


#### 两种热备的区别和联系:

在postgresql处理热备并不会严格的区分它们。

**recovery.conf**是控制热备和恢复的配置。posgresql在启动的时候，如果配置了`restore_command`,slave则启动加载日志的进程进行加载，

如果加载完成，则进入pg_xlog目录进行加载日志,如果也加载完成，此时查看是否配置了stream方式的复制，

如果配置了，则通过链接与master链接进行接搜日志，如果此步骤失败或者没有配置，

然后根据是否这是了standby_mode 选择退出恢复模式还是继续进行此循环。

如果设置了`standby_mode = on` 则会循环上面的步骤，可见**log-ship**类型和**stream**类型的复制是同时可以存在的。

如果没有设置`standby_mode = on `（默认情况）则postgresql在所有尝试都失败(完成)后，认为recovery完成了。将recovery.conf改成recovery.conf.done防止下次重复执行，然后spwan一个新的实例。

通过查看postgresql的启动后进程，可以发现log-ship的工作和stream工作的是由不同进程完成的，因而这两个过程估计是并发进行的。


#### 热备的一致性
基于stream的热备比log-ship一致性高，然而基于stream的热备默认是异步的，事务的提交不会等到slave也完成。因而可能存在master上和slave上的不一致性（落后）。

通过在postgresql.conf中设置:synchronous_commit = on 和 synchronous_standby_names="a,b" 设置复制是同步的。
第一个选项默认是打开的，第二个选项中配置需要同步的slave。

在master将事务写入wal日志后，日志被传输到slave，slave在写入数据库并flush到磁盘后会应答master其写入完成，master收到此应答后才认为此事务完成。

### 复制(replication)

复制,replication 可以通过基于stream的热备功能来实现，配置可以直接使用stream热备的配置。


### 其它

* 查看replication状态:   
   在master上的系统view表pg_stat_replication中各个字段
* 根据wal日志的location查询对应的段文件:  
   select pg_xlogfile_location('0/28D09608');
* master正在发送的wal段和slave正在接受的wal段也可以通过查看进程来看到:  

    master:
    
        /usr/local/pgsql/bin/postgres -D pgsql_db
         \_ postgres: writer process
         \_ postgres: wal writer process
         \_ postgres: autovacuum launcher process 
         \_ postgres: archiver process   last was 000000010000000000000027
         \_ postgres: stats collector process
         \_ postgres: wal sender process repl 127.0.0.1(19770) streaming 0/28D09728
    
    slave:
    
        /usr/local/pgsql/bin/postgres -D pgsql_db2
         \_ postgres: startup process   recovering 000000010000000000000028
         \_ postgres: writer process
         \_ postgres: stats collector process
         \_ postgres: admin pesystem [local] idle 
         \_ postgres: wal receiver process   streaming 0/28D09728


### 参考
<http://www.postgresql.org/docs/devel/static/high-availability.html>
