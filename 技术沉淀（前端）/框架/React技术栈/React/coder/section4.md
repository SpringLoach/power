

| --       | --                                                      |
| -------- | ------------------------------------------------------- |
| 默认样式 | 引入 antd，默认会引入一些全局样式，如 body 的 margin    |
| 优化体积 | antd 默认支持基于 ES modules 的 tree shaking            |
| 优化体积 | 像 `import { Button } from 'antd'` 就会有按需加载的效果 |
| 修改配置 | 想要修改create-react-app 的默认配置，craco是推荐的方案  |



## ant-design

### 引入依赖及样式

```elm
yarn add antd
```

图标库需要单独引入

```elm
yarn add @ant-design/icons
```

样式也需要自行引入

<span style="backGround: #efe0b9">src\index.js</span>

```javascript
import "antd/dist/antd.css"
```

使用[示例](https://ant.design/components/overview-cn/)

```react
import React, { PureComponent } from 'react';
import { Button } from 'antd';
import { PoweroffOutlined } from '@ant-design/icons';

export default class App extends PureComponent {
  render() {
    const loadings = true;

    return (
      <>
        <Button type="primary" size="small" loading>
          Loading
        </Button>
        <Button type="primary" icon={<PoweroffOutlined />} loading />
          Click me!
        </Button>
      </>
    )
  }
}
```



### 配置脚手架

```elm
yarn add @craco/craco
```

<span style="backGround: #efe0b9">package.json</span>

```elm
"script": {
  "start": "craco start",
  "build": "craco build",
  "test": "craco test",
}
```

:ghost: 这样执行的脚本，将会读取根目录下的 craco.config.js，用于合并配置

<span style="backGround: #efe0b9">craco.config.js</span>

```
module.exports = {

}
```



### 配置主题

要想修改 ant-design 默认的主题色，需要修改[配置](https://ant.design/docs/react/use-with-create-react-app-cn#%E8%87%AA%E5%AE%9A%E4%B9%89%E4%B8%BB%E9%A2%98)

```elm
yarn add craco-less
```

<span style="backGround: #efe0b9">craco.config.js</span>

```javascript
const CracoLessPlugin = require('craco-less');

module.exports = {
  plugins: [
    {
      plugin: CracoLessPlugin,
      options: {
        lessLoaderOptions: {
          lessOptions: {
            modifyVars: { '@primary-color': '#1DA57A' },
            javascriptEnabled: true,
          },
        },
      },
    }
  ]
}
```

还需要修改引入的组件库样式文件

<span style="backGround: #efe0b9">src\index.js</span>

```javascript
// import 'antd/dist/antd.css';
import 'antd/dist/antd.less';
```



### 配置别名

```javascript
const path = require("path");
const resolve = dir => path.resolve(__dirname, dir);

module.exports = {
  webpack: {
    alias: {
      "@": resolve("src"),
      "components": resolve("src/components")
    }
  }
}
```

**使用实例**

```javascript
import HYTitle from "components/title/title.js";
```



### 组件使用-两种方式

```react
import { Input } from "antd";
const { TextArea } = Input;


// 组件部分
render () {
  <div>
    {/* 方式一 */}
    <Input.TextArea />
    {/* 方式二 */}
    <TextArea />
  </div>  
}
```





### 案例-评论列表

见十二集

<img src="C:\Users\86186\AppData\Roaming\Typora\typora-user-images\image-20220717144057512.png" alt="image-20220717144057512" style="zoom:60%;" />

**moment 库使用中文格式**

<span style="backGround: #efe0b9">src\index.js</span>

```javascript
import 'moment/locale/zh-hk';
```



## axios

```elm
yarn add axios
```

### 基本使用

```javascript
import axios from 'axios';

// 组件部分
componentDidMount() {
  axios({
   url: "https://httpbin.org/get",
   params: { name: "why" }
  }).then(res => {
    console.log(res);
 }).catch(err => {
    console.error(err);
  });
}
```

可以在[辅助网站](http://httpbin.org/)中测试请求。



### async await

```javascript
import axios from 'axios';

// 组件部分
async componentDidMount() {
  try {
    const result = await axios.get("https://httpbin.org/get", {
      params: {
        name: "lilei",
        age: 30
      }
    });
    console.log(result);
  } catch(err) {
    console.log(err);
  }
}
```

:turtle: 使用异步函数时，需要通过 try catch 的组合捕获错误。



### 封装使用

<span style="backGround: #efe0b9">src\service\request.js</span>

```javascript
import axios from 'axios';
const BASE_URL = 'https://production.org';

const instance = axios.create({
  baseURL: BASE_URL,
  timeout: 5000
});

instance.interceptors.request.use(func, func);

instance.interceptors.response.use(func, func);

export default instance;
```

:european_castle: 配置优先级：创建实例的配置 > 实例配置 > 默认配置



## 过渡动画

好处：不需要自己动手去维护类名的添加、删除（考虑时机）

```elm
yarn add react-transition-group
```

| 组件             | 说明                                 |
| ---------------- | ------------------------------------ |
| Transition       | 没有结合css                          |
| CSSTransition    | 常用，能够结合css                    |
| SwitchTransition | 两个组件显示和隐藏切换时，使用该组件 |
| TransitionGroup  | 将多个动画组件包裹在其中（列表）     |



### CSSTransition-基本使用

| 其它属性      | 说明                     | 默认值 |
| ------------- | ------------------------ | ------ |
| unmountOnExit | 退出动画结束后卸载组件   | true   |
| appear        | 挂载时触发动画           | false  |
| onEnter等钩子 | 特点时机触发，参数为 dom |        |

```react
import React, { PureComponent } from 'react';

// 1.引入组件
import { CSSTransition } from 'react-transition-group';
import './CSSTransition.css';

export default class CSSTransitionDemo extends PureComponent {
  constructor(props) {
    super(props);
    this.state = { isShow: true }
  }

  render() {
    const {isShow} = this.state; 

    return (
      <div>
        <button onClick={e => {this.setState({isShow: !isShow})}}>显示/隐藏</button>
        {/* 2.包裹需要切换类的部分，并设置需要的属性 */}
        <CSSTransition in={isShow}
                       classNames="card"
                       timeout={5000}
                       >
          <h2>内容</h2>
        </CSSTransition>
      </div>
    )
  }
}
```

<span style="color: #f7534f;font-weight:600">in</span> 触发进入或者退出状态，会切换相关的类；

<span style="color: #f7534f;font-weight:600">classNames</span> 会为动画相关的类，添加前缀；

<span style="color: #f7534f;font-weight:600">timeout</span> 控制类切换的时间

<span style="backGround: #efe0b9">CSSTransition.css</span>

```less
// 进入状态开始时添加，结束时移除
.card-enter, .card-appear {
  opacity: 0;
  transform: scale(.6);
}

.card-enter-active, .card-appear-active {
  opacity: 1;
  transform: scale(1);
  transition: opacity 300ms, transform 300ms;
}

// 进入状态结束触发
.card-enter-done, .card-appear-done {

}

// 退出状态开始时添加，结束时移除
.card-exit {
  opacity: 1;
  transform: scale(1);
}

.card-exit-active {
  opacity: 0;
  transform: scale(.6);
  transition: opacity 300ms, transform 300ms;
}

// 退出状态结束时添加
.card-exit-done {
  opacity: 0;
}
```

:whale: 这里的 appear 为<span style="color: #ff0000">挂载</span>时添加的状态，不需要挂载就添加动画时，不需要设置。



### CSSTransition-动画钩子

```react
<CSSTransition in={isShow}
                classNames="card"
                timeout={5000}
                unmountOnExit={true}
                appear
                onEnter={el => console.log("开始进入")}
                onEntering={el => console.log("正在进入")}
                onEntered={el => console.log("进入完成")}
                onExit={el => console.log("开始退出")}
                onExiting={el => console.log("退出状态")}
                onExited={el => console.log("退出完成")}
                >
  <h2>内容</h2>
</CSSTransition>
```



### SwitchTransition-基本使用

| 核心属性 | 说明                          | 默认值 |
| -------- | ----------------------------- | ------ |
| mode     | 表示新旧组件，移除/新建的顺序 | out-in |

```react
import React, { PureComponent } from 'react';

import "./SwitchTransition.css";
import { SwitchTransition, CSSTransition } from 'react-transition-group';

export default class SwitchTransitionDemo extends PureComponent {
  constructor(props) {
    super(props);
    this.state = { isOn: true }
  }

  render() {
    const {isOn} = this.state;

    return (
      <div>
        <SwitchTransition mode="out-in">
          <CSSTransition key={isOn ? "on": "off"}
                         classNames="btn"
                         timeout={1000}>
            <button onClick={e => this.setState({isOn: !isOn})}>
              {isOn ? "on": "off"}
            </button>
          </CSSTransition>
        </SwitchTransition>
      </div>
    )
  }
}

```

:ghost: SwitchTransition 需要包裹 CSSTransition 或 Transition 进行使用；

:ghost: 被包裹的组件不再使用 <span style="color: #a50">in</span> 来判断状态，而是通过 <span style="color: #ff0000">key</span> 来判断。

<span style="backGround: #efe0b9">SwitchTransition.css</span>

```less
.btn-enter {
  opacity: 0;
  transform: translateX(100%);
}

.btn-enter-active {
  opacity: 1;
  transform: translateX(0);
  transition: opacity 1000ms, transform 1000ms;
}

.btn-exit {
  opacity: 1;
  transform: translateX(0);
}

.btn-exit-active {
  opacity: 0;
  transform: translateX(-100%);
  transition: opacity 1000ms, transform 1000ms;
}
```



### TransitionGroup-基本使用

```react
import React, { PureComponent } from 'react';
import { CSSTransition, TransitionGroup } from 'react-transition-group';

import './TransitionGroup.css';

export default class TransitionGroupDemo extends PureComponent {

  constructor(props) {
    super(props);

    this.state = {
      names: ["coderwhy", "kobe", "lilei"]
    }
  }

  render() {
    return (
      <div>
        <TransitionGroup>
          {
            this.state.names.map((item, index) => {
              return (
                <CSSTransition key={item}
                  timeout={500}
                  classNames="item">
                  <div> {item} </div>
                </CSSTransition>
              )
            })
          }
        </TransitionGroup>
        <button onClick={e => this.addName()}>+name</button>
      </div>
    )
  }

  addName() {
    this.setState({
      names: [...this.state.names, "coderwhy"]
    })
  }
}
```

:ghost: 需要动画效果添加到列表中时，使用 <span style="color: #a50">TransitionGroup</span>  将 CSSTransition 包裹起来。

:octopus: 忽略添加 key，可能导致动画相关的类添加到不符预期的元素上。

<span style="backGround: #efe0b9">TransitionGroup.css</span>

```less
.item-enter {
  opacity: 0;
  transform: scale(.6);
}

.item-enter-active {
  opacity: 1;
  transform: scale(1);
  transition: opacity 300ms, transform 300ms;
}

.item-enter-done {
  color: red;
}

.item-exit {
  opacity: 1;
  transform: scale(1);
}

.item-exit-active {
  opacity: 0;
  transform: scale(.6);
  transition: opacity 300ms, transform 300ms;
}

.item-exit-done {
  opacity: 0;
}
```



## Redux

用于进行状态管理的库，本身可以不在 React 中运行。

状态是只读的，只能通过执行 action 修改状态。

单一数据源，便于管理





### 使用流程

```elm
yarn init -y
```

```elm
yarn add redux
```

可以直接在 node 环境下运行测试。

```javascript
// 1.引入库
const redux = require('redux');

// 2.定义初始状态
const initialState = {
  counter: 0
}

// 4.根据初始状态和action，定义reducer
function reducer(state = initialState, action) {
  switch (action.type) {
    case "INCREMENT":
      return { ...state, counter: state.counter + 1 }
    case "DECREMENT":
      return { ...state, counter: state.counter - 1 }
    case "ADD_NUMBER":
      return { ...state, counter: state.counter + action.num }
    case "SUB_NUMBER":
      return { ...state, counter: state.counter - action.num }
    default:
      return state;
  }
}

// 5.创建store对象(接收reducer)
const store = redux.createStore(reducer)

// 5.1订阅store的修改(可选)
store.subscribe(() => {
  console.log("counter:", store.getState().counter);
})

// 3.定义action
const action1 = { type: "INCREMENT" };
const action2 = { type: "DECREMENT" };

const action3 = { type: "ADD_NUMBER", num: 5 };
const action4 = { type: "SUB_NUMBER", num: 12 };

// 5.派发action
store.dispatch(action1);
store.dispatch(action2);
store.dispatch(action2);
store.dispatch(action3);
store.dispatch(action4);
```

:ghost: reducer 首参为状态，第二个参数为 action；要提供默认的 state 作初始化使用；

:ghost: reducer 本质上是根据传入的不同键，来执行对应的函数；

:ghost: 派发 action，实际上就是调用 reducer 方法；

:ghost: reducer 的执行要像纯函数一样，不会改变输入值。

:ghost: store.subscribe 接收函数，会在状态变化时进行回调。



### 结构划分

```elm
- store
  + actionCreators.js	 // 定义 action，通过函数返回
  + constants.js		 // 定义 action 的类型常量
  + reducer.js			 // 定义初始状态和 reducer
  + index.js			 // 导出 store 实例
- index.js               // 使用（该文件不固定）
```

<span style="backGround: #efe0b9">store\actionCreators.js</span>

```javascript
import {
  ADD_NUMBER,
  INCREMENT
} from './constants.js';

export const addAction = num => ({
  type: ADD_NUMBER,
  num
});

export const incAction = () => ({
  type: INCREMENT
});
```

:turtle: 箭头函数：直接返回对象时，使用小括号包裹，可以省略 return

<span style="backGround: #efe0b9">store\constants.js</span>

```javascript
export const ADD_NUMBER = "ADD_NUMBER";
export const INCREMENT = "INCREMENT";
```

<span style="backGround: #efe0b9">store\reducer.js</span>

```javascript
import {
  ADD_NUMBER,
  INCREMENT
} from './constants.js';

const defaultState = {
  counter: 0
}

function reducer(state = defaultState, action) {
  switch (action.type) {
    case ADD_NUMBER:
      return { ...state, counter: state.counter + action.num };
    case INCREMENT:
      return { ...state, counter: state.counter + 1 };
    default:
      return state;
  }
}

export default reducer;
```

<span style="backGround: #efe0b9">store\index.js</span>

```javascript
import redux from 'redux';

import reducer from './reducer.js';

const store = redux.createStore(reducer);

export default store;
```

:whale: 这里 redux 的导入方式做了特殊处理，与在 react 中导入的方式不同。

**使用**

<span style="backGround: #efe0b9">index.js</span>

```javascript
import store from './store/index.js';

import {
  addAction,
  subAction,
  incAction,
  decAction
} from './store/actionCreators.js';

store.subscribe(() => {
  console.log(store.getState());
})

store.dispatch(addAction(10));
store.dispatch(addAction(15));
store.dispatch(incAction());
```



### 融入react

| --       | --                                                      |
| -------- | ------------------------------------------------------- |
| 定义     | 参照上节，即结构划分                                    |
| 差异     | react 中引入 redux 的方式有所不同                       |
| 组件使用 | 初始化 react 的 state                                   |
| 组件使用 | 挂载后，订阅状态；状态变化时，通过 setState 触发 render |
| 组件使用 | 卸载前，取消订阅                                        |
| 组件使用 | 在某些时机（如点击按钮）的事件处理函数中，派发 action   |

**使用**

```react
import React, { PureComponent } from 'react';

import store from '../store';

import {
  addAction
} from '../store/actionCreators'

export default class Home extends PureComponent {
  constructor(props) {
    super(props);

    this.state = {
      // 初始化react的state
      counter: store.getState().counter
    }
  }

  componentDidMount() {
    this.unsubscribue = store.subscribe(() => {
      this.setState({
        counter: store.getState().counter
      })
    })
  }

  componentWillUnmount() {
    this.unsubscribue();
  }

  render() {
    return (
      <div>
        <h1>Home</h1>
        <h2>当前计数: {this.state.counter}</h2>
        <button onClick={e => this.addNumber(5)}>+5</button>
      </div>
    )
  }

  addNumber(num) {
    store.dispatch(addAction(num));
  }
}
```

:turtle: 调用订阅状态方法本身的返回值，即可以取消订阅。



### 封装逻辑

<span style="backGround: #efe0b9">src\utils\connect.js</span>

```react
import React, { PureComponent } from "react";

// 获取封装好的实例
import store from '../store';

export function connect(mapStateToProps, mapDispachToProp) {
  return function enhanceHOC(WrappedComponent) {
    return class extends PureComponent {
      constructor(props) {
        super(props);

        this.state = {
          storeState: mapStateToProps(store.getState())
        }
      }

      componentDidMount() {
        this.unsubscribe = store.subscribe(() => {
          this.setState({
            storeState: mapStateToProps(store.getState())
          })
        })
      }

      componentWillUnmount() {
        this.unsubscribe();
      }

      render() {
        return <WrappedComponent {...this.props}
          {...mapStateToProps(store.getState())}
          {...mapDispachToProp(store.dispatch)} />
      }
    }
  }
}
```

:hammer_and_wrench: 将公共部分进行抽离，而不同的部分，通过参数形式传入函数，加以处理；

:european_castle: 调用 connect 方法，返回一个高阶组件；

:european_castle: 而高阶组件是参数为组件，返回值为新组件的函数（通过加一个中间组件增强？）

<span style="backGround: #efe0b9">使用</span>

```react
import React, { PureComponent } from 'react';

import {connect} from '../utils/connect';
import {
  incAction,
  addAction
} from '../store/actionCreators'

class Home extends PureComponent {
  render() {
    return (
      <div>
        <h1>Home</h1>
        <h2>当前计数: {this.props.counter}</h2>
        <button onClick={e => this.props.increment()}>+1</button>
        <button onClick={e => this.props.addNumber(5)}>+5</button>
      </div>
    )
  }
}

const mapStateToProps = state => ({
  counter: state.counter
})

const mapDispatchToProps = dispatch => ({
  increment() {
    dispatch(incAction());
  },
  addNumber(num) {
    dispatch(addAction(num));
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(Home);
```

:whale: 封装后，可以将 Redux 管理的状态和方法通过 props 的方式传递到业务组件中；

:whale: 届时业务组件甚至不需要维护自己的 state，故可以写成更简洁的函数式组件；

:whale: 每个实例的 state / dispatch 是不一样的；

:whale: 为了不往业务组件中引入 store，将传值写成了函数形式，然后再返回对象，可以通过参数传递获取到 store 上需要的的属性。



### 加强封装

让 connect 方法所在的文件，不直接依赖业务内容（store）

<span style="backGround: #efe0b9">src\index.js</span>

```react
import React from 'react';
import ReactDOM from 'react-dom';

import store from './store';

import { StoreContext } from './utils/context';

import App from './App';

ReactDOM.render(
  <StoreContext.Provider value={store}>
    <App />
  </StoreContext.Provider>,
  document.getElementById('root')
);
```

<span style="backGround: #efe0b9">src\utils\context.js</span>

```react
import React from 'react';

const StoreContext = React.createContext(); 

export {
  StoreContext
}
```

<span style="backGround: #efe0b9">src\utils\connect.js</span>

```react
import React, { PureComponent } from "react";

import { StoreContext } from './context';

export function connect(mapStateToProps, mapDispachToProp) {
  return function enhanceHOC(WrappedComponent) {
    class EnhanceComponent extends PureComponent {
      constructor(props, context) {
        super(props, context);

        this.state = {
          storeState: mapStateToProps(context.getState())
        }
      }

      componentDidMount() {
        this.unsubscribe = this.context.subscribe(() => {
          this.setState({
            storeState: mapStateToProps(this.context.getState())
          })
        })
      }

      componentWillUnmount() {
        this.unsubscribe();
      }

      render() {
        return <WrappedComponent {...this.props}
          {...mapStateToProps(this.context.getState())}
          {...mapDispachToProp(this.context.dispatch)} />
      }
    }

    /* 新增：将 context 传递给组件 */
    EnhanceComponent.contextType = StoreContext;

    return EnhanceComponent;
  }
}
```

:octopus: 不能在 constuctor 中通过 this.context 直接获取到对象。

:ghost: 但在使用 context 时，组件可以从 constuctor 中取出第二个参数来获得它。



### 使用 react-redux

:star2: connect 和 context，在 react-redux 内部已经帮我们实现好了。

```elm
yarn add react-redux
```

<span style="backGround: #efe0b9">src\index.js</span>

```react
import React from 'react';
import ReactDOM from 'react-dom';

import store from './store';

import { Provider } from 'react-redux';

import App from './App';

ReactDOM.render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('root')
);
```

:whale: 这里传递的属性由 value 改成了 store，其实内部接收的还是 value

<span style="backGround: #efe0b9">使用</span>

```react
// import { connect } from '../utils/connect';
import { connect } from 'react-redux';
```



### 接收异步状态

流程：定义常量、定义 action、添加 reduce 内部处理、组件传递action、在合适时机调用 dispatch

<span style="backGround: #efe0b9">src\store\constants.js</span>

```
export const CHANGE_BANNERS = "CHANGE_BANNERS";
```

<span style="backGround: #efe0b9">src\store\actionCreators.js</span>

```react
import {
  CHANGE_BANNERS
} from './constants.js';

export const changeBannersAction = (banners) => ({
  type: CHANGE_BANNERS,
  banners
});
```

<span style="backGround: #efe0b9">src\store\reducer.js</span>

```react
import {
  CHANGE_BANNERS
} from './constants.js';

const defaultState = {
  banners: [],
}

function reducer(state = defaultState, action) {
  switch (action.type) {
    case ADD_NUMBER:
      return { ...state, counter: state.counter + action.num };
    case CHANGE_BANNERS:
      return { ...state, banners: action.banners };
    default:
      return state;
  }
}

export default reducer;
```



```react
import React, { PureComponent } from 'react';

import { connect } from 'react-redux';

import axios from 'axios';

import {
  changeBannersAction
} from '../store/actionCreators'

class Home extends PureComponent {
  componentDidMount() {
    axios({
      url: "http://123.207.32.32:8000/home/multidata",
    }).then(res => {
      const data = res.data.data;
      this.props.changeBanners(data.banner.list);
    })
  }

  render() {
    return (
      <div>
        <h1>{props.recommends}</h1>
      </div>
    )
  }
}

const mapStateToProps = state => {
  banners: state.banners
};

const mapDispatchToProps = dispatch => ({
  changeBanners(banners) {
    dispatch(changeBannersAction(banners));
  }
})
```



### 异步action

> 对于网络请求状态获取状态这部分逻辑，更适合放在 action 而不是业务逻辑当中实现。
>
> 要想要支持异步的 action，需要借助三方库；

```elm
yarn add redux-thunk
```

:ghost: dispatch 只允许接收对象，但应用该中间件后，被赋予了接收函数的能力。

<span style="backGround: #efe0b9">src\store\index.js</span>

```react
import { createStore, applyMiddleware, compose } from 'redux';
import thunkMiddleware from 'redux-thunk';

import reducer from './reducer.js';

// 应用一些中间件
const storeEnhancer = applyMiddleware(thunkMiddleware);

const store = createStore(reducer, storeEnhancer);

export default store;
```

<span style="backGround: #efe0b9">src\store\actionCreators.js</span>

```react
import axios from 'axios';

import {
  CHANGE_BANNERS,
  FETCH_HOME_MULTIDATA
} from './constants.js';


export const changeBannersAction = (banners) => ({
  type: CHANGE_BANNERS,
  banners
});

// redux-thunk中定义的action函数
export const getHomeMultidataAction = (dispatch, getState) => {
  axios({
    url: "http://123.207.32.32:8000/home/multidata",
  }).then(res => {
    const data = res.data.data;
    dispatch(changeBannersAction(data.banner.list));
  })
}
```

:ghost: 此时 dispatch 允许接收 <span style="color: #ff0000">func</span> 形式的 action，可以在异步获取到数据后执行相应的 action。

```react
import React, { PureComponent } from 'react';

import { connect } from 'react-redux';

import {
  getHomeMultidataAction
} from '../store/actionCreators'

class Home extends PureComponent {
  /* 直接调用下发的action */
  componentDidMount() {
    this.props.getHomeMultidata();
  }

  render() {
    return (
      <div>
        <h1>{props.recommends}</h1>
        </div>
    )
  }
}

// ...

const mapDispatchToProps = dispatch => ({
  getHomeMultidata() {
    dispatch(getHomeMultidataAction);
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(Home);
```



### 浏览器追踪

可以安装浏览器插件 <span style="color: #a50">Redux DevTools</span>，在 Redux 一栏，追踪状态的变化；需要在代码额外配置。

<span style="backGround: #efe0b9">src\store\index.js</span>

```react
import { createStore, applyMiddleware, compose } from 'redux';
import thunkMiddleware from 'redux-thunk';

import reducer from './reducer.js';

// composeEnhancers函数
const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__({trace: true}) || compose;

// 应用一些中间件
const sagaMiddleware = createSagaMiddleware();

const storeEnhancer = applyMiddleware(thunkMiddleware);
const store = createStore(reducer, composeEnhancers(storeEnhancer));

export default store;
```



### 异步action-分离

> 比起 redux-thunk，这个库能够将异步代码更好的分离；与生成器函数密切相关。

```elm
yarn add redux-saga
```

<span style="backGround: #efe0b9">src\store\index.js</span>

```react
import { createStore, applyMiddleware, compose } from 'redux';
import thunkMiddleware from 'redux-thunk';
import createSagaMiddleware from 'redux-saga';

import saga from './saga';
import reducer from './reducer.js';

const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__({trace: true}) || compose;

// 应用一些中间件
// 创建sagaMiddleware中间件
const sagaMiddleware = createSagaMiddleware();

// 传入中间件
const storeEnhancer = applyMiddleware(thunkMiddleware, sagaMiddleware);
const store = createStore(reducer, composeEnhancers(storeEnhancer));

// 调用执行，需要传入生成器
sagaMiddleware.run(saga);

export default store;
```

:whale: 该库需要引入、创建中间件、添加中间件、最后调用执行，才生效。

<span style="backGround: #efe0b9">saga.js</span>

```javascript
import { takeEvery, put, all, takeLatest } from 'redux-saga/effects';
import axios from 'axios';
import {
  FETCH_HOME_MULTIDATA
} from './constants';
import {
  changeBannersAction,
  changeRecommendAction
} from './actionCreators';

function* fetchHomeMultidata(action) {
  // 内部做了特殊处理，故可以取到数据
  const res = yield axios.get("http://123.207.32.32:8000/home/multidata");
  const banners = res.data.data.banner.list;
  const recommends = res.data.data.recommend.list;
  // 获取到数据后，执行 action 存入数据；都要执行，故使用了 all
  yield all([
    yield put(changeBannersAction(banners)),
    yield put(changeRecommendAction(recommends))
  ])
}

function* mySaga() {
  // takeLatest: 短时间内（在生成器执行完毕前）多次触发action，最终只触发一次生成器
  // takeEvery: 短时间内多次触发action，那么多次触发生成器
  // 可以使用 all 监听多个 action
  yield all([
    // 接收action和生成器函数
    takeEvery(FETCH_HOME_MULTIDATA, fetchHomeMultidata),
    // ...
  ]);
}

export default mySaga;
```

:ghost: 一旦箭头到需要拦截的 action，就会执行后面的操作（生成器函数）；

:ghost: 这里之所以能获取到 yield 后面的期约结果，是因为内部将结果传递给了 <span style="color: #a50">next()</span>；

:ghost: put 方法可以直接传入 action，内部会进行 <span style="color: #a50">dispatch</span> 处理。

<span style="backGround: #efe0b9">src\store\constants.js</span>

```react
export const ADD_NUMBER = "ADD_NUMBER";

export const FETCH_HOME_MULTIDATA = "FETCH_HOME_MULTIDATA";
```

<span style="backGround: #efe0b9">src\store\actionCreators.js</span>

```javascript
import {
  FETCH_HOME_MULTIDATA
} from './constants.js';

// redux-saga拦截的action
export const fetchHomeMultidataAction = {
  type: FETCH_HOME_MULTIDATA
}
```

**使用**

```react
// 组件内部
componentDidMount() {
  this.props.getHomeMultidata();
}
// 传递给 connect 的 action
const mapDispatchToProps = dispatch => ({
  getHomeMultidata() {
    dispatch(fetchHomeMultidataAction);
  }
})
```



### 中间件原理

需求：日志打印，即在每次执行 dispatch 前，能够打印 action；执行 dispatch 后，能够打印 state。

| --             | --                                                         |
| -------------- | ---------------------------------------------------------- |
| 直接实现       | 在每次 dispatch 前后添加代码                               |
| 直接实现       | 可以，但是不方便；而且用户可能在任何地方调用 dispatch      |
| 初步封装       | 可以将这三步封装到函数A中，调用函数A即能完成需求           |
| 初步封装       | 但这相对于让用户抛弃原本的 api，强制用函数A                |
| monkeyingpatch | 可以通过一个中间变量，给原本的 api 重新赋值为函数A         |
| monkeyingpatch | 将monkeyingpatch这一部分单独封装到函数里，用户调用即可生效 |

```react
function patchLogging(store) {
  const next = store.dispatch;
  function dispatchAndLogging(action) {
    console.log("dispatch前---dispatching action:", action);
    next(action);
    console.log("dispatch后---new state:", store.getState());
  }
  store.dispatch = dispatchAndLogging;
}
```



### reducer 与 reduce

```react
(previousState = defaultState, action) => nextState
```

:whale: 该方法与数组的 reduce 非常相似，提供默认的初始值，然后每次的结果作为下次的参数。



### reducer的封装

以模块为单位，将状态进行拆分；每个模块由一个对象维护相关的 state。

```less
- store
  + home              
  + counter              // 模块下的状态管理
    - actionCreators.js	 // action 定义
    - constants.js		 // 常量
    - reducer.js         // reducer，即实现对 action 的具体逻辑
    - index.js		     // 统一出口
```



### 合并reducer

事实上，redux 提供了 combineReducers 函数可以方便的让我们对多个 reducer 进行合并

<span style="backGround: #efe0b9">src\store\reducer.js</span>

```react
import { combineReducers } from 'redux';

import { reducer as counterReducer } from './counter';
import { reducer as homeReducer } from './home';

const reducer = combineReducers({
  counterInfo: counterReducer,
  homeInfo: homeReducer
});

export default reducer;
```



