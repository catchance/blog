---
title: atom
toc: true
tags:
  - 基础
  - 工具
categories:
  - atom
date: 2016-12-21 17:16:59
---
> atom的使用技巧和常用插件  

<!--more-->

### 相关文档
---
- [Atom官网](https://atom.io/)
- [Github >> Git](https://github.com/atom/atom)

### 安装
---
#### Windows
[Download](https://atom.io/download/windows)  
下载相应的exe文件下一步就好了
#### Linux
#### Mac OS X

### 概述
---
#### 概念

#### 命令行
```bash
# atom命令的帮助信息
$ atom -h
# 打开多个文件操作
$ atom [options] [path ...]
```

#### 快捷键
##### 常用
`ctrl+shift+p` 快速搜索 执行命令面板
`ctrl+shift+n` 新建界面窗口(New Window)
`ctrl+n` 新建文件(New File)
`ctrl+o` 打开文件(Open File)
`ctrl+shift+o` 打开文件夹(Open Folder)
`ctrl+alt+o` 加载项目目录(Add Project Folder)
`ctrl+shift+t` 重新加载上次项目(Reopen Last Item)
`ctrl+s` 保存文件
`ctrl+shift+s` 另存为
`ctrl+w` `ctrl+F4` 关闭当前编辑文档
`ctrl+shift+w` 关闭编辑器
`ctrl+z` 撤销
`ctrl+y` 重做
`ctrl+shift+l` 语法选择
`ctrl+shift+m` markdown 预览模式
`alt+shift+s` 查看文件相关语言的代码块(snippet)
`ctrl + f` 搜索当前文件
`ctrl+shift+f` 搜4索整个项目
`alt + ctrl + [` 代码折叠
`alt + ctrl + ]` 代码展开
`ctrl + /` 快速注释当前行
`ctrl + [` 代码左缩进
`ctrl + ]` 代码右缩进
`alt+1..`（数字）  打开相应标签
`Ctrl+T` `Ctrl+P` **来搜索目录中的文件**
`ctrl + b` **快速跳转打开的文件**
`ctrl + shift + b` **快速跳转打开的文件**
`Cmd+K ↓(方向键)` 分栏  
`Cmd+K Cmd+↓(方向键)` 分栏间切换光标焦点  
`f11` 全屏

##### 编辑操作
`ctrl+backspace` `ctrl+w` `alt+backspace` 'editor:delete-to-beginning-of-word'

##### 目录操作
`cmd-\` `cmd-k cmd-b` `tree-view:toggle` 显示(隐藏)目录树
选中文件 + `a` 创建文件和目录  
选中文件 + `m` 移动文件和目录  
选中文件 + `delete` 删除文件和目录  

##### 光标移动快捷键
`ctrl+g` **跳转到某行**

#### atom设置代理
修改 ~/.atom/.apmrc 文件
```bash
http-proxy=http://127.0.0.1:1080
https-proxy=http://127.0.0.1:1080
strict-ssl=false
```
或者
```bash
apm config set strict-ssl false
apm config set http-proxy socks5:127.0.0.1:1080
apm config get http-proxy
apm config set https-proxy socks5:127.0.0.1:1080
apm config get https-proxy
```

#### 插件
插件的安装推荐使用apm,需要在终端运行命令。
国内由于被墙的原因，请切换安装的源 ~/.atom/.apmrc
```bash
registry=https://registry.npm.taobao.org/  
strict-ssl=false
```
```bash
# 安装指定包
$ apm install <package_name>
# 安装指定版本的包
$ apm install <package_name>@<package_version>
# 查找包
$ apm search <package_name>
# 查看包更多详情
$ apm view <packge_name>
# 查看当前已安装包(包含默认Atom捆绑和个人安装)
$ apm list
```
常用插件列表
- markdown-scroll-sync markdown滚动插件
- markdown-writer markdown插件
- markdown-toc Atom TOC插件
- markdown-document 显示md文档的目录
- pretty-json json美化
- git plus git插件
- color-picker 颜色拾取器
- linter 代码风格审核
- [emmet](https://github.com/emmetio/emmet-atom) 前端神器 `$ apm install emmet`
- terminal-plus（这个一直用不了） / platformio-ide-terminal(这个可以使用) atom上面直接使用终端
- atom-miku
- activate-power-mode
- vim-mode / vim-mode-plus vim模式
- ex-mode & relative-numbers 对于vim模式的扩展支持配合:w:s和支持相对行号
- minimap
- split-diff 文件对比工具
