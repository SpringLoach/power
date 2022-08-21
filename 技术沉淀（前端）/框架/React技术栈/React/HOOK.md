## Hook简介

> Hook 将组件中相互关联的部分拆分成更小的函数

```react
import React, { useState } from 'react';

function Example() {
  // 声明一个新的叫做 “count” 的 state 变量
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>
        Click me
      </button>
    </div>
  );
}
```

在这里，`useState` 就是一个 *Hook* 。通过在函数组件里调用它来给组件添加一些内部 state。React 会在重复渲染时保留这个 state。`useState` 会返回一对值：**当前**状态和一个让你更新它的函数。

它类似 class 组件的 this.setState，但是它不会把新的 state 和旧的 state 进行合并。

useState 唯一的参数就是初始 state。在上面的例子中，我们的计数器是从零开始的，所以初始 state 就是 0。



> 也可以在一个组件中多次使用 State Hook

```react
function ExampleWithManyStates() {
  // 声明多个 state 变量！
  const [age, setAge] = useState(42);
  const [fruit, setFruit] = useState('banana');
  const [todos, setTodos] = useState([{ text: 'Learn Hooks' }]);
  // ...
}
```

useState 可以接收数字、字符串或对象等，这不同于 class 。



### 理解

```react
import React, { useState } from 'react'; // ①

function Example() {
  // 声明一个新的叫做 “count” 的 state 变量
  const [count, setCount] = useState(0); // ②

  return (
    <div>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}> // ③
        Click me
      </button>
    </div>
  );
}
```

① 引入 React 中的 `useState` Hook。它让我们在函数组件中存储内部 state

② 调用 `useState` Hook 声明了一个新的 state 变量，通过传 `0` 作为 `useState` 唯一的参数来将其初始化为 `0`。第二个返回的值本身就是一个函数。它让我们可以更新 `count` 的值

③ 触发后，传递一个新的值给 `setCount`。React 会重新渲染 `Example` 组件，并把最新的 `count` 传给它



### State Hook

#### 读取state

**class**

```react
<p>You clicked {this.state.count} times</p>
```

**函数**

```react
<p>You clicked {count} times</p>
```

在函数中，我们可以直接用 `count`



#### 更新 State

**class**

```react
<button onClick={() => this.setState({ count: this.state.count + 1 })}>
  Click me
</button>
```

**函数**

```react
<button onClick={() => setCount(count + 1)}>
  Click me
</button>
```

在函数中，我们已经有了 `setCount` 和 `count` 变量，所以我们不需要 `this`



### Effect Hook

```react
import React, { useState, useEffect } from 'react';

function Example() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    document.title = `You clicked ${count} times`;
  });

  return (
    <div>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>
        Click me
      </button>
    </div>
  );
}
```

默认情况下，它在第一次渲染之后*和*每次更新之后都会执行。



#### 消除副作用

```react
useEffect(() => {
  function handleStatusChange(status) {
    setIsOnline(status.isOnline);
  }

  ChatAPI.subscribeToFriendStatus(props.friend.id, handleStatusChange);
  return () => {
    ChatAPI.unsubscribeFromFriendStatus(props.friend.id, handleStatusChange);
  };
});
```

每个 effect 都可以返回一个清除函数，React 会在组件卸载的时候执行清除操作。



### Hook规则

只有 Hook 的调用顺序在多次渲染之间保持一致，React 才能保证正确地将内部 state 和对应的 Hook 进行关联。



#### 只在最顶层使用 Hook

**不要在循环，条件或嵌套函数中调用 Hook**，会导致 bug 的产生。

tip：如果我们想要有条件地执行一个 effect，可以将判断放到 Hook 的*内部*。

#### 只在 React 函数中调用 Hook

**不要在普通的 JavaScript 函数中调用 Hook**，遵循此规则，确保组件的状态逻辑在代码中清晰可见。





### 自定义Hook

通过自定义 Hook，可以将组件逻辑提取到可重用的函数中

#### 定义

```react
import { useState, useEffect } from 'react';

function useFriendStatus(friendID) {
  const [isOnline, setIsOnline] = useState(null);

  useEffect(() => {
    function handleStatusChange(status) {
      setIsOnline(status.isOnline);
    }

    ChatAPI.subscribeToFriendStatus(friendID, handleStatusChange);
    return () => {
      ChatAPI.unsubscribeFromFriendStatus(friendID, handleStatusChange);
    };
  });

  return isOnline;
}
```

请确保只在自定义 Hook 的顶层无条件地调用其他 Hook。
它的名字应该始终以 use 开头，这样可以一眼看出其符合 Hook 的规则。
此处 useFriendStatus 的 Hook 目的是订阅某个好友的在线状态。这就是我们需要将 friendID 作为参数，并返回这位好友的在线状态的原因。

// 在两个组件中使用相同的 Hook 不会共享 state 



#### 使用

我们将使用聊天程序中的另一个组件来说明这一点。这是一个聊天消息接收者的选择器，它会显示当前选定的好友是否在线:

```react
const friendList = [
  { id: 1, name: 'Phoebe' },
  { id: 2, name: 'Rachel' },
  { id: 3, name: 'Ross' },
];

function ChatRecipientPicker() {
  const [recipientID, setRecipientID] = useState(1);
  const isRecipientOnline = useFriendStatus(recipientID);

  return (
    <>
      <Circle color={isRecipientOnline ? 'green' : 'red'} />
      <select
        value={recipientID}
        onChange={e => setRecipientID(Number(e.target.value))}
      >
        {friendList.map(friend => (
          <option key={friend.id} value={friend.id}>
            {friend.name}
          </option>
        ))}
      </select>
    </>
  );
}
```

由于 `useState` 为我们提供了 `recipientID` 状态变量的最新值，因此我们可以将它作为参数传递给自定义的 `useFriendStatus` Hook



### 基础Hook

#### `useState`

```react
const [state, setState] = useState(initialState);
```

如果新的 state 需要通过使用先前的 state 计算得出，那么可以将函数传递给 setState。
该函数将接收先前的 state，并返回一个更新后的值。下面的计数器组件示例展示了 setState 的两种用法：

```react
function Counter({initialCount}) {
  const [count, setCount] = useState(initialCount);
  return (
    <>
      Count: {count}
      <button onClick={() => setCount(initialCount)}>Reset</button>
      <button onClick={() => setCount(prevCount => prevCount - 1)}>-</button>
      <button onClick={() => setCount(prevCount => prevCount + 1)}>+</button>
    </>
  );
}
```



与 class 组件中的 `setState` 方法不同，`useState` 不会自动合并更新对象。你可以用函数式的 `setState` 结合展开运算符来达到合并更新对象的效果。

```react
setState(prevState => {
  // 也可以使用 Object.assign
  return {...prevState, ...updatedValues};
});
```

这就类似于 Vue 的触发更新



##### 惰性初始 state

initialState 参数只会在组件的初始渲染中起作用，后续渲染时会被忽略。如果初始 state 需要通过复杂计算获得，则可以传入一个函数，在函数中计算并返回初始的 state，此函数只在初始渲染时被调用：

```
const [state, setState] = useState(() => {
  const initialState = someExpensiveComputation(props);
  return initialState;
});
```

