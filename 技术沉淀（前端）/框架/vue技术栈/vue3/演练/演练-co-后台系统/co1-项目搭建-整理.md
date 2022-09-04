## 创建项目

```
vue create manageS
```



- Manage select features

```elm
(*) Choose Vue version
(*) Babel
(*) TypeScript
(*) Router
(*) Vuex
(*) CSS Pre-proceessor
(*) Linter / Formatter
```

| 选项                                                         | 选择                                               | 说明                   |
| ------------------------------------------------------------ | -------------------------------------------------- | ---------------------- |
| Choose a version of Vue.js that you want to start the project with | 3.x                                                | vue3                   |
| Use class-style component syntax?                            | No                                                 |                        |
| Use Babel alongside TypeScript?                              | Yes                                                | ①                      |
| Pick a CSS pre-processor                                     | Less                                               |                        |
| Pick a linter / formatter config                             | <span style="color: #a50">ESLint + Prettier</span> | 选择的检测规范         |
| Pick additional lint features:                               | Lint on save                                       | 保存代码时进行检测     |
| Where do you prefer placing config for Babel, ESLint, etc.?  | In dedicated config files                          | 在单独的配置文件中配置 |
| Save this as a preset for future project?                    | N                                                  | 不保存为预设方案       |

> ① 使用 Babel 处理 ts，比起 typescript 的 tsc，它还能将一些浏览器不能支持的接口进行适配

 

## 一. 代码规范

### 1.1. 编码风格

> 统一编码风格

1.新增文件

<span style="backGround: #efe0b9">项目/.editorconfig</span>

```yaml
# http://editorconfig.org

root = true # 表示在根目录下

[*] # 表示所有文件适用
charset = utf-8 # 设置文件字符集为 utf-8
indent_style = space # 缩进风格（tab | space）
indent_size = 2 # 缩进大小
end_of_line = lf # 控制换行类型(lf | cr | crlf)
trim_trailing_whitespace = true # 去除行首的任意空白字符
insert_final_newline = true # 始终在文件末尾插入一个新行

[*.md] # 表示仅 md 文件适用以下规则
max_line_length = off
trim_trailing_whitespace = false
```

2.安装插件

对于 <span style="color: #a50">VSCode</span>，还需要额外安装一个插件：EditorConfig for VS Code



### 1.2. 使用prettier工具

> 格式化工具

1.安装prettier

```shell
npm install prettier -D
```

2.新增配置文件

<span style="backGround: #efe0b9">项目/.prettierrc</span>

```
{
  "useTabs": false,
  "tabWidth": 2,
  "printWidth": 80,
  "singleQuote": true,
  "trailingComma": "none",
  "semi": false
}
```

3.新增配置忽略文件

<span style="backGround: #efe0b9">项目/.prettierignore</span>

```
/dist/*
.local
.output.js
/node_modules/**

**/*.svg
**/*.sh

/public/*
```

4.对于 VSCode，需要安装插件 Prettier - Code formatter

5.配置统一格式命令

<span style="backGround: #efe0b9">项目/package.json</span>

```json
"script": {
  "prettier": "prettier --write ."
}
```



### 1.3. 使用ESLint检测

> 解决eslint和prettier冲突的问题。

1.对于 <span style="color: #a50">VSCode</span>，需要安装插件 ESLint

2.解决eslint和prettier冲突的问题：

```elm
npm i eslint-plugin-prettier eslint-config-prettier -D
```

配置prettier插件：

<span style="backGround: #efe0b9">项目/.eslintrc.js</span>

```javascript
  extends: [
    "plugin:vue/vue3-essential",
    "eslint:recommended",
    "@vue/typescript/recommended",
    "@vue/prettier",
    "@vue/prettier/@typescript-eslint",
    'plugin:prettier/recommended'   // 添加：对于相同的配置，由后面的覆盖前面
  ],
```



### 1.4. git Husky和eslint

> 在执行 <span style="color: #a50">git commit</span> 的时候会自动对代码进行lint校验和修复。

```shell
npx husky-init '&&' npm install
```

<span style="backGround: #efe0b9">项目/.husky/pre-commit</span>

```
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

npm run lint
```



### 1.5. git commit规范

#### 1.5.1. 代码提交风格

通常我们的git commit会按照统一的风格来提交，这样可以快速定位每次提交的内容，方便之后对版本进行控制。

1.安装Commitizen

```shell
npm install commitizen -D
```

2.安装并且初始化cz-conventional-changelog：

```shell
npx commitizen init cz-conventional-changelog --save-dev --save-exact
```

<span style="backGround: #efe0b9">项目/package.json</span>

```json
"scripts": {
  "commit": "cz"
},
```

#### 1.5.2. 代码提交验证

> 不规范的格式不允许提交。

1.安装 @commitlint/config-conventional 和 @commitlint/cli

```shell
npm i @commitlint/config-conventional @commitlint/cli -D
```

2.在根目录创建commitlint.config.js文件，配置commitlint

<span style="backGround: #efe0b9">项目/commitlint.config.js</span>

```js
module.exports = {
  extends: ['@commitlint/config-conventional']
}
```

3.使用husky生成commit-msg文件，将对提交信息进行验证：

```elm
npx husky add .husky/commit-msg
```

<span style="backGround: #efe0b9">项目/.husky/commit-msg</span>

```
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

npx --no-install commitlint --edit $1
```



## 二. 第三方库集成

### 2.4. element-plus集成

