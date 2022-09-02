# 逻辑复用

## 组合式函数

| 特征          | 说明                                                         |
| ------------- | ------------------------------------------------------------ |
| 命名方式      | 组合式函数约定用驼峰命名法命名，并以“use”作为开头            |
| 最佳实践      | 推荐在组合式函数中使用 ref 而不是 reactive，这样解构后仍有响应式 |
| 处理副作用    | 执行的副作用，像添加DOM事件监听，应该在 *onUnmounted* 中移除 |
| 绑定实例      | 在 *<script setup>* 中，组合式函数应被<span style="color: #ff0000">同步地</span>调用，以绑定到组件实例上 |
| 绑定实例      | 将生命周期钩子注册到该组件实例上                             |
| 绑定实例      | 将计算属性和监听器注册到该组件实例上，以便在组件卸载时停止监听，避免内存泄漏 |
| vs Mixin      | 更清晰的数据来源，避免命名冲突，避免隐形的跨 mixin 交流      |
| vs Mixin      | 不再推荐在 Vue 3 中继续使用 mixin。保留只是为了旧项目迁移    |
| vs 无渲染组件 | 无渲染组件即通过作用域插槽传递数据，将大部分布局留给父组件控制的组件 |
| vs 无渲染组件 | 推荐在纯逻辑复用时使用组合式函数，在需要同时复用逻辑和视图布局时使用无渲染组件 |



### 鼠标跟踪器示例

*定义*

```javascript
// mouse.js
import { ref, onMounted, onUnmounted } from 'vue'

// 按照惯例，组合式函数名以“use”开头
export function useMouse() {
  // 被组合式函数封装和管理的状态
  const x = ref(0)
  const y = ref(0)

  // 组合式函数可以随时更改其状态。
  function update(event) {
    x.value = event.pageX
    y.value = event.pageY
  }

  // 一个组合式函数也可以挂靠在所属组件的生命周期上
  // 来启动和卸载副作用
  onMounted(() => window.addEventListener('mousemove', update))
  onUnmounted(() => window.removeEventListener('mousemove', update))

  // 通过返回值暴露所管理的状态
  return { x, y }
}
```

*使用*

```vue
<script setup>
import { useMouse } from './mouse.js'

const { x, y } = useMouse()
</script>

<template>Mouse position is at: {{ x }}, {{ y }}</template>
```



## 自定义指令

| 特征     | 说明                                                         |
| -------- | ------------------------------------------------------------ |
| 使用场景 | 自定义指令主要是为了重用涉及普通元素的底层 DOM 访问的逻辑    |
| 特征     | 使用到多根节点组件，会抛出错误，且无法通过 `$attrs` 指定生效元素 |



### 使用手册

| 参数       | 类型       | 说明                                                         | 可选 |
| ---------- | ---------- | ------------------------------------------------------------ | ---- |
| name       | str        | 填写 definition 时，定义实例；忽略 definition 时，返回指令定义 | 必填 |
| definition | func / obj | 类型为 func 时，为函数指令（在 mounted 和 updated 调用）     | 可选 |

```javascript
import { createApp } from 'vue'
const app = createApp({})

// 注册
app.directive('my-directive', {
  // 指令具有一组生命周期钩子：
  // 在绑定元素的 attribute 或事件监听器被应用之前调用
  created() {},
  // 在绑定元素的父组件挂载之前调用
  beforeMount() {},
  // 在绑定元素的父组件挂载之后调用
  mounted() {},
  // 在包含组件的 VNode 更新之前调用
  beforeUpdate() {},
  // 在包含组件的 VNode 及其子组件的 VNode 更新之后调用
  updated() {},
  // 在绑定元素的父组件卸载之前调用
  beforeUnmount() {},
  // 在绑定元素的父组件卸载之后调用
  unmounted() {}
})

// 注册 (函数指令)
app.directive('my-directive', () => {
  // 这将被作为 `mounted` 和 `updated` 调用
})

// getter, 如果已注册，则返回指令定义
const myDirective = app.directive('my-directive')
```

#### 指令钩子参数

| 参数     | 说明                                                | 注意 |
| -------- | --------------------------------------------------- | ---- |
| el       | 绑定的元素，用于直接操作 DOM                        |      |
| binding  | 包含组件实例、传值、参数、修饰符等信息              | 只读 |
| vnode    | 虚拟节点，对应el                                    | 只读 |
| prevNode | 上一个虚拟节点，仅出现在 `beforeUpdate` / `updated` | 只读 |

#### binding参数解析

| 参数      | 说明                                              | 示例                                                   |
| --------- | ------------------------------------------------- | ------------------------------------------------------ |
| instance  | 使用指令的组件实例                                |                                                        |
| value     | 传递给指令的值                                    | `v-my-directive="1 + 1"` 对应 2                        |
| oldValue  | 先前的值，仅在 `beforeUpdate` 和 `updated` 中可用 | 只读                                                   |
| arg       | 传递给指令的参数                                  | `v-my-directive:foo` 对应 foo                          |
| modifiers | 包含修饰符的对象                                  | `v-my-directive.foo.bar` 对应 `{foo: true，bar: true}` |
| dir       | 在注册指令时作为参数传递                          |                                                        |



