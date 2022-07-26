### React的特点

#### 声明式编程

只需要维护状态即可，状态改变时，React 会根据最新状态渲染界面；不需要手动操作DOM。

![image-20220712212927790](.\img\声明式编程)



### 初体验-引入CDN

#### 依赖多个库

只需要引入一个库就能使用 vue，但 react 不行：

```html
<script src="https://unpkg.com/react@16/umd/react.development.js" crossorigin></script>
<script src="https://unpkg.com/react-dom@16/umd/react-dom.development.js"></script>
<!-- 使用jsx时需要额外引入 -->
<script src="https://unpkg.com/babel-standalone@6/babel.min.js"></script>
```

<span style="color: #f7534f;font-weight:600">react</span> 包含 react 所必须的核心代码 

<span style="color: #f7534f;font-weight:600">react-dom </span>react 渲染在不同平台所需要的核心代码 

<span style="color: #f7534f;font-weight:600">babel </span>将 jsx 转换成 react 代码的工具

- 在web端，将 jsx 终渲染成真实的DOM
- 在native端，将 jsx 终渲染成原生的控件

:ghost: 使用 React.createElement 来编写源代码，过程繁琐和且可读性差；

:ghost: 可以选择直接编写 jsx，后续让 babel 将其转换成 React.createElement

:whale: 对于跨域脚本（如cdn引入的脚本），默认情况下，浏览器不会输出其内部的错误信息 ，添加 <span style="color: #a50">crossorigin</span> 属性后可以进行输出



#### 初体验

```react
<!-- 不要忘记引入依赖的库 -->
<div id="app">将会被替代的内容</div>

<script type="text/babel">
  let message = "Hello World";
  ReactDOM.render(<h2>{message}</h2>, document.getElementById("app"))
</script>
```

<span style="color: #f7534f;font-weight:600">ReactDOM.render</span> 至少接收两个参数：渲染内容，挂载元素；

:ghost: 这里的渲染内容使用了 jsx 的写法，需要给 script 标签加上相应属性以<span style="color: #ff0000">支持</span>。



#### 实例-更改数据（缺陷）

```react
<script type="text/babel">
  let message = "Hello World";

  function btnClick() {
    message = "Hello React";
  }

  ReactDOM.render(
    <div>
      <h2>{message}</h2>
      <button onClick={btnClick}>改变文本</button>
    </div>,
    document.getElementById("app")
  );
</script>
```

:ghost: jsx语法：需要一个根组件包裹。

:octopus: 这里的写法似乎可行，但由于在更改数据后，没有进行重新渲染，所以视图是没有变化的。



#### 实例-更改数据

```react
<script type="text/babel">
  let message = "Hello World";

  function btnClick() {
    message = "Hello React";
    console.log(message);
    render();
  }

  function render() {
    ReactDOM.render(
      <div>
        <h2>{message}</h2>
        <button onClick={btnClick}>改变文本</button>
      </div>,
      document.getElementById("app")
    );
  }

  render();
</script>
```

:ghost: 在修改数据后，手动进行了重新渲染，故可行。



#### 组件化实现（缺陷）

```react
<script type="text/babel">
  // 封装App组件
  class App extends React.Component {
    constructor() {
      super();
      this.message = "Hello World";
    }

    render() {
      return (
        <div>
          <h2>{this.message}</h2>
          <button onClick={this.btnClick}>改变文本</button>
        </div>
      )
    }

    btnClick() {
      this.message = "Hello React";
    }
  }

  // 渲染组件
  ReactDOM.render(<App/>, document.getElementById("app"));
</script>
```

:whale: render 返回值下的 `()`，表示内容为一个整体，届时允许<span style="color: #a50">换行</span>编写代码；

:ghost: 组件必须实现 render 函数；

:ghost: 渲染函数中的 jsx，需要通过 this 获取到<span style="color: #ff0000">类</span>内部的属性或方法；

:ghost: 模板内的方法被调用时，真正的执行环境<span style="color: #ff0000">不是在类的内部</span>，届时方法内的 this 值是 undefined；

:ghost: 改变普通的属性，无法触发重新渲染。



#### 组件化实现

