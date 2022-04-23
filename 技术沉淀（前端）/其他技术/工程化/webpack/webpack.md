## 概念

### 什么是webpack  

webpack是一个打包模块化的工具，在webpack里一切文件皆模块，通过loader转换文件，通过plugin注入钩子，最后输出由多个模块组合成的文件。  

WebPack可以看做是模块打包机：分析项目的结构，找到JavaScript模块以及其它的一些浏览器不能直接运行的拓展语言（Scss，TypeScript等），
并将其打包为合适的格式以供浏览器使用。



### 概念  

#### 概念_入口  
> 指示 webpack 应该使用哪个模块，来作为构建其内部**依赖图**的开始。进入入口起点后，webpack 会找出有哪些模块和库是入口起点（直接和间接）依赖的。  

关键词 | 说明
:- | :-
entry | 指定入口起点
output | 定义出口
path | node 核心模块  
\_\_dirname | 被执行js文件的绝对路径

#### 概念_输出  
> 告诉 webpack 在哪里输出它所创建的 bundle，以及如何命名这些文件。  

```
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
> webpack 自身只能理解 JavaScript 和 JSON 文件。loader 让 webpack 能够去处理其他类型的文件，并将它们**转换**为有效**模块**，以供应用程序使用，以及被添加到依赖图中。  

属性 | 说明
:- | :-
test | 识别出哪些文件会被转换
use | 定义出在进行转换时，应该使用哪个 loader

```
module.exports = {
  entry: './src/main.js',
  module: {
    rules: [{ test: /\.txt$/, use: 'raw-loader' }],
  },
};
```
> 对 module 对象定义了 rules 属性，里面包含两个必须属性：test 和 use
> 
> 当碰到「在 require()/import 语句中被解析为 `'.txt'` 的路径」时，在打包之前，先使用 `raw-loader` 转换一下。
> 
> 使用正则表达式匹配文件时，不要添加引号，表示匹配任何以 `.txt` 结尾的文件。  

#### 概念_插件  
> 可以扩展 webpack 能力，如打包优化，资源管理，注入环境变量。  

步骤 | 说明
:- | :-
① | 通过 npm 安装
② | 通过 require 导出
③ | 添加到 plugins 数组  
④ | 多数插件可以通过 option 自定义  
⑤ | 复用插件时，new 插件实例  

```
const HtmlWebpackPlugin = require('html-webpack-plugin'); 
const webpack = require('webpack'); // 用于访问内置插件

