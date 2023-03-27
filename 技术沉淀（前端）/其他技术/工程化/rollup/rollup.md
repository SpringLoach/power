## 介绍

如果需要直接开发项目，webpack 是合适的，它将图片、js、css等视作资源，但本身比较笨重，会稍微增大代码的体积；

如果要开发js库，就可以使用配置简单且轻量的 rollup 了。



## 特性

- 能够<span style="color: #ff0000">支持模块化开发</span>，使开发者能够使用 ES6 模块的方式编写代码；

- 支持 ES6 模块，能够从库中单独引入需要的函数；

- 拥有 Tree-Shaking 的能力，能够对代码进行静态分析，并剔除未使用到的代码；

  ```javascript
  import { ajax } from './utils';
  ```

- 对比 commonJS：如果使用 commonJS，需要导入整个三方库，然后简单的通过代码压缩工具查找未使用变量，效率没这么高；

  ```javascript
  const utils = require( './utils' );
  ```

- 输入：可以通过使用[插件](https://github.com/rollup/plugins/tree/master/packages/commonjs)来支持 commonJS 模块；

- 输出：可以将代码编译为 umd/commonJS 格式实现对 Node.js 等环境的支持。



## 安装

```shell
npm install --global rollup
```

:turtle: 实际做项目时，也可以进行本地安装。



## 配置方式-命令行

> 下面的例子将 `main.js` 作为应用的入口，将所有的引入都编译到单文件 `bundle.js` 中。

用于浏览器：

```shell
# 编译为供 <script> 调用的立即执行函数
rollup main.js --file bundle.js --format iife
```

用于 Node.js：

```shell
# 编译为 CommonJS 模块
rollup main.js --file bundle.js --format cjs
```

同时用于浏览器和 Node.js：

```shell
# 需要为 UMD 格式的包指定一个名称，否则会报错
rollup main.js --file bundle.js --format umd --name "myBundle"
```



## 配置方式-配置文件

配置文件是一个导出配置对象的ES模块，通常位于项目根目录，并命名为 `rollup.config.js`

```javascript
export default {
  input: 'src/main.js',
  output: {
    file: 'bundle.js',
    format: 'cjs'
  }
};
```

使用 `.cjs` 的拓展名，配置文件可以使用 `commonJS` 模块，就能支持 `require` 和 `module.exports` 语法；



### 构建不同的输出

- 根据不同的入口构建不同的 bundle，可配置为对象数组；
- 为相同的入口构建多个 bundle，可以将输出项写成数组。

```javascript
export default [{
  input: 'main-a.js',
  output: {
    file: 'dist/bundle-a.js',
    format: 'cjs'
  }
}, {
  input: 'main-b.js',
  output: [
    {
      file: 'dist/bundle-b1.js',
      format: 'cjs'
    },
    {
      file: 'dist/bundle-b2.js',
      format: 'es'
    }
  ]
}];
```



### 异步构建

Rollup 可以处理结果为对象/数组形式的 promise。

<span style="color: #3a84aa">例子一</span>

```javascript
import fetch from 'node-fetch';
export default fetch('/some-remote-service-or-file-which-returns-actual-config');
```

<span style="color: #3a84aa">例子二</span>

```javascript
export default Promise.all([
  fetch('get-config-1'),
  fetch('get-config-2')
])
```



### 自定义文件路径

在命令行加上 `--config` 或者 `-c` 的选项，就可以使用指定的配置文件。

```shell
rollup --config rollup.config.dev.js
```

忽略文件名，会按照特定顺序加载配置文件

> rollup.config.mjs -> rollup.config.cjs -> rollup.config.js

```shell
rollup --config
```



## 使用插件

> 使用插件能够拓展 Rollup 本身的行为，如使用 NPM 安装导入模块，使用 Babel 编译代码，运行 JSON 文件。

### 示例一

使 Rollup 支持从 JSON 文件中导入数据。

<span style="color: #3a84aa">安装</span>

```shell
npm install --save-dev @rollup/plugin-json
```

<span style="color: #3a84aa">使用</span>

<span style="backGround: #efe0b9">src/main.js</span>

```javascript
import { version } from '../package.json';

export default function () {
  console.log('version ' + version);
}
```

<span style="color: #3a84aa">配置</span>

<span style="backGround: #efe0b9">rollup.config.js</span>

```javascript
import json from '@rollup/plugin-json';

export default {
  input: 'src/main.js',
  output: {
    file: 'bundle.js',
    format: 'cjs'
  },
  plugins: [ json() ]
};
```

:turtle: 不使用这个插件，也能从 JSON 文件中导入数据，参考[官方示例](https://github.com/rollup/rollup-starter-lib)。

### 示例二

对输出的代码进行压缩，来生成压缩后的 bundles。

```shell
npm install --save-dev rollup-plugin-terser
```

<span style="color: #3a84aa">配置</span>

<span style="backGround: #efe0b9">rollup.config.js</span>

```javascript
import {terser} from 'rollup-plugin-terser';

export default {
  input: 'src/main.js',
  output: {
    file: 'bundle.js',
    format: 'cjs',
    plugins: [terser()]
  },
};
```

:star2: 注意插件的使用时机，压缩适合在 Rollup 分析代码后使用，故配置在 `output.plugins` 中。



## 集成三方工具

### 使用npm包

<span style="color: #3a84aa">在代码中使用任意包</span>

```shell
npm install the-answer
```

<span style="backGround: #efe0b9">src/main.js</span>

```javascript
import answer from 'the-answer';

export default function () {
  console.log('the answer is ' + answer);
}
```

<span style="color: #3a84aa">支持 Rollup 找到外部模块</span>

```shell
npm install --save-dev @rollup/plugin-node-resolve
```

<span style="backGround: #efe0b9">rollup.config.js</span>

```javascript
import resolve from '@rollup/plugin-node-resolve';

export default {
  input: 'src/main.js',
  output: {
    file: 'bundle.js',
    format: 'cjs'
  },
  plugins: [ resolve() ]
};
```

:octopus: 如果没有使用插件 `@rollup/plugin-node-resolve`，那么输出的 `bundle.js` 将不会注入<span style="color: slategray">使用到的包</span>，并在控制台提示：

```elm
(!) Unresolved dependencies
https://rollupjs.org/guide/en/#warning-treating-module-as-external-dependency
```



### 处理commonJS

使用插件 [@rollup/plugin-commonjs](https://github.com/rollup/plugins/tree/master/packages/commonjs) 能够支持依赖中的 `commonJS`，注意应该在其他插件前调用。



### 前置依赖

如果构建一个具有前置依赖的库（类似 React / Loadsh），按照下面的方式设置，rollup 将会打包所有的引入项:

```javascript
import _ from 'lodash';
```

- 可以通过 `external` 指定外部引入，它们不会被打包到 bundle 当中去；
- 构建的包如果是提供给浏览器使用，指定 `external` 会导致依赖找不到。

```javascript
// rollup.config.js
import resolve from '@rollup/plugin-node-resolve';

export default {
  input: 'src/main.js',
  output: {
    file: 'bundle.js',
    format: 'cjs'
  },
  plugins: [resolve({
    // 将自定义选项传递给解析插件，【推测为外部引入的查找路径】
    customResolveOptions: {
      moduleDirectory: 'node_modules'
    }
  })],
  // 指出哪些模块需要被视为外部引入
  external: ['lodash']
};
```



### Babel

能够使 rollup 支持最新的 JavaScript 特性。

<span style="color: #3a84aa">安装插件并配置</span>

```shell
npm i -D @rollup/plugin-babel @rollup/plugin-node-resolve
```

```shell
npm i -D @babel/core @babel/preset-env
```

<span style="backGround: #efe0b9">rollup.config.js</span>

```javascript
import resolve from '@rollup/plugin-node-resolve';
import babel from '@rollup/plugin-babel';

export default {
  input: 'src/main.js',
  output: {
    file: 'bundle.js',
    format: 'cjs'
  },
  plugins: [
    resolve(),
    babel({ babelHelpers: 'bundled' })
  ]
};
```

<span style="color: #3a84aa">配置 babel</span>

<span style="backGround: #efe0b9">src/.babelrc.json</span>

```javascript
{
  "presets": [
    ["@babel/env", {"modules": false}]
  ]
}
```

:ghost: 设置 `modules: false` 来避免 babel 将模块转化为 commonJS；

:turtle: babel 将在正在编译的文件的当期目录中查找 `.babelrc`，如果不存在，就顺着目录往上找。

<span style="color: #3a84aa">添加es6语法以方便测试</span>

<span style="backGround: #efe0b9">src/main.js</span>

```javascript
import answer from 'the-answer';

export default () => {
  console.log(`the answer is ${answer}`);
}
```



### Gulp

Gulp 可以理解 Rollup 返回的 Promise。

```javascript
const gulp = require('gulp');
const rollup = require('rollup');
const rollupTypescript = require('@rollup/plugin-typescript');

gulp.task('build', async function () {
  const bundle = await rollup.rollup({
    input: './src/main.ts',
    plugins: [
      rollupTypescript()
    ]
  });

  await bundle.write({
    file: './dist/library.js',
    format: 'umd',
    name: 'library',
    sourcemap: true
  });
});
```

:whale: 这里使用了 Rollup 的 JavaScript API，在内存中构建包，然后输出到硬盘中。



## 示例一

<span style="backGround: #efe0b9">rollup.config.js</span>

```javascript
import resolve from '@rollup/plugin-node-resolve';
import commonjs from '@rollup/plugin-commonjs';
import pkg from './package.json';

export default [
  // 对浏览器友好的umd构建
  {
    input: 'src/main.js',
    output: {
      name: 'howLongUntilLunch',
      file: pkg.browser, // 输出文件名
      format: 'umd'
    },
    plugins: [
      resolve(), // 支持 Rollup 找到外部模块
      commonjs() // 支持依赖中的 commonJS
    ]
  },

  // commonJS(用于Node)
  // ES module(用于bundlers)
  {
    input: 'src/main.js',
    // 指出模块为外部引入，将不会被打包到 bundle 中
    external: ['ms'],
    output: [
      { file: pkg.main, format: 'cjs' },
      { file: pkg.module, format: 'es' }
    ]
  }
];
```

:whale: 示例项目安装了外部依赖 `ms`，并引入到 `src/main.js` 文件中。

<span style="backGround: #efe0b9">package.json</span>

```json
"scripts": {
  "build": "rollup -c",
  "dev": "rollup -c -w"
}
```

<span style="color: #f7534f;font-weight:600">-c</span> 指定配置文件，默认是 <span style="color: slategray">rollup.config.js</span>；

<span style="color: #f7534f;font-weight:600">-w</span> 监听，在输入(包括依赖)改变时重新构建(bundle)。



## 示例二

<span style="backGround: #efe0b9">rollup.config.js</span>

```javascript
import resolve from '@rollup/plugin-node-resolve';
import commonjs from '@rollup/plugin-commonjs';
import { terser } from 'rollup-plugin-terser';

// 通过命令行的（-w/-watch）判断是否生产环境
const production = !process.env.ROLLUP_WATCH;

export default {
  input: 'src/main.js',
  output: {
    file: 'public/bundle.js',
    format: 'iife', // 供 <script> 调用的立即执行函数
    sourcemap: true // 生成sourcemap，使错误和日志能够指向原模块
  },
  plugins: [
    resolve(),
    commonjs(),
    production && terser() // 生产环境时，压缩
  ]
};
```

:whale: 示例项目安装了外部依赖 `date-fns/format`，并作为 `src/main.js` 的深层依赖。

<span style="backGround: #efe0b9">package.json</span>

```json
"scripts": {
  "build": "rollup -c",
  "watch": "rollup -c -w",
  "dev": "npm-run-all --parallel start watch", // 并行执行
  "start": "serve public"
}
```



## 生成bundle规律总结

- 编写源码（作为配置入口）使用 es 语法，编写配置使用 commonJs 语法，可以生成 bundle 



<span style="color: #3a84aa">使用 es 的语法编写源码和配置文件</span>

| 编译方式 | 导入语法       | 导出语法 |
| -------- | -------------- | -------- |
| cjs      | 无，内容被注入 | commonJS |
| es       | 无，内容被注入 | es       |

<span style="color: #3a84aa">使用 commonJS 的语法编写源码和配置文件</span>

| 编译方式 | 导入语法 | 导出语法 |
| -------- | -------- | -------- |
| cjs      | commonJS | commonJS |
| es       | commonJS | commonJS |

<span style="color: #3a84aa">使用 commonJS 的语法编写源码和配置文件 + @rollup/plugin-commonjs 处理</span>

| 编译方式 | 导入语法       | 导出语法 |
| -------- | -------------- | -------- |
| cjs      | 无，内容被注入 | commonJS |
| es       | 无，内容被注入 | es       |



## 附录

| 类型       | 说明                                                         |
| ---------- | ------------------------------------------------------------ |
| 文档       | [命令行标志](https://www.rollupjs.com/guide/command-line-reference#%E5%91%BD%E4%BB%A4%E8%A1%8C%E6%A0%87%E5%BF%97) |
| 文档       | [配置选项](https://www.rollupjs.com/guide/big-list-of-options) |
| 文档       | [插件列表](https://github.com/rollup/awesome)                |
| 文档       | [插件开发](https://rollupjs.org/plugin-development/#a-simple-example) |
| 未总结特性 | JavaScript API、代码分割                                     |

参考资料：

- [rollup.js中文文档](https://www.rollupjs.com/)

- [rollup-starter-lib](https://github.com/rollup/rollup-starter-lib)

- [rollup-starter-app](https://github.com/rollup/rollup-starter-app)

- [es6模块打包之rollup](https://blog.csdn.net/whl0071/article/details/128411677)



## 补充的话

如果这篇笔记能够帮助到你，请帮忙在 github 上点亮 `star`，这对我非常重要，感谢！

