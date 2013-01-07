---
layout: post
title: Raspberry Pi 试玩
category: linux
change_frequency: monthly
---
### 目录
{:.no_toc}
* 
{:toc}
<hr>

[Raspberry Pi](http://www.raspberrypi.org/) 是ARM 处理器搭载Gnu/Debian Linux的单片电脑。它的发行目标是促进青少年学习计算机技术。

<img src="/images/Raspberry-Pi.jpg">

Raspberry Pi 有早些发布的256M内存/不带网卡的A版本和迟些时候发布的512M内存/带100M网卡的B版本，多数人都买B版本应该。

### Raspberry Pi 构成
Raspberry Pi 买到手后，还需要一块SD卡来作"硬盘"，容量需要2GB以上，我买了一块8GB SanDisk的45 ￥。
Raspberry Pi 有如下接口：
- 电源输入：Micro usb接口的5V 1A 的输入电流。
- 2个USB接口：可以接鼠标和键盘等。
- HDMI接口：接HDMI接口的显示器，如果是DVI或VGA的，需要买转接线。
- 以太网接口：100M的以太网接口，插网线上网用的。
- 模拟信号音频和视频输出接口：可以接电视机，输出模拟信号，显示在电视机上。
- SD卡插口：插入SD卡，作存储用。

### Raspberry Pi ssh 登陆
拿到手后，我由于没有HDMI的显示器（目前这样显示器还贵，多数还是VGA的便宜LED），也不打算花钱再买，所以打算用ssh登陆试玩。

Raspberry Pi在加电后就会自动启动系统，系统中sshd 服务已经配置为随系统启动启动。所以Rapsberry Pi 启动后ssh服务就可用了。

在连接ssh前我们需要配置Pi的网络，我使用了一根网线连接Pi和我的笔记本，两者组成了一个局域网。
为了实现连接，我在我的笔记本Fedora中配置了DHCP服务，这样Pi启动的时候就可以从DHCP获得IP：

1. 安装dhcp-server 在Fedora中：

      sudo yum install dhcp
2. 配置dhcp：

      sudo vim /etc/dhcp/dhcpd.conf
   添加如下配置：

      subnet 192.168.33.0 netmask 255.255.255.0 { 
          range 192.168.33.2 192.168.33.114; 
          default-lease-time 86400; 
          max-lease-time 259200; 
          option subnet-mask 255.255.255.0; 
          option broadcast-address 192.168.33.255; 
          option routers 192.168.33.2; 
          option domain-name-servers 192.168.33.2; 
      } 
3. 配置与Pi连接的网卡的IP:

      sudo ifconfig em1 192.168.33.2/24
4. 启动dhcp服务：

      sudo dhcpd
5. 启动Pi,重新加电即可重起Pi。
6. 查看Pi 的IP：

      cat /var/lib/dhcpd.lease
   里面可以看到从dhcpd 获取到IP的客户端，可以看到服务器带有Pi字样的服务器，就是Pi了。我的Pi获取的地址是:192.168.33.3
7. 使用ssh 登陆Pi:

      ssh pi@192.168.33.3 
   密码是*respberry*
8. 登陆后我们可以设置Pi的网络配置，配成静态地址，这样就不需要使用dhcp了。网络配置在/etc/network/interfaces

      auto eth0
      #iface eth0 inet dhcp 
      iface eth0 inet static
      address 192.168.33.3
      netmask 255.255.255.0
      network 192.168.33.0
      broadcast 192.168.33.255
      gateway 192.168.33.2

### 使用远程桌面连接Pi
没有显示器，却想看Pi的图形桌面，怎么办？

可以使用远程桌面来访问Pi，过程也很简单，我通过iphone也连接到了Pi。

1. 在Pi上安装xrdp, 一个远程桌面的服务端：

      sudo apt-get install xrdp
   安装好后xrdp就自动启动了，而且配置为随系统启动
2. 在Fedora上安装rdesktop，一个远程桌面客户端：

      sudo yum install rdesktop
3. 使用Fedora 的Remte Desktop 连接Pi，输入Pi的ip地址和用户名pi，连接后如图：

   <img src="/images/Raspberry-Pi-Remote-desktop.png">

### 配置Pi连接Internet
使用一根网线连接Pi和电脑实现了Pi和电脑的互联，Pi却无法连接internet，访问google，baidu等网站，需要作一些配置。

我使用iptables来让Fedora作路由器的功能，相当于Pi通过网线连接到了一台局域网的路由器一样。
Fedora当路由器作用，同时作Nat功能，将Pi的地址转换为Fedora连接局域网的网卡的地址（我这里的网卡是无线网卡）。

1. 打开Fedora的ip_forward功能，允许转发包，作路由器用:

     sudo bash -c 'echo 1 >/proc/sys/net/ipv4/ip_forward'
2. 添加iptables，完成NAT功能:

      sudo iptables -A POSTROUTING -j SNAT --to-source 192.168.1.100 --random
   *--random* 选项让内核自己帮我们选端口，这个是必须的  
   192.168.1.100 是我连接路由器上网的那个网卡的ip地址，是个无线网卡wlan0
3. 在Pi内部检测网络联通：

      ping www.baidu.com

   *如果没有配置域名服务器* 需要配置域名解析服务器地址: `sudo echo nameserver 8.8.8.8 >/etc/resolv.conf`

### 使用iphone连接Pi
使用iphone连接Pi，需要安装远程桌面客户端在iphone上。

由于iphone通过无线路由器接入局域网，和Fedora是同一个网段:192.168.1.0，和Pi是不在一个局域网的（没有物理连接），
所以需要通过Fedora的转发来完成iphone到Pi的连接:

    iphone --> Fedora --> Pi

通过在Fedora上面配置如下iptables完成转发功能：

    sudo iptables -A PREROUTING -i wlan0 -p tcp -m tcp --dport 3389 -j DNAT --to-destination 192.168.33.3 

*wlan0*是电脑的无线网卡，连接到局域网的无线路由器上网 

*192.168.3.3*是Pi的地址

这句iptables的意思是对访问fedora的3389的连接，DNAT到Pi的3389端口

配置完成后就可以使用iphone连接到Pi:

<img src="/images/Raspberry-Pi-iphone-remote-desktop.jpg">


Have Fun :)
