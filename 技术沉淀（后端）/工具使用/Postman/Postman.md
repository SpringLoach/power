### 安装使用

github 上有专门的汉化版[教程和资源](https://github.com/hlmd/Postman-cn)可以使用

**禁止自动更新**

1. 把postman目录下的update删除

2. postman - 设置 - 禁用自动下载主要更新



### 特殊

#### starthope接口前缀

> 接口的协议、主机名从 `vue.config.js` 中的 `devServer` 获取（这里是 `devServer.proxy.***.target` ）



### 操作方式

#### 登录

> 获取 `token` 值备用。

| --       | --                                             |
| -------- | ---------------------------------------------- |
| 请求类型 | POST                                           |
| 路径     | http://aicp-user.stage.dm-ai.com/v1/user/login |

| Headers      | --               |
| ------------ | ---------------- |
| Content-Type | application/json |

`Body`  o raw

```
{
    "username":"yyds",
    "password":"123456"
}
```



#### 请求所有标签

| --       | --                                                           |
| -------- | ------------------------------------------------------------ |
| 请求类型 | GET                                                          |
| 路径     | https://aicp-management-web.stage.dm-ai.com/api/v1/question/labels |

| Authorization |                                     |
| ------------- | ----------------------------------- |
| Bearer Token  | 粘贴 Token 值或全局变量 `{{Token}}` |



#### 获取课程列表

| --       | --                                                           |
| -------- | ------------------------------------------------------------ |
| 请求类型 | GET                                                          |
| 路径     | https://aicp-course.stage.dm-ai.com/api/course/published/all |

| Authorization |               |
| ------------- | ------------- |
| Bearer Token  | 粘贴 Token 值 |

| Parmas   |      |
| -------- | ---- |
| pagesize | 1    |
| page     | 1    |

#### 全局变量

> 设置后可以在相关请求中通过双括号语法引入。

| --                | --                           |
| ----------------- | ---------------------------- |
| initial value     | 可以分享给别人使用的变量值   |
| **current value** | 当前自己使用该变量时变量的值 |

![全局变量1](./img/postman全局1.png)

![全局变量1](./img/postman全局2.png)

#### 环境变量

https://blog.csdn.net/qq_36662437/article/details/105022694

#### 新建工程

> 往往用一个 `Collections` 表示一个工程，方便管理。

![新建工程](./img/postman新建工程.png)

#### 保存接口

> 在新建接口并验证后，可以将接口保存到工程中。

![保存接口](./img/postman保存接口.png)

#### 新建目录或请求

> 点击左侧工程或文档处的 `···`，可以重命名、新建目录或在当前目录新建请求。



## postman

> 参考自codewhy老师的node课程

### 环境配置接口

大概在Node课程的18集？ 1:50:30



### 全局token

**设置**

> 在登录接口的 Tests 添加代码：

```javascript
const res = pm.response.json();
pm.globals.set("token", res.token);
```

<span style="color: #f7534f;font-weight:600">pm</span> 是一个全局对象，是 `postman` 的缩写

<span style="color: #f7534f;font-weight:600">pm.response</span> 可以拿到本次响应的结果

<span style="color: #f7534f;font-weight:600">pm.globals</span> 里面可以设置一些全局属性

**获取**

> 在需要添加 Token 的地方，一般是 Authorization 中设置该变量。

```javascript
{{token}}
```



