## 概念

### 什么是webpack  

> webpack是一个打包模块化的工具。
>
> 在webpack里一切文件皆模块，通过loader转换文件，通过plugin注入钩子，最后输出由多个模块组合成的文件。  



### 概念  

#### 概念_入口  

> 指示 webpack 应该使用哪个模块，来作为构建其内部**依赖图**的开始。进入入口起点后，webpack 会找出有哪些模块和库是入口起点（直接和间接）依赖的。  

| 关键词      | 说明                   |
| :---------- | :--------------------- |
| entry       | 指定入口起点           |
| output      | 定义出口               |
| path        | node 核心模块          |
| \_\_dirname | 被执行js文件的绝对路径 |

:whale: 入口，如 vue 项目的 main.js，在处理好依赖关系后，最终可以通过 HtmlWebpackPlugin 插件引入到 html 文件中从而生效。

#### 概念_输出  

> 告诉 webpack 在哪里输出它所创建的 bundle，以及如何命名这些文件。  

```javascript
/* webpack.config.js */
const path = require('path')

module.exports = {
    entry: './src/main.js',
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: 'bundle.js'
    }
}
```

#### 概念_loader  

> webpack 自身只能理解 JavaScript 和 JSON 文件。loader 让 webpack 能够去处理其他类型（如css、png）的文件，并将它们**转换**为有效**模块**，以供应用程序使用，以及被添加到依赖图中。  

| 属性 | 说明                                    |
| :--- | :-------------------------------------- |
| test | 识别出哪些文件会被转换                  |
| use  | 定义出在进行转换时，应该使用哪个 loader |

```javascript
module.exports = {
  entry: './src/main.js',
  module: {
    rules: [{ test: /\.txt$/, use: 'raw-loader' }],
  },
};
```

> 解释：当碰到「在 require()/import 语句中被解析为 `'.txt'` 的路径」时，在打包之前，先使用 `raw-loader` 转换一下。

#### 概念_插件  

> 可以扩展 webpack 能力，如打包优化，资源管理，注入环境变量。  

| 步骤 | 说明                           |
| :--- | :----------------------------- |
| ①    | 通过 npm 安装                  |
| ②    | 通过 require 导出              |
| ③    | 添加到 plugins 数组            |
| ④    | 多数插件可以通过 option 自定义 |
| ⑤    | 复用插件时，new 插件实例       |

```javascript
const HtmlWebpackPlugin = require('html-webpack-plugin'); 
const webpack = require('webpack'); // 用于访问内置插件

module.exports = {
  module: {
    rules: [{ test: /\.txt$/, use: 'raw-loader' }],
  },
  plugins: [
      new HtmlWebpackPlugin({
          template: './src/index.html'
      })
  ],
};
```

#### 概念_模式  

设置 process.env.NODE_ENV 的值，可选 development, production 或 none。  

```javascript
module.exports = {
  mode: 'production',
};
```

#### 概念_浏览器兼容性  

指浏览器对 webpack 的支持。

