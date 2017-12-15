---
title: chrome
toc: true
tags:
  - chrome
  - 工具
categories:
  - chrmoe
date: 2016-12-28 18:28:06
---
> chrome浏览器的使用

<!--more-->

### 安装
---

### 快捷键
---
`ctrl+shift+n` 新建隐身窗口
`ctrl+t` 打开新的标签页
`ctrl+n` 打开新的窗口
`ctrl+shift+t` 重新打开上一次关闭的页面
`ctrl+j` 打开下载内容
`ctrl+w` `ctrl+f4`  关闭标签页
`ctrl+shift+w` `alt+f4` 关闭浏览器
`ctrl+p` 打印
`ctrl+f` 查找
`ctrl+s` 保存网页
`ctrl+shift-delete` 清除浏览数据
`ctrl+h` 打开历史记录
`ctrl+d` 为当前打开的页面添加书签
`ctrl+shift+d` 为所有的标签页添加书签
`ctrl+shift+b` 显示/隐藏书签栏
`ctrl+shift+o` 书签管理器  
`shift+esc` 打开Chrome任务管理器
`ctrl+shift+i` `f12` 打开调试窗口
`f1` Google浏览器帮助中心
`Ctrl++` 放大页面
`Ctrl+-` 缩小页面
`Ctrl+0` 默认页面字体大小
`Ctrl+Tab` 从左到右，标签循环浏览
`Ctrl+Shift+Tab` 从右到左，标签循环浏览
`Ctrl+1-8` 分别指向第1、2、3…8标签
`Ctrl+9` 跳转到最后一个标签
`alt+home` 在当前标签打开首页
`alt+d` `ctrl+l` `f6` 迅速突出地址栏
`ctrl+enter` 在地址栏自动添加www或.com
`Ctrl+Shift+V` 粘帖剪切板中的纯文本格式
`Shift+Alt+T` 将焦点聚集到工具栏中的第一个工具
`Space or Enter (after Shift+Alt+T)` 可激活工具栏按钮
`Tab (after Shift+Alt+T)` 工具栏中将焦点移到各个选项上
`Shift+F10 (after Shift+Alt+T)` 可打开相关右键菜单
`Esc (after Shift+Alt+T)` 可将焦点从工具栏移回到网页上
`alt+←` 前进
`alt+→` 后退
`ctrl+u` 查看源代码

### chrome命令支持
---
chrome://about

### chrome插件
---
- JSONView
- 印象笔记·剪藏 （笔记）
- 马克飞象 （MD）
- Remarkerbe （标记）
- Clear your downloads list automatically（自动清除下载历史记录）
- Awesome Screenshot / Smartshot （截图）
- Adguard / Adblock Plus （广告拦截）
- 谷歌翻译 / Imtranslator
- Atavi / iCloud / Xmarks Bookmark Sync（跨浏览器同步备份书签）
- Infinity新标签页(Pro)
- Vimium
- Octotree 程序员神器浏览github方便浏览目录
- Push to Kindle
- wappalyzer 分析网站使用了哪些技术
- XV — XML Viewer / XML Tree XML文件浏览的插件
- Tampermonkey 互联网神器——Greasemonkey（油猴脚本）/ Tampermonkey，它能让你除去这些烦恼，甚至，按照你想要的方式来定制网站，享受属于你自己的互联网
- Sourcegraph for GitHub 方便浏览github上面代码的插件
- ZenHub for GitHub
- 流浪节省程序

### chrome 控制台
---
`F12`进入chrome开发者工具

#### Console API
挂在window.console这个对象下面的方法，统称为Console API
console控制台使用`shift+enter`可以编写多行代码
- console.log的使用
```
  console.log('log');
  console.info('info');
  console.warn('warn');
  console.error('error');
  console.log('%chello world','font-size:25px;color:red;');
```
```
  console.group("app.foo");
  console.log("来自foo模块的信息 blah blah blah...");
  console.groupEnd();
  console.group("app.bar");
  console.log("来自bar模块的信息 blah blah blah...");
  console.groupEnd();
```

