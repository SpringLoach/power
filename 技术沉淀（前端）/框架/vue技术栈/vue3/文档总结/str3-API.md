## 全局API

### 应用示例

| 方法/属性       | 说明                                                         |
| --------------- | ------------------------------------------------------------ |
| createApp()     | 创建一个应用实例                                             |
| createSSRApp()  | 以 <span style="color: #a50">SSR 激活</span> 模式创建一个应用实例 |
| app.mount()     | 将应用实例挂载在一个容器元素中（innerHTML）                  |
| app.unmount()   | 卸载应用实例                                                 |
| app.provide()   | 提供的值，可以在应用中的所有后代组件中使用                   |
| app.component() | 定义全局组件/获取定义                                        |
| app.directive() | 定义全局指令/获取定义                                        |
| app.use()       | 安装插件                                                     |
| app.mixin()     | 全局混入，主要为了向后兼容，不建议使用                       |
| app.version     | 提供 Vue 版本号，对某些插件有用                              |
| app.config      | 包含应用配置的对象                                           |



**app.config 的配置项**

| property                                                 | 说明                                                         |
| -------------------------------------------------------- | ------------------------------------------------------------ |
| errorHandler                                             | 为应用内抛出的未捕获错误配置全局处理函数（如弹出提示，替换控制台报红） |
| warnHandler                                              | 为运行时警告配置处理函数（仅开发环境生效，可追踪组件的继承关系追踪） |
| performance                                              | 配合浏览器开发工具的性能追踪                                 |
| compilerOptions <span style="color:#42b983;">3.1+</span> | 配置自定义元素、压缩空格行为、文本插值语法、生产保留模板内的 HTML 注释 |
| globalProperties                                         | 添加全局属性/方法（命名冲突时取组件的；替换 Vue2 的 Vue.prototype） |
| optionMergeStrategies                                    | 可更改通过mixin合并选项时，冲突的值以合并项为准，还是组件为准 |

在<span style="color: #ff0000">挂载应用之前</span>，可以修改上面的 property。



### 通用

| 方法/属性              | 说明                                                         |
| ---------------------- | ------------------------------------------------------------ |
| version                | 暴露当前所使用的 Vue 版本                                    |
| nextTick()             | 将回调推迟到下一个 DOM 更新周期之后执行                      |
| defineComponent()      | 接收的对象参数会直接返回；但为组件提供了类型推导             |
| defineAsyncComponent() | 创建只有在使用时才会加载的异步组件                           |
| defineCustomElement()  | 参数同 defineComponent，但返回原生的 <span style="color: #a50">自定义元素</span> |



## 组合式API

### setup()

比起 *setup* 钩子， 官方更推荐使用 <script setup> 语法

使用 *setup* 作为组合式 API 的入口。在组件被创建之前，<span style="color: #a50">props</span> 被解析之后执行。



#### 基本使用

```vue
<!-- MyBook.vue -->
<template>
  <div>{{ readersNumber }} {{ book.title }}</div>
</template>

<script>
  import { ref, reactive } from 'vue'

  export default {
    setup(props, { attrs, slots, emit, expose }) {
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

:whale: 如果需要解构 props，为了不失去响应式，应该借助 toRef 和 toRefs；

:whale: context 对象是非响应式的，故可以安全地解构。



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
    
    // 请注意，在这里需要显式地使用 value 值
    return () => h('div', [readersNumber.value, book.title])
  }
}
```

如果需要将 property 暴露给外部访问，比如通过父组件的 `ref`，可以使用 `expose`。



### 响应式：核心

要使用这些API，需要从 vue 中导出

```javascript
import { ref, reactive } from 'vue'
```

