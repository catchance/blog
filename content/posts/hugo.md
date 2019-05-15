+++
title = "Hugo"
description = "description"
keywords = ["hugo"]
categories = ["hugo"]
tags = ["hugo"]
date = 2019-05-04T15:17:02+08:00
draft = true
# CJKLanguage: Chinese, Japanese, Korean
isCJKLanguage = true
# 排序你的文章
weight = 40

# 这里还可以自定义任何参数，这些参数可以在模板中使用
toc = true
comments = false
featured_image = ""
+++

> [Hugo](https://gohugo.io/)是由Go语言实现的静态网站生成器。简单、易用、高效、易扩展、快速部署。
> Hugo以速度快著称，号称是世界上最快的网站生成框架，[5秒生成6000个页面！](https://twitter.com/dzello/status/895835610476199939)
> [官网文档](https://gohugo.io/documentation/)详细，有活跃的[社区](https://discourse.gohugo.io/)，相对于[hexo](https://hexo.io/zh-cn/)，[jekyll](https://jekyllrb.com/)有更加自由的内容组织方式。
> 有丰富的[主题](https://themes.gohugo.io/)，目前主题数量已经超过hexo。
<!--more-->

### 概述
---

### 安装
---
#### os x
使用brew安装， 安装之前可以`brew search hugo`查询  
`brew install hugo`

#### windows
extended版本功能更多，比如SCSSToCSS的功能，解压得到exe文件后，将exe所在的目录添加到系统环境变量，安装成功！

- [hugo_0.55.5_Windows-64bit](https://github.com/gohugoio/hugo/releases/download/v0.55.5/hugo_0.55.5_Windows-64bit.zip)
- [hugo_extended_0.55.5_Windows-64bit](https://github.com/gohugoio/hugo/releases/download/v0.55.5/hugo_extended_0.55.5_Windows-64bit.zip)

#### linux
- ubuntu下面使用`Snap Package` 
```bash
# install the “extended” Sass/SCSS version
> snap install hugo --channel=extended
# install the non-extended version without Sass/SCSS support
> snap install hugo
```
- apt-get(hugo的版本很旧，不建议使用这种方式安装)
```bash
> sudo apt-get install hugo
```

#### Source 
- Git
- Go (at least Go 1.11)
```bash
> mkdir $HOME/src
> cd $HOME/src
> git clone https://github.com/gohugoio/hugo.git
> cd hugo
# Remove --tags extended if you do not want/need Sass/SCSS support.
> go install --tags extended
```

#### 其他系统
请参考[官方文档](https://gohugo.io/getting-started/installing/)

#### 验证
```bash
> hugo version
Hugo Static Site Generator v0.55.0/extended darwin/amd64 BuildDate: unknown
```

### 基本使用
---
#### 建站
```bash
> hugo new site xxx
# 目录结构（ps:可以使用 tree -L 2 命令生成目录结构）
.
├── archetypes  # 储存.md的模板文件
│   └── default.md
├── config.toml # 配置文件
├── content     # 储存网站的所有内容
│   ├── about
│   └── posts
├── static      # 储存图片,css,js等静态文件，该目录下的文件会直接拷贝到/public，该文件夹的优先级高于主题下的/static文件夹
│   └── img
├── themes      # 储存主题
│      └── LeaveIt 
└── public      # 执行hugo命令后，储存生成的静态文件
```

#### 添加一个主题
```bash
# 主题在themes目录下面
> cd xxx
> git init
> git submodule add https://github.com/budparr/gohugo-theme-ananke.git themes/ananke;
# 编辑你的 config.toml 配置文件使用该主题
> echo 'theme = "ananke"' >> config.toml
```
#### 开始写作
`hugo new posts/helloworld.md`
#### 启动内部服务器
```bash
> hugo server -t LeaveIt --ignoreCache --buildDrafts
# -t 使用主题
# -ignoreCache 不使用缓存
# -D --buildDrafts 生成页面包含草稿
```
使用[http://localhost:1313/](http://localhost:1313/)可以访问了

### 高级功能
---
#### Shortcodes
[Shortcodes](https://gohugo.io/content-management/shortcodes/)帮助你在编写markdown时快捷的插入HTML代码，功能上类似于Hexo的标签插件。
```Go HTML Template
{ {< ref "posts/hugo.md" >}} => http://localhost:1313/2019/hugo/
{ {< ref "posts/hugo.md#高级功能" >}} => http://localhost:1313/2019/hugo/#高级功能
```
#### Syntax Highlighting
- [Syntax Highlighting](https://gohugo.io/content-management/syntax-highlighting/)
- [List of Chroma Highlighting Languages](https://gohugo.io/content-management/syntax-highlighting/#list-of-chroma-highlighting-languages)

### 相关文档
---
- [Hugo 从入门到会用](https://blog.olowolo.com/post/hugo-quick-start/)

