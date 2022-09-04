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

### Reactive

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

:whale: <span style="color: #a50">reactive函数</span> 只能接受对象或数组，不能传入基本类型。



#### shallowReactive

- 创建一个响应式代理，它跟踪其自身 property 的响应性，但不执行嵌套对象的深层响应式转换（深层还是原生对象）。

- 相对比，<span style="color: #a50">reactive函数</span> 是会对嵌套对象也会进行深层响应式转换（进行依赖追踪）的。



### Ref

> 该 Api 可以传入基本类型，对于较为简单的数据使用它就好了。

```react
<h2>当前计数: {{counter}}</h2>
<button @click="increment">+1</button>

import { ref } from 'vue';

setup() {
  // 返回一个可变的响应式对象，作为一个 响应式的引用 维护着它内部的值
  let counter = ref(100);

  const increment = () => {
    counter.value++;
    console.log(counter.value);
  }

  return {
    counter,
    increment
  }
}
```

:turtle:  在<span style="color: #ff0000">模板中</span>引入ref的值时，Vue会<span style="color: #ff0000">自动进行解包操作</span>，故不需要通过 ref.value 的方式来使用；

:turtle:  但是<span style="color: #ff0000">在 setup 函数内部，它依然是一个 ref 引用</span>， 所以对其进行操作时，我们依然需要使用 ref.value的方式；



#### Ref的浅层解包

```react
<h2>当前计数: {{info.counter.value}}</h2>
<!-- 当如果最外层包裹的是一个reactive可响应式对象, 那么内容的ref可以解包 -->
<h2>当前计数: {{reactiveInfo.counter}}</h2>

setup() {
  let counter = ref(100);
  const info = {
    counter
  }
  const reactiveInfo = reactive({
    counter
  })

  return {
    info,
    reactiveInfo,
  }
}
```

:ghost: ref 的解包是浅层的，如果它被一个<span style="color: #ff0000">普通对象</span>作为属性引用并出现在模板中，此时它<span style="color: #ff0000">没有解包</span>。

:whale: 通过 <span style="color: #a50">reactive函数</span> 处理的 ref，作为其属性，出现在模板中时<span style="color: #ff0000">仍然能够解包</span>。



#### shallowRef

- 创建一个<span style="color: #ff0000">浅层的ref对象</span>。

- 相对比，<span style="color: #a50">ref函数</span> 是会对对象参数的属性也进行深层响应式转换（进行依赖追踪）的。

   ```javascript
   import { shallowRef } from 'vue';
   
   const info = shallowRef({name: "why"});
   
   info.value.name = "james"; // 执行这段代码不会更新视图
   ```



#### triggerRef

> 手动触发和 shallowRef 相关联的副作用。

```javascript
import { shallowRef } from 'vue';

const info = shallowRef({name: "why"});

const changeInfo = () => {
  info.value.name = "james"; // 执行这段代码不会更新视图
  triggerRef(info);          // 加上这段代码可以手动触发响应，视图也会更新
}
```





## 响应式相关

### readonly

> readonly会返回原生对象的<span style="color: #ff0000">只读代理</span>（这个proxy的set方法被劫持，并且不能对其进行修改）。

```html
<button @click="updateState" :info="readonlyInfo3">修改状态</button>
```

```javascript
import { reactive, ref, readonly } from 'vue';

export default {
  setup() {
    // 1.普通对象
    const info1 = {name: "why"};
    const readonlyInfo1 = readonly(info1);

    // 2.响应式的对象reactive
    const info2 = reactive({ name: "why" });
    const readonlyInfo2 = readonly(info2);

    // 3.响应式的对象ref
    const info3 = ref("why");
    const readonlyInfo3 = readonly(info3);

    const updateState = () => {
      readonlyInfo1.name = "demo";  // 无法成功
      info1.name = "demo";          // 能成功，但不是响应式的，故开发很少用普通对象
      readonlyInfo2.name = "demo";  // 无法成功
      info2.name = "demo";          // 成功且响应式
      readonlyInfo3.value = "demo"; // 无法成功
      info3.value = "demo";         // 成功且响应式
    }

    return {
      updateState,
      readonlyInfo3, // 将该值传给子组件，子组件便不能修改
      info3          // 将该值传给子组件，子组件能修改
    }
  }
}
```

