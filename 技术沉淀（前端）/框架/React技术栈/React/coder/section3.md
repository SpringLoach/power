# React性能优化

## React更新机制

1. props/state 改变
2. render 函数重新执行
3. 产生新的虚拟Dom树 
4. 新旧Dom树进行diff
5. 计算差异 -更新到真实DOM

| 类型 | 说明                                                         |
| ---- | ------------------------------------------------------------ |
| 算法 | 同层节点之间进行比较，不会跨节点比较                         |
| 算法 | 不同类型的节点，不会比较其子树，直接替换                     |
| 算法 | 通过 key，指定哪些节点保持稳定                               |
| 要点 | 某节点类型改变时，整个旧的 DOM 树被销毁，新的 DOM 树会被创建并插入，触发完整的重建 |
| 要点 | 在遍历列表时，如果没有提供 key，默认按节点顺序往下比较       |
| 要点 | 使用 key 能帮助匹配原有树上的子元素以及最新树上的子元素；如在列头插入数据 |
| 要点 | 使用 index 作为 key，对性能是没有优化的                      |

### 对比不同/相同类型元素

```react
<div>
  <Counter />
</div>

// 更改：React 会销毁 Counter 组件并且重新装载一个新的组件，而不会对Counter进行复用

<span>
  <Counter />
</span>
```

```react
// React 知道只需要修改 DOM 元素上的 className 属性
<div className="before" title="stuff" />
<div className="after" title="stuff" />

// React 知道只需要修改 DOM 元素上的 color 样式，无需修改 fontWeight
<div style="{{ color: 'red', fontWeight: 'bold' }}" />
<div style="{{ color: 'green', fontWeight: 'bold' }}" />
```



## 嵌套组件的重新渲染

### 嵌套组件渲染-机制

| 类型     | 默认情况下                                                   |
| -------- | ------------------------------------------------------------ |
| 补充     | 即使 jsx 中没有对 state 的依赖，执行了 setState 依旧会调用 render |
| 嵌套组件 | 父组件内部的状态发生改变（setState ）时，它的所有子组件也会调用相应的 render |
| 嵌套组件 | 这在性能方面，不是一件好事                                   |



### 控制重新渲染-钩子

```react
export default class App extends Component {
  constructor(props) {/**/}

  render() {/**/}

  // 参数为更新后的自定义属性、状态
  shouldComponentUpdate(nextProps, nextState) {
    if (this.state.counter !== nextState.counter) {
      return true;
    }
    
    return false;
  }

  increment() {
    this.setState({
      counter: this.state.counter + 1
    })
  }
}
```

:ghost: setState 后会触发 <span style="color: #a50">shouldComponentUpdate</span> 钩子，必须在钩子内返回 true，组件才会执行 render。

:octopus: 这种方式用起来较为笨重。



### 优化重新渲染-类组件

只有自身的 props 或 state 发生变化时（浅层比较），才会触发组件的重新渲染。

```react
import React, { PureComponent } from 'react';

export default class App extends PureComponent {
  /* 内容不变 */
}
```

:ghost: 该方法仅适用于类组件；

:whale: 要想改变父组件状态时，所有没关联的子组件不触发 render，要给所有子组件都修改为这种继承；

:whale: 而孙组件不受影响：父没有执行 render，也不会使子执行 render。



### 优化重新渲染-函数组件

```react
import React, { PureComponent, memo } from 'react';

const MemoHeader = memo(function Header() {
  return <h2>我是Header组件</h2>
})

export default class App extends PureComponent {
  // ...

  render() {
    return (
      <div>
        <h2>当前计数: {this.state.counter}</h2>
        <button onClick={e => this.increment()}>+1</button>
        <MemoHeader/>
      </div>
    )
  }

  // ...
}
```

:ghost: 要想控制函数式组件的重新渲染，可以引入 memo 方法；用它包裹原有组件，返回的变量作为组件使用。

:ghost: 只有自身的 props 或 state 发生变化时（浅层比较），才会触发组件的重新渲染。



### setState-不可变的力量

#### 错误操作

```react
export default class App extends Component {
  constructor(props) {/**/}

  shouldComponentUpdate(newProps, newState) {
    if (newState.friends !== this.state.friends) {
      return true;
    }

    return false;
  }

  render() {/**/}

  insertData() {
    const newData = {name: "tom", age: 30}
    this.state.friends.push(newData);
    this.setState({
      friends: this.state.friends
    });
  }
}
```

