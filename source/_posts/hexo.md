---
title: Hexo基础知识
toc: true
tags:
  - install
categories: hexo
---
> hexo是一款基于Node.js的静态博客框架。
> 本文主要内容包括：hexo的基本语法和使用技巧。
> 内容大多数引用其他作者文章，已经标明引用来源。  

<!--more-->

### 相关文档
---
- [hexo官网(官方文档有中文翻译)](https://hexo.io)
- [Node.js >> hexo](https://www.npmjs.com/package/hexo)
- [Github >> hexo](https://github.com/hexojs/hexo)

### 安装
---
#### 环境
- Node.js
- git

``` bash
$ npm install hexo-cli -g #
$ hexo init blog #
$ cd blog #
$ hexo server #
$ hexo new "Hello Hexo" #
$ hexo generate #
```

### 部署
---
#### Openshift
1. openshift上面部署nodejs的环境
2. 安装 Hexo 的 Openshift 插件
`$ npm install hexo-deployer-openshift --save`
3. 编辑Hexo根目录 "_config.yml"的文件
> deploy:  
> 　　type: openshift  
> 　　repo: xxx@xxx:~/git/xxx.git
4. 部署  
`$ hexo [d|deploy]`
5. yes

#### github
1. github上面创建Pages repository
2. 编辑Hexo根目录"_config.yml"
> deploy:  
> 　　type: github  
> 　　repository: https://github.com/catchance/catchance.github.com.git  
> 　　branch: master
3. `$ hexo d`
4. yes

### 基础语法
---
[官方文档的中文翻译](http://www.jianshu.com/p/f935e5459c49)

### 技巧
- 使用swig写主题模板的时候，可以通过`site.posts.sort('-updated')`进行排序
