---
title: Markdown基础知识
toc: true
tags:
  - base
categories: markdown
---
> 本文主要内容包括：markdwon的基本语法和使用技巧。  

<!--more-->

### 相关文档
---
- [创始人 John Gruber 的 Markdown 语法说明](http://daringfireball.net/projects/markdown/syntax)
- [Markdown 中文版语法说明](http://wowubuntu.com/markdown/)
- [Html特殊符号](http://tool.chinaz.com/Tools/HtmlChar.aspx)

### 概述
---
#### 宗旨
易读易写

#### 编辑工具
- Mou
Mac OS X 系统可以使用，支持实时预览功能
- Atom
多端可以使用，就是效率很低。有时候很卡。
- 简书
Web端使用简书编辑也是不错的选择。可以保存在云端。

#### 兼容 HTML
- 区块元素(`<div>` `<table>` `<pre>` `<p>`)
  ``` html
  这是一个普通的段落。
  <table>
    <tr>
      <td>*Hello*</td>
      <td>Word</td>
    </tr>
  </table>
  这是另外一个段落。
  ```
  这是一个普通的段落。
  <table><tr><td>*Hello*</td><td>Word</td></tr></table>
  这是另外一个段落。
- HTML 区块标签间的 Markdown 格式语法将不会被处理
- 行内标签(`<span>` `<cite>` `<del>`)可以随意使用
- `<a>` `<img>`可以直接使用
``` html
<a href="http://www.baidu.com">百度</a>
```
  <a href="http://www.baidu.com">百度</a>
- 特殊字符自动转换
  ``` html
    AT&T
    &copy;
  ```
  AT&T  
  &copy;

#### 基本符号
- `*,-,+` 3个符号效果都一样，这3个符号被称为**Markdown符号**
- 空白行表示另起一个段落
- `` ` ``是表示inline代码，tab是用来标记 代码段，分别对应html的code，pre标签

### 区块元素
---
#### 段落和换行
段落是由前后一个以上的[空行]( <#no> "显示上看起来像是空的，便会被视为空行。比方说，若某一行只包含空格和制表符，则该行也会被视为空行")产生的，普通段落不该用空格或制表符来缩进。

#### 标题
- Setext 形式
  ```
  这是 H1
  =============
  这是 H2
  -------------
  ```

- atx 形式
  ```
  # 这是 H1
  ## 这是 H2
  ###### 这是 H6
  ```

#### 区块引用 Blockquotes
```
> 这是一个区块引用
  Markdown 也允许你偷懒只在整个段落的第一行最前面加上 >
>> 区块引用可以嵌套
>>> 区块引用可以嵌套  
>>> - 这是第一行列表项。
>>> - 这是第二行列表项。

>> 区块引用可以嵌套

> 区块引用可以嵌套
```
> 这是一个区块引用
  Markdown 也允许你偷懒只在整个段落的第一行最前面加上 `>`
>> 区块引用可以嵌套
>>> 区块引用可以嵌套  
>>> - 这是第一行列表项。  
>>> - 这是第二行列表项。

>> 区块引用可以嵌套

> 区块引用可以嵌套

#### 列表
无序列表使用星号、加号或是减号作为列表标记：
```
  *   Red
  -   Green
  +   Blue  
```
*   Red
-   Green
+   Blue  

有序列表则使用数字接着一个英文句点
```
1. Bird  
  第二段  
  第三段

2. McHale
  > 这是一个区块引用
  > 这是一个区块引用
3. Parish
4. 一列表项包含一个列表区块:  
  <代码写在这>
1986. 有序列表前面的序号不起作用
1986\. 避免这种`数字-句点-空白`生成列表
```
1. Bird  
  第二段  
  第三段

2. McHale
  > 这是一个区块引用
  > 这是一个区块引用
3. Parish
4. 一列表项包含一个列表区块:  
  `代码写在这`  
1986. 有序列表前面的序号不起作用
1986\. 避免这种`数字-句点-空白`生成列表

#### 代码区块
##### markdwon语法
缩进 4 个空格或是 1 个制表符
```
这是一个普通段落：

    这是一个代码区块。

      import java.io.*;
```

这是一个普通段落：

  这是一个代码区块。

    import java.io.*;
    <div class="footer">
      &copy; 2004 Foo Corporation
    </div>  

```
  `这是一个代码区块`
```
`这是一个代码区块`

<pre>
  &#39;&#39;&#39;
    这是一个代码区块
  &#39;&#39;&#39;
</pre>

```
  这是一个代码区块
```

##### html方式
`<pre>` `<code>`

#### 分隔线
```
  ***
  * * *
  ---
  - - -
```

***

* * *

---

- - -

#### 表格(扩展的markdown才支持)
注意冒号是对齐方式
```
| Tablees    | Are           | Coll  |
| ----------:|:-------------:|:------|
| col 3 is   | right-aligned | $160  |
| col 2 is   | centered      | $12   |
| col 2 is   | centered      | $12   |
```
| Tablees    | Are           | Coll  |
| ----------:|:-------------:|:------|
| col 3 is   | right-aligned | $160  |
| col 2 is   | centered      | $12   |
| col 2 is   | centered      | $12   |

#### 流程图
[参考](http://blog.csdn.net/aizhaoyu/article/details/44350821)
```flow  
  st=>start: Start
  i=>inputoutput: 输入年份n
  cond1=>condition: n能否被4整除？
  cond2=>condition: n能否被100整除？
  cond3=>condition: n能否被400整除？
  o1=>inputoutput: 输出非闰年
  o2=>inputoutput: 输出非闰年
  o3=>inputoutput: 输出闰年
  o4=>inputoutput: 输出闰年
  e=>end: End

  st->i->cond1
  cond1(no)->o1->e
  cond1(yes)->cond2
  cond2(no)->o3->e
  cond2(yes)->cond3
  cond3(yes)->o2->e
  cond3(no)->o4->e
```

#### 插入LaTeX公式
[参考](http://blog.csdn.net/xiahouzuoxin/article/details/26478179)
- 使用MathJax引擎
```html
<script type="text/javascript"  
        src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=default">
</script>
```
使用Tex写公式。`$$公式$$`表示行间公式，本来Tex中使用\(公式\)表示行内公式，但因为Markdown中\是转义字符，所以在Markdown中输入行内公式使用\\(公式\\)，如下代码：
```
  $$x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}$$
  \\(x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}\\)
```
  $$x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}$$
  \\(x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}\\)

### 区段元素
---
#### 强调

```
*斜体* _斜体_
**粗体** __粗体__
~~删除线~~
<u>下划线</u>
上标<sup>2</sup>
下标<sub>2</sub>
```
*斜体* _斜体_  
**粗体** __粗体__  
~~删除线~~  
<u>下划线</u>
上标<sup>2</sup>  
下标<sub>2</sub>    

#### 链接
- 行内式
  ```
  这是一个[行内式的链接](http://tech.xchance.xyz "可选的title")
  这是一个[相对路径的连链接](/about "可选的title")
  ```
  这是一个[行内式的链接](http://tech.xchance.xyz "可选的title")  
  这是一个[相对路径的连链接](/about "可选的title")
- 参考式
  `这是一个[参考式的连接] [1]`  
  `[1]: http://tech.xchance.xyz "Github 个人主页"`  
  `[2]: <http://tech.xchance.xyz> "Github 个人主页"`  
  `[3]: http://tech.xchance.xyz 'Github 个人主页'`  
  `[4]: http://tech.xchance.xyz (Github 个人主页)`  
  [参考式的连接][1]  
  `隐式链接标记:[Google Address][]`  
  `[Google Address]: http://google.com/`

  [Google Address][]
  [Google Address]: http://google.com/
  [id]: http://tech.xchance.xyz
- 简写Url
  ```
  <http://tech.xchance.xyz>
  <catchance@163.com>
  ```
  <http://tech.xchance.xyz>  
  <catchance@163.com>

#### 图片
类似链接方式同样支持**行内式**、**参考式**和**`<img>`**  
hexo好像不支持可选文字
```
  ![Alt text](http://tech.xchance.xyz/favicon.ico)
  ![Alt text](/path/to/img.jpg "Optional title")
  ![Alt text][id]
  [id]: url/to/image  "Optional title attribute"
```
![Alt text](http://tech.xchance.xyz/favicon.ico)
![Alt text](http://tech.xchance.xyz/favicon.ico)

#### 注脚
原始Markdown语法好像不支持，不过有些Blog是支持的
```
  这是一个注脚[^footer]
  [^footer]: 这是一个注脚
```
这是一个注脚 [^1]
[^1]: 这是一个注脚

#### 页内跳转
```
  定义锚点: <span id="jump"> hello world </span>
  使用锚点: [hello](#jump)
```
定义锚点: <span id="jump"> hello world </span>  
使用锚点: [hello](#jump)


### 技巧
---
- 使用两个以上的空格然后回车插入`<br />` 标签
- 特殊字符需要`\`字符来转义:
  ``\  `  * _ {} [] () # + - . ! ``
- 如果要在代码区段内插入反引号，你可以用多个反引号来开启和结束代码区段
```
  代码块中插入反引号：`` ` ``
```
  代码块中插入反引号：`` ` ``
- 段首缩进技巧：
  切换到全角模式下（一般的中文输入法都是按 shift + space）输入两个空格就行了
- 文章中插入注释的话，可以使用`<!-- -->`


### 名词解释
---
<span id ="ref1">**空行**</span> 显示上看起来像是空的，便会被视为空行。比方说，若某一行只包含空格和制表符，则该行也会被视为空行

[1]: http://tech.xchance.xyz "Github 个人主页"
[2]: <http://tech.xchance.xyz> "Github 个人主页"
[3]: http://tech.xchance.xyz 'Github 个人主页'
[4]: http://tech.xchance.xyz (Github 个人主页)  
