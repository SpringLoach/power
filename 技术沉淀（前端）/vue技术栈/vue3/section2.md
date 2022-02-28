## 动画实现

>  Vue 提供了内置组件和对应的API来完成动画，可以方便的实现过渡动画效果。

### 通过transition来实现

```html
<transition name="demo">
  <h2 v-if="show">hey</h2>
</transition>

<style scoped>
.demo-enter-from,
.demo-leave-to {
  opacity: 0;
}
// 可以省略（默认值）
.demo-enter-to,
.demo-leave-from {
  opacity: 1;
}
.demo-enter-active,
.demo-leave-active {
  transition: opacity 1s ease;
}
</style>
```

:ghost: 通过内置的 `transition` 组件包裹，其内部元素/组件的根节点会根据 `name` 属性添加上类。

:ghost: 没有提供 `name` 时，添加的类名会以 `v-` 作为开头。

:ghost: 当<span style="color: #ff0000">插入或删除</span>包含在 transition 组件中的元素时，会自动嗅探目标元素是否应用了CSS过渡或者动画，如果有，那么在恰当的时机添加/删除 CSS类名。



### 过渡动画class

<span style="color: #f7534f;font-weight:600">v-enter-from</span> 定义<span style="color: #a50">进入过渡</span>的开始状态。在元素被插入之前生效，在元素被插入之后的下一帧移除。

<span style="color: #f7534f;font-weight:600">v-enter-active</span> 定义<span style="color: #a50">进入过渡</span>生效时的状态。在整个进入过渡的阶段中应用，在元素被插入之前生效，在过渡/动

画完成之后移除。这个类可以被用来定义进入过渡的过程时间，延迟和曲线函数。

<span style="color: #f7534f;font-weight:600">v-enter-to</span> 定义<span style="color: #a50">进入过渡</span>的结束状态。在元素被插入之后下一帧生效 (与此同时 v-enter-from 被移除)，在过渡/

动画完成之后移除。

<span style="color: #f7534f;font-weight:600">v-leave-from</span> 定义<span style="color: #a50">离开过渡</span>的开始状态。在离开过渡被触发时立刻生效，下一帧被移除。

<span style="color: #f7534f;font-weight:600">v-leave-active</span> 定义<span style="color: #a50">离开过渡</span>生效时的状态。在整个离开过渡的阶段中应用，在离开过渡被触发时立刻生效，在

过渡/动画完成之后移除。这个类可以被用来定义离开过渡的过程时间，延迟和曲线函数。

<span style="color: #f7534f;font-weight:600">v-leave-to</span> 定义<span style="color: #a50">离开过渡</span>的结束状态。在离开过渡被触发之后下一帧生效 (与此同时 v-leave-from 被删除)，在过渡动画完成之后移除。



### 通过animation实现

```react
<transition name="bounce">
  <h2 v-if="show">hey</h2>
</transition>

<style scoped>
.bounce-enter-active {
  animation: bounce-in 0.5s;
}
.bounce-leave-active {
  animation: bounce-in 0.5s reverse; // 反转
}
@keyframes bounce-in {
  0% {
    transform: scale(0)
  }
  50% {
    transform: scale(1.2)
  }
  100% {
    transform: scale(1)
  }
}
</style>
```



### 更多配置



#### 监听过渡/动画

```react
<transition type="transition">
  <h2 v-if="show">hey</h2>
</transition>
```

:whale: 如果同时设置了过渡和动画，可以通过 `type` 属性设置具体监听的类型，另外一个值为 animation。



#### 显示的指定动画时间

```react
// 同时设置进入和离开的过渡时间
<transition :duration="1000">
  <h2 v-if="show">hey</h2>
</transition>

// 分别设置进入和离开的过渡时间
<transition :duration="{enter: 800, leave: 1000}">
  <h2 v-if="show">hey</h2>
</transition>
```

:whale: 过渡时间除去监听外，也可以直接设置，此时内部的过渡/动画时间无效。



#### 元素的切换解决

> 动画在两个元素之间切换时，默认同时发生，可以通过 `mode` 属性改变行为。

```html
<transition mode="out-in" >
  <h2 v-if="show">male</h2>
  <h2 v-else>female</h2>
</transition>
```

:whale: 设置为 in-out 表示新元素先进行过渡，完成之后当前元素过渡离开。



#### 初次渲染添加动画

> 默认情况下，初次渲染时没有过渡/动画效果，可以添加 `appear` 属性改变行为。

```html
<transition name="demo" appear>
  <h2 v-if="show">hey</h2>
</transition>
```



### animation.css