:octopus: 在比较新旧的 state 是否变化时，指向同一块<span style="color: #ff0000">内存地址</span>会导致无法触发重新渲染；

:european_castle: 使用 PureComponent 优化重新渲染时，内部就是根据新旧值是变化来执行不同逻辑。



#### 正确操作

```react
import React, { PureComponent } from 'react';

export default class App extends PureComponent {
  constructor(props) {/* */}

  render() {/* */}

  insertData() {
    const newFriends = [...this.state.friends];
    newFriends.push({ name: "tom", age: 30 });
    this.setState({
      friends: newFriends
    })
  }
}
```

 

# ----



## 受控和非受控组件

### refs的使用

#### 三种使用方式

方式一：字符串（已废弃）

方式二：对象（推荐）

方式三：回调函数

**方式一**

```react
import React, { PureComponent } from 'react';

export default class App extends PureComponent {
  render() {
    return (
      <div>
        {/* 使用方式一：传入字符串 */}
        <h2 ref="titleRef">Hello React</h2>
        <button onClick={e => this.changeText()}>改变文本</button>
      </div>
    )
  }

  changeText() {
    // 使用方式一
    this.refs.titleRef.innerHTML = "Hello Coderwhy";
  }
}
```

:octopus: 这种方式官方已经不推荐使用。

**方式二**

```react
import React, { PureComponent, createRef } from 'react';

export default class App extends PureComponent {
  constructor(props) {
    super(props);

    this.titleRef = createRef();
  }
    
  render() {
    return (
      <div>
        {/* 使用方式二：传入对象 */}
        <h2 ref={this.titleRef}>Hello React</h2>
        <button onClick={e => this.changeText()}>改变文本</button>
      </div>
    )
  }

  changeText() {
    // 使用方式二
    this.titleRef.current.innerHTML = "Hello JavaScript";
  }
}
```

**方式三**

```react
import React, { PureComponent, createRef } from 'react';

export default class App extends PureComponent {
  constructor(props) {
    super(props);

    this.titleEl = null;
  }
    
  render() {
    return (
      <div>
        {/* 使用方式三：传入函数（作为挂载成功的回调） */}
        <h2 ref={arg => this.titleEl = arg}>Hello React</h2>
        <button onClick={e => this.changeText()}>改变文本</button>
      </div>
    )
  }

  changeText() {
    // 使用方式三
    this.titleEl.innerHTML = "Hello TypeScript";
  }
}
```



#### 引用子组件

```react
import React, { PureComponent, createRef } from 'react';

// 子组件
class Counter extends PureComponent {
  constructor(props) {
    super(props);

    this.state = { counter: 0 }
  }

  render() {
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
}

// 父组件
export default class App extends PureComponent {
  constructor(props) {
    super(props);

    this.counterRef = createRef();
  }

  render() {
    return (
      <div>
        <Counter ref={this.counterRef}/>
        <button onClick={e => this.appBtnClick()}>调用子组件的方法</button>
      </div>
    )
  }

  appBtnClick() {
    this.counterRef.current.increment();
  }
}
```

:ghost: 只能引用类组件，无法引用函数式组件。



#### ref的转发

```react
import React, { PureComponent, createRef, forwardRef } from 'react';

class Home extends PureComponent {
  render() {
    return <h2>Home</h2>
  }
}

// 使用高阶组件
const Profile = forwardRef(function(props, ref) {
  return <p ref={ref}>Profile</p>
})

export default class App extends PureComponent {
  constructor(props) {
    super(props);

    this.profileRef = createRef();
  }

  render() {
    return (
      <div>
        {/* 传递 ref */}
        <Profile ref={this.profileRef} name={"why"}/>
        <button onClick={e => this.printRef()}>打印ref</button>
      </div>
    )
  }

  printRef() {
    console.log(this.profileRef.current);
  }
}
```

:whale: 在 jsx 的标签属性中，默认不支持传递 ref，react 内部不会把它当作属性传递；

:ghost: 通过高阶组件 <span style="color: #a50">forwardRef</span>，可以使<span style="color: #ff0000">函数式组件</span>接收第二个参数，即组件实例 ref。



### 受控组件

| 类型       | 特点                                |
| ---------- | ----------------------------------- |
| 受控组件   | 通过 state 维护表单控件的值（推荐） |
| 非受控组件 | 通过 dom 节点维护表单数据           |