```react
<script type="text/babel">
  class App extends React.Component {
    constructor() {
      super();
      this.state = {
        message: "Hello World"
      }
    }

    render() {
      return (
        <div>
          <h2>{this.state.message}</h2>
          <button onClick={this.btnClick.bind(this)}>改变文本</button>
        </div>
      )
    }

    btnClick() {
      this.setState({
        message: "Hello React"
      })
    }
  }

  ReactDOM.render(<App/>, document.getElementById("app"));
</script>
```

:ghost: 可以将模板内的方法的 this 指向改为类本身。

:ghost: 需要在渲染函数中添加 <span style="color: #ff0000">state</span> 下的属性，并通过 <span style="color: #ff0000">setState</span> 修改状态才能够触发监听，以进行重新渲染。

:ghost: 在类中可以获取到 <span style="color: #ff0000">setState</span>，它是从父类中继承下来的。



### JSX核心语法一

#### 案例-列表

```react
<script type="text/babel">
  class App extends React.Component {
    constructor() {
      super();

      this.state = {
        message: "Hello World",
        movies: ["大话西游", "盗梦空间", "星际穿越", "流浪地球"]
      }
    }

    render() {
      const liArray = [];
      for (let movie of this.state.movies) {
        liArray.push(<li>{movie}</li>);
      }

      return (
        <div>
          <h2>电影列表1</h2>
          <ul>
            {liArray}
          </ul>
        </div>
      )
    }
  }

  ReactDOM.render(<App/>, document.getElementById("app"));
</script>
```

:ghost: 可以向 jsx 的大括号里放上一个<span style="color: #ff0000">数组</span>，它的元素是标签，最终生成多个标签。

#### 案例-列表（优化）

```react
render() {
  return (
    <div>
      <h2>电影列表2</h2>
      <ul>
        {
          this.state.movies.map((item) => {
            return <li>{item}</li>
          })
        }
      </ul>
    </div>
  )
}
```

:whale: 使用 ES6 的 map 方法，更简洁。



#### jsx-语法

```react
<script type="text/babel">
  const element = <h2>Hello World</h2>;
  ReactDOM.render(element, document.getElementById("app"));
</script>
```

:ghost: 元素本身是不允许赋值给变量的，之所以可以这样写，是因为它就是 jsx 的语法。	



#### jsx-注释

```react
render() {
  return (
    <div>
      {/* 我是一段注释 */}
      <h2>Hello World</h2>
    </div>
  )
}
```

:octopus: jsx 中不能使用 `<!-- -->`、`//` 这样的方式注释。



#### jsx-嵌入数据限制

这里嵌入的数据，指的是放入 jsx 的 `{}` 的内容。

```react
class App extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      demo: "why"
    }
  }

  render() {
    return (
      <div>
        <h2>{this.state.demo}</h2>
      </div>
    )
  }
}
```

| 类型         | 现象                            |
| ------------ | ------------------------------- |
| String       | 正常显示                        |
| Number       | 正常显示                        |
| Array        | 正常显示                        |
| Object       | 报错（对象不能作为 jsx 的子类） |
| null         | 不显示(忽略)                    |
| undefined    | 不显示(忽略)                    |
| true / false | 不显示(忽略)                    |
| NaN          | 报错（不能作为 jsx 的子类）     |

:ghost: 对于不显示的几种类型，可以将其转化为字符串后进行显示

```react
{this.state.demo.toString()}

{this.state.demo + ''}

{String(this.state.demo)}
```



#### jsx-嵌入表达式

```react
class App extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      firstname: "kobe",
      lastname: "bryant",
      isLogin: false
    }
  }

  render() {
    const { firstname, lastname, isLogin } = this.state;

    return (
      <div>
        {/*1.运算符表达式*/}
        <h2>{ firstname + " " + lastname }</h2>
        <h2>{20 * 50}</h2>

        {/*2.三元表达式*/}
        <h2>{ isLogin ? "欢迎回来~": "请先登录~" }</h2>

        {/*3.进行函数调用*/}
        <h2>{this.getFullName()}</h2>
      </div>
    )
  }

  getFullName() {
    return this.state.firstname + " " + this.state.lastname;
  }
}
```

:ghost: 这里是<span style="color: #ff0000">函数调用</span>而非绑定事件，直接就能获取到当前类。

