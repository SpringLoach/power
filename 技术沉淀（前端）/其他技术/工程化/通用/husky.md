## 介绍

husky 通常用于在提交/推送前，校验提示信息，校验代码等。



## 安装使用

### 自动方式

<span style="color: #3a84aa">需要先初始化git仓库</span>，再执行下面的命令，否则会报错

```elm
git init
```

<span style="color: #3a84aa">安装</span>

```elm
npx husky-init && npm install       # npm
npx husky-init && yarn              # Yarn 1
yarn dlx husky-init --yarn2 && yarn # Yarn 2+
pnpm dlx husky-init && pnpm install # pnpm
```

:octopus: 使用 window 系统时，需要在连接符前后加上引号 `'&&'`，否则识别不了；

:turtle: `husky-init` 是一次性的命令，用于快速初始化项目；

:turtle: 这将会修改 `package.json` 、并创建预提交钩子的示例文件，文件配置了在提交前执行 `npm test`；

:turtle: 如果执行 `npm test` 的过程发生了错误，代码将不会提交。



<span style="color: #3a84aa">添加其它钩子</span>

```shell
npx husky add .husky/commit-msg 'npx --no -- commitlint --edit "$1"'
```

:octopus: 对于 window，如果出现其它提示，将语法改为 `node node_modules/husky/lib/bin add ...`

:ghost: 这将会生成 `commit-msg` 文件，并将命令语句中引号的内容作为文件内容



### 手动方式

<span style="color: #3a84aa">安装</span>

1. 安装 `husky`

```elm
npm install husky --save-dev
```

2. 开启 `git hooks`

```elm
npx husky install
```

3. 为了在执行 `install` 后能够自动开启 `git hooks`，需要添加脚本命令

```elm
npm pkg set scripts.prepare="husky install"
```

<span style="color: #3a84aa">创建示例钩子</span>

```elm
npx husky add .husky/pre-commit "npm test"
```

<span style="color: #3a84aa">卸载</span>

```elm
npm uninstall husky && git config --unset core.hooksPath
```



## 相关

### 不使用钩子

添加 `-n/--no-verify` 配置可以绕过 `pre-commit` 和 `commit-msg` 这两个钩子的校验。

```elm
git commit -m "yolo!" --no-verify
```



### 废弃写法

这种配置方式在 v6 版本已经被废弃了，故不能生效

<span style="backGround: #efe0b9">package.json</span>

```json
{
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "husky": {
    "hooks": {
      "pre-commit": "npm run test"
    }
  },
}
```



## 项目实践

### 提交前修复

<span style="color: #3a84aa">一、如果没有，准备 ` .husky/pre-commit` 文件</span>

```elm
npx husky add .husky/pre-commit "npm test"
```

<span style="color: #3a84aa">二、启用脚本</span>

<span style="backGround: #efe0b9">.husky/pre-commit</span>

```elm
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

npm run lint-staged
```

<span style="color: #3a84aa">三、安装配置 lint-staged 脚本，包括它的匹配模式和触发命令</span>

```elm
npm install lint-staged -D -S
```

<span style="backGround: #efe0b9">package.json</span>

```json
{
  "scripts": {
    "lint-staged": "lint-staged"
  },
  "lint-staged": {
    "*.js": [
      "eslint --fix",
      "git add ."
    ]
  }
}
```

:whale: 需要先初始化 eslint，并配置好 `.eslintrc.js` 文件，`eslint --fix` 才能发挥作用；

:whale: 也可以在使用 `eslint` 前先添加 `prettier --write` 来进一步格式化文件;

:star2: 使用 <span style="color: #a50">lint-staged</span> 能够只检查&修复暂存区中的文件，节省性能，避免影响其他文件。



:whale: 匹配规则示例

```javascript
"lint-staged": {
  "src/**/*.{js,vue,ts,jsons}": [
    "prettier --write",
    "eslint --fix",
    "git add ."
  ]
}
```

glob 语法解释：

- `*` 匹配0或多个除了 / 以外的字符

- `**` 匹配多个字符包括 /

- `{}` 可以让多个规则用 , 逗号分隔，起到或者的作用



### 提交前校验信息

<span style="color: #3a84aa">一、安装依赖</span>

```shell
npm install @commitlint/cli @commitlint/config-conventional -S -D
```

<span style="color: #3a84aa">二、生成配置文件</span>

```shell
echo "module.exports = {extends: ['@commitlint/config-conventional']}" > commitlint.config.js
```

:octopus: 如果使用 window，需手动创建一下这个文件；默认生成的 `utf-16` 格式是有问题的。

<span style="backGround: #efe0b9">commitlint.config.js</span>

```javascript
module.exports = { extends: ['@commitlint/config-conventional'] }
```

<span style="color: #3a84aa">三、添加 husky 钩子</span>

```shell
#添加 commit-msg 钩子
npx husky add .husky/commit-msg 'npx --no-install commitlint --edit "$1"'
```

 

:whale:配置示例

```javascript
module.exports = {
  // 解析并从node_modules加载@commitlint/config常规
  extends: ['@commitlint/config-conventional'],
  rules: {
    "subject-empty": [2, "never"],
    // type 不能为空
    "type-empty": [2, "never"],
    // type 的可选值
    "type-enum": [
      2,
      "always",
      [
        "feat", // 新增功能
        "fix", // 修复缺陷
        "style", // 代码格式（不影响功能，例如空格、分号等格式修正）
        "refactor", // 代码重构（不包括 bug 修复、功能新增）
        "test", // 添加疏漏测试或已有测试改动
        "chore", // 对构建过程或辅助工具和库的更改
        "revert" //对构建过程或辅助工具和库的更改（不影响源文件、测试用例）
      ],
    ],
  }
}
```



## 附录

参考资料

- [husky官方文档](https://typicode.github.io/husky/#/)


- [commitlint.js官方文档](https://commitlint.js.org/#/)
- [前端提交信息规范——commitlint](http://events.jianshu.io/p/0f577906b5d1)



## 补充的话

在[仓库](https://github.com/SpringLoach/power)，还提供了许多<span style="color: #3a84aa">前端常见需求</span>及实现的归纳整理，欢迎客官看看~

如果这篇笔记能够帮助到你，请帮忙在 [github](https://github.com/SpringLoach/power) 上点亮 `star`，感谢！
