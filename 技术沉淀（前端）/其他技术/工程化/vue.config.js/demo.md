## 原理

vue-cli 是基于（依赖于） Webpack 来模块化和打包的，而 Webpack 又是基于 Node 的。



## 关闭代码映射

代码经过打包压缩后，无法直接得知输出的错误信息源自于哪里；

这个配置开启时，将为每个js文件（在同目录下）生成一个map文件，可以用于映射出错信息对应的代码位置；

但同时也会大大地增加代码打包的体积，生产环境推荐关闭。

```javascript
module.exports = {
  productionSourceMap: false,
}
```

**测试结果**

| 配置行为   | 最终包体积 |
| ---------- | ---------- |
| 不进行配置 | 638 KB     |
| 配置为开启 | 638 KB     |
| 配置为关闭 | 104 KB     |



## 配置别名

```javascript
module.exports = {
  configureWebpack: {
    resolve: {
      alias: {
        'assets': '@/assets',
        'commom': '@/commom',
        'components': '@/components',
        'network': '@/network',
        'router': '@/router',
      }
    }
  }
}
```

借助 configureWebpack 将配置整合到默认配置上。
