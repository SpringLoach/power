## 监听原理

### (理)hash监听原理

```html
<div id="app">
  <a href="#/home">home</a>
  <a href="#/about">about</a>
  <div class="content">Default</div>
</div>

<script>
  const contentEl = document.querySelector('.content');
  window.addEventListener("hashchange", () => {
    switch(location.hash) {
      case "#/home":
        contentEl.innerHTML = "Home";
        break;
      case "#/about":
        contentEl.innerHTML = "About";
        break;
      default:
        contentEl.innerHTML = "Default";
    }
  })
</script>
```

:ghost: 监听路由的 `hash` 变化，（不向服务器请求）动态改变渲染内容。

:whale: `hash` 的优势就是兼容性更好，在老版IE中都可以运行，但是缺陷是有一个 `#`，显得不像一个真实的路径。

### (理)history监听原理

```html
<div id="app">
  <a href="/home">home</a>
  <a href="/about">about</a>
  <div class="content">Default</div>
</div>

<script>
  const contentEl = document.querySelector('.content');

  const changeContent = () => {
    switch(location.pathname) {
      case "/home":
        contentEl.innerHTML = "Home";
        break;
      case "/about":
        contentEl.innerHTML = "About";
        break;
      default: 
        contentEl.innerHTML = "Default";
    }
  }

  const aEls = document.getElementsByTagName("a");
  for (let aEl of aEls) {
    aEl.addEventListener("click", e => {
      e.preventDefault();
      
      const href = aEl.getAttribute("href");
      history.pushState({}, "", href);

      changeContent();
    })
  }

  window.addEventListener("popstate", changeContent)
</script>
```

:ghost: 监听点击和浏览器的回退事件。



## 路由的基本使用流程

第一步：创建路由组件的组件；

第二步：配置路由映射: 组件和路径映射关系的routes数组； 

第三步：通过createRouter创建路由对象，并且传入routes和history模式；

第四步：使用路由: 通过<router-view>；



**安装**

```elm
npm install vue-router@4
```

:whale: 将会安装该大版本(4)下的最新版本。

<span style="backGround: #efe0b9">项目/router/index.js</span>

```javascript
import { createRouter, createWebHistory, createWebHashHistory } from 'vue-router'

import Home from "../pages/Home.vue";
import About from "../pages/About.vue";

// 配置映射关系
const routes = [
  { path: "/home", component: Home },
  { path: "/about", component: About },
];

// 创建一个路由对象router
const router = createRouter({
  routes,
  history: createWebHistory() // hash 为 createWebHashHistory()
})

export default router
```

:ghost: 需要指定路由的模式时，其方式与 vue2 有所不同。

<span style="backGround: #efe0b9">main.js</span>

```javascript
import { createApp } from 'vue'
import router from './router'
import App from './App.vue'

createApp(App).use(router).mount('#app');
```

:whale: 在安装插件的过程中，已经全局注册了 <span style="color: #a50">\<router-view\></span> 等。

<span style="backGround: #efe0b9">App.vue</span>

```html
<template>
  <div id="app">
    <h2>点击跳转</h2>  
    <router-link to="/home">首页</router-link>
    <router-link to="/about">关于</router-link>
      
    <router-view>
  </div>
</template>
```

:ghost: 需要使用 <span style="color: #a50">\<router-view\></span> 声明路由组件出现的位置。



## 默认路由-重定向

<span style="backGround: #efe0b9">router/index.js</span>

```javascript
const routes = [
  { path: "/", redirect: "/home" },
  { path: "/home", component: Home },
  { path: "/about", component: About },
];
```



## router-link自定义标签

> 在 vue2 中用于指定元素种类的 tag 标签已废弃。现在（VueRoute4）可以通过插槽指定渲染标签/组件等。

```html
<router-link to="/home">
  <h2>跳转</h2>
</router-link>
```



### 作用域插槽值

