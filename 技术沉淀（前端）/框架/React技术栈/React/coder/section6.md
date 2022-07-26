## 内置Hook

| 特性           | 说明                                          |
| -------------- | --------------------------------------------- |
| 更方便         | 不像 class 组件，需要处理很多 this 相关的操作 |
| 状态           | 能够让函数时组件拥有内部的状态                |
|                | 生命周期                                      |
| 函数最外层调用 | 不要在循环、条件判断或者子函数中调用          |
| 只用于函数组件 | 只能在 React 的函数组件中调用 Hook            |



###  useState

```react
import React, {useState} from 'react';

export default function CounterHook() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <h2>当前计数: {count}</h2>
      <button onClick={e => setCount(count + 1)}>+1</button>
      <button onClick={e => setCount(count - 1)}>-1</button>
    </div>
  )
}
```

<span style="color: #f7534f;font-weight:600">参数</span> 状态的初始值，不设置则为 undefined；

<span style="color: #f7534f;font-weight:600">返回值</span> 数组，首个元素为状态，第二个元素为改变状态的方法；

:ghost: 当状态改变时，会重新调用函数，获取最新的状态，并<span style="color: #ff0000">重新渲染</span>组件。



#### 更多说明

| 特点     | 说明                                                         |
| -------- | ------------------------------------------------------------ |
| 参数     | useState 也可以接收函数类型的参数，会将函数返回值作为状态的初始值 |
| 改变状态 | 改变状态的方法，也可以接收函数作为参数，该函数的默认参数是上次的状态 |
| 改变状态 | 多次调用 setState，接收值，操作会被合并                      |
| 改变状态 | 多次调用 setState，接收函数类型，会将上次结果作为下次参数    |



#### 复杂状态的修改

```react
import React, { useState } from 'react'

export default function ComplexHookState() {

  const [count, setCount] = useState(0);
  const [friends, setFrineds] = useState(["kobe", "lilei"]);
  const [students, setStudents] = useState([
    { id: 110, name: "why", age: 18 },
    { id: 111, name: "kobe", age: 30 },
    { id: 112, name: "lilei", age: 25 },
  ])

  // 错误示例，将无法触发更新
  function addFriend() {
    friends.push("hmm");
    setFrineds(friends);
  }

  function incrementAgeWithIndex(index) {
    const newStudents = [...students];
    newStudents[index].age += 1;
    setStudents(newStudents);
  }

  return (
    <div>
      <div>{count}:</div>
      <div>{friends.length}</div>
      {/* 正确的修改 */}
      <button onClick={e => setFrineds([...friends, "tom"])}>添加朋友</button>
      {/* 错误的修改 */}
      <button onClick={addFriend}>添加朋友</button>

      <div>
        {
          students.map((item, index) => {
            return <div onClick={e => incrementAgeWithIndex(index)}>age+1</div>
          })
        }
      </div>
    </div>
  )
}
```

:octopus: 改变状态且接收值，而值与上次的状态相等时，<span style="color: #ff0000">不会引起重新渲染</span>，包括引用值。



#### 修改状态的合并

```react
const [count, setCount] = useState(() => 10);

// 首次调用结果为20
function handleBtnClick() {
  setCount(count + 10);
  setCount(count + 10);
  setCount(count + 10);
  setCount(count + 10);
}
```

```react
const [count, setCount] = useState(() => 10);

// 首次调用结果为 50
function handleBtnClick() {
  setCount((prevCount) => prevCount + 10);
  setCount((prevCount) => prevCount + 10);
  setCount((prevCount) => prevCount + 10);
  setCount((prevCount) => prevCount + 10);
} 
```



###  useEffect

可以完成一些类似于 class 组件中生命周期的功能



#### 案例-根据状态修改文档标题

```react
import React, { useState, useEffect } from 'react'

export default function HookCounterChangeTitle() {
  const [counter, setCounter] = useState(0);

  useEffect(() => {
    document.title = counter;
  })

  return (
    <div>
      <h2>当前计数: {counter}</h2>
      <button onClick={e => setCounter(counter + 1)}>+1</button>
    </div>
  )
}
```

:ghost: useEffect 接收函数，该函数的调用时机为当前组件挂载/更新后；

:ghost: 相当于在 class 组件的 <span style="color: #a50">componentDidmount</span> 和 <span style="color: #a50">componentDidUpdate</span> 执行逻辑。



