---
title: atom-vim-mode-plus
toc: true
tags: ["插件", "工具"]
categories: ["atom"]
date: 2016-12-27 11:11:37 +08:00
draft: true
---
> atom的插件vim-mode-plus的使用  

<!--more-->

### 概述
---

#### 快捷键
`ctrl+w z` `cmd+center`  'vim-mode-plus:maximize-pane'  最大化工作窗口
`escape` `ctrl+c` `ctrl+[` 'vim-mode-plus:reset-normal-mode' vim退出正常模式

#### 编辑快捷键
`ctrl+w` 'editor:delete-to-beginning-of-word' **删除光标位置到单词开始**
`ctrl+u` 'editor:delete-to-beginning-of-line' **删除光标到行开始位置的字符**
`ctrl+y` 'vim-mode-plus:copy-from-line-above' **复制光标上一行的字符**
`ctrl+o` 'vim-mode-plus:activate-normal-mode-once' **由插入模式转变成正常模式一次然后自动返回插入模式**
`ctrl+r` 'vim-mode-plus:insert-register' 插入寄存器(？)

#### 移动
`h` `left` `backspace` 'vim-mode-plus:move-left'
`l` `right` `space` 'vim-mode-plus:move-right'
`k` `up` 'vim-mode-plus:move-up'
`j` `down` 'vim-mode-plus:move-down'
`w` 'vim-mode-plus:move-to-next-word' 移动到一个单词的结尾
`W` 'vim-mode-plus:move-to-next-whole-word' 移动到整个单词的结尾
`e` 'vim-mode-plus:move-to-end-of-word'
`E` 'vim-mode-plus:move-to-end-of-whole-word'
`b` 'vim-mode-plus:move-to-previous-word'
`B` 'vim-mode-plus:move-to-previous-whole-word'
`)` 'vim-mode-plus:move-to-next-sentence'
`(` 'vim-mode-plus:move-to-previous-sentence'
`}` 'vim-mode-plus:move-to-next-paragraph'
`{` 'vim-mode-plus:move-to-previous-paragraph'
`0` `home` 'vim-mode-plus:move-to-beginning-of-line'
`|` 'vim-mode-plus:move-to-column'
`^` 'vim-mode-plus:move-to-first-character-of-line'
`_` 'vim-mode-plus:move-to-first-character-of-line-and-down'
`$` `end` 'vim-mode-plus:move-to-last-character-of-line'
`g _`  'vim-mode-plus:move-to-last-nonblank-character-of-line-and-down'
`-` 'vim-mode-plus:move-to-first-character-of-line-up'
`+` `enter` 'vim-mode-plus:move-to-first-character-of-line-down'

#### scroll
`ctrl-u(up)` 'vim-mode-plus:scroll-half-screen-up' 向上翻半页
`ctrl-d(down)` 'vim-mode-plus:scroll-half-screen-down' 向下翻半页
`ctrl-b` 'vim-mode-plus:scroll-full-screen-up' 向上翻一页
`ctrl-f` 'vim-mode-plus:scroll-full-screen-down' 向下翻一页
`ctrl-e` 'vim-mode-plus:scroll-down' 向下滚动  
`ctrl-y` 'vim-mode-plus:scroll-up' 向上滚动  
`[2|3...] G(go)` 'vim-mode-plus:move-to-last-line' 移动到最后一行
`g g(1G)` 'vim-mode-plus:move-to-first-line' 移动到第一行
`H(head)` 'vim-mode-plus:move-to-top-of-screen' 移动到一屏的开头
`L(last)` 'vim-mode-plus:move-to-bottom-of-screen' 移动到一屏幕的结尾
`M(middle)` 'vim-mode-plus:move-to-middle-of-screen' 移动到可是屏幕的中间

#### Operator
`d` 'vim-mode-plus:delete'
`c` 'vim-mode-plus:change'
`s` 'vim-mode-plus:substitute'
`x` 'vim-mode-plus:delete-right' # to avoid `d x` is treated as `d d`
`D` 'vim-mode-plus:delete-line'
`C` 'vim-mode-plus:change-to-last-character-of-line'
`S` 'vim-mode-plus:substitute-line'
`r` 'vim-mode-plus:replace'
`g o` 'vim-mode-plus:toggle-preset-occurrence'
`g .` 'vim-mode-plus:add-preset-occurrence-from-last-occurrence-pattern'