```html
<!-- props: href跳转的链接 -->
<!-- props: route路由对象（对象） -->
<!-- props: navigate导航函数（函数） -->
<!-- props: isActive 是否当前处于活跃的状态（布尔值） -->
<!-- props: isExactActive 是否当前处于精确的活跃状态（布尔值） -->
<router-link to="/home" v-slot="props" custom>
  <button>{{props.href}}</button>
  <button @click="props.navigate">哈哈哈</button>
</router-link>
```

:turtle: 默认情况下，都会存在带有导航的 <span style="color: #a50">a</span> 标签包裹插槽内容。

:turtle: 添加 custom 属性后，会去除包裹的 <span style="color: #a50">a</span> 标签，但想要内部元素存在导航功能，需要手动添加跳转路由逻辑。（props.navigate）本身可以实现。



## router-view实现动画

```html
<router-view v-slot="props">
  <transition name="demo">
    <keep-alive>
      <component :is="props.Component"></component>
    </keep-alive>
  </transition>
</router-view>
```

:turtle: 在 VueRouter4 中，可以通过 props.Component 拿到路由组件，它同时拥有 props.route。

:whale: 在这个例子里，<span style="color: #a50">keep-alive</span> 不是必须的，在同时需要动画和缓存时，它便是这样的结构。

```css
.demo-enter-from,
.demo-leave-to {
  opacity: 0;
}

.demo-enter-active,
.demo-leave-active {
  transition: opacity 1s ease;
}
```



## 路由懒加载

> 通过路由懒加载，能把不同路由对应的组件分割成不同的代码块，然后当路由被访问的时候才加载对应组件，可以提高首屏的渲染效率。

<span style="backGround: #efe0b9">router/index.js</span>

```javascript
const routes = [
  { path: "/", redirect: "/home" },
  { path: "/home", component: () => import('../pages/Home.vue') },
  { path: "/about", component: () => import('../pages/About.vue') },
];
```



### 分包命名

<span style="backGround: #efe0b9">router/index.js</span>

```javascript
const routes = [
  { 
    path: "/",
    redirect: "/home" },
  { 
    path: "/home",
    component: () => import(/* webpackChunkName: "home-chunk" */'../pages/Home.vue')
  },
  {
    path: "/about",
    component: () => import(/* webpackChunkName: "about-chunk" */'../pages/About.vue')
  },
];
```



## name和meta

<span style="backGround: #efe0b9">router/index.js</span>

```javascript
const routes = [
  { 
    path: "/demo",
    component: () => import('../pages/Home.vue'),
    name: "Demo",
    meta: { menuItem: true }
  },
];
```

:whale: <span style="color: #a50">name</span> 可以用于跳转路由，设置动态路由等。



## 动态路由

> 使用动态路由可以在路径中展示对应的Id等信息。

### 动态路由的基本匹配

<span style="backGround: #efe0b9">router/index.js</span>

```javascript
{ 
  path: "/user/:username",
  component: () => import("../pages/User.vue") 
},
```

<span style="backGround: #efe0b9">App.vue</span>

```html
<router-link to="/user/master">用户</router-link>
```

:flipper: 需要与路径格式完全相同，才能匹配到对应的路由。



### 获取动态路由的值

<span style="backGround: #efe0b9">User.vue</span>

```html
<script>
  import { useRoute } from "vue-router";

  export default {
    created() {
      console.log(this.$route.params.username);
    },
    setup() {
      const route = useRoute();
      console.log(route.params.username);
    }
  }
</script>
```

  :turtle: 通过实例化 `useRoute` 可以拿到组件对应的路由实例。



## (例)NotFound

<span style="backGround: #efe0b9">router/index.js</span>

```javascript
const routes = [
  { 
    path: "/home",
    component: () => import(/* webpackChunkName: "home-chunk" */'../pages/Home.vue')
  },
  ...,
  {
    path: "/:pathMatch(.*)",
    component: () => import('../pages/NotFound.vue')
  },
];
```

:ghost: 如果没有任意路径与之匹配，将使用最后一项。

<span style="backGround: #efe0b9">NotFound.vue</span>

```html
<template>
  <div>
    <h2>Page Not Found</h2>
  </div>
</template>
```



