## 对接

### 对象属性作参

`定义`

```react
/* 编辑个人信息 */
export function demoPost(data) {
  return axios({
    url: 'xxx',
    method: 'post',
    data,
  });
}
```

`使用`

```react
this.form = {
  name: 'xx',
  age: 2
}

/* 将本地 form 直接作为请求参数 */
this.demoPost(this.form);

/* 将本地 form 添加到对象中成为属性 */
form = this.form;
this.demoPost({form});
```



### get请求传递数组参数

> 能够将请求中的 `arr=1[]&arr=2[]` 转化为 `arr=1&arr=2`。

```javascript
/* 最底层请求封装 */
import axios from 'axios'
import qs from 'qs';

// 请求实例
const request = axios.create({...})

// 实例的请求拦截               
request.interceptors.request.use(config => {
  if (config.method === 'get') {
    config.paramsSerializer = function (params) {
      return qs.stringify(params, { arrayFormat: 'repeat' })
    }
  }
  return config
}, ...)
```



### 表单请求传递数组参数

`全局配置`

```javascript
import axios from 'axios'
import qs from 'qs'

// 请求拦截中添加逻辑
if (config.method === 'post') {
  if (config.isFormData) {
    // 表单提交
    config.headers['Content-Type'] = 'application/x-www-form-urlencoded;charset-utf-8'
    if (config.isRewrite) {
      config.data = qs.stringify(config.data, {indices: false}) // 允许参数重复
    } else {
      config.data = qs.stringify(config.data) // 不允许参数（键）重复
    }
  }
}
```



`局部配置`

```javascript
export function getFisher (data) {
  return request({
    url: FisherApi.GetFisher,
    method: 'post',
    data: qs.stringify(data, {indices: false}),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
    }
  })
}
```

:turtle: 能全局配置的肯定不选择在局部配置了。



### qs格式化数组参数

```javascript
qs.stringify({ a: ['b', 'c'] });
// 'a[0]=b&a[1]=c'

qs.stringify({ a: ['b', 'c'] }, { indices: false });
// 'a=b&a=c'
```

```javascript
qs.stringify({ a: ['b', 'c'] }, { arrayFormat: 'indices' })
// 'a[0]=b&a[1]=c'

qs.stringify({ a: ['b', 'c'] }, { arrayFormat: 'brackets' })
// 'a[]=b&a[]=c'

qs.stringify({ a: ['b', 'c'] }, { arrayFormat: 'repeat' })
// 'a=b&a=c'
```



## 业务



### 接口错误统一弹出消息

> 情景：该系统会在请求成功时，返回 result 字段给前端表示是否为顺利请求。

方式一

> 前提：以及在 main.js 中全局安装了 UI 框架。

```javascript
import Vue from 'vue'

request.interceptors.response.use((response) => {
  if (response.data.result) {
    return response.data
  } else {
    Vue.prototype.$message.info('This is a normal message')
    return Promise.reject(response.data)
  }
}, errorHandler)
```

方式二

```javascript
import { message } from 'ant-design-vue';

request.interceptors.response.use((response) => {
  if (response.data.result) {
    return response.data
  } else {
    message.info('This is a normal message')
    return Promise.reject(response.data)
  }
}, errorHandler)
```

方式三

```react
import notification from 'ant-design-vue/es/notification'

request.interceptors.response.use((response) => {
  if (response.data.result) {
    return response.data
  } else {
    notification.error({
      message: '请求失败',
      duration: 0,
      description: response.data.description
    })
    Promise.reject(response.data).catch(() => {}) // 多余
  }
}, errorHandler)
```

:octopus: 不顺利的请求没有将结果返回出去，故需在所有的业务层的每个请求后判断是否拿到结果。

![image-20220416223957231](./img/不顺利请求)



### 错误消息字段的不同形式

> 接口会返回一个字段表示错误消息，但由于操作不规范，返回了多种键。

