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



### 传中文参数

```
可以通过 post 请求，body 传参的方式来实现
```

也可以通过 encodeURIComponent 编码，需要后端解码配合。



## 业务

### 常见操作

| 位置     | 操作                             | 说明                         |
| -------- | -------------------------------- | ---------------------------- |
| 基础配置 | 封装的位置为 utils/request.js    | 个人喜欢把配置归属到 api     |
| 基础配置 | 设置 baseURL                     | 直接使用环境变量中的值       |
| 基础配置 | 直接设置默认的头部字段           | 一般为 json 格式             |
| 请求拦截 | 防重：针对 post / put 的请求类型 | 借助缓存拦截短时间的重复提交 |
| 响应拦截 | 对于二进制数据，直接返回         | 正常数据通过解决期约返回     |
| 响应拦截 | 处理状态码：401 重新登录         |                              |



### baseURL & 默认头部

- baseURL 直接使用环境变量中的值

- 直接设置默认的头部字段为  json 格式

```javascript
import axios from 'axios'

axios.defaults.headers['Content-Type'] = 'application/json;charset=utf-8'
// 创建axios实例
const service = axios.create({
  baseURL: import.meta.env.VITE_APP_BASE_API,
  timeout: 10000
})
```

>  这里以 vite 作为例子展示取环境变量中的值。



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



### 防止短时间重复请求

> 请求拦截中添加如下代码

```javascript
// 配置了需要防重，且为 post / put 类型的请求进行校验
if (!isRepeatSubmit && (config.method === 'post' || config.method === 'put')) {
  const requestObj = {
    url: config.url,
    data: typeof config.data === 'object' ? JSON.stringify(config.data) : config.data,
    time: new Date().getTime()
  }
  const sessionObj = cache.session.getJSON('sessionObj')
  if (sessionObj === undefined || sessionObj === null || sessionObj === '') {
    cache.session.setJSON('sessionObj', requestObj)
  } else {
    const s_url = sessionObj.url;                // 请求地址
    const s_data = sessionObj.data;              // 请求数据
    const s_time = sessionObj.time;              // 请求时间
    const interval = 1000;                       // 间隔时间(ms)，小于此时间视为重复提交
    if (s_data === requestObj.data && requestObj.time - s_time < interval && s_url === requestObj.url) {
      const message = '数据正在处理，请勿重复提交';
      console.warn(`[${s_url}]: ` + message)
      return Promise.reject(new Error(message))
    } else {
      cache.session.setJSON('sessionObj', requestObj)
    }
  }
}
```

这里的 cache 为项目封装的方法对象，内部自动完成了JSON解析/转化的操作；



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