## 编程式导航

```html
<button @click="jumpToAbout">关于</button>

<script>

import { useRouter } from 'vue-router'

export default {
  // Composition API
  setup() {
    const router = useRouter();

    const jumpToAbout = () => {
      router.push("/about")
    }

    return { jumpToAbout }
  }
}
</script>
```

```javascript
// Options API
methods: {
  jumpToAbout() {
    this.$router.replace({
      path: "/about",
      query: { age: 12 }
    })
  }
},
```



## 动态添加路由

需要根据用户不同的权限，注册不同的路由，然后动态展示导航栏时，就不能直接把路由配置写死。

**思路**

```javascript
const routes = []
const router = createRouter({routes})

// 如果满足条件，就进行添加路由
if(管理员) {
  router.addRoute({ path: '/order', name: 'order', component: () => import(order.vue) });
}

app.use(router);
```

<span style="backGround: #efe0b9">router/index.js</span>

```javascript
const routes = [...]

// 创建一个路由对象router
const router = createRouter({
  routes,
  history: createWebHistory()
})

// 动态添加路由
const categoryRoute = {
  path: "/category",
  component: () => import("../pages/Category.vue")
}

// 添加顶级路由对象，可以拓展为数组对象展开传入，还是要遍历内部传入？
router.addRoute(categoryRoute);

// 添加二级路由对象
router.addRoute("home", {
  path: "moment",
  component: () => import("../pages/HomeMoment.vue")
})

export default router
```

:turtle: 如果要为 route 添加一个 children 路由，那么可以传入该 route 对应 的 <span style="color: #a50">name</span> 作为首参。



## 动态删除路由

> 实际应用较少。

方式一：添加一个name相同的路由；

```javascript
router.addRoute({ path: '/about', name: 'about', component: About });
router.addRoute({ path: '/home', name: 'about', component: Home });
```

:ghost: 其实就是替换了原本的路由。

方式二：通过removeRoute方法，传入路由的名称； 

```javascript
router.addRoute({ path: '/about', name: 'about', component: About });
router.removeRoute('about')
```

方式三：通过addRoute方法的返回值回调；

```javascript
const removeRoute = router.addRoute({ path: '/about', name: 'about', component: About });
removeRoute(); // 如果存在则删除路由
```



## 全局前置守卫

> 实现登录验证。

```react
const router = createRouter({...})

router.beforeEach((to, from) => {
  if (to.path !== "/login") {
    const token = window.localStorage.getItem("token");
    if (!token) {
      return "/login"
    }
  }
})

export default router
```



### 参数

<span style="color: #f7534f;font-weight:600">to</span> 即将进入的路由Route对象；

<span style="color: #f7534f;font-weight:600">from</span> 即将离开的路由Route对象；

<span style="color: #f7534f;font-weight:600">next</span> 控制跳转，在 vue3 中不再推荐使用，而是建议<span style="color: #ff0000">通过返回值</span>实现跳转。



### 返回值

| 返回值             | --                                                    |
| ------------------ | ----------------------------------------------------- |
| false              | 取消当前导航                                          |
| 无返回值/undefined | 进行默认导航                                          |
| 路由地址           | 可以是 str 或 obj （可以包含 path、query、params 等） |



# VueX

> 使用场景：对于多个视图需要依赖/允许改变的状态（数据）进行管理。
>
> Vue3 与 Vuex4 相匹配； Vue2 与 Vuex3 相匹配。



## devtools插件

### 浏览器安装方式

谷歌 - ☰ - 更多工具 - 扩展程序 - ☰ - 打开 Chrome 网上应用店 - 搜索 vue devtool - 安装 6.0.0 以上版本（支持vue3）



### 手动安装方式