:ghost: <span style="color: #a50">readonly</span> 返回的对象都是不允许修改的。

:ghost:  但可以修改给 <span style="color: #a50">readonly </span>传入的对象，而且此时 <span style="color: #a50">readonly </span>返回的对象也会被修改。



#### shallowReadonly

-  创建一个 proxy，使其自身的 property 为只读，但不执行嵌套对象的深度只读转换（深层还是可读、可写的）。
-  相对比，<span style="color: #a50">readonly</span> 的嵌套对象仍然是只读的。



### 判断Reactive的API

**isProxy**

- 检查对象是否是由 reactive 或 readonly 创建的 proxy。 

**isReactive**

- 检查对象是否是由 reactive创建的响应式代理： 

- 如果该代理是 readonly 建的，但包裹了由 reactive 创建的另一个代理，它也会返回 true； 

  ```javascript
  const info = readonly(reactive({ name: "why" }));
  ```

**isReadonly**

- 检查对象是否是由 readonly 创建的只读代理。 

**toRaw**

- 返回 reactive 或 readonly 代理的原始对象引用（不建议保留对原始对象的持久引用，请谨慎使用）。



### 解构后失去响应能力

> 对于这些特殊的响应对象，如果不借助 toRefs 或 toRef 就进行结构，会导致其失去相应能力。

```javascript
import { reactive } from 'vue';
setup() {
  const info = reactive({name: "why", age: 18});
  let { name, age } = info;
    
  const changeAge = () => {
    age++;
    info.age++;
  }
    
  return {
    name,
    age,
    changeAge,
  }
}
```

:ghost:   从 <span style="color: #a50">reactive</span> 解构出来的变量后，无论是修改变量还是修改 <span style="color: #a50">reactive</span> 返回的对象，数据都不再是响应式的。

#### toRefs

```javascript
import { reactive, toRefs } from 'vue';
setup() {
  const info = reactive({name: "why", age: 18});
  let { name, age } = toRef(info);

  const changeAge = () => {
    age.value++;  // 会引起另一个变化
    info.age++;   // 会引起另一个变化
  }

  return {
    name,
    age,
    changeAge
  }
}
```

:ghost: 将 <span style="color: #a50">reactive</span> 返回的对象中的属性都转成 <span style="color: #a50">ref</span>

:ghost:  相当于已经在 info.name 和 ref.value 之间建立了 链接，任何一个修改都会引起另外一个变化。

#### toRef

> 如果只需要将 <span style="color: #a50">reactive</span> 对象中的<span style="color: #ff0000">一个</span>属性转化为 <span style="color: #a50">ref</span>, 那么可以使用 <span style="color: #a50">toRef</span> 的方法。

```javascript
import { reactive, toRef } from 'vue';
setup() {
  const info = reactive({name: "why", age: 18});
  let age = toRef(info, "age");

  const changeAge = () => {
    age.value++;
  }

  return {
    age,
    changeAge
  }
}
```



### ref的其它API

#### isRef

判断值是否是一个<span style="color: #a50">ref对象</span>。



#### unref

> 如果参数是一个 <span style="color: #a50">ref</span>，则返回内部值，否则返回参数本身。相当于下面处理的语法糖。

```javascript
val = isRef(val) ? val.value : val
```



#### customRef

创建一个**自定义的ref**，并**对其依赖项跟踪和更新触发**进行**显示控制**：

- 它需要一个<span style="color: #ff0000">工厂函数</span>，该函数接受 track 和 trigger 函数作为参数；

- 并且应该返回一个<span style="color: #ff0000">带有 get 和 set 的对象</span>；



##### (例)双向绑定节流

<span style="backGround: #efe0b9">hook/useDebounceRef.js</span>

```javascript
import { customRef } from 'vue';

export default function(value, delay = 300) {
  let timer = null;
  return customRef((track, trigger) => {
    return {
      get() {
        track();         // 触发依赖收集
        return value;
      },
      set(newValue) {
        clearTimeout(timer);
        timer = setTimeout(() => {
          value = newValue;
          trigger();      // 触发更新
        }, delay);
      }
    }
  })
}
```

`Demo.vue`