module.exports = {
  module: {
    rules: [{ test: /\.txt$/, use: 'raw-loader' }],
  },
  plugins: [new HtmlWebpackPlugin({ template: './src/index.html' })],
};
```

#### 概念_模式  
> 设置 process.env.NODE_ENV 的值，可选 development, production 或 none。  

```
module.exports = {
  mode: 'production',
};
```

#### 概念_浏览器兼容性  

属性 | 说明
:- | :-
支持所有符合 ES5 标准 的浏览器 | 不支持 IE8 及以下版本
`import()` 和 `require.ensure()` 需要 `Promise` | 想支持旧浏览器，使用前，还需要提前加载 [polyfill](https://webpack.docschina.org/guides/shimming/)

----



### 入口  

#### 入口_单入口语法  

```
module.exports = {
  entry: './src/main.js',
};
```

> 单入口语法  
```
module.exports = {
  entry: {
    main: './path/to/my/entry/file.js',
  },
};
```

> 可以将一个文件路径数组传递给 entry 属性。可以一次注入多个依赖文件，并且将它们的依赖关系绘制在一个 `chunk` 中。  
> 
> 可以通过一个入口（例如一个库）为应用程序快速设置 webpack 配置，但扩展或调整配置的灵活性不大。  
```
module.exports = {
  entry: ['./src/file_1.js', './src/file_2.js'],
  output: {
    filename: 'bundle.js',
  },
};
```

#### 入口_对象语法  

> 这是应用程序中定义入口的最可扩展的方式。  
```
module.exports = {
  entry: {
    app: './src/app.js',
    adminApp: './src/adminApp.js',
  },
};
```

配置对象 | 说明 | 补充
:- | :- | :-
import | 需加载的模块 | 
dependOn | 前置入口，需先加载 | 不能循环引用
runtime | 运行时 `chunk` 的名字 | 与dependOn冲突，同一入口不能同时用

#### 入口_常见场景  

#### 分离应用程序和第三方库入口
> 指 app 和 vendor。  
> 
> 即配置两个单独的入口点。在 `vendor.js` 中存入很少修改的文件（如jQuery、图片），`contenthash` 保持不变，能让浏览器独立缓存，减少加载时间。  

webpack.config.js
```
module.exports = {
  entry: {
    main: './src/app.js',
    vendor: './src/vendor.js',
  },
};
```

webpack.prod.js
```
module.exports = {
  output: {
    filename: '[name].[contenthash].bundle.js',
  },
};
```

webpack.dev.js
```
module.exports = {
  output: {
    filename: '[name].bundle.js',
  },
};
```

#### 多页面应用程序  
> 在多页面应用程序中，服务器会取新的文档，页面根据文档重新加载，资源重新加载。
> 
> 此时可以使用 [optimization.splitChunks](https://webpack.docschina.org/configuration/optimization/#optimizationsplitchunks) 为页面间共享的应用程序代码创建 bundle等。复用多个入口起点之间的大量代码/模块。    

```
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
> 不同于入口，输出只能指定一个。  

#### 输出_示例
> 将一个单独的 `bundle.js` 文件输出到 `dist` 目录中。  
```
module.exports = {
  output: {
    filename: 'bundle.js',
  },
};
```

#### 输出_多个入口起点  
```
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
> 使用占位符来确保每个文件具有唯一的名称。



### loader  
> 用于对模块的源代码进行转换。可以在导出或加载模块时预处理模块。  

#### loader_示例  
```
npm install --save-dev css-loader ts-loader
```

```
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

```
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

顺序 | 说明
:- | :-
① | 支持链式调用，从后往前执行，将结果传递给下一个 loader
② | 运行在 Node.js 中
③ | 可以通过 `options` 进行配置 



### plugin  
> 插件能做到 loader 无法实现的事情，拓展能力。  

#### plugin_剖析  

> 插件是一个具有 apply 方法的对象。
> 
> 该方法会被 webpack compiler 调用，并且在**整个**编译生命周期都可以访问 compiler 对象。
> 
> 其中 compiler.hooks 的 tap 方法的首参为插件名称，建议用驼峰大小写保存为常量。  

ConsoleLogOnBuildWebpackPlugin.js
```
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

#### plugin_用法_配置方式  

webpack.config.js
```
const HtmlWebpackPlugin = require('html-webpack-plugin'); // 通过 npm 安装
const webpack = require('webpack'); // 访问内置的插件

module.exports = {
  plugins: [
    new webpack.ProgressPlugin(),
    new HtmlWebpackPlugin({ template: './src/index.html' }),
  ],
};
```
> ProgressPlugin 用于自定义编译过程中的进度报告。
> 
> HtmlWebpackPlugin 将生成一个 HTML 文件，并在其中使用 `script` 引入出口文件（js）  



### 配置

#### 配置_基本配置  

webpack.config.js
```
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

#### 模块_webpack模块  

所属 | 语句
:- | :-
ES2015 | import
CommomJS | require()
css/sass/less | @import
stylesheet | url(...)
HTML | <img src=...\> 

#### 依赖图  
> 当文件依赖另一个文件时，webpack 会将文件视为直接存在依赖关系。这使得 webpack 可以获取非代码资源，如 images 或 web 字体等。并会把它们作为**依赖**提供给应用程序。  
> 
> 根据入口递归构建**依赖关系图**，包含应用程序所需的所有模块，然后将其打包为通常只有一个的 `bundle`，由浏览器加载。  

#### target  
> 由于 JavaScript 既可以编写服务端代码也可以编写浏览器代码，所以 webpack 提供了多种部署。 
> 
> 使用相应值，webpack 将在类似环境编译代码。  

#### 多target  

webpack.config.js
```
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



