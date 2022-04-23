## 分支管理  
> 在不影响主分支正常使用的前提下，在另外一条自己的分支上干活（任意提交），最后开发完毕后，再一次性合并到原来的分支上。

## 创建与合并分支（图解部分）

HEAD 严格来说不是指向提交，而是指向 *master( “主”分支 )*， *master* 才是指向提交的，所以，**HEAD 指向当前分支**。
每次提交，*master* 分支都会向前移动一步，这样，随着你不断提交，*master* 分支的（ 时间 ）线也越来越长。  
　　![分支1](./img/分支1.png)

1. 创建新分支 *dev* 并改变指向：  
![分支2](./img/分支2.png)

2. 此后，对**工作区的修改和提交**就是针对 *dev* 分支了。  
   接下来我们进行提交一次：  
   ![分支3](./img/分支3.png)

3. 完成合并：把 *master* 指向 *dev* 的 **当前提交**：  
![分支4](./img/分支4.png)

4. 合并完分支后，甚至可以删除 *dev* 分支（ 本质即 *dev* 指针）。  
![分支5](./img/分支5.png)

## 创建与合并分支（实战部分）

**创建新分支 *dev* 并改变指向：**  
```elm
$ git switch -c dev
```

可以用 `git branch` 命令**查看当前分支**( 列出所有分支，其中 `*` 指向当前分支 )：
```elm
$ git branch
* dev
  master
```

**在 *dev* 分支上完成一次修改和提交后**

**切换回 *master* 分支**  
> 到这里，是没有之前在 *dev* 分支的提交的。
> 
> 一般都是提交后，再切分支，用以避免缓存区的混乱。
```elm
$ git switch master
```

**把 *dev* 分支的工作成果 合并 到 *master* 分支上**  
```elm
$ git merge dev
```
会被告知 **Fast-forward** 的信息，代表“快进模式”，也就是直接把 *master* 指向 *dev* 的**当前提交**。

**删除 *dev* 分支**  
```elm
$ git branch -d dev
```

### 旧版本使用的命令  
**创建新分支 *dev* 并改变指向：**  
```elm
$ git checkout -b dev
```
`git checkout` 命令加上 `-b` 参数表示创建并切换，相当于以下两条命令：  
```elm
$ git branch dev
$ git checkout dev
```

**直接切换到已有的 *master* 分支**  
```elm
$ git checkout master
```

## 解决冲突（图解部分）  
当我们对新建的 *feature1* 分支和 *master* 分支**分别有新的提交**时，Git 将无法执行“ 快速合并 ”，只能试图把各自的修改**合并**起来，但这种合并就可能会有**冲突**。  
　　![分支2.1](./img/分支2.1.png)  
此时，需要手动解决冲突后 **再提交**。提交后，*master* 分支和 *feature1* 分支变成了下图所示：  
　　![分支2.2](./img/分支2.2.png)  
最后，删除 *feature1* 分支，工作完成。  

## 解决冲突（实战部分）  
**在两个分支分别有新的提交后，尝试合并：**  
```elm
$ git merge feature1
Auto-merging a.html
CONFLICT (content): Merge conflict in a.html
Automatic merge failed; fix conflicts and then commit the result.
```
Git 返回信息：*a.html* 文件存在冲突，必须手动解决冲突后再提交。  
> 通过 `git status`，可以查看冲突的文件。  
> 同时它告诉我们当前 *master* 分支比**远程**的 *master* 分支要超前 2 个提交：
>```elm
> $ git status
> On branch master
> Your branch is ahead of 'origin/master' by 2 commits.
> ......
> both modified:   a.html
> ```

**手动解决冲突**  
> Git 用<<<<<<<，=======，>>>>>>>标记出不同分支的内容。

**再提交**  
```elm
$ git add a.html 
$ git commit -m "miaoshu"
```
> 用 `git log --graph` 可以看到分支的合并情况。  
> 此时 *master* 在同分支下领先于 *feature1* 一个提交，若再合并就是“ 快速合并 ”。

**最后，删除 *feature1* 分支**  

## 分支管理策略  

### 普通模式合并
合并分支时，加上 `--no-ff` 参数( 表示禁用`fast forward` )就可以用普通模式合并。  
```elm
$ git merge --no-ff -m "miaoshu" dev
```
　　![分支3.1](./img/分支3.1.png)

**普通模式 VS 快速合并**  
普通模式合并后的历史有分支，会在 `merge` 时生成一个新的 **commit**，能看出来曾经做过合并。  
而 `fast forward` 合并就看不出来曾经做过合并，删除分支后，会丢掉分支信息。

### 分支策略  
> 在实际开发中，我们应该按照几个基本原则进行分支管理。  

