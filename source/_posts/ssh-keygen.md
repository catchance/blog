---
title: ssh-keygen
toc: true
tags:
  - linux命令
categories: ssh
---

## 用法

### Windows下生产ssh密钥文件
- 已经安装git,打开"Git Bash"
- `ssh-keygen -t rsa -C "email@email.com"`
- 提示输入key的名称，默认id_rsa
- 用户目录会生成.ssh文件夹和id_rsa和id_rsa.pub两个文件
- id_rsa.pub就是公钥，可以复制到github上面使用。
