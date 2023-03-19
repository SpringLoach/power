## PostCss

> 能够按照一定的规则处理 css，转化为 new css。

<span style="color: slategray">安装</span>

```elm
npm install postcss -D
```

<span style="color: slategray">配置</span>

<span style="backGround: #efe0b9">postcss.config.js</span>

```react
module.exports = {
  // ...
}
```

:ghost: 和 `webpack` 类似，`postcss` 有自己的配置文件；

:ghost: `postcss` 本身没有发挥作用，要借助插件去完成功能，但<span style="color: #ff0000">本身也需要安装</span>；



## 预设的多个功能

>  `postcss-preset-env` 是一个<span style="color: #ff0000">预设了许多其它插件功能</span>的一个插件。

<span style="color: #3a84aa">安装</span>

```elm
npm install postcss -D
```

```elm
npm install postcss-preset-env -D
```

:ghost: `postcss` 本身没有发挥作用，要借助插件去完成功能；

<span style="color: #3a84aa">配置</span>

<span style="backGround: #efe0b9">postcss.config.js</span>

```react
module.exports = {
  plugins: [
    require('postcss-preset-env')
  ]
}
```

<span style="color: #3a84aa">特点</span>

| 特点              | 说明                                                         |
| ----------------- | ------------------------------------------------------------ |
| 自动的厂商前缀    | 内置 `autoprefixer` 来完成该功能，可调整兼容的浏览器范围     |
| 支持未来的css语法 | 可[配置](https://blog.csdn.net/xun__xing/article/details/108290032)对某个支持阶段的css语法进行兼容处理 |
| 支持变量          | 未来的css语法是天然支持变量的                                |
| 自定义选择器      | 略                                                           |
| 嵌套              | 与 less 相同，只不过嵌套的选择器前必须使用符号`&`            |

:whale: 参考自[博客](https://blog.csdn.net/xun__xing/article/details/108290032)



### 调整兼容的浏览器范围

#### 方式1

在 `postcss-preset-env` 的配置中添加 `browsers`

```javascript
module.exports = {
  plugins: {
    "postcss-preset-env": {
      browsers: [
        "last 2 version",
        "> 1%"
      ]
    } 
  }
}
```

#### 方式2

在 `.browserslistrc` 中配置

<span style="backGround: #efe0b9">.browserslistrc</span>

```javascript
last 2 version
> 1%
```

#### 方式3

在 `package.json` 中配置 `browserslist`

<span style="backGround: #efe0b9">package.json</span>

```javascript
"browserslist": [
  "last 2 version",
  "> 1%"
]
```



## 移动端字体适配

> postcss-pxtorem

**安装**

```elm
npm install postcss-pxtorem --save-dev
```

**配置**

<span style="backGround: #efe0b9">[root]/postcss.config.js</span>

```javascript
module.exports = {
  plugins: {
    // 兼容浏览器，添加前缀
    autoprefixer: {
      overrideBrowserslist: [
        "Android 4.1",
        "iOS 7.1",
        "Chrome > 31",
        "ff > 31",
        "ie >= 8",
        "last 10 versions", // 所有主流浏览器最近10版本用
      ],
      grid: true,
    },
    "postcss-pxtorem": {
      rootValue: 37.5, // 根标签的fontSize的值，计算方式为【**设计稿宽度/10**】
      propList: ["*"], // 存储哪些将被转换的属性列表，这里设置为全部
      unitPrecision: 5, // 保留rem小数点多少位
      selectorBlackList: ['fs'], // 对css选择器进行过滤的数组，对于fs-xl类名，有关px的样式将不被转换
      mediaQuery: false, // 媒体查询中不生效
      minPixelValue: 12, // px小于12的不会被转换
    },
  },
};
```



## 附录

参考资料：

[PostCss](https://blog.csdn.net/xun__xing/article/details/108290032)
