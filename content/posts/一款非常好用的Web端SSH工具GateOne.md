+++
title = "一款非常好用的Web端SSH工具GateOne"
description = "一款非常好用的Web端SSH工具GateOne"
keywords = ["gateone", "webssh"]
categories = ["linux tool"]
tags = ["gateone"]
date = 2019-05-22T10:34:14+08:00
draft = false
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

> [GateOne](https://github.com/liftoff/GateOne)是一个能在浏览器上运行的Terminal SSH客户端，无论你在哪里，只要有网，你就可以用浏览器操控你的VPS服务器.
> 还支持右键复制/粘贴等客户端常用功能，包括多窗口等，使用起来非常方便 
<!--more-->

### 安装
---
#### 环境说明
- Ubuntu-16.04.2
- Python 2.7.12
- tornado 4.5.3

#### docker方式安装

```bash
$ docker pull liftoff/gateone
```

#### 运行
```bash
# docker run [-d/-t] -p [443]:8000 -h [hostname] --name gateone liftoff/gateone gateone
# 示例，如果服务器上443被占用，请使用其它未被占用的端口
$ docker run -it -p 443:8000 --name gateone liftoff/gateone gateone --disable_ssl=true --url_prefix=/gateone/
```

#### liftoff/gateone镜像运行报错
如果使用liftoff/gateone运行报错的话，可能是因为tornado版本不对，我们需要在此镜像的基础上做修改.

- 新建目录myGateOne `mkdir ~/myGateOne`
- 编辑Dockerfile文件

    ```bash
    FROM liftoff/gateone
    RUN pip install tornado==4.5.3
    CMD ["gateone"]
    ``` 
- 重建镜像
```bash
# 英文 . 别漏掉了
$ docker build -t="mygateone" .  
Successfully Built
```
- 使用新镜像启动

    ```bash
    $ docker run -it -p 443:8000 --name gateone mygateone gateone --disable_ssl=true --url_prefix=/gateone/
    ```


#### 配合Nginx设置设置转发
- [配置Nginx用户认证]({{< ref "posts/Nginx.md" >}})

- 添加nginx的配置

    ```bash
    server {
        # 端口配置
        listen       443 ssl;
        server_name  <domain>;
        
        # 证书配置
        ssl on;
        ssl_certificate <your-fullchain.pem>;
        ssl_certificate_key <your-privkey.pem>;
        # 其他配置
        ...
        
        # GateOne
        location /gateone/ {
            
            auth_basic "User Authentication";
            auth_basic_user_file /opt/nginxpwd;
        
            proxy_pass       http://127.0.0.1:54321;
    
            proxy_redirect off;
            proxy_pass_header Server;
            proxy_set_header Host $http_host;
            proxy_set_header X-Real-IP $http_address;
            proxy_set_header X-Scheme $scheme;
    
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
        }
    }
    ```
    
- docker启动gateone服务

    ```bash
    $ docker run -it -p 54321:8000 --name gateone mygateone gateone --disable_ssl=true --url_prefix=/gateone/
    ```

### 相关文档
---
- [Ubuntu 安装配置 GateOne](https://zhgcao.github.io/2016/09/06/ubuntu-install-gateone/)
- [一款非常好用的Web端SSH工具：GateOne安装教程](https://hupsun.com/882.html)

