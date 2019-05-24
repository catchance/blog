+++
title = "Supervisor-Python开发的一套通用的进程管理程序"
description = "一款非常好用的Web端SSH工具GateOne"
keywords = ["supervisor"]
categories = ["linux tool"]
tags = ["python", "supervisor"]
date = 2017-02-22T13:53:26+08:00
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

> [Supervisor](https://github.com/Supervisor/supervisor)是用Python开发的一套通用的进程管理程序.
> 这里写摘要内容

<!--more-->

### 安装
---
```bash
$ apt-get install supervisor # Debian / Ubuntu
$ yum install supervisor # Centos / RedHat
```

### 使用
1. 给我们自己开发的应用程序编写配置文件
/etc/supervisor/conf.d/app.conf
```bash
[program:app]
command=/usr/bin/gunicorn -w 1 wsgiapp:application # 命令
directory=/srv/www # 进程的当前目录
user=www-data # 进程运行的用户身份
```

2. 重启supervisor
```bash
# supervisorctl start/stop <app> #启动/停止进程
```

### 相关文档
---
- [Supervisor官网](http://www.supervisord.org/)