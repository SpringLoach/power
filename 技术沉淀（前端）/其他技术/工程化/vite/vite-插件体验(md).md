## 使用流程

### <span style="color: #3a84aa">一、准备插件</span>

① 使用 vite 新建 vue 项目

② 根据原目录结构，将[插件项目](https://github.com/a1029563229/-vitejs-plugin-markdown)中的核心文件整理为如下

```elm
- plugin
  + assets
    - juejin.style.js
  + markdown
    - index.js
```

③ 将 `index.js` 中的 commonJS 语法修改为 ES Module 



### <span style="color: #3a84aa">二、引入并测试</span>

① 引入插件到项目

<span style="backGround: #efe0b9">vite.config.js</span>

```javascript
import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
// 添加
import markdown from "./plugin/markdown/index";

export default defineConfig({
  plugins: [vue(), markdown()],
});
```

② 向 `App.vue` 中添加下面的代码，并准备一个 `.md` 文件

```html
<g-markdown file="./demo.md" />
```



### <span style="color: #3a84aa">三、增强</span>

>  支持代码高亮，支持表情

```elm
npm install highlight.js markdown-it-emoji -D -S
```

```javascript
import hljs from 'highlight.js'
import emoji from 'markdown-it-emoji'

const highlight = (str, lang) => {
  if (!lang || !hljs.getLanguage(lang)) {
    return '<pre><code class="hljs">' + str + '</code></pre>'
  }
  const html = hljs.highlight(str, { language: lang, ignoreIllegals: true }).value
  return `<pre><code class="hljs language-${lang}">${html}</code></pre>`
}

const md = new MarkdownIt({
  html: true,
  highlight
});
md.use(emoji);
```



### <span style="color: #3a84aa">四、替换样式</span>

>  默认通过添加标签的方式引入掘金的样式，可以替换掉。

① 先删除原本添加的默认样式；

<span style="backGround: #efe0b9">plugin/markdown/index.js</span>

```javascript
import { style } from "./assets/juejin.style";

transformCode = `
${transformCode}
<style scoped>
  ${style}
</style>
`;
```

② 再将需要引入的新样式文件，引入到 `main.js` 即可。



## 附录

参考资料

- [vite插件](https://blog.csdn.net/qq_34621851/article/details/123535975)

- [bin-datav](https://github.com/wangbin3162/bin-datav) 