#### 案例-订阅/取消订阅

```react
import React, { useEffect, useState } from 'react'

export default function EffectHookCancelDemo() {

  const [count, setCount] = useState(0);

  useEffect(() => {
    console.log("订阅事件");

    return () => {
      console.log("取消订阅事件")
    }
  }, []);

  return (
    <div>
      <h2>EffectHookCancelDemo</h2>
      <h2>{count}</h2>
      <button onClick={e => setCount(count + 1)}>+1</button>
    </div>
  )
}
```

:ghost: useEffect 本身返回一个函数，默认情况下，<span style="color: #ff0000">组件销毁/每次更新前</span>都会执行该函数；

:ghost: useEffect 可以接收第二个参数， `[]` 来解决组件更新前后也会执行订阅/取消订阅的问题；

:ghost: 相当于在 class 组件的 <span style="color: #a50">componentDidmount</span> 执行函数；在 <span style="color: #a50">componentWillUnmount</span> 执行返回值。



#### 案例-多次调用处理不同逻辑

```react
import React, { useState, useEffect } from 'react'

export default function MultiEffectHookDemo() {
  const [count, setCount] = useState(0);
  const [other, setOther] = useState(6);

  useEffect(() => {
    console.log("修改DOM", count);
  }, [count]);

  useEffect(() => {
    console.log("订阅事件");
  }, []);

  useEffect(() => {
    console.log("网络请求");
  }, []);

  return (
    <div>
      <button onClick={e => setCount(count + 1)}>{count}</button>
      <button onClick={e => setOther(other + 1)}>{other}</button>
    </div>
  )
}
```

:turtle: 修改状态 other，不会触发这里任何一个 useEffect 的回调。



#### 更多说明

| 特点     | 说明                                                         |
| -------- | ------------------------------------------------------------ |
| 多次使用 | 使用多个useEffect ，能将不同的逻辑拆开（如操作DOM、订阅事件、网络请求） |
| 多次使用 | 将按定义的顺序进行调用                                       |
| 性能优化 | 可以接收数组作为第二参，数组元素为依赖的变量；仅变量改变时，才会执行回调 |



### useContext  

| 特性 | 说明                                                         |
| ---- | ------------------------------------------------------------ |
| 传递 | 在传递多个 context 时，类组件 / 使用 useContext  的函数组件都需要嵌套 |
| 使用 | 在使用多个 context 时，类组件需要嵌套，函数组件则不需要      |

**祖先传递**

```react
import React, { useState, createContext } from 'react';
import ContextHookDemo from './useContext/useContext';

export const UserContext = createContext();
export const ThemeContext = createContext();

export default function App() {
  return (
    <div>
      <UserContext.Provider value={{name: "why", age: 18}}>
        <ThemeContext.Provider value={{fontSize: "30px", color: "red"}}>
          <ContextHookDemo/>
        </ThemeContext.Provider>
      </UserContext.Provider>
    </div>
  )
}
```

**后代获取**

```react
import React, { useContext } from 'react';

import { UserContext, ThemeContext } from "../App";

export default function ContextHookDemo(props) {
  const user = useContext(UserContext);
  const theme = useContext(ThemeContext);

  console.log(user, theme);

  return (
    <div>
      <h2>ContextHookDemo</h2>
    </div>
  )
}
```



### useRuduce 

| 特点     | 说明                                                       |
| -------- | ---------------------------------------------------------- |
| 使用情景 | 是 useState 的替代，特点是可以对不同的处理逻辑进行抽离     |
| 使用模式 | 与 Redux 相似，但功能完全不同，useRuduce 不能用于共享状态  |
| 参数     | reducer，初始状态值                                        |
| 返回值   | 状态，dispatch 方法                                        |
| 修改状态 | 如果状态是引用类型，在修改状态时，注意避免使用相同的引用值 |

```react
import React, { useState, useReducer } from 'react';

import reducer from './reducer';

export default function Home() {
  const [state, dispatch] = useReducer(reducer, {counter: 0});

  return (
    <div>
      <h2>Home当前计数: {state.counter}</h2>
      <button onClick={e => dispatch({type: "increment"})}>+1</button>
      <button onClick={e => dispatch({type: "decrement"})}>-1</button>
    </div>
  )
}
```

