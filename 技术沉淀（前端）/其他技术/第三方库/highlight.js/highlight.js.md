### 基本使用

安装

```elm
npm install highlight.js
```

使用

```vue
<template>
  <div ref="preCode" style="white-space: pre">{{ code }}</div>
</template>

<script setup lang="ts">
import { nextTick, ref } from 'vue'
import Hljs from 'highlight.js'
import 'highlight.js/styles/monokai-sublime.css' // 代码高亮风格，可以选择以切换

const preCode = ref<HTMLElement>()
const code =`
// 这里放一些代码
`

nextTick(() => {
  Hljs.highlightElement(preCode.value as HTMLElement)
})
</script>
```

