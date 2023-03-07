## webpack5-loader

### 配置loader

> 原生的 webpack 只能解析 js，除此以外的文件类型都不能作为模块解析。
>
> 可以通过 `module.rules` 的方式为项目配置 <span style="color: #f7534f;font-weight:600">loader</span> 。

<span style="backGround: #efe0b9">webpack.config.js</span>

```javascript
module.exports = {
  ...,
  module: {
    rules: [
      {
        test: /\.css&/,
        loader: "css-loader"
      }
    ]
  }
}

/* 上面 Rule 对象的等价写法 */
{
  test: /\.css&/,
  use: [
    "css-loader"
  ]
}
```

`module.rules` 的格式为数组，它由 Rule 对象组成。



#### Rule对象

- <span style="color: #f7534f;font-weight:600">test属性</span>：用于对资源进行匹配，通常会设置成正则表达式；
- <span style="color: #f7534f;font-weight:600">use属性</span>：对应的值是一个数组：[UseEntry] 
  + UseEntry可以为配置对象
    - loader：必须有一个 loader属性，对应的值是一个字符串；
    - options：可选的属性，值是一个字符串或者对象，值会被传入到loader中；
    - query：目前已经使用options来替代；
  + UseEntry也可以为字符串
- <span style="color: #f7534f;font-weight:600">loader属性</span>： 语法糖，相当于 Rule.use: [ { loader } ] 的简写。



#### css的插入

> 仅配置 `css-loader` ，并不能样式在页面上出现效果。

```react
rules: [
  {
    test: /\.css&/,
    use: [
      "style-loader",
      "css-loader"       // 后（右）者先执行
    ]
  }
]

/* 上面 Rule 对象的等价写法 */
{
  test: /\.css&/,
  use: [
    { loader: "style-loader" },
    { loader: "css-loader" },
  ]
}
```

- css-loader <span style="color: #ff0000">负责将 .css 文件进行解析</span>

- style-loader <span style="color: #ff0000">负责将 style 插入到页面</span>



#### 配置插件

> loader 能够通过插件来拓展能力，这里以 **postcss-loader** 为例。

```react
use: [
  { loader: "style-loader" },
  { loader: "css-loader" },
  {
    loader: "postcss-loader",
    options: {
      postcssOptions: {
        plugins: [
          require('postcss-preset-env')
        ]
      }
    }
  }
]
```

:star2: 通过 <span style="color: #a50">postcss-preset-env</span> ，可以自动生成适配各浏览器的带前缀的CSS属性，也能将现代CSS转换为大多数浏览器都认识的CSS，如将 #00000000 转化为 rgba。



#### 抽离postcss配置

> **postcss-loader** 的配置可以放到一个特定命名的单独文件中，需要在项目根目录下。

<span style="backGround: #efe0b9">postcss.config.js</span>

```react
/* 此时 webpack.config.js 中的 postcss-loader 不再需要 options */
module.exports = {
  plugins: [
    require('postcss-preset-env') 
  ]
}
```



#### file-loader

> 可以使用该 loader 来处理图片，它能够处理<span style="color: #ff0000">import/require()方式</span>引入的文件资源，并放到<span style="color: #ff0000">输出文件夹</span>。



##### 文件命名

> 有时会想要保留原来的文件名、扩展名，同时为了防止重复，包含一个hash值。

\- 常用的placeholder： 

 **[ext]：** 处理文件的扩展名

 **[name]：**处理文件的名称

 **[hash]：**文件的内容，使用MD4的散列函数处理，生成的一个128位的hash值（32个十六进制）

 **[hash:<length>]：**截取hash的长度，有时默认32个字符太长了

 **[contentHash]：**在file-loader中和[hash]结果是一致的（在webpack的一些其他地方不一样）

 **[path]：**文件相对于webpack配置文件的路径；



```react
{
  test: /\.(jpe?g|png|gif|sbg)$/,
  use: {
    loader: "file-loader",
    options: {
      name: "img/[name]_[hash:8].[ext]"
    }
  }
}

/* 等价写法 */
{
  test: /\.(jpe?g|png|gif|sbg)$/,
  use: {
    loader: "file-loader",
    options: {
      outputPath: "img",
      name: "[name]_[hash:8].[ext]"
    }
  }
}
```



##### 引用方式

```react
import demoImage from '../img/xx.png';

img.src = demoImage;
```

<span style="backGround: #efe0b9">错误写法</span>

```react
/* 打包后，根据该路径会找不到资源 */
img.src = "../img/xx.png"
```

:turtle: 针对 JavaScript 中的图片路径，Vue 模板中的图片路径可能经过特殊处理。



#### url-loader

