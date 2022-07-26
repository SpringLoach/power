## 脚手架

<span style="color: #f7534f;font-weight:600">create-react-app</span>



### 安装脚手架

:whale: react 的脚手架依赖于 node 环境，且倾向于使用 yarn 进行包管理

1. 安装 yarn

```
npm install -g yarn
```

2. 安装脚手架

```
npm install -g create-react-app
```

3. 创建项目

```
create-react-app 项目名称
```

:whale: 项目名称只能是小写，可以用分隔符

4. 运行项目

```
yarn start
```



### yarn 命令对比

![image-20220714223349197](.\img\yarn对比)



### 目录结构分析

![image-20220714223817725](.\img\目录结构分析)



### 了解 PWA

- 该技术可以将网页应用添加至主屏幕，开启推送，使用离线功能等；

- React 脚手架创建的项目，自带 PWA 相关的文件，分别是 <span style="backGround: #efe0b9">serviceWorker.js</span> 和 <span style="backGround: #efe0b9">manifest.json</span>；

- 默认情况下，没有启用该功能。



### 显示 webpack 信息

React 基于 webpack 进行模块化和打包等操作，但默认情况下是将相关配置隐藏起来的。

```elm
yarn eject
```

:turtle: 通过该命令，可以显示配置相关信息，该过程是不可逆的；

:turtle: 此时会在项目下生成 <span style="backGround: #efe0b9">config</span> 和 <span style="backGround: #efe0b9">script</span> 文件夹，并且 <span style="backGround: #efe0b9">package.json</span> 中暴露更多原始信息。



## 重新开始

### 删除文件

1. 删除 src 下的所有文件

2. 将 public 中，除了 favicon.ico 和 index.html 之外的文件都删除掉

3. 与 PWA 相关的文件删掉是没有影响的，因为不需要使用到



### 开始编写

src/index.js

```react
import React from 'react';
import ReactDOM from 'react-dom';

ReactDOM.render(<h2>Hello React</h2>, document.getElementById("root"));
```

:whale: 模板中默认有提供 id 为 root 的元素；

:ghost: 模块化管理时，必须导入后才能使用相应变量；

:turtle: 这里需要导入 React，因为调用 React.createElement 处理 jsx。



### 初步封装

<span style="backGround: #efe0b9">src/index.js</span>

```react
import React from 'react';
import ReactDOM from "react-dom";

import App from './App';

ReactDOM.render(<App/>, document.getElementById("root"));
```

<span style="color: #f7534f;font-weight:600">ReactDOM.render</span> 也可以接收组件；将组件分离到别的文件，结构更清晰。

<span style="backGround: #efe0b9">src/App.js</span>

```react
import React from 'react';
const { Component } = React;

export default class App extends React.Component {
  constructor() {
    super();
  }

  render() {
    return (
      <div>Hello React</div>
    )
  }
}
```

:turtle: 这里需要导入 React，因为调用 React.createElement 处理 jsx。

**优化结构**

```react
import React, { Component } from 'react';

export default class App extends Component {
  constructor() {
    super();

    this.state = {
      counter: 0
    }
  }

  render() {
    return (
      <div>
        <h2>当前计数: {this.state.counter}</h2>
      </div>
    )
  }
}
```



## React 的组件化

| 分类方式         | 关注 UI 展示                                 | 关注数据逻辑                               |
| ---------------- | -------------------------------------------- | ------------------------------------------ |
| 定义方式         | <span style="color: #ff0000">函数组件</span> | <span style="color: #ff0000">类组件</span> |
| 需要维护内部状态 | 无状态组件                                   | 有状态组件                                 |
| 职责             | 展示型组件                                   | 容器型组件                                 |

:whale: 这些概念有很多重叠，它们最主要的是关注数据逻辑和UI展示的分离。



### 组件特点