**[下载代码](https://github.com/vuejs/devtools/tree/v6.0.0-beta.15)**

```elm
yarn install
```

```elm
yarn run build
```

谷歌 - ☰ - 更多工具 - 扩展程序 - 加载已解压的扩展程序 - 选中 `shell-chrome`



## 基本使用流程

```elm
npm install vuex@next
```

<span style="backGround: #efe0b9">项目/store/index.js</span>

```javascript
import { createStore } from 'vuex'

const store = createStore({})

export default store
```

<span style="backGround: #efe0b9">main.js</span>

```javascript
import { createApp } from 'vue'
import App from './App'
import store from './store'

createApp(App).use(store).mount('#app')
```



### state 的类型

<span style="backGround: #efe0b9">store/index.js</span>

```javascript
import { createStore } from 'vuex'

const store = createStore({
  state() {
    return {
      counter: 100
    }
  },
  mutations: {
    increment(state) {
      state.counter++
    },
    decrement(state) {
     state.counter--
    }
  }
})

export default store
```

:ghost: 以往，state 选项往往写成对象，现在也支持函数形式，并且更推荐。

<span style="backGround: #efe0b9">Demo.vue</span>

```javascript
methods() {
  add() {
    this.$store.commit('increment')
    console.log(this.$store.state.counter);
  }
}
```



## setup 中使用 state

### 常规用法

```react
// 直接在模板使用
<h2>{{ $store.state.counter }}</h2>
// 单个获取出来的使用
<h2>{{sCounter}}</h2>
// 批量获取出来的使用
<h2>{{counter}}</h2>
<h2>{{name}}</h2>

import { mapState, useStore } from 'vuex'
import { computed } from 'vue'

setup() {
  // store 相当于其他选项中的 this.$store
  const store = useStore()
  
  // 通过计算属性保存状态值，适合于保存零星状态时多次调用
  const sCounter = computed(() => store.state.counter)
  
  // storeStateFns: {counter: function, name: function}
  // 通过计算属性，把原先的函数转化为了 ref 对象
  // storeState:    {counter: ref, name: ref}
  const storeStateFns = mapState(["counter", "name"])
  
  const storeState = {}
  Object.keys(storeStateFns).forEach(fnKey => {
    const fn = storeStateFns[fnKey].bind({$store: store})
    storeState[fnKey] = computed(fn)
  })

  return {
    sCounter,
    ...storeState
  }
}
```

:whale:  computed(fn)，本质上接收的一个特殊的函数，并且在内部会调用到 this.$store.state，所以需要使用到 `bind` 为其提供该值。

:whale:  通过 `...mapState(["counter", "name"])` 解析出来的，其实是一个个的函数，所以它才能在 computed 选项中这么使用。



### 封装使用

<span style="backGround: #efe0b9">项目/hooks/useState.js</span>

```javascript
import { computed } from 'vue'
import { mapState, useStore } from 'vuex'

export function useState(mapper) {
  const store = useStore()

  // 支持数组和对象，获取到对应的对象functions: {name: function, age: function}
  const storeStateFns = mapState(mapper)

  // 对数据进行转换: {name: ref, age: ref}
  const storeState = {}
  Object.keys(storeStateFns).forEach(fnKey => {
    const fn = storeStateFns[fnKey].bind({$store: store})
    storeState[fnKey] = computed(fn)
  })

  return storeState
}
```

<span style="backGround: #efe0b9">Demo.vue</span>

```javascript
import { useState } from '../hooks/useState'

setup() {
  // 参数可以传入数组类型
  const storeState = useState(["counter", "name", "age", "height"])
  // 参数可以传入对象类型，用于重命名
  const storeState2 = useState({
    sCounter: state => state.counter,
    sName: state => state.name
  })

  return {
    ...storeState,
    ...storeState2
  }
}
```

:whale: 困惑：这里的 state 是从哪里来的。



## setup 中使用 getters

### 常规用法

<span style="backGround: #efe0b9">Demo.vue</span>

```javascript
import { computed } from 'vue'
import { useStore } from 'vuex'

setup() {
  const store = useStore()

  const sNameInfo = computed(() => store.getters.nameInfo)
  return {
    sNameInfo
  }
}
```



### 封装使用

<span style="backGround: #efe0b9">hooks/useMapper.js</span>

```javascript
import { computed } from 'vue'
import { useStore } from 'vuex'

export function useMapper(mapper, mapFn) {
  const store = useStore()

  const storeStateFns = mapFn(mapper) // ①

  const storeState = {}
  Object.keys(storeStateFns).forEach(fnKey => {
    const fn = storeStateFns[fnKey].bind({$store: store})
    storeState[fnKey] = computed(fn)
  })

  return storeState
}
```

:ghost: 封装 getters 和封装 state，唯一的差别在于①处调用的方法，故可以对这部分代码进行公共使用。

<span style="backGround: #efe0b9">hooks/useGetters.js</span>

```javascript
import { mapGetters } from 'vuex'
import { useMapper } from './useMapper'

export function useGetters(mapper) {
  return useMapper(mapper, mapGetters)
}
```

<span style="backGround: #efe0b9">Demo.vue</span>

```javascript
import { useGetters } from '../hooks/useGetters'

setup() {
  const storeGetters = useGetters(["nameInfo", "ageInfo", "heightInfo"])
  return {
    ...storeGetters
  }
}
```



###  导出出口

<span style="backGround: #efe0b9">hooks/index.js</span>

```javascript
import { useGetters } from './useGetters';
import { useState } from './useState';

export {
  useGetters,
  useState
}
```



## setup 中使用 mutations

### 常规写法

```react
<button @click="decrement">-1</button>

import { mapMutations } from 'vuex'

setup() {
  const storeMutations = mapMutations(["increment", "decrement"])

  return {
    ...storeMutations
  }
}
```

:whale: 由于解构出去的方法会被调用，所以可以直接这么使用。



## actions

### (例)通过接口数据更新state

> 可以在组件中调用接口，拿到回调后使用 muation 提交，但既然改变的是 vuex 中的状态，调用接口的部分让它内部实现也可以。

<span style="backGround: #efe0b9">Demo.vue</span>

```javascript
mounted() {
  this.$store.dispatch("incrementAction")
}
```

<span style="backGround: #efe0b9">store/index.js</span>

```javascript
import axios from 'axios'

state() {
  return {
    banners: null,
  }
},
mutaions: {
  addBannerData(state, payload) {
    state.banners = payload
  },
},
actions: {
  getHomeMultidata(context) {
    axios.get("https://demo").then(res => {
      context.commit("addBannerData", res.data.baner)
    })
  }
}
```

### (例)返回Promise

<span style="backGround: #efe0b9">Demo.vue</span>

```javascript
mounted() {
  const promise = this.$store.dispatch("incrementAction")
  promise.then(res => {
    console.log(res)
  }).catch(err => {
    console.log(err)
  })
}
```

<span style="backGround: #efe0b9">store/index.js</span>

```javascript
actions: {
  getHomeMultidata(context) {
    return new Promise((resolve, reject) => {
      axios.get("https://demo").then(res => {
        context.commit("addBannerData", res.data.baner)
        resolve({name: "coderwhy", age: 18})
      }).catch(err => {
        reject(err)
      })
    })
  }
}
```



### context的对象结构赋值

```javascript
actions: {
  aChangeName({ state, getters, commit, dispatch, rootState, rootGetters }) {
    console.log(123);
  }
}
```

:whale:  其中的 <span style="color: #a50">rootState</span> 和 <span style="color: #a50">rootGetters</span> 一般在子模块获取根模块的 state 和 getters 时用到。



### 不同的提交风格

> 同 mutations。



## setup 中使用 actions

### 常规写法

```react
<button @click="decrementAction">-1</button>

import { mapActions } from 'vuex'

setup() {
  const actions = mapActions(["incrementAction", "decrementAction"])

  return {
    ...actions
  }
}
```



## mutations

### mutaions的目录结构

```elm
- store
  + modules
    - home.js
    - user.js
  + index.js
```

<span style="backGround: #efe0b9">store/index.js</span>

```javascript
import { createStore } from "vuex"
import home from './modules/home'
import user from './modules/user'

const store = createStore({
  state() {
    return {}
  },
  getters: {},
  mutations: {}
  },
  modules: {
    home,
    user
  }
});

export default store;
```

<span style="backGround: #efe0b9">home.js</span>

```javascript
const homeModule = {
  state() {
    return {}
  },
  getters: {},
  mutations: {},
  actions: {}
}

export default homeModule
```



#### 默认使用

<span style="backGround: #efe0b9">Demo.vue</span>

```react
// 根部的状态
<h2>{{ $store.state.rootCounter }}</h2>
// 模块的状态
<h2>{{ $store.state.home.homeCounter }}</h2>

// 根部的 getter
<h2>{{ $store.getters.rootAge }}</h2>
// 模块的 getter
<h2>{{ $store.getters.homeAge }}</h2>

// 根部的 mutation
<button>@click="$store.commit("rootIncrement")"</button>
// 模块的 mutation
<button>@click="$store.commit("homeIncrement")"</button>

// 根部的 action
<button>@click="$store.dispatch("rootDe")"</button>
// 模块的 action
<button>@click="$store.dispatch("homeDe")"</button>
```

:ghost: 当出现模块和根部的方法重名的时候，在模块中调用时，每处的方法都会被调用。

#### 命名空间使用

```react
// 根部的状态
<h2>{{ $store.state.rootCounter }}</h2>
// 模块的状态
<h2>{{ $store.state.home.homeCounter }}</h2>

// 根部的 getter
<h2>{{ $store.getters.rootAge }}</h2>
// 模块的 getter
<h2>{{ $store.getters["home/homeAge"] }}</h2>

// 根部的 mutation
<button>@click="$store.commit("rootIncrement")"</button>
// 模块的 mutation
<button>@click="$store.commit("home/homeIncrement")"</button>

// 根部的 action
<button>@click="$store.dispatch("rootDe")"</button>
// 模块的 action
<button>@click="$store.dispatch("home/homeDe")"</button>
```

:ghost: 添加了命名空间后，不能再像根部的 getter/方法 那样去使用了，会导致找不到。

<span style="backGround: #efe0b9">home.js</span>

```javascript
const homeModule = {
  namespaced: true, // 添加这一个属性
  state() {
    return {}
  },
  getters: {},
  mutations: {},
  actions: {}
}

export default homeModule
```



#### 使用根部的方法

<span style="backGround: #efe0b9">home.js</span>

```javascript
const homeModule = {
  namespaced: true, 
  mutations: {
    increment(state) {
      console.log(state);
    }
  },
  actions: {
    dos({commit, dispatch}) {
      commit("increment")
      commit("increment", null, {root: true})
      dispatch("incrementAction", null, {root: true})
    }
  }
}
```

:ghost: 第二个参数为载荷，通过第三个参数配置使用根部方法。



### 辅助函数

#### opstions API

##### 写法一

```javascript
import { mapState, mapGetters, mapMutations, mapActions } from "vuex";

export default {
  computed: {
    ...mapState({
      homeCounter: state => state.home.homeCounter
    }),
    ...mapGetters({
      doubleHomeCounter: "home/doubleHomeCounter"
    })
  },
  methods: {
    ...mapMutations({
      increment: "home/increment"
    }),
    ...mapActions({
      incrementAction: "home/incrementAction"
    }),
  },
}
```

##### 写法二

```javascript
import { mapState, mapGetters, mapMutations, mapActions } from "vuex";

export default {
  computed: {
    ...mapState("home", ["homeCounter"]),
     ...mapGetters("home", ["doubleHomeCounter"])
  },
  methods: {
    ...mapMutations("home", ["increment"]),
    ...mapActions("home", ["incrementAction"]),
  },
}
```

##### 写法三(推荐)

```javascript
import { createNamespacedHelpers } from "vuex";

const { mapState, mapGetters, mapMutations, mapActions } = createNamespacedHelpers("home");

export default {
  computed: {
    ...mapState(["homeCounter"]),
    ...mapGetters(["doubleHomeCounter"])
  },
  methods: {
    ...mapMutations(["increment"]),
    ...mapActions(["incrementAction"]),
  },
}
```



#### composition  API

<span style="backGround: #efe0b9">hooks/useGetters.js</span>

```javascript
import { mapGetters, createNamespacedHelpers } from 'vuex'
import { useMapper } from './useMapper'

export function useGetters(moduleName, mapper) {
  let mapperFn = mapGetters
  if (typeof moduleName === 'string' && moduleName.length > 0) { // 验证传入的是个模块名
    mapperFn = createNamespacedHelpers(moduleName).mapGetters
  } else {
    mapper = moduleName
  }

  return useMapper(mapper, mapperFn)
}
```

:whale:  原先定义的方法，只能对根部的状态进行处理，故需要添加处理模块状态的能力。

<span style="backGround: #efe0b9">hooks/useState.js</span>

```javascript
import { mapState, createNamespacedHelpers } from 'vuex'
import { useMapper } from './useMapper'

export function useState(moduleName, mapper) {
  let mapperFn = mapState
  if (typeof moduleName === 'string' && moduleName.length > 0) {
    mapperFn = createNamespacedHelpers(moduleName).mapState
  } else {
    mapper = moduleName
  }

  return useMapper(mapper, mapperFn)
}
```

<span style="backGround: #efe0b9">Demo.vue</span>

```javascript
import { useState, useGetters } from '../hooks/index'

const { mapMutations, mapActions } = createNamespacedHelpers("home")

setup() {
  // 使用根部
  const state = useState(["rootCounter"])
  const rootGetters = useGetters(["doubleRootCounter"])
  // 使用模块
  const getters = useGetters("home", ["doubleHomeCounter"])

  const mutations = mapMutations(["increment"])
  const actions = mapActions(["incrementAction"])

  return {
    ...state,
    ...getters,
    ...rootGetters
    ...mutations,
    ...actions
  }
}
```

:ghost: 不能取出模块中的 state 和 getters 直接遍历到返回值，它们仍是一个个的方法。



## nexttick

### (例)计算元素高度

> 情景： 在操作元素后，获取该元素的高度。

<span style="backGround: #efe0b9">Demo.vue</span>

```react
<h2 class="title" ref="titleRef">{{message}}</h2>
<button @click="addMessageContent">添加内容</button>

import { ref, nextTick } from "vue";

export default {
  setup() {
    const message = ref("")
    const titleRef = ref(null) // 获取元素/组件

    const addMessageContent = () => {
      message.value += "哈哈哈哈哈哈哈哈哈哈"
      // 更新 DOM 后执行
      nextTick(() => {
        console.log(titleRef.value.offsetHeight)
      })
    }

    return {
      message,
      titleRef,
      addMessageContent
    }
  }
}
```

:whale:  像 watch、组件更新、生命周期、nextTick 的回调都被当作微任务执行。

#### 错误示例

```javascript
import { ref, onUpdated } from "vue";

export default {
  setup() {
    const message = ref("")
    const titleRef = ref(null)

    const addMessageContent = () => {
      message.value += "哈哈哈哈哈哈哈哈哈哈"
      console.log(titleRef.value.offsetHeight)  // 此时获取到的是更新前的值
    }

    onUpdated(() => {
      console.log(titleRef.value.offsetHeight)  // 任何的 DOM 更新都会触发该钩子，即便加判断也会存在多次调用
    })

    return {
      message,
      titleRef,
      addMessageContent
    }
  }
}
```





## 通过路径返回资源

使用history模式时，由前端根据路由匹配资源那没有问题，但由于服务器没有对应路径的资源，在刷新时会请求资源而返回404。

使用 `npm run dev` 不会出现这种情况，是因为 vue-cli 默认配置了 webpack 的 historyApiFallback，让它匹配不到资源时自动返回 index.html 的内容。

<span style="backGround: #efe0b9">vue.config.js</span>

```javascript
module.expoets = {
  configureWebpack: {
    devServe: {
      historyApiFallback: true
    }
  }
}
```





