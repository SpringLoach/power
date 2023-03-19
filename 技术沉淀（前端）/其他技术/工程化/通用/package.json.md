## script拓展

### 设置环境变量

> 在 windows 系统上不支持 `NODE_ENV=production` 这样的配置方式，使用 `cross-env`，能够实现兼容不同系统的差异性，从而能够这样配置环境变量。

<span style="color: #3a84aa">局部安装</span>

```elm
npm install cross-env -S -D
```

<span style="color: #3a84aa">脚本配置</span>

```json
"scripts": {
  "build": "cross-env NODE_ENV=production webpack --config build/webpack.config.js"
}
```



### 移除文件

<span style="color: #3a84aa">局部安装</span>

```elm
npm install rimraf -S -D
```

<span style="color: #3a84aa">脚本配置</span>

<span style="backGround: #efe0b9">package.json</span>

```json
"scripts": {
  "clean-lib": "rimraf lib",
},
```

`rimraf` 的作用：以包的形式包装 `rm -rf` 命令，用于删除文件和文件夹的



### 并行/顺序运行脚本

#### Bash

| 命令 | 说明                                                       |
| ---- | ---------------------------------------------------------- |
| `&&` | 顺序执行多条命令，当碰到执行出错的命令后将不执行后面的命令 |
| `&`  | 并行执行多条命令                                           |
| `||` | 顺序执行多条命令，当碰到执行正确的命令后将不执行后面的命令 |

```json
"scripts": {
  "build": "rimraf lib && npm run build:style",
  "build:style": "gulp --gulpfile ./build/gulpfile.js"
}
```



#### npm-run-all

<span style="color: #3a84aa">局部安装</span>

```elm
npm install npm-run-all -S -D
```

<span style="color: #3a84aa">并行执行|run-p | npm-run-all --parallel</span>

```json
"scripts": {
  "build": "run-p type-check build-only",
  "build-only": "vite build",
  "type-check": "vue-tsc --noEmit --skipLibCheck"
}
```

<span style="color: #3a84aa">顺序执行|run-s | npm-run-all --serial</span>

```json
"scripts": {
  "build": "run-s type-check build-only",
  "build-only": "vite build",
  "type-check": "vue-tsc --noEmit --skipLibCheck"
}
```

<span style="color: #3a84aa">其他使用形式</span>

```json
"scripts": {
  "build": "rimraf lib && run-s build:style",
  "build:style": "gulp --gulpfile ./build/gulpfile.js"
}
```

:turtle: 这个脚本同样支持在 yarn 下使用。



## 附录

参考：

[cross-env的简介、原因、安装和用法](https://blog.csdn.net/weixin_45249263/article/details/123719280)

[npm-run-all——并行或顺序运行多个npm脚本的CLI工具](https://www.jianshu.com/p/4ccff715a6a9)

[npm并行&串行执行多个scripts命令](https://zhuanlan.zhihu.com/p/137993627)

[妙啊！这个库组织npm脚本简直爆炸！](https://blog.csdn.net/web22050702/article/details/125983954)
