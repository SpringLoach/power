## ----基础----

### 模板语法

| 要点             | 说明                                                         |
| ---------------- | ------------------------------------------------------------ |
| 模板语法         | 可以结合可选的 JSX 支持直接手写渲染函数而不采用模板，        |
| 模板语法         | 但这将不会享受到和模板同等级别的编译时优化                   |
| 模板访问全局对象 | 模板中的表达式仅能访问内部配置了的全局对象                   |
| 模板访问全局对象 | 可以在 app.config.globalProperties 上显性添加                |
| 动态参数         | 动态参数的计算值只能为 str / null，后者表示移除绑定          |
| 动态参数的限制   | 存在限制，无法使用空格和引号等，可以使用计算属性代替         |
| 动态参数的限制   | 如果不是单文件组件内的模板，避免动态参数名使用大写字母：会被转换为小写 |



#### 指令参数

```javascript
<a v-bind:href="url"> ... </a>

<!-- 简写 -->
<a :href="url"> ... </a>
```

```javascript
<a v-on:click="doSomething"> ... </a>

<!-- 简写 -->
<a @click="doSomething"> ... </a>
```



#### 指令动态参数

```javascript
<a v-bind:[argument]="url"> ... </a>

<!-- 简写 -->
<a :[argument]="url"> ... </a>
```

```javascript
<a v-on:[argument]="doSomething"> ... </a>

<!-- 简写 -->
<a @[argument]="doSomething">
```

> 这里的 argument 将作为表达式执行，允许是组件实例的数据属性

![指令语法图](.\img\directive.69c37117.png)



### 响应式基础



| 特点                  | 说明                                                         |
| --------------------- | ------------------------------------------------------------ |
| setup vs script setup | 前者需要将模板使用到的状态和方法暴露，比较繁琐               |
| setup vs script setup | 后者顶层的导入和变量声明可在同一组件的模板中直接使用         |
| 获取更新 DOM          | 访问更新后的 DOM 需要使用 <span style="color: #a50">nextTick</span> |
| 响应式特征            | 响应式一般是深层的，除非使用特殊的 API                       |
| 响应式特征            | 只有代理对象是响应式的，更改原始对象不会触发更新             |
| 最佳实践              | 使用 Vue 的响应式系统的最佳实践是 *仅使用声明对象的代理版本* |
| 响应式特征            | 依靠深层响应性，响应式对象内的嵌套<span style="color: #ff0000">对象</span>依然是代理（属性不是） |
| reactive 缺陷         | 仅对对象类型有效，对原始类型无效                             |
| reactive 缺陷         | 解构时失去响应式                                             |
| ref 特征              | 可以为任何值类型创建响应式对象                               |
| ref 特征              | 能够在不丢失响应性的前提下传递引用，在组合函数中很有用       |
| ref 在模板中的解包    | 在模板中作为顶层属性被访问时，它们会被自动解包               |
| ref 在模板中的解包    | 作为对象属性在模板中使用，结合表达式时，不会解包             |
| ref 在模板中的解包    | 作为对象属性在模板中使用，且为计算最终值时，也会解包         |
| 新特征                | 响应性语法糖可以免除取 ref 时添加 value 的烦恼，但仍在实验阶段 |
| 计算属性              | 对于模板中的复杂逻辑，写成计算属性更清晰，且可复用           |
| 计算属性              | 会返回一个计算属性 ref，在模板中会自动解包                   |
| 计算属性              | 会基于其响应式依赖被缓存，只有内部响应式依赖变化时，重新计算 |
| 计算属性              | 同时提供 get 和 set 方法将会创建<span style="color: #ff0000">可写</span>计算属性 |



#### ref 在响应式对象中的解包

当一个 *ref* 被嵌套在一个深层响应式对象中，作为属性访问 / 更改时，会自动解包；

当 *ref* 作为响应式数组或像 Map 这种原生集合类型的元素被访问时，不会进行解包。

```javascript
const state = reactive({
  count: ref(0)
})

console.log(state.count) // 0
```

```javascript
const books = reactive([ref(0)])

// 这里需要 .value
console.log(books[0].value) // 0
```



### 类与样式绑定

