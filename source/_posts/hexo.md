---
title: Hexo基础知识
toc: true
tags:
  - install
categories: hexo
---

[hexo](https://www.npmjs.com/package/hexo)

## 安装
---
### 环境
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

## 部署
---
### Openshift
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

### github
1. github上面创建Pages repository
2. 编辑Hexo根目录"_config.yml"
> deploy:  
> 　　type: github  
> 　　repository: https://github.com/catchance/catchance.github.com.git  
> 　　branch: master
3. `$ hexo d`
