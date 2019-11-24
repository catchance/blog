+++
title = "mac os 系统准备"
description = "mac os系统的准备工作"
keywords = ["macos", "osx"]
categories = ["os"]
tags = ["os", "mac os"]
date = 2019-07-13T17:19:55+08:00
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

> - mac os系统的准备工作
> - 工作环境和软件安装相关软件  
<!--more-->

### 常用工具和配置
---
#### brew
[homebrew官网](https://brew.sh/index_zh-cn.html)
``` bash
# ruby命令安装
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

#### brew cask
``` bash
# brew命令安装cask
$ brew install  caskroom/cask/brew-cask 
# 验证
$ brew cask
```

#### Hammerspoon
``` bash
# brew cask 安装
$ brew cask install hammerspoon
```

#### iTerm2

- 直接使用homebrew进行安装  
```bash
$ brew cask install iterm2
```

- 配置iTerm2主题
[download](http://ethanschoonover.com/solarized)  
下载解压后，打开 iTerm2，按Command +键，打开 Preferences 配置界面
然后Profiles -> Colors -> Color Presets  
在下拉列表中选择 Import，选择刚才解压的solarized->iterm2-colors-solarized->Solarized Dark.itermcolors文件.
导入成功后,在 Color Presets下选择 Solarized Dark 主题

- 设置iTerm2图片
打开 iTerm2，按Command +键，打开 Preferences 配置界面Profiles -> Window->Background mage,选择一张自己喜欢的背景图.

- 配置 Oh My Zsh 
[download](https://github.com/robbyrussell/oh-my-zsh)
``` bash
# 一键安装
$ sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# 设置zsh为当前用户的默认shell
$ chsh -s /bin/zsh
# 设置主题为ZSH_THEME="agnoster"。
$ vim ~/.zshrc
```
[zsh其他主题列表](https://github.com/robbyrussell/oh-my-zsh/wiki/themes)

- 配置Meslo字体
[Meslo LG M Regular for Powerline.ttf](https://github.com/powerline/fonts/blob/master/Meslo%20Slashed/Meslo%20LG%20M%20Regular%20for%20Powerline.ttf)
字体下载好后直接安装   
打开 iTerm2，按Command + ,键，打开 Preferences 配置界面，然后Profiles -> Text -> Font -> Chanage Font，选择 Meslo LG M Regular for Powerline 字体。

- 声明高亮（特殊命令和错误命令都会高亮显示）
``` bash
# homebrew安装
$ brew install zsh-syntax-highlighting
# 安装成功之后，编辑vim ～/。zshrc文件最后一行添加下面的配置
$ source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

- 自动建议填充
``` bash
# 克隆zsh-autosuggestions项目，到指定目录
$ git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
# 成功之后，编辑vim ～/。zshrc 找到plugins配置，增加zsh-autosuggestions插件
$ plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
# 当你重新打开终端时可能看不到变化，可能你的字体颜色太淡了，我们把其改亮一些
$ cd ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
# vim 编辑 zsh-autosuggestions.zsh 文件
$ ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'
```

- iterm2快速隐藏和显示窗体  
打开 iTerm2，按Command + ,键，打开 Preferences 配置界面，然后Profiles → Keys →Hotkey，自定义一个快捷键就可以了.比如`command+.`

- iTerm2隐藏用户名和主机名
``` bash
# 编辑vim ~/.zshrc文件，增加DEFAULT_USER="xxx"配置.
# 可以通过whoami查看当前用户
$ whami
```

- iTerm2常用快捷键
    - `command + t` 新建标签
    - `command + w` 关闭标签
    - `command + 数字 command + 左右方向键`    切换标签
    - `command + enter` 切换全屏
    - `command + f` 查找
    - `command + d` 水平分屏
    - `command + shift + d` 垂直分屏
    - `command + option + 方向键 command + [ 或 command + ]`    切换屏幕
    - `command + ;` 查看历史命令
    - `command + shift + h` 查看剪贴板历史
    - `ctrl + u`    清除当前行
    - `ctrl + l`    清屏
    - `ctrl + a`    到行首
    - `ctrl + e`    到行尾
    - `ctrl + f/b`  前进后退
    - `ctrl + p `   上一条命令
    - `ctrl + r`    搜索命令历史

#### mpv视频播放软件

### macos使用技巧和快捷键
#### 怎么显示隐藏文件
- 打开访达，在访达左侧点击隐藏文件所在的目录。
- 在隐藏文件所在的目录按键盘上面的 `shift+cmmand+.`

### 相关文档
---
- [Mac下终端工具iTerm2安装](https://www.jianshu.com/p/ba08713c2b19)
- [github > zsh](https://github.com/robbyrussell/oh-my-zsh)

