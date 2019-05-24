+++
title = "MyBatis踩坑系列"
description = "MyBatis大小坑"
keywords = ["bug", "mybatis", "pageHelper"]
categories = ["bug"]
tags = ["mybatis","pageHelper"]
date = 2019-05-21T14:32:41+08:00
draft = true
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

> MyBatis大小坑系列
<!--more-->

### 使用PageHelper获取到的分页数据不正确
---
#### 问题（坑）描述
使用PageHelper组件进行分页的时候，超过的数据的最大页后也会返回数据，使用的是如下方式进行分页：
``` java
PageHelper.startPage(pageIndex, pageSize);
```

#### Why？
经过查询相关资料发现 pageHelper里面自带的一个功能，叫做reasonable分页参数合理化。
当`reasonable:true`时在`pageNum<1`会查询第一页，如果`pageNum>pages`会查询最后一页。
也就是说当pageNum>你的最大页数时会返回最后一页的数据而不是返回`null`。

#### 解决
禁用合理化，如果`pageNum<1`或`pageNum>pages`会返回空数据，
所以如果不希望这种情况则需要设置`reasonable:false`

- 看官网新版好像默认是`false`了

#### 相关参考
[分页插件参数介绍](https://pagehelper.github.io/docs/howtouse/)
