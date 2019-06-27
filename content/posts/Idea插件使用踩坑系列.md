+++
title = "Idea插件使用踩坑系列"
description = "description"
keywords = ["bug", "idea", "git"]
categories = ["idea"]
tags = ["idea"]
date = 2019-06-27T14:31:58+08:00
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

> Idea Git 插件的坑    
<!--more-->
### *Git插件* Idea中pull代码的时候需要输入密码
---

#### 问题（坑）描述
在idea使用git可视化工具pull代码时,总会弹出一个对话框,要求输入密码,本以为是生成密钥对时生成的密码,可怎么输入都不正确

#### Why?
SSH key is hardcoded to "id_rsa" inside org.jetbrains.git4idea.ssh.SSHMain

idea将id_rsa硬编码了,导致只能识别id_rsa文件的密钥,而且只能放在家目录C:\Users\<username>.ssh

而我们的密钥一般都是自己的邮箱名称

#### 解决
只需要复制一份私钥重命名为id_rsa放到C:\Users\<username>.ssh目录即可，至此,问题解决

#### Tips

#### 相关参考
- [idea >> issue](https://youtrack.jetbrains.com/issue/IDEA-70326)

