# API

## 应用配置

每个 Vue 应用都会暴露一个包含其配置项的 `config` 对象：

```js
const app = createApp({})

console.log(app.config)
```



在<span style="color: #ff0000">挂载应用之前</span>，可以修改下列 property。

| property                                                 | 说明                                                         |
| -------------------------------------------------------- | ------------------------------------------------------------ |
| errorHandler                                             | 指定函数，处理组件抛出的未捕获错误（如弹出提示，替换控制台报红） |
| warnHandler                                              | 指定函数，处理运行时警告（仅开发环境生效，可追踪组件的继承关系追踪） |
| globalProperties                                         | 可添加全局中任何实例访问的全局属性（命名冲突时，取组件的；可替换 Vue2 的 Vue.prototype） |
| optionMergeStrategies                                    | 可更改通过mixin合并选项时，冲突的值以合并项为准，还是组件为准 |
| performance                                              | 配合浏览器开发工具的性能追踪                                 |
| compilerOptions <span style="color:#42b983;">3.1+</span> | 配置自定义元素、压缩空格行为、文本插值语法、生产保留模板内的 HTML 注释 |





## 应用API

调用 `createApp` 返回一个应用实例，该实例提供了一个应用上下文，该上下文提供了之前在 Vue 2.x 中的“全局”配置。

```js
import { createApp } from 'vue'

const app = createApp({})
```

由于 `createApp` 方法返回应用实例本身，因此可以在其后链式调用其它方法



| property  | 说明                                                         |
| --------- | ------------------------------------------------------------ |
| component | 定义全局组件/获取定义                                        |
| config    | 包含应用配置的对象                                           |
| directive | 定义全局组件指令/获取定义                                    |
| mixin     | 全局混入，**不建议在应用代码中使用**，编写插件可以用         |
| mount     | 所提供 DOM 元素的 `innerHTML` 将被替换为应用根组件的模板渲染结果 |
| provide   | 设置可以被注入到应用范围内所有组件中的值                     |
| unmount   | 卸载应用实例                                                 |
| use       | 安装插件                                                     |
| version   | 提供版本号，对某些插件有用                                   |

use 接收两种类型的参数

- 对象，必须存在一个 install 方法，其会被调用
- 函数，会被作为 install 方法来调用

该 `install` 方法将以应用实例作为第一个参数被调用。传给 `use` 的其他参数将作为后续参数传入该安装方法。



## 全局API

对于 ES 模块，它们需要从 vue 中导入

```js
import { createApp, h, nextTick } from 'vue'
```

还有一些处理响应性的全局函数，如 `reactive` 和 `ref`，其文档编写在其他地方



