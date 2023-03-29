## 介绍

通过一个简单小案例，体验写 vite 插件的简单流程；

将代码样式部分的 rpx 单位，根据设计稿宽度调整为相应的 vw 单位。

  

## 开发流程

### <span style="color: #3a84aa">一、准备项目</span>

```elm
npm create vite@latest my-vue-app -- --template vue
```

<span style="color: #3a84aa">需要修改/新增的文件如下</span>

```less
- root
  + plugin          # 定义插件
    - unitFix
      + index.js
    - src
      + App.vue     # 观察插件效果
  + vite.config.js  # 引用插件
```



### <span style="color: #3a84aa">二、编写插件结构</span>

<span style="backGround: #efe0b9">plugin/unitFix/index.js</span>

```javascript
export default function unitFitPlugin(config) {
  
  return {
    // 插件名称
    name: "vite:unitFit",

    // 调整插件顺序，可以直接解析到原模板文件
    enforce: "pre",

    // 在模块请求前调用，可用于代码转译，类似于 `webpack` 的 `loader`
    transform(code, id, opt) {
      // 将转换后的代码返回
      return transformCode;
    },
  };
}
```



### <span style="color: #3a84aa">三、转化代码的实现</span>

① 匹配 `.vue` 文件中的 `<style scoped>...</style>` 部分，作为转化目标；

② 根据规则 设计稿总宽度/实际总宽度 = 设计稿元素宽度/实际元素宽度；

③ 将转化目标中的 rpx 单位转化为 vw；

④ 设计稿宽度默认为 1920，允许用户提供不同的值，作为插件参数传入。

<span style="backGround: #efe0b9">plugin/unitFix/index.js</span>

```javascript
/** 设计稿宽度 */
let designDraftWidth = 1920;

export const transformStyle = (style) => {
  // 匹配样式中的rpx单位，如 12rpx
  const rpxRE = /[0-9]+(.*?)rpx/g;
  const rpxList = style.match(rpxRE);
  let transformCode = style;
  rpxList?.forEach((rpx) => {
    const origin = rpx.replace("rpx", "");
    const vw = `${(origin * 100) / designDraftWidth}vw`;
    // 将 style 标签的内容替换
    transformCode = transformCode.replace(rpx, vw);
  });

  return transformCode;
};

export default function unitFitPlugin({ viewportWidth }) {
  designDraftWidth = viewportWidth || 1920;
  const vueRE = /\.vue$/;
  const styleRE = /(?<=\<style scoped\>)[\s\S]*(?=\<\/style\>)/g;

  return {
    // 插件名称
    name: "vite:unitFit",

    // 该插件在 plugin-vue 插件之前执行，这样就可以直接解析到原模板文件
    enforce: "pre",

    // 代码转译，这个函数的功能类似于 `webpack` 的 `loader`
    transform(code, id, opt) {
      if (!vueRE.test(id) || !styleRE.test(code)) return code;

      const styleList = code.match(styleRE);
      let transformCode = code;
      styleList?.forEach((style) => {
        // 将 style 标签的内容替换
        transformCode = transformCode.replace(style, transformStyle(style));
      });

      // 将转换后的代码返回
      return transformCode;
    },
  };
}
```



### <span style="color: #3a84aa">四、引用插件</span>

<span style="backGround: #efe0b9">vite.config.js</span>

```javascript
import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
 // 添加
import unitFit from "./plugin/unitFit/index";

export default defineConfig({
  plugins: [
    vue(),
    unitFit({
      viewportWidth: 1920,
    }),
  ],
});
```



### <span style="color: #3a84aa">五、测试插件效果</span>

<span style="backGround: #efe0b9">src/App.vue</span>

```vue
<template>
  <div class="page-wrapper">
    <p>Vite是一种新型前端构建工具，能够显著提升前端开发体验。</p>
  </div>
</template>

<style scoped>
.page-wrapper {
  text-align: left;
  font-size: 24rpx;
}
</style>
```

```elm
npm run dev
```



## 附录

参考资料

- [vite中文文档](http://www.fenovice.com/doc/vitejs/guide/api-plugin.html#plugin-ordering)

- [postcss-px-to-viewport](https://github.com/evrone/postcss-px-to-viewport/blob/master/README_CN.md)

- [从0开始写一个简单的 vite hmr 插件](https://www.cnblogs.com/mushrain/p/16794508.html)




## 补充的话

在[仓库](https://github.com/SpringLoach/power)，还提供了许多<span style="color: #3a84aa">前端常见需求</span>及实现的归纳整理，欢迎客官看看~

如果这篇笔记能够帮助到你，请帮忙在 [github](https://github.com/SpringLoach/power) 上点亮 `star`，感谢！

