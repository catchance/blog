---
title: Git基础知识
toc: true
tags: ["install"]
categories: ["git"]
keywords: ["git"]
description: "Git基础知识"
draft: true
---
> 本文包括git的简介、基本使用方法、部分原理。
> 这么好用的工具必须安利大家使用，真的是越使用越觉得其强大的功能。
> 用过图形界面和命令行，还是命令行下面使用的得心用手，推荐大家了解原理后使用命令行。

<!--more-->  

### 相关文档
---
- [git官网](https://git-scm.com/)
- [download](https://git-scm.com/downloads)
- [官方中文文档](https://git-scm.com/book/zh/v2)
- [Github >> Git](https://github.com/git/git)

### 安装
---
#### Windows
下载相应包安装即可
#### Linux
```bash
  $ sudo yum install git #yum软件包管理工具
  $ sudo apt-get install git #基于Debian的发行版
```
#### Mac OS X
Terminal 里尝试首次运行 git 命令即可，会提示你安装
#### 源码安装
#### 命令校验是否安装成功
``` bash
$ git --version
```

### 概述
---
#### 概念
- 直接记录快照，而非差异比较
- 近乎所有操作都是本地执行
- Git 保证完整性
- Git 一般只添加数据
- 三种状态
  - 已提交（committed） 对应 .git directory(Repository) 工作区域
  - 已修改（modified） 对应 Working Directory工作区域
  - 已暂存（staged/Index） 对应 Index/Staging Area工作区域
- HEAD Git 中的 HEAD 可以理解为指针，指向当前仓库所处的分支，如果我们使用的是
来切换到指定的某一次提交，HEAD 就会处于 **detached** 状态，也就是游离状态
- up-stream git的远程仓库上的一个分支名字，（形象理解为 上游）本地新建立的分支是没有这个up-stream信息，
所以git push的时候会提示你不能push，因为没有这个up-stream

#### 配置
- 系统级别：`/etc/gitconfig`,通过`git config --system`命令来配置
- 用户级别：`~/.gitconfig`或者`~/.config/git/config`,通过`git config --global`来配置
- 仓库级别：`.git/config`
```bash
# 设置用户名
$ git config --global user.name "xxx"
# 设置email
$ git config --global user.email "xxx@xx.com"
# 设置默认文本编辑器，当Git需要你输入信息的时候会调用它
$ git config --global core.editor emacs
# 检查配置信息
$ git config --list
# 设置credential cache，省得多次输入密码
$ git config --global credential.helper cache
```

#### git引用 **^** 和 **~** 的区别
- **`(<commit>|HEAD)^`** 代表父提交,当一个提交有多个父提交时，可以通过在`^`后面跟上一个数字，表示第几个父提交，`^`相当于`^1`。
- **`(<commit>|HEAD)~<n>`** 指的是第n个祖先提交，用一个等式来说明就是：(<commit>|HEAD)~n = (<commit>|HEAD)^^^….(^的个数为n)。
- checkout只会移动HEAD指针，reset会改变对应分支的引用值和HEAD的引用值。

#### 获取帮助
```bash
# 有关命令的更多信息
$ git <verb> --help
$ git help <verb>
$ man git-<verb>
```
### 基础文件操作
---
#### 获取Git仓库
- `git init`将现有目录和文件初始化一个Git仓库，会生成一个.git文件夹（这个文件夹就是本地Git仓库）
- `git clone [url]`来克隆现有的仓库
```bash
$ git clone https://github.com/catchance/git-learning.git git-learning
```

#### 检查当前文件状态
```bash
$ git status
```
`git status`命令的功能:

- 查看当前工作区的状态

#### 忽略文件
创建.gitignore文件来来将某些文件不纳入Git管理
```bash
# 忽略所有以 .o 或 .a 结尾的文件
*.[oa]
# Git 忽略所有以波浪符（~）结尾的文件
*~
```
- 匹配模式可以以`/`开头防止递归
- 匹配模式可以以`/`结尾指定目录
- 所有空行或者以 ＃ 开头的行都会被 Git 忽略。
- 可以使用标准的 glob 模式匹配(指`shell`所使用的简化了的正则表达式)
    - 星号（*）匹配零个或多个任意字符；
    - [abc] 匹配任何一个列在方括号中的字符
    - 问号（?）只匹配一个任意字符
    - 使用两个星号（*) 表示匹配任意中间目录`a/**/z`
    - 方括号中使用短划线分隔两个字符，表示所有在这两个字符范围内的都可以匹配`[0-9]`

#### 跟踪文件,将文件添加到暂存区，文件处于暂存状态。
```bash
# 跟踪文件，文件处于暂存状态 默认是忽略溢出的操作
$ git add <file>...
# 跟踪文件，文件处于暂存状态 同时对于删除的操作进行记录
$ git add --all <file>...
# 将文件撤出未跟踪的状态
$ git reset HEAD <file>...
# 将已经修改的文件还原成HEAD索引指向的版本
$ git checkout -- <file>...
```
1. `HEAD`指向当前所在分支，将`HEAD`想象为当前分支的别名。
2. git add命令的功能：  
    - 可以用它开始跟踪新文件
    - 把已跟踪的文件放到暂存区
    - 合并时把有冲突的文件标记为已解决
3. git checkout --命令
    - 撤销对工作区修改，这个命令是以最新的存储时间节点（add和commit）为参照
    - 覆盖工作区对应文件file；这个命令改变的是工作区
4. git reset命令
    - 清空add命令向暂存区提交的关于file文件的修改（Ustage）
    - 这个命令仅改变暂存区，并不改变工作区

#### 对比文件信息
```bash
# 对比工作目录中的文件和暂存区的区别
$ git diff
# 对比暂存区的文件和上一次提交的不同
$ git diff --cached
# 效果等同于 --cached命令
$ git diff --staged
# 可以使用diff插件来分析结果
$ git difftool --tool-help
```

#### `git show`命令
- 显示具体的代码改动情况
  ```bash
  # 查看某次commit的修改内容
  $ git show <commit-hash-id>
  ```

#### 提交更新
```bash
# 提交更新
$ git commit -m "message"
# 跳过暂存区直接提交
$ git commit -a -m "message"
# git 修改上次git commit的时间(date -R获取当前时间的命令)
# `date -R` 也可以使用 "$(date -R)"
# --date 的时间格式为 "Sun, 25 Dec 2018 20:00:00 +0800"
# git commit –amend既可以对上次提交的内容进行修改，也可以修改提交说明，也可以修改提交时间。
> git commit --amend --date=`date -R` 
```
- 提交时记录的是放在暂存区域的快照
- 每一次运行提交操作，都是对你项目作一次快照，以后可以回到这个状态，或者进行比较。

#### 移除文件
```bash
# 将删除的文件提交 rm <file>
$ git add --all <file>... 提交工作空间中删除的文件
# 同 git add 命令一样的
$ git rm <file>
# 如果工作空间不想删除，而只是想删除Git跟踪的文件的话
$ git rm --cached <file>...
```

#### 移动文件
```bash
# Git 并不显式跟踪文件移动操作
# 如果在 Git 中重命名了某个文件，仓库中存储的元数据并不会体现出这是一次改名操作
# git mv命令相当于 mv xx xxx git rm xx git add xxx
$ git mv <file> <file>
```

#### 查看提交历史
`git log`命令的输出格式多种多样，自行参考帮助文档。
```bash
# 查询提交历史
$ git log
# 常用提交信息
$ git log --oneline --graph --all --decorate
# -2 用来显示最近两次提交，-p用来显示每次提交的内容差异
$ git log -p -2
# 查看某个文件的修改历史
$ git log -p <filename>
# 除了显示基本信息之外，还附带了每次 commit 的变化
$ git log --stat
# 可以指定使用不同于默认格式的方式展示提交历史
$ git log --pretty=oneline
# 添加了一些ASCII字符串来形象地展示你的分支、合并历史
$ git log --graph
# 显示某个路径或者文件的提交历史
$ git log -- <path>
```
**git log 命令乱码的问题解决方法**

- git config --global i18n.commitencoding utf-8
- git config --global i18n.logoutputencoding gbk
- export LESSCHARSET=utf-8

#### 查询引用变更的记录
```bash
# 查询操作的相关记录
$ git reflog
```

#### 撤销操作
```bash
# 重新提交命令
# 这个命令会将暂存区中的文件提交,如果快照会保持不变，而你所修改的只是提交信息。
$ git commit --amend
# 撤销暂存区的记录，工作区的文件不变。
$ git reset HEAD <path>
# 重置工作区中的文件，从暂存区或者上次提交中重置文件。
$ git checkout -- <path>
```

#### git cherry-pick用于把另一个本地分支的commit修改应用到当前分支。
```bash
git cherry-pick <commit id>
```

### 远程仓库
---
#### 查看远程仓库信息
```bash
# 列出你指定的每一个远程服务器的简写
$ git remote  
#会显示需要读写远程仓库使用的 Git 保存的简写与其对应的 URL。
$ git remote -v
# 要查看某一个远程仓库的更多信息
$ git remote show origin
```

#### 添加远程仓库
```bash
# 添加一个新的远程 Git 仓库，同时指定一个你可以轻松引用的简写
$ git remote add <shortname> <url>
```

#### 从远程仓库中抓取与拉取
```bash
# 从远程仓库中获得数据,它并不会自动合并或修改你当前的工作
> git fetch <remote-name>
# 通常会从最初克隆的服务器上抓取数据并自动尝试合并到当前所在的分支。
> git pull <remote-name>
> git pull <remote-name> --rebase 
```

#### 推送到远程仓库
```bash
# 要将 master 分支推送到 origin 服务器时 `git push [remote-name] [branch-name]`
$ git push origin master
```

#### 远程仓库的移除与重命名
```bash
# 修改你的远程分支名字
$ git remote rename pb paul
$ git remote
# 移除一个远程仓库
$ git remote rm paul
$ git remote
```

#### 打标签
```bash
# 过滤显示定义的标签
$ git tag -l 'v1.8.5*'
# 创建标签
$ git tag -a v1.4 -m 'my version 1.4'
# 轻量标签 轻量标签本质上是将提交校验和存储到一个文件中 - 没有保存任何其他信息。
$ git tag v1.4-lw
# 后期打标签 9fceb2每次提交的校验和
$ git tag -a v1.2 9fceb2  
# 共享标签 默认情况下，git push 命令并不会传送标签到远程仓库服务器上。
# 在创建完标签后你必须显式地推送标签到共享服务器上。
$ git push origin [tagname]
# 检出标签 `git checkout -b [branchname] [tagname]`
$ git checkout -b version2 v2.0.0
```

#### Git别名
```bash
# 取消暂存文件别名
git config --global alias.unstage 'reset HEAD --'
# 轻松地看到最后一次提交
git config --global alias.last 'log -1 HEAD'
```

### Git分支
---
#### 创建分支
创建分支，就相当于在当前分支上面创建一个指针。  
Git有一个HEAD的特殊指针，指向当前所在的本地分支。
```bash
# 创建分支
$ git branch testing
```

#### stash的常用操作
```bash
$ git stash  #保存当前的修改
$ git stash pop #弹出stash中最顶端的即stash<0>的内容
$ git stash list #查看stash中所有的改动
$ git stash apply @stash<id> #弹出stash<id>的修改
$ git stash pop @stash<id> #弹出stash<id>的修改
$ git stash clear  #清除所有的stash
$ git stash drop @stash<id>  #移除stash<id>
```

#### 切换分支
切换分支的时候通过保存进度（stashing） 和 修补提交（commit amending）
保持好一个干净的状态。
```bash
$ git checkout testing
$ git checkout master
# 创建分支并且切换分支
$ git checkout -b <branchname>
```

#### 删除分支
```bash
# 删除分支
$ git branch -d <branchname>
```

#### 合并分支
`fast-forward`分支所指向的提交是你当前提交的直接上游
```bash
# 合并test分支到当前分支
$ git merge test
```
冲突的解决

#### 分支管理（开发分支流）
- 长期分支 用来维护不同层次的稳定性
  1. master分支 只保留完全稳定的代码
  2. develop/next分支 后续开发和测试稳定性
  3. pu(proposed updates) 建议更新分支，不成熟的内容不适合放入master和develop的
  4. test 测试部门使用的需要测试的分支
- 短期分支，特性分支
  1. issue分支 特性分支
  2. hotfix分支 紧急修复补丁分支

#### 远程分支
```bash
$ git remote show <remote>
$ git ls-remote <remote>
```
- 推送
  ```bash
    $ git push <remote> <branch>
    # 将本地的 localbranch 分支推送到远程仓库上的 serverfix 分支
    $ git push origin localbranch:serverfix
    # 运行 git merge origin/serverfix 将这些工作合并到当前所在的分支
    $ git merge origin/serverfix
  ```
- 跟踪分支
  ```bash
    # 查看设置的所有跟踪分支
    $ git branch -vv
    # 在自己的 serverfix 分支上工作，可以将其建立在远程跟踪分支之上
    $ git checkout -b serverfix origin/serverfix
    # 上面命令的快捷方式
    $ git checkout --track origin/serverfix
    # 设置已有的本地分支跟踪一个刚刚拉取下来的远程分支
    $ git branch -u origin/serverfix
  ```
- 拉取
  ```bash
    # 抓取本地没有的数据时，它并不会修改工作目录中的内容
    $ git fetch
    # 相当于fetch然后紧接着一个merge命令
    $ git pull
  ```
- 删除远程分支
  ```bash
    # 删除分支
    $ git push origin --delete serverfix
  ```
- 本地新建分支, 把此分支放入其中
  ```bash
    $ git checkout -b <本地分支名> origin/<远程分支名>
  ```

#### 变基rebase
整合分支的两种方式：rebase和merge
merge:它会把两个分支的最新快照以及二者最近的共同祖先进行三方合并，合并的结果是生成一个新的快照并提交
rebase:提取在分支中所做的补丁和修改，然后在需要合并的分支上再应用一次。用于把一个分支的修改合并到当前分支。rebase用来修改本地私有提交历史的。
```bash
  # git rebase [basebranch] [topicbranch]
  # 在git rebase后面加上参数<branch>，那么会先执行git checkout到这个分支，如果没有加分支则表示对当前分支进行操作
  $ git rebase master server
  # git add 解决冲突后继续rebase
  $ git rebase --continue  
  # --abort参数来终止rebase的行动，并且"mywork" 分支会回到rebase开始前的状态。
  $ git rebase --abort
```
```bash
# 想维持树的整洁
$ git fetch origin master
$ git rebase origin/master
$ git push
```
- rebase妙用：压缩多次提交

```bash
# 使用下面的命令压缩多次提交为1次，最后一个数字4代表压缩最后四次提交。
> git rebase -i HEAD~4
# 该命令执行后，会弹出vim的编辑窗口，4次提交的信息会倒序排列，最上面的是第四次提交，最下面的是最近一次提交。
# 我们需要修改第2-4行的第一个单词pick -> squash
# 这个意义为将最后三次的提交压缩到倒数第四次的提交
# 效果就是我们在pick所在的提交就已经做了4次动作，但是看起来就是一次而已

pick 1cf0e94 ▒~O~P交主▒▒~X▒▒~P模▒~]~W
pick ec818f3 修▒~T▒hugo
pick 6feb489 修▒~T▒git
pick 8d61b20 update git
# Rebase 9da3e1a..8d61b20 onto 9da3e1a (4 commands)
#
# Commands:
# p, pick = use commit
# r, reword = use commit, but edit the commit message
# e, edit = use commit, but stop for amending
# s, squash = use commit, but meld into previous commit
# f, fixup = like "squash", but discard this commit's log message
# x, exec = run command (the rest of the line) using shell
# d, drop = remove commit
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out

# 保存退出，git会一个一个压缩提交历史，如果有冲突，需要修改，修改的时候要注意，保留最新的历史，不然我们的修改就丢弃了。修改以后要记得敲下面的命令：
> git add .
> git rebase --continue
# 如果你想放弃这次压缩的话，执行以下命令
> git rebase --abort
# 修改好了后，会发现无法push到远程仓库，所以需要 -f 强制push
> git push -f
```
- 不要对在你的仓库外有副本的分支执行rebase操作

#### 子模块(`git Submodule`)
`git Submodule`是一个多项目使用共同类库的工具，他允许类库项目做为repository,子项目做为一个单独的git项目存在父项目中，子项目可以有自己的独立的commit，push，pull。而父项目以Submodule的形式包含子项目，父项目可以指定子项目header，父项目中会的提交信息包含Submodule的信息，再clone父项目的时候可以把Submodule初始化。

- 使用git命令可以直接添加Submodule
```bash
# 使用git命令可以直接添加Submodule
> git submodule add git@github.com:catchance/smart.git themes/smart
# 使用 git status 可以查询到多了文件需要提交
> git status
On branch master
    Changes to be committed:
        new file:   .gitmodules
        new file:   themes/smart
```
- 生成的.gitmodules就是内容包含Submodule的主要信息，指定reposirory,指定路径:
```bash
    [submodule "themes/smart"]
        path = themes/smart
        url = git@github.com:catchance/smart.git
# 使用 git submodule status 查看子项目的commit id
> git submodule status
 812f406232947059eaae53875bfaf60b3156eeb8 themes/smart (heads/master)
```
- 这两个文件都需要提交到父项目的git中
- 更新Submodule的两种方式
```bash
# 1. 在父项目的目录下直接运行
> git submodule foreach git pull
> git submodule foreach git pull --rebase origin master
# 2. 在Submodule的目录下面更新
> git pull
```
- clone Submodule的两种方式
```bash
# 1. clone父项目的时候采用 --recursive 递归的方式clone整个项目，包含所有的子项目
> git clone <repository> --recursive
# 2. 先clone父项目，再初始化Submodule
> git clone <repository>
> cd <sub-repository>
> git submodule init
> git submodule update
```
- 更新子模块
```bash
# 进入Submodule目录里面修改后 commit -> push 到远程服务器
> git commit -a -m 'update submodule'
> git push
# 回到父目录,提交Submodule在父项目中的变动
> git commit -m'update submodule'
> git push
```
- 删除Submodule
只需要直接删除Submodule对应的文件就可以了（.gitmodules、<sub-repository>、.git/config）
```bash
> cd <repository>
> git rm --cached <sub-repository>
> rm -rf <sub-repository>
> rm .gitmodules
# 删除.git/config中submodule相关的内容,然后提交到远程服务器
> git commit -a -m <msg>
```


### 命令详解
---
#### `git reset`
#### `git revert`
Git Revert原理：根据你要回退的提交所做的改动做相反的改动，然后重新提交代码，使代码达到没有这些旧提交所能达到的状态。

- 使用git reset是不影响远程分支的，一切都在本地发生。如果回退需要很快影响远程分支的，应该使用git revert

#### `git rebase`  
- `git rebase --continue | --abort | --skip | --edit-todo`  
--continue 继续rebase操作   
--abort 终止rebase操作   
--skip 完全忽略该提交。   
--edit-todo
- `git rebase [-i] [options] [--exec <cmd>] [--onto <newbase>] [<upstream>] [<branch>]`
- `git rebase [-i] [options] [--exec <cmd>] [--onto <newbase>] --root [<branch>]`
- `git rebase <startpoint> <endpoint> --onto  <newbase>`
    ```bash
    # <startpoint> <endpoint> 是一个左开右闭的区间
    # 将[90bc0045b, 5de0da9f2]之间的修改应用到master分支上
    > git rebase 90bc0045b^ 5de0da9f2 --onto master
    ```

### 规范
---
- 如果某些文件已经被跟踪了， 再放入到.gitinore可能会失效， 用以下命令来忽略
  ```bash
  # 忽略文件 这个可是实现Git的分两次提交
  $ git update-index --assume-unchanged filename
  # 撤销用：
  $ git update-index --no-assume-unchanged filename
  ```
- `git diff --check` 找出可能的空白错误并将它们列出来
- 本地分支和远程分支的绑定（tracking)，加上 rebase 策略
  ```bash
  [branch "master"]
      remote = origin
      merge = refs/heads/master
      rebase = true
  ```
- 解决多个问题，最好不要一次提交，根据任务分开提交。
- 每次提交信息的模板  
修改的摘要（50 个字符或更少）如果必要的话，加入更详细的解释文字。在
大概 72 个字符的时候换行。在某些情形下，第一行被当作一封电子邮件的标题，剩下的
文本作为正文。分隔摘要与正文的空行是必须的（除非你完全省略正文）；如果你将
两者混在一起，那么类似变基等工具无法正常工作。空行接着更进一步的段落。
- 句号也是可以的。
- 项目符号可以使用典型的连字符或星号
  前面一个空格，之间用空行隔开，
  但是可以依据不同的惯例有所不同。