### 模块解析！！待填坑

### manifest   
> webpack 的 runtime 和 manifest，管理所有模块的交互。  

1. 当编译开始执行、解析和映射应用程序时，它会保留所有模块的详细要点。这个数据集合称为 `manifest`。  

2. 当完成打包并发送到浏览器时，runtime 会通过 manifest 来解析和加载模块。  

3. import 或 require 模块语句会被转换为 `__webpack_require__` 方法，指向标识符。

4. 通过使用 `manifest` 中的数据，runtime 将能够检索这些标识符，找出每个标识符背后对应的模块。

----



## 指南

### 起步  

#### 起步_普通项目  
> 即不使用 webpack 管理脚本，比如在头部引入了外部库，其后脚本的执行依赖其中的属性。    

索引 | 说明
:- | :-
① | 无法直接体现，脚本的执行依赖于外部库
② | 如果依赖不存在，或者引入顺序错误，应用程序将无法正常运行
③ | 如果依赖被引入但是并没有使用，浏览器将被迫下载无用代码

#### 起步_使用webpack  
> 将引入外部库改为安装依赖后通过模块导入。  
>
> webpack 原生支持 `import`、`export` 操作模块。  

文件路径 | 文件类型 | 说明  
:- | :- | :-
src/index.js | 入口起点 | 默认路径。需要引入第三方库后再使用。项目中是 `main.js`？
dist/main.js | 输出 | 默认路径。打包生成的文件
dist/index.html | 页面 | 需要手动创建，引入输出

+ 项目文件
  - dist
    + index.html  

```
<body>
  <script src="main.js"></script>
</body>
```

#### 起步_添加配置文件  

+ 项目文件
  - webpack.config.js  

```
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

操作 | 需要  
:- | :-  
加载CSS | [安装loader](https://webpack.docschina.org/guides/asset-management/)
加载图像 | Asset Modules
加载字体文件 | Asset Modules
加载JSON | /
加载XML | 安装loader



### 管理输出  

#### 管理输出_正常输出   
> 当输出多个文件，或更改入口起点名称/新增入口时，需要将 `index.html` 中的引用进行增加或修改，不太方便。  

#### 管理输出_HtmlWebpackPlugin  
> 通过该插件，可以自动在 `dist/` 下生成一个引入了所有打包文件（js）的 `index.html`。  

```
const path = require('path');

module.exports = {
  plugins: [
    new HtmlWebpackPlugin({
      title: 'Development',
    }),
  ]
};
```

#### 管理输出_清理dist文件夹  
> 打包生成的文件会输出到 `dist/`，但在该文件夹下之前的一些文件并不会删除，可以使用 `output.clean` 在每次构建前清理该文件夹。  

```
const path = require('path');

module.exports = {
  output: {
    filename: '[name].bundle.js',
    path: path.resolve(__dirname, 'dist'),
    clean: true,
  },
};
```



### 开发环境  

#### 开发环境_准备  

```
module.exports = {
  mode: 'development',
};
```

#### [开发环境_追踪错误](https://webpack.docschina.org/guides/development/#using-source-maps)  
> 在打包源码时，若将多个源文件打包到一个 `bundle.js` 中，会难以追踪到错误的具体信息。
> 
> 可以开启 source map 将编译后的代码映射到源代码，以在控制台获得具体的报错信息。记得不要用于生产环境。  

#### 开发环境_开发工具  
> 通常使用的是 webpack-dev-server，它会用 `output.path` 这个目录为服务器提供 bundle 文件，并保存在内存中。  
> 
> 若更改任何源文件并保存它们，web server 将在编译代码后自动重新加载。  

```
module.exports = {
  devServer: {
    static: './dist',
  },
};
```
> 表示将 `dist` 下的资源作为 server 的可访问属性，到 `localhost:8080`。  



### 代码分离  

> 将代码分离到不同的 bundle 中，然后按需加载或并行加载这些文件。合理使用能极大影响加载时间。  
>
> 方法可以分为三种：入口起点、防止重复、动态导入。  

#### 代码分离_入口起点  
> 即通过 `entry` 配置多个入口，注意不是用数组形式在一个入口导入多个依赖文件。  

```
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
> 如果入口 chunk 之间包含相同的模块，其会被重复引入到各个 bundle 中。   

