---
title: Html和Css常用技巧
toc: true
tags: ["HTML&CSS",  "技巧"]
categories: ["HTML&CSS"]
date: 2016-12-08 17:36:37 +08:00
draft: true
---
> 常用的Html和Css的使用技巧  

<!--more-->

### Html
---

### Css
---
#### 解决页面滚动条出现时候页面布局跳动变化的问题
> 问题描述:css页面布局的时候，当浏览器出现滚动条的时候，会出现位置移动的跳动问题

解决代码：
```css
html {
  overflow-y: scroll;
}

:root {
  overflow-y: auto;
  overflow-x: hidden;
}

:root body {
  position: absolute;
}

body {
  width: 100vw;
  overflow: hidden;
}
```