```react
<input v-model="message"/>
<h2>{{message}}</h2>

import debounceRef from './hook/useDebounceRef';
setup() {
  const message = debounceRef("Hello World");

  return {
    message
  }
}
```



## computed

**例子**

```javascript
import { ref } from 'vue';

setup() {
  const firstName = ref("Kobe");
  const lastName = ref("Bryant");

  const fullName = firstName.value + lastName.value
  
  return {
    fullName // 不是响应式的
  }
}
```

>  直接拼接两个 ref 对象，得到的结果是非响应式的。



### 传入getter

```javascript
import { ref, computed } from 'vue';

setup() {
  const firstName = ref("Kobe");
  const lastName = ref("Bryant");

  const fullName = computed(() => firstName.value + " " + lastName.value);


  const changeName = () => {
    firstName.value = "James"
  }

  return {
    fullName,
    changeName
  }
}
```

:star2: computed 的返回值是一个 <span style="color: #a50">ref对象</span> 。



### 传入getter和setter

```javascript
setup() {
  const firstName = ref("Kobe");
  const lastName = ref("Bryant");

  const fullName = computed({
    get() {
      return firstName.value + " " + lastName.value;
    },
    set(newValue) {
      const names = newValue.split(" ");
      firstName.value = names[0];
      lastName.value = names[1];
    }
  });

  const changeName = () => {
    fullName.value = "coder why";
  }

  return {
    fullName,
    changeName
  }
}
```



## watch

<span style="color: #f7534f;font-weight:600">watchEffect</span> 用于自动收集响应式数据的依赖；

<span style="color: #f7534f;font-weight:600">watch </span>需要手动指定侦听的数据源；



### watchEffect

```javascript
import { ref, watchEffect } from 'vue';
 
setup() {
  // watchEffect: 自动收集响应式的依赖
  const name = ref("why");
  const age = ref(2);

  const changeName = () => name.value = "kobe"

  watchEffect(() => {
    console.log("name:", name.value);
  });

  return {
    name,
    age,
    changeName,
    changeAge
  }
}
```

:ghost: watchEffect传入的函数会被<span style="color: #ff0000">立即执行一次</span>，并且<span style="color: #ff0000">在执行的过程中会收集依赖</span>；

:ghost: 只有收集的依赖发生变化时，watchEffect传入的函数才会再次执行；



#### 停止侦听

```javascript
const age = ref(2);
const stopWatch = watchEffect(() => {
  console.log("age:", age.value);
});

const changeAge = () => {
  age.value++;
  if (age.value > 5) {
    stopWatch();
  }
}
```

可以获取 watchEffect 的调用，需要停止侦听时，执行该调用即可。



#### 清除副作用

> 可以用于取消网络请求等（比如根据某参数发起请求，参数改变的太快了，此时取消前面的请求）。

```javascript
import { ref, watchEffect } from 'vue';

setup() {
  const age = ref(2);
  const stop = watchEffect((onInvalidate) => {
    console.log("age:", age.value);
    const timer = setTimeout(() => {
      console.log("网络请求成功~");
    }, 2000)

    onInvalidate(() => {
      // 在这个函数中清除额外的副作用
      clearTimeout(timer);
    })
  });
}
```

:ghost: watchEffect 的函数参数本身接收一个参数，通常命名为 `onInvalidate`，在内部使用时它本身又接收另外一个函数。

:ghost: 当 <span style="color: #ff0000">副作用（watchEffect中的其他代码）重新执行前</span> 或者 <span style="color: #ff0000">侦听器被停止</span> 时会执行该函数传入的回调函数。



#### 执行时机

> 默认情况下，**watchEffect** 是立即执行的，它的第二个参数，可以配置该行为。

```javascript
watchEffect(() => {
  console.log(title.value);
}, {
  flush: "post"
})
```

:whale: 该配置项的默认值为 `flush: "pre"`，会在元素**挂载**或者**更新**之前执行。



##### (例)使用ref

```react
<h2 ref="title">哈哈哈</h2>

import { ref, watchEffect } from 'vue';

setup() {
  const title = ref(null);

  watchEffect(() => {
    console.log(title.value);
  }, {
    flush: "post"  // 进行一次打印：值为引用的组件/元素实例
  })

  return {
    title
  }
}
```