| 类型            | 特点                                                   |
| --------------- | ------------------------------------------------------ |
| 类组件/函数组件 | 名称是大写字符开头                                     |
| 类组件          | 需要继承自 React.Component                             |
| 类组件          | 必须实现 render 方法；                                 |
| 类组件          | 可以实现 constructor，其中的 this.state 为组件内部状态 |
| 函数组件        | 没有生命周期函数（虽然也会被更新并挂载）               |
| 函数组件        | 没有this(组件实例），没有内部状态                      |

:turtle: 在 HTML 中，原生标签可以写成大写形式；但在 jsx 中不允许，这会被当作自定义组件。



### 函数式组件-示例

```react
import React from 'react';

export default function App() {
  return (
    <div>
      <span>你好</span>
      <h2>生活</h2>
    </div>
  )
}
```

除非使用 hook，一般认为函数式组件没有自己的状态。



### render 的返回值

| 允许的类型        | 说明                              |
| ----------------- | --------------------------------- |
| React 元素        | 原生元素/自定义组件               |
| 数组或 fragments  | 可以没有根元素                    |
| 字符串 / 数值类型 | 会被渲染为文本节点                |
| 布尔类型 / null   | 不进行渲染                        |
| Portals           | 可以渲染子节点到不同的 DOM 子树中 |



## 生命周期

### 常见钩子-时机

| 钩子                 | 回调时机          |
| -------------------- | ----------------- |
| constructor          |                   |
| render               |                   |
| componentDidMount    | 组件挂载到 DOM 上 |
| componentDidUpdate   | 组件发生更新      |
| componentWillUnmount | 组件卸载前        |

:ghost: 组件挂载时，会触发 <span style="color: #a50">componentDidMount</span>，而不触发 <span style="color: #a50">componentDidUpdate</span>。



### 常见钩子-作用

| 钩子                 | 作用                               |
| -------------------- | ---------------------------------- |
| constructor          | 初始化内部状态、为事件绑定实例     |
| componentDidMount    | DOM操作、网络请求、订阅            |
| componentDidUpdate   | DOM操作、网络请求                  |
| componentWillUnmount | 清除定时器、取消网络请求、取消订阅 |

:ghost: 如果不初始化 state 或不进行方法绑定，则不需要为 React 组件实现构造函数。



### 常见钩子-例子

```react
export default class App extends Component {
  constructor() {
    super();
    this.state = { counter: 0 }

    console.log("constructor");
  }

  render() {
    console.log("render");

    return (
      <div>
        <h2>当前计数: {this.state.counter}</h2>
        <button onClick={e => this.increment()}>+1</button>
      </div>
    )
  }

  increment() {
    this.setState({
      counter: this.state.counter + 1
    })
  }

  componentDidMount() {
    console.log("componentDidMount");
  }

  componentDidUpdate(prevProps, prevState, snapshot) {
    console.log("componentDidUpdate");
  }
}

// 首次渲染：constructor -> render -> componentDidMount

// 点击按钮：render -> componentDidMount
```

:whale: 动态渲染组件时， 能够触发 componentWillUnmount 钩子；



### 其它钩子-作用

| 钩子                     | 作用/使用场景                                          |
| ------------------------ | ------------------------------------------------------ |
| getDerivedStateFromProps | props 更新时，需要 state 也发生相应变化                |
| shouldComponentUpdate    | 根据返回值，决定是否需要重新执行 render 函数           |
| getSnapshotBeforeUpdate  | 可以获取DOM更新前的一些信息，传递给 componentDidUpdate |

![image-20220715235447360](.\img\其它钩子)

 

## 组件通信

### 父传子-类组件

```react
import React, { Component } from 'react';

// 子类
class ChildCpn extends Component {
  render() {
    const {name, age, height} = this.props;
    return (
      <h2>子组件展示: {name + " " + age + " " + height}</h2>
    )
  }
}

// 父类
export default class App extends Component {
  render() {
    return (
      <div>
        <ChildCpn name="why" age="18" height="1.88"/>
        <ChildCpn name="kobe" age="40" height="1.98"/>
      </div>
    )
  }
}
```

:ghost: 父传子，是通过<span style="color: #ff0000">标签中的属性</span>进行传递的；

:turtle: 实例化类时，会调用父类的构造函数，且作用域绑定到新建对象上： `super.call(this, param1, param2)`

:ghost: 故子类实例可以通过 props 获取自定义属性；

:ghost: 如果在子类（派生类）中不显性定义构造函数，实际上会有以下默认行为。

```react
constructor(props) {
  super(props); // 子类（派生类）默认将所有参数传递给super
}
```

:ghost: 就算不定义 constructor，不将 props 传递给 super 也没问题，源码内部做了<span style="color: #ff0000">双重保险</span>，在某个时机给实例添加了 props 属性。

```react
constructor() {
  super();
  // 不能通过 this.props 获取
}
componentDidMount() {
  // 能够通过 this.props 获取
}
render() {
  // 能够通过 this.props 获取
}
```





### 父传子-函数组件

```react
import React, { Component } from 'react';

// 子类
function ChildCpn(props) {
  const { name, age, height } = props;

  return (
    <h2>{name + age + height}</h2>
  )
}

// 父类
export default class App extends Component {
  render() {
    return (
      <div>
        <ChildCpn name="why" age="18" height="1.88" />
        <ChildCpn name="kobe" age="40" height="1.98" />
      </div>
    )
  }
}
```

:ghost: 子组件的默认参数就是父类传递的自定义属性。



### 父传子-组件验证

> 更多示例可以查看[文档](https://zh-hans.reactjs.org/docs/typechecking-with-proptypes.html)，实际上用 ts 也可以实现对传递属性的验证效果。

```react
import React, { Component } from 'react';

// 组件验证需要引入
import PropTypes from 'prop-types';

function ChildCpn(props) {
  const { name, age, height, names } = props;

  return (
    <div>
      <h2>{name + age + height}</h2>
      <h2>{names}</h2>    
    </div>
  )
}

// 默认类型
ChildCpn.propTypes = {
  name: PropTypes.string.isRequired, // 限制类型，且必传或提供默认值
  age: PropTypes.number,
  height: PropTypes.number,
  names: PropTypes.array
}

// 也可以提供默认值
ChildCpn.defaultProps = {
  name: "why",
  age: 30,
  height: 1.98,
  names: ["aaa", "bbb"]
}

export default class App extends Component {
  render() {
    return (
      <div>
        <ChildCpn name="why" age={18} height={1.88} names={["abc", "cba"]}/>
        <ChildCpn name="kobe" age={40} height={1.98} names={["nba", "mba"]}/>
        <ChildCpn/>
      </div>
    )
  }
}
```

**类组件中的定义方式**

```react
class ChildCpn2 extends Component {
  static propTypes = {}
  static defaultProps = {}
}
```



### 子传父-类组件

这里以 类组件 为例子，编写子传父。

```react
// 子组件
class CounterButton extends Component {
  render() {
    const {onClick} = this.props;
    return <button onClick={onClick}>+1</button>
  }
}

// 父子局
export default class App extends Component {
  constructor(props) {
    super(props);

    this.state = { counter: 0 }
  }

  render() {
    return (
      <div>
        <h2>当前计数: {this.state.counter}</h2>
        <CounterButton onClick={e => this.increment()} />
      </div>
    )
  }

  increment() {
    this.setState({
      counter: this.state.counter + 1
    })
  }
}
```

:ghost: 由父组件提供修改自身状态的方法，并将其<span style="color: #ff0000">通过属性</span>传递给子组件调用；注意绑定 this。



### 任意-全局事件传递

```elm
yarn add events
```

使用频率较高的一个第三方库

```react
import React, { PureComponent } from 'react';

// 1. 引入三方库的类
import { EventEmitter } from 'events';

// 2. 创建事件对象
const eventBus = new EventEmitter();

class Home extends PureComponent {
  // 4. 添加监听
  componentDidMount() {
    eventBus.addListener("sayHello", this.handleSayHelloListener);
  }

  // 5. 取消监听
  componentWillUnmount() {
    eventBus.removeListener("sayHello", this.handleSayHelloListener);
  }

  handleSayHelloListener(num, message) {
    console.log(num, message);
  }

  render() {/* */}
}

class Profile extends PureComponent {
  render() {
    return <button onClick={e => this.emmitEvent()}>点击按钮</button>
  }

  emmitEvent() {
    // 3. 发生全局事件
    eventBus.emit("sayHello", 123, "Hello Home");
  }
}

// 父组件，使用了上面两个兄弟组件
export default class App extends PureComponent {
  render() {
    return (
      <div>
        <Home/>
        <Profile/>
      </div>
    )
  }
}
```

:hammer_and_wrench: 使用上，在参数方面，与 vue 的自定义事件特别像；

:ghost: 取消监听时，如果不传入对特定钩子的引用，将取消该事件下的所有钩子。



### tabs案例

:european_castle: 动态类的添加；

:turtle: 在任一文件中引入资源（css），都能生成依赖关系，正确加载。

:hammer_and_wrench: 对于静态数据，将它设置到 state 之外的地方 ；

:whale: 这里通过子组件维护 currentIndex，其实感觉由父组件维护该状态更合理；

<span style="backGround: #efe0b9">父组件</span>

```react
import TabControl from './TabControl';
import './style.css';

export default class App extends Component {
  constructor(props) {
    super(props);

    this.titles = ['新款', '精选', '流行'];

    this.state = {
      currentTitle: "新款",
      currentIndex: 0
    }
  }

  render() {
    const {currentTitle} = this.state;

    return (
      <div>
        <TabControl itemClick={index => this.itemClick(index)} titles={this.titles} />
        <h2>{currentTitle}</h2>
      </div>
    )
  }

  itemClick(index) {
    this.setState({
      currentTitle: this.titles[index]
    })
  }
}
```

<span style="backGround: #efe0b9">子组件</span>

```react
export default class TabControl extends Component {
  constructor(props) {
    super(props);

    this.state = {
      currentIndex: 0
    }
  }

  render() {
    const { titles } = this.props;
    const { currentIndex } = this.state;

    return (
      <div className="tab-control">
        {
          titles.map((item, index) => {
            return (
              <div key={item} 
                   className={"tab-item " + (index === currentIndex ? "active": "")}
                   onClick={e => this.itemClick(index)}>
                <span>{item}</span>
              </div>
            )
          })
        }
      </div>
    )
  }

  itemClick(index) {
    this.setState({
      currentIndex: index
    })

    const {itemClick} = this.props;
    itemClick(index);
  }
}
```





## 实现 slot

### 通过标签内容传递

<span style="backGround: #efe0b9">父组件</span>

```react
import NavBar from './NavBar';

export default class App extends Component {

  render() {
    return (
      <div>
        <NavBar>
          <span>aaa</span>
          <strong>bbb</strong>
          <a href="/#">ccc</a>
        </NavBar>
      </div>
    )
  }
}
```

:ghost: 双标签内的内容，会传递给子组件。

<span style="backGround: #efe0b9">子组件</span>

```react
export default class NavBar extends Component {
  render() {
    return (
      <div className="nav-item nav-bar">
        <div className="nav-left">
          {this.props.children[0]}
        </div>
        <div className="nav-item nav-center">
          {this.props.children[1]}
        </div>
        <div className="nav-item nav-right">
          {this.props.children[2]}
        </div>
      </div>
    )
  }
}
```

:ghost: 通过 <span style="color: #a50">this.props.children</span> 可以获取到父组件传递的内容；

:octopus: 由于只能通过下标获取具体项，需要父组件传递的内容顺序、数量要规范，不方便。



### 通过标签属性传递

<span style="backGround: #efe0b9">父组件</span>

```react
import NavBar from './NavBar';

export default class App extends Component {
  const leftJsx = <span>aaa</span>;
  render() {
    return (
      <div>
        <NavBar leftSlot={leftJsx}
                centerSlot={<strong>bbb</strong>}
                rightSlot={<a href="/#">ccc</a>}/>
      </div>
    )
  }
}
```

:ghost:  jsx 本身也可以<span style="color: #ff0000">作为标签属性</span>传递。

<span style="backGround: #efe0b9">子组件</span>

```react
export default class NavBar2 extends Component {
  render() {
    const {leftSlot, centerSlot, rightSlot} = this.props;

    return (
      <div className="nav-item nav-bar">
        <div className="nav-left">
          {leftSlot}
        </div>
        <div className="nav-item nav-center">
          {centerSlot}
        </div>
        <div className="nav-item nav-right">
          {rightSlot}
        </div>
      </div>
    )
  }
}
```



## 跨组件通信

| API                 | 说明                                         | 适用     |
| ------------------- | -------------------------------------------- | -------- |
| React.createContext | 创建需要共享的Context对象                    | 通用     |
| Context.Provider    | 用于包裹的特殊组件，向内部的子孙组件传递数据 | 通用     |
| Class.contextType   | 告知当前组件使用哪个Context对象              | 类组件   |
| Context.Consumer    | 用于包裹的特殊组件，向内部传递数据           | 函数组件 |

### 跨组件通信-props

该方案会产生冗余的代码，因为中间层不得不进行一个转承。

```react
// 孙
function ProfileHeader(props) {
  return (
    <div>
      <h2>用户昵称: {props.nickname}</h2>
      <h2>用户等级: {props.level}</h2>
    </div>
  )
}

// 子
function Profile(props) {
  return (
    <div>
      <ProfileHeader nickname={props.nickname} level={props.level}/>
      <div>设置</div>
    </div>
  )
} 

// 父
export default class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      nickname: "kobe",
      level: 99
    }
  }

  render() {
    const {nickname, level} = this.state;

    return (
      <div>
        <Profile nickname={nickname} level={level} />
      </div>
    )
  }
}
```

:european_castle: 对于不需要维护内部状态的组件，可以写成函数组件。



### 跨组件通信-props-优化

标签属性[展开](https://zh-hans.reactjs.org/docs/jsx-in-depth.html#spread-attributes)，为 jsx 中的语法糖。

```react
function App() {
  return <Greeting firstName="Ben" lastName="Hector">;
}

// 等价
function App() {
  const props = {firstName: "Ben", lastName: "Hector"};
  return <Greeting {...props} />;
}
```

上面的例子可以改写如下：

```react
// 孙
function ProfileHeader(props) {
  return (
    <div>
      <h2>用户昵称: {props.nickname}</h2>
      <h2>用户等级: {props.level}</h2>
    </div>
  )
}

// 子
function Profile(props) {
  return (
    <div>
      <ProfileHeader {...props}/>
      <div>设置</div>
    </div>
  )
} 

// 父
export default class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      nickname: "kobe",
      level: 99
    }
  }

  render() {
    return (
      <div>
        <Profile {...this.state}/>
      </div>
    )
  }
}
```



### 跨组件通信-context-类组件

```react
// 1. 创建 Context 对象（默认值）
const UserContext = React.createContext({
  nickname: "aaaa",
  level: -1
})

// 4. 通过 this.context 获取传值
class ProfileHeader extends Component {
  render() {
    return (
      <div>
        <h2>用户昵称: {this.context.nickname}</h2>
        <h2>用户等级: {this.context.level}</h2>
      </div>
    )
  }
}

// 3. 给组件的contextType属性赋值为相应的Context对象
ProfileHeader.contextType = UserContext;

function Profile(props) {
  return (
    <div>
      <ProfileHeader />
      <div>设置</div>
    </div>
  )
}

// 2. 在父组件中使用特殊组件包裹需要进行传值的组件（可以提供传值内容）
export default class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      nickname: "kobe",
      level: 99
    }
  }

  render() {
    return (
      <div>
        <UserContext.Provider value={this.state}>
          <Profile />
        </UserContext.Provider>
      </div>
    )
  }
}
```

:hammer_and_wrench: 整个流程中，不需要对<span style="color: #ff0000">中间组件</span>做任何操作；

:ghost: 特殊组件 <span style="color: #a50">xx.Provider</span> 通过 <span style="color: #a50">value</span> 属性向后代传值；

:ghost: 如果需要传值的组件（及其祖先组件）没有被特殊组件包裹，该获取到的将会是默认值；

:whale: 当 Provider 的 value 值发生变化时，它内部的所有消费组件都会重新渲染。



### 跨组件通信-context-函数组件

```react
// 1. 创建 Context 对象（默认值）
const UserContext = React.createContext({
  nickname: "aaaa",
  level: -1
})

// 3. 通过特殊组件包裹，并在内部写成函数提供默认参数进行传值
function ProfileHeader() {
  return (
    <UserContext.Consumer>
      {
        value => {
          return (
            <div>
              <h2>用户昵称: {value.nickname}</h2>
              <h2>用户等级: {value.level}</h2>
            </div>
          )
        }
      }
    </UserContext.Consumer>
  )
}

function Profile(props) {
  return (
    <div>
      <ProfileHeader />
      <div>设置</div>
    </div>
  )
}

// 2. 在父组件中使用特殊组件包裹需要进行传值的组件（可以提供传值内容）
export default class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      nickname: "kobe",
      level: 99
    }
  }

  render() {
    return (
      <div>
        <UserContext.Provider value={this.state}>
          <Profile />
        </UserContext.Provider>
      </div>
    )
  }
}
```



### 跨组件通信-context-多个

:hammer_and_wrench: 由于要进行嵌套才能传递多个 context 对象，实际开发不推荐用这种。

```react
// 1. 创建 Context 对象（默认值）
const UserContext = React.createContext({
  nickname: "aaaa",
  level: -1
})

const ThemeContext = React.createContext({
  color: "black"
})

// 3. 套娃
function ProfileHeader() {
  return (
    <UserContext.Consumer>
      {
        value => {
          return (
            <ThemeContext.Consumer>
              {
                theme => {
                  return (
                    <div>
                      <h2 style={{color: theme.color}}>用户昵称: {value.nickname}</h2>
                      <h2>用户等级: {value.level}</h2>
                      <h2>颜色: {theme.color}</h2>
                    </div>
                  )
                }
              }
            </ThemeContext.Consumer>
          )
        }
      }
    </UserContext.Consumer>
  )
}

function Profile(props) {
  return (
    <div>
      <ProfileHeader />
      <div>设置</div>
    </div>
  )
}

// 2. 在父组件中使用特殊组件包裹需要进行传值的组件（可以提供传值内容）
export default class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      nickname: "kobe",
      level: 99
    }
  }

  render() {
    return (
      <div>
        <UserContext.Provider value={this.state}>
          <ThemeContext.Provider value={{ color: "red" }}>
            <Profile />
          </ThemeContext.Provider>
        </UserContext.Provider>
      </div>
    )
  }
}
```



## setState

| 要点     | 说明                                                         |
| -------- | ------------------------------------------------------------ |
| 异步原因 | 多次执行 render 函数，造成页面频繁重新渲染，效率低；获取多个更新后再更新可以提高性能 |
| 异步原因 | 如果同步更新 state 后，还没执行 render；子组件的 prop 会失去同步 |
| 异步时机 | 组件生命周期 / React合成事件                                 |
| 同步时机 | setTimeout / 原生dom事件                                     |



### setState-异步执行

```react
<button onClick={e => this.changeText()}>改变文本</button>

// 合成事件
changeText() {
  this.setState({
    message: "更新后的值"
  })
  console.log(this.state.message); // 更新前的值
}
```

<span style="color: #f7534f;font-weight:600">合成事件</span> 区别于原生的 dom 事件，内部会判断其在浏览器 / native 的实现。



### setState-获取更新后的值

```react
// 方式二：钩子中获取
componentDidUpdate() {
  console.log(this.state.message);
}
changeText() {
  // 方式一：setState的回调
  this.setState({
    message: "你好啊,李银河"
  }, () => {
    console.log(this.state.message);
  })
}
```

:ghost: setState 提供第二个参数，为 state 更新后执行的回调。



### setState-同步执行

```react
<button id="btn">改变文本</button>

componentDidMount() {
  // 情况二：原生dom事件
  document.getElementById("btn").addEventListener("click", (e) => {
    this.setState({
      message: "你好啊,李银河"
    })
    console.log(this.state.message);
  })
}

changeText() {
  // 情况一: 定时器中执行
  setTimeout(() => {
    this.setState({
      message: "你好啊,李银河"
    })
    console.log(this.state.message);
  }, 0);
}
```



### setState-数据的合并

```react
constructor(props) {
  super(props);

  this.state = {
    message: "Hello World",
    name: "coderwhy"
  }
}

render() {
  return <button onClick={e => this.changeText()}>改变文本</button>
}

changeText() {
  this.setState({
    message: "你好啊,李银河"
  });
}
```

:ghost: 调用 setState 方法的本质，其实是 <span style="color: #a50">Object.assign</span>，故会保留之前的其它属性。



### setState-本身的合并

```react
// 假设 state.counter 本来的值是0，更新后的结果将为 1
increment() {
  this.setState({
    counter: this.state.counter + 1
  });
  this.setState({
    counter: this.state.counter + 1
  });
  this.setState({
    counter: this.state.counter + 1
  });
}
```

:octopus: 会将多次更新后的结果进行 <span style="color: #a50">Object.assign</span>，故重复属性会被覆盖。



### setState-避免本身合并

```react
// 假设 state.counter 本来的值是0，更新后的结果将为 3
increment() {
  this.setState((prevState, props) => {
    return {
      counter: prevState.counter + 1
    }
  });
  this.setState((prevState, props) => {
    return {
      counter: prevState.counter + 1
    }
  });
  this.setState((prevState, props) => {
    return {
      counter: prevState.counter + 1
    }
  });
}
```

:ghost: <span style="color: #ff0000">setState</span> 本身也可以接收函数，此时它会先将结果快照“保存”下来，供后面获取。

:octopus: 注意要用首参来获取上次的更新结果，而不是从状态中获取。