| API                                                          | 说明                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| createApp                                                    | 创建应用实例，它提供的应用上下文供整个组件树共享             |
| h                                                            | 可生成虚拟节点，用于渲染函数                                 |
| defineComponent                                              | 接收的对象参数会直接返回；但返回值增加了类型处理，以支持TSX 和 IDE 工具 |
| defineAsyncComponent                                         | 创建只有在需要时才会加载的异步组件                           |
| defineCustomElement <span style="color:#42b983;">3.2+</span> | 参数同 defineComponent，但返回原生的[自定义元素](https://developer.mozilla.org/zh-CN/docs/Web/Web_Components/Using_custom_elements) |
| resolveComponent                                             | 按名称解析 `component`，返回 `Component`                     |
| resolveDynamicComponent                                      | 允许使用与 `<component :is="">` 相同的机制来解析一个 `component` |
| resolveDirective                                             | 解析 `directive`，返回指令                                   |
| withDirectives                                               | 应用于 **VNode**，使用指令                                   |
| createRenderer                                               | /                                                            |
| nextTick                                                     | 将回调推迟到下一个 DOM 更新周期之后执行                      |
| mergeProps                                                   | 应用于 **VNode**，合并 prop  对象                            |
| useCssModule                                                 | 允许在 `setup` 的单文件组件函数中访问 <span style="color: slategray">CSS 模块</span> |
| version                                                      | Vue 的版本号                                                 |



## 选项式API

### Data

| property | 说明                                                  | 类型     |
| -------- | ----------------------------------------------------- | -------- |
| data     | 创建示例的数据，具有响应式                            | func     |
| props    | 自定义属性                                            | arr，obj |
| computed | 计算属性                                              | obj      |
| methods  | 方法                                                  | obj      |
| watch    | 侦听器                                                | obj      |
| emits    | 记录组件示例的自定义事件，可以对其校验                | arr，obj |
| expose   | 将组件示例上的 property 暴露出去，如通过 `$refs` 访问 | arr      |

### DOM

| property | 说明                                  | 类型 |
| -------- | ------------------------------------- | ---- |
| template | 字符串模板，用作 component 实例的标记 | str  |
| render   | template之外的另一选择，优先级更高    | func |



### 生命周期钩子

所有生命周期钩子的 `this` 上下文将自动绑定至实例中，因此可以访问 data、computed 和 methods。

| 钩子            | 对应setup         | 调用时机                       | 说明                                       |
| --------------- | ----------------- | ------------------------------ | ------------------------------------------ |
| beforeCreate    | 使用 setup()      | 实例初始化后                   | str                                        |
| created         | 使用 setup()      | 实例创建后                     | 未挂载，且 `$el` property 目前尚不可用     |
| beforeMount     | onBeforeMount     | 挂载开始之前                   |                                            |
| mounted         | onMounted         | 实例挂载完成后                 | **不会**保证所有的子组件也都被挂载完成     |
| beforeUpdate    | onBeforeUpdate    | DOM 被更新之前                 |                                            |
| updated         | onUpdated         | DOM 被更新之后                 | **不会**保证所有的子组件也都被重新渲染完毕 |
| activated       | onActivated       | 被 keep-alive 缓存的组件激活时 |                                            |
| deactivated     | onDeactivated     | 被 keep-alive 缓存的组件失活时 |                                            |
| beforeUnmount   | onBeforeUnmount   | 在卸载组件实例之前调用         |                                            |
| unmounted       | onUnmounted       | 卸载组件实例后调用             |                                            |
| errorCaptured   | onErrorCaptured   | 捕获一个来自后代组件的错误     |                                            |
| renderTracked   | onRenderTracked   | 跟踪虚拟 DOM 重新渲染          |                                            |
| renderTriggered | onRenderTriggered | 虚拟 DOM 重新渲染被触发        |                                            |

如果你希望等待整个视图都渲染完毕，可以在 `mounted` 内部使用 [vm.$nextTick](https://v3.cn.vuejs.org/api/instance-methods.html#nexttick)

如果你希望等待整个视图都渲染完毕，可以在 `updated` 内部使用 [vm.$nextTick](https://v3.cn.vuejs.org/api/instance-methods.html#nexttick)





### 选项/资源

| property   | 说明                       | 类型 |
| ---------- | -------------------------- | ---- |
| directives | 声明组件实例中的指令       | obj  |
| components | 声明可用于组件实例中的组件 | obj  |



### 组合

| property         | 说明                                     | 类型       |
| ---------------- | ---------------------------------------- | ---------- |
| mixins           | 支持的混入                               | `arr<obj>` |
| extends          | 功能与 mixins 一致，但语义上表示为继承   | obj        |
| provide / inject | 允许祖先组件向其所有子孙后代注入一个依赖 |            |
| setup            | 组合式 API 的入口                        | func       |

<span style="color: #f7534f;font-weight:600">setup</span> 在创建组件实例时，在初始 prop 解析之后立即调用 `setup`。在生命周期方面，它是在 [beforeCreate](https://v3.cn.vuejs.org/api/options-lifecycle-hooks.html#beforecreate) 钩子之前调用的。



### 杂项

| property                                                 | 说明                                  | 类型 |
| -------------------------------------------------------- | ------------------------------------- | ---- |
| name                                                     |                                       | str  |
| inheritAttrs                                             | 禁止组件的根元素继承 attribute        | boo  |
| compilerOptions <span style="color:#42b983;">3.1+</span> | 配置与应用级别的 compilerOptions 相同 | obj  |





## 实例属性

| property | 说明                                                         | 类型         |
| -------- | ------------------------------------------------------------ | ------------ |
| $data    | 组件示例的 data                                              | obj          |
| $props   | 组件示例的 props                                             | obj          |
| $el      | 根 DOM 元素                                                  | any          |
| $options | 获取实例的初始化选项                                         | obj          |
| $parent  | 父实例，如果当前实例有的话                                   | Vue instance |
| $root    | 当前组件树的根组件实例                                       | Vue instance |
| $slots   | 用来以编程方式访问通过[插槽分发](https://v3.cn.vuejs.org/guide/component-basics.html#通过插槽分发内容)的内容，常用于渲染函数 | obj          |
| $refs    | 包含所有添加了 ref 属性的 DOM 元素和组件实例                 | obj          |
| $attrs   | 包含了父作用域中不作为组件 [props](https://v3.cn.vuejs.org/api/options-data.html#props) 或 [自定义事件 ](https://v3.cn.vuejs.org/api/options-data.html#emits)的 attribute 绑定和事件 | obj          |



## 实例方法

| property     | 说明                                  |
| ------------ | ------------------------------------- |
| $watch       |                                       |
| $emit        | 触发当前实例上的事件                  |
| $forceUpdate | 迫使组件实例重新渲染                  |
| $nextTick    | 将回调延迟到下次 DOM 更新循环之后执行 |



## 内置组件

| 组件             | 说明                                                         |
| ---------------- | ------------------------------------------------------------ |
| component        | 渲染一个“元组件”为动态组件。依 `is` 的值，来决定哪个组件被渲染 |
| transition       | 提供了**单个**元素/组件的过渡效果                            |
| transition-group | 提供了**多个**元素/组件的过渡效果                            |
| keep-alive       | 包裹动态组件时，会缓存（代替销毁）不活动的组件实例           |
| slot             | 作为组件模板之中的内容分发插槽。`<slot>` 元素自身将被替换    |
| teleport         | 移动实际的 DOM 节点到目标元素上                              |

component 的 is 可以接收的参数类型有：str（标签名/组件名）/ Component / VNode

transition 和 transition-group 把过渡效果应用到其包裹的内容上，而不会额外渲染 DOM 元素



## 指令

| 指令                                            | 说明                                                         |
| ----------------------------------------------- | ------------------------------------------------------------ |
| v-text                                          | 更新元素的内容                                               |
| v-html                                          | 更新元素的 [innerHTML](https://developer.mozilla.org/en-US/docs/Web/API/Element/innerHTML)，渲染 HTML |
| v-show                                          | v-if、v-else、v-else-if、 v-for、v-on、v-bind、v-model       |
| v-slot                                          | 提供具名插槽，可以接收 prop                                  |
| v-pre                                           | 跳过这个元素和它的子元素的编译过程，可以显示原始 {{}}        |
| v-cloak                                         | /                                                            |
| v-once                                          | 只渲染元素和组件**一次**，随后的重新渲染时，它与子元素的内容将被视为静态内容并跳过 |
| v-memo <span style="color:#42b983;">3.2+</span> | 仅供性能敏感场景的针对性优化，会用到的场景应该很少。渲染 <span style="color: #a50">v-for</span> 长列表 (长度大于 1000) 可能是它最有用的场景 |



## 特殊属性

| 指令 | 说明                                                         |
| ---- | ------------------------------------------------------------ |
| key  | 主要用于虚拟 DOM 算法，常与 <span style="color: #a50">v-for</span> 一起使用 |
| ref  | 用来给元素或子组件注册引用信息                               |
| is   | 使用动态组件                                                 |

key 可以用于强制替换元素/组件而不是重复使用它，可以 [用于](https://v3.cn.vuejs.org/api/special-attributes.html#key) <span style="color: #ff0000">完整地触发组件的生命周期钩子 / 触发过渡</span>

有相同父元素的子元素必须有<span style="color: #ff0000">唯一的 key</span>。重复的 key 会造成渲染错误



## 组合式API

### setup

使用 `setup` 作为组合式 API 的入口。在组件被创建之前，`props` 被解析之后执行。



#### 使用模板

```vue
<!-- MyBook.vue -->
<template>
  <div>{{ readersNumber }} {{ book.title }}</div>
</template>

<script>
  import { ref, reactive } from 'vue'

  export default {
    setup() {
      const readersNumber = ref(0)
      const book = reactive({ title: 'Vue 3 Guide' })

      // 暴露给模板
      return {
        readersNumber,
        book
      }
    }
  }
</script>
```



#### 使用渲染函数

```javascript
import { h, ref, reactive } from 'vue'

export default {
  setup() {
    const readersNumber = ref(0)
    const book = reactive({ title: 'Vue 3 Guide' })
    
    expose({
      book
    })
    
    // 请注意，在这里需要显式地使用 ref 值
    return () => h('div', [readersNumber.value, book.title])
  }
}
```

如果需要将 property 暴露给外部访问，比如通过父组件的 `ref`，可以使用 `expose`。



