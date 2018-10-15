---
title: vim
toc: true
tags:
  - vim
  - start
categories:
  - vim
date: 2016-12-16 11:34:08
---
> vim的相关内容和基本操作  
> 包括常用的vim命令

<!--more-->

### 相关文档和帮助
---
[官网](http://www.vim.org/)

#### vim安装中文帮助手册
- 下载安装包
`wget http://sourceforge.net/projects/vimcdoc/files/vimcdoc/1.8.0/vimcdoc-1.8.0.tar.gz`
- 解压
`tar zxvf vimcdoc-1.8.0.tar.gz`  
- 进入vimcdoc目录，运行安装脚本
`sudo ./vimcdoc.sh -i`
- 帮助方式
```
:help messages@cn 获取中文帮助文档
:h messages@cn
```

### 安装
---
[Download](http://www.vim.org/download.php#pc)

### 配置
vim终极配置:[spf13-vim](https://github.com/spf13/spf13-vim)  
[一行指令安装Spf13打造全功能Vim开发环境](http://www.jianshu.com/p/c512886c7232)

### VimScript .vimrc语法详解
vim程序中使用`:help vim-script-intro`查看帮助文档  
[VimScript](http://blog.csdn.net/smstong/article/details/20724191)  
[vimrc语法](http://blog.csdn.net/hcwzq/article/details/7756590)

### 插件
#### NERDTree
[上古神器vim插件：你真的学会用NERDTree了吗](http://www.jianshu.com/p/3066b3191cb1)

#### Vundle - 基于Git仓库的插件管理软件
Vundle将插件的安装简化为类似yum软件安装的过程  
- Vundle的安装
```bash
$ git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
```
- 更新 ～／.vimrc配置文件  
```  
set nocompatible              " be iMproved  
filetype off                  " required!  
set rtp+=~/.vim/bundle/vundle/  
call vundle#rc()  
" let Vundle manage Vundle  
" required!   
Bundle 'gmarik/vundle'  
" 可以通过以下四种方式指定插件的来源  
" a) 指定Github中vim-scripts仓库中的插件，直接指定插件名称即可，插件明中的空格使用“-”代替。  
Bundle 'L9'  
“ b) 指定Github中其他用户仓库的插件，使用“用户名/插件名称”的方式指定  
Bundle 'tpope/vim-fugitive'  
Bundle 'Lokaltog/vim-easymotion'  
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}  
Bundle 'tpope/vim-rails.git'  
" c) 指定非Github的Git仓库的插件，需要使用git地址  
Bundle 'git://git.wincent.com/command-t.git'  
" d) 指定本地Git仓库中的插件  
Bundle 'file:///Users/gmarik/path/to/plugin'  
filetype plugin indent on     " required!  
```
- Vundle常用命令(vim编辑器中运行就好了)
:BundleList             -列举列表(也就是.vimrc)中配置的所有插件  
:BundleInstall          -安装列表中的全部插件  
:BundleInstall!         -更新列表中的全部插件  
:BundleSearch foo   -查找foo插件  
:BundleSearch! foo  -刷新foo插件缓存  
:BundleClean           -清除列表中没有的插件  
:BundleClean!          -清除列表中没有的插件  

#### vim 配置文件详解
- 默认的配文件路径  
mac /usr/share/vim/vimrc  
linux ／etc/vimrc  

#### vim基本操作