> 与 <span style="color: #a50">file-loader</span> 的配置相似，可以<span style="color: #ff0000">直接替代</span> <span style="color: #a50">file-loader</span>，并且可以将较小文件转为<span style="color: #ff0000">base64的URI</span>。

```react
{
  test: /\.(jpe?g|png|gif|sbg)$/,
  use: {
    loader: "url-loader",
    options: {
      limit: 10 * 1024,             
      outputPath: "img",
      name: "[name]_[hash:8].[ext]"
    }
  }
}
```

:turtle: 对于满足条件（小于10kb）的资源，将其转化并生成在 JavaScript 文件中，否则正常导出。

:turtle: 不转化较大的资源，否则会<span style="color: #ff0000">增大请求文件体积，影响页面的请求速度</span>。



##### 性能优化—图片

> 对于较小体积的多张图片，可以使用字体图片、转base64、雪碧图的方式来减少请求次数，可以减少服务器压力。



#### 资源模板类型

> 在 <span style="color: #a50">webpack5</span>   后，用于替代 <span style="color: #a50">raw-loader、url-loader、file-loader</span>，并且它是内置的，不需要像其它 loader 在使用前还要进行安装。



\- **资源模块类型(asset module type)**，通过添加 4 种新的模块类型，来替换所有这些 loader： 

| webpack5       | 相当于webpack4的    | 作用                |
| -------------- | ------------------- | ------------------- |
| asset/resource | file-loader         | 导出资源的 URL      |
| asset/inline   | url-loader          | 导出资源的 data URI |
| asset/source   | raw-loader          | 导出资源的源代码    |
| asset          | 加限制的 url-loader | 配置资源体积限制    |

`demo`

```react
// 导出到对应路径
{
  test: /\.(jpe?g|png|gif|sbg)$/,
  type: "asset/resource"
}
```

`demo2`

```react
// 满足条件会生成 base64，否则导出到对应路径
{
  test: /\.(jpe?g|png|gif|sbg)$/,
  type: "asset",
  generator: {
    filename: "img/[name]_[hash:8][ext]"        // 配置路径
  },
  parser: {
    dataUrlCondition: {
      maxSize: 10 * 1024                       // 限制体积
    }
  }
}
```

:turtle: 这里的 `[ext]` 会以 `.` 作为开头。

```react
module.export = {
  output: {
    ...,
    assetModuleFilename: "img/[name]_[hash:8][ext]"  // 配置路径
  }
}
```

:octopus: 对于asset的路径，也可以在这里进行配置。



#### 打包图标库

<span style="backGround: #efe0b9">webpack.config.js</span>

`webpack4`

```react
{
  test: /\.(eot|ttf|woff2?)$/,
  use: {
    loader: "file-loader",
    options: {
      name: "font/[name]_[hash:6].[ext]"
    }
  },
}
```

`webpack5`

```react
{
  test: /\.(eot|ttf|woff2?)$/,
  type: "asset/resource",
  generator: {
    filename: "font/[name]_[hash:6][ext]"        // 配置路径
  },
}
```









### Babel

> 用于将源代码 （ES6、TypeScript） 转化为旧浏览器或环境中能够兼容的源代码（ES5），可以看作为编译器。



#### 执行原理

![babel编译器原](.\img\babel编译器原理.png)



#### webpack中使用

```elm
npm install babel-loader @babel/core @babel/preset-env -D
```

##### 整合配置方式

<span style="backGround: #efe0b9">webpack.config.js</span>

```react
module: {
  rules: [
    {
      test: /\.js$/,
      use: {
        loader: "babel-loader",
        options: {               
          presets: [
            ["@babel/preset-env"]
          ]
        }
      }
    }
  ]
}
```



##### 单独配置方式

>  babel 的配置可以放到一个特定命名的单独文件中，需要在项目根目录下。

<span style="backGround: #efe0b9">babel.config.js</span>

```react
modules.exports = {
  presets: [
    ["@babel/preset-env"]
  ]
}
```

<span style="backGround: #efe0b9">webpack.config.js</span>

```react
{
  test: /\.js$/,
  loader: "babel-loader"
}
```

配置文件可以使用的其它命名

| 文件名称          | 其它允许的后缀            | 特点                                                    |
| ----------------- | ------------------------- | ------------------------------------------------------- |
| babel.config.json | .js，.cjs，.mjs           | 可以直接作用于 Monorepos 项目的子包，更加推荐（babel7） |
| .babelrc.json     | .babelrc，.js，.cjs，.mjs | 早期使用较多                                            |



### 支持Vue3的SFC文件

```elm
npm install vue@next --save
npm install vue-loader@next -D   // 支持SFC需要
npm install @vue/compiler-sfc -D // 支持SFC需要
```