#### 代码分离_防止重复_入口依赖  
> 配置入口的 `dependOn`，能在多个 chunk 间共享模块。  
>  
> 若要在一个 HTML 页面使用多个入口，还需要设置 `optimization.runtimeChunk: 'single'`。  

```
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
> 避免使用多依赖的入口，这样在使用 `async` 脚本标签时，会有更好的优化。  

#### 代码分离_防止重复_SplitChunksPlugin  
> 使用该插件[可以](https://webpack.docschina.org/guides/code-splitting/#splitchunksplugin)将公共的依赖模块提取到已有的入口chunk/新生成的chunk中。  

```
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
> `import()` 调用会在内部用到 promises，返回也是期约。被它动态导入的模块会被分离为一个 chunk。  
> 
> 在代码中用到对应模块前导入，然后用期约或异步函数写逻辑[即可](https://webpack.docschina.org/guides/code-splitting/#dynamic-imports)，不需在顶部导入。  

#### 预获取/预加载模块  
> 使用 `import()` 时，加上特定内置指令，即可将资源设置为预获取或预加载。  
> 
> 当页面需要用到体积很大的模块，如图表库时，就可以采用预加载的方案。页面模块很快加载好并显示进度条，待图表库请求好后消失。  

指令 | prefetch | preload 
:- | :- | :- 
说明 | 预获取 | 预加载  
在父chunk | 加载结束后开始加载 | 加载时，以并行方式开始加载
**优先级** | 浏览器闲置时下载 | 立即下载  

#### bundle分析  
> 打包完成后，`asset` 字段示意打包资源及大小。也可以通过[各自工具](https://webpack.docschina.org/guides/code-splitting/#bundle-analysis)查看模块占用空间等。  



### 缓存  

> 通过必要的配置，以确保 webpack 编译生成的文件能够被客户端缓存，而在文件内容变化后，能够请求到新的文件。  

步骤 | 操作 | 说明
:- | :- | :-
① | 设置出口文件名 | 仅资源变化，文件名变化
② | 提取引导模板 | 抽离变化部分
③ | 提取第三方库 | 利于长效缓存  
④ | 模块标识符算法 | 保证其它代码改变时，三方库文件名不变  

#### 缓存_输出文件名   
> `contenthash` 会根据资源内容创建出唯一 hash，内容不变则值不变。  

```
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
> 但此时每次的打包结果文件名都会不一样，因为入口模块中，包含了引导模板。  

#### 缓存_提取引导模板  
> 将所有 chunk 中的 runtime 代码拆分为一个单独的 chunk。  

```
module.exports = {
  ...
  optimization: {
    runtimeChunk: 'single',
  },
};
```

#### 缓存_将三方库单独提取  
> 对于第三方库（如loadsh、react），由于其很少修改，可以将其提取到 `vender` 的模块中，利于长效缓存。  

```
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

#### 缓存_模块标识符  
> 上述步骤后，若修改代码文件，`vender` 由于随自身的 `module.id` 变化，名称也会变化。  
> 
> 可以设置 `optimization.moduleIds: 'deterministic'` 解决问题。  

```
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

步骤 | 操作 | 说明
:- | :- | :-
① | 创建示例library | 在入口文件导入了 `lodash`，导出两个方法
② | Webpack配置 | 更改了打包文件的名称
③ | 暴露库 | 通过设置 `output.library` 暴露导出内容，此时只能被脚本标签引用  
④ | 兼容更多环境 | 通过设置 `output.library.type:'umd'` 使其能在CommonJS、Node.js等环境  
⑤ | 外部化lodash | 通过设置 `externals`，意味对使用者来说，该库依赖 `lodash`
⑥ | 定义引用依赖时的文件地址 | 在 `package.json` 中设置 `main`



### 环境变量  

> 适当设置环境变量可以消除配置文件在开发环境和生产环境间的差异。  
>
> 在webpack命令行中的 `--env`，可以传入环境变量，在配置文件中能访问到。  

```
npx webpack --env goal=local --env production --progress
```

webpack.config.js  
> 要想访问 `env` 变量，需将导出模块转换为函数。  
> 
> 在上面，设置了环境变量却未赋值，默认赋值为true。  
```
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

#### 环境变量_[node环境](https://webpack.docschina.org/api/cli/#node-env)
> 可以使用 `--node-env` 选项来设置 `process.env.NODE_ENV`  
> 
> 此时，配置文件中如果没有明确的 `mode`，会被该设置覆盖。  

```
npx webpack --node-env production   # process.env.NODE_ENV = 'production'
```



### 构建性能  

#### 构建性能_通用环境  
> 包含了开发环境和生产环境。   

索引 | 操作 | 说明
:- | :- | :-
① | 更新到最新版本 | 包含npm、webpack、node.js，新版本在性能方面做的更好
② | [loader](#构建性能_通用环境_loader) | 将 loader 应用于最少数量的必要模块
③ | 减少 loader/plugin | 均有启动时间  
④ | 解析 | [跳转](https://webpack.docschina.org/guides/build-performance/#resolving)到详情
⑤ | 保持 chunk 体积小 | 使用更少，更小的库、
⑤ | 保持 chunk 体积小 | 在多页面应用程序中使用 SplitChunksPlugin ，并开启 async 模式
⑥ | 将非常消耗资源的loader分流到 worker pool | 谨慎使用，启动和通讯消耗资源  

#### 构建性能_通用环境_loader 
> 可以通过使用 `include` 字段，将 loader 仅作用于需要的地方。  

```
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

索引 | 操作 | 说明
:- | :- | :-
① | 在内存中编译 | 如 `webpack-dev-server`
② | 排除仅生产环境用到的工具 | 如压缩  
③ | 剥离 runtimeChunk | `optimization.runtimeChunk: true`
④ | 输出结果不携带路径信息 | `output.pathinfo: false`，降低对大项目的垃圾回收性能压力
⑤ | 缓存性能开销较大的loader | 使用 `cache-loader`，保存和读取有时间开销，谨慎使用  



### 依赖管理  

#### require.context  
> 可以创建一个导入上下文，其中包括满足条件的所有文件  

参数 | 说明
:- | :- 
① | 要搜索的目录
② | 是否还搜索其子目录
③ | 匹配文件的正则表达式  

```
require.context('../', true, /\.stories\.js$/);
// （创建出）一个 context，其中所有文件都来自父文件夹及其所有子级文件夹，request 以 `.stories.js` 结尾。
```

> 上下文有一个 keys 属性，是一个包含导入文件的数组，可以将其保存到一个对象中。    
```
const cache = {};

function importAll(r) {
  r.keys().forEach((key) => (cache[key] = r(key)));
}

importAll(require.context('../components/', true, /\.js$/));
// 在构建时(build-time)，所有被 require 的模块都会被填充到 cache 对象中。
```



### 生产环境  

> 在开发环境，需要强大的 source map 和有着实时重新加载或热模块替换能力的本地服务器。  
> 
> 在生产环境，注重压缩 bundle、更轻量的 source map、资源优化等。  

#### 生产环境_分别配置  
> 由于两个环境的构建目标不同，往往将它们不同的部分拆分，并保留一份通用配置。   

- 项目   
  + webpack.common.js  
  + webpack.dev.js  
  + webpack.prod.js  

webpack.common.js
```
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

webpack.dev.js  
```
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

webpack.prod.js  
```
 const { merge } = require('webpack-merge');
 const common = require('./webpack.common.js');

 module.exports = merge(common, {
   mode: 'production',
   // 生产模式推荐，避免使用 inline- 及 eval- 值，降低性能  
   // devtool: 'source-map',
 });
```

#### 生产环境_配置说明  
> 对于开发模式，可以使用 style-loader 将 CSS 插入到 DOM。
> 
> 对于生产模式，使用 `mini-css-extract-plugin` 以压缩代码，其与 style-loader 冲突。  

操作 | 名称 | 配置方式 | 说明
:- | :- | :- | :-
剔除死代码 | TerserPlugin | 默认使用 | 利于压缩，可选择其它压缩方式。与 tree shaking 相关  
压缩CSS | CssMinimizerPlugin | 手动配置 | [跳转](https://webpack.docschina.org/plugins/mini-css-extract-plugin/#minimizing-for-production) 
提取CSS到一个文件 | CssMinimizerPlugin | 手动配置 | [跳转](https://webpack.docschina.org/plugins/mini-css-extract-plugin/#extracting-all-css-in-a-single-file)
长期缓存 | CssMinimizerPlugin | 手动配置 | [跳转](https://webpack.docschina.org/plugins/mini-css-extract-plugin/#long-term-caching)

#### 生产环境_脚本设置  

package.json
```
{
  "scripts": {
    "serve": "webpack serve --open --config webpack.dev.js",
    "build": "webpack --config webpack.prod.js"
  },
}
```



## 其他

### 常见的loader  

loader | 说明 | webpack4
:- | :- | :-:
raw-loader | 导出资源的源代码 | √ 
file-loader | 把文件输出到一个文件夹中，在代码中通过相对 URL 去引用输出的文件 | √
url-loader | 和 file-loader 类似，但是能在文件很小的情况下以 base64 的方式把文件内容注入到代码中去 | √ 
image-loader | 加载并且压缩图片文件 | 
babel-loader | 把 ES6 转换成 ES5 | 
postcss-loader | 可以自动补全浏览器前缀、[将px转换为rem](http://www.baidu.com/link?url=fkrwinKCUrxqE6O8rM_MQBsCRdJ3Dq82liD5HHEXbgDwJ_OLFD4NVFFQBNStwQI8BSQNaQXtNZxVvLVXu_fy-6m5dFDXxlT8J4-pYABjYwm) | 
less-loader | 将 Less 编译为 CSS | 
sass-loader | 将 Sass 编译为 CSS | 
css-loader | 识别导入的 CSS 模块，将其转换后导出 |  
style-loader | 将模块导出的内容作为样式并添加到 DOM 中 | 
vue-loader | 允许以单文件组件的格式编写 Vue 组件 | 
eslint-loader | 通过 ESLint 检查 JavaScript 代码 | 
source-map-loader | 加载额外的 Source Map 文件，以方便断点调试 | 

> 在 webpack 5 中，使用[资源模块](https://webpack.docschina.org/guides/asset-modules/)类型，允许使用资源文件（字体，图标等）而无需配置额外 loader


### 常见的plugin

define-plugin：定义环境变量

terser-webpack-plugin：通过TerserPlugin压缩ES6代码

html-webpack-plugin：会在 `dist` 文件夹下创建文件 `index.html`，其中引入了所有的输出文件（bundle.js）

mini-css-extract-plugin：可以分离css文件、压缩等  

clean-webpack-plugin：删除打包文件

happypack：实现多线程加速编译