> 若使用默认配置，将打印两次：初始一次，挂载完成后赋值一次。



### watch

> 完全等同于组件的watch选项。

与watchEffect相比，watch的特点：

- 懒执行副作用（不会立即执行）；

- 更具体的说明当哪些状态发生变化时，触发侦听器的执行；

- 访问侦听状态变化前后的值。

#### 侦听类型

<span style="color: #f7534f;font-weight:600">getter函数 </span>： 但是该 getter函数 必须引用可响应式的对象（比如 reactive 或者 ref）；

<span style="color: #f7534f;font-weight:600">可响应对象</span>：reactive 或者 ref；



##### getter函数

```javascript
import { reactive, watch } from 'vue';

setup() {
  const info = reactive({name: "why", age: 18});

  watch(() => info.name, (newValue, oldValue) => {
    console.log("newValue:", newValue, "oldValue:", oldValue);
  })

  const changeData = () => {
    info.name = "kobe";
  }

  return { ... }
}
```



##### 可响应对象

```javascript
import { ref, reactive, watch } from 'vue';

setup() {
  const info = reactive({name: "why", age: 18});
  // 侦听reactive对象，获取到的新旧值为reactive对象
  watch(info, (newValue, oldValue) => {
    console.log(newValue, oldValue);
  })
  // 侦听reactive对象，获取到的新旧值为普通对象
  watch(() => {...info}, (newValue, oldValue) => {
    console.log(newValue, oldValue);
  })
    
  // 侦听ref对象，获取到的新旧值是value值本身
  const name = ref("why");
  watch(name, (newValue, oldValue) => {
    console.log(newValue, oldValue);
  })

  const changeData = () => {
    info.name = "kobe";
    name = "demo",
  }

  return { ... }
}
```

###### 补充

```javascript
// 同样允许将数组类型的reactive解析为普通数组
const names = reactive(["abc", "cba"]);
watch([...names], (newValue, oldValue) => {
  console.log(newValue, oldValue);
})
```



#### 侦听多个对象

```javascript
import { ref, reactive, watch } from 'vue';

setup() {
  const info = reactive({name: "why", age: 18});
  const name = ref("why");

  watch([info, name], (newValue, oldValue) => {
    console.log(newValue, oldValue);
  })

  return { ... }
}
```

:ghost: 可以通过数组的方式传递首参，表示侦听多个对象；新旧值均为数组。

**其它写法**

```javascript
watch([() => ({...info}), name], ([newInfo, newName], [oldInfo, oldName]) => {
  console.log(newInfo, newName, oldInfo, oldName);
})
```

:whale: 若数组参数为 getter，需要添加 `()` 帮助它识别整体；

:whale: 可以通过数组解构取相应值。



#### 配置

```javascript
import { reactive, watch } from 'vue';

setup() {
  const info = reactive({
    name: "why",
    friend: {
      name: "kobe"
    }
  });

  watch(() => ({...info}), (newInfo, oldInfo) => {
    console.log(newInfo, oldInfo);
  }, {
    deep: true,
    immediate: true
  })

  const changeData = () => {
    info.friend.name = "james";
  }

  return { ... }
}
```

:ghost: 在 <span style="color: #a50">watch</span> 的第三个参数中，可以配置是否对普通对象进行深层监听及立即执行一次回调。

:whale: 如果直接监听 reactive 对象，<span style="color: #ff0000">默认进行深层监听</span>。

:whale: 如果监听解构后的响应对象，默认没有进行深层监听。



## 生命周期钩子

### 映射关系

| **选项式 API**  | **组合式 API**   |
| -------------- | --------------- |
| beforeCreate | setup()       |
| created      | setup()       |
| beforeMount  | onBeforeMount |
| mounted      | onMounted     |
| beforeUpdate   | onBeforeUpdate  |
| updated        | onUpdated       |
| beforeUnmount | onBeforeUnmount |
| unmounted | onUnmounted |
| activated | onActivated |
| deactivated | onDeactivated |
| errorCaptured | onErrorCaptured |
| renderTracked | onRenderTracked |
| renderTriggered | onRenderTriggered |

:whale: 需要在 `beforeCreate` 和 `created` 中定义的代码直接在 `setup` 选项中定义即可。



### 使用钩子

