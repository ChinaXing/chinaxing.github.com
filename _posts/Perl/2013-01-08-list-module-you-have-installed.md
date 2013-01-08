---
layout: post
title: 列出你安装的Perl模块
category: Perl
change_frequency: monthly
---

有时候，我们想知道自己的机器上安装了哪些Perl模块，可以通过一个很简单的命令成:

    perldoc perllocal 

如:

      Tue Dec 18 13:43:01 2012: "Module" Test::Simple
        *   "installed into: /usr/share/perl5"
    
        *   "LINKTYPE: dynamic"
    
        *   "VERSION: 0.98"
    
        *   "EXE_FILES: "
    
      Tue Dec 18 13:43:03 2012: "Module" version
        *   "installed into: /usr/local/share/perl5"
    
        *   "LINKTYPE: dynamic"
    
        *   "VERSION: 0.9901"
    
        *   "EXE_FILES: "


这条命令是perl自带的，它会列出每个安装的模块，包括安装时间和具体信息。

我们可以通过grep方便找出这个模块列表：

    perldoc -t perllocal | grep "Module"

如：

      Tue Dec 18 13:43:01 2012: "Module" Test::Simple
      Tue Dec 18 13:43:03 2012: "Module" version
      Tue Dec 18 13:43:04 2012: "Module" Module::Metadata
      Tue Dec 18 13:43:06 2012: "Module" CPAN::Meta::YAML
      Tue Dec 18 13:43:12 2012: "Module" JSON::PP
      Tue Dec 18 13:43:13 2012: "Module" Parse::CPAN::Meta
      Tue Dec 18 13:43:14 2012: "Module" CPAN::Meta::Requirements
      Tue Dec 18 13:43:18 2012: "Module" CPAN::Meta
      Tue Dec 18 13:43:20 2012: "Module" Perl::OSType
      Tue Dec 18 13:43:22 2012: "Module" Locale::Maketext::Simple
      Tue Dec 18 13:43:23 2012: "Module" Params::Check
      Tue Dec 18 13:43:24 2012: "Module" Module::Load
      Tue Dec 18 13:43:26 2012: "Module" Module::CoreList
      Tue Dec 18 13:43:27 2012: "Module" Module::Load::Conditional
      Tue Dec 18 13:43:30 2012: "Module" IPC::Cmd
      Tue Dec 18 13:43:32 2012: "Module" ExtUtils::CBuilder
      Tue Dec 18 13:44:34 2012: "Module" App::cpanminus
      Wed Dec 19 11:13:40 2012: "Module" Try::Tiny
      Wed Dec 19 11:13:40 2012: "Module" Test::Fatal
      Wed Dec 19 11:13:43 2012: "Module" Test::TinyMocker
      Mon Jan  7 14:27:39 2013: "Module" Locale-Maketext
      ... ... 
