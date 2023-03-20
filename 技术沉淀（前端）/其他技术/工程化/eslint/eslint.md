## 介绍

阅读前两个章节可以快速应对项目中的eslint规则调整/禁用的场景；

后面的[使用示例](使用示例)和[常用配置](常用配置)推荐刚刚接触eslint的读者使用。



## 配置eslint语法规则

```json
module.exports = {
  // ...
  "rules": {
    "semi": ["error", "always"],
    "camelcase": "off"
  }
}
```

| 错误级别        | 说明                             |
| --------------- | -------------------------------- |
| `"off"` / `0`   | 关闭规则                         |
| `"warn"` / `1`  | 不满足规则将生成警告             |
| `"error"` / `2` | 不满足规则将生成错误，会退出程序 |

:whale: 可以参考[中文文档](https://eslint.bootcss.com/docs/rules/)查看语法配置项的具体含义； 



## 忽略eslint语法检查

### 忽略多个文件

<span style="backGround: #efe0b9">[root]/.eslintignore</span>

```shell
# 忽略build目录下类型为js的文件
build/*.js
# 忽略src/assets目录下文件
src/assets
# 忽略public目录下文件
public
# 忽略当前目录下为js的文件
*.js
# 忽略当前目录的demo.js文件
demo.js
# 忽略所有文件
*
```



### 忽略单个文件

#### 忽略整个文件

```javascript
/* eslint-disable */
some code
some code
```

```vue
<!--  eslint-disable-->
<template></template>
...
```

:whale: 在 `.vue` 文件中需要忽略整个文件的eslint校验时，语法如上。

#### 忽略一段代码

```javascript
/* eslint-disable */
some code
some code
/* eslint-enable */
```

#### 忽略下一行

```javascript
// eslint-disable-next-line
some code
```

```javascript
// 使用示例
watch: {
  // eslint-disable-next-line
  'a.b': function () {
    this.loadList();
  },
},
```

#### 忽略当前行

```javascript
some code // eslint-disable-line
```

```javascript
console.log(message); // eslint-disable-line no-console
```



## 使用示例

<span style="color: #3a84aa">初始化项目</span>

```shell
npm init -y
```

<span style="color: #3a84aa">安装eslint依赖</span>

```shell
npm install eslint --save-dev
```

<span style="color: #3a84aa">初始化eslint，在项目根目录下生成 `.eslintrc.*`</span>

```shell
npm run ./node_modules/.bin/eslint --init
```

<span style="backGround: #efe0b9">.eslintrc.js</span>

```javascript
module.exports = {
  // ...
  "extends": "eslint:recommended"
}
```

:ghost: 由于这行，所有在[规则页面](https://eslint.bootcss.com/docs/rules)被标记为 :heavy_check_mark: 的规则将会默认开启;

:whale: 也可以使用其他的配置集，或写成数组形式来使用多个配置集。

<span style="color: #3a84aa">编写例子用于测试</span>

<span style="backGround: #efe0b9">demo.js</span>

```javascript
function dos() {
  console.log(123)
}
function dos() {
  console.log(456)
}

dos()
```

<span style="color: #3a84aa">配置并启用脚本</span>

<span style="backGround: #efe0b9">package.json</span>

```json
"scripts": {
  "test": "node demo.js"
}
```

```shell
npm run test
```

:star2: 使用 <span style="color: slategray">vscode</span> 时，还需要额外安装插件 ESLint 才能使校验生效；



## 常用配置

编写配置文件有以下三种方式，添加的配置将作用于整个目录：

- 使用 JavaScript/json/yaml，编写对应的 `.eslintrc.*` 配置；

- 直接在 `package.json` 文件里的 `eslintConfig` 字段配置；

- 在命令行指定需要运行的配置文件。

  ```shell
  eslint -c test.js
  ```

  

### 配置规则项

配置 `rules` 可以对细粒度的语法规则进行配置

```json
module.exports = {
  // ...
  "rules": {
    "semi": ["error", "always"],
    "camelcase": "off",
    "plugin1/rule1": "off"
  }
}
```

:ghost: 属性名为规则名称，字符串/数组首参为设置的错误级别；

:turtle: 规则 `plugin1/rule1` 表示来自插件 `plugin1` 的 `rule1` 规则，

:turtle: 指定来自插件的规则时，需要删除 `eslint-plugin-` 前缀。

| 错误级别        | 说明                             |
| --------------- | -------------------------------- |
| `"off"` / `0`   | 关闭规则                         |
| `"warn"` / `1`  | 不满足规则将生成警告             |
| `"error"` / `2` | 不满足规则将生成错误，会退出程序 |



### 支持ES6

```javascript
module.exports = {
  // ...
  "parserOptions": {
    "ecmaVersion": 6
  },
  "env": {
    "es6": true
  }
}
```



### 指定解析器

```javascript
module.exports = {
  // ...
  "parser": {
    "ecmaVersion": "esprima"
  }
}
```

| 可选值                                                       | 说明                             |
| ------------------------------------------------------------ | -------------------------------- |
| [babel-eslint](https://www.npmjs.com/package/babel-eslint)（废弃） | 保证 babel，以实现与 eslint 兼容 |
| [@babel/eslint-parser](https://www.npmjs.com/package/@babel/eslint-parser) | babel-selint 的新实现            |
| [@typescript-eslint/parser](https://www.npmjs.com/package/@typescript-eslint/parser) | 能够实现 ts 与 eslint 的兼容     |

:turtle: 使用了自定义解析器后，也需要配置 `parserOptions`，它会传入解析器，来决定是否启用 es6 等。



### 指定环境

每个环境都有对应的预定义好的全局变量，让 eslint 知道它们的存在，方便在项目中使用，且不报错。

```javascript
module.exports = {
  // ...
  "env": {
    "browser": true,
    "node": true
  }
}
```

| 可选值   | 说明                                          |
| -------- | --------------------------------------------- |
| browser  | 浏览器环境中的全局变量                        |
| node     | Node.js 全局变量和 Node.js 作用域             |
| commonjs | commonjs 全局变量和 commonjs 作用域           |
| es6      | 启用除了 modules 以外的所有 ECMAScript 6 特性 |
| es6      | 该选项会自动设置 `ecmaVersion: 6`，即支持 es6 |



### 定义全局变量

需要在源文件中使用未定义变量时，为避免报错需要进行配置：

```javascript
module.exports = {
  // ...
  "globals": {
    "var1": "writable", // 允许重写
    "var2": "readonly"  // 只读
  }
}
```

:hammer_and_wrench: 要启用 [no-global-assign ](https://eslint.bootcss.com/docs/rules/no-global-assign)规则来禁止对只读的全局变量进行修改。



### 使用插件

```javascript
module.exports = {
  // ...
  "plugins": [
    "eslint-plugin-plugin1",
    "plugin2"
  ]
}
```

:hammer_and_wrench: 使用插件前需要先安装插件依赖；

:hammer_and_wrench: 插件名称可以省略 `eslint-plugin-` 前缀。



### 层叠配置

取当前目录与祖先目录配置文件的并集，当前目录规则优先。

```
your-project
├── package.json
├── lib
│ └── source.js
└─┬ tests
  ├── .eslintrc
  └── test.js
```



## 附录

更多资料

[eslint配置文档-中文](https://eslint.bootcss.com/docs/rules/)

[eslint-命令行文档](https://eslint.bootcss.com/docs/user-guide/command-line-interface)

[eslint-plugin-vue文档](https://eslint.vuejs.org/user-guide/)

[eslint-plugin-vue配置文档](https://eslint.vuejs.org/rules/comment-directive.html)



参考资料

- [eslint常见问题记录](http://events.jianshu.io/p/e7a83e4e56f3)

- [.eslintrc.js文件内容/配置eslint/eslint参数](https://blog.csdn.net/qq_51657072/article/details/124427270)



## 补充的话

在[仓库](https://github.com/SpringLoach/power)，还提供了许多<span style="color: #3a84aa">前端常见需求</span>及实现的归纳整理，欢迎客官看看~

如果这篇笔记能够帮助到你，