```javascript
import { onMounted, onUnmounted } from 'vue';

setup() {
  onMounted(() => {
    console.log("App Mounted1");
  })
  onMounted(() => {
    console.log("App Mounted2");
  })
  onUnmounted(() => {
    console.log("App onUnmounted");
  })

  return { ... }
}
```

:whale: 在 <span style="color: #a50">setup</span> 内部可使用同一个生命周期钩子多次，它们将以同步顺序执行。



## Provide和Inject

```react
import { provide, ref, readonly } from 'vue';

import Home from './Home.vue';

export default {
  components: {
    Home
  },
  setup() {
    const name = ref("coderwhy");
    let counter = ref(100);

    provide("name", readonly(name));      
    provide("counter", readonly(counter));  // 属性名 属性值

    const increment = () => counter.value++;

    return {
      increment,
      counter
    }
  }
}
```

:whale: 一般传递给后代组件的数据，期望实现单向数据流，不适合让后代组件去直接修改，故使用了 `readonly`。



```react
import { inject } from 'vue';

setup() {
  const name = inject("name", "defaultName");  // 键名 默认值
  const counter = inject("counter");

  return {
    name,
    counter,
  }
}
```

:whale: <span style="color: #a50">inject</span> 可以传入第二参数，当上层没有传下来对应值时，将其作为默认值使用。



## compositionAPI练习

<span style="backGround: #efe0b9">demo.vue</span>

```react
<h2>当前计数: {{counter}}</h2>
<h2>计数*2: {{doubleCounter}}</h2>
<button @click="increment">+1</button>
<button @click="decrement">-1</button>

import { useCounter } from './hooks/useCounter';

export default {
  setup() {
    const { counter, doubleCounter, increment, decrement } = useCounter();

    return { counter, doubleCounter, increment, decrement }
  }
}
```

写法二

```javascript
import { useCounter } from './hooks/useCounter';

setup() {
  return { ...useCounter() }
}
```

:turtle: 不推荐这种写法，它会让阅读性变差，即不明白变量/方法来自哪里。



<span style="backGround: #efe0b9">hooks/useCounter.js</span>

```javascript
import { ref, computed } from 'vue';

export default function() {
  const counter = ref(0);
  const doubleCounter = computed(() => counter.value * 2);

  const increment = () => counter.value++;
  const decrement = () => counter.value--;

  return {
    counter, 
    doubleCounter, 
    increment, 
    decrement
  }
}
```



### (例)设置文档标题

<span style="backGround: #efe0b9">demo.vue</span>

```javascript
import { useTitle } from './hooks/useTitle';

setup() {
  const titleRef = useTitle("coderwhy");
  setTimeout(() => {
    titleRef.value = "kobe"
  }, 3000);

  return {}
}
```

<span style="backGround: #efe0b9">hooks/useTitle.js</span>

```javascript
import { ref, watch } from 'vue';

export default function(title = "默认的title") {
  const titleRef = ref(title);

  watch(titleRef, (newValue) => {
    document.title = newValue
  }, {
    immediate: true
  })

  return titleRef
}
```



### (例)使用本地缓存

<span style="backGround: #efe0b9">demo.vue</span>

```javascript
import { useLocalStorage } from './hooks/useLocalStorage';

setup() {
  const data = useLocalStorage("info");
  const changeData = () => data.value = "哈哈哈哈"

  return { changeData }
}
```

<span style="backGround: #efe0b9">hooks/useLocalStorage.js</span>

```javascript
import { ref, watch } from 'vue';

export default function(key, value) {
  const data = ref(value);

  if (value) {
    window.localStorage.setItem(key, JSON.stringify(value));
  } else {
    data.value = JSON.parse(window.localStorage.getItem(key));
  }

  watch(data, (newValue) => {
    window.localStorage.setItem(key, JSON.stringify(newValue));
  })

  return data;
}
```

:whale: 传一个参数时，读取缓存；传两个参数时，设置缓存；并且修改缓存对应变量时，自动缓存。

:whale: 储存时使用<span style="color: #a50">JSON字符串</span>格式，可以应对数组、对象、原始数据类型等的任何类型。



## 目录导出结构

- hooks
  - index.js
  - useA.js
  - useB.js

<span style="backGround: #efe0b9">hooks/index.js</span>

