---
title: supervisor
toc: true
tags:
  - linux-工具
categories:
  - linux
date: 2017-02-22 13:53:26
---
> 这里写摘要内容  
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
# supervisorctl start/stop app #启动/停止进程
```