```react
import React, { PureComponent } from 'react'

export default class App extends PureComponent {
  constructor(props) {
    super(props);
    this.state = { username: "" }
  }

  render() {
    return (
      <div>
        <form onSubmit={e => this.handleSubmit(e)}>
          <label htmlFor="username">
            用户: 
            {/* 受控组件 */}
            <input type="text" 
                   id="username" 
                   onChange={e => this.handleChange(e)}
                   value={this.state.username}/>
          </label>
          <input type="submit" value="提交"/>
        </form>
      </div>
    )
  }

  // 阻止表单的默认提交，以方便实现自定义的逻辑
  handleSubmit(event) {
    event.preventDefault();
    console.log(this.state.username);
  }

  handleChange(event) {
    this.setState({
      username: event.target.value
    })
  }
}
```

:whale: 以 input 为例子：通过 value 传递 state 中的默认值，通过监听，将改变同步到 state 中，实现双向绑定。



### 非受控组件

实际上就是通过原生的表单方式，配合 refs 进行操作，不推荐。

```react
import React, { PureComponent, createRef } from 'react'

export default class App extends PureComponent {
  constructor(props) {
    super(props);

    this.usernameRef = createRef();
  }

  render() {
    return (
      <div>
        <form onSubmit={e => this.handleSubmit(e)}>
          <label htmlFor="username">
            用户: 
            <input type="text" id="username" ref={this.usernameRef}/>
          </label>
          <input type="submit" value="提交"/>
        </form>
      </div>
    )
  }

  handleSubmit(event) {
    event.preventDefault();
    console.log(this.usernameRef.current.value);
  }
}
```



## 高阶组件

<span style="color: #f7534f;font-weight:600">高阶组件</span>是参数为组件，返回值为新组件的<span style="color: #ff0000">函数</span>；

高阶组件并不是React API的一部分，它是基于 React 的组合特性而形成的设计模式。



### 高阶组件-定义方式

```react
import React, { PureComponent } from 'react'

class App extends PureComponent {
  render() {
    return <div> App: {this.props.name} </div>
  }
}

// 定义高阶组件
function enhanceComponent(WrappedComponent) {
  return class NewComponent extends PureComponent {
    render() {
      return <WrappedComponent {...this.props}/>
    }
  }
}

// 调用高阶组件
const EnhanceComponent = enhanceComponent(App);

export default EnhanceComponent;
```

:turtle: 这里对自定义属性进行了传递。

**也支持函数式组件**

```react
function enhanceComponent(WrappedComponent) {
  function NewComponent(props) {
    return <WrappedComponent {...props}/>
  }

  NewComponent.displayName = "Kobe";
  return NewComponent;
}
```

:whale: 也可以对组件进行命名，这在开发阶段，使用调试工具进行调试时，可能有所帮助；



### 应用-增强props

场景：给组件增加一个 props 属性： region="中国"

```react
import React, { PureComponent } from 'react';

// 定义高阶组件
function enhanceRegionProps(WrappedComponent) {
  return props => {
    return <WrappedComponent {...props} region="中国"/>
  }
}

class Home extends PureComponent {
  render() {
    return <h2>Home: {`昵称: ${this.props.nickname} 等级: ${this.props.level} 区域: ${this.props.region}`}</h2>
  }
}

// 调用高阶组件
const EnhanceHome = enhanceRegionProps(Home);

class App extends PureComponent {
  render() {
    return (
      <div>
        App
        {/* 使用高阶组件 */}
        <EnhanceHome nickname="coderwhy" level={90}/>
      </div>
    )
  }
}

export default App;
```



### 应用-context转props

场景：将 context 对象上的属性传递到 props 上，可以简化中间的传递流程。

```react
import React, { PureComponent, createContext } from 'react';

// 定义高阶组件
function withUser(WrappedComponent) {
  return props => {
    return (
      <UserContext.Consumer>
        {
          user => {
            return <WrappedComponent {...props} {...user}/>
          } 
        }
      </UserContext.Consumer>
    )
  }
}

// 创建Context
const UserContext = createContext({
  nickname: "默认",
  level: -1,
  区域: "中国"
});

class Home extends PureComponent {
  render() {
    return <h2>Home: {`昵称: ${this.props.nickname} 等级: ${this.props.level} 区域: ${this.props.region}`}</h2>
  }
}

const UserHome = withUser(Home);

class App extends PureComponent {
  render() {
    return (
      <div>
        App
        <UserContext.Provider value={{nickname: "why", level: 90, region: "中国"}}>
          <UserHome/>
        </UserContext.Provider>
      </div>
    )
  }
}

export default App;
```