```react
export default function reducer(state, action) {
  switch(action.type) {
    case "increment":
      return {...state, counter: state.counter + 1};
    case "decrement":
      return {...state, counter: state.counter - 1};
    default:
      return state;
  }
}
```



### useCallback

| 特点     | 说明                                                         |
| -------- | ------------------------------------------------------------ |
| 缓存性   | 使用 useCallback  处理的函数，在组件更新时，默认不会重新定义 |
| 缓存性   | 但由于使用闭包，不更新会导致一直引用着最初的状态             |
| 缓存性   | 故需要向第二个参数 [] 中添加相应依赖，依赖改变时会更新       |
| 优化场景 | 仅使用 useCallback  处理函数是没有意义，没有性能优化的       |
| 优化场景 | 通常使用 useCallback 的目的是不希望子组件进行多次渲染，而不是为了函数进行缓存 |

该例子中，increment1 是普通的函数， increment2 是通过 useCallback 处理的函数。

```react
import React, {useState, useCallback, memo} from 'react';

const HYButton = memo((props) => {
  console.log("重新渲染子组件");
  return <button onClick={props.increment}>HYButton +1</button>
});

export default function CallbackHookDemo02() {
  const [count, setCount] = useState(0);
  const [show, setShow] = useState(true);

  const increment1 = () => {
    console.log("执行increment1函数");
    setCount(count + 1);
  }

  const increment2 = useCallback(() => {
    console.log("执行increment2函数");
    setCount(count + 1);
  }, [count]);

  return (
    <div>
      <h2>CallbackHookDemo01: {count}</h2>
      <HYButton title="btn1" increment={increment1}/>
      <HYButton title="btn2" increment={increment2}/>

      <button onClick={e => setShow(!show)}>更新父组件</button>
    </div>
  )
}
```

:octopus: 要配合子组件使用才有效果，这里如果只使用父组件，不会有任何优化效果；

:turtle: 配合 <span style="color: #a50">memo</span>，将经过 <span style="color: #a50">useCallback</span> 处理的函数传递给子组件，父组件更新时，子组件不会更新。



### useMemo

| 特性 | 说明                                         |
| ---- | -------------------------------------------- |
| 差异 | useCallback 仅能优化函数，返回值也会是函数； |
| 差异 | useMemo 可以作用于数字，对象，函数等类型     |

#### 案例-缓存计算结果

```react
import React, {useState, useMemo} from 'react';

function calcNumber(count) {
  console.log("重新执行");
  let total = 0;
  for (let i = 1; i <= count; i++) {
    total += i;
  }
  return total;
}

export default function MemoHookDemo01() {
  const [count, setCount] = useState(10);
  const [show, setShow] = useState(true);

  // const total = calcNumber(count); 像这样普通的调用方法，每次组件更新都会执行
  const total = useMemo(() => {
    return calcNumber(count);
  }, [count]);

  return (
    <div>
      <button onClick={e => setCount(count + 1)}>{total}</button>
      <button onClick={e => setShow(!show)}>更新</button>
    </div>
  )
}
```

:octopus: 这里的 total 值仅依赖于状态 count；但默认情况下，改变任何状态导致的组件更新，<span style="color: #ff0000">方法都会重新调用</span>；

:ghost: 可以通过 <span style="color: #a50">useMemo</span> 处理，表示仅当依赖的状态改变时，才会去重新调用方法。



#### 案例-保持子组件不更新

```react
import React, { useState, memo, useMemo } from 'react';

const HYInfo = memo((props) => {
  console.log("HYInfo重新渲染");
  return <h2>名字: {props.info.name} 年龄: {props.info.age}</h2>
});

export default function MemoHookDemo02() {
  const [show, setShow] = useState(true);

  // const info = { name: "why", age: 18 };  
  const info = useMemo(() => {
    return { name: "why", age: 18 };
  }, []);

  return (
    <div>
      <HYInfo info={info} />
      <button onClick={e => setShow(!show)}>更新</button>
    </div>
  )
}
```

由于 info 为局部变量，每次更新都会重新生成，故导致子组件仍会重新渲染；

:ghost: 通过 useMemo 将变量的结果保存，供父组件更新后使用，来实现子组件的无需更新。



### useRef

| 特性    | 说明                                                         |
| ------- | ------------------------------------------------------------ |
| 引用DOM | 包括元素 / 类组件，函数式组件由于没有实例不能被引用          |
| 保存值  | 除非通过实例的 current 属性修改，否则值在组件的整个周期不会改变 |