| 特点     | 说明                                                         |
| -------- | ------------------------------------------------------------ |
| 模板使用 | class 和 :class 可以结合使用                                 |
| 动态样式 | 可以绑定为对象类型数据属性，包括返回对象类型的计算属性       |
| 动态样式 | 也可以绑定到数组上（鸡肋）                                   |
| 继承     | 对于只有一个根元素的组件，会接收父组件添加的类和样式         |
| 继承     | 存在多个根元素的组件，可以自行指定谁来继承                   |
| 模板使用 | 动态样式能够接收 camelCase 或引号包围的 kebab-cased 的键     |
| 特征     | 如浏览器不支持某些样式属性，动态样式将自动添加相应的浏览器前缀 |



### 条件渲染

需要切换不带根的多个元素时，可以将 v-if 与 teamplate 结合使用



### 列表渲染

| 特征    | 说明                                                         |
| ------- | ------------------------------------------------------------ |
| *v-for* | 指令的值需要使用 `item in items` 形式的特殊语法              |
| *v-for* | 也可以使用 `of` 作为分隔符来替代 `in`                        |
| *v-for* | 可以用于遍历数组、对象、整数值                               |
| *v-for* | 可以在 `<template>` 标签上使用 `v-for` 来渲染一个包含多个元素的块 |
| 使用    | 不推荐一个节点上同时使用 v-for 和 v-if；                     |
| 使用    | v-if 优先级更高，故在标签中获取不到 v-for 作用域的变量；     |
| 使用    | 可以在外面加 template 循环来解决该问题                       |
| 使用    | 不要用对象作为 `v-for` 的 key，可以使用 str / num            |
| 其它    | 原来能够改变 arr 的数组方法，也能改变响应式的 arr            |



### 事件处理

| 特征   | 说明                                                  |
| ------ | ----------------------------------------------------- |
| 修饰符 | 可以实现监听自身/阻止事件/不阻止事件/仅执行一次等操作 |
| 修饰符 | 可以通过按键修饰符监听特定按键，甚至是鼠标按键        |



#### 访问事件参数

```vue
<!-- 使用特殊的 $event 变量 -->
<button @click="dos('add', $event)">
  Submit
</button>

<!-- 使用内联箭头函数 -->
<button @click="(event, event2) => dos('edit', event, event2)">
  Submit
</button>
```



### 表单输入绑定

