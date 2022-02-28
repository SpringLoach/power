# Composition API



## 编写组件对比

在vue2中，是使用 **Options API** 进行组件的编写，它包括data、methods、生命周期钩子等。

- 当我们实现某一个功能时，这个功能对应的代码逻辑会被<span style="color: #ff0008">拆分到各个属性中</span>；

- 当一个组件更大更复杂，<span style="color: #ff0000">存在多个功能时，逻辑就会被拆分的很分散</span>。尤其对于没有参与这些组件的人来说，是难以阅读的。

在vue3中，使用 **Composition API** 能将同一个逻辑关注点相关的代码收集在一起。

- 通过<span style="color: #ff0000">setup选项</span>编写代码；

- 可以用它来<span style="color: #ff0008">替代</span>之前所编写的<span style="color: #ff0000">大部分选项</span>。



## setup函数的参数

<span style="color: #ff0000">props</span> 

- 用于获取该组件中的props

<span style="color: #ff0000">context</span>

- 它本身是一个对象，包含三个属性：
- attrs：所有的 <span style="color: #a50">非 prop </span>的 attribute； 
- slots：父组件传递过来的插槽（在以渲染函数返回时会用）；
- emit：当组件内部需要发出事件时会用到 emit 。

<span style="backGround: #efe0b9">Father.vue</span>

```react
<home demo="hey" />

import Home from './Home.vue';

export default {
  components: {
    Home
  }
}
```

<span style="backGround: #efe0b9">Demo.vue</span>

```react
export default {
  props: {
    demo: {
      type: String,
      required: true
    }
  },
  setup(props, context) {
    console.log(props.demo);
  },
}
```

:star2: 在 setup 的内部，不能通过 <span style="backGround: pink">this</span> 去获取组件实例。



**常见风格**

```react
setup(_, { emit }) {
  console.log(emit);
},
```

:whale: 很多时候不需要引入整个context对象，可以用对象解构语法引入需要的部分。



## setup函数的返回值

```react
<h2>{{title}}: {{counter}}</h2>
<button @click="increment">+1</button>


setup() {
  let counter = 100;

  const increment = () => {  // 局部函数
    counter++;
  }

  return {
    title: "当前计数",
    counter,
    increment
  }
}
```

:ghost: setup的返回值<span style="color: #ff0000">可以在模板template中被使用</span>，可以用于代替data选项。

:turtle: setup与data选项的返回值重名时，会取setup的返回值。

:octopus: 上面的例子<span style="color: #ff0000">不能实现响应式</span>，因为 Vue 不会追踪一个普通定义变量的变化。



## setup不可以使用this

在 `setup` 中要避免使用 `this`，因为它没有指向组件实例。`setup` 的调用发生在 `data` 、`computed` 或 `methods` 被解析之前，所以它们无法在 `setup` 中被获取。



## 提供响应式

> 使用 <span style="color: #a50">reactive函数</span>，可以为 setup 中定义的数据提供响应式的特性。

```react
<h2>当前计数: {{state.counter}}</h2>
<button @click="increment">+1</button>

import { reactive } from 'vue';

setup() {
  const state = reactive({
    counter: 100
  })

  const increment = () => {
    state.counter++;
  }

  return {
    state,
    increment
  }
}
```

:ghost: 使用 <span style="color: #a50">reactive函数</span> 处理的数据，在使用时就会进行依赖收集，在后续方便进行对应的响应式操作。