#### 案例-引用DOM

```react
import React, { useRef } from 'react';

class TestCpn extends React.Component {
  render() {
    return <h2>TestCpn</h2>
  }
}

export default function RefHookDemo01() {
  const titleRef = useRef();
  const inputRef = useRef();
  const testRef = useRef();

  function changeDOM() {
    titleRef.current.innerHTML = "Hello World";
    inputRef.current.focus();
    console.log(testRef.current);
  }

  return (
    <div>
      <h2 ref={titleRef}>RefHookDemo01</h2>
      <input ref={inputRef} type="text"/>
      <TestCpn ref={testRef}/>

      <button onClick={e => changeDOM()}>修改DOM</button>
    </div>
  )
}
```



#### 案例-保存更新前的状态

```react
import React, { useRef, useState, useEffect } from 'react'

export default function RefHookDemo02() {
  const [count, setCount] = useState(0);

  const numRef = useRef(count);

  useEffect(() => {
    numRef.current = count;
  }, [count])

  return (
    <div>
      {/* <h2>numRef中的值: {numRef.current}</h2>
      <h2>count中的值: {count}</h2> */}
      <h2>count上一次的值: {numRef.current}</h2>
      <h2>count这一次的值: {count}</h2>
      <button onClick={e => setCount(count + 10)}>+10</button>
    </div>
  )
}
```

:turtle: 除非主动改变，它保存的数据，（在整个组件的生命周期）会<span style="color: #ff0000">保持不变</span>；

:whale: 每次组件更新后会调用 useEffect 的回调，而 useRef 引用值的改变不会引起组件更新。



### useImperativeHandle

| 特点                     | 说明                                         |
| ------------------------ | -------------------------------------------- |
| 回顾 forwardRef          | 让父组件获取子组件元素的引用，可进行任何操作 |
| useImperativeHandle 作用 | 限制父组件能对引用元素做出的行为             |

#### 回顾-forwardRef的用法

```react
import React, { useRef, forwardRef } from 'react';

const HYInput = forwardRef((props, ref) => {
  return <input ref={ref} type="text"/>
})

export default function ForwardRefDemo() {
  const inputRef = useRef();

  return (
    <div>
      <HYInput ref={inputRef}/>
      <button onClick={e => inputRef.current.focus()}>聚焦</button>
    </div>
  )
}
```

:ghost: 通过 forwardRef 方法，可以让父组件获取到子组件标签的引用。

#### 案例-限制对引用dom的行为

```react
import React, { useRef, forwardRef, useImperativeHandle } from 'react';

const HYInput = forwardRef((props, ref) => {
  const inputRef = useRef();

  useImperativeHandle(ref, () => ({
    focus: () => {
      inputRef.current.focus();
    }
  }), [inputRef])

  return <input ref={inputRef} type="text"/>
})

export default function UseImperativeHandleHookDemo() {
  const inputRef = useRef();

  return (
    <div>
      <HYInput ref={inputRef}/>
      <button onClick={e => inputRef.current.focus()}>聚焦</button>
    </div>
  )
}
```

:ghost: useImperativeHandle 的首个参数需要传入 ref，与父组件传入的 ref 实例关联；

:ghost: useImperativeHandle 的第二个参数的返回值（obj），将暴露到父组件传入的 ref 实例的 current 属性上；

:ghost: 此时子组件需要新建一个引用，提供给 useImperativeHandle 内部操作 DOM；

:ghost: useImperativeHandle 接收的第三个参数表示相应依赖改变才触发更新。



### useLayoutEffect

| 特点            | 说明                         |
| --------------- | ---------------------------- |
| useEffect       | 在组件更新后执行             |
| useLayoutEffect | 在组件更新前执行，会阻塞渲染 |

```react
import React, { useState, useEffect, useLayoutEffect } from 'react'

export default function LayoutEffectCounterDemo() {
  const [count, setCount] = useState(10);

  useLayoutEffect(() => {
    if (count === 0) {
      setCount(Math.random() + 200)
    }
  }, [count]);

  return (
    <div>
      <h2>数字: {count}</h2>
      <button onClick={e => setCount(0)}>修改数字</button>
    </div>
  )
}
```

这里如果使用 useEffect，首次点击按钮会引起组件的两次重新渲染。



## 自定义Hook