### 应用-登录校验

场景：未登录跳转到登录页，有登录就跳转购物车

```react
import React, { PureComponent } from 'react';

class LoginPage extends PureComponent {
  render() {
    return <h2>LoginPage</h2>
  }
}

// 创建高阶组件
function withAuth(WrappedComponent) {
  return props => {
    const {isLogin} = props;
    if (isLogin) {
      return <WrappedComponent {...props}/>
    } else {
      return <LoginPage/>
    }
  }
}

// 购物车组件
class CartPage extends PureComponent {
  render() {
    return <h2>CartPage</h2>
  }
}

// 调用高阶组件
const AuthCartPage = withAuth(CartPage);

export default class App extends PureComponent {
  render() {
    return (
      <div>
        <AuthCartPage isLogin={true}/>
      </div>
    )
  }
}
```



### 应用-生命周期劫持

```react
import React, { PureComponent } from 'react';

// 创建高阶组件
function withRenderTime(WrappedComponent) {
  // 添加一个中间的组件
  return class extends PureComponent {
    // 即将渲染获取一个时间 beginTime
    UNSAFE_componentWillMount() {
      this.beginTime = Date.now();
    }

    // 渲染完成再获取一个时间 endTime
    componentDidMount() {
      this.endTime = Date.now();
      const interval = this.endTime - this.beginTime;
      console.log(`${WrappedComponent.name}渲染时间: ${interval}`)
    }

    render() {
      return <WrappedComponent {...this.props}/>
    }
  }
}

class Home extends PureComponent {
  render() {
    return <h2>Home</h2>
  }
}

// 调用高阶组件
const TimeHome = withRenderTime(Home);

export default class App extends PureComponent {
  render() {
    return (
      <div>
        <TimeHome />
        <TimeAbout />
      </div>
    )
  }
}
```

:whale: 组件实例上有一个 name 属性，暴露组件的名称。



## 组件内容补充

### Portal-修改默认挂载

| 要点     | 说明                                                        |
| -------- | ----------------------------------------------------------- |
| 默认情况 | 从组件返回元素时，元素将被挂载到 DOM 节点中离其最近的父节点 |
| 情景     | 如相对页面居中的弹窗                                        |
| Portal   | 提供了一种将子节点渲染到存在于父组件以外的 DOM 节点         |
| 首参     | 任何可渲染的 React 子元素，例如一个元素，字符串或 fragment  |
| 第二参   | DOM 元素；默认是 id 为 root 的 DOM 元素                     |

```react
import React, { PureComponent } from 'react';
// 1.引入
import ReactDOM from 'react-dom';

class Modal extends PureComponent {
  render() {
    // 2. 使用api包裹
    const div = document.createElement("div");
    document.body.appendChild(div);
    return ReactDOM.createPortal(
      this.props.children,
      div
    )
  }
}

export default class App extends PureComponent {
  render() {
    return (
      <div>
        <h2>Home</h2>
        <Modal>
          <h2>Title</h2>
        </Modal>
      </div>
    )
  }
}
```



### fragments-片段/模板

本质上，与小程序的 block，非常相似；用于添加一个不会实际渲染的根组件。

```react
// 引入组件
import React, { PureComponent, Fragment } from 'react';

export default class App extends PureComponent {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      // 使用组件
      <Fragment>
       <h2>元素一</h2>
       <div>元素二</div>
      <Fragment/>
    )
  }
}
```

:ghost: 可以给 Fragment 标签添加 key 属性（作为列表项时优化更新）

```react
render() {
  return (
    <>
     <h2>元素一</h2>
     <div>元素二</div>
    </>
  )
}
```

:octopus: 也可以写成短语法的形式，此时不能给该标签添加 key 属性。



### StrictMode-严格模式