<span style="backGround: #efe0b9">webpack.config.js</span>

```react
const { VueLoaderPlugin } = require('vue-loader/dist/index');

module.exports = {
  module: {
    rules: [
      {
        test: /\.vue&/,
        loader: "vue-loader"
      }
    ]
  },
  plugins: [
    new VueLoaderPlugin() // 支持SFC需要
  ]
}
```

<span style="backGround: #efe0b9">index.html</span>

```react
<div id="app"></div>
```

<span style="backGround: #efe0b9">main.js</span>

```react
import { createApp } from 'vue'; 
import App from './vue/App.vue';

const app = createApp(App);
app.mount('#app');
```



### 配置Vue3的默认行为

> 虽然Vue3有对它们的默认配置，但如果不手动配置会在网页有警告。

<span style="backGround: #efe0b9">webpack.config.js</span>

```react
const { DefinePlugin } = require('webpack'); // 内置模板，无需安装

module.exports = {
  plugins: [
    new DefinePlugin({
      __VUE_OPTIONS_API__: true, // 设置为 false,会使用 tree-shaking 剔除相关代码,减小体积
      __VUE_PROD_DEVTOOLS__: false
    })
  ]
}
```

<span style="color: #f7534f;font-weight:600">__VUE_OPTIONS_API __</span>表示支持使用Vue的Options，对Vue2做适配

<span style="color: #f7534f;font-weight:600">__VUE_PROD_DEVTOOLS __</span>表示生产模式下支持使用devtools工具



## 本地服务器

### 本地服务器

> 当文件发生变化时,可以<span style="color: #ff0000">自动地完成编译和展示</span>。



为了完成自动编译，webpack提供了几种可选的方式： 

- webpack watch mode

- webpack-dev-server（常用）

- webpack-dev-middleware



#### webpack watch mode

>  在该模式下，webpack依赖图中的所有文件，只要有一个发生了更新，那么代码将被重新编译。
>
>  在不借助 live-server 地前提下，无法自动刷新浏览器。

配置方式一

<span style="backGround: #efe0b9">package.json</span>

```json
"script": {
  "build": "webpack --watch"
}
```

配置方式二

<span style="backGround: #efe0b9">webpack.config.js</span>

```javascript
module.exports = {
  watch: true,
}
```



#### webpack-dev-server

> 能够实现实时重新加载(自动刷新浏览器)的功能。其编译后不会输出任何文件，而是<span style="color: #ff0000">直接将 bundle 文件保存在内存中</span>，省略了读取输出文件到内存的步骤，效率更高。

```elm
npm install webpack-dev-server -D
```

<span style="backGround: #efe0b9">package.json</span>

```json
"script": {
  "serve": "webpack serve"
}
```

<span style="backGround: #efe0b9">webpack.config.js</span>

```javascript
module.exports = {
  target: "web",            // 目标运行环境,不配置偶尔有问题?
  devServer: {
    contentBase: "./public" // 当在内存的打包资源中找不到某项资源时,会在该路径下找
  },
}
```

##### 建议的资源处理方式

开发阶段: devServer.contentBase，可以提高些许效率

打包阶段: CopyWebackPlugin，即复制插件



### 模块热替换

> <span style="color: #a50">HMR</span> 是指在应用程序运行过程中，<span style="color: #ff0000">替换、添加、删除模块，而无需重新刷新整个页面；</span>



#### 好处

- 不重新加载整个页面，这样可以保留某些应用程序的状态不丢失； 

- 只更新需要变化的内容（以模块作为单位），节省开发的时间； 

- 修改了css、js源代码，会立即在浏览器更新，相当于直接在浏览器的devtools中直接修改样式；

:turtle: 应用程序的状态，如表单里的输入值。



#### 使用

<span style="backGround: #efe0b9">webpack.config.js</span>

```react
devServer: {
  target: "web",            // 目标运行环境,不配置偶尔有问题?
  hot: true
},
```

<span style="backGround: #efe0b9">main.js</span>

```react
import './demo.js'

if (module.hot) {
  module.hot.accept("./demo.js", () => {
    console.log("进行了更新");
  })
}
```

> 如果不添加上述的配置，HMR不会起效果。



#### 框架体验

> 如vue开发中，我们使用vue-loader，此loader支持vue组件的HMR，提供开箱即用的体验，而不需要频繁写入 module.hot.accept 相关的API。



#### HRM原理

webpack-dev-server 会创建两个服务：提供静态资源的服务（express）和 Socket 服务（net.Socket）

![HRM原理](.\img\HRM原理.png)

<span style="color: #f7534f;font-weight:600">express server </span>负责直接提供静态资源的服务（打包后的资源直接被浏览器请求和解析）；

