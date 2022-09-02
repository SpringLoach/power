## 自定义指令

> 需要对**DOM元素进行底层操作**时，就可以用到自定义指令。



### (例)自动聚集

#### 默认实现

```html
<input type="text" ref="input">
```

```javascript
import { ref, onMounted } from "vue";

setup() {
  const input = ref(null);

  onMounted(() => {
    input.value.focus();
  })

  return { input }
}
```

:turtle: 当多个组件/视图都需要使用到这种操作时，可以把它抽离成指令形式。



#### 局部指令

```html
<input type="text" v-focus>
```

```javascript
export default {
  directives: {
    focus: {
      mounted(el, bindings, vnode, preVnode) {
        el.focus();
      }
    }
  }
}
```

:whale: 生命周期钩子提供的首参为<span style="color: #ff0000">目标元素</span>。



#### 全局指令

<span style="backGround: #efe0b9">Demo.vue</span>

```html
<input type="text" v-focus>
```

<span style="backGround: #efe0b9">main.js</span>

```javascript
import { createApp } from 'vue'
import App from './03_自定义指令/App.vue'

const app = createApp(App);

app.directive("focus", {
  mounted(el, bindings, vnode, preVnode) {
    el.focus();
  }
})

app.mount('#app');
```



### 指令的生命周期

> 指令有如下钩子，用于定义行为。注意<span style="color: #ff0000">它们的命名、数量与 vue2 不同</span>。

<span style="color: #f7534f;font-weight:600">created</span>：在绑定元素的 attribute 或事件监听器被应用之前调用；

<span style="color: #f7534f;font-weight:600">beforeMount</span>：当指令第一次绑定到元素并且在挂载父组件之前调用；

<span style="color: #f7534f;font-weight:600">mounted</span>：在绑定元素的父组件被挂载后调用；

<span style="color: #f7534f;font-weight:600">beforeUpdate</span>：在更新包含组件的 VNode 之前调用；

<span style="color: #f7534f;font-weight:600">updated</span>：在包含组件的 VNode **及其子组件的 VNode** 更新后调用；

<span style="color: #f7534f;font-weight:600">beforeUnmount</span>：在卸载绑定元素的父组件之前调用；

<span style="color: #f7534f;font-weight:600">unmounted</span>：当指令与元素解除绑定且父组件已卸载时，只调用一次；



### 指令的参数和修饰符

```html
<button v-demo.aa.bb="'test'">示例</button>
```

```javascript
directives: {
  demo: {
    created(el, bindings, vnode, preVnode) {
      console.log(bindings.value);            // 'test'
      console.log(bindings.modifiers);        // {aa: true, bb: true}
    },
  }
}
```

:turtle: 可以通过钩子的第二个参数获取传递进来的参数和修饰符。



### (例)全局-时间格式化指令

> 将时间戳转化为自定义字符串的形式。

```elm
npm install dayjs
```

<span style="backGround: #efe0b9">directives/format-time.js</span>

```javascript
import dayjs from 'dayjs';

export default function(app) {
  app.directive("format-time", {
    created(el, bindings) {
      bindings.formatString = "YYYY-MM-DD HH:mm:ss"; // 默认格式
      if (bindings.value) {
        bindings.formatString = bindings.value;
      }
    },
    mounted(el, bindings) {
      const textContent = el.textContent;
      let timestamp = parseInt(textContent);
      el.textContent = dayjs(timestamp).format(bindings.formatString);
    }
  })
}
```

:whale: 传入参数时，使用参数格式，否则使用默认格式。

<span style="backGround: #efe0b9">directives/index.js</span>

```javascript
import registerFormatTime from './format-time';

export default function registerDirectives(app) {
  registerFormatTime(app);
}
```

:whale: 作为自定义指令的整合文件，可以清晰明了的查看（决定）注册哪些指令。

<span style="backGround: #efe0b9">main.js</span>

```javascript
import { createApp } from 'vue'
import App from './03_自定义指令/App.vue'
import registerDirectives from './directives'

const app = createApp(App);

registerDirectives(app);

app.mount('#app');
```

<span style="backGround: #efe0b9">Demo.vue</span>

```html
<h2 v-format-time="'YYYY/MM/DD'">{{timestamp}}</h2>
```