| API                                                      | 说明                                                         |
| -------------------------------------------------------- | ------------------------------------------------------------ |
| ref                                                      | 返回接收值（即内部值）的响应式代理                           |
| ref                                                      | 本身只有一个 value 属性，为接收值                            |
| ref                                                      | 接收对象时，会通过 reactive 处理，响应是深层的               |
| computed                                                 | 接收函数（getter），根据返回值创建不可变的 ref               |
| computed                                                 | 接收对象（具有 get 和 set 函数），创建可写的 ref             |
| reactive                                                 | 深层地进行响应式转换                                         |
| reactive                                                 | 应用于普通<span style="color: #a50">对象</span>，可以返回对象的响应式副本 |
| reactive                                                 | 使用 ref 的<span style="color: #ff0000">对象</span>属性会被代理自动解包 |
| reactive                                                 | 使用 ref 的<span style="color: #ff0000">数组等集合</span>元素不会被代理自动解包 |
| readonly                                                 | 接收响应式 / 纯对象 / ref 并返回只读代理，只读代理是深层的   |
| readonly                                                 | 自动解包 ref                                                 |
| watchEffect                                              | 接收函数，立即执行，并在其依赖变更时重新运行该函数           |
| watchPostEffect <span style="color:#42b983;">3.2+</span> | 即 watchEffect，且 `flush: 'post'`                           |
| watchSyncEffect <span style="color:#42b983;">3.2+</span> | 即 watchEffect，且 `flush: 'sync'`                           |
| watch                                                    | 默认不会立即执行，仅在侦听源发生变化时被调用                 |
| watch                                                    | 对比 watchEffect，可以获取状态的先前值和当前值               |
| watch                                                    | 侦听器数据源可以是具有返回值的 getter 函数，或 ref           |
| watch                                                    | 侦听器还可以使用数组以同时侦听多个源                         |
| watch                                                    | 与 watchEffect，在手动停止侦听、清除副作用、刷新时机和调试方面行为相同 |
| watch                                                    | 常用配置项有 immediate、deep、flush                          |

#### computed-只读

```javascript
const count = ref(1)
const plusOne = computed(() => count.value + 1)

console.log(plusOne.value) // 2

plusOne.value++ // 错误
```

#### computed-读写

```javascript
const count = ref(1)
const plusOne = computed({
  get: () => count.value + 1,
  set: val => {
    count.value = val - 1
  }
})

plusOne.value = 1
console.log(count.value) // 0
```



#### reactive-添加响应

```javascript
const obj = reactive({ count: 0 })
```

#### reactive-解包ref

将解包所有深层的 ref，同时维持 ref 的响应性

```javascript
const count = ref(1)
const obj = reactive({ count })

// ref 会被解包
console.log(obj.count === count.value) // true

// 它会更新 `obj.count`
count.value++
console.log(count.value) // 2
console.log(obj.count) // 2

// 它也会更新 `count` ref
obj.count++
console.log(obj.count) // 3
console.log(count.value) // 3
```

#### reactive-接收ref

当将 ref 分配给 reactive 实例的属性时，ref 将被自动解包

```javascript
const count = ref(1)
const obj = reactive({})

obj.count = count

console.log(obj.count) // 1
console.log(obj.count === count.value) // true
```



#### watch-侦听单一源

```javascript
// 侦听一个 getter
const state = reactive({ count: 0 })
watch(
  () => state.count,
  (count, prevCount) => {
    /* ... */
  }
)

// 直接侦听一个 ref
const count = ref(0)
watch(count, (count, prevCount) => {
  /* ... */
})
```

#### watchEffect-停止侦听

```javascript
const stop = watchEffect(() => {})

// 当不再需要此侦听器时:
stop()
```

可以显式调用返回值以停止侦听

在组件的 setup 选项或生命周期钩子中调用时，能够在组件卸载时自动停止

#### watchEffect-清除副作用

对于一些异步的逻辑，在其返回结果前，我们可能希望它们被清除。watchEffect 本身传入一个参数，该参数方法接收一个函数

```javascript
watchEffect(onInvalidate => {
  const token = performAsyncOperation(id.value)
  onInvalidate(() => {
    token.cancel()
  })
})
```

函数将会在副作用即将重新执行时/组件卸载时调用。



场景：对于可能发生的连续请求，只需要最新的结果

```javascript
const data = ref(null)
watchEffect(async onInvalidate => {
  // 在Promise解析之前注册清除函数
  onInvalidate(() => {
    /* ... */
  })
  data.value = await fetchData(props.id)
})
```



#### watchEffect-副作用刷新时机

副作用函数会被缓存，并异步调用，来避免同个 “tick” 中由于多个状态改变导致的重复调用。

```vue
<template>
  <div>{{ count }}</div>
</template>

<script>
export default {
  setup() {
    const count = ref(0)

    watchEffect(() => {
      console.log(count.value)
    })

    return {
      count
    }
  }
}
</script>
```

- `count` 会在初始运行时同步打印出来
- 更改 `count` 时，将在组件更新<span style="color: #ff0000">前</span>执行副作用



通过配置 `flush: 'post'`，可以在组件更新<span style="color: #ff0000">后</span>重新运行侦听器副作用

```js
// 在组件更新后触发，这样你就可以访问更新的 DOM。
// 注意：这也将推迟副作用的初始运行，直到组件的首次渲染完成。
watchEffect(
  () => {
    /* ... */
  },
  {
    flush: 'post'
  }
)
```

- pre 组件更新前运行

- post 组件更新后运行

- ync 强制效果始终同步触发（低效的，应该很少需要）