| 特性     | 说明                                               | 例子                      |
| -------- | -------------------------------------------------- | ------------------------- |
| 严格模式 | 与 Fragment 一样，StrictMode 不会渲染任何可见的 UI |                           |
| 严格模式 | 它为其后代元素触发额外的检查和警告                 |                           |
| 严格模式 | 仅在开发模式下运行                                 |                           |
| 检查内容 | 待废弃的声明周期                                   | UNSAFE_componentWillMount |
| 检查内容 | 待废弃的 ref 的字符串用法                          | ref="title"               |
| 检查内容 | 开发环境下会调用两次 constructor 来检查副作用      |                           |
| 检查内容 | findDOMNode                                        | /                         |
| 检查内容 | 过时的 context API                                 | /                         |

```react
return (
  <div>
    <h2>雨我无瓜</h2>
    <React.StrictMode>
      <h2>后代也被严格检查</h2>
    </React.StrictMode>
  </div>
)
```



## 样式方案

React官方并没有给出在React中统一的样式风格，因此存在的方案很多。

| 方式              | 特点                                                         |
| ----------------- | ------------------------------------------------------------ |
| 内联样式          | 能避免样式冲突问题；设置动态样式方便                         |
| 内联样式          | 需要写成驼峰；不适合大量样式；无法写伪类、伪元素             |
| 普通css           | 与普通的网页开发中编写方式一致                               |
| 普通css           | 都属于全局样式，容易造成样式冲突                             |
| css modules       | webpack 提供， React 脚手架内置了相应配置                    |
| css modules       | 设置局部样式方便                                             |
| css modules       | 类名不能使用连接符；形式生硬；配合内联样式才能设置动态样式   |
| CSS in JS         | 将样式写入到 js 中的方式，容易使用 js 的状态；最流行的库是  styled-components |
| CSS in JS         | 支持样式嵌套、样式继承、动态样式、后代选择器、伪类、设置主题等 |
| styled-components | 基于 ES6 的特性：标签模板字符串 实现                         |



### 内联样式

```react
export default class App extends PureComponent {
  constructor(props) {
    super(props);

    this.state = {
      color: "purple"
    }
  }

  render() {
    const pStyle = {
      color: this.state.color,
      textDecoration: "underline"
    }

    return (
      <div>
        <h2 style={{fontSize: "50px", color: "red"}}>我是标题</h2>
        <p style={pStyle}>我是一段文字描述</p>
      </div>
    )
  }
}
```



### 普通css

```elm
- app           // 组件文件夹
  + index.js    // 组件
  + style.css   // 组件样式
- home
  + index.js
  + style.css
- profile
  + index.js
  + style.css
```

```react
import React, { PureComponent } from 'react';

import './style.css';

export default class App extends PureComponent {
  render() {
    return (
      <div id="app">
        App
        <h2 className="title">标题</h2>
      </div>
    )
  }
}
```



### css modules

```elm
- app                   // 组件文件夹
  + index.js            // 组件
  + style.modules.css   // 组件样式
- home
  + index.js
  + style.modules.css
- profile
  + index.js
  + style.modules.css
```

<span style="backGround: #efe0b9">home\index.js</span>

```react
import React, { PureComponent } from 'react';

import homeStyle from './style.module.css';

export default class Home extends PureComponent {
  render() {
    return (
      <div className="home">
        <h2 className={homeStyle.title}>我是home的标题</h2>
        <div className={homeStyle.banner}>
          <span>轮播图</span>
        </div>
      </div>
    )
  }
}
```

<span style="backGround: #efe0b9">home\index.js</span>

```css
.title {
  font-size: 30px;
  color: red;
}

.banner {
  color: orange;
}
```



### styled-components

```elm
yarn add styled-components
```

#### 基本使用

示例结构

```elm
- home             // 组件文件夹
  + index.js	   // 组件
  + style.css      // 定义样式组件
```

<span style="backGround: #efe0b9">app\index.js</span>

```react
import React, { PureComponent } from 'react';

// 引入
import styled from 'styled-components';

// 定义组件类型和样式
const HYButton = styled.button`
  padding: 10px 20px;
  border-color: red;
  color: red;
`

// 使用组件继承，可以继承组件类型和样式
const HYPrimaryButton = styled(HYButton)`
  color: #fff;
  background-color: green;
`

export default class App extends PureComponent {
  render() {
    return (
      <div>
        {/* 使用 */}
        <HYButton>普通按钮</HYButton>
        <HYPrimaryButton>主要按钮</HYPrimaryButton>
      </div>
    )
  }
}
```

可以定义标签类型，传入特点样式，返回（带有样式的）组件。



#### 其它特性

<span style="backGround: #efe0b9">profile\index.js</span>

