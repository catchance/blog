+++
title = "Python环境包管理工具pipenv"
description = "Python环境包管理工具pipenv"
keywords = ["python", "pipenv"]
categories = ["python"]
tags = ["pipenv", "python"]
date = 2019-06-01T16:31:45+08:00
draft = false
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

> pipenv 是 Pipfile 主要倡导者、requests 作者 Kenneth Reitz 写的一个命令行工具，主要包含了Pipfile、pip、click、requests和virtualenv,pipenv相当于pip与virtualenv的结合体

<!--more-->
### 概述
---
#### pip
pip 是一个 *Python* 包,也是 *Python* 推荐的包管理程序，可以用于安装和管理 *Python* 包，*Python* 2.7.9+ 版本中已经自带了 *pip* 包。针对 Python 2 和 3，pip 分别提供了 pip 和 pip3 两个命令。

#### virtualenv
一般情况，每个应用都需要各自拥有一套 **独立** 的 *Python* 运行环境。*virtualenv* 就是用来为一个应用创建一套 **隔离** 的 *Python* 运行环境。

#### requirements.txt
*requirements.txt* 是 *pip* 批量安装读取的文件。`pip install -r requirements.txt`

```bash
# 需要安装的包
Package 
# 明确指定版本号
Package1==1.0.0
# 指定最小版本号
Package2>=1.0.0
# 指定版本号区间
Package3>=1.0.0,<2.0.0
```

#### Pipfile 和 Pipfile.lock
*Pipfile* 与 *Pipfile.lock* 是社区拟定的依赖管理文件，用于替代过于简陋的 *requirements.txt* 文件。

- Pipfile

    ```toml
    [[source]]
    name = "pypi"
    url = "https://pypi.org/simple"
    verify_ssl = true
    
    [dev-packages]
    
    [packages]
    requests = "*"
    selenium = "*"
    
    [requires]
    python_version = "3.6"
    ```
    
- Pipfile.lock
*Pipfile.lock* 是根据 *Pipfile* 和当前环境自动生成的 JSON 格式的依赖文件，任何情况下都不要手动修改该文件！

    ```json
    {
        "_meta": {
            "hash": {
                "sha256": "eff857bba91909a3e6ad85f171f73fd4f0a9330e99feb38d9ea7e0ea4a44ae39"
            },
            "pipfile-spec": 6,
            "requires": {
                "python_version": "3.6"
            },
            "sources": [
                {
                    "name": "pypi",
                    "url": "https://pypi.org/simple",
                    "verify_ssl": true
                }
            ]
        },
        "default": {
            "certifi": {
                "hashes": [
                    "sha256:59b7658e26ca9c7339e00f8f4636cdfe59d34fa37b9b04f6f9e9926b3cece1a5",
                    "sha256:b26104d6835d1f5e49452a26eb2ff87fe7090b89dfcaee5ea2212697e1e1d7ae"
                ],
                "version": "==2019.3.9"
            },
            "chardet": {
                "hashes": [
                    "sha256:84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae",
                    "sha256:fc323ffcaeaed0e0a02bf4d117757b98aed530d9ed4531e3e15460124c106691"
                ],
                "version": "==3.0.4"
            },
            "idna": {
                "hashes": [
                    "sha256:c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407",
                    "sha256:ea8b7f6188e6fa117537c3df7da9fc686d485087abf6ac197f9c46432f7e4a3c"
                ],
                "version": "==2.8"
            },
            "requests": {
                "hashes": [
                    "sha256:11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4",
                    "sha256:9cf5292fcd0f598c671cfc1e0d7d1a7f13bb8085e9a590f48c010551dc6c4b31"
                ],
                "index": "pypi",
                "version": "==2.22.0"
            },
            "selenium": {
                "hashes": [
                    "sha256:2d7131d7bc5a5b99a2d9b04aaf2612c411b03b8ca1b1ee8d3de5845a9be2cb3c",
                    "sha256:deaf32b60ad91a4611b98d8002757f29e6f2c2d5fcaf202e1c9ad06d6772300d"
                ],
                "index": "pypi",
                "version": "==3.141.0"
            },
            "urllib3": {
                "hashes": [
                    "sha256:b246607a25ac80bedac05c6f282e3cdaf3afb65420fd024ac94435cabe6e18d1",
                    "sha256:dbe59173209418ae49d485b87d1681aefa36252ee85884c31346debd19463232"
                ],
                "version": "==1.25.3"
            }
        },
        "develop": {}
    }
    ```

#### pipenv
[pipenv](https://github.com/pypa/pipenv)是 Pipfile 主要倡导者，requests 作者 Kenneth Reitz 的一个库，有机地结合了  Pipfile，pip，和virtualenv。

### 安装
---
#### pip直接安装
```bash
$ pip install pipenv
```
#### os x安装
```bash
$ brew install pipenv
```

### 使用
---
#### 创建一个准备当环境的文件夹
#### pipenv命令创建环境
```bash
    # 使用当前系统的Python3创建环境
    $ pipenv --three
    # 指定某一Python版本创建环境
    $ pipenv --python 3.6 
    # 显示目录信息
    $ pipenv --where
    # 显示虚拟环境信息
    $ pipenv --venv
    # 显示Python解释器信息
    $ pipenv --py  
```
    
#### 安装相关模块并加入到Pipfile
```bash
    # 安装相关模块并加入到Pipfile
    $ pipenv install requests 
    # 安装固定版本模块并加入到Pipfile
    $ pipenv install django==1.11 
    # 查看目前安装的库及其依赖
    $ pipenv graph
    # 检查安全漏洞 
    $ pipenv check
    # 卸载全部包并从Pipfile中移除
    $ pipenv uninstall --all
    # 生成lockfile
    $ pipenv lock
```

#### 运行python代码（py文件）
- pipenv run python xxx.py
    ```bash
    $ pipenv run python xxx.py
    ```

- 启动虚拟环境的shell环境
    ```bash
    $ pipenv shell
    $ python xxx.py
    ```

#### 删除虚拟环境
```bash
$ pipenv --rm
```

### Tips
#### 在idea中使用pipenv需要配置
- File -> Project Structure -> Project -> Project SDK

    需要设置为`pipenv --venv`命令执行的虚拟python环境

-  File -> Project Structure -> SDKs 

    同样需要添加`pipenv --venv`命令执行的虚拟python环境
    
- 运行python程序 -> RUN Configurations设置

    python interpreter 同样需要选择`pipenv --venv`命令执行的虚拟python环境

### 相关文档
---
- [Python新利器之pipenv](https://www.jianshu.com/p/00af447f0005)
- [Github >> pipenv](https://github.com/pypa/pipenv)
- [pipenv >> doc](https://docs.pipenv.org/en/latest/)