本质上只是一种函数代码逻辑的抽取

| 特性         | 说明                                                         |
| ------------ | ------------------------------------------------------------ |
| 使用内置hook | 不能够在普通函数中使用 react 的内置 hook，会报错             |
| 使用内置hook | 将普通函数的名称，修改为 `use` 开头，这时它就成为了自定义hook，可以使用内置 hook |



### 案例-组件创建/销毁时打印

```react
import React, { useEffect } from 'react';

const Home = (props) => {
  useLoggingLife("Home");
  return <h2>Home</h2>
}

const Profile = (props) => {
  useLoggingLife("Profile");
  return <h2>Profile</h2>
}

export default function CustomLifeHookDemo01() {
  useLoggingLife("CustomLifeHookDemo01");
  return (
    <div>
      <h2>CustomLifeHookDemo01</h2>
      <Home/>
      <Profile/>
    </div>
  )
}

function useLoggingLife(name) {
  useEffect(() => {
    console.log(`${name}组件被创建出来了`);

    return () => {
      console.log(`${name}组件被销毁掉了`);
    }
  }, []);
}
```



### 案例-使用context共享

需要将多个关联的 context 实例，引入到组件中使用；比起使用高阶组件，用自定义 hook 要简介得多。

```react
- src 
  + hooks
    - info-hook.js
  + App.js
```

<span style="backGround: #efe0b9">src\App.js</span>

```react
import React, { useState, createContext } from 'react';

export const UserContext = createContext();
export const TokenContext = createContext();

export default function App() {
  return (
    <div>
      <UserContext.Provider value={{name: "why", age: 18}}>
        <TokenContext.Provider value="fdafdafafa">
          <CustomContextShareHook/>
        </TokenContext.Provider>
      </UserContext.Provider>
    </div>
  )
}
```

<span style="backGround: #efe0b9">src\hooks\info-hook.js</span>

```react
import { useContext } from "react";
import { UserContext, TokenContext } from "../App";

function useUserContext() {
  const user = useContext(UserContext);
  const token = useContext(TokenContext);

  return [user, token];
}

export default useUserContext;
```

<span style="backGround: #efe0b9">使用</span>

```react
import React, { useContext } from 'react';
import useUserContext from '../hooks/user-hook';

export default function CustomContextShareHook() {
  const [user, token] = useUserContext();
  console.log(user, token);

  return (
    <div>
      <h2>CustomContextShareHook</h2>
    </div>
  )
}
```



### 案例-获取滚动位置

<span style="backGround: #efe0b9">src\hooks\scroll-position-hook.js</span>

```react
import { useState, useEffect } from 'react';

function useScrollPosition() {
  const [scrollPosition, setScrollPosition] = useState(0);

  useEffect(() => {
    const handleScroll = () => {
      setScrollPosition(window.scrollY);
    }
    document.addEventListener("scroll", handleScroll);

    return () => {
      document.removeEventListener("scroll", handleScroll)
    }
  }, []);

  return scrollPosition;
}

export default useScrollPosition;
```

<span style="backGround: #efe0b9">使用</span>

```react
import React, { useEffect, useState } from 'react'
import useScrollPosition from '../hooks/scroll-position-hook'

export default function CustomScrollPositionHook() {
  const position = useScrollPosition();

  return (
    <div style={{padding: "1000px 0"}}>
      <h2 style={{position: "fixed", left: 0, top: 0}}>{position}</h2>
    </div>
  )
}
```



### 案例-localStorage存储

<span style="backGround: #efe0b9">src\hooks\local-store-hook.js</span>

```javascript
import {useState, useEffect} from 'react';

function useLocalStorage(key) {
  const [name, setName] = useState(() => {
    const name = JSON.parse(window.localStorage.getItem(key));
    return name;
  });

  useEffect(() => {
    window.localStorage.setItem(key, JSON.stringify(name));
  }, [name]);

  return [name, setName];
}

export default useLocalStorage;

```

<span style="backGround: #efe0b9">使用</span>

```react
import React, { useState, useEffect } from 'react';

import useLocalStorage from '../hooks/local-store-hook';

export default function CustomDataStoreHook() {
  const [name, setName] = useLocalStorage("name");

  return (
    <div>
      <h2>CustomDataStoreHook: {name}</h2>
      <button onClick={e => setName("kobe")}>设置name</button>
    </div>
  )
}
```

