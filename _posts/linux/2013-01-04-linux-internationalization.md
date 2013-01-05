---
layout: post
title: Linux 下使用gettext完成程序国际化/本地化
category: linux
change_frequency: monthly
tag: gettext
---

程序的国际化/本地化是指根据用户语言和区域的不同程序可以使用针对用户的交互信息。如，中文用户，则语言会变成中文，时间会显示北京时间，货币会显示RMB。

Linux 下**Gnu/gettext**工具套件可以完成语言(message)的本地化/国际化。

**gettext的官方手册**：http://www.gnu.org/software/gettext/manual/gettext.html

若要完整的了解和掌握gettext的why，what，how，请看这里。

gettext套件的工具包括： gettext,xgettext,msgfmt ... 

- gettext : 进行translate，根据LC_MESSAGES环境变量的值和TEXTDOMAIN查找字串对应的本地表示。
- xgettext : 从程序中抽取调用gettext进行本地化的字符串，生成一份.po结尾的配置文件。
- msgfmt : 将配置好的本地化配置文件进行转换成gettext使用的格式。


### 使用gettext进行本地化的步骤：
1. 程序编写的时候,
   - 在程序开始的地方配置gettext:

         setlocale(lc_ALL,""); # "" 空串，则会根据运行时环境变量的情况决定
         bindtextdomain('myapp','/usr/local/share/locale')
         textdomain('myapp');
   - 需要本地化的地方调用gettext库函数。如:

         printf (gettext("hello,world")); 
   代替:

         printf ("hello,world");
   gettext 调用可以使用define宏定义为_(),等于使用gettext()，因而可以简写为(几乎所有程序都这么做):

         printf (_("hello,world"));
2. 使用xgettext工具处理程序，从中抽取出gettext调用的字符串：

       xgettext -L c -o zh_CN.po myprogram.c
   假如我想本地化中文:zh_CN
3. 编辑生成的本地化配置文件(zh_CN.po),设置转换对应关系，注意设置编码(charset)为*utf-8*，否则转换可能有问题:

       # SOME DESCRIPTIVE TITLE.
       # Copyright (C) YEAR THE PACKAGE'S COPYRIGHT HOLDER
       # This file is distributed under the same license as the PACKAGE package.
       # FIRST AUTHOR <EMAIL@ADDRESS>, YEAR.
       #
       #, fuzzy
       msgid ""
       msgstr ""
       "Project-Id-Version: PACKAGE VERSION\n"
       "Report-Msgid-Bugs-To: \n"
       "POT-Creation-Date: 2013-01-04 17:11+0800\n"
       "PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE\n"
       "Last-Translator: FULL NAME <EMAIL@ADDRESS>\n"
       "Language-Team: LANGUAGE <LL@li.org>\n"
       "MIME-Version: 1.0\n"
       "Content-Type: text/plain; charset=utf-8\n"
       "Content-Transfer-Encoding: 8bit\n"
       
       #: t.sh:6
       msgid "hello,world"
       msgstr "你好，世界"
 使用msgfmt工具将配置文件转换成gettext使用的格式：

     msgfmt -o /usr/local/share/locale/zh_CN/LC_MESSAGES/myapp.mo zh_CN.po

5. 验证，设置环境变量LC_MESSAGES或LANG为zh_CN。然后运行程序即可。


### 实例：
shell 使用gettext的示例:

    TEXTDOMAINDIR=/usr/local/share/locale/ # 为gettext查找路径
    TEXTDOMAIN=myapp.mo #为gettext查找文件名称
    LC_MESSAGES=zh_CN #gettext查找路径的本地化部分
    
    echo `gettext "hello,world"`

将会输出:

    你好中国

