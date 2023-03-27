# 基础使用

## 安装

```elm
npm install esbuild -S -D
```

<span style="color: #3a84aa">确认安装成功</span>

```elm
.\node_modules\.bin\esbuild --version
```



## 初体验

<span style="color: #3a84aa">使用 react 作为示例</span>

```elm
cnpm install react react-dom -D -S
```

<span style="color: #3a84aa">在目录下新建文件</span>

<span style="backGround: #efe0b9">app.jsx</span>

```javascript
import * as React from 'react'
import * as Server from 'react-dom/server'

let Greet = () => <h1>Hello, world!</h1>
console.log(Server.renderToString(<Greet />))
```

<span style="color: #3a84aa">构建输出</span>

<span style="backGround: #efe0b9">package.json</span>

```json
"scripts": {
  "test1": "esbuild app.jsx --bundle --outfile=out.js"
}
```

```elm
npm run test1
```

<span style="color: #3a84aa">获取到产物</span>

在目录下会生成 `out.js` 文件，内部包含了 React 代码和业务代码，不再依赖于 `node_modules`

<span style="color: #3a84aa">运行产物</span>

```elm
node out.js
```

<span style="color: #3a84aa">可以得到控制台输出</span>

```html
<h1>Hello, world!</h1>
```

:whale: 想要在 `.js` 文件中使用 JSX 语法，可以在命令行添加 `--loader:.js=JSX` 表示允许这种做法。



## 使用配置文件

- 在选项过多时，建议使用配置文件代替命令行；

- 这里的代码需保存在 `.mjs` 后缀名的文件中，因为使用了 `import` 和顶级 `await`。

```javascript
import * as esbuild from 'esbuild'

// 返回 promise
await esbuild.build({
  entryPoints: ['app.jsx'],
  bundle: true,
  outfile: 'out.js',
})
```

:whale: 示例为异步风格的 API，能够满足插件的环境；同步 API 不建议使用，除非需要在 Node 中做特定事情。



## 用于浏览器

默认情况下构建的 bundler 是用于浏览器的；

开发版本，希望使用 `--sourcemap` 映射源码；

生产版本，希望启用 `--minify` 压缩、支持目标浏览器（将较新的js语法转成旧的）；

全部都使用上的话，命令行大概是这个形式：

```elm
esbuild app.jsx --bundle --minify --sourcemap --target=chrome58,firefox57,safari11,edge16
```



## 用于Node.js

- 在 Node 中使用 bundler 不是必须的，但使用 esbuild 处理仍有好处；

- 如将 ES Module 转化为 CommonJS，将较新的 JavaScript 语法转成旧语法，发布前压缩；

- 如果 esbuild 需要构建 Node 中使用的包，应该添加如下参数，

  ```elm
  --plaform=node
  ```

- 它默认将内置模块，如 `fs` 标记为外部包，从而不会构建到 bundle 中



<span style="color: green">使用新的 JavaScript 语法</span>

如果代码中使用了较新的语法，在 Node 当中不能生效，需要指定 Node 的目标版本：

```elm
esbuild app.js --bundle --platform=node --target=node10.4
```



<span style="color: green">排除依赖</span>

很多 Node 特性是 esbuild 不能支持的，如 `__dirname`、`fs.readFileSync`，

通过将包设置为外部，可以从捆绑包中排除所有依赖项，

这样做的话，需要保证相关依赖在运行时存在于文件系统中。

```elm
esbuild app.jsx --bundle --platform=node --packages=external
```



# API

使用命令行方式时，要理解不同标志类型的作用

| 标志类型  | 示例        | 说明                 |
| --------- | ----------- | -------------------- |
| --foo     | --minify    | 是否启用的布尔标志   |
| --foo=var | --platform= | 单个值，只能指定一次 |
| --foo:bar | --external: | 多个值，可以指定多次 |



## 自动重新构建

- 有三种模式提供这方面的支持；
- 可以组合使用，如想要在保存文件时，实时重新加载页面，需要组合使用 Watch Mode 和 Serve Mode

### Watch Mode

在文件修改时自动重新构建

```elm
esbuild app.ts --bundle --outdir=dist --watch

[watch] build finished, watching for changes...
```



### Serve Mode

会启用本地服务器，提供最新构建结果

```elm
esbuild app.ts --bundle --outdir=dist --serve

 > Local:   http://127.0.0.1:8000/
 > Network: http://192.168.0.1:8000/
```



### Rebuild Mode

手动调用重新构建的 API，命令行方式不支持配置

```javascript
// 略
```



## transformt特性

常用于压缩代码、将 TypeScript 转换为 JavaScript 等

```javascript
import * as esbuild from 'esbuild'

let ts = 'let x: number = 1'
let result = await esbuild.transform(ts, {
  loader: 'ts',
})
console.log(result)
```



## 常用选项

| 选项                   | 说明                                                         |
| ---------------------- | ------------------------------------------------------------ |
| bundle                 | esbuild 默认不会将依赖（包括依赖的依赖）内联到 bundle 中，需要显式启用 |
| bundle                 | 如果不开启，依赖只会通过模块语法来简单的引入                 |
| 通用                   | 绑定在编译时进行，故不支持动态的导入路径                     |
| cancel                 | 使用 cancel 可以实现取消正在进行的手动构建，以便开始新的构建 |
| platform               | 默认，构建的 bundle 是用于浏览器的，想要构建用于 Node，需指定平台 |
| 平台设置为浏览器(默认) | 启用绑定后，默认输出格式设置为iife，立即执行函数可以避免变量污染 |
| external               | 将文件/包标记为外部资源，保留导入，而不是内联到 bundle       |
| external               | 导入保留方式：require(iife、cjs)；import(esm)                |

:whale: [文档](https://esbuild.github.io/api/)给出了命令行/javascript/Go三种形式的很多配置例子，可以很方便的去对照学习。



# 附录

参考资料

- [esbuild官方文档](https://esbuild.github.io/getting-started/#install-esbuild)



# 补充的话

在[仓库](https://github.com/SpringLoach/power)，还提供了许多<span style="color: #3a84aa">前端常见需求</span>及实现的归纳整理，欢迎客官看看~

如果这篇笔记能够帮助到你，请帮忙在 [github](https://github.com/SpringLoach/power) 上点亮 `star`，感谢！