> 手动编写动画效率是比较低的，可以引用一些**第三方库的动画库**，该库通过css实现。

**安装**

```elm
npm install animation.css
```

**引入**

<span style="backGround: #efe0b9">main.js</span>

```
import "animation.css"
```



#### 使用定义动画

> 使用方式一。


```react
<transition name="demo">
  <h2 v-if="show">hey</h2he>
</transition>

<style scoped>
.title {
  display: inline-block;
}
.demo-entry-active {
  animation: bounceInUp 1s ease-in;
}
.demo-leave-active {
  animation: bounceInUp 1s ease-in reverse; // 反转
}
</style>
```



#### 使用定义动画类名

> 使用方式二。

```html
<transition enter-active-class="animate__animated animate__fadeInDown">
  <h2 v-if="show">hey</h2he>
</transition>
```

:whale: 第二个类名为具体的动画，第一个类名为基础效果（如时长）。



##### 自定义过渡class

> 可以通过以下 attribute 来自定义过渡类名。

enter-from-class

enter-active-class

enter-to-class

leave-from-class

leave-active-class

leave-to-class

:whale:  优先级高于普通的类名，这对于 Vue 的过渡系统和其他第三方 CSS 动画库，如 [Animate.css](https://daneden.github.io/animate.css/) 结合使用十分有用。



### gsap

> 该库可以<span style="color: #ff0000">通过JavaScript为CSS属性、SVG、Canvas</span>等设置动画，并且是浏览器兼容的。
>

**安装**

```elm
npm install gsap
```



#### 使用示例

```react
<transition @enter="enter"
            @leave="leave"
            :css="false">
  <h2 class="title" v-if="isShow">Hello World</h2>
</transition>

import gsap from 'gsap';

methods: {
  // el为传入的元素/添加过渡的元素
  enter(el, done) {
    gsap.from(el, {
      scale: 0,
      x: 200,
      onComplete: done
    })
  },
  leave(el, done) {
    gsap.to(el, {
      scale: 0,
      x: 200,
      onComplete: done
    })
  }
}

.title {
  display: inline-block;
}
```



##### Javascript勾子

```html
<transition
  @before-enter="beforeEnter"
  @enter="enter"
  @after-enter="afterEnter"
  @enter-cancelled="enterCancelled"
  @before-leave="beforeLeave"
  @leave="leave"
  @after-leave="afterLeave"
  @leave-cancelled="leaveCancelled"
  :css="false"
>
  <!-- ... -->
</transition>
```

```javascript
methods: {
  beforeEnter(el) {},
  enter(el, done) {
    ...
    done()
  },
}
```

:ghost: 其中 `enter` 和 `leave` 的回调有第二个参数 `done`。当只用 JavaScript 过渡的时候，必须使用 `done` 进行回调。否则，它们将被同步调用，过渡会立即完成。

:ghost: 一般用的比较多的就是 <span style="color: #a50">@enter</span> 和 <span style="color: #a50">@leave</span> 。

:ghost:  推荐对于仅使用 JavaScript 过渡的元素添加 `v-bind:css="false"`，Vue 会跳过 CSS 的检测。这也可以避免过渡过程中 CSS 的影响。



### (例)实现数字变化

```react
<input type="number" step="100" v-model="counter">
<h2>当前计数: {{showCounter}}</h2>
    
<script>
  import gsap from 'gsap';

  export default {
    data() {
      return {
        counter: 0,
        showNumber: 0
      }
    },
    computed: {
      showCounter() {
        return this.showNumber.toFixed(0);
      }
    },
    watch: {
      counter(newValue) {
        gsap.to(this, {duration: 1, showNumber: newValue})
      }
    }
  }
</script>
```



### 列表过渡

> 前面的栗子中，过渡动画只是**针对单个元素或者组件**的；
>
> 如果希望列表中添加删除数据也有动画执行，就可以使用 <span style="color: #a50"><transition-group> 组件</span>来完成。



- 默认情况下，它不会渲染一个元素的包裹器，但可以用 tag 属性指定一个元素进行渲染； 

- 过渡模式不可用，因为不再相互切换特有的元素；

- 内部元素总是需要提供唯一的 key； 

- CSS 过渡的类将<span style="color: #ff0000">会应用在内部的元素</span>中，而不是这个组/容器本身。



#### (例)实现插入动画

```elm
npm install lodash
```

```react
<template>
  <div>
    <button @click="addNum">添加数字</button>
    <button @click="removeNum">删除数字</button>
    <button @click="shuffleNum">数字洗牌</button>

    <transition-group tag="p" name="demo">
      <span v-for="item in numbers" :key="item" class="item">
        {{item}}
      </span>
    </transition-group>
  </div>
</template>

<script>
  import _ from 'lodash';

  export default {
    data() {
      return {
        numbers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
        numCounter: 10
      }
    },
    methods: {
      // 随机添加数字到一个位置
      addNum() {
        this.numbers.splice(this.randomIndex(this.numbers), 0, this.numCounter++)
      },
      // 随机删除一个位置的数字
      removeNum() {
        this.numbers.splice(this.randomIndex(this.numbers), 1)
      },
      // 打乱数组顺序
      shuffleNum() {
        this.numbers = _.shuffle(this.numbers);
      },
      randomIndex(arr) {
        return Math.floor(Math.random() * arr.length)
      }
    },
  }
</script>
```

```less
.item {
  margin-right: 10px;
  display: inline-block;
}

// 透明度改变 + 纵向插入
.demo-enter-from,
.demo-leave-to {
  opacity: 0;
  transform: translateY(30px);
}

.demo-enter-active,
.demo-leave-active {
  transition: all 1s ease;
}
// 解决目标项消失前仍然占位问题
.demo-leave-active {
  position: absolute;
}
// 给非目标项添加移动效果
.demo-move {
  transition: transform 1s ease;
}
```



#### (例)提示项交替消失

```react
<template>
  <div>
    <input v-model="keyword">
    <transition-group tag="ul" :css="false"
                      @before-enter="beforeEnter"
                      @enter="enter"
                      @leave="leave">
      <li v-for="(item, index) in showNames" :key="item" :data-index="index">
        {{item}}
      </li>
    </transition-group>
  </div>
</template>

<script>
  import gsap from 'gsap';

  export default {
    data() {
      return {
        names: ["abc", "cba", "nba", "why", "lilei", "hmm", "kobe", "james"],
        keyword: ""
      }
    },
    computed: {
      showNames() {
        return this.names.filter(item => item.indexOf(this.keyword) !== -1)
      }
    },
    methods: {
      beforeEnter(el) {
        el.style.opacity = 0;
        el.style.height = 0;
      },
      enter(el, done) {
        gsap.to(el, {
          opacity: 1,
          height: "1.5em",
          delay: el.dataset.index * 0.5, // 每个项的延时不同，实现交替效果
          onComplete: done
        })
      },
      leave(el, done) {
        gsap.to(el, {
          opacity: 0,
          height: 0,
          delay: el.dataset.index * 0.5,
          onComplete: done
        })
      }
    }
  }
</script>
```

:whale: 通过 `data-*` 的技巧，可以将值”传递“到兄弟标签。



## 混入

### 认识Mixin

> 在不同组件间存在相同的代码逻辑时，我们可以对它<span style="color: #ff0000">（代码）</span>进行一个抽取，vue2和vue3都支持<span style="color: #a50">Mixin</span>。

- Mixin对象可以包含任何组件选项； 

- 当组件使用Mixin对象时，Mixin对象的<span style="color: #ff0000">所有选项将被混合</span>到该组件本身的选项中；

#### 基本使用

<span style="backGround: #efe0b9">mixins/demoMixin.js</span>

```javascript
export const demoMixin = {
  data() {...},
  methods: {...},
  created() {...}
}
```

<span style="backGround: #efe0b9">demo.vue</span>

```javascript
import { demoMixin } from './mixins/demoMixin';

export default {
  mixins: [demoMixin],
  ...
}
```



#### 合并规则

**情况一：如果是data函数的返回值对象**

- 返回值对象默认情况下会进行合并； 

- 如果data返回值对象的属性发生了冲突，那么会保留组件自身的数据。

**情况二：如何生命周期钩子函数**

- 生命周期的钩子函数会被合并到数组中，<span style="color: #ff0000">最终都会被调用</span>。

**情况三：值为对象的选项，例如 methods、components 和 directives，将被合并为同一个对象。**

- 比如都有methods选项，并且都定义了方法，那么它们都会生效； 

- 但是如果对象的key重复，那么会取组件对象的键值对。



#### 全局混入

<span style="backGround: #efe0b9">main.js</span>

```javascript
const app = createApp(App);
app.mixin({
  created() {
    console.log('global mixin created');
  }
})
app.mount("#app");
```

:whale: 全局混入也可以配置任何选项，且对每个后代组件生效。



### extends

> 类似于Mixins，用于混入另一个组件的配置项。很少用。

```javascript
import Demo from './Demo.vue';

export default {
  extends: Demo,
  ...
}
```

