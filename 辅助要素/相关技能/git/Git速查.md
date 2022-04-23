### 常用命令手册


操作 | 指令 | 说明  
:- | :- | :-
初始化仓库 | git init | 使用其它指令的前提  
添加文件到缓存区 | git add <file\> | 可反复多次使用   
将缓存文件提交本地仓库 | git commit -m <message\> | /  
查看本地分支 | git branch | /
查看远程分支 | git branch -r | 较少用
创建分支 | git branch <name\> | /
切换分支 | git checkout <name\> | 别名 git switch <name\>
创建+切换分支 | git checkout -b <name\> | 别名 git switch -c <name\> 
合并某分支到当前分支 | git merge <name\> | 需要先切换到当前分支  
删除分支 | git branch -d <name\> | /  
强行删除分支 | git branch -D <name\> | 分支未合并过时，不能普通删除
前往某次提交版本 | git reset --hard <commit_id\>  | /
查看提交历史 | git log  | 方便回到过去版本
查看命令历史 | git reflog  | 方便前往未来版本  
丢弃工作区修改 | git checkout -- <file\> | 尚未添加到缓存
丢弃缓存区修改 | git reset HEAD <file\> | 需要再执行上一步 
从版本库恢复被删除文件 | git checkout -- <file\> | 需要版本库存在该文件   
从版本库恢复被修改文件 | git checkout -- <file\> | 需要版本库存在该文件   
从版本库删除文件 | git rm <file\> | 需要提交操作  
关联远程库 | git remote add origin <url.git\> | origin 是远程库的习惯命名  
推送当前分支到远程**并关联** | git push -u origin <name\> | 关联当前、远程分支，后续推送/拉取可以简化命令  
↑ | / | 如远程分支不存在，将新建远程分支
将当前分支推送（更新）到远程 | git push origin <name\> | 分支通常重名  
将当前分支推送（更新）到远程 | git push origin | 需要关联当前、远程分支  
将当前分支推送（更新）到远程 | git push | 还需要当前分支只有一个远程分支   
从远程库克隆 | git clone <url.git\> | /
查看远程库信息 | git remote -v | /
拉取远程的某分支到本地 | git checkout -b <branch\> origin/<branch\> | 应该不需要下一步
关联本地、远程分支 | git branch --set-upstream-to <branch\> origin/<branch\> | /
从远程获取最新版本到本地并合并 | git pull | 远程分支比本地更新时使用。需要先关联
从远程获取最新版本到本地 | git fetch | /
合并分支 | git merge | /

### 常用操作

#### 添加修改到本地仓库

1\. 查看状态
```elm
git status
```

2\. 添加所有修改文件到暂存区
```elm
git add .
```

3\. 提交到本地仓库
```elm
git commit -m 'xxx'
```

4\. 查看状态
```elm
git status
```

----

#### 添加修改到远程仓库

```elm
git push
```

----

#### 更改关联的远程库  
> 针对报错 `fatal: remote origin already exists.`。  

1\. 删除远程 Git 仓库
```elm
git remote rm origin
```

2\. 添加远程 Git 仓库
```elm
git remote add origin https://github.com/SpringLoach/manager-copy.git
```

----

#### 将本地仓库关联并推送到远程库

1\. 新建空的远程库

2\. 在项目文件下执行如下命令
> 其中 `manager-copy` 为远程库名称，`main` 为分支名，`SpringLoach` 为 GitHub 账号。  
```react
/* 初始化仓库（如果没有） */  
git init  
  
/* 关联远程库 */  
git remote add origin https://github.com/SpringLoach/manager-copy.git
  
/* 强制重命名分支 */  
git branch -M main
  
/* 推送当前分支到远程并关联 */  
git push -u origin main
```

----

#### 提交操作者信息  
> 添加 `--global` 参数，表示机器上所有的Git仓库都会使用这个配置。  

```  elm
$ git config --global user.name "Your Name"
$ git config --global user.email "email@example.com"  
```

验证操作者信息  

```  elm
$ git config user.name 
$ git config user.email 
```
----

#### 协同处理_获取已有远程库某分支处理  

顺序 | 步骤 | 命令
:-: | :- | :-  
① | 从远程库克隆，默认只拉取主分支 `main` | git clone <url.git\>
② | 拉取远程的某分支到本地 | git checkout -b <branch\> origin/<branch\>
③ | 查看分支、正常操作 | ..  

##### 远程库克隆报错  
> 由于网络不稳定，连接超时导致，可再次尝试克隆命令。    
```  elm
fatal: unable to access 'https://github.com/SpringLoach/test.git/': OpenSSL SSL_read: Connection was reset, errno 10054


----

#### 协同处理_他人在当前分支已有提交  

| 顺序 | 步骤                           | 命令     |
| :--: | :----------------------------- | :------- |
|  ①   | 修改后，尝试正常推送           | git push |
|  ②   | 提示错误，建议使用             | git pull |
|  ③   | 会将冲突文件的冲突代码部分标出 | /        |
|  ④   | 手动修改，解决冲突             | /        |
|  ⑤   | 正常操作、再次推送             | /        |
