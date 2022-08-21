# 路由

核心：页面不刷新；监听路径的变化，切换内容。

## 原理

### 监听hash的改变

```html
<body>

  <div id="app">
    <a href="#/home">首页</a>
    <a href="#/about">关于</a>

    <div class="router-view"></div>
  </div>
  
  <script>
    // 获取router-view的DOM
    const routerViewEl = document.getElementsByClassName("router-view")[0];

    // 监听URL的改变
    window.addEventListener("hashchange", () => {
      switch (location.hash) {
        case "#/home":
          routerViewEl.innerHTML = "首页";
          break;
        case "#/about":
          routerViewEl.innerHTML = "关于";
          break;
        default:
          routerViewEl.innerHTML = "";
      }
    })
  </script>
</body>
```



### 监听history的改变

```html
<body>

  <div id="app">
    <a href="/home">首页</a>
    <a href="/about">关于</a>

    <div class="router-view"></div>
  </div>

  <script>
    // 1.获取router-view的DOM
    const routerViewEl = document.getElementsByClassName("router-view")[0];

    // 获取所有的a元素, 自己来监听a元素的改变
    const aEls = document.getElementsByTagName("a");
    for (let el of aEls) {
      el.addEventListener("click", e => {
        e.preventDefault();
        const href = el.getAttribute("href");
        history.pushState({}, "", href);
        urlChange();
      })
    }

    // 执行返回/前进操作时, 也能执行urlChange
    window.addEventListener('popstate', urlChange);

    // 监听URL的改变
    function urlChange() {
      switch (location.pathname) {
        case "/home":
          routerViewEl.innerHTML = "首页";
          break;
        case "/about":
          routerViewEl.innerHTML = "关于";
          break;
        default:
          routerViewEl.innerHTML = "";
      }
    }

  </script>

</body>
```

:octopus: 手动跳转时，还需要自行调用 urlChange；

:turtle: 这里需要<span style="color: #ff0000">阻止</span> a 标签的默认行为：除非改变 hash，否则会造成页面刷新。



## react-router

```elm
yarn add react-router-dom
```



| 组件          | 说明                                          |
| ------------- | --------------------------------------------- |
| BrowserRouter | 使用 history 模式，会将相应的路径传递给子组件 |
| HashRouter    | 使用 hash 模式，会将相应的路径传递给子组件    |
| Link          | 最终会被渲染为 a 标签                         |
| Link          | to 属性用于设置跳转到的路径                   |
| Route         | 用于路径的匹配，默认模糊匹配                  |
| Route         | path 属性用于设置匹配到的路径                 |
| Route         | exact 表示路径精准匹配才会渲染                |
| Route         | component 匹配到路径后，渲染的组件            |
| Route         | 匹配后会将组件渲染到标签占位的位置            |

### 基本使用

```react
import React, { PureComponent } from 'react';

import {
  BrowserRouter
  Link,
  Route
} from 'react-router-dom';

import Home from './pages/home';
import About from './pages/about';
import Profile from './pages/profile';

class App extends PureComponent {
  render() {
    return (
      <div>
		<BrowserRouter>
          <Link to="/">首页</LinkLink>
          <Link to="/about">关于</LinkLink>
          <Link to="/profile">我的</LinkLink>
            
          <Route exact path="/" component={Home} />
          <Route path="/about" component={About} />
          <Route path="/profile" component={Profile} />
        </BrowserRouter>
      </div>
    )
  }
}
```

:ghost: 这里将 BrowserRouter  替换为 HashRouter 即表示使用 hash 模式；

:ghost: 默认情况下，如果多个 Route 匹配条件，也会渲染多个组件。



### 激活的链接

| 组件    | 说明                                       |
| ------- | ------------------------------------------ |
| NavLink | 比起 Link 组件，更容易实现激活态的样式控制 |
| NavLink | activeStyle 当前路径为活跃时的样式         |
| NavLink | activeClassName 活跃时添加的class          |
| NavLink | exact 是否精准匹配；默认为模糊匹配         |

```react
import React, { PureComponent } from 'react';

import {
  BrowserRouter
  Link,
  Route
} from 'react-router-dom';

import Home from './pages/home';
import About from './pages/about';
import Profile from './pages/profile';

export default class App extends PureComponent {
  render() {
    return (
      <div>
		<BrowserRouter>
          <NavLink exact to="/" activeStyle={{color: "red"}}>首页</NavLink>
          <NavLink to="/about" activeStyle={{color: "red"}}>关于</NavLink>
          <NavLink to="/profile" activeStyle={{color: "red"}}>我的</NavLink>
            
          <Route exact path="/" component={Home} />
          <Route path="/about" component={About} />
          <Route path="/profile" component={Profile} />
        </BrowserRouter>
      </div>
    )
  }
}
```



### 首个匹配渲染

| 组件   | 说明                               |
| ------ | ---------------------------------- |
| Switch | 只渲染首个匹配条件的路由，由上往下 |

