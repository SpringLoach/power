## script setup

> 在单文件组件 (SFC) 中，每个文件可以有最多一个 `script`，且最多一个 `script setup`，可以两个都存在。
>
> `script setup` 是在单文件组件中使用<span style="color: #ff0000">组合式 API</span> 的编译时语法糖。



### 优势

- 更少的样板内容，更简洁的代码。
- 能够使用纯 TypeScript 声明 props 和抛出事件。
- 更好的运行时性能 (其模板会被编译成与其同一作用域的渲染函数，没有任何的中间代理)。
- 更好的 IDE 类型推断性能 (减少语言服务器从代码中抽离类型的工作)。



###  基本语法

```vue
<script setup>
  console.log('hello script setup')
</script>
```

:ghost: 里面的代码会被编译成组件 <span style="color: #ff0000">`setup()` 函数的内容</span>；

:ghost: 与普通的 `<script>` 只在组件被首次引入的时候执行一次不同，`<script setup>` 中的代码会在<span style="color: #ff0000">每次组件实例被创建的时候执行</span>。



####  模板可使用顶层的绑定

```vue
<script setup>
// 引入
import { capitalize } from './helpers'

// 变量
const msg = 'Hello!'

// 函数
function log() {
  console.log(msg)
}
</script>

<template>
  <div @click="log">{{ msg }}</div>
  <div>{{ capitalize('hello') }}</div>
</template>
```

:ghost: 声明在顶层的绑定 (包括变量，函数声明，以及 import 引入的内容) 可以在模板中直接使用。



### 响应式

```vue
<script setup>
import { ref } from 'vue'

const count = ref(0)
</script>

<template>
  <button @click="count++">{{ count }}</button>
</template>
```