:whale: 类似的，还有之前的 map 的语法。

:whale: 可以在将状态添加到 jsx 前，先解构出来。



#### jsx-绑定属性

```react
function demo(imgUrl) {
  return imgUrl + ''
}

class App extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      title: "wang",
      imgUrl: "http://xxx.jpg"
    }
  }

  render() {
    const { title, imgUrl } = this.state;
    return (
      <div>
        <h2 title="wang">标题一</h2>
        <h2 title={title}>标题二</h2>
        <img src={demo(imgUrl)} alt=""/>
      </div>
    )
  }
}
```

:ghost: 可以像普通 html 的方式一样，给 jsx 中的标签添加属性；

:ghost: 也可以通过括号语法动态绑定值；

:turtle: 括号内使用表达式也被允许。



#### jsx-绑定类/样式

```react
class App extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      link: "http://www.baidu.com",
      active: true
    }
  }

  render() {
    const { link, active } = this.state;
    return (
      <div>
        {/* 绑定class */}
        <div className="box title">元素</div>
        <div className={"box title " + (active ? "active": "")}>元素</div>

        {/* 绑定style */}
        <div style={{color: "red", fontSize: "50px"}}>元素</div>
      </div>
    )
  }
}
```

:whale: 为了与 jsx 中的某些关键字作区别，部分 html 的属性要起<span style="color: #ff0000">别名</span>；

:turtle: <span style="color: #ff0000">添加动态类</span>，只能通过 js 的方式进行添加；

:ghost: 添加内联样式时，通过<span style="color: #ff0000">对象</span>形式添加，这里看上去就是双括号；

:whale: 样式中的一些短横线属性名，需要转为<span style="color: #ff0000">小驼峰</span>；

:whale: 内联样式的属性值要加上引号，否则会被理解为变量。



#### jsx-绑定事件/this

本质都是改变 this 的指向，提供了三种方式。

**方式一**

```react
// 通过 bind 绑定 this (显示绑定)
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = { message: "你好啊" }

    this.btnClick = this.btnClick.bind(this);
  }

  render() {
    return (
      <div>
        <button onClick={this.btnClick}>按钮</button>
      </div>
    )
  }

  btnClick() {
    console.log(this.state.message);
  }
}
```

```react
// 通过 bind 绑定 this (显示绑定)
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = { message: "你好啊" }
  }

  render() {
    return (
      <div>
        <button onClick={this.btnClick.bind(this)}>按钮</button>
      </div>
    )
  }

  btnClick() {
    console.log(this.state.message);
  }
}
```

:whale: 不同于在常规 HTML 中定义事件，jsx 中需要写成小驼峰的形式。

**方式二**

```react
// 定义为箭头函数
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = { message: "你好啊" }
  }

  render() {
    return (
      <div>
        <button onClick={this.btnClick}>按钮</button>
      </div>
    )
  }

  btnClick = () => {
    console.log(this.state.message);
  }
}
```

:ghost: 箭头函数内的 this 指向类

**方式三**

```react
// 在表达式内传入箭头函数
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = { message: "你好啊" }
  }

  render() {
    return (
      <div>
        <button onClick={() => { this.btnClick() }}>按钮</button>
      </div>
    )
  }

  btnClick() {
    console.log(this.state.message);
  }
}
```

:ghost: 箭头函数内的 this 指向类。



#### jsx-绑定事件-传参

```react
class App extends React.Component {
  constructor(props) {
    super(props);

    this.btnClick = this.btnClick.bind(this);
  }

  render() {
    return (
      <div>
        <button onClick={this.btnClick}>按钮</button>
        
        <button onClick={ e => { this.btnClick2(666, e) }}>按钮</button>
      </div>
    )
  }

  btnClick(event) {
    console.log(event);
  }

  btnClick2(num, event) {
    console.log(num, event);
  }
}
```



#### jsx-条件渲染

- 通过 if 判断，适合逻辑代码较多的情况
- 三目运算符，较为清晰
- 逻辑与，适合于仅渲染/不渲染的情况

