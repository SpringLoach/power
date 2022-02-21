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
import axios from 'axios';
import qs from 'qs';

const instance = axios.create({
  baseURL: '/api',
  timeout: 10 * 60 * 1000,
});

const requestHandlers = [(config) => {
  // 如果是get请求，且paramas是数组类型如arr=[1, 2]，则转换成arr=1&arr=2
  if (config.isParamsSerializer) {
    if (config.method === 'get') {
      config.paramsSerializer = params => qs.stringify(params, { arrayFormat: 'repeat' });
    }
  }
  return config;
}, err => Promise.reject(err)]; // 第二个参数（方法）用于处理错误请求

instance.interceptors.request.use(...requestHandlers); // 请求拦截

export default instance;
```