```javascript
request.interceptors.response.use((response) => {
  const responseCode = Number(response.data.code);
  response.data.code = Number(response.data.code);
  if (responseCode !== 200 && responseCode !== 401) {
    const error = response.data.message || response.data.msg || '后台服务出现错误';
    message.error(error);
    return Promise.reject(new Error(`${error}`)); 
  }
  return response.data.data;  
}, errorHandler)
```

:hammer_and_wrench: 不管后台返回 message 还是 msg 表示错误消息，都能成功抛出；并统一返回码类型。

:whale: 这里的 401 状态码，在该业务中有特殊含义（token失效）。



### 处理文件下载时的返回值

```react
request.interceptors.response.use((response) => {
  if (response.data instanceof ArrayBuffer || typeof response.data === 'string' || response.data instanceof Blob) {
  // 处理文件下载
    return response;
  }
  return response.data.data;
}, errorHandler)
```



### 登录失效处理

> 不管响应视为成功/失败，都能根据状态码来进行接下来的退出登录逻辑。

```javascript
import store from '@/store'

request.interceptors.response.use((response) => {
  if (responseCode === 401) {
    store.dispatch('Logout').then(() => {
      setTimeout(() => {
      window.location.reload()
      }, 1500)
    });
    return Promise.reject();
  }
  return response.data.data;  
}, errorHandler)

const errorHandler = (error) => {
  if (error.response) {
    if (error.response.status === 401) {
      store.dispatch('Logout').then(() => {
        setTimeout(() => {
        window.location.reload()
        }, 1500)
      });
      return Promise.reject();
    }
  }
  return Promise.reject(error);
}
```

:whale: 退出登录时删除 token，在刷新页面后，会被路由守卫拦截到登录页。



### 头部全局添加字段

```javascript
import VueCookie from 'vue-cookie';
import { baseURL } from '@/constants/base';

instance.interceptors.request.use((config) => {
  const token = VueCookie.get('authorization');
  const store_id = VueCookie.get('store_id');
  const type = VueCookie.get('type');
  if (parseInt(type, 10) === 2 && store_id) {
    config.headers['store-id'] = store_id;
  }
  if (token != null) {
    config.headers.authorization = token;
    config.headers.type = 'unioncenter'; // 类型 商户
  } else {
    window.location.href = `${baseURL}/set-token`;
  }
}, ...);
```

>  代码中的 instance 为 axios 实例；上面的三个缓存值，在登录时会写入进去；
>
> 在没有 token 的情况下，调用任何接口都会去set-token页面。



### 上传excel到服务器

> 图片等资源应该也适用。

![image-20220618173130414](.\img\上传资源)

```html
<!DOCTYPE html>
<html>
<body>

<input id="input" type="file" />

<script src="https://unpkg.com/axios/dist/axios.min.js"></script>

<script>
document.getElementById("input").addEventListener("change",function (e) {
  console.log("change", e.target.files[0]);
  const excelFilt = e.target.files[0]
  const form = new FormData(); // FormData 对象
  form.append('file', excelFilt);
  console.log(form)
  
  axios.post('/user', form)
  .then(function (response) {
    console.log(response);
  })
  .catch(function (error) {
    console.log(error);
  });
});

</script>

</body>
</html>
```



### 下载excel

```javascript
export async function handleExport(config, fileName) {
  // 下载
  exportFile(config).then(res => {
    const href = window.URL.createObjectURL(new Blob([res])) // 创建下载的链接
    const link = document.createElement('a')
    link.style.display = 'none'
    link.href = href
    link.download = fileName + '.xlsx' // 将作为文件名称
    document.body.appendChild(link)
    link.click()
    // 下载完成移除元素
    document.body.removeChild(link)
    // 释放掉blob对象
    window.URL.revokeObjectURL(href)
  }).catch(err => {
    console.log(err.response.data.message)
  })
}
```

window.URL.createObjectURL介绍 https://www.cnblogs.com/mark5/p/13321460.html?ivk_sa=1024320u