>  针对于vue3开发的一个UI组件库；

1.安装

```elm
npm install element-plus
```

2.按需引入（自动）

```elm
npm install -D unplugin-vue-components unplugin-auto-import
```

<span style="backGround: #efe0b9">项目/vue.config.js</span>

```javascript
const AutoImport = require('unplugin-auto-import/webpack')
const Components = require('unplugin-vue-components/webpack')
const { ElementPlusResolver } = require('unplugin-vue-components/resolvers')

module.exports = {
  configureWebpack: {
    plugins: [
      AutoImport({
        resolvers: [ElementPlusResolver()]
      }),
      Components({
        resolvers: [ElementPlusResolver()]
      })
    ]
  }
}
```



### 2.5. axios集成

安装axios：

```shell
npm install axios
```

封装axios：

<span style="backGround: #efe0b9">src/service/request/index.ts</span>

```ts
import axios, { AxiosInstance, AxiosRequestConfig } from 'axios'

class Request {
  private instance: AxiosInstance

  private readonly options: AxiosRequestConfig

  constructor(options: AxiosRequestConfig) {
    this.options = options
    this.instance = axios.create(options)

    this.instance.interceptors.request.use(
      (config) => {
        const token = 'demo' // 从vuex或缓存中获取
        if (token) {
          if (!config.headers) {
            config.headers = {}
          }
          config.headers.Authorization = `Bearer ${token}`
        }
        return config
      },
      (err) => {
        return err
      }
    )

    this.instance.interceptors.response.use(
      (res) => {
        // 拦截响应的数据
        return res.data
      },
      (err) => {
        return err
      }
    )
  }

  request<T = any>(config: AxiosRequestConfig): Promise<T> {
    return new Promise((resolve, reject) => {
      this.instance
        .request<any, T>(config)
        .then((res) => {
          resolve(res as unknown as Promise<T>)
        })
        .catch((err) => {
          reject(err)
        })
    })
  }
}

export default Request
```

<span style="backGround: #efe0b9">src/service/request/config.ts</span>

```javascript
// 手动的切换不同的环境(不推荐)
// 1:开发 2:生产
const condition = 1

let BASE_URL: string, BASE_NAME: string

if (condition === 1) {
  BASE_URL = 'http://coderwhy.org/dev'
  BASE_NAME = 'dev'
} else if (condition === 2) {
  BASE_URL = 'http://coderwhy.org/prod'
  BASE_NAME = 'prod'
}

const TIME_OUT = 10000

export { BASE_URL, BASE_NAME, TIME_OUT }
```

<span style="backGround: #efe0b9">src/service/index.ts</span>

```javascript
import Request from './request'
import { BASE_URL, TIME_OUT } from './request/config'

const baseRequest = new Request({
  baseURL: BASE_URL,
  timeout: TIME_OUT
})

export default baseRequest
```

<span style="backGround: #efe0b9">Demo.ts</span>

```javascript
import baseRequest from './service'

baseRequest.request({
  url: '/home/multidata',
  method: 'GET'
})
```



## 三. 样式集成

前往 [github](https://github.com/necolas/normalize.css) 下载，复制代码到 <span style="backGround: #efe0b9">src/assets/css/normalize.css</span>

<span style="backGround: #efe0b9">src/assets/css/base.less</span>

```css
body {
  padding: 0;
  margin: 0;
}

html, body, #app {
  width: 100%;
  height: 100%;
}
```

统一导出导入

<span style="backGround: #efe0b9">src/assets/css/index.less</span>

```less
@import "./normalize.css";
@import "./base.less";
```

<span style="backGround: #efe0b9">src/main.ts</span>

```javascript
import './assets/css/index.less'
```



## 四. 规范：

组件都提供一个根元素，且类名与组件名一致









# ----

## 保存时无法格式化该文件

> VSCode

<span style="color: #f7534f;font-weight:600">解决：</span>

1.文件 - 首选项 - 设置 - 搜索 格式化 - 勾选下面两项

```
Editor: Format On Save
Editor: Format On Type
```

2.`Ctrl` + `Shift` + `P` - 搜索 *Open WorkSpace Settings(JSON)* 

<span style="backGround: #efe0b9">.vscode/settings.json</span>

```json
{
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.tabSize": 2
}
```







## 忽略警告

### 模板需要根元素

[vue/no-multiple-template-root]

<span style="color: #f7534f;font-weight:600">原因：</span>由 Vetur 插件 发出的警告：

<span style="color: #f7534f;font-weight:600">解决：</span>文件 - 首选项 - 设置 - 搜索 eslint - 找到 Vetur - 取消勾选 - 重启编辑器

![image-20220317230444946](D:\笔记\技术沉淀（前端）\vue技术栈\vue3\后台项目\img\vetur验证)



### 关闭eslint警告

当 eslint 对某些代码给出了警告，但自己能确定这就是自己想要的效果时，可以关闭检测。

1.复制小括号后的内容

![eslint警告](D:\笔记\技术沉淀（前端）\vue技术栈\vue3\后台项目\img\eslint警告.png)

2.将内容粘贴到配置文件

- <span style="backGround: #efe0b9">eslintrc.js</span> 

```javascript
module.exports = {
  ...
  rules: {
    'no-console': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
    'no-debugger': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
    '@typescript-eslint/no-var-requires': 'off',       // 添加，并赋值为 'off'
  }
}
```

:whale: 表示关闭检测：使用 require 方式引入模块。