- *master* 分支应该是非常稳定的，也就是仅用来发布新版本。  
- 干活都在 *dev* 分支上，在版本发布时（如1.0），再把 *dev* 分支合并到 *master* 上，在 *master* 分支发布 1.0 版本。  
- 大家都在 *dev* 分支上干活，每个人都有**自己的分支**，时不时地往 *dev* 分支上合并。  
　　![分支3.2](./img/分支3.2.png)

## Bug 分支  
> 修复 bug 时，我们会通过创建新的 bug 分支进行修复，然后合并，最后删除。

**储藏现场**  
> 工作到一半，被告知要紧急修复一个 bug，此时在分支 dev 上进行的工作还没提交（ 包括未 `git add` ）。  
```elm
$ git stash
```

**然后切换到修复 bug 的分支上（ 如 *master* 分支），创建新的 bug 分支进行修复，然后合并，最后删除。**

**在其他分支修复同样的 bug**
> 切换回 *dev* 分支后，突然想到，*dev* 分支是早期从 *master* 分支分出来的，故这个 bug 其实在当前 *dev* 分支上 **也存在**。  
> 
> 除了可以重复操作提交外，还可以：  
```elm
$ git cherry-pick 4c805e2
```
> 其中的 `4c805e2` 代表先前修复 bug 的提交。  
>```  elm
> $ git add a.html   
> $ git commit -m "fix bug 101"  
> [issue-101 4c805e2] fix bug 101  
>  1 file changed, 1 insertion(+), 1 deletion(-)  
> ```

当然，也可以先在 *div* 分支保存现场，待修复 bug 后，在到 *master* 分支上“ 重放 ”修复。

### 回到工作现场  
> 此时的工作区是干净的，刚才的工作现场可以用 `git stash list` 命令看看。  
> ```elm
> $ git stash list  
> stash@{0}: WIP on dev: f52c633 add merge  
> ```
> 
**恢复现场**
- 方法一：用 `git stash apply` 恢复，但是恢复后，stash 内容并没有删除，需要用 `git stash drop` 来删除。
- 方法二：用 `git stash pop`，恢复的同时把 stash 内容也删。

> **多次储藏**  
> 可以多次 stash，恢复的时候，先用 `git stash list`查看，然后恢复**指定的 stash**，用命令：  
> ```elm
> $ git stash apply stash@{0}
> ```

### 注意事项  
- 也可以先将工作现场的任务完成 **提交后**，再“ 重放 ”修复。
- 如果修复 bug 与工作现场的修改在同个文件的相同处，“ 重放 ”修复可能会导致报错。

## Feature分支  
> 添加一个新功能时，肯定不希望因为一些实验性质的代码，把主分支搞乱了，所以，每添加一个新功能，最好新建一个 *feature* 分支，在上面开发，完成后，合并，最后，删除该 *feature* 分支。这个过程类似于 *处理 bug*。

**强行删除**  
> 准备合并分支前，突然被告知：新功能取消，这个包含新功能的 *feature* 分支 **必须销毁**。 
> 
> 其中的 *feature-121* 为分支名称  
```elm
$ git branch -D feature-121               
```
> tip：没有合并过的分支，如果删除，将 **丢失修改**，普通的方法去删除分支会被报错：  
> ```elm
> $ git branch -d feature-121
> error: The branch 'feature-121' is not fully merged.
> If you are sure you want to delete it, run 'git branch -D feature-121'.
> ```
> （ 正常工作中，为了防止需求变动，不会直接这么操作吧？）

## 多人协作  

### 查看远程库的信息  
> 当从远程仓库克隆时，实际上 Git 自动把本地的 *master* 分支和远程的 *master* 分支 **对应起来** 了，并且，远程仓库的默认名称是 origin。
```elm
$ git remote
origin
```
> 或者，用 `git remote -v` 显示更详细的信息：  
> 可以显示抓取和推送的 origin 的地址。如果没有 **推送权限**，就看不到 push 的地址。
> ```elm
> $ git remote -v
> origin  git@github.com:zhanghaoming/cangkuming.git (fetch)
> origin  git@github.com:zhanghaoming/cangkuming.git (push)
> ```

