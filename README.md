#### nice
hello everyone!

### hexo2hugo.py 
hexo->hugo的python脚本(主要转换一下时间格式)

### deploy.py
[Hugo 自动化部署脚本](https://blog.coderzh.com/2015/11/21/hugo-deploy-script/)
- 将 deploy.py 放到你的 Hugo 站点目录。（和 config.yaml 等文件放一起）
- 编辑文件，修改要部署的仓库：
```python
GIT_REPO = [
    # [别名,   分支名,     Git Repo 路径]
    ['origin', 'gh-pages', 'git@github.com:coderzh/hugo-blog-deployed.git'],
    ['gitcafe', 'gh-pages', 'git@gitcafe.com:coderzh/coderzh-hugo-blog.git'],
] 
# 部署到哪里，相对上一级目录。比如下面的配置，会部署到 ../gh-pages 目录里
DEPLOY_DIR = 'gh-pages'
```
- 如果你的网站需要指定皮肤，需要在 config 文件中指定 theme
- 第一次执行，使用 first 参数，它会做一些初始化的操作。并使用 -t 表示只是测试一下，并不会真的 push 。`python deploy.py first -t`
- 中间可能需要输入密码，如果是自动化部署，可在 Git Repo 里添加一个没有密码的 SSH Key
- 如果一切正常，切换到 DEPLOY_DIR 目录，git log 看看 commit 记录是否正常。如果一切也如你所愿。则可以把 -t 参数去掉重新执行一遍，执行真的 push 操作：`python deploy.py first`
- 执行完成后，应该已经将生成的静态页面自动 push 到了你指定的 GIT_REPO 里。
- 之后如需再次手工部署，只需要使用 manual 参数，速度会快很多：`python deploy.py manual`
- 如果你想通过 webhook 来自动部署，使用 auto 参数，这样在执行 deploy.py 时，会使用 Git 自动更新你当前的 Hugo 站点目录 ，然后部署：`python deploy.py auto`

