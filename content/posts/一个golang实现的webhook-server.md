+++
title = "一个golang实现的webhook Server"
description = "description"
keywords = ["webhook", "golang"]
categories = ["linux tool"]
tags = ["webhook"]
date = 2019-05-21T16:07:04+08:00
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

> [webhook](https://github.com/adnanh/webhook) is a lightweight incoming webhook server to run shell commands
<!--more-->

### 安装教程
---
#### Building from source
- 需要[golang](http://golang.org/doc/install)环境

```bash
> go get github.com/adnanh/webhook
```

#### Snap安装
[Snap store](https://snapcraft.io/webhook)
```bash
> sudo snap install webhook
```

#### Ubuntu/Debian
```bash
> sudo apt-get install webhook
```

### 使用
---
#### 编辑主要配置文件/etc/webhook/hooks.json
```json
[
  {
    "id": "redeploy-webhook",
    "execute-command": "/var/scripts/redeploy.sh",
    "command-working-directory": "/var/webhook"
  }
]
```
- [json配置参数说明](https://github.com/adnanh/webhook/blob/master/docs/Hook-Definition.md)
- 保证shell脚本有可执行权限

#### 启动服务
```bash
# 默认的启动端口为9000
> /<path>/webhook -hooks /etc/webhook/hooks.json -verbose
```
- [Webhook启动参数](https://github.com/adnanh/webhook/blob/master/docs/Webhook-Parameters.md)

#### 钩子访问
可以通过`http://<domain/ip>:9000/hooks/redeploy-webhook`访问服务，这样就可以执行`/var/scripts/redeploy.sh`的shell脚本了

#### tips
- 貌似只能执行shell脚本，好像不能执行python脚本。

### 相关参考
---
- [webhook](https://github.com/adnanh/webhook)
- [Hook examples](https://github.com/adnanh/webhook/blob/master/docs/Hook-Examples.md)
