---
title: Nginx
toc: true
tags: ["Nginx"]
categories: ["Nginx"]
date: 2017-02-23 11:16:28 +08:00
draft: true
---
> Nginx学习指南  

<!--more-->

### 安装
---

### 常用功能
---
#### Nginx用户验证

- 使用用 Apache 的 htpasswd 工具来创建密码文件
    ```bash 
    $ htpasswd -c /opt/nginxpwd user 
    # 如果出现 -bash: htpasswd: command not found
    # 安装 htpasswd 
    # 乌班图安装方法 sudo apt install apach2-utils
    ```
    
- 使用刚刚生成的秘钥文件配置Nginx
    ```bash
    location /test/ {
        auth_basic "TEST-Login!";
        auth_basic_user_file /opt/nginxpwd;
    }
    ```

- 重启nginx服务
```bash
$ systemctl restar nginx
```

### nginx.conf配置文件说明
---
