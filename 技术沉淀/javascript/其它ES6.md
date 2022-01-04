### 返回连锁

`api.js`

```react
/* 1. 返回期约 2. 解决处理程序中返回值进行传递 */
getProfile(queryForm) {
  return getProfile(queryForm).then(r => r);
},
```

:ghost: 其实这里照样传递，用 `then` 没什么意义了，不省略便于理解吧。

`demo.vue`

```react
this.getProfile().then((r) => {
  console.log(r);
});
```