### 响应式：工具

| API        | 说明                                                         |
| ---------- | ------------------------------------------------------------ |
| isRef      | 检查某个值是否为 ref 对象                                    |
| unref      | 如果参数是 ref，则返回内部值，否则返回参数本身               |
| toRef      | 为源响应式对象上的某个属性新创建一个 ref，且保持对其源属性的响应式连接 |
| toRef      | 在使用可选 prop 时特别有用，即使源属性不存在，也会创建 ref   |
| toRefs     | 将响应式对象转换为普通对象，但返回对象的每个属性都是指向源属性的 ref |
| toRefs     | 可以在不丢失响应性的情况下对返回的对象进行解构               |
| toRefs     | 只会为源对象中包含的属性生成 ref                             |
| isProxy    | 检查一个对象是否是由深浅 reactive、readonly 创建的代理       |
| isReactive | 检查一个对象是否是由深浅 reactive 创建的代理                 |
| isReadonly | 检查一个对象是否是由深浅 readonly 创建的代理                 |

#### toRef-可选prop

```javascript
export default {
  setup(props) {
    useSomeFeature(toRef(props, 'foo'))
  }
}
```

可选 prop 并不会被 toRefs 处理，但是 toRef 依旧返回一个可用的 ref。

#### toRefs-解构响应式对象

```javascript
function useFeatureX() {
  const state = reactive({
    foo: 1,
    bar: 2
  })

  // 操作 state 的逻辑

  // 返回时转换为ref
  return toRefs(state)
}

export default {
  setup() {
    // 可以在不失去响应性的情况下解构
    const { foo, bar } = useFeatureX()

    return {
      foo,
      bar
    }
  }
}
```



### 响应式：进阶

| API             | 说明                                                         |
| --------------- | ------------------------------------------------------------ |
| shallowRef      | 创建浅层响应的 ref                                           |
| triggerRef      | 手动执行与 shallowRef 关联的任何作用 (effect)                |
| customRef       | 创建自定义的 ref，可以显式控制其依赖项跟踪和更新触发         |
| shallowReactive | 浅层地进行响应式转换                                         |
| shallowReactive | 使用 ref 的属性<span style="color: green">不会</span>被代理自动解包 |
| shallowReadonly | 返回只读代理，只读代理是浅层的                               |
| shallowReadonly | 使用 ref 的属性<span style="color: green">不会</span>被代理自动解包 |
| toRaw           | 返回深浅 reactive 或 readonly 代理的原始对象                 |
| markRaw         | 标记一个对象，使其永远不会转换为代理                         |
| effectScope     | 创建 effect 作用域对象，以捕获在其内部创建的响应式 effect (例如计算属性或侦听器)，使得这些 effect 可以一起被处理 |
| getCurrentScope | 如果有，则返回当前活跃的 effect 作用域                       |
| onScopeDispose  | 在当前活跃的 effect 作用域上注册一个处理回调                 |



### 生命周期钩子

对于选项式API，所有生命周期钩子的 `this` 上下文将自动绑定至实例中，因此可以访问 data、computed 和 methods。

| 钩子            | 对应setup         | 调用时机                           | 说明                                       |
| --------------- | ----------------- | ---------------------------------- | ------------------------------------------ |
| beforeCreate    | 使用 setup()      | 实例初始化后                       |                                            |
| created         | 使用 setup()      | 实例创建后                         | 未挂载，且 `$el` property 目前尚不可用     |
| beforeMount     | onBeforeMount     | 挂载开始之前                       |                                            |
| mounted         | onMounted         | 实例挂载完成后                     | **不会**保证所有的子组件也都被挂载完成     |
| beforeUpdate    | onBeforeUpdate    | DOM 被更新之前                     |                                            |
| updated         | onUpdated         | DOM 被更新之后                     | **不会**保证所有的子组件也都被重新渲染完毕 |
| activated       | onActivated       | 被 keep-alive 缓存的组件激活时     |                                            |
| deactivated     | onDeactivated     | 被 keep-alive 缓存的组件失活时     |                                            |
| beforeUnmount   | onBeforeUnmount   | 在卸载组件实例之前调用             |                                            |
| unmounted       | onUnmounted       | 卸载组件实例后调用                 |                                            |
| errorCaptured   | onErrorCaptured   | 捕获一个来自后代组件的错误         |                                            |
| renderTracked   | onRenderTracked   | 跟踪虚拟 DOM 重新渲染              |                                            |
| renderTriggered | onRenderTriggered | 虚拟 DOM 重新渲染被触发            |                                            |
|                 | onServerPrefetch  | 在组件实例在服务器上被渲染之前调用 | SSR only                                   |