### 抓取分支：  
模拟同伴，可以在另一台电脑（ 注意要把 **SSH Key** 添加到 GitHub ）或者同一台电脑的另一个目录下克隆：  
```elm
$ git clone git@github.com:zhanghaoming/cangkuming.git
```
> 此时同伴只能看到本地的 *master* 分支。
> ```elm
> $ git branch
> * master  

要在 *dev* 分支上开发，就必须创建远程 origin 的 *dev* 分支到本地。  
```elm
$ git checkout -b dev origin/dev
```
### 多人协作的工作模式

1. 首先，可以试图用 `git push origin <本地分支名>` 推送自己的修改；  
> 推送时，要**指定本地分支**，这样，Git 就会把该分支推送到远程库 **被追踪（ 通常同名的 ）** 远程分支上。  
> 
> 基本用法为 `git push <远程主机名> <本地分支名>:<远程分支名>`，可以查看它[更详细的用法](https://www.cnblogs.com/qianqiannian/p/6008140.html)。 

2. 如果推送失败，是因为远程分支比你的本地更新( 同伴提交了 )，需要先用 `git pull` 试图 **合并**；  
> 如果 `git pull` 提示 **no tracking information**，则说明本地分支和远程分支的链接关系没有创建。
>   
> 查看追踪关系：  
> ```elm
> git branch -vv
> ```
> 创建链接( 追踪关系 )：    
>  ```elm
>  git branch --set-upstream-to=origin/<远程分支名> <本地分支>
>  ```
> 再 pull：  
> ```elm
> $ git pull
> ```

3. 如果合并有冲突，则手动 **解决冲突**，并在本地提交；

4. 没有冲突或者解决掉冲突后，再用 `git push origin <branch-name>` 推送就能成功。

### 判断分支是否需要推送  
- *master* 分支是主分支，因此要时刻与远程同步；
- *dev* 分支是开发分支，团队所有成员都需要在上面工作，所以也需要与远程同步；
- *bug* 分支只用于在本地修复 bug，就没必要推到远程了，除非老板要看看你每周到底修复了几个 bug；
> 本地新建的分支如果不推送到远程，对其他人就是 **不可见的**。
- *feature* 分支是否推到远程，取决于你是否和你的小伙伴合作在上面开发。

### git pull 命令的用法  
基本用法
> git pull <远程主机名> <远程分支名>:<本地分支名>  
> 
> 例子表示将远程主机 origin 的 master 分支拉取过来，与本地的 brantest 分支合并。
```elm
git pull origin master:brantest     
```
省略冒号：
> 表示将远程主机 origin 的 master 分支拉取过来，与本地的**当前分支**进行合并。  
> ```  elm
> git pull origin master          
> ```


## Rebase  
> 要想让 Git 的提交历史成为一条干净的直线，可以执行 **rebase** 的操作，有人把它翻译成“ 变基 ”。  
> 可以把本地 **未push的分叉提交历史** 整理成直线，在查看历史提交的变化时更容易。

同步远程最新代码，开始工作

使用 `git push` 产生冲突，说明有人先你一步同步了他的本地代码到远程。

这时候，需要先拉取代码，有两种方案：

#### 方案Ａ  　　
```elm
git pull
```
该命令会将远程的提交和你本地的提交 **merge** (如果有冲突需要手动解决并提交),且 **会产生 merge 的记录**  
> git pull 的默认行为是 `git fetch` + `git merge`  
> 
> git fetch 表示从远程获取最新版本到本地，不会自动合并分支。

#### 方案Ｂ　　
```elm
git pull -- rebase
```
该命令会**把你的提交“ 放置 ”在远程拉取的提交之后**，即改变基础（变基）。  
> git pull --rebase 的默认行为是 `git fetch` + `git rebase`  
> 
> 如果有冲突，解决所有冲突的文件，然后 `git add <冲突文件>` ，最后：
> ```elm
> git rebase --continue
> ```

### 示意图  
```react
git pull：  
会尝试将 A的提交3 和 B的最终提交（从终端拉取）合并，并会产生 merge 的记录。

*             Merge的提交             
|\              
| *           B的最终提交  
* |           A的提交3  
* |           A的提交2  
|/  
*             A的提交1

git rebase：  
会尝试 在 B的最终提交 （从终端拉取）的基础上，将 A后来的提交 加（移动）上去。

*             A的提交3  
*             A的提交2  
*             B的最终提交  
*             A的提交1  
```

### 解决 rebase 冲突的方案：  
放弃合并，本地内容会回到提交之间的状态，即撤销。  
```elm
$ git rebase --abort 
```
引起冲突的commits会被丢弃（丢弃的是自己的提交）。  
```elm
$ git rebase --skip
```
修改后检查没问题，**合并冲突**，需要配合。
> 手动解决冲突之后，用 **git add** 命令去更新这些内容的索引(index)，然后再执行:
```elm
$ git rebase --continue
```
无误之后就回退出，回到主分支上。

### 注意事项  
在 `git pull` 解决好冲突后，再使用 `git rebase`，会导致变回冲突未解决的状态，因为此时使用了不同的合并方式。