```react
import React, { PureComponent } from 'react';
import styled from 'styled-components';

/**
 * 特点:
 *  1.props穿透
 *  2.attrs的使用
 *  3.传入state作为props属性
 */

const HYInput = styled.input.attrs({
  placeholder: "coderwhy",
  bColor: "red"
})`
  background-color: lightblue;
  border-color: ${props => props.bColor};
  color: ${props => props.color};
`

export default class Profile extends PureComponent {
  constructor(props) {
    super(props);
    this.state = { color: "purple" }
  }

  render() {
    return (
      <div>
        <HYInput type="password" color={this.state.color}/>
        <h2>标题</h2>
      </div>
    )
  }
}
```

:ghost: 添加到样式组件上的属性，带有<span style="color: #ff0000">穿透</span>功能，能添加到原标签上去；

:ghost: 通过使用 attrs，可以对原标签<span style="color: #ff0000">添加属性</span>，会与样式组件上的属性进行合并；

:ghost: 这些属性在定义样式时，都可以通过函数方式获取到。



#### 使用主题

```react
import React, { PureComponent } from 'react';

import styled, { ThemeProvider } from 'styled-components';

const TitleWrapper = styled.h2`
  text-decoration: underline;
  color: ${props => props.theme.themeColor};
  font-size: ${props => props.theme.fontSize};
`

export default class App extends PureComponent {
  render() {
    return (
      <ThemeProvider theme={{themeColor: "red", fontSize: "30px"}}>
        <TitleWrapper>标题</TitleWrapper>
      </ThemeProvider>
    )
  }
}

```

:turtle: 使用特殊组件 <span style="color: #a50">ThemeProvider</span> 提供全局的主题属性；

:turtle: 内部的所有后代级别的样式组件，都可通过 <span style="color: #a50">props.theme</span> 获取到主题属性。



#### 开发规范

<span style="backGround: #efe0b9">home\index.js</span>

```react
import React, { PureComponent } from 'react';

// 引入样式组件后使用
import { 
  HomeWrapper,
  TitleWrapper
} from "./style";

export default class Home extends PureComponent {
  render() {
    return (
      <HomeWrapper>
        <TitleWrapper>标题</TitleWrapper>
        <div className="banner">
          <span className="active">轮播图</span>
        </div>
      </HomeWrapper>
    )
  }
}
```

:ghost: 实际上开发时，可以将样式组件的定义逻辑进行抽离。

<span style="backGround: #efe0b9">home\style.js</span>

```react
import styled from 'styled-components';

// 定义样式组件
export const HomeWrapper = styled.div`
  font-size: 12px;
  color: red;

  .banner {
    background-color: blue;

    span {
      color: #fff;

      &.active {
        color: red;
      }

      &:hover {
        color: green;
      }

      &::after {
        content: "aaa"
      }
    }
  }
`

export const TitleWrapper = styled.h2`
  text-decoration: underline;
  color: red;
`
```

:ghost: 可以像 less、sass 一样<span style="color: #ff0000">通过嵌套</span>的方式编写样式。



## 添加类名

### 普通方式

```react
render() {
  const { isActive } = this.state;
  return (
    <div>
      {/* 添加固定类 */}
      <h2 className={"foo bar active title"}>标题</h2>
      {/* 添加固定类和动态类 */}
      <h2 className={"title" + (isActive ? " active": "")}>标题</h2>
      <h2 className={["title", (isActive ? "active": "")].join(" ")}>标题</h2>
    </div>
  )
}
```



### 使用 classnames

帮助添加类名的第三方库。

```elm
yarn add classnames
```

```react
// 顶层引入
import classNames from 'classnames';

// 组件内部
render() {
  const { isActive } = this.state;
  const errClass = "error";  
  const demoClass = null;
    
  return (
    <div>
      {/* 添加固定类 */}
      <h2 className={classNames("foo", "bar", "active", "title")}>标题</h2>
      {/* 添加固定类和动态类 */}
      <h2 className={classNames("foo", errClass, demoClass)}>标题</h2>
      <h2 className={classNames("foo", {"active": isActive})}>标题</h2>
      {/* 支持数组形式 */}   
      <h2 className={classNames(["active", "title", {"active": isActive}])}>标题</h2>
    </div>
  )
}
```

:whale: 函数内部可以使用变量，但是对于 null，0， undefined 这些值，会被忽略。