- console.table

  ```
  var data = [{'品名': '杜雷斯', '数量': 4}, {'品名': '冈本', '数量': 3}];
  console.table(data);

  ```  

- console.assert
  ```
  var isDebug = false;
  console.assert(isDebug,'develop log message...');
  ```

- console.count

  ```
  > function foo(){
      console.count('foo ...');
    }
  > foo();
  > foo();
  > foo();
  ```

- console.dir
  ```
  console.dir(document.body);
  console.dir(document.body);
  ```

- console.time & console.timeEnd
  ```
  console.time("Array initialize");
  var array= new Array(1000000);
  for (var i = array.length - 1; i >= 0; i--) {
    array[i] = new Object();
  };
  console.timeEnd("Array initialize");
  ```

#### Command Line API
Chrome内置提供，在控制台中使用的，他们统称为Command Line API
- `$_` 命令返回最近一次表达式执行的结果
```
> 2 + 2
< 4
> $_+1
< 5
```

- `$0~$4` 代表了最近5个你选择过的DOM节点

- chrome 控制台中原生支持类JQuery的选择器
```
> $('body') // $(selector)是原生JavaScript document.querySelector()
> $$('a') //命令$$(selector)返回的是所有满足选择条件的元素的一个集合，是对document.querySelectorAll() 的封装
```

- copy 命令
```
> copy(document.body);
```
gi
- keys & values
```
> var tboy={name:'wayou',gender:'unknown',hobby:'opposite to the gender'};
> keys(tboy)
> values(tboy)
```

- monitor & unmonitor
  ```
  function sayHello(name){
    alert('hello,'+name);
  }
  monitor(sayHello);
  sayHello('wayou');
  unmonitor(sayHello);
  sayHello('wayou');
  ```

- debug & undebug
debug同样也是接收一个函数名作为参数。当该函数执行时自动断下来以供调试，类似于在该函数的入口处打了个断点，可以通过debugger来做到，同时也可以通过在Chrome开发者工具里找到相应源码然后手动打断点。

### chrome 技巧
---
- 快速切换文件
`ctrl+p` | `cmd+p` Go to anything 就能快速搜寻和打开你项目的文件。
- 在源代码中搜索
`ctrl+shift+f` | `cmd+opt+f`
- 快速跳转到指定行
`ctrl+g` | `cmd+l`
- 使用多个插入符进行选择
你可以按住Ctrl（cmd），在你要编辑的地方点击鼠标，可以设置多个插入符，这样可以一次在多个地方编辑。
- 保存记录
- 优质打印
Chrome’s Developer Tools有内建的美化代码，可以返回一段最小化且格式易读的代码。Pretty Print的按钮在Sources标签的左下角。
- 设备模式
对于开发移动友好页面，DevTools包含了一个非常强大的模式，这个谷歌视频介绍了其主要特点，如调整屏幕大小、触摸仿真和模拟糟糕的网络连接。
- 强制改变元素状态
DevTools有一个可以模拟CSS状态的功能，例如元素的hover和focus,可以很容易的改变元素样式。在CSS编辑器中可以利用这个功能
- 选择下一个匹配项
当在Sources标签下编辑文件时，按下Ctrl + D (Cmd + D) ，当前选中的单词的下一个匹配也会被选中，有利于你同时对它们进行编辑。
- 改变颜色格式
在颜色预览功能使用快捷键Shift + 点击，可以在rgba、hsl和hexadecimal来回切换颜色的格式
- 通过workspaces来编辑本地文件
Workspaces是Chrome DevTools的一个强大功能，这使DevTools变成了一个真正的IDE。Workspaces会将Sources选项卡中的文件和本地项目中的文件进行匹配，所以你可以直接编辑和保存，而不必复制/粘贴外部改变的文件到编辑器。为了配置Workspaces，只需打开Sources选项，然后右击左边面板的任何一个地方，选择 Add Folder To Worskpace，或者只是把你的整个工程文件夹拖放入Developer Tool。