#### 传入多个值

如果指令需要多个值，可以传入对象

```vue
<div v-demo="{ color: 'white', text: 'hello!' }"></div>
```

```javascript
app.directive('demo', (el, binding) => {
  console.log(binding.value.color) // => "white"
  console.log(binding.value.text) // => "hello!"
})
```



#### 在元素/组件使用

当在组件中使用时，自定义指令总是会被应用在组件的根节点上。



### 例子-自动聚焦

```javascript
const app = Vue.createApp({})

// `v-focus`：当被绑定的元素挂载到 DOM 中时，聚焦元素
app.directive('focus', {
  mounted(el) {
    el.focus()
  }
})
```

```vue
<input v-focus />
```



### 例子-固定布局

> 控制通过固定布局将元素固定在页面上，可以传入参数和值来控制其固定的位置。

**定义**

```javascript
app.directive('pin', {
  mounted(el, binding) {
    el.style.position = 'fixed'
    // binding.arg 是我们传递给指令的参数
    const s = binding.arg || 'top'
    el.style[s] = binding.value + 'px'
  }
})
```

**使用**

```vue
<!-- 模板 -->
<p v-pin:right="200">I am pinned onto the page at 200px to the left.</p>
```

或使用[动态参数](https://v3.cn.vuejs.org/guide/template-syntax.html#动态参数)

```vue
<!-- 模板 -->
<p v-pin:[direction]="200">I am pinned onto the page at 200px to the left.</p>

<script setup lang="ts">
  const direction = "right";
</script>
```



### 例子-固定布局-增强

传给指令的值可以是动态的，以实现更好的交互

**定义**

```javascript
app.directive('pin', {
  mounted(el, binding) {
    el.style.position = 'fixed'
    const s = binding.arg || 'top'
    el.style[s] = binding.value + 'px'
  },
  updated(el, binding) {
    const s = binding.arg || 'top'
    el.style[s] = binding.value + 'px'
  }
})
```

:whale: 这里完全可以写成函数指令的形式

**使用**

```vue
<!-- 模板 -->
<p v-pin:[direction]="pinPadding">I am pinned onto the page at 200px to the left.</p>
<input type="range" min="0" max="500" v-model="pinPadding" />

<script setup lang="ts">
import { ref, onBeforeMount } from "vue";

const direction = "right";
const pinPadding = ref(100);

</script>
```



### 例子-复制到剪切板

这里给元素添加一个属性，用于记录最新的需要粘贴的值

```javascript
app.directive('copy', {
  mounted(el, { value }) {
    el.$value = value;
    el.handler = () => {
      if (!el.$value) {
        console.log('复制内容为空');
        return;
      }
      const aux = document.createElement('input');
      aux.setAttribute('value', el.$value);
      document.body.appendChild(aux);
      aux.select();
      document.execCommand('copy');
      document.body.removeChild(aux);
      console.log('复制成功');
    };
    el.addEventListener('click', el.handler);
  },
  updated(el, { value }) {
    el.$value = value;
  },
  unmounted(el) {
    el.removeEventListener('click', el.handler);
  },
})
```

```vue
<p v-copy="text">{{ text }}</p>
```

这里的打印可以替换为 UI 组件的弹出框，效果更好。



### 对比vue2

钩子的命名和定义不一样了

```javascript
App.directive('copy', {
  bind(el, { value }) {
    el.$value = value;
    el.handler = () => {
      if (!el.$value) {
        message.error('复制内容为空');
        return;
      }
      const aux = document.createElement('input');
      aux.setAttribute('value', el.$value);
      document.body.appendChild(aux);
      aux.select();
      document.execCommand('copy');
      document.body.removeChild(aux);
      message.success('复制成功');
    };
    el.addEventListener('click', el.handler);
  },
  update(el, { value }) {
    el.$value = value;
  },
  componentUpdated(el, { value }) {
    el.$value = value;
  },
  unbind(el) {
    el.removeEventListener('click', el.handler);
  },
})
```



### 封装思路

```elm
- directives
  + copy     // 各指令入口
    index.js
  + index.js // 出口
```

<span style="backGround: #efe0b9">directives/index.js</span>

```javascript
import copy from './copy';

const directives = {
  copy, // 同时命名
};

export default {
  install(app) {
    Object.keys(directives).forEach((key) => {
      app.directive(key, directives[key]);
    });
  },
};
```

<span style="backGround: #efe0b9">directives/copy/index.js</span>

```javascript
/* 对应 app.directive 的第二个参数 */
const Copy = {/* code */};

export default Copy;
```

<span style="backGround: #efe0b9">main.ts</span>

```javascript
import directives from './directives';

app.use(directives);
```



## 插件

> 可用于们向Vue全局添加一些功能。

**编写方式**

- <span style="color: #f7534f;font-weight:600">对象类型</span> 必须包含一个名为 <span style="color: #ff0000">install</span> 的方法，该方法会在安装插件时执行
- <span style="color: #f7534f;font-weight:600">函数类型</span> 在安装插件时自动执行函数



### 常见场景

| 依赖                        | 操作                   |
| --------------------------- | ---------------------- |
| app.component()             | 注册全局组件           |
| app.directive()             | 注册全局插件           |
| app.provide()               | 进行全局注入           |
| app.config.globalProperties | 添加全局属性，全局方法 |

### 编写函数类型

<span style="backGround: #efe0b9">plugins/plugins_function.js</span>

```javascript
export default function(app) {
  console.log(app);
}
```

:whale: 由于可以拿到传入的实例，能够进行全局添加属性，指令等

### 编写对象类型

<span style="backGround: #efe0b9">plugins/plugins_object.js</span>

```javascript
export default {
  install(app) {
    app.config.globalProperties.$name = "coderwhy"
  }
}
```

:whale: 定义全局变量时通常使用 `$` 作为前缀，以区分局部变量。

### 安装插件

<span style="backGround: #efe0b9">main.js</span>

```javascript
import { createApp } from 'vue'
import App from './03_自定义指令/App.vue'
import pluginObject from './plugins/plugins_object'
import pluginFunction from './plugins/plugins_function'

const app = createApp(App);

app.use(pluginObject);   // 安装
app.use(pluginFunction); // 安装

app.mount('#app');
```

**选项/setup中获取全局变量**

```javascript
import { getCurrentInstance } from "vue";

setup() {
  const instance = getCurrentInstance();
  console.log(instance.appContext.config.globalProperties.$name);
},
mounted() {
  console.log(this.$name);
},
```

### 获取配置项

```javascript
const demo = (a, b) => {
  console.log('获取到实例', a)
  console.log('获取到配置项', b)
}

const app = createApp(App);

app.use(demo, {
  hey: 'girl!'
})
```

本身会将在 app.use 中接收的第二个参数传递为安装方法的第二参。



# 内置组件

## KeepAlive

| 示例       | 说明                                                         |
| ---------- | ------------------------------------------------------------ |
| 可定制缓存 | 默认会缓存内部的所有组件实例，可通过 `include` 和 `exclude` 定制缓存组件 |
| 匹配方式   | 可以接收字符串、正则表达式，或数组；会根据组件的 [`name`](https://cn.vuejs.org/api/options-misc.html#name) 选项进行匹配 |
| name 选项  | 在 3.2.34 或以上的版本中，使用 `<script setup>` 的单文件组件， |
| name 选项  | 会自动根据文件名生成对应的 `name` 选项，无需再手动声明。     |
| 额外钩子   | 组件将被添加 onActivated 和 onDeactivated 两个钩子           |
| 额外钩子   | 这两个钩子适用于缓存的根组件，以及缓存树中的后代组件         |
| 更多配置   | 通过 max 可以配置缓存的最大组件实例数                        |

### 使用实例

基本使用

```vue
<!-- 非活跃的组件将会被销毁 -->
<component :is="activeComponent" />
```

默认情况下，组件实例在被替换掉后会被销毁

```vue
<!-- 非活跃的组件将会被缓存 -->
<KeepAlive>
  <component :is="activeComponent" />
</KeepAlive>
```



## Teleport

| 特性          | 说明                                                         |
| ------------- | ------------------------------------------------------------ |
| 使用场景      | 子组件添加到文档的指定位置，方便控制布局。仍能与父组件正常通信 |
| 禁用 Teleport | 不同终端需要使用不同布局效果时，可以添加 disabled 属性动态禁用 Teleport |

<span style="backGround: #efe0b9">index.html</span>

```html
<body>
  <div id="app"></div>
  <div id="demo"></div>
</body>
```

<span style="backGround: #efe0b9">Demo.vue</span>

```html
<template>
  <div>
  	<teleport to="body">
      <span>添加到body标签下</span>
    </teleport>
  
    <teleport to="#demo">
      <h2>内容1</h2>
      <hello-world></hello-world>
    </teleport>

    <teleport to="#demo">
      <span>内容2</span>
    </teleport>
  </div>
</template>
```

:whale: 可以将多个 `<Teleport>` 组件的内容挂载在同一个目标元素上。



## 动画

/



# 进阶主题

## 组合式API常见问答

| 特性             | 说明                                                         |
| ---------------- | ------------------------------------------------------------ |
| 非函数式编程     | 组合式 API 是以 Vue 中数据可变的、细粒度的响应性系统为基础的， |
| 非函数式编程     | 而函数式编程通常强调数据不可变                               |
| 更好的逻辑复用   | 解决 mixins 的缺陷                                           |
| 更灵活的代码组织 | 比起选项式API，可以将同一逻辑相关的代码归为一组              |
| 更好的类型推导   | 对于 TypeScript  的支持更加友好                              |
| 更小的包体积     | 比起选项式 API，对代码压缩也更友好                           |
| 选项式 API       | 对于中小型项目来说选项式 API 仍然是一个不错的选择            |
| 完全覆盖         | 组合式 API 能够覆盖所有状态逻辑方面的需求，如果使用 `<script setup>`， |
| 完全覆盖         | 那么 `inheritAttrs` 应该是唯一一个需要用额外的 `<script>` 块书写的选项 |