- 结合组件中使用 [v-model](https://cn.vuejs.org/guide/components/events.html#usage-with-v-model)



| 项         | 示例       | 说明                                                         |
| ---------- | ---------- | ------------------------------------------------------------ |
| sync       | vue2       | 在 vue2 中，帮助实现多次双向绑定                             |
| v-model    | vue3       | 在 vue3 中，依靠指定参数，也能实现多次双向绑定               |
| 不同控件   |            | *v-model* 用于不同类型的表单控件，会组合不同的属性和事件     |
| 绑定值     |            | 应该使用响应式的 API 声明初始值                              |
| 演示       |            | 官方有对于原生的 文本域/复选框/单选按钮/选择器 的绑定演示    |
| 内置属性   | true-value | 对于原生控件的某些原布尔值，可以通过 true-value/false-value 修改选中值 |
| 修饰符     | .lazy      | 监听 `change` 事件而不是 `input`                             |
| 修饰符     | .number    | 将输入的合法符串转为数字                                     |
| 修饰符     | .trim      | 移除输入内容两端空格                                         |
| 自定义组件 | 绑定参数   | 默认绑定参数 modelValue，可以自行指定                        |



#### 原生表单元素使用

下面两者等价

```html
<input
  :value="text"
  @input="event => text = event.target.value">
```

```html
<input v-model="text">
```



#### 自定义组件使用

下面两者等价

```vue
<CustomInput v-model="searchText" />
```

```vue
<CustomInput
  :modelValue="searchText"
  @update:modelValue="newValue => searchText = newValue"
/>
```

**组件内部需要做两件事：**

1. 将内部原生 `input` 元素的 `value` 属性绑定到自定义属性 `modelValue` 
2. 输入新的值时在 `input` 元素上触发 `update:modelValue` 事件

```vue
<!-- CustomInput.vue -->
<script setup>
defineProps(['modelValue'])
defineEmits(['update:modelValue'])
</script>

<template>
  <input
    :value="modelValue"
    @input="$emit('update:modelValue', $event.target.value)"
  />
</template>
```

另一种在组件内实现 `v-model` 的方式是使用计算属性;

`get` 方法需返回自定义属性 `modelValue`，而 `set` 方法需触发相应的事件：

```vue
<!-- CustomInput.vue -->
<script setup>
import { computed } from 'vue'

const props = defineProps(['modelValue'])
const emit = defineEmits(['update:modelValue'])

const value = computed({
  get() {
    return props.modelValue
  },
  set(value) {
    emit('update:modelValue', value)
  }
})
</script>

<template>
  <input v-model="value" />
</template>
```



#### 自行指定参数

```vue
<MyComponent v-model:title="bookTitle" />
```

```vue
<!-- MyComponent.vue -->
<script setup>
defineProps(['title'])
defineEmits(['update:title'])
</script>

<template>
  <input
    type="text"
    :value="title"
    @input="$emit('update:title', $event.target.value)"
  />
</template>
```



#### 多个 v-model 绑定

```vue
<UserName
  v-model:first-name="first"
  v-model:last-name="last"
/>
```

```vue
<script setup>
defineProps({
  firstName: String,
  lastName: String
})

defineEmits(['update:firstName', 'update:lastName'])
</script>

<template>
  <input
    type="text"
    :value="firstName"
    @input="$emit('update:firstName', $event.target.value)"
  />
  <input
    type="text"
    :value="lastName"
    @input="$emit('update:lastName', $event.target.value)"
  />
</template>
```



#### 自定义修饰符

例子：创建一个自定义的修饰符 `capitalize`，它会自动将字符串值首字母转为大写

```vue
<MyComponent v-model.capitalize="myText" />
```

```vue
<script setup>
const props = defineProps({
  modelValue: String,
  modelModifiers: { default: () => ({}) }
})

const emit = defineEmits(['update:modelValue'])

console.log(props.modelModifiers) // { capitalize: true }

function emitValue(e) {
  let value = e.target.value
  if (props.modelModifiers.capitalize) {
    value = value.charAt(0).toUpperCase() + value.slice(1)
  }
  emit('update:modelValue', value)
}
</script>

<template>
  <input type="text" :value="modelValue" @input="emitValue" />
</template>
```

:turtle: 如果父组件通过 v-model 使用了自定义修饰符，子组件自定义属性 modelModifiers 对象上将添加对应的属性，值为 true。



### 侦听器

| 特征                 | 说明                                                         |
| -------------------- | ------------------------------------------------------------ |
| 侦听数据源类型       | ref (包括计算属性)、响应式对象、getter 函数、多个数据源组成的数组 |
| 默认深层监听         | 侦听响应式对象时，默认为深层监听                             |
| 侦听特征             | 侦听返回响应式对象的 getter 时，为浅层侦听，且比较的是对象引用， |
| 侦听特征             | 可以开启 deep 选项，强制转成深层侦听器                       |
| watch vs watchEffect | 都能响应式地执行有副作用的回调。它们之间的主要区别是追踪响应式依赖的方式 |
| watch vs watchEffect | 前者默认为懒执行，后者的回调会立即执行                       |
| watch vs watchEffect | 前者追踪明确侦听的数据源，后者自动追踪所有能访问到的响应式属性 |
| 侦听器特征           | 回调默认在组件更新前调用（获取的是更新前的DOM），            |
| 侦听器特征           | 可以添加配置 `flush: 'post'`，表示组件更新后调用，           |
| 侦听器特征           | 后置刷新的 `watchEffect()` 有个更方便的别名 `watchPostEffect()` |
| 侦听器生命周期       | 在 setup 中创建的侦听器会绑定到宿主组件上，随组件卸载而停止  |
| 侦听器生命周期       | 但如果使用异步的方式添加，则需[手动停止](https://cn.vuejs.org/guide/essentials/watchers.html#stopping-a-watcher) |

#### 侦听数据源类型

```javascript
const x = ref(0)
const y = ref(0)

// 单个 ref
watch(x, (newX) => {
  console.log(`x is ${newX}`)
})

// getter 函数
watch(
  () => x.value + y.value,
  (sum) => {
    console.log(`sum of x + y is: ${sum}`)
  }
)

// 多个来源组成的数组
watch([x, () => y.value], ([newX, newY]) => {
  console.log(`x is ${newX} and y is ${newY}`)
})
```

不能直接侦听响应式对象的属性值

```javascript
const obj = reactive({ count: 0 })

// 错误，因为 watch() 得到的参数是一个 number
watch(obj.count, (count) => {
  console.log(`count is: ${count}`)
})

// 正确，提供一个 getter 函数
watch(
  () => obj.count,
  (count) => {
    console.log(`count is: ${count}`)
  }
)
```



### 模板引用

| 特征     | 说明                                                         |
| -------- | ------------------------------------------------------------ |
| 引用特征 | 只可以在<span style="color: green">组件挂载后</span>才能访问模板引用，否则将获取到 <span style="color: #ff0000">nul</span> |
| 引用特征 | 当在 `v-for` 中使用模板引用时，对应的 ref 中包含的值是一个数组 |
| 引用特征 | 注意，ref 数组<span style="color: #ff0000">并不保证与源数组相同的顺序</span> |
| 特殊用法 | 模板中的 ref 也可以接收动态的函数，会将元素引用作为首参      |
| 引用特征 | 引用 script setup 子组件时，其属性和方法默认是私有的，       |
| 引用特征 | 需要通过 defineExpose 宏显式暴露                             |
| 引用特征 | 父组件通过模板引用组件实例，如果属性为 ref，会自动解包       |

#### 基本使用

```vue
<script setup>
import { ref, onMounted } from 'vue'

// 必须和模板里的 ref 同名
const inputRef = ref(null)

onMounted(() => {
  input.value.focus()
})
</script>

<template>
  <input ref="inputRef" />
</template>
```

#### 列表中的模板引用

```vue
<script setup>
import { ref, onMounted } from 'vue'

const list = ref([
  /* ... */
])

const itemRefs = ref([])

onMounted(() => console.log(itemRefs.value))
</script>

<template>
  <ul>
    <li v-for="item in list" ref="itemRefs">
      {{ item }}
    </li>
  </ul>
</template>
```





## ----深入组件----

### 注册

| 特征          | 说明                                                         |
| ------------- | ------------------------------------------------------------ |
| 全局注册-缺陷 | 对于全局注册且未使用的组件，在生产环境打包时无法自动移除 *(tree-shaking)* |
| 局部注册      | 使用 *<script setup>* 的单文件组件中，导入的组件无需注册，可以直接在模板中使用 |
| 局部注册      | 如果没有使用 *<script setup>* ，则需要使用 `components` 选项来显式注册 |
| 定义&使用     | 推荐使用 *PascalCase* 的形式进行注册                         |
| 定义&使用     | 模板中使用可以采用 *PascalCase* 或 *kebab-cased*             |



### Props

| 特征       | 说明                                                         |
| ---------- | ------------------------------------------------------------ |
| 定义&使用  | 对于较长的名称，推荐使用 *camelCase* 定义，在模板通过 *kebab-case* 使用 |
| 快捷绑定   | 通过无参数的 v-bind 可以将对象的所有属性绑定到目标元素上     |
| 单向数据流 | 当自定义属性类型为对象，数组时，可以修改其属性（父子紧密耦合时可以采用） |
| 单向数据流 | 官方推荐大多数场合下，抛出事件通知父组件作改变               |
| 修改Props  | 需要props作为初始值时，可以定义属性获取初值                  |
| 修改Props  | 需要进一步转换时，可以使用计算属性                           |

#### Props作为初始值

```javascript
const props = defineProps(['initialCounter'])

// 获取初值，使 prop 和后续更新无关
const counter = ref(props.initialCounter)
```

#### Prop校验

```javascript
defineProps({
  // 基础类型检查
  // （给出 `null` 和 `undefined` 值则会跳过任何类型检查）
  propA: Number,
  // 多种可能的类型
  propB: [String, Number],
  // 必传，且为 String 类型
  propC: {
    type: String,
    required: true
  },
  // Number 类型的默认值
  propD: {
    type: Number,
    default: 100
  },
  // 对象类型的默认值
  propE: {
    type: Object,
    default(rawProps) {
      return { message: 'hello' }
    }
  },
  // 自定义类型校验函数
  propF: {
    validator(value) {
      // The value must match one of these strings
      return ['success', 'warning', 'danger'].includes(value)
    }
  },
  // 函数类型的默认值
  propG: {
    type: Function,
    default() {
      return 'Default function'
    }
  }
})
```

:turtle: 编译时整个表达式都会被移到外部的函数中，故不能访问其他变量

- 除 `Boolean` 外的未传递的可选 prop 将会有一个默认值 `undefined`；
- `Boolean` 类型的未传递 prop 将被转换为 `false`；
- 如果声明了 `default` 值，那么在 prop 的值被解析为 `undefined` 时，无论 prop 是未被传递还是显式指明的 `undefined`，都会改为 `default` 值。



#### 类型的可选值

```elm
String
Number
Boolean
Array
Object
Date
Function
Symbol
自定义的类
自定义的构造函数
```



#### Boolean 类型语法糖

<span style="backGround: #efe0b9">子组件</span>

```react
defineProps({
  disabled: Boolean
})
```

<span style="backGround: #efe0b9">父组件</span>

```vue
<!-- 等同于传入 :disabled="true" -->
<MyComponent disabled />

<!-- 等同于传入 :disabled="false" -->
<MyComponent />
```



### 事件

| 特征      | 说明                                                         |
| --------- | ------------------------------------------------------------ |
| 定义&使用 | *camelCase* 命名的事件，在父组件也能通过 *kebab-case* 的形式监听 |



### 透传属性

| 特征     | 说明                                                         |
| -------- | ------------------------------------------------------------ |
| 定义     | 传递给组件，却没有被该组件声明为 [props](https://cn.vuejs.org/guide/components/props.html) 或 [emits](https://cn.vuejs.org/guide/components/events.html#defining-custom-events) 的 attribute 或者 `v-on` 事件监听器， |
| 定义     | 最常见的例子就是 `class`、`style` 和 `id`                    |
| 特征     | 当一个组件以单个元素为根作渲染时，透传的属性会自动被添加到根元素上 |
| 特征     | 若符合结构，透传属性也能进行深层组件继承                     |
| 更改继承 | 可以通过配置禁用透传属性的默认继承                           |
| 访问属性 | 在模板中，可以通过 $attrs 访问透传属性                       |
| 特征     | 透传属性会被保留原始大小写                                   |
| 特征     | 像 `@click` 这样的一个 `v-on` 事件监听器将在此对象下被暴露为一个函数 `$attrs.onClick` |
| 特征     | 有着多个根节点的组件没有自动 attribute 透传行为，            |
| 特征     | 如果 `$attrs` 没有被显式绑定，将会抛出一个运行时警告         |
| 访问属性 | 可以在 `<script setup>` 中使用 `useAttrs()` *来访问透传属性*， |
| 访问属性 | 透传属性是最新的，但不是响应式的                             |
| 补充     | 通过无参数的 v-bind 可以将对象的所有属性绑定到目标元素上     |



### 插槽

| 知识点                 | 说明                                                         |
| ---------------------- | ------------------------------------------------------------ |
| 插槽内容               | 子组件中存在 `<slot>` 时，该组件起始标签和结束标签之间的任何内容（文本、元素或组件）会把其替换掉 `<slot>` |
| 插槽内容               | 父元素提供了插槽内容时，该内容会被抛弃                       |
| 渲染作用域             | 父级模板里的所有内容都是在父级作用域中编译的；不能使用子模板内的数据 |
| 备用内容               | 父级组件没有提供内容时，将用 `<slot>` 中的内容替换掉 `<slot>` |
| 具名插槽               | 当需要提供多个插槽时，可以通过 `name` 分配不同的 ID          |
| 具名插槽               | 不带 `name` 的 `<slot>` 会带有隐含的名字 default             |
| 作用域插槽             | 让插槽内容能够访问子组件中才有的数据                         |
| 作用域插槽             | 提供：在 `<slot>` 上添加属性，可提供多个（这些属性被称为插槽 Prop） |
| 作用域插槽             | 消费：传递到 v-slot 的值上，该值本身是一个对象（任意命名），提供的数据将作为对象属性 |
| 独占默认插槽的缩写语法 | 只提供默认插槽的内容时，可以不使用 template，而是直接把 v-slot 添加到组件上 |
| 解构插槽 Prop          | 消费作用域插槽的值时，可以通过解构只取需要的值，届时还可以重命名、提供默认值 |
| 动态插槽名             | 使用[动态指令参数](https://v3.cn.vuejs.org/guide/template-syntax.html#动态参数)，可以动态的使用插槽名 |
| 具名插槽的缩写         | 可以将` v-slot:` 替换为`#`                                   |
| 具名插槽的缩写         | 默认插槽使用缩写时，不能省略参数，即需要为 `#default`        |



#### 具名插槽

```vue
<div class="container">
  <header>
    <slot name="header"></slot>
  </header>
  <main>
    <slot></slot>
  </main>
  <footer>
    <slot name="footer"></slot>
  </footer>
</div>
```

定义具名插槽，添加 name 属性；

```vue
<template v-slot:header>
  <h1>Here might be a page title</h1>
</template>

<template v-slot:default>
  <p>A paragraph for the main content.</p>
  <p>And another one.</p>
</template>

<template v-slot:footer>
  <p>Here's some contact info</p>
</template>
```

为具名插槽提供内容，在 template 标签上通过 v-slot 指明是哪个。



#### 作用域插槽

子组件

```vue
<ul>
  <li v-for="( item, index ) in items">
    <slot :item="item"></slot>
  </li>
</ul>
```

父组件

```vue
<todo-list>
  <template v-slot:default="slotProps">
    <i class="fas fa-check"></i>
    <span class="green">{{ slotProps.item }}</span>
  </template>
</todo-list>
```



#### 独占默认插槽的缩写语法

```vue
<todo-list v-slot="slotProps">
  <i class="fas fa-check"></i>
  <span class="green">{{ slotProps.item }}</span>
</todo-list>
```



#### 动态插槽名

```vue
<base-layout>
  <template v-slot:[dynamicSlotName]>
    ...
  </template>
</base-layout>
```



### 依赖注入

| 特征     | 说明                                                         |
| -------- | ------------------------------------------------------------ |
| inject   | 接收第二个参数作为默认值，这将允许没有提供者                 |
| 最佳实际 | 推荐将响应式状态的变更都保持在供给方组件中，可以给后代提供状态和修改状态的方法 |
| 最佳实际 | 不想让后代对状态进行修改时，使用 *readonly* 包装             |
| 最佳实际 | 对于包含很多依赖的大型应用，建议使用 *Symnol* 作为注入名避免冲突 |



#### Provide(提供)

```vue
<script setup>
import { provide } from 'vue'

provide(/* 注入名 */ 'message', /* 值 */ 'hello!')
</script>
```

| 方法参数 | 含义   | 类型                 |
| -------- | ------ | -------------------- |
| 参数一   | 注入名 | str / Symbol         |
| 参数二   | 注入值 | 任意类型，包括响应式 |

也可以在整个应用层面提供依赖

```javascript
import { createApp } from 'vue'

const app = createApp({})

app.provide(/* 注入名 */ 'message', /* 值 */ 'hello!')
```



#### Inject (注入)

```vue
<script setup>
import { inject } from 'vue'

const message = inject('message')
</script>
```

:ghost: 注入的如果是 ref，不会自动解包



### 异步组件

| 特征     | 说明                                               |
| -------- | -------------------------------------------------- |
| 定义     | 仅在页面需要它渲染时才会调用加载内部实际组件的函数 |
| 额外配置 | 可以配置预留组件、延迟时间、失败组件               |

**全局注册**

```javascript
app.component('MyComponent', defineAsyncComponent(() =>
  import('./components/MyComponent.vue')
))
```

**局部注册**

```vue
<script setup>
import { defineAsyncComponent } from 'vue'

const AdminPage = defineAsyncComponent(() =>
  import('./components/AdminPageComponent.vue')
)
</script>

<template>
  <AdminPage />
</template>
```