```react
import React, { PureComponent } from 'react';

import {
  BrowserRouter
  Link,
  Route,
  Switch
} from 'react-router-dom';

// 省略组件导入

export default class App extends PureComponent {
  render() {
    return (
      <div>
		<BrowserRouter>
          <NavLink exact to="/" activeClassName="link-active">首页</NavLink>
          <NavLink to="/about" activeClassName="link-active">关于</NavLink>
          <NavLink to="/profile" activeClassName="link-active">我的</NavLink>
          
          <Switch>
            <Route exact path="/" component={Home} />
            <Route path="/about" component={About} />
            <Route path="/profile" component={Profile} />
            <Route component={NoMatch} />
          </Switch>
        </BrowserRouter>
      </div>
    )
  }
}
```

:ghost: <span style="color: #a50">Route</span> 组件不添加 path 属性，表示什么路径都能匹配上。



### 路由重定向

| 组件     | 说明                                           |
| -------- | ---------------------------------------------- |
| Redirect | 当这个组件出现时，就会执行跳转到对应的to路径中 |

场景：根据用户有无登录，渲染不同的组件

父组件

```react
<Switch>
  <Route exact path="/" component={Home} />
  <Route path="/user" component={User} />
</Switch>
```

业务组件

```react
import { Redirect } from 'react-router-dom';

export default class User extends PureComponent {
  constructor(props) {
    super(props);

    this.state = {
      isLogin: true
    }
  }

  render() {
    return this.state.isLogin ? (
      <div>
        <h2>User</h2>
        <h2>用户名: coderwhy</h2>
      </div>
    ): <Redirect to="/login"/>
  }
}
```



### 路由嵌套

父组件

```react
<Switch>
  <Route exact path="/" component={Home} />
  <Route path="/about" component={About} />
</Switch>
```

子组件

```react
export default class About extends PureComponent {
  render() {
    return (
      <div>
        <NavLink exact to="/about">企业历史</NavLink>
        <NavLink exact to="/about/culture">企业文化</NavLink>
        <NavLink exact to="/about/contact">联系我们</NavLink>

        <Switch>
          <Route exact path="/about" component={AboutHisotry}/>
          <Route path="/about/culture" component={AboutCulture}/>
          <Route path="/about/contact" component={AboutContact}/>
        </Switch>
      </div>
    )
  }
}
```

:ghost: 这里提供的下一级的路由要用 <span style="color: #a50">Switch</span> 包裹，以渲染到内部。



### 代码跳转

#### 路由组件

```react
export default class About extends PureComponent {
  render() {
    return (
      <div>
        <NavLink exact to="/about">企业历史</NavLink>
        <NavLink exact to="/about/culture">企业文化</NavLink>
        <button onClick={e => this.jumpToJoin()}>加入我们</button>

        <Switch>
          <Route exact path="/about" component={AboutHisotry}/>
          <Route path="/about/culture" component={AboutCulture}/>
          <Route path="/about/join" component={AboutJoin}/>
        </Switch>
      </div>
    )
  }
  jumpToJoin() {
    this.props.history.push("/about/join");
  }
}
```

:turtle: 路由组件（通过 Route 组件匹配后渲染的组件）默认会被添加一些属性，可以通过 this.props 获取。



#### 非路由组件

```react
ReactDOM.render(
  <BrowserRouter>
    <App/>
  </BrowserRouter>,
  document.getElementById('root')
);
```

```react
import React, { PureComponent } from 'react';

import {
  BrowserRouter
  Link,
  Route,
  Switch
} from 'react-router-dom';

// 省略组件导入

class App extends PureComponent {
  render() {
    return (
      <div>
        <NavLink exact to="/" activeClassName="link-active">首页</NavLink>
        <NavLink to="/about" activeClassName="link-active">关于</NavLink>
        <button onClick={e => this.jumpToProduct()}>商品</button>
          
        <Switch>
          <Route exact path="/" component={Home} />
          <Route path="/about" component={About} />
          <Route path="/product" component={Product} />
        </Switch>
      </div>
    )
  }
    
  jumpToProduct() {
    this.props.history.push("/product");
  }  
}

export default withRouter(App);
```

:ghost: 通过使用高阶组件 <span style="color: #a50">withRouter</span>，普通的组件也能够接收到 history 等路由相关的属性；

:turtle: 这里要求将 <span style="color: #a50">BrowserRouter</span> 至少包裹到 App 组件的外面。



### 动态路由

<span style="backGround: #efe0b9">父组件</span>

```react
class App extends PureComponent {
  render() {
    const id = "123";
    return (
      <div>
        <NavLink to={`/detail/${id}`} activeClassName="link-active">详情</NavLink>
          
        <Switch>
          <Route path="/detail/:id" component={Detail} />
        </Switch>
      </div>
    )
  }
}
```

<span style="backGround: #efe0b9">子组件</span>

```react
export default class Detail extends PureComponent {
  render() {
    const match = this.props.match;

    return (
      <div>
        <h2>Detail: {match.params.id}</h2>
      </div>
    )
  }
}
```

