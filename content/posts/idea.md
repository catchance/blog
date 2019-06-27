+++
title = "Idea"
description = "description"
keywords = ["idea"]
categories = ["idea"]
tags = ["idea", "tools"]
date = 2016-12-26T14:31:58+08:00
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

> idea的简介和详细使用

<!--more-->

### 安装
---
#### Windows
- [安装教程](http://www.cnblogs.com/exmyth/p/5554452.html)

#### Linux

#### Mac OS X

### 概述
---
#### IDEA内存优化
因机器本身的配置而配置：
%IDEA_HOME%\bin\idea.exe.vmoptions
```bash
-Xms64m
-Xmx256m
-XX:MaxPermSize=92m
-ea
-server
-Dsun.awt.keepWorkingSetOnMinimize=true
-Dfile.encoding=UTF-8
```

### 效率快捷键的使用
---
- 使用 `|` 进行windows 和 osx 区分  
- `cmd` 相当于 mac中commond键

#### 查询快捷键  
`Shift+Shift` **查询所有地方**  
`CTRL+N`  查找类  
`CTRL+SHIFT+N`  查找文件  
`CTRL+SHIFT+ALT+N` 查找类中的方法或变量  
`CTRL+G`  定位行  
`CTRL+F`  在当前窗口查找文本  
`CTRL+SHIFT+F`  在指定窗口查找文本  
`CTRL+R`   在 当前窗口替换文本  
`CTRL+SHIFT+R`  在指定窗口替换文本  
`Ctrl+E` 最近打开的文件  
`F3`  向下查找关键字出现位置  
`SHIFT+F3`  向上一个关键字出现位置  
`Alt＋F3` 可以快速寻找  
`F4`   查找变量来源  
`Ctrl＋Q` 可以看JavaDoc  
`Alt+Q` 可以不需要移动代码就能查看当前方法地声明。连续按两次会显示当前所编辑的类名  

#### 导航快捷键
`Ctrl+Tab` **快速切换**  
`CTRL+Z`  倒退  
`CTRL+SHIFT+Z`  向前  
`CTRL+ALT+F12`  资源管理器打开文件夹  
`Ctrl＋F12` 可以显示当前文件的结构  
`ALT+ ←/→`  切换代码视图  
`CTRL+ALT ←/→`  返回上次编辑的位置  
`ALT+ ↑/↓`  在方法间快速移动定位  
`CTRL+H`  显示类结构图  
`Ctrl+Alt+H` 显示该方法被调用的情况 Call Hierarchy  
`CTRL+ALT+B` 查看抽象方法的具体实现  
`CTRL+B` 快速打开光标处的类或方法  
`CTRL+鼠标点击方法`  进入到抽象方法  
`CTRL+ALT+鼠标点击方法`  进入到具体的方法实现  
`F2 或Shift+F2` 高亮错误或警告快速定位  
`Alt + F12` 打开Terminal终端   
`Alt + 6` 显示代办TODO列表

#### 自动代码
`ALT+回车`  **导入包,自动修正**  
`CTRL+ALT+L`  格式化代码  
`CTRL+ALT+I`  自动缩进  
`CTRL+ALT+O`  优化导入的类和包  
`ALT+INSERT`  **生成代码(如GET,SET方法,构造函数等)**  
`CTRL+SHIFT+SPACE` **自动补全代码**  
`CTRL+SPACE`  代码提示  
`CTRL+ALT+SPACE`  类名或接口名提示  
`CTRL+P`   方法参数提示  
`CTRL+J`   自动代码  
`Ctrl+Shift+Enter`  **自动完成**  
`Ctrl+Shift+A` **发号施令**  
`Template/Postfix +Tab` **代码生成**  

#### 编辑快捷键
`Ctrl＋O` 可以选择父类的方法进行重写  
`Ctrl＋Alt＋V` 可以引入变量。例如把括号内的SQL赋成一个变量  
`Ctrl＋Alt＋T` 可以把代码包在一块内，例如try/catch  
`CTRL+D`  复制行  
`CTRL+X`  剪切,删除行  
`Ctrl+Shift+U` 选中字母大小写快速切换  

#### 调试Debug
`F7` Step Into 相当于eclipse的f5就是  进入到代码  
`Alt+Shift+F7` Force Step Into 这个是强制进入代码  
`F8` Step Over 相当于eclipse的f6跳到下一步  
`Alt+F8` debug时选中查看值  
`Shift+F8` Step Out  相当于eclipse的f8跳到下一个断点，也相当于eclipse的f7跳出函数  
`F9` resume programe 恢复程序  
`Atl+F9` Run To Cursor 运行到光标处  
`Ctrl+Shift+F9`  debug运行java类  
`Alt+F10` show execution point 显示执行断点  
`Ctrl+Shift+F10` 正常运行java类  
`Ctrl+F1` 显示结果  

#### 其他
`Ctrl+Alt+S` 打开设置  
`Ctrl+Alt+Shift+S` 打开项目设置  
`CTRL+/`  注释//  
`CTRL+SHIFT+/`  注释/*...*/  
`ESC`  光标返回编辑框  
`SHIFT+ESC`  **光标返回编辑框,关闭无用的窗口**  
`CTRL+F4`  非常重要下班都用  
`ALT+1..`（数字）  快速打开工程面板  
`CTRL+Q`   显示注释文档  
`CTRL+W`  **选中代码，连续按会有其他效果**  

#### 重构
`Ctrl+Shift+Alt+T`  **重构一切**  

### 使用技巧
---
- Idea中执行RUN=>Reload Changed Class,就可调试修改后程序 。
- File->Settings->Code Style->General中，修改“Right margin (columns)”的值即可改变代码行宽度的限制。
- File->Settings->Editor->General->Code Completion Case sensitive completion: None (不区分大小写)
- Help->Edit Custom Properties...->keymap.windows.as.meta=true 解决windows下面映射Meta键的问题,快捷键和系统快捷键冲突可以通过禁用Win系统快捷键方式解决。
> 需要禁用的快捷键`Win+1F`
- Setting->Inspections->Serialization issues->Serializable class without ’serialVersionUID’ Intellij IDEA 自动生成 serialVersionUID
- Editor -> Live Templates output -> 新建soutl Prints a line separator Template text:System.out.println("---------------------------------------------------------");快捷输入。
- 集成JIRA、UML类图插件、集成SSH、集成FTP、Database管理  
[参考链接](http://blog.csdn.net/RickyIT/article/details/52956108?locationNum=9&fps=1)
- Smart Step Into  
在 Debug 的时候，如果一行代码中有多行语句，我们又需要进入其中的一个方法调用的话，经常做的方法是点开源代码，然后打上断点，或者直接右键 Run to Line，而不能使用快捷键快速将 Debug 的当前行进入到想要去的方法上，Intellij IDEA 提供了 Smart Step Into 的能力，只要使用 Shift + F7，就可以选择到底要 Debug 进入哪一个方法
- Idea多线程debug  
Idea提供了两种挂起的模式，默认的是All，会在我们调试一个线程时，屏蔽另一个线程的断点。也就是说debug模式下可能只有一个主线程在跑。多线程调试只需要选中Thread。
[![idea-debug-20190627172854.png](https://i.postimg.cc/BZyzS1FS/idea-debug-20190627172854.png)](https://postimg.cc/Z08Hjnj2)

#### idea 高级调试技巧
[idea 高级调试技巧](http://www.cnblogs.com/yjmyzz/p/idea-advanced-debug-tips.html)

#### 快速输入
sout
soutp
soutv
soutm
soutl
serr
soutf

### 常见问题
- 解决idea 控制台中文乱码
[参考链接](https://jingyan.baidu.com/article/046a7b3ea33e25f9c27fa93d.html)

### 插件
---
- [插件仓库][0]
- [Key Promoter X][1]
- [.ignore][2]
- [Jindent][3]
- [CheckStyle]
- [FindBugs]
- [javadoc]
- [Maven Helper]
- [GsonFormat]json格式的内容转成Object的需求
- [IdeaVim]
- [Maven Helper]
- [JRebel]
- [AceJump] AceJump其实是一款能够代替鼠标的软件
- [VisualVM Launcher]
- [lombok]
- [IdeaJad]
- [Equals and HashCode Deluxe Generator]
- [save actions]
- [Mongo Plugin] mongo的Idea集成插件
- [Iedis] redis的集成插件  
- [CodeGlance] 类似SublimeText的Mini Map插件
- [sonarlint] 代码检查工具
- [Grep Console] 高亮log不同级别日志，看日志的时候一目了然。  
- [GenerateSerialVersionUID] Alt + Insert 生成serialVersionUID  
- [RestfulToolkit] Java WEB开发必备，再也不用全局搜索RequestMapping了。  
- [Rainbow Brackets] 彩虹括号。自动给代码块内花括号和括号加色，让视野更加注意在代码上。  
- [Alibaba Java Coding Guidelines] 阿里巴巴Java开发规约扫描插件。  
- [String Manipulation] 字符串格式风格快捷转换：大小写、驼峰、连接串等。  
- [MyBatis Log Plugin] MyBatis Log Plugin 这款插件是直接将Mybatis执行的sql脚本显示出来，无需处理，可以直接复制出来执行的  
- [Free MyBtais plugin] Free MyBtais plugin  

### 相关文档
---
- [Idea官网](http://www.jetbrains.com/idea/)

#### 激活服务器
- http://idea.qinxi1992.cn
- http://www.iteblog.com/idea/key.php
- http://idea.iteblog.com/key.php (上次激活可行)

[0]:http://plugins.jetbrains.com/
[1]:http://plugins.jetbrains.com/plugin?pr=idea&pluginId=1003
[2]:http://plugins.jetbrains.com/plugin/7495?pr=objc
[3]:http://www.jindent.com
