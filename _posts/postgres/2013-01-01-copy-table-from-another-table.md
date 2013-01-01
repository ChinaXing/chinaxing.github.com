---
layout: post
title: Copy table from another table
category: postgres
change_frequency: monthly
---


    create table table2 ( like table1 INCLUDING DEFAULTS INCLUDING CONSTRAINTS INCLUDING INDEXES );

this will create table2 which is clone of table1.


    select * into table2 from table1 where 1=2;
    create table table2 as select * from table1 where 1=2;

these will create table2 like table1 , but missing the **modifers**(default,not null ... attribute)in table1.



