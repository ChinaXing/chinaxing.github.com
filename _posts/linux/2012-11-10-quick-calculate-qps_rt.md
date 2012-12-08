---
layout: post
title: 快速取得apache/nginx的qps和rt
category: linux
---

在计算QPS和RT的时候，我们一般使用grep 。但是当日志文件很大的时候，grep会很耗时。

监控系统中计算的方法是记录上次采样的行，下次读取的时候从记录的位置开始。所以不存在这个问题。

但是如果我们仅仅希望链接到服务器，执行一条命令就快速的计算出qps和rt。则需要考虑如何快速读取需要的行的问题：

经过我这几天的考虑，总结出了下面一条命令。计算qps和rt算是很快了。如果谁有比这个更秒的方法，不吝赐教：

{% highlight bash linenos %}
        srm=" \[`date -d ' -1 second '  +%d\\\/%h\\\/%Y:%H:%M:%S` +0800\] "
        QPS_RT=$(tac $acc_logs|sed -n -e  '/'"$srm"'/,${
        /'"$srm"'/p
        /'"$srm"'/!q}' | awk '{sum+=$2;count++}END{printf "%d,%.2f",count,sum/count/1000}'
        )
{% endhighlight %}


**说明**：  

第一行取得日志中的时间字符串，这里取的前一秒的。  

第二行使用linux下到命令得到qps和rt的平均值。