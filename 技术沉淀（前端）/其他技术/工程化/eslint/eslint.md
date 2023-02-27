#### 忽略一段代码检查

```javascript
/* eslint-disable */
some code
some code
/* eslint-enable */
```

#### [忽略](http://events.jianshu.io/p/e7a83e4e56f3)下一行校验

```javascript
// eslint-disable-next-line
some code
```

**示例**

```javascript
watch: {
  // eslint-disable-next-line
  'a.b': function () {
    this.loadList();
  },
},
```

#### 忽略当前行校验

```javascript
some code // eslint-disable-line
```

