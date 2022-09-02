#### 通过 watchEffect 将最新状态保存到对象上

```javascript
const obj = ref({})
const time = ref(0)
const number = ref(100)
setInterval(() => {
  time.value++
}, 1000)
setInterval(() => {
  number.value++
}, 2500)

watchEffect(() => {
  Object.assign(obj.value, {
    count: time.value,
    num: number.value
  });
});
```

