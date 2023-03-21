## markit

vite插件 https://blog.csdn.net/qq_34621851/article/details/123535975

bin-datav https://github.com/wangbin3162/bin-datav





使用 vite 新建 vue 项目

根据原目录结构，将核心文件抽取为如下

```elm
- plugin
  + assets
    - juejin.style.js
  + markdown
    - index.js
```



插件我想还是通过 commonJS 的方式

```elm
cnpm install rollup -S -D  
```



rollup.config.js

```javascript
export default {
  input: 'plugin/markdown/index.js',
  output: {
    file: 'lib/markdown.js',
    format: 'es'
  }
};
```



package.json

```json
"scripts": {
  "build:lib": "rimraf lib && run-s build:md",
  "build:md": "rollup --config"
}
```



```elm
npm install rimraf npm-run-all markdown-it -S -D
```



```
npm install --save-dev @rollup/plugin-node-resolve
```

```
npm install --save-dev @rollup/plugin-commonjs
```

