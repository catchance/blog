---
title: docker
toc: true
tags: ["docker", "base"]
categories: ["docker"]
date: 2017-02-14 11:20:22 +08:00
---
> docker的基础介绍和简单实用  
> docker的基本使用

<!--more-->

### 安装
---

#### linux
```bash
$ yum install docker # 安装
$ service docker start # 启动 docker 服务（新）
$ chkconfig docker on # 设置为开机启动（新）
$ systemctl start docker.service # 启动 docker 服务（新）
$ systemctl enable docker.service # 设置为开机启动（新）
$ docker pull centos # 下载官方的 CentOS 镜像到本地
$ docker images centos # 确认 CentOS 镜像已经被获取
$ docker run -i -t centos /bin/bash # 运行一个容器
```

### 命令
- 容器生命周期管理 — docker [run|start|stop|restart|kill|rm|pause|unpause]
- 容器操作运维 — docker [ps|inspect|top|attach|events|logs|wait|export|port]
- 容器rootfs命令 — docker [commit|cp|diff]
- 镜像仓库 — docker [login|pull|push|search]
- 本地镜像管理 — docker [images|rmi|tag|build|history|save|import]
- 其他命令 — docker [info|version]

#### ps
```bash
# 列出机器上的镜像
$ docker ps # -a 查看包括已经停止的所有容器 -l 显示最新启动的一个容器（包括已停止的）
```

#### images
```bash
# 列出机器上的镜像
$ docker images
```

#### search
```bash
# 在docker index中搜索image
$ docker search <keyword>
```

#### pull/push
```bash
# 从docker registry server 中下拉image或repository docker pull [OPTIONS] NAME[:TAG]
# 推送一个image或repository到registry（push）
$ docker pull centos7
$ docker push seanlook/mongo
```

#### run
```bash
# 从image启动一个container
# Usage: docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
$ docker run ubuntu echo "hello world"
$ docker run -it ubuntu /bin/bash # i,t参数进入交互伪终端模式

```

#### commit
将一个container固化为一个新的image（commit）
```bash
# docker commit <container> [repo:tag]
$
```

#### build
将一个container固化为一个新的image（commit）
```bash
# docker build [OPTIONS] PATH | URL | -
$
```

#### attach/exec
```
# attach到一个已经运行的容器的stdin，然后进行命令执行的动作。
# !但是需要注意的是，如果从这个stdin中exit，会导致容器的停止。
$ docker attach bb2

# 使用-it时，则和我们平常操作console界面类似,而且也不会像attach方式因为退出，导致
整个容器退出。
$ docker exec -it bb2 /bin/bash
```

### Dockerfile
```bash
# Version 0.2

# 基于那个基础镜像
FROM ubuntu:latest

# 维护者信息
MAINTAINER catchance@163.com

# 镜像操作命令
RUN apt-get -yqq update && apt-get install -yqq apache2 && apt-get clean
RUN apt-get install -yqq supervisor
RUN mkdir -p /var/log/supervisor

# 挂载数据卷,将apache访问的日志数据存储到宿主机可以访问的数据卷中
VOLUME ["/var/log/apche2"]

# 向镜像中添加文件有两种命令：COPY 和ADD
ADD html.tar /var/www
# ADD http://www.shiyanlou.com/html.tar /var/www
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 将启动后的工作目录切换到/var/www/html目录
WORKDIR /var/www/html

# ENV命令能够对容器内的环境变量进行设置
ENV HOSTNAME chance
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apche2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apche2

# 暴露端口，提供给容器互联使用
EXPOSE 80

# 容器启动命令
CMD ["/usr/bin/supervisord"]

# ENTRYPOINT ["memcached"] # Container启动时执行的命令,多条则只执行最后一条
# USER daemon # 使用哪个用户跑Container
# ONBUILD # ONBUILD 指定的命令在构建镜像时并不执行，而是在它的子镜像中执行

```

### 一次建立image的完整例子
1.  创建Dockerfile文件
  ```bash
  $ cd
  $ mkdir myimage
  $ cd myimage
  $ touch Dockerfile
  ```

  文件参考上一章节中的配置文件  

2. 使用Supervisord
  ```bash
  ~/myimage/supervisord.conf
  [supervisord]
  nodaemon=true

  [program:apache2]
  command=/bin/bash -c "source /etc/apache2/envvars && exec /usr/sbin/apache2ctl -D FOREGROUND"
  ```

3. 下载静态页面文件压缩包
```bash
$ cd ~/myimage
$ wget http://labfile.oss.aliyuncs.com/courses/498/html.tar
```
4. docker build 执行创建，-t参数指定镜像名称：
```bash
$ docker build -t <name>:0.1 ~/myimage/
```
5. 运行
```bash
docker run -ti -p 80:80 --name web2 <name>:0.1
```

### 技巧
- 使用Docker Hub Mirror加速Docker官方镜像下载
使用[DaoCloud](https://www.daocloud.io/mirror#accelerator-doc)团队提供的服务Docker Hub Mirror。
