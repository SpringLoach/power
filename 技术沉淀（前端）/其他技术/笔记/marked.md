关键 | 所属技术 | 说明
:- | :- | :- 
`class="hljs"` | highlight主题 | 用于更改代码块背景
v-html | Vue | 更新元素的 `innerHTML`

#### 静态输出 
```react
<template>
  <div class="hljs" v-html="code"></div>
</template>

<script>
import marked from 'marked';
import hljs from 'highlight.js';
import javascript from 'highlight.js/lib/languages/javascript';
import 'highlight.js/styles/atom-one-dark.css'    // 高亮主题

export default {
  name: 'HelloWorld',
  data() {
    return {
      code: '```javascript\nfunction(){\n\tconsole.log(123)\n}\n```'
    }
  },
  mounted() {
    marked.setOptions({
      renderer: new marked.Renderer(),
      highlight: function(code) {
        return hljs.highlightAuto(code).value;
      },
      pedantic: false,
      gfm: true,
      breaks: false,
      sanitize: false,
      smartLists: true,
      smartypants: false,
      xhtml: false
    });
    this.code = marked(this.code)
  }
}
</script>
```

#### 表单双向绑定
```react
<template>
  <br><br><br><br><br><br><br><br>
  <textarea v-model="content" @input="update" cols="80" rows="10"></textarea>
  <div class="hljs" v-html="compiledMarkdown()"></div>
</template>

<script>
import marked from 'marked';
import hljs from 'highlight.js';
import javascript from 'highlight.js/lib/languages/javascript';
import 'highlight.js/styles/atom-one-dark.css'


export default {
  name: 'HelloWorld',
  data() {
    return {
      content: '```javascript\nfunction(){\n\tconsole.log(123)\n}\n```',
      markedContent: ''
    }
  },
  mounted() {
    marked.setOptions({
      renderer: new marked.Renderer(),
      highlight: function(code) {
        return hljs.highlightAuto(code).value;
      },
      pedantic: false,
      gfm: true,
      breaks: false,
      sanitize: false,
      smartLists: true,
      smartypants: false,
      xhtml: false
    });
    this.markedContent = marked(this.content);
  },
  methods: {
    // 编译Markdown
    compiledMarkdown: function () {
      return marked(this.content)
    },
    update: function (e) {
      this.markedContent = e.target.value
    }
  }
}
</script>
```
