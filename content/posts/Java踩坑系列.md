+++
title = "Java踩坑集合"
description = "description"
keywords = ["bug", "java"]
categories = ["bug"]
tags = ["java"]
date = 2019-05-21T11:10:23+08:00
draft = true
# CJKLanguage: Chinese, Japanese, Korean
isCJKLanguage = true
# 排序你的文章
weight = 40

# 这里还可以自定义任何参数，这些参数可以在模板中使用
toc = true
comments = false
# 精选图片
featured_image = ""
+++
    
> java相关踩坑系列  
<!--more-->
### e.printStackTrace()会导致锁死
---

#### 问题（坑）描述

#### 原因
短时间内大量请求访问此接口 -> 代码本身有问题，很多情况下抛异常  -> e.printStackTrace() 来打印异常到控制台 -> 产生错误堆栈字符串到字符串池内存空间 -> 此内存空间一下子被占满了 -> 开始在此内存空间产出字符串的线程还没完全生产完整，就没空间了 ->  大量线程产出字符串产出到一半，等在这儿（等有内存了继续搞啊）-> 相互等待，等内存，锁死了，整个应用挂掉了。

#### 解决
- java中e.printStackTrace()不要使用，请使用logger记录

#### tips
- java中e.printStackTrace()不要使用，请使用logger记录

#### 相关参考
- [e.printStackTrace() 会导致锁死](https://blog.csdn.net/qq_28929589/article/details/82495193)


### x-forwarded-for 请求头丢失问题
---

#### 问题（坑）描述
在后端业务经常有需要获取客户端真实的ip需求，通常的做法是解析x-forwarded-for请求头来获取IP。x-forwarded-for  用来记录请求代理链IP(不包含最后代理)但是在某些情况下会出现x-forwarded-for丢失的问题，导致获取不到x-forwarded-for请求头

#### 原因
以下情况会造成x-forwarded-for请求头丢失
- nginx没有设置x-forwarded-for
- 客户端和服务端调用属于内网调用
- tomcat中设置了remoteIpHeader="x-forwarded-for"
当tomcat设置了remoteIpHeader或protocolHeader 会启用RemoteIpValve模块
Tomcat中的RemoteIpValve会根据InternalProxies和TrustedProxies来过滤x-forwarded-for中的代理链IP
InternalProxies默认值如下：
``` java
private Pattern internalProxies = Pattern.compile(
        "10\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}|" +
        "192\\.168\\.\\d{1,3}\\.\\d{1,3}|" +
        "169\\.254\\.\\d{1,3}\\.\\d{1,3}|" +
        "127\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}|" +
        "172\\.1[6-9]{1}\\.\\d{1,3}\\.\\d{1,3}|" +
        "172\\.2[0-9]{1}\\.\\d{1,3}\\.\\d{1,3}|" +
        "172\\.3[0-1]{1}\\.\\d{1,3}\\.\\d{1,3}");
```
InternalProxies默认值是一些常见的内网IP,如果tomcat发现代理链IP属于内网IP,则会过滤掉，以获取代理机器之前的IP地址，将其设置进RemoteAddress值，方便后端通过request.getRemoteAddr()获取。
此举目的是为了获取真实IP,没有RemoteIpValve的处理，RemoteAddress可能永远为代理机器的IP地址。
然后Tomcat将没有过滤的IP重新设置进x-forwarded-for请求头。这意味着如果代理链内都为内网IP地址，则x-forwarded-for都会清空。

#### 解决
nginx的x-forwarded-for设置正常情况下
如果项目需要访问x-forwarded-for请求头真实数据（不管是否是内网IP）请勿设置remoteIpHeader 或 protocolHeader
如果设置了remoteIpHeader="x-forwarded-for"，请将request.getRemoteAddr()和x-forwarded-for请求头结合使用，并考虑是否存在内网请求调用情况进行处理。

#### tips
- java中e.printStackTrace()不要使用，请使用logger记录

#### 相关参考
- [X-Forwarded-For等http头字段与Tomcat的 Remote IP Valve（Valve源码分析之六）](https://www.cnblogs.com/zhongchang/articles/10345333.html)