| 属性                                            | 说明                                                         |
| :---------------------------------------------- | :----------------------------------------------------------- |
| 支持所有符合 ES5 标准 的浏览器                  | 不支持 IE8 及以下版本                                        |
| `import()` 和 `require.ensure()` 需要 `Promise` | 想支持旧浏览器，使用前，还需要提前加载 [polyfill](https://webpack.docschina.org/guides/shimming/) |

----



### 入口  

#### 入口_单入口语法  

```javascript
module.exports = {
  entry: {
    main: './path/to/my/entry/file.js',
  },
};
```

**简写**

```javascript
module.exports = {
  entry: './src/main.js',
};
```

**数组语法**

```javascript
module.exports = {
  entry: ['./src/file_1.js', './src/file_2.js'],
  output: {
    filename: 'bundle.js',
  },
};
```

:turtle: 可以将一个文件路径数组传递给 entry 属性，即<span style="color: #ff0000">在一个入口中</span>注入多个依赖文件，并将它们的依赖关系绘制在一个 `chunk` 中。  

#### 入口_对象语法  

> 这是应用程序中定义入口的最可扩展的方式，在其他配置中可以引用以进行更多配置。  

```javascript
module.exports = {
  // 配置多个入口
  entry: {
    app: './src/app.js',
    adminApp: './src/adminApp.js',
  },
};
```

| 配置对象 | 说明                  | 补充                               |
| :------- | :-------------------- | :--------------------------------- |
| import   | 需加载的模块          |                                    |
| dependOn | 前置入口，需先加载    | 不能循环引用                       |
| runtime  | 运行时 `chunk` 的名字 | 与dependOn冲突，同一入口不能同时用 |

#### 入口_常见场景  

##### 分离app/vender

> 即将代码分为应用程序和第三方库，并配置 2 个单独的入口点，
>
> 对于较少修改的文件（如jQuery、图片）可以存入到 `vendor.js` 中作为单独入口，使用内容哈希保证文件名不更改。这样浏览器可以独立缓存它们，减少加载时间。

webpack.config.js

```javascript
module.exports = {
  entry: {
    main: './src/app.js',
    vendor: './src/vendor.js',
  },
};
```

webpack.prod.js

```javascript
module.exports = {
  output: {
    filename: '[name].[contenthash].bundle.js',
  },
};
```

webpack.dev.js

```javascript
module.exports = {
  output: {
    filename: '[name].bundle.js',
  },
};
```

:whale: 在 webpack4 以后，不再推荐新建entry，而是推荐使用 `optimization.splitChunks` 来分离 app 和 vendor。

##### 多页面应用程序  

> 在多页面应用程序中，页面会重新加载HTML文档，并重新加载资源。
>
> 此时可以使用 [optimization.splitChunks](https://webpack.docschina.org/configuration/optimization/#optimizationsplitchunks) 为页面间共享的应用程序代码创建 bundle，复用多个入口起点之间的大量代码/模块。    

```javascript
module.exports = {
  entry: {
    pageOne: './src/pageOne/index.js',
    pageTwo: './src/pageTwo/index.js',
    pageThree: './src/pageThree/index.js',
  },
};
```

----



###  输出  

#### 输出_示例

> 将一个单独的 `bundle.js` 文件输出到 `dist` 目录中。  

```javascript
module.exports = {
  output: {
    filename: 'bundle.js',
  },
};
```

#### 输出_多个入口起点  

```javascript
module.exports = {
  entry: {
    app: './src/app.js',
    search: './src/search.js',
  },
  output: {
    filename: '[name].js',
    path: __dirname + '/dist',
  },
};

// 写入到硬盘：./dist/app.js, ./dist/search.js
```

:whale: 使用占位符来确保每个文件具有唯一的名称。



### loader  

> 用于对模块的源代码进行转换。可以在导出或加载模块时预处理模块。  

#### loader_示例  

```elm
npm install --save-dev css-loader ts-loader
```

```javascript
module.exports = {
  module: {
    rules: [
      { test: /\.css$/, use: 'css-loader' },
      { test: /\.ts$/, use: 'ts-loader' },
    ],
  },
};
```

#### loader_使用方式  

> 支持配置方式和内联方式，后者在 `import` 导入语句中指定 loader，不太推荐。  

配置方式

```javascript
module.exports = {
  module: {
    rules: [
      {
        test: /\.css$/,
        use: [
          { loader: 'style-loader' },
          {
            loader: 'css-loader',
            options: {
              modules: true
            }
          },
          { loader: 'sass-loader' }
        ]
      }
    ]
  }
};
```

#### loader_特性  

| 顺序 | 说明                                                  |
| :--- | :---------------------------------------------------- |
| ①    | 支持链式调用，从后往前执行，将结果传递给下一个 loader |
| ②    | 运行在 Node.js 中                                     |
| ③    | 可以通过 `options` 进行配置                           |



### plugin  

插件能够做到 loader 无法实现的其他事。  

#### plugin_定义  

- 插件是一个具有 apply 方法的对象。

- 该方法会被 webpack compiler 调用，并且在**整个**编译生命周期都可以访问 compiler 对象。

- 其中 compiler.hooks 的 tap 方法的首参为插件名称，建议采用驼峰命名保存为常量。  

<span style="backGround: #efe0b9">ConsoleLogOnBuildWebpackPlugin.js</span>

```javascript
const pluginName = 'ConsoleLogOnBuildWebpackPlugin';

class ConsoleLogOnBuildWebpackPlugin {
  apply(compiler) {
    compiler.hooks.run.tap(pluginName, (compilation) => {
      console.log('webpack 构建正在启动！');
    });
  }
}

module.exports = ConsoleLogOnBuildWebpackPlugin;
```

#### plugin_使用与配置

<span style="backGround: #efe0b9">webpack.config.js</span>

```javascript
const HtmlWebpackPlugin = require('html-webpack-plugin'); // 通过 npm 安装
const webpack = require('webpack'); // 访问内置的插件

module.exports = {
  plugins: [
    new webpack.ProgressPlugin(),
    new HtmlWebpackPlugin({ template: './src/index.html' }),
  ],
};
```

<span style="color: #ed5a65">ProgressPlugin</span> 用于自定义编译过程中的进度报告；

<span style="color: #ed5a65">HtmlWebpackPlugin</span> 将在打包目录下生成引用了出口文件(js)的 HTML 文件。  

#### Node API方式

<span style="backGround: #efe0b9">some-node-script.js</span>

```javascript
const webpack = require('webpack'); // 访问 webpack 运行时(runtime)
const configuration = require('./webpack.config.js');

let compiler = webpack(configuration);

// 使用插件处理
new webpack.ProgressPlugin().apply(compiler);

compiler.run(function (err, stats) {
  // ...
});
```



### 配置

#### 配置_基本配置  

<span style="backGround: #efe0b9">webpack.config.js</span>

```javascript
const path = require('path');

module.exports = {
  mode: 'development',
  entry: './foo.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'foo.bundle.js',
  },
};
```



### 模块  

> 在模块化编程中，开发者将程序分解为功能离散的模块，即 chunk。  
>
> 这使得验证、调试及测试变得轻而易举。   

#### 模块_模块示例  

| 所属          | 语句           |
| :------------ | :------------- |
| ES2015        | import         |
| CommomJS      | require()      |
| css/sass/less | @import        |
| stylesheet    | url(...)       |
| HTML          | <img src=...\> |



### 模块解析

> resolve 用于设置模块如何被解析，可以帮助 webpack 从每个 <span style="color: #a50">require/import</span> 语句中，找到需要引入的合适的模块代码。

#### 解析三种文件路径

绝对路径

```javascript
import 'C:\\Users\\me\\file';
```

相对路径

```react
import App from './vue/App.vue';
```

模块路径

```react
import { createApp } from 'vue';
```

说明

<span style="backGround: #efe0b9">webpack.config.js</span>

```react
resolve: {
  modules: ['node_modules'] // 默认值
}
```

:whale: 在 <span style="color: #a50">resolve.modules</span> 中指定的所有目录检索模块，默认会从<span style="color: #ff0000">node_modules</span>中查找文件；

:whale: 可以通过使用 <span style="color: #a50">resolve.alias</span> 配置别名的方式来替换初始模块路径；



#### 确定导入资源类型

<span style="color: #f7534f;font-weight:600">如果是文件</span>

- 如果文件具有扩展名，则直接打包文件；

- 否则，将使用 <span style="color: #a50">resolve.extensions</span> 选项作为文件扩展名解析； 

<span style="color: #f7534f;font-weight:600">如果是文件夹</span>

- 会在文件夹中根据 <span style="color: #a50">resolve.mainFiles</span> 配置选项中指定的文件顺序查找，默认文件名为<span style="color: #ff0000">index</span>； 

- 然后再根据 <span style="color: #a50">resolve.extensions</span> 来解析扩展名；

<span style="backGround: #efe0b9">webpack.config.js</span>

```javascript
module.exports = {
   // 默认值
  resolve: {
    // 配置模块搜索目录（先查看当前目录，再查看祖先目录）
    modules: ['node_modules'],
    mainFiles: ['index'],
    extensions: ['.js', '.json', '.wasm'],
  }
}
```



### 依赖图  

- 当文件依赖另一个文件时，webpack 会将文件视为直接存在依赖关系。这使得 webpack 可以获取非代码资源，如 images 或 web 字体等。并会把它们作为**依赖**提供给应用程序。  

- 根据入口递归构建**依赖关系图**，包含应用程序所需的所有模块，然后将其打包为通常只有一个的 `bundle`，由浏览器加载。  



### target  

由于 JavaScript 既可以编写服务端代码也可以编写浏览器代码，所以 webpack 提供了多种部署 target。 

#### target_用法

<span style="backGround: #efe0b9">webpack.config.js</span>

```javascript
module.exports = {
  target: 'node',
};
```

> webpack 将在类 Node.js 环境编译代码。

#### target_多target  

<span style="backGround: #efe0b9">webpack.config.js</span>

```javascript
const path = require('path');
const serverConfig = {
  target: 'node',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'lib.node.js',
  },
  //…
};

const clientConfig = {
  target: 'web', // <=== 默认为 'web'，可省略
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'lib.js',
  },
  //…
};

module.exports = [serverConfig, clientConfig];
```

> 将会在 `dist` 文件夹下创建 lib.js 和 lib.node.js 文件。  



### manifest   

> webpack 的 runtime 和 manifest，管理所有模块的交互。  

0. 在webpack 进行打包、压缩等处理后，原目录结构已经不复存在；

1. 当编译开始执行、解析和映射应用程序时，它会保留所有模块的详细要点。这个数据集合称为 `manifest`；

2. 当完成打包并发送到浏览器时，runtime 会通过 manifest 来解析和加载模块；

3. import 或 require 模块语句会被转换为 `__webpack_require__` 方法，指向标识符；

4. 通过使用 `manifest` 中的数据，runtime 将能够检索这些标识符，找出每个标识符背后对应的模块。

----



## 指南

### 起步  

#### 起步_普通项目  

> 即不使用 webpack 管理脚本，比如在头部引入了外部库，其后脚本的执行依赖其中的属性。    

| 索引 | 说明                                                     |
| :--- | :------------------------------------------------------- |
| ①    | 无法直接体现，脚本的执行依赖于外部库                     |
| ②    | 如果依赖不存在，或者引入顺序错误，应用程序将无法正常运行 |
| ③    | 如果依赖被引入但是并没有使用，浏览器将被迫下载无用代码   |

#### 起步_使用webpack  

> 将引入外部库改为安装依赖后通过模块导入。  

| 文件路径        | 文件类型 | 说明                                                   |
| :-------------- | :------- | :----------------------------------------------------- |
| src/index.js    | 入口起点 | 默认路径。需要引入第三方库后再使用。项目中是 `main.js` |
| dist/main.js    | 输出     | 默认路径。打包生成的文件                               |
| dist/index.html | 页面     | 需要手动创建，引入输出                                 |

+ 项目文件
  - dist
    + index.html  

```html
<body>
  <script src="main.js"></script>
</body>
```

#### 起步_添加配置文件  

+ 项目文件
  - webpack.config.js  

```javascript
const path = require('path');

module.exports = {
  entry: './src/index.js',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist'),
  },
};
```



### 管理资源  

> 可以通过 loader 或内置的 [Asset模块](https://webpack.docschina.org/guides/asset-modules/) 引入其它类型的文件。  
>
> 根据依赖图将资源动态打包，避免打包未使用的模块。   

使用 Asset Modules 可以接收并加载任何文件，然后将其输出到构建目录。

| 操作         | 需要                                                         |
| :----------- | :----------------------------------------------------------- |
| 加载CSS      | [安装loader](https://webpack.docschina.org/guides/asset-management/) |
| 加载图像     | [Asset Modules](https://www.webpackjs.com/guides/asset-management/#loading-images) |
| 加载字体文件 | Asset Modules                                                |
| 加载JSON     | /                                                            |
| 加载XML      | 安装loader                                                   |



### 管理输出  

#### 管理输出_正常输出    

输出文件会根据入口文件的修改而修改， 需要手动在 `index.html` 中修改引用。

#### 管理输出_自动引入 

> 通过插件，可以自动在打包目录下生成引入了所有打包文件（js）的 `index.html`。  

```javascript
// 引入自动生成 html 的插件
const HtmlWebpackPlugin = require('html-webpack-plugin')

module.exports = {
  plugins: [
    new HtmlWebpackPlugin({
      title: 'Development',
    }),
  ]
};
```

#### 管理输出_清理dist 

> 打包生成的文件会输出到 `dist/`，默认会保留之前生成的文件，可以不保留。

```javascript
const path = require('path');

module.exports = {
  output: {
    filename: '[name].bundle.js',
    path: path.resolve(__dirname, 'dist'),
    // 构建前清理打包文件夹
    clean: true,
  },
};
```



### 开发环境  

#### 开发环境_配置

```javascript
module.exports = {
  mode: 'development',
};
```

#### 开发环境_追踪错误

源代码经打包处理后会被合并丑化，原目录已不复存在，难以追踪错误信息来自哪个文件；

可以开启 source map 将编译后的代码映射回源代码，以获得具体的报错信息。

```javascript
 module.exports = {
   mode: 'development',
   // 不要用于生产环境
   devtool: 'inline-source-map',
 };
```

#### 开发环境_开发工具  

通常使用 webpack-dev-server，它会为 `output.path` 中定义的目录中的 bundle 文件提供服务，并保存到内存中；

修改源文件时，webserver 将在编译代码后自动重新加载。

```javascript
module.exports = {
  devServer: {
    static: './dist',
  },
};
```

> 表示将 `dist` 下的资源作为作为 server 的目标，作用到 `localhost:8080`。  



### 代码分离  

将代码分离到不同的 bundle 中，然后按需加载/并行加载这些文件。合理使用能较少加载时间。  

方法可以分为三种：入口起点、防止重复、动态导入。  

#### 代码分离_入口起点  

> 即通过 `entry` 配置多个入口，注意不是用数组形式在一个入口导入多个依赖文件。  

```javascript
const path = require('path');

 module.exports = {
  mode: 'development',
  entry: {
    index: './src/index.js',
    another: './src/another-module.js',
  },
   output: {
    filename: '[name].bundle.js',
    path: path.resolve(__dirname, 'dist'),
  },
};
```

:turtle: 如果入口 chunk 之间包含相同的模块，这些模块会被<span style="color: #ff0000">重复地</span>引入到不同的 bundle 中;

:turtle: 不能动态地将核心应用程序逻辑中的代码拆分出来。

#### 代码分离\_防止重复

##### 入口依赖  

通过配置 `dependOn` 选项，能在多个 chunk 间共享模块。  

```javascript
 module.exports = {
  entry: {
    index: {
      import: './src/index.js',
      dependOn: 'shared',
    },
    another: {
      import: './src/another-module.js',
      dependOn: 'shared',
    },
    shared: 'lodash',
  },
  optimization: {
    runtimeChunk: 'single',
  },
};
```

:turtle: 如果要在一个 HTML 页面上使用多个入口，还需要设置 `optimization.runtimeChunk: 'single'`，不然会有麻烦。  

**避免使用多入口的入口**

> 避免使用多入口的入口，这样在使用 `async` 脚本标签时，会有更好的优化。  

```javascript
// 示例
module.exports = {
  entry: {
    page: ['./analytics', './app'],
};
```



##### SplitChunksPlugin  

> 使用该插件[可以](https://webpack.docschina.org/guides/code-splitting/#splitchunksplugin)将公共的依赖模块提取到已有的入口chunk/新生成的chunk中。  

```javascript
module.exports = {
  mode: 'development',
  entry: {
    index: './src/index.js',
    another: './src/another-module.js',
  },
  optimization: {
    splitChunks: {
      chunks: 'all',
    },
  },
};
```

#### 代码分离_动态导入  

> `import()` 本身依赖于 promises，返回也是期约；导入模块会被分离到一个单独的 bundle。

可以写成 promise 或 aync/await，无需在顶部导入。

```javascript
function getComponent() {
  return import('lodash')
    .then(({ default: _ }) => {
      console.log(_);
  })
}
```

  ```javascript
async function getComponent() {
  const { default: _ } = await import('lodash')
  const result = _.join(['Hello', 'webpack'], ' ');
}
  ```



#### 预获取/预加载模块  

> 使用 `import()` 时，加上特定[内置指令](https://www.webpackjs.com/guides/code-splitting/#prefetchingpreloading-modules)，即可将资源设置为预获取或预加载。  
>
> 当页面需要用到体积很大的模块，如图表库时，就可以采用预加载的方案。页面模块很快加载好并显示进度条，待图表库请求好后消失。  

| 指令       | prefetch           | preload                    |
| :--------- | :----------------- | :------------------------- |
| 说明       | 预获取             | 预加载                     |
| 在父chunk  | 加载结束后开始加载 | 加载时，以并行方式开始加载 |
| **优先级** | 浏览器闲置时下载   | 立即下载                   |

#### bundle分析  

可以借助[各种工具](https://www.webpackjs.com/guides/code-splitting/#bundle-analysis)对打包结果进行分析。



### 缓存  

> 通过必要的配置，以确保 webpack 编译生成的文件能够被客户端缓存，而在文件内容变化后，能够请求到新的文件。  

| 步骤 | 操作           | 说明                                 |
| :--- | :------------- | :----------------------------------- |
| ①    | 设置出口文件名 | 仅资源变化，文件名变化               |
| ②    | 提取引导模板   | 抽离变化部分                         |
| ③    | 提取第三方库   | 利于长效缓存                         |
| ④    | 模块标识符算法 | 保证其它代码改变时，三方库文件名不变 |

#### 缓存_输出文件名   

> `[contenthash]` 会根据资源内容创建出唯一 hash，内容不变则值不变。  

```javascript
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: './src/index.js',
  plugins: [
    new HtmlWebpackPlugin({
      title: 'Caching',
    }),
  ],
  output: {
    filename: '[name].[contenthash].js',
    path: path.resolve(__dirname, 'dist'),
    clean: true,
  },
};
```

> 但此时每次的打包结果文件名都会不一样，因为入口模块中，包含了引导模板(runtime)。  

#### 缓存_提取引导模板  

> `optimization.runtimeChunk` 选项能够将 runtime 代码拆分为一个单独的 chunk；
>
> 设置为 `single`，表示为所有 chunk 创建一个 runtime bundle。

```javascript
module.exports = {
  // ..其它配置
  optimization: {
    runtimeChunk: 'single',
  },
};
```

#### 缓存_将三方库单独提取  

> 对于第三方库（如loadsh、react），由于其很少修改，可以将其提取到 `vender` 的模块中，利于长效缓存。  

```javascript
module.exports = {
  ...
  optimization: {
    runtimeChunk: 'single',
    splitChunks: {
      cacheGroups: {
        vendor: {
          test: /[\\/]node_modules[\\/]/,
          name: 'vendors',
          chunks: 'all',
        },
      },
    },
  },
};
```

:octopus: 此时修改代码，vendors 的包名仍会发生变化，这与模块标识符有关。

#### 缓存_模块标识符  

> 上述步骤后，若修改代码文件，`vender` 由于随自身的 `module.id` 变化，名称也会变化。  
>
> 可以设置 `optimization.moduleIds: 'deterministic'` 解决问题。  

```javascript
module.exports = {
  optimization: {
    moduleIds: 'deterministic',
    runtimeChunk: 'single',
    splitChunks: {
      cacheGroups: {
        vendor: {
          test: /[\\/]node_modules[\\/]/,
          name: 'vendors',
          chunks: 'all',
        },
      },
    },
  },
};
```



### 创建library  

> 除了打包应用程序，webpack 还能打包 JavaScript library。

| 步骤 | 操作             | 说明                                                         |
| :--- | :--------------- | :----------------------------------------------------------- |
| ①    | 创建示例library  | 在入口文件导入了 `lodash`，导出两个方法                      |
| ②    | Webpack配置      | 更改了打包文件的名称                                         |
| ③    | 暴露库           | 通过设置 `output.library` 暴露导出内容，此时只能被 script 标签引用 |
| ④    | 兼容更多环境     | 通过设置 `output.library.type:'umd'` 使其可以在 CommonJS、AMD 以及 script 标签中使用 |
| ⑤    | 外部化 `lodash`  | 通过设置 `externals`，意味对使用者来说，该库依赖 `lodash`    |
| ⑥    | 添加文件路径规范 | 将bandle 的文件路径添加到 `package.json` 的 `main` 字段中    |
| ⑦    | 发布到 npm       | /                                                            |



### 环境变量  

适当设置环境变量可以消除配置文件在开发环境和生产环境间的差异；

在 webpack 命令行中的 `--env`，可以传入环境变量，在配置文件中能访问到；  

```elm
npx webpack --env goal=local --env production --progress
```

:whale: 如果设置 `env` 变量，却没有赋值，`--env production` 默认表示将 `env.production` 设置为 `true`。



<span style="backGround: #efe0b9">webpack.config.js</span>

```javascript
const path = require('path');

module.exports = (env) => {
  console.log('Goal: ', env.goal); // 'local'
  console.log('Production: ', env.production); // true

  return {
    entry: './src/index.js',
    output: {
      filename: 'bundle.js',
      path: path.resolve(__dirname, 'dist'),
    },
  };
};
```

:star2: 要想访问 `env` 变量，需将导出模块转换为函数。

#### 环境变量_[node环境](https://webpack.docschina.org/api/cli/#node-env)

可以使用 `--node-env` 选项来设置 `process.env.NODE_ENV` : 

```elm
npx webpack --node-env production   # process.env.NODE_ENV = 'production'
```

:ghost: 如果配置文件中没有明确 `mode` 选项的值，那么 `mode` 也会被这个设置覆盖；

:whale: 即使在 webpack.config.js 指定了 mode，在这个文件中 process.env.NODE_ENV 仍未被赋值。




### 构建性能  

#### 构建性能_通用环境  

> 包含了开发环境和生产环境。   

| 索引 | 操作                                     | 说明                                                         |
| :--- | :--------------------------------------- | :----------------------------------------------------------- |
| ①    | 更新到最新版本                           | 包含 npm、webpack、node.js，新版本在性能方面一般更好         |
| ②    | [loader](#构建性能_通用环境_loader)      | 将 loader 应用于最少数量的必要模块                           |
| ③    | 减少 loader/plugin                       | 均有启动时间                                                 |
| ④    | 解析                                     | 与 resolve 相关，[具体](https://www.webpackjs.com/guides/build-performance/#resolving) |
| ⑤    | 保持 chunk 体积小                        | 使用更少、体积更小的库、                                     |
| ⑤    | 保持 chunk 体积小                        | 在多页面应用程序中使用 SplitChunksPlugin ，并开启 async 模式 |
| ⑥    | 将非常消耗资源的loader分流到 worker pool | 谨慎使用，启动和通讯消耗资源                                 |

##### loader 

> 可以通过使用 `include` 字段，将 loader 仅作用于需要的地方。  

```javascript
const path = require('path');

module.exports = {
  //...
  module: {
    rules: [
      {
        test: /\.js$/,
        include: path.resolve(__dirname, 'src'),
        loader: 'babel-loader',
      },
    ],
  },
};
```

#### 构建性能_开发环境    

| 索引 | 操作                     | 说明                                                     |
| :--- | :----------------------- | :------------------------------------------------------- |
| ①    | 在内存中编译             | 如 `webpack-dev-server`                                  |
| ②    | Devtool                  | 不同的 Devtool 配置，会导致性能差异                      |
| ③    | 排除仅生产环境用到的工具 | 如压缩、hash命名                                         |
| ④    | 剥离 runtimeChunk        | `optimization.runtimeChunk: true`                        |
| ⑤    | 输出结果不携带路径信息   | `output.pathinfo: false`，降低对大项目的垃圾回收性能压力 |

:ghost: 在大多数情况下，最佳选择是 `eval-cheap-module-source-map`。

##### 合适的优化配置

```javascript
module.exports = {
  // ...
  optimization: {
    removeAvailableModules: false,
    removeEmptyChunks: false,
    splitChunks: false,
  },
};
```

:turtle: 这些优化适用于小型代码库，但是在大型代码库中却非常耗费性能。

#### 构建性能_生产环境

在大多数情况下，优化代码质量比构建性能更重要；

source map 相当消耗资源，生产环境可以不使用。

#### 构建性能_工具相关

##### TypeScript

| 索引 | 说明                                                         |
| :--- | :----------------------------------------------------------- |
| ①    | 在单独的进程中使用 `fork-ts-checker-webpack-plugin` 进行类型检查 |
| ②    | 配置 loader 跳过类型检查                                     |
| ③    | 使用 `ts-loader` 时，设置 `happyPackMode: true` / `transpileOnly: true` |



### 依赖管理  

#### require.context  

> 可以创建一个导入上下文，其中包括满足条件的所有文件  

| 参数 | 说明                 |
| :--- | :------------------- |
| ①    | 要搜索的目录         |
| ②    | 是否还搜索其子目录   |
| ③    | 匹配文件的正则表达式 |

```javascript
require.context('../', true, /\.stories\.js$/);
// （创建出）一个 context，其中所有文件都来自父文件夹及其所有子级文件夹，request 以 `.stories.js` 结尾。
```

> 上下文有一个 keys 属性，是一个包含导入文件的数组，可以将其保存到一个对象中。    

```javascript
const cache = {};

function importAll(r) {
  r.keys().forEach((key) => (cache[key] = r(key)));
}

importAll(require.context('../components/', true, /\.js$/));
// 在构建时(build-time)，所有被 require 的模块都会被填充到 cache 对象中。
```



### 生产环境  

- 开发环境，需要强大的 source map 和有着实时重新加载/热模块替换能力的本地服务器；  

- 生产环境，注重压缩 bundle、更轻量的 source map、资源优化等。  

#### 生产环境_分别配置  

> 由于两个环境的构建目标不同，往往将它们不同的部分拆分，并保留一份通用配置。   

- 项目   
  + webpack.common.js  
  + webpack.dev.js  
  + webpack.prod.js  

<span style="backGround: #efe0b9">webpack.common.js</span>

```javascript
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: {
    app: './src/index.js',
  },
  plugins: [
    new HtmlWebpackPlugin({
      title: 'Production',
    }),
  ],
  output: {
    filename: '[name].bundle.js',
    path: path.resolve(__dirname, 'dist'),
    clean: true,
  }, 
};
```

<span style="backGround: #efe0b9">webpack.dev.js</span>

```javascript
 const { merge } = require('webpack-merge');
 const common = require('./webpack.common.js');

 module.exports = merge(common, {
   mode: 'development',
   // 拥有更强大的调试源码功能
   devtool: 'inline-source-map',
   devServer: {
     static: './dist',
   },
 });
```

<span style="backGround: #efe0b9">webpack.prod.js</span>

```javascript
 const { merge } = require('webpack-merge');
 const common = require('./webpack.common.js');

 module.exports = merge(common, {
   mode: 'production',
   // 避免使用 inline- 及 eval- 值，降低性能  
   // devtool: 'source-map',
 });
```

:ghost: 生产模式[推荐](https://www.webpackjs.com/configuration/devtool/#production)不配置 devtool，或配置为 `source-map` 并且不将映射文件暴露。

#### 生产环境_配置说明  

> 对于开发模式，可以使用 style-loader 将 CSS 插入到 DOM。
>
> 对于生产模式，使用 `mini-css-extract-plugin` 以压缩代码，其与 style-loader 冲突。  

| 操作              | 名称               | 配置方式 | 说明                                                         |
| :---------------- | :----------------- | :------- | :----------------------------------------------------------- |
| 剔除死代码        | TerserPlugin       | 默认使用 | 利于压缩，可选择其它压缩方式。与 tree shaking 相关           |
| 压缩CSS           | CssMinimizerPlugin | 手动配置 | [跳转](https://webpack.docschina.org/plugins/mini-css-extract-plugin/#minimizing-for-production) |
| 提取CSS到一个文件 | CssMinimizerPlugin | 手动配置 | [跳转](https://webpack.docschina.org/plugins/mini-css-extract-plugin/#extracting-all-css-in-a-single-file) |
| 长期缓存          | CssMinimizerPlugin | 手动配置 | [跳转](https://webpack.docschina.org/plugins/mini-css-extract-plugin/#long-term-caching) |

#### 生产环境_脚本设置  

<span style="backGround: #efe0b9">package.json</span>

```json
{
  "scripts": {
    "serve": "webpack serve --open --config webpack.dev.js",
    "build": "webpack --config webpack.prod.js"
  },
}
```



## 其他

### 常见的loader  

| loader            | 说明                                                         | webpack4 |
| :---------------- | :----------------------------------------------------------- | :------: |
| raw-loader        | 导出资源的源代码                                             |    √     |
| file-loader       | 把文件输出到一个文件夹中，在代码中通过相对 URL 去引用输出的文件 |    √     |
| url-loader        | 和 file-loader 类似，但是能在文件很小的情况下以 base64 的方式把文件内容注入到代码中去 |    √     |
| image-loader      | 加载并且压缩图片文件                                         |          |
| babel-loader      | 把 ES6 转换成 ES5                                            |          |
| postcss-loader    | 可以自动补全浏览器前缀、[将px转换为rem](http://www.baidu.com/link?url=fkrwinKCUrxqE6O8rM_MQBsCRdJ3Dq82liD5HHEXbgDwJ_OLFD4NVFFQBNStwQI8BSQNaQXtNZxVvLVXu_fy-6m5dFDXxlT8J4-pYABjYwm) |          |
| less-loader       | 将 Less 编译为 CSS                                           |          |
| sass-loader       | 将 Sass 编译为 CSS                                           |          |
| css-loader        | 识别导入的 CSS 模块，将其转换后导出                          |          |
| style-loader      | 将模块导出的内容作为样式并添加到 DOM 中                      |          |
| vue-loader        | 允许以单文件组件的格式编写 Vue 组件                          |          |
| eslint-loader     | 通过 ESLint 检查 JavaScript 代码                             |          |
| source-map-loader | 加载额外的 Source Map 文件，以方便断点调试                   |          |

> 在 webpack 5 中，使用[资源模块](https://webpack.docschina.org/guides/asset-modules/)类型，允许使用资源文件（字体，图标等）而无需配置额外 loader


### 常见的plugin

define-plugin：定义环境变量

terser-webpack-plugin：通过TerserPlugin压缩ES6代码

html-webpack-plugin：会在 `dist` 文件夹下创建文件 `index.html`，其中引入了所有的输出文件（bundle.js）

mini-css-extract-plugin：可以分离css文件、压缩等  

clean-webpack-plugin：删除打包文件

happypack：实现多线程加速编译