```react
// 通过 if 判断，适合逻辑代码较多的情况
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = { isLogin: true, isRegister: true }
  }

  render() {
    const { isLogin, isRegister } = this.state;
    let title = null;
    let btnText = null;

    if (isLogin) {
      title = <h2>标题一</h2>
    } else {
      title = <h2>标题二</h2>
    }
      
    if (isRegister) {
      btnText = "登录";
    } else {
      btnText = "注册";
    }

    return (
      <div>
        {title}
        <button>{btnText}</button>
      </div>
    )
  }
    
}
```

:european_castle: 通过 jsx 的语法，可以直接将“标签”赋值给变量。

```react
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = { isLogin: true, isRegister: true }
  }

  render() {
    const { isLogin, isRegister } = this.state;

    return (
      <div>
        <button>{isLogin ? "退出" : "登录"}</button>

        { isRegister && <h2>你好啊, 已注册</h2> }
      </div>
    )
  }
}
```

:turtle: 巧用逻辑与的操作，可以动态决定是否渲染标签。



#### jsx-条件展示

```react
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = { isLogin: true }
  }

  render() {
    const { isLogin } = this.state;
    const titleDisplayValue = isLogin ? "block": "none";
    return (
      <div>
        <h2 style={{display: titleDisplayValue}}>你好啊, 已登陆</h2>
      </div>
    )
  }
}
```

:ghost: 通过控制样式属性 display 来实现条件展示；

:ghost: 变量通过 const 声明也没问题，因为每次调用 setState，都会在新的作用域重新执行 render 函数。



#### jsx-列表渲染

```react
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      numbers: [110, 123, 50, 32, 55, 10, 8, 333]
    }
  }

  render() {
    const { numbers } = this.state;  
    return (
      <div>
        <h2>数字列表</h2>
        <ul>
          { numbers.map(item => <li>{item}</li>) }
        </ul>

        <h2>数字列表(过滤)</h2>
        <ul>
          { numbers.filter(item => item >= 50).map(item => <li>{item}</li>) }
        </ul>

        <h2>数字列表(截取)</h2>
        <ul>
          { numbers.slice(0, 4).map(item => <li>{item}</li>) }
        </ul>
      </div>
    )
  }
}
```

:whale: <span style="color: #a50">map</span> 在列表渲染中发挥着很重要的作用。



### jsx的渲染

#### 本质是语法糖

```elm
jsx -> babel -> React.createElement()
```

```elm
React.createElement(component, props, ...children)
```

:ghost: 使用 jsx 时，它会通过 babel 转化为 React.createElement() 的形式；



```react
<script src="https://unpkg.com/react@16/umd/react.development.js" crossorigin></script>
<script src="https://unpkg.com/react-dom@16/umd/react-dom.development.js"></script>
<!-- 使用jsx时需要额外引入 -->
<script src="https://unpkg.com/babel-standalone@6/babel.min.js"></script>

<script type="text/babel">
  /* 渲染 message1 和 message2 是等价的 */
  const message1 = <h2>Hello React</h2>;
  const message2 = React.createElement("h2", null, "Hello React");

  ReactDOM.render(message1, document.getElementById("app"));

</script>
```

:whale: 后者不需要依赖 babel，所以仅使用它时，不需要在标签上加额外的属性，也不需要引入 babel；

:whale: 可以在 babel 的官网中快速查看转换的过程：https://babeljs.io/repl/#?presets=react



#### 映射为真实DOM

```
jsx -> createElement函数 -> ReactElement(对象树) -> ReactDOM.render -> 真实DOM
```

| 方法/步骤              | 结果                          | 说明                       |
| ---------------------- | ----------------------------- | -------------------------- |
| React.createElement    | 创建出 ReactElement 对象      | 本质是 js 对象             |
| 通过 ReactElement 对象 | 组成了虚拟 DOM                | VNode                      |
| ReactDOM.render        | 最终将虚拟 DOM 转换为真实 DOM | 在 native 端转换为原生控件 |



#### 虚拟DOM的优势

 为什么要采用虚拟DOM，而不是直接修改真实的DOM呢？ 

很难跟踪状态发生的改变

- 原有的开发模式，很难跟踪到状态发生的改变，不方便针对应用程序进行调试； 

- 现在可以通过状态追踪变化，配合调试工具跟踪状态变化。

操作真实DOM性能较低

