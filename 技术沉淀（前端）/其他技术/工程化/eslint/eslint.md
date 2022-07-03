#### [忽视](http://events.jianshu.io/p/e7a83e4e56f3)下一行的所有检查

```javascript
watch: {
  // eslint-disable-next-line
  'a.b': function () {
    this.loadList();
  },
},
```