```javascript
import useA from './useA';
import useB from './useB';

export {
  useA,
  useB
}
```

<span style="backGround: #efe0b9">demo.vue</span>

```javascript
import {
  useA,
  useB,
} from './hooks';
```



## render和h函数的简单示例

```react
<script>
  import { h } from 'vue';

  export default {
    render() {
      return h("h2", {class: "title"}, "Hello Render")
    }
  }
</script>

<style scoped></style>
```

:whale: 使用 <span style="color: #a50">render </span>选项时，不需要 <template>，并且需要在 <span style="color: #a50">render </span>中返回一个 Vnode 对象。

:whale: <span style="color: #a50">h函数 </span>用于创建 Vnode 对象。



## render实现计数器

### Options API

```react
<script>
  import { h } from 'vue';

  export default {
    data() {
      return {
        counter: 0
      }
    },
    render() {
      return h("div", {class: "app"}, [
        h("h2", null, `当前计数: ${this.counter}`),
        h("button", {
          onClick: () => this.counter++
        }, "+1"),
        h("button", {
          onClick: () => this.counter--
        }, "-1"),
      ])
    }
  }
</script>

<style scoped></style>
```



### Composition API

```react
<script>
  import { ref, h } from 'vue';

  export default {
    setup() {
      const counter = ref(0);
      
      return () => {
        return h("div", {class: "app"}, [
          h("h2", null, `当前计数: ${counter.value}`),
          h("button", {
            onClick: () => counter.value++
          }, "+1"),
          h("button", {
            onClick: () => counter.value--
          }, "-1"),
        ])
      }
    }
  }
</script>

<style scoped></style>
```

:whale: 要想在 <span style="color: #a50">setup</span> 选项中使用渲染函数，需要从中返回一个函数，该函数返回一个 Vnode 对象。



## 渲染组件及插槽使用

<span style="backGround: #efe0b9">demo.vue</span>

```react
<script>
  import { h } from 'vue';
  import HelloWorld from './HelloWorld.vue';

  export default {
    render() {
      return h("div", null, [
        h(HelloWorld, null, {
          default: props => h("span", null, `app传入到HelloWorld中的内容: ${props.name}`)
        })
      ])
    }
  }
</script>

<style scoped></style>
```

:whale: 在 <span style="color: #a50">render </span>中使用组件无需显示注册。

:whale: 在第三个参数中指定插槽，并在方法（值）返回一个 Vnode 对象。它的参数在子组件调用时传递。

<span style="backGround: #efe0b9">HelloWorld.vue</span>

```react
<script>
  import { h } from "vue";

  export default {
    render() {
      return h("div", null, [
        h("h2", null, "Hello World"),
        this.$slots.default ? this.$slots.default({name: "demo"}): h("span", null, "插槽默认文本")
      ])
    }
  }
</script>

<style scoped></style>
```

:whale: 判断，没有传递插槽内容时，使用默认插槽。



## jsx的使用

```elm
npm install @vue/babel-plugin-jsx -D
```

<span style="backGround: #efe0b9">babel.config.js</span>

```javascript
module.export = {
  plugin: [
    "@vue/babel-plugin-jsx"
  ]
}
```

<span style="backGround: #efe0b9">demo.vue</span>

```react
<script>
  import HelloWorld from './HelloWorld.vue';

  export default {
    data() {
      return {
        counter: 0
      }
    },

    render() {
      const increment = () => this.counter++;
      const decrement = () => this.counter--;

      return (
        <div>
          <h2>当前计数: {this.counter}</h2>
          <button onClick={increment}>+1</button>
          <button onClick={decrement}>-1</button>
          <HelloWorld>
          </HelloWorld>
        </div>
      )
    }
  }
</script>

<style scoped></style>
```

:whale: 比起 h函数 更友好，阅读性更强。但本身会经过 babel 被转化为 h函数。注意语法与模板中的不同。



<span style="backGround: #efe0b9">HelloWorld.vue</span>

```react
<script>
  export default {
    render() {
      return (
        <div>
          <h2>HelloWorld</h2>
          {this.$slots.default ? this.$slots.default(): <span>哈哈哈</span>}
        </div>
      )
    }
  }
</script>

<style scoped></style>
```

