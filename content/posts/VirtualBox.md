---
title: VirtualBox
toc: true
tags:
  - 工具
  - VirtualBox
categories:
  - VirtualBox
date: 2017-02-15 17:18:28 +08:00
---
> VirtualBox的简单使用
> 这里写摘要内容

<!--more-->

### 标题一
---

### VirtualBox centos7扩容
[参考](http://blog.csdn.net/cinvzi_/article/details/52138052)
1. 查看磁盘格式：右键点击虚拟机->设置->存储
2. 磁盘格式为vdi,则可直接在win终端中执行如下命令：
  VBoxManage modifyhd "CentOS7-1511.vdi" --resize 20480（单位为M）
  如果磁盘格式为vmdk，则需要先转换为vdi格式，执行如下命令：
  VBoxManage clonehd "CentOS7-1511_Dev.vmdk" "CentOS7-1511.vdi" --format vdi
  VBoxManage modifyhd "CentOS7-1511.vdi" --resize 20480（单位为M）
3. 启动虚拟机，相关命令操作设置
  ```bash
  $ sudo fdisk /dev/sda
  $ m # 获取帮助
  $ n #
  $ p #
  $ 3
  $   # 提示分别输入起始扇区和默认扇区 默认就好
  $   # 提示分别输入起始扇区和默认扇区 默认就好
  $ t # 输入t来改变磁盘的system id
  $ 8e # 可以看见原有的磁盘id就为8e
  $ sudo fdisk -l #
  $ w #
  $ reboot # 重启
  $ sudo fdisk -l # 查看设备Boot（我的为 /dev/sda3 ）
  $ sudo mkfs.ext4 /dev/sda3 # 将分区格式化为ext4格式
  $ sudo pvcreate /dev/sda3 # 创建新的物理分区
  $ sudo vgdisplay # 查看虚拟卷
  $ sudo vgextend centos /dev/sda3 #扩展到卷 组
  $ sudo lvdisplay # 根据大小判定/dev/centos/root即是根分区，执行
  $ sudo lvextend /dev/centos/root /dev/sda3 #
  $ sudo resize2fs /dev/centos/root #刷新逻辑分区容量
  # 如果报错则是因为你的某些分区使用的是xfs的文件系统，执行 xfs_growfs /dev/centos/root 刷新逻辑分区即可。
  $ sudo df -h # 根分区容量变大了，恭喜你成功了
  $ reboot
  ```
