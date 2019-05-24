+++
title = "Hugo"
description = "description"
keywords = ["hugo"]
categories = ["hugo"]
tags = ["hugo"]
date = 2019-05-04T15:17:02+08:00
draft = true
# CJKLanguage: Chinese, Japanese, Korean
isCJKLanguage = true
# 排序你的文章
weight = 40

# 这里还可以自定义任何参数，这些参数可以在模板中使用
toc = true
comments = false
featured_image = ""
+++

> [Hugo](https://gohugo.io/)是由Go语言实现的静态网站生成器。简单、易用、高效、易扩展、快速部署。
> Hugo以速度快著称，号称是世界上最快的网站生成框架，[5秒生成6000个页面！](https://twitter.com/dzello/status/895835610476199939)
> [官网文档](https://gohugo.io/documentation/)详细，有活跃的[社区](https://discourse.gohugo.io/)，相对于[hexo](https://hexo.io/zh-cn/)，[jekyll](https://jekyllrb.com/)有更加自由的内容组织方式。
> 有丰富的[主题](https://themes.gohugo.io/)，目前主题数量已经超过hexo。
<!--more-->

### 概述
---

### 安装
---
#### os x
使用brew安装， 安装之前可以`brew search hugo`查询  
`brew install hugo`

#### windows
extended版本功能更多，比如SCSSToCSS的功能，解压得到exe文件后，将exe所在的目录添加到系统环境变量，安装成功！

- [hugo_0.55.5_Windows-64bit](https://github.com/gohugoio/hugo/releases/download/v0.55.5/hugo_0.55.5_Windows-64bit.zip)
- [hugo_extended_0.55.5_Windows-64bit](https://github.com/gohugoio/hugo/releases/download/v0.55.5/hugo_extended_0.55.5_Windows-64bit.zip)

#### linux
- ubuntu下面使用`Snap Package` 
```bash
# install the “extended” Sass/SCSS version
> snap install hugo --channel=extended
# install the non-extended version without Sass/SCSS support
> snap install hugo
```
- apt-get(hugo的版本很旧，不建议使用这种方式安装)
```bash
> sudo apt-get install hugo
```

#### Source 
- Git
- Go (at least Go 1.11)
```bash
> mkdir $HOME/src
> cd $HOME/src
> git clone https://github.com/gohugoio/hugo.git
> cd hugo
# Remove --tags extended if you do not want/need Sass/SCSS support.
> go install --tags extended
```

#### 其他系统
请参考[官方文档](https://gohugo.io/getting-started/installing/)

#### 验证
```bash
> hugo version
Hugo Static Site Generator v0.55.0/extended darwin/amd64 BuildDate: unknown
```

### 基本使用
---
#### 建站
```bash
> hugo new site blog
# 目录结构（ps:可以使用 tree -L 2 命令生成目录结构）
.
├── archetypes  # 储存.md的模板文件
│   └── default.md
│   └── bug.md
├── config.toml # 配置文件
├── content     # 储存网站的所有内容
│   ├── about
│   └── posts
├── static      # 储存图片,css,js等静态文件，该目录下的文件会直接拷贝到/public，该文件夹的优先级高于主题下的/static文件夹
│   └── img
├── themes      # 储存主题
│      └── LeaveIt 
└── public      # 执行hugo命令后，储存生成的静态文件
```

#### 添加一个主题
```bash
# 主题在themes目录下面
> cd blog
> git init
> git submodule add https://github.com/catchance/smart.git themes/smart;
# 编辑你的 config.toml 配置文件使用该主题
> echo 'theme = "smart"' >> config.toml
```

#### 请开始你的表演吧
`hugo new posts/helloworld.md`

#### 启动内部服务器本地预览
```bash
> hugo server -t LeaveIt --ignoreCache --buildDrafts
# -t 使用主题
# -ignoreCache 不使用缓存
# -D --buildDrafts 生成页面包含草稿
```
使用[http://localhost:1313/](http://localhost:1313/)可以访问了

#### 部署到[Github Pages](https://pages.github.com/)
[申请流程参考](https://blog.csdn.net/njp_njp/article/details/79933295)

- 请到[Github](https://github.com/)申请注册账号。
- 首页 => New repository => repository name: <username>.github.io
- 将public(hugo生成的静态文件目录)中的静态文件`git pull`到刚刚建立的仓库中去
- 在Github中的仓库Setting页面找到GitHubPages那一项，将Sourse改成master branch保存
- 使用`http://<username>.github.io/`访问

### 进阶(自动化部署和发布)
---
使用github、vultr、webhook、supervisor、nginx自动发布和部署到云服务器。
#### github
使用github存放blog的源代码。

#### vultr
Vultr是一家创建于2014年的VPS提供商，总部坐落于美国新泽西州。作为VPS界的新秀，Vultr发展迅猛、有口皆碑，在中国大陆地区也拥有广泛的用户。Vultr在全球各地部署有15个机房，其中亚太地区部署了东京、新加坡、悉尼三处机房，与大陆的连接速度都不错，位于美国西海岸的硅谷、洛杉矶机房也深受大陆用户的青睐。
我自己使用的话，发现洛杉矶和东京节点的速度还ok，看YouTube 1080P没有压力，价格也还算可以，最便宜的$2.5。个人使用的是$5的东京节点。$5/月的方案提供1核CPU、1G内存、25G的SSD核1024G的流量，能满足VPN、Shadowsocks、WordPress等常见使用场景的要求。  
**最最最最主要的是：vultr可以按照小时付费**，当发现速度不行的时候，可以随时更换，只收取 **$0.01**。

- [注册后30天内充值$10，获赠$10](https://www.vultr.com/?ref=7320488)
- [限时：注册后30天内充值$25，获赠$50](https://www.vultr.com/?ref=7816158-4F)

#### webhook服务
使用[webhook]({{< ref "posts/一个golang实现的webhook-server.md" >}})创建一个github webhook的服务，用来接收github的请求，自动部署hugo服务。

- webhook的配置文件：`/etc/webhook/hooks.json`

    ```json
    [{
        "id": "hugo-deploy",
        "execute-command": "/var/script/auto-run-hugo.sh",
        "command-working-directory": "/root/blog",
        "response-message": "success!"
    }]
    ```
- shell脚本 `/var/script/auto-run-hugo.sh`

    ```bash
    #!/bin/sh
    cd /root/blog
    git fetch origin
    git checkout feature-hugo
    git reset --hard origin/feature-hugo
    git clean -fdx
    supervisorctl restart hugo
    echo "ok!"
    ```
- 我的hugo项目所在分支为feature-hugo
- supervisorctl管理得hugo服务的名称为hugo
- hugo blog 所在的目录为/root/blog

#### supervisor
使用[supervisor]({{< ref "posts/Supervisor.md" >}})来管理 **hugo** 、 **webhook** 服务

- hugo服务配置 `/etc/supervisor/conf.d/hugo.conf`

    ```bash
    [program:hugo]
    command=/snap/bin/hugo server -t smart --port 1313 --bind 0.0.0.0 --baseUrl="https://xchance.xyz/" --appendPort=false
    directory=/root/blog
    autostart=true
    autorestart=true
    startsecs=10
    stopwaitsecs=600
    killasgroup=true
    numprocs=1
    redirect_stderr=true
    user=root
    stdout_logfile = /var/log/my_blog.log
    ```
- webhook服务配置 `/etc/supervisor/conf.d/webhook.conf`

    ```bash
    [program:webhook]
    command=/usr/local/go/bin/webhook -hooks /etc/webhook/hooks.json -verbose -port=9876
    autostart=true
    autorestart=true
    startsecs=10
    stopwaitsecs=600
    killasgroup=true
    numprocs=1
    redirect_stderr=true
    user=root
    stdout_logfile = /var/log/webhook.log
    ```


#### 配置github webhooks
我们可以在我们的Github相关repository上面最右边有一个Settings的Tab，找到Webhooks & services去添加。

#### nginx
使用nginx配置反向代理

- nginx配置文件：`etc/nginx/conf.d/`

    ```nginx
    server{
        listen 443 ssl http2;
        server_name xchance.xyz;
        ssl on;
        ssl_certificate <这里填写你的证书的配置>;
        ssl_certificate_key <这里填写你的证书的配置>;
        ssl_session_timeout 5m;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_session_cache builtin:1000 shared:SSL:10m;
        # openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048
        ssl_dhparam /etc/nginx/ssl/dhparam.pem;
        access_log on;
        location / {
            #向后端传递访客IP
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            #设定需要反代的域名，可以加端口号
            proxy_pass http://127.0.0.1:1313;
            #替换网站内容
            sub_filter 'xchance.xyz' 'xchance.xyz';
        }
       location /hooks/ {
         proxy_set_header Upgrade $http_upgrade;
         proxy_set_header Connection "upgrade";
         proxy_set_header Host $http_host;
         proxy_pass http://127.0.0.1:9876;
       }
    }
    ```

#### cloudflare
配置CDN加速

#### 总结
当完成上述一系列配置，我们就完成了一个自动化部署的博客系统了，当我们更新文章到github，云服务就会更新我们最新的代码，并且发布到线上。

### 高级功能
---
#### Shortcodes
[Shortcodes](https://gohugo.io/content-management/shortcodes/)帮助你在编写markdown时快捷的插入HTML代码，功能上类似于Hexo的标签插件。
```Go HTML Template
{ {< ref "posts/hugo.md" >} } => http://localhost:1313/2019/hugo/
{ {< ref "posts/hugo.md#高级功能" >} } => http://localhost:1313/2019/hugo/#高级功能
```

#### Syntax Highlighting
- [Syntax Highlighting](https://gohugo.io/content-management/syntax-highlighting/)
- [List of Chroma Highlighting Languages](https://gohugo.io/content-management/syntax-highlighting/#list-of-chroma-highlighting-languages)

#### Archetypes
[Archetypes](https://gohugo.io/content-management/archetypes/)是创建新内容时使用的模板。
hugo new [path] [flags] 使用以下优先级创建新，也可以通过 *-k --kind* 指定使用哪个模板
```bash
1.archetypes/posts.md
2.archetypes/default.md
3.themes/<theme>/archetypes/posts.md
4.themes/<theme>/archetypes/default.md
# 新建一个名称为hello的md文件，在content/posts目录下
> hugo new posts/hello.md
# 以bug.md为模板创建一个my-bug.md的文件
> hugo new --kind bug posts/my-bug.md
```

### 相关文档
---
- [Hugo 从入门到会用](https://blog.olowolo.com/post/hugo-quick-start/)