:ghost: 响应式状态需要使用[响应式 APIs](https://v3.cn.vuejs.org/api/basic-reactivity.html) 来创建，在模板中使用的时候会<span style="color: #ff0000">自动解包</span>。



###  使用组件

```vue
<script setup>
import MyComponent from './MyComponent.vue'
</script>

<template>
  <MyComponent />
</template>
```

:ghost: `script setup` 范围里的值也能被<span style="color: #ff0000">直接作为自定义组件</span>的标签名使用；

:whale: 也可以用 kebab-case 格式的 `<my-component>`，但建议使用 PascalCase 格式以保持一致性，也助于区分原生的自定义元素。



####  动态组件

```vue
<script setup>
import Foo from './Foo.vue'
import Bar from './Bar.vue'
</script>

<template>
  <component :is="Foo" />
  <component :is="someCondition ? Foo : Bar" />
</template>
```

:ghost: 由于组件被引用为变量（而非字符串键）来注册的，在 `script setup` 中要使用动态组件的时候，就应该使用动态的 `:is` 来绑定。



#### 递归组件

<span style="backGround: #efe0b9">FooBar.vue</span>

```vue
<FooBar/>
```

:ghost: 一个单文件组件可以通过它的文件名被其自己所引用。

```javascript
import { FooBar as FooBarChild } from './components'
```

:whale: 存在命名冲突时，可以使用别名导入。



#### 命名空间组件

```vue
<script setup>
import * as Form from './form-components'
</script>

<template>
  <Form.Input>
    <Form.Label>label</Form.Label>
  </Form.Input>
</template>
```

需要<span style="color: #ff0000">从单个文件中导入多个组件</span>的时候，可以使用带点的组件标记，例如 `<Foo.Bar>` 来引用嵌套在对象属性中的组件。



#### 使用自定义指令

全局注册的自定义指令将以符合预期的方式工作，且本地注册的指令可以直接在模板中使用。

```vue
<script setup>
const vMyDirective = {
  beforeMount: (el) => {
    // 在元素上做些操作
  }
}
</script>
<template>
  <h1 v-my-directive>This is a Heading</h1>
</template>
```

:turtle: 命名本地自定义指令时，必须采用 <span style="color: #ff0000">`vNameOfDirective`</span> 的形式。

```vue
<script setup>
  // 导入的指令同样能够工作，并且能够通过重命名来使其符合命名规范
  import { myDirective as vMyDirective } from './MyDirective.js'
</script>
```



### defineProps 和 defineEmits

```vue
<script setup>
const props = defineProps({
  foo: String
})

const emit = defineEmits(['change', 'delete'])
// setup code
</script>
```

:ghost: 对于传统的 <span style="color: #a50">prop</span> 和 <span style="color: #a50">emits</span>，在 `script setup` 中要替换为 <span style="color: #a50">defineProps</span> 和 <span style="color: #a50">defineEmits</span>，它们不需导入，因为是**编译器宏**。

:ghost: 传入的选项不能引用在 setup 范围中声明的局部变量，这样做会引起编译错误。但是，它*可以*<span style="color: #ff0000">引用导入</span>的绑定，因为它们也在模块范围内。

:octopus: 直接使用，eslint 报错[解决](https://www.csdn.net/tags/MtTaMg4sOTIxMjA3LWJsb2cO0O0O.html)

```
 error  'defineProps' is not defined  no-undef
```



### defineExpose

通过模板 ref，默认是<span style="color: #ff0000">获取不到</span> `script setup` 中声明的绑定的，为了将其暴露，需要使用 <span style="color: #a50">defineExpose</span> 编译器宏。

```vue
<script setup>
import { ref } from 'vue'

const a = 1
const b = ref(2)

defineExpose({
  a,
  b
})
</script>
```

当父组件通过模板 ref 的方式[获取](https://blog.csdn.net/pig_pig32/article/details/125034074)到当前组件的实例，获取到的实例会像这样 `{ a: number, b: number }` (ref 会和在普通实例中一样被自动解包)



### useSlots 和 useAttrs

```vue
<script setup>
import { useSlots, useAttrs } from 'vue'

const slots = useSlots()
const attrs = useAttrs()
</script>
```

:whale: 在 `script setup` 使用 <span style="color: #a50">slots</span> 和 <span style="color: #a50">attrs</span> 的情况应该是很罕见的，因为可以在模板中通过 <span style="color: #a50">$slots</span> 和 <span style="color: #a50">$attrs</span> 来访问它们。



###  与普通的 script 一起使用

**需求情景**

- 无法在 `<script setup>` 声明的选项，例如 `inheritAttrs` 或通过插件启用的自定义的选项；
- 声明命名导出；
- 运行副作用或者创建只需要执行一次的对象。

```vue
<script>
// 普通 <script>, 在模块范围下执行(只执行一次)
runSideEffectOnce()

// 声明额外的选项
export default {
  inheritAttrs: false,
  customOptions: {}
}
</script>

<script setup>
// 在 setup() 作用域中执行 (对每个实例皆如此)
</script>
```



###  限制：没有 Src 导入

由于模块执行语义的差异，将其移动到外部的 `.js` 或者 `.ts` 文件中的时候，对于开发者和工具来说都会感到混乱。



### 仅限 TypeScript 的功能

#### 仅限类型的 props/emit 声明

```vue
const props = defineProps<{
  foo: string
  bar?: number
}>()

const emit = defineEmits<{
  (e: 'change', id: number): void
  (e: 'update', value: string): void
}>()
```

截至目前，类型声明参数必须是以下内容之一，以确保正确的静态分析：类型字面量、在同一文件中的接口或类型字面量的引用

现在还不支持复杂的类型和从其它文件进行类型导入。理论上来说，将来是可能实现类型导入的。

:octopus: 记得要在 `script setup lang="ts"` 环境中使用，否则编译器会报错。



#### 类型声明的默认 props 值

```typescript
interface Props {
  msg?: string
  labels?: string[]
}

const props = withDefaults(defineProps<Props>(), {
  msg: 'hello',
  labels: () => ['one', 'two']
})
```

需要提供默认值时，需要使用 <span style="color: #a50">withDefaults</span> 编译器宏。



## 内置组件

### component

> `is` - ` string | Component | VNode `

```vue
<!-- 也能够渲染注册过的组件或 prop 传入的组件-->
<component :is="$options.components.child"></component>

<!-- 可以通过字符串引用组件 -->
<component :is="condition ? 'FooComponent' : 'BarComponent'"></component>

<!-- 可以用来渲染原生 HTML 元素 -->
<component :is="href ? 'a' : 'span'"></component>
```



### keep alive

被 vue3 抛弃的写法

```vue
<keep-alive>
  <router-view />
</keep-alive>
```

会导致报错：

```elm
vue-router.mjs?6605:35 [Vue Router warn]: <router-view> can no longer be used directly inside <transition> or <keep-alive>.
Use slot props instead:
```

vue3 支持的写法

```vue
<router-view v-slot="{ Component }">
  <keep-alive>
    <component :is="Component" />
  </keep-alive>
</router-view>
```



## TypeScript支持

### 推荐配置

tsconfig.json

```
{
  "compilerOptions": {
    "target": "esnext",
    "module": "esnext",
    // 这样就可以对 `this` 上的数据属性进行更严格的推断
    "strict": true,
    "jsx": "preserve",
    "moduleResolution": "node"
  }
}
```



### 项目配置支持

#### webpack

> 自定义 Webpack 配置，又要支持 ts，参考官网[配置](https://v3.cn.vuejs.org/guide/typescript-support.html#webpack-配置)



#### Vue CLI

##### 开始

```less
# 1. Install Vue CLI, 如果尚未安装
npm install --global @vue/cli@next

# 2. 创建一个新项目, 选择 "Manually select features" 选项
vue create my-project-name

# 3. 如果已经有一个不存在TypeScript的 Vue CLI项目，请添加适当的 Vue CLI插件：
vue add typescript
```

组件使用

```vue
<script lang="ts">
  ...
</script>
```

结合JSX

```vue
<script lang="tsx">
  ...
</script>
```



### 推断组件选项类型

> 要让 TypeScript 正确推断 Vue 组件选项中的类型，需要使用 `defineComponent` 全局方法定义组件

ts

```typescript
import { defineComponent } from 'vue'

const Component = defineComponent({
  // 已启用类型推断
})
```

vue

```vue
<script lang="ts">
import { defineComponent } from 'vue'
export default defineComponent({
  // 已启用类型推断
})
</script>
```



### 结合 Options API 

隐式绑定

```typescript
const Component = defineComponent({
  data() {
    return {
      count: 0
    }
  },
  mounted() {
    const result = this.count.split('') // => Property 'split' does not exist on type 'number'
  }
})
```



对于复杂类型/接口，使用类型断言进行指明

```typescript
interface Book {
  title: string
  author: string
  year: number
}

const Component = defineComponent({
  data() {
    return {
      book: {
        title: 'Vue 3 Guide',
        author: 'Vue Team',
        year: 2020
      } as Book
    }
  }
})
```



####  为 globalProperties 扩充类型

这个 [API](https://v3.cn.vuejs.org/api/application-config.html#globalproperties) 用于添加全局属性、方法，在 ts 中使用时需要[添加声明](https://v3.cn.vuejs.org/guide/typescript-support.html#为-globalproperties-扩充类型)。



#### 注解 computed

由于 Vue 声明文件的循环特性，TypeScript 可能难以推断 computed 的类型。因此，可能需要注解计算属性的返回类型。

```javascript
import { defineComponent } from 'vue'

const Component = defineComponent({
  data() {
    return {
      message: 'Hello!'
    }
  },
  computed: {
    // 需要注解
    greeting(): string {
      return this.message + '!'
    },

    // 在使用 setter 进行计算时，需要对 getter 进行注解
    greetingUppercased: {
      get(): string {
        return this.greeting.toUpperCase()
      },
      set(newValue: string) {
        this.message = newValue.toUpperCase()
      }
    }
  }
})
```



#### 注解 Props

Vue 对定义了 `type` 的 prop 执行运行时验证。要将这些类型提供给 TypeScript，需要使用 `PropType` 指明构造函数

```typescript
import { defineComponent, PropType } from 'vue'

interface Book {
  title: string
  author: string
  year: number
}

const Component = defineComponent({
  props: {
    name: String,
    id: [Number, String],
    success: { type: String },
    callback: {
      type: Function as PropType<() => void>
    },
    book: {
      type: Object as PropType<Book>,
      required: true
    },
    metadata: {
      type: null // metadata 的类型是 any
    }
  }
})
```

注意对象和数组的 `validator` 和 `default` 值

```javascript
import { defineComponent, PropType } from 'vue'

interface Book {
  title: string
  year?: number
}

const Component = defineComponent({
  props: {
    bookA: {
      type: Object as PropType<Book>,
      // 请务必使用箭头函数
      default: () => ({
        title: 'Arrow Function Expression'
      }),
      validator: (book: Book) => !!book.title
    },
    bookB: {
      type: Object as PropType<Book>,
      // 或者提供一个明确的 this 参数
      default(this: void) {
        return {
          title: 'Function Expression'
        }
      },
      validator(this: void, book: Book) {
        return !!book.title
      }
    }
  }
})
```



####  注解 emit

> 可以为触发的事件注解一个有效载荷

```javascript
const Component = defineComponent({
  emits: {
    addBook(payload: { bookName: string }) {
      // perform runtime 验证
      return payload.bookName.length > 0
    }
  },
  methods: {
    onSubmit() {
      this.$emit('addBook', {
        bookName: 123 // 类型错误！
      })
      this.$emit('non-declared-event') // 类型错误！
    }
  }
})
```



### 结合 组合式 API

在 `setup()` 函数中，不需要将类型传递给 `props` 参数，因为它将从 `props` 组件选项推断类型。

```javascript
import { defineComponent } from 'vue'

const Component = defineComponent({
  // 组件选项
  props: {
    message: {
      type: String,
      required: true
    }
  },

  setup(props) {
    const result = props.message.split('') // 正确, 'message' 被声明为字符串
    const filtered = props.message.filter(p => p.value) // 将引发错误: Property 'filter' does not exist on type 'string'
  }
})
```



#### 类型声明 refs

Refs 根据初始值推断类型

```javascript
import { defineComponent, ref } from 'vue'

const Component = defineComponent({
  setup() {
    const year = ref(2020)

    const result = year.value.split('') // => Property 'split' does not exist on type 'number'
  }
})
```

为 ref 的内部值指定复杂类型，可以传递使用泛型

```javascript
const year = ref<string | number>('2020') // year's type: Ref<string | number>

year.value = 2020 // ok!
```

:whale: 如果泛型的类型未知，建议将 `ref` 转换为 `Ref<T>`



####  类型声明 reactive

> 可以使用接口

```typescript
import { defineComponent, reactive } from 'vue'

interface Book {
  title: string
  year?: number
}

export default defineComponent({
  name: 'HelloWorld',
  setup() {
    const book = reactive<Book>({ title: 'Vue 3 Guide' })
    // or
    const book: Book = reactive({ title: 'Vue 3 Guide' })
    // or
    const book = reactive({ title: 'Vue 3 Guide' }) as Book
  }
})
```



#### 声明组件类型

```javascript
import { defineComponent, ref } from 'vue'
const MyModal = defineComponent({
  setup() {
    const isContentShown = ref(false)
    const open = () => (isContentShown.value = true)
    return {
      isContentShown,
      open
    }
  }
})
const app = defineComponent({
  components: {
    MyModal
  },
  template: `
    <button @click="openModal">Open from parent</button>
    <my-modal ref="modal" />
  `,
  setup() {
    const modal = ref()
    const openModal = () => {
      modal.value.open()
    }
    return { modal, openModal }
  }
})
```

它可以工作，但是没有关于 `MyModal` 及其可用方法的类型信息。为了解决这个问题，你应该在创建引用时使用 `InstanceType`

```javascript
setup() {
  const modal = ref<InstanceType<typeof MyModal>>()
  const openModal = () => {
    modal.value?.open()
  }
  return { modal, openModal }
}
```

还需要使用[可选链操作符](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Operators/Optional_chaining)或其它方式来确认 `modal.value` 不是 undefined

InstanceType<T> - 获取构造函数的实例类型



#### 类型声明 computed

计算值将根据返回值自动推断类型

```ts
import { defineComponent, ref, computed } from 'vue'

export default defineComponent({
  name: 'CounterButton',
  setup() {
    let count = ref(0)

    // 只读
    const doubleCount = computed(() => count.value * 2)

    const result = doubleCount.value.split('') // => Property 'split' does not exist on type 'number'
  }
})
```



#### 为事件处理器添加类型

在处理原生 DOM 事件的时候，正确地为处理函数的参数添加类型或许会是有用的。

```vue
<template>
  <input type="text" @change="handleChange" />
</template>
<script lang="ts">
import { defineComponent } from 'vue'
export default defineComponent({
  setup() {
    // `evt` 将会是 `any` 类型
    const handleChange = evt => {
      console.log(evt.target.value) // 此处 TS 将抛出异常
    }
    return { handleChange }
  }
})
</script>
```

在没有为 `evt` 参数正确地声明类型的情况下，当尝试获取 `<input>` 元素的值时，TypeScript 将抛出异常。解决方案是将事件的目标转换为正确的类型：

```ts
const handleChange = (evt: Event) => {
  console.log((evt.target as HTMLInputElement).value)
}
```



## 渲染函数

###  渲染函数的返回值

- 单个根 VNode
- 文本 VNode
- 子元素数组（这会创建一个片段）

<span style="color: #f7534f;font-weight:600">文本 VNode</span>

```javascript
render() {
  return 'Hello world!'
}
```

<span style="color: #f7534f;font-weight:600">子元素数组</span>

```javascript
// 相当于模板 `Hello<br>world!`
render() {
  return [
    'Hello',
    h('br'),
    'world!'
  ]
}
```





### h()函数

用于创建 VNode（虚拟节点） 的实用程序，它接收三个参数。

```javascript
// @returns {VNode}
h(
  'div',
  {},
  [
    'Some text comes first.',
    h('h1', 'A headline'),
    h(MyComponent, {
      someProp: 'foobar'
    })
  ]
)
```

如果不需要 props，可以将 children 作为第二个参数传入；如果会产生歧义，使用 null 保留第二个参数

| createVNode函数参数 | 可选类型                                                     | 属性 |
| ------------------- | ------------------------------------------------------------ | ---- |
| tag                 | { str\| obj \| func } 标签名 / 组件 / 异步组件 / 函数式组件  | 必填 |
| props               | { obj } 包含传到模板的 attribute、prop 和事件                | 可选 |
| children            | { str\| arr\| obj } 使用 `h()` 构建的子 VNodes / 字符串 / 有插槽的对象 | 可选 |

:whale: children为字符串时，实际上是文本 VNode



### 替代模板功能

| 说明           | 模板功能                                  | 替代方案                                                     |
| -------------- | ----------------------------------------- | ------------------------------------------------------------ |
| 条件、列表渲染 | `v-if` 和 `v-for`                         | 使用 if else 语句和 map 函数可以替代                         |
| 双向绑定       | `v-model`                                 | 需要扩展为 `modelValue` 和 `onUpdate:modelValue`             |
| 事件绑定       | `v-on`                                    | onClick                                                      |
| 事件修饰符     |                                           | 有的要拼接在事件名后面、有的需要自己在函数内实现             |
| 插槽           |                                           | 通过[`this.$slots`](https://v3.cn.vuejs.org/api/instance-properties.html#slots)访问静态插槽的内容等 |
| 动态组件       | `<component>` 和 `is`                     | 使用 `resolveDynamicComponent` 来实现                        |
| 自定义指令     |                                           | 使用 [`withDirectives`](https://v3.cn.vuejs.org/api/global-api.html#withdirectives) 将自定义指令应用于 VNode |
| 内置组件       | <keep-alive>、<transition>、 <teleport>等 | 需要自行导入                                                 |



### JSX

> 某些情况下，在 Vue 中使用 JSX 语法比渲染函数要更简单，想使用需要[安装插件](https://github.com/vuejs/babel-plugin-jsx/blob/dev/packages/babel-plugin-jsx/README-zh_CN.md)。

```vue
import AnchoredHeading from './AnchoredHeading.vue'

const app = createApp({
  render() {
    return (
      <AnchoredHeading level={1}>
        <span>Hello</span> world!
      </AnchoredHeading>
    )
  }
})

app.mount('#demo')
```



### 其他特点

| --                                                           | 特点                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| 必须唯一                                                     | VNodes 必须唯一，如果需要重复的元素/组件，使用工厂函数       |
| 组件 VNode                                                   | 为[组件](https://v3.cn.vuejs.org/guide/render-function.html#创建组件-vnode)创建 VNode，需要将组件本身作为 h 函数的首参来传递 |
| [函数式组件](https://v3.cn.vuejs.org/guide/render-function.html#函数式组件) | 将函数作为 h 函数的首参来传递时，会被视作函数式组件          |

<span style="color: #ed5a65">函数式组件</span> 在渲染过程中不会创建组件实例，并跳过常规的组件生命周期。

