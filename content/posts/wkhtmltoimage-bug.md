---
title: wkhtmltoimage-bug
toc: true
tags: ["wkhtmltoimage", "bug"]
categories: ["wkhtmltoimage"]
date: 2016-12-13 23:10:04 +08:00
draft: true
---
> [wkhtmltoimage]({{< ref "wkhtmltoimage.md" >}})是将HTML转变成image的帮助软件。  
> wkhtmltoimage软件使用中长出现的一些问题。  
> [Download]({{< relref "wkhtmltoimage.md#相关文档" >}})

<!--more-->

### Error: Could not save image
---
```
...
QPainter::setPen: Painter not active
QPainter:🔚 Painter not active, aborted
Error: Could not save image
Done
Exit with code 1, due to unknown error.
```
解决办法：
```bash
# 增加--width 1280 --height 1600 参数
$ wkhtmltoimage --width 1280 --height 1600 --javascript-delay 10000 --enable-plugins http://www.creationshop.com test.png
```
