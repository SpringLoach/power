## 简介  
> Git 是最强大的分布式版本控制系统，没有之一。想要多人一起合作完成项目，学习 Git 是非常有必要的。以下是一些自己的学习笔记，主要参考自[廖雪峰的Git教程](https://www.liaoxuefeng.com/wiki/896043488029600)。

## 安装 Git  
> 在 Windows 上使用 Git，可以从 Git 官网直接下载安装程序，然后按默认选项安装即可。

安装好后，每个机器需要自报家门：  
```elm
$ git config --global user.name "Your Name"
```
```elm
$ git config --global user.email "email@example.com"
```
注意 `--global` 参数，表示该机器的所有 Git 仓库都会使用这个配置，当然也可以对某个仓库指定不同的用户名和Email地址。

验证
```elm
$ git config user.name 

$ git config user.email 
```

## 创建版本库  
> 版本库又名仓库，英文名 repository，可以简单理解成一个目录。Git 可以管理目录里面的所有文件，甚至任何时刻都可以追踪历史，或者在将来某个时刻可以“还原”。

创建一个版本库，需要在合适的地方创建一个空目录
```react
$ mkdir 文件夹名
$ cd 文件夹名
$ pwd
/将会出现当前目录
```
`pwd` 命令用于显示当前目录。  

**若使用 Windows 系统，为了避免遇到各种莫名其妙的问题，请确保目录名（包括父目录）不包含中文。**  

然后，通过 `git init` 命令把这个目录变成Git可以管理的仓库:  
```elm
$ git init
Initialized empty Git repository in 当前目录/.git/
```
可以使用 `ls -ah` 命令查看隐藏的.git目录

### 把文件添加到版本库  
> 编写的文件，要放到当前目录下（或它的子目录），确保它放到了 Git 仓库中。

首先，用命令 `git add`，把文件添加到仓库：  
```react
$ git add 加后缀的文件名
```
然后，用命令 `git commit`，把文件提交到仓库：  
```elm
$ git commit -m "提交说明"
[master (root-commit) eaadf4e] xxxx
 1 file changed, 2 insertions(+)
 create mode 100644 文件名 
```
执行成功后，告知：`1 file changed`: 1个文件被改动;`2 insertions`：插入了两行内容。

要知道 commit 可以一次提交很多文件，所以可以**多次 add 不同的文件**：  
```elm
$ git add file1.txt
$ git add file2.txt file3.txt
$ git commit -m "add 3 files."
```

### 注意事项  
> Git 命令必须在 **Git 仓库目录内**执行（git init 除外），在仓库目录外执行是没有意义的。  
> 添加某个文件时，该文件必须在当前目录下**存在**（ 有时会不小心写错文件名 ），可以用 `ls` 命令查看当前目录的文件。  

- 所有的版本控制系统（包括 Git），其实**只能跟踪文本文件的改动**，比如 TXT 文件，网页，所有的程序代码等等；对于（二进制文件）图片、视频、Word，只能知道大小的变化，没法跟踪。  
因为文本是有编码的，建议使用标准的 *UTF-8编码* 。  
- **Windows 的记事本**  
不要使用 Windows 自带的记事本编辑任何文本文件，会遇到很多不可思议的问题，建议下载 [Notepad++](http://notepad-plus-plus.org/) 代替记事本。  
- Unix 的哲学是“ 没有消息就是好消息 ”。

----

**查看文件修改**  

查看工作区的**状态**  
```elm
git status
```

查看**工作区与缓存区**的差别。  
```elm
git diff 文件名
```

查看**缓存区与本地仓库**的差别。  
```elm
git diff --cached 文件名
```

查看**工作区和本地仓库**的差别。 其中：HEAD 代表的是最近的一次 commit 的信息。  
```elm
git diff HEAD 文件名
```

----

## 版本回退  
> 每当你觉得文件修改到一定程度的时候，就可以“保存一个快照”，这个快照在 Git 中被称为 commit。一旦你把文件改乱了，或者误删了文件，还可以从最近的一个 commit 恢复，然后继续工作。

假设文件 a.html共有几个版本被提交到 Git 仓库里（以下为 *提交说明* ）：  
- create  
- change 1  
- change 2  

版本控制系统可以告诉我们历史记录，在 Git 中，我们用 `git log` 命令查看：  
**git log** 命令显示 **从最近到最远** 的提交日志，最近的一次是 *change 2*。  

如果嫌输出信息太多，看得眼花缭乱的，可以试试加上 `--pretty=oneline` 参数：  
```elm
$ git log --pretty=oneline
1094adb7b9b3807259d8cb343e7df1d4d6477073 (HEAD -> master) change 2 
e475afc93c209a690c39c13a26716e8fa000c366 change 1
eaadf4e385e865d25c48e7ca1c8395c3f7dfaef0 create
```
其中，开头的那一大串类似 1094adb... 的是 **`commit id`（版本号）**，一个用十六进制表示的庞大数字，方便多人在同一个版本库里工作。

### 回退到上一个版本    
在Git中，用 `HEAD` 表示当前版本，也就是最新的提交1094adb...，上一个版本就是 `HEAD^`，上上一个版本就是 `HEAD^^`，往上 100 个版本可以写成 `HEAD~100`。

把 a.html 回退到上一个版本，也就是 change 1 的版本，就可以使用 `git reset` 命令：  
```elm
$ git reset --hard HEAD^
HEAD is now at e475afc change 1
```

此时用 `git log` 再看看现在版本库的状态,会**看不到**最新的那个版本 *change 2*  
可以在上面的命令行窗口中找到 *change 2* 的 `commit id` 是 1094adb...，于是就可以指定回到未来的某个版本：  
```elm
$ git reset --hard 1094a
HEAD is now at 83b0afe change 2
```
版本号没必要写全，前几位就可以了，能够使 Git 找到唯一的版本号

Git 的版本回退速度非常快，因为 Git 在内部有个指向当前版本的 HEAD 指针，当回退版本的时候，Git仅仅是把 HEAD 的指向改变，然后顺便把工作区的文件更新了。

当关闭了命令行窗口后，第二天回来 **忘记了的** 新版本的 `commit id` ,想要找回来。  
Git 提供了一个命令 `git reflog` 用来查看命令历史：    
```elm
$ git reflog
e475afc HEAD@{1}: reset: moving to HEAD^
1094adb (HEAD -> master) HEAD@{2}: commit: change2
e475afc HEAD@{3}: commit: change1
eaadf4e HEAD@{4}: commit (initial): create
```

## 工作区和暂存区  
> 暂存区是 Git 非常重要的概念，弄明白了暂存区，就弄明白了 Git 的很多操作到底干了什么。  

### 工作区 （Working Directory）
就是在电脑里能看到的目录，如之前创建版本库前所创建的空**目录文件夹**，或拷贝下来的文件夹。  
![工作区](./img/工作区.jpg)

### 版本库（Repository）  
工作区有一个隐藏目录 `.git`，这个不算工作区，而是 Git 的版本库。

Git 的版本库里存了很多东西，其中最重要的就是称为 stage（或者叫 index ）的**暂存区**，还有 Git 为我们**自动创建**的第一个分支 master，以及指向 master 的一个指针叫 HEAD。  
![版本库1](./img/版本库1.jfif)  
把文件往 Git 版本库里添加的时候，是分两步执行的：  
第一步是用 `git add` 把文件添加进去，实际上就是**把文件修改添加到暂存区**；  
第二步是用 `git commit` 提交更改，实际上就是把暂存区的**所有内容提交到当前分支**。  
因为我们创建 Git 版本库时，Git 自动为我们创建了唯一一个 `master` 分支，所以，现在，`git commit` 就是往 `master` 分支上提交更改。

可以简单理解为，需要提交的文件修改通通放到暂存区，然后，一次性提交暂存区的所有修改。  

进行这样的操作：修改文件 *a.html*，并新建文件 *b.html*  
此时用 `git status` 查看的状态：  
```elm
$ git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   readme.txt

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	LICENSE

no changes added to commit (use "git add" and/or "git commit -a")
```
Git 告诉我们，*a.html* 被修改了，而 *b.html* 还从来没有被添加过，所以它的状态是 **Untracked**。  

然后，用两次命令 `git add` ，把两个文件添加后，用 `git status` 查看的状态：  
```elm
$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	new file:   LICENSE
	modified:   readme.txt
```
 此时暂存区的状态：   
 （直接用的别人的图，故那两个文件名会有所不同）  
![版本库2](./img/版本库2.jfif)   
 然后，执行 `git commit` 后，用 `git status` 查看的状态：  

 ```elm
 $ git status
On branch master
nothing to commit, working tree clean
 ```
 即提交后，如果又没有对工作区做任何修改，那么工作区就是“干净”的。  

 版本库的暂存区中也没有内容了。    
![版本库3](./img/版本库3.jfif)   

 ## 管理修改  
> Git 比其他版本控制系统设计得优秀的原因：Git 跟踪并管理的是修改，而非文件。  
>  
> 我理解为跟踪的是**暂存区的修改**，而非工作区的文件。 

### 栗子一  
对同一个文件进行：第一次修改 → `git add` → 第二次修改 → `git commit`  
那么，第二次修改不会被提交，因为它不在暂存区中。

此时，用 `git diff HEAD -- 文件名` 命令可以查看工作区和版本库里面最新版本的区别

### 栗子二  
对同一个文件进行：第一次修改 → `git add` → 第二次修改 → `git add` → `git commit`  
那就相当于把两次修改合并后一块提交了（ 也可以理解为取最新的一次提交？ ）

### 注意事项  
显示在工作区、暂存区和分支里同名文档的最新修改版本的内容:  
```elm
$ cat 文件名
```
## 撤销修改  
> 这里的一些命令在新版本中被替换掉了，具体修改可以在**注意事项**看到。

**情景一：  想要撤销 某文件 在工作区的修改**  
除了手动修改外，还可以使用 `git checkout -- 文件名` 丢弃工作区的修改，这里有两种情况。  

- 一种是某文件自修改后 **还没有被放到暂存区**，现在，撤销修改就回到和 **版本库** 一模一样的状态；
- 一种是某文件 **已经添加到暂存区后**，又作了修改，现在，撤销修改就回到添加到 **暂存区** 后的状态。

**情景一：  想要撤销 某文件 在暂存区的修改**  

用命令 `git reset HEAD 文件名` 可以把暂存区的修改撤销掉（**unstage**），重新放回工作区；  
然后，丢弃工作区的修改：`git checkout -- 文件名`

`git reset` 命令既可以回退版本，也可以把暂存区的修改回退到工作区。其中的 `HEAD`，表示最新的版本。

**情景一：  想要撤销 某文件 在版本库的修改**   
可以回退到上一个版本。但是，一旦推送到远程版本库，那就莫得办法了。

### 注意事项  
原来的 `git checkout -- 文件名` 可以使用 `git restore -- 文件名` 代替  
原来的 `git reset HEAD 文件名` 可以使用 `git restore --staged 文件名` 代替

## 删除文件  
> 这里的删除文件指的是工作区的文件，有两种情况，一是确实要从版本库中删除该文件，二是误删。  

一般情况下，通常直接在文件管理器中把没用的文件删了，或者用 `rm` 命令删了：  
```elm
$ rm 文件名
```

### 删除该文件  
从版本库中删除该文件，那就用命令 `git rm` 删掉，并且 `git commit`：
```elm
$ git rm c.html
rm 'test.txt'

$ git commit -m "remove c.html"
[master d46f35e] remove test.txt
 1 file changed, 1 deletion(-)
 delete mode 100644 test.txt
```

### 恢复该文件  
`git checkout` 可以用版本库里的**最新版本**替换工作区的版本：  
```elm
$ git checkout -- c.html
```

**注意：从来没有被添加到版本库就被删除的文件，是无法恢复的**  

----

**远程仓库注意事项**  
由于本地 Git 仓库和 GitHub 仓库之间的传输是通过 SSH 加密的，需要[创建 SSH Key 并添加到Github中](https://www.liaoxuefeng.com/wiki/896043488029600/896954117292416)。  
> 这样，GitHub 就能识别出你推送的提交确实是你推送的，而不是别人冒充的。
>     
> 假定你有若干电脑，你一会儿在公司提交，一会儿在家里提交，只要把每台电脑的 Key 都添加到 GitHub，就可以在每台电脑上往 GitHub 推送了。

## 添加远程库  
> 在本地创建了一个 Git 仓库后，又想在 GitHub 创建一个Git仓库，并且让这两个仓库进行远程同步，这样，GitHub 上的仓库既可以作为备份，又可以让其他人通过该仓库来协作。

先在 Github 上创建一个空的仓库，如 aa。

**关联到远程库**  
然后，在本地的 aa 仓库下运行命令使本地仓库与之关联：  
```elm
$ git remote add origin git@github.com:Github的账号名/aa.git
```
添加后，远程库的名字就是 `origin`，这是 Git 默认的叫法，也可以改成别的，但是 origin 这个名字一看就知道是远程库。  

**推送到远程库**  
```elm
$ git push -u origin master
```
由于远程库是空的，我们第一次推送 master 分支时，加上了`-u` 参数，Git 不但会把本地的 master（当前）分支内容推送的远程新的 `master` 分支，还会把本地的 master 分支和远程的 `master` 分支关联起来，在以后的推送或者拉取时就可以简化命令。

**推送修改**  
从现在起，只要本地作了提交，就可以通过如下命令，把本地 master 分支的最新修改推送至 GitHub。  
```elm
$ git push origin master
```

### SSH警告  
当你第一次使用 Git 的 `clone` 或者 `push` 命令连接 GitHub 时，会得到一个警告：  
```elm
The authenticity of host 'github.com (xx.xx.xx.xx)' can't be established.
RSA key fingerprint is xx.xx.xx.xx.xx.
Are you sure you want to continue connecting (yes/no)?
```
因为 Git 使用 SSH 连接，这会发生在 SSH 连接第一次验证 GitHub 服务器的 Key 时。  
**输入 `yes`** ，以确认 GitHub 的 Key 的指纹信息是否真的来自 GitHub 的服务器。

Git 会输出一个警告（后面的操作中不会出现），表示已经把 GitHub 的 Key 添加到本机的一个信任列表里。  
如果实在担心冒充有人冒充 GitHub 服务器，输入 `yes` 前可以对照 [GitHub的 RSA Key 的指纹信息](https://docs.github.com/en/github/authenticating-to-github/githubs-ssh-key-fingerprints)是否与 SSH 连接给出的一致。

### 删除远程库  
如果添加的时候地址写错了，或者就是想删除远程库，可以用 `git remote rm <name>` 命令。使用前，建议先用 `git remote -v` 查看远程库信息：  
```elm
$ git remote -v
origin  git@github.com:Github用户名/仓库名.git (fetch)
origin  git@github.com:Github用户名/仓库名.git (push)
```
然后，根据名字删除，比如删除 *origin*：  
```elm
$ git remote rm origin
```
此处的“ 删除 ”其实是**解除了本地和远程的绑定关系**，并不是物理上删除了远程库。远程库本身并没有任何改动。


## 从远程库克隆  

先准备好远程库，然后用命令 `git clone` 克隆到本地库：    
```elm
$ git clone git@github.com:GitHub账号名/仓库名.git
```
也可以是  
```elm
$ git clone https://github.com/GitHub账号名/仓库名.git
```

**实际上，后面的地址可以从 GitHub 上直接复制**

其中，`git://` 使用 `ssh` 协议，也可以使用 `https` 等其他协议  
使用 `https` 除了速度慢以外，还有个最大的麻烦是每次推送都必须输入口令，但是在某些只开放 http 端口的公司内部就无法使用 ssh 协议而只能用 https。

To be continue...



















