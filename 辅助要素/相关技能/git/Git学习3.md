## 创建标签  
> 将来无论什么时候，取某个标签的版本，就是把那个打标签的时刻的历史版本取出来。  
> *tag* 就是一个让人容易记住的有意义的名字，它跟某个 *commit* 绑在一起。  

#### 创建默认标签  
> 首先切换到需要打标签的分支上，标签会打在最新提交的 *commit* 上。
> 
> \<name\>可以输入 v1.0
```elm
$ git tag <name>
```

#### 对指定的 commit 打标签  
> \<id\>需要输入指定的 **commit id**。
```elm
$ git tag <name> <id>
```
**注意：标签总是和某个 *commit* 挂钩。如果这个 *commit* 既出现在 *master* 分支，又出现在 *dev* 分支，那么在这两个分支上都可以看到这个标签。**

> 查找历史提交的commit id  
>
> ```elm
> $ git log --pretty=oneline --abbrev-commit
> ```

#### 创建带有说明的标签   
> 用 `-a` 指定标签名，`-m` 指定说明文字  
```elm
$ git tag -a <name> -m "miaoshu" <id>
```

## 查看标签

#### 查看所有标签  
> 注意，标签不是按时间顺序列出，而是按字母排序的。  
```elm
$ git tag
```

#### 查看标签信息   
```elm
git show <tagname>
```

## 删除标签   
> 因为创建的标签都只存储在本地，不会自动推送到远程。所以，打错的标签可以在本地安全删除。  

#### 删除某个本地标签  
```elm
$ git tag -d <tagname>
```
#### 删除已经推送到远程的标签  
- **先从本地删除**   
```elm
$ git tag -d <tagname>
```
- **再从远程删除**
> 注意 origin 和冒号之间有个**空格**， 相当于 push 一个空的 *tag* 到远程。
```elm
$ git push origin :refs/tags/<tagname>
```

## 推送标签  
#### 推送某个标签到远程  
```elm
git push origin <tagname>
```

#### 推送全部尚未推送到远程的本地标签  
```elm
$ git push origin --tags
```

## 自定义 Git  
> 实际上，Git 有很多可配置项。 

**让 Git 显示颜色**  
```elm
$ git config --global color.ui true
```

## 忽略特殊文件  
> 有些时候，必须把某些文件放到 Gi t工作目录中，但又不能提交它们。每次 `git status` 都会显示 Untracked files ...，让人难以接受。

在 Git 工作区的根目录下创建一个特殊的`.gitignore`文件，然后把要忽略的文件名填进去，Git 就会自动忽略这些文件。也可以组合[官方准备的配置文件](https://github.com/github/gitignore)。

### 忽略文件的原则
1. 忽略操作系统自动生成的文件，比如缩略图等；
2. 忽略编译生成的中间文件、可执行文件等，也就是如果一个文件是通过另一个文件自动生成的，那自动生成的文件就没必要放进版本库，比如 Java 编译产生的 `.class` 文件；
3. 忽略你自己的带有敏感信息的配置文件，比如存放口令的配置文件。

**注意：在文本编辑器里“保存”或者“另存为”就可以把文件保存为 `.gitignore`，而办不到在资源管理器里新建一个 `.gitignore` 文件。**

栗子：忽略一些 Windows，Python和自己定义的文件，最终得到一个完整的.gitignore文件：  
> 把指定文件排除在.gitignore规则外的写法就是 `!+文件名`
> 所有空行或者以 \# 开头的行都会被 Git 忽略。
```react
# Windows:       // 指示win环境下忽略
Thumbs.db     
ehthumbs.db
Desktop.ini

# Python:       // 指示java环境下
*.py[cod]
*.so           // 忽略所有后缀为.so 的文件
*.egg
*.egg-info
dist
build

# My configurations:
db.ini
deploy_key_rsa

# 不排除.gitignore和App.class:
!.gitignore
!App.class
```

检验 `.gitignore` 的标准是 `git status` 命令是不是说 working directory clean.

**提交文件**  

最后记得把 `.gitignore` 也提交到Git，可以方便多人协作。

**添加被忽略的文件：**  
```elm
$ git add -f 文件名
```

**检查冲突规则**  

```elm
$ git check-ignore -v 文件名
```
### 其他用法
如果觉得要忽略的内容太多懒得管理, 可以采取全部忽略逐一排除的策略:
先\*忽略全部, 之后再\!设定不被忽略的内容。
```react
*          # 忽略全部

！/ch01/   # 不忽略的文件

！*.c      # 不忽略的文件
```
如果不慎在创建.gitignore文件之前就push了某文件，那么即使在.gitignore文件中写入新的过滤规则，这些规则也不会起作用。

更详细的[设置方法](https://zhuanlan.zhihu.com/p/52885189)

## 配置别名  
> 给Git配置好别名，就可以输入命令时偷个懒。

**告诉 Git，以后 输入`st` 就表示 `status` ：**   
> 那么以后，敲 `git st` 就表示 `git status`  
> 
> （非取代）  
```elm
$ git config --global alias.st status
```

**常用命令**  
> 很多人都用co表示checkout，ci表示commit，br表示branch：  
```elm
$ git config --global alias.co checkout
$ git config --global alias.ci commit
$ git config --global alias.br branch
```

**git unstage file**  
把暂存区的修改撤销掉，重新放回工作区  
```elm
$ git config --global alias.unstage 'reset HEAD'
```

**git last**  
显示最后一次提交信息  
```elm
$ git config --global alias.last 'log -1'
```

**git lg**  
更好的颜色显示  
```elm
$ git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```

### 配置文件  
> 配置 Git 的时候，加上 `--global` 是针对当前用户起作用的，如果不加，那只针对当前的仓库起作用。  

- 每个仓库的 Git 配置文件都放在 `.git/config` 文件中。  
（别名就在 **[alias]** 后面，要删除别名，直接把对应的行删掉即可。）　　

- 而当前用户的 Git　配置文件放在用户主目录下的一个隐藏文件 `.gitconfig` 中。

## 使用 SourceTree  
> 当我们对 Git 的提交、分支已经非常熟悉，可以熟练使用命令操作 Git 后，再使用 *GUI 工具*，就可以更高效。  
> 
> 这里推荐 SourceTree，一款免费 Git 图形界面工具，可以操作任何 Git 库，[进入下载](https://www.sourcetreeapp.com/)。

[教程很简单](https://www.liaoxuefeng.com/wiki/896043488029600/1317161920364578)

最后，附上廖大神友情准备的 [Git Cheat Sheet](https://liaoxuefeng.gitee.io/resource.liaoxuefeng.com/git/git-cheat-sheet.pdf)

