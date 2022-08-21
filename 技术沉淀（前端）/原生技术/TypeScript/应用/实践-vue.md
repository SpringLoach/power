### 给对象的动态属性赋值

```javascript
const posterForm = ref({
  avatorUrl: '',
  posterUrl: '',
  other: 123
})

function change(type) {
  posterForm.value[type as 'avatorUrl' | 'posterUrl'] = 'demo'
}
```

>  可以添加定义的时候存在的属性来进行类型收缩。



### 引用表单组件

> 引用 ant-design-vue 的表单组件，并使用它的重置方法。

初始为 null

```javascript
const formRef = ref(null);

function closeDrawer() {
  formRef.value!.resetFields() // 会报错 Property 'resetFields' does not exist on type 'never'
}
```

初始为空/any

```javascript
const formRef = ref();

// 关闭抽屉
function closeDrawer() {
  formRef.value!.resetFields() // 不会报错
}
```

提供对应类型

```javascript
import type { FormInstance } from 'ant-design-vue';

const formRef = ref<FormInstance>();

// 关闭抽屉
function closeDrawer() {
  formRef.value!.resetFields() // 会有提示
}
```