- 传统的开发模式会进行频繁的DOM操作；

- 涉及到 js 与 渲染线程间的通信；

- 会引起浏览器的回流和重绘。





### 阶段案例-加购书籍

#### 代码结构

```react
<script src="./format-utils.js"></script>

<script type="text/babel">
  class App extends React.Component {
    constructor(props) {
      super(props);

      this.state = {
        books: [
          {
            id: 1,
            name: '《算法导论》',
            date: '2006-9',
            price: 85.00,
            count: 2
          }, {...}
        ]
      }
    }

    render() {/* */}
  }

  ReactDOM.render(<App/>, document.getElementById("app"));
</script>
```

:ghost: 引入其它脚本后，可以直接使用其中的变量。

<span style="backGround: #efe0b9">./format-utils.js</span>

```javascript
function formatPrice(price) {
  return "¥" + price.toFixed(2);
}
```



#### 显示内容、总价

:trident: 以下为组件 App 类中的内容

```react
render() {
  return (
    <div>
      <table>
        <thead>
          <tr>
            <th></th>
            <th>书籍名称</th>
            <th>出版日期</th>
            <th>价格</th>
            <th>购买数量</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          {
            this.state.books.map((item, index) => {
              return (
                <tr>
                  <td>{index+1}</td>
                  <td>{item.name}</td>
                  <td>{item.date}</td>
                  <td>{formatPrice(item.price)}</td>
                  <td>
                    <button>-</button>
                    <span className="count">{item.count}</span>
                    <button>+</button>
                  </td>
                  <td><button>移除</button></td>
                </tr>
              )
            })
          }
        </tbody>
      </table>
      <h2>总价格: {this.getTotalPrice()}</h2>
    </div>
  )
}

getTotalPrice() {
  const totalPrice = this.state.books.reduce((preValue, item) => {
    return preValue + item.count * item.price;
  }, 0);

  return formatPrice(totalPrice);
}
```



#### 移除书籍、增减数量

:trident: 以下为组件 App 类中的内容

```react
renderBooks() {
  return  (
    <div>
      <table>
        <thead>
          <tr>
            <th></th>
            <th>书籍名称</th>
            <th>出版日期</th>
            <th>价格</th>
            <th>购买数量</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          {
            this.state.books.map((item, index) => {
              return (
                <tr>
                  <td>{index+1}</td>
                  <td>{item.name}</td>
                  <td>{item.date}</td>
                  <td>{formatPrice(item.price)}</td>
                  <td>
                    <button disabled={item.count <= 1} onClick={e => this.changeBookCount(index, -1)}>-</button>
                    <span className="count">{item.count}</span>
                    <button onClick={e => this.changeBookCount(index, 1)}>+</button>
                  </td>
                  <td><button onClick={e => this.removeBook(index)}>移除</button></td>
                </tr>
              )
            })
          }
        </tbody>
      </table>
      <h2>总价格: {this.getTotalPrice()}</h2>
    </div>
  )
}

renderEmptyTip() {
  return <h2>购物车为空~</h2>
}

render() {
  return this.state.books.length ? this.renderBooks(): this.renderEmptyTip();
}

changeBookCount(index, count) {
  // 实际上，老师给出的这个例子，也会改变对象本身的内容呀。。
  const newBooks = [...this.state.books];
  newBooks[index].count += count;
  this.setState({
    books: newBooks
  })
}

removeBook(index) {
  // filter 不会改变数组本身
  this.setState({
    books: this.state.books.filter((item, indey) => index != indey)
  })
}

getTotalPrice() {
  const totalPrice = this.state.books.reduce((preValue, item) => {
    return preValue + item.count * item.price;
  }, 0);

  return formatPrice(totalPrice);
}
```

:ghost: 对于组件内的状态，通过 splice、push 这些方法操作无法做到响应，<span style="color: #ff0000">必须调用 setState 触发重新渲染</span>；

:hammer_and_wrench: React 的设计原则，不要直接修改状态，哪怕是将其修改后再赋值给自身；

:european_castle: 在无条件时，需要提供备用的渲染内容，这里将它们抽离到不同的方法中，条件显示；

:hammer_and_wrench: 将渲染相关的方法放在 render 上面，功能相关方法放在 render 下面。