<span style="color: #f7534f;font-weight:600">Socket server </span> 是一个socket的长连接：

- 当服务器监听到对应的模块发生变化时，会生成两个文件.json（manifest文件）和.js文件（update chunk）；

- 通过长连接，可以直接将这两个文件<span style="color: #ff0000">主动发送</span>给客户端（浏览器）；

- 浏览器拿到两个新的文件后，通过HMR runtime机制，加载这两个文件，并且<span style="color: #ff0000">针对修改的模块</span>进行更新；

:ghost: 长连接在建立连接后双方可以通信（服务器可以直接发送文件到客户端）

:ghost: 短连接一般需要从客户端发起请求，服务器返回资源后断开连接，故不能对资源进行及时的更新。



### 主机地址

> host， 用于设置主机地址。

<span style="backGround: #efe0b9">webpack.config.js</span>

```react
devServer: {
  host: "0.0.0.0" // 默认值是localhost
}
```



##### localhost VS 0.0.0.0 

<span style="color: #f7534f;font-weight:600">localhost </span> 本质上是一个域名，通常情况下会被解析成 127.0.0.1; 

- 127.0.0.1：回环地址，即主机自己发出去的包，直接被自己接收; 

- 正常的数据库包经过 <span style="color: #a50">应用层 - 传输层 - 网络层</span> - 数据链路层 - 物理层 ; 

- 而回环地址，是在网络层直接就被获取到了，不会经过数据链路层和物理层; 

- 在监听 127.0.0.1时，在同一个网段下的主机中，通过ip地址是不能访问的; 

<span style="color: #f7534f;font-weight:600">0.0.0.0</span> 监听IPV4上所有的地址，再根据端口找到不同的应用程序; 

-  在监听 0.0.0.0时，<span style="color: #ff0000">在同一个网段下的其它主机，通过ip地址是可以访问它的;</span>

:whale: <span style="color: #ff0000">在浏览器访问时</span>， 对于 window 系统，`0.0.0.0` 的地址可能不能被正常解析，可以用以下任意去替代。

```react
localhost
127.0.0.1
局域网的IP地址
```



### 设置压缩

> 为静态文件开启 gzip compression。

<span style="backGround: #efe0b9">webpack.config.js</span>

```react
devServer: {
  compress: true // 默认值false
}
```

:turtle: 压缩效果还挺显著的，且浏览器能够自动识别解压 `gzip` 格式的资源。

:turtle: 自己服务器使用自己资源时，速度足够快，没必要开，否则还会增加压缩成本。



### Proxy

> 设置代理是解决跨域访问问题的一个手段。



#### 跨域的发生

如直接从 http://localhost:6666 访问 http://localhost:8888/moment/，会跨域



#### 解决跨域的原理

> 将域名发送给本地的服务器（启动vue项目的服务,loclahost:8080），再由本地的服务器去请求真正的服务器。

![proxy原理](.\img\proxy原理.png)



#### 配置示例

##### 正常请求

<span style="backGround: #efe0b9">demo.js</span>

```react
axios.get("http://localhost:8888/moment").then(res => {
  console.log(res);
})
```



##### 配置代理

<span style="backGround: #efe0b9">webpack.config.js</span>

```react
devServer: {
  proxy: {
    "/api": "http://localhost:8888" // 键会被映射为值
  }
}
```

<span style="backGround: #efe0b9">demo.js</span>

```react
axios.get("/api/moment").then(res => {
  console.log(res);
})
```

:octopus: 此时，该请求会被映射为 `http://localhost:8888/api/moment`，因为它会自动插入键。

:star2: 如果不希望传递 `/api`，则需要重写路径。



##### 重写路径

```react
devServer: {
  proxy: {
    "/api": {
      target: "http://localhost:8888",
      pathRewrite: {  // 重写
        "^/api": ""
      }
    }
  }
}
```

:whale: 此时，该请求会被映射为 `http://localhost:8888/moment`，即所需。



##### 更多配置

```react
devServer: {
  contentBase: "./public",
  hot: true,
  port: 6666,
  open: true,
  proxy: {
    "/api": {
      target: "http://localhost:8888", // 代理到的目标地址
      pathRewrite: {  // 重写
        "^/api": ""
      },
      secure: false, // 默认为true，默认不接收https的请求
      changeOrigin: true // 替代源
    }
  }
}
```

:whale: 出于反爬充等目的，部分服务器会开启源的校验（header）；

:whale: 不开启<span style="color: #a50">changeOrigin</span>，会直接将源代码中的 `http://localhost:6666/api/moment` 发送给服务器而校验失败；

:whale: 开启<span style="color: #a50">changeOrigin</span>，会将`http://localhost:8888`放入 header 然后发送给服务器来通过校验。