如果你希望等待整个视图都渲染完毕，可以在 `mounted` 内部使用 [vm.$nextTick](https://v3.cn.vuejs.org/api/instance-methods.html#nexttick)

如果你希望等待整个视图都渲染完毕，可以在 `updated` 内部使用 [vm.$nextTick](https://v3.cn.vuejs.org/api/instance-methods.html#nexttick)



### 依赖注入

| API     | 说明                           |
| ------- | ------------------------------ |
| provide | 提供一个值，可以被后代组件注入 |
| inject  | 使用祖先元素提供的值           |



## 内置内容

### 指令

| 指令                                            | 说明                                                         |
| ----------------------------------------------- | ------------------------------------------------------------ |
| v-text                                          | 更新元素的文本内容                                           |
| v-html                                          | 更新元素的 [innerHTML](https://developer.mozilla.org/en-US/docs/Web/API/Element/innerHTML)，渲染 HTML |
| v-show                                          | v-if、v-else、v-else-if、 v-for、v-on、v-bind、v-model       |
| v-slot                                          | 提供具名插槽，可以接收 prop                                  |
| v-pre                                           | 跳过这个元素和它的子元素的编译过程，模板语法都会被保留并按原样渲染。可以显示原始 {{}} |
| v-once                                          | 仅渲染元素和组件（及子项）一次，并跳过之后的更新             |
| v-memo <span style="color:#42b983;">3.2+</span> | 仅供性能敏感场景的针对性优化，会用到的场景应该很少。渲染 <span style="color: #a50">v-for</span> 长列表 (长度大于 1000) 可能是它最有用的场景 |
| v-cloak                                         | 隐藏尚未完成编译的 DOM 模板                                  |



### 组件

| 组件             | 说明                                               |
| ---------------- | -------------------------------------------------- |
| transition       | 提供了**单个**元素/组件的过渡效果                  |
| transition-group | 提供了**多个**元素/组件的过渡效果                  |
| keep-alive       | 包裹动态组件时，会缓存（代替销毁）不活动的组件实例 |
| teleport         | 移动实际的 DOM 节点到目标元素上                    |
| suspense         | 用于协调对组件树中嵌套的异步依赖的处理             |

两个过渡组件会把过渡效果应用到其包裹的内容上，而不会额外渲染 DOM 元素

在渲染函数中使用它们时，需要显式导入。



### 特殊元素

| 组件      | 说明                                                         |
| --------- | ------------------------------------------------------------ |
| component | 用于渲染动态组件或元素的“元组件”。要渲染的实际组件由 `is` 属性 决定 |
| slot      | 作为组件模板之中的内容分发插槽。`<slot>` 元素自身将被替换    |

component 的 is 可以接收的参数类型有：str（HTML 标签名/组件名）/ Component / VNode



### 特殊属性

| 指令 | 说明                                                         |
| ---- | ------------------------------------------------------------ |
| key  | 主要用于虚拟 DOM 算法，常与 <span style="color: #a50">v-for</span> 一起使用 |
| ref  | 用来引用元素或子组件                                         |
| is   | 用于绑定动态组件                                             |

key 可以用于强制替换元素/组件而不是重复使用它，可以用于<span style="color: #ff0000">完整地触发组件的生命周期钩子 / 触发过渡</span>

有相同父元素的子元素必须有<span style="color: #ff0000">唯一的 key</span>。重复的 key 会造成渲染错误



## 单文件组件

*<script setup>*
/



## 进阶API

### TypeScript工具类型

*PropType<T>*

用于在用运行时 props 声明时给一个 prop 标注更复杂的类型定义。

```javascript
import { PropType } from 'vue'

interface Book {
  title: string
  author: string
  year: number
}

export default {
  props: {
    book: {
      // 提供一个比 `Object` 更具体的类型
      type: Object as PropType<Book>,
      required: true
    }
  }
}
```



### 渲染函数和自定义渲染

| API              | 说明                                   |
| ---------------- | -------------------------------------- |
| h                | 可生成虚拟节点 (vnode)，用于渲染函数   |
| mergeProps       | 合并 prop  对象                        |
| cloneVNode       | 克隆一个 vnode                         |
| isVNode          | 判断一个值是否为 vnode 类型            |
| resolveComponent | 按名称手动解析已注册的组件             |
| resolveDirective | 按名称手动解析已注册的指令             |
| withDirectives   | 给 vnode 增加自定义指令                |
| withModifiers    | 用于向事件处理函数添加内置 v-on 修饰符 |
| createRenderer   | 创建自定义渲染器                       |