动态路由指路由的路径不是固定的；可以用来传递参数。





### 传参-search

不建议使用这种方式传参，建议用 state 方式。

父组件

```react
<NavLink to={`/detail2?name=why&age=18`}>详情2</NavLink>

<Route path="/detail2" component={Detail2} />
```

子组件

```react
export default class Detail2 extends PureComponent {
  render() {
    return (
      <div>
        <h2>Detail2: {this.props.location.search}</h2>
      </div>
    )
  }
}
// 渲染结果为 ?name=why&age=18
```



### 传参-state

<span style="backGround: #efe0b9">父组件</span>

```react
// 事先声明
const info = {name: "why", age: 18, height: 1.88};
<NavLink to={{
          pathname: "/detail3",
          search: "name=abc",
          state: info
          }}>
  详情3
</NavLink>

<Route path="/detail3" component={Detail3} />
```

<span style="backGround: #efe0b9">子组件</span>

```react
import React, { PureComponent } from 'react'

export default class Detail3 extends PureComponent {
  render() {
    const location = this.props.location;
    return (
      <div>
        <h2>Detail3: {location.state.name}</h2>
      </div>
    )
  }
}
// 渲染结果为 why
```



### 路由映射配置

需要借助插件实现

```elm
yarn add react-router-config
```

```elm
- src
  + router
    - index.js
```

:hammer_and_wrench: 创建一个专门的文件，用于集中管理路由映射关系。

<span style="backGround: #efe0b9">src\router\index.js</span>

```react
import Home from '../pages/home';
// 引入其它子组件

const routes = [
  {
    path: "/",
    exact: true,
    component: Home
  },
  {
    path: "/about",
    component: About,
    routes: [
      {
        path: "/about",
        exact: true,
        component: AboutHisotry
      },
      {
        path: "/about/culture",
        component: AboutCulture
      }
    ]
  },
  {
    path: "/profile",
    component: Profile
  },
  {
    path: "/user",
    component: User
  }
]

export default routes;
```

:turtle: 在每个级别的路由外都会自动加上 <span style="color: #a50">Switch</span>；

:turtle: 默认情况下，路由项使用的是模糊匹配。

<span style="backGround: #efe0b9">包含顶层路由的组件</span>

```react
import React, { PureComponent } from 'react';
// 1. 引入方法
import { renderRoutes } from 'react-router-config';

import routes from './router';

import {
  NavLink,
  withRouter
} from 'react-router-dom';

class App extends PureComponent {
  render() {
    return (
      <div>
        <NavLink exact to="/" activeClassName="link-active">首页</NavLink>
        <NavLink to="/about" activeClassName="link-active">关于</NavLink>
		
        {/* 将原本（switch包裹的）Route组件替换如下 */}
        {renderRoutes(routes)}
      </div>
    )
  }
}

export default withRouter(App);
```

<span style="backGround: #efe0b9">非顶层路由组件</span>

```react
import React, { PureComponent } from 'react'
import { NavLink } from 'react-router-dom';
// 1. 引入方法
import { renderRoutes } from 'react-router-config'

export default class About extends PureComponent {
  render() {
    return (
      <div>
        <NavLink exact to="/about">企业历史</NavLink>
        <NavLink exact to="/about/culture">企业文化</NavLink>

        {/* 将原本（switch包裹的）Route组件替换如下 */}    
        {renderRoutes(this.props.route.routes)}
      </div>
    )
  }
}
```

:ghost: 使用相应的方法管理路由映射后，路由组件上会被添加额外属性 route，可用于<span style="color: #a50">嵌套路由的占位</span>。



### 路由懒加载

**路由映射**

```react
import React from 'react';

// import Home from '@/pages/home';
const Home = React.lazy(() => import("@/pages/home"));

const routes = [
  // ...
]

export default routes;
```

**根组件处理**

```react
import React, { Suspense } from 'react';
import { renderRoutes } from 'react-router-config';

export default memo(function App() {
  return (
    <Suspense fallback={<div>page loading</div>}>
      {renderRoutes(routes)}
    </Suspense>
  )
})
```

:octopus: 使用懒加载时，要求根路由的外层必须用 <span style="color: #ff0000">Suspense</span> 组件包裹，用于提供应急组件，在组件未加载前展示；

:ghost: 该组件通过 <span style="color: #a50">fallback</span> 属性接收一个组件。



### 路由重定向

```react
import { Redirect } from "react-router-dom";

// ...
import Home from '@/pages/home';

const routes = [
  {
    path: "/",
    exact: true,
    render: () => (
      <Redirect to="/discover"/>
    )
  },
  {
    path: "/discover",
    component: HYDiscover,
    routes: [
      {
        path: "/discover",
        exact: true,
        render: () => (
          <Redirect to="/discover/recommend"/>
        )
      },
      {
        path: "/discover/recommend",
        component: HYRecommend
      }
    ]
  }
]
```

这个例子中，对于 `/`，会直接处理为 `/discover/recommend`。

