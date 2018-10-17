---
title: ubuntu的使用
toc: true
tags:
  - linux
date: 2017-6-3 10:14:48 +08:00
categories: [ 操作系统]
---
> ubuntu系统的使用

<!--more-->  

### 使用技巧
#### linux ubuntu 16.04 忘记登录密码的解决办法
[参考](http://blog.csdn.net/w410589502/article/details/53611974)
- Step 1 开机按Shift键，出现如下界面。（手速要快，Shift键要按时间久一点）=> Ubuntu 高级选项 => recovery mode => e
- 并找到的recovery nomodeset删除，并在这一行的后面输入quiet splash rw init=/bin/bash后，按F10
- 命令行输入passwd +用户名，修改密码，若修改成功，则会返回password updated successfully
- 重新登陆
