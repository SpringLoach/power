### [官方文档](http://expressjs.com/en/5x/api.html#res)

----

### 应用  
> express 的实例。  

#### 应用_常用方法 

方法 | 说明 | 补充
:- | :- | :-
app.listen() | 启动 HTTP 服务器侦听连接，首参为端口 | 与 Node 的[http.Server.listen](https://nodejs.org/api/http.html#http_server_listen)()相同
app.set() | 可用于配置服务器的行为 | 参考[表格](http://expressjs.com/en/5x/api.html#app.settings.table)
[app.use](#app_use)() | 安装指定的[中间件](http://expressjs.com/en/5x/api.html#middleware-callback-function-examples)在指定的路径功能或多个功能 | 中间件[教程](http://expressjs.com/en/guide/using-middleware.html)
[express.static](http://expressjs.com/en/4x/api.html#express.static)() | 提供静态文件，首参为根目录 | 通过结合req.url提供的root目录来确定要提供的文件


#### app_use  

参数 | 说明 | 默认值 | 可选值
:- | :- | :- | :-
path | 调用中间件函数的路径 | '/'（根路径）| 表示路径的字符串或正则、路径模式
callback | 回调函数 | 无 | 可提供多个回调。若无路径，收到任何类型请求时都会执行





----

### 响应对象  
> 该res对象表示 Express 应用在收到 HTTP 请求时发送的 HTTP 响应。  
> 
> 为 Node 自身响应对象的增强版本，支持所有[内置字段和方法](https://nodejs.org/api/http.html#http_class_http_serverresponse)。

```
app.get('/user/:id', function (req, res) {
  res.send('user ' + req.params.id)
})
```

#### 响应对象_常用方法  

方法 | 说明 | 补充
:- | :- | :-
res.end() | 用于在没有任何数据的情况下**快速结束响应** | / 
res.json() | 参数通过 JSON.stringify 转化格式后响应 | 参数可以是 JSON 类型（对象、数组、字符串、布尔值、数字或空值）也可以是非 JSON 类型
res.send() | 发送参数，会根据参数类型自动设置 `Content-Type` | 参数可以是Buffer对象、字符串、对象、布尔值或数组
[res.status](#res_status)() | 设置响应的状态码，其后可接其它响应方法 | /

#### res_status  

```
res.status(403).end()
res.status(400).send('Bad Request')
res.status(404).sendFile('/absolute/path/to/404.png')
```

----

### Router  
> 在express中使用Router是为了方便根据路由去分模块，避免将所有路由都写在入口文件中。  

#### 使用方式    

#### 不拆分文件使用  

顺序 | 步骤 | 说明 
:-: | :- | :-
① | 创建路由实例 | `express.Router()` 
② | 添加路由到应用上 | `app.use('根路径', 路由实例)`
③ | 增加路由 | 首参可以不带根路径

```
const express = require('express');
 
let app = express();
app.listen(8888);
 
let usersRouter = express.Router();
let orderRouter = express.Router();
 
app.use('/users', usersRouter);
app.use('/order', orderRouter);
 
usersRouter.get('/', function (req, res) {
    res.send('用户首页');
});
 
usersRouter.get('/:id', function (req, res) {
    res.send(`${req.params.id} 用户信息`);
});
```

#### 划分多文件使用
> 创建一个 routes 目录，专门用于放置路由文件，在文件最后通过 module.exports 导出供外部使用。  

```
const express = require('express');
let app = express();
app.listen(8888);
 
app.use('/users', require('./routes/users'));
app.use('/order', require('./routes/order'));
```

```
/* user.js */
const express = require('express');
 
let router = express.Router();
 
router.get('/', function (req, res) {...});
 
router.get('/:id', function (req, res) {...});

module.exports = router;
```

#### 划分单个文件使用  

```
const express = require('express')
const router = require('./server/router')
const app = express()

app.use(router)
```

```
/* router.js */
const express = require('express')
const router = express.Router()

router.post('/api/admin/signup', function (req, res) {...})

router.post('/api/admin/signin', function (req, res) {...})

router.get('/api/admin/getUser/:name', function (req, res) {...})

router.get('/api/articleList', function (req, res) {...})

module.exports = router
```

#### 路由方法  
> 可结合任意HTTP方法使用，首参为路径，第二参为回调。  

[常见方法](http://expressjs.com/en/5x/api.html#router.all) | 说明
:-: | :-
router.all() | 匹配所有方法，可为特定前缀路径路由，或所有路径路由等添加全局逻辑。如身份验证、自动加载用户、白名单
router.get() | 
router.post() | 
router.put() | 

传给回调的参数

顺序 | 参数 | 说明
:-: | :- | :-
① | req | 请求对象 
② | res | 响应对象
③ | next | 下一个中间件功能
④ | ... | ...

----

#### [body-parser](https://www.jianshu.com/p/0de80549c520)  
> 在 Node.js 原生的http模块中，请求体是要基于流的方式来接受和解析。  
> 
> body-parser 是一个HTTP请求体解析的中间件，使用这个模块可以解析JSON、Raw、文本、URL-encoded格式的请求体。   
>
> Express框架默认使用body-parser作为请求体解析中间件，配置其以获得解析的能力。  

#### [express-session](https://www.cnblogs.com/loaderman/p/11506682.html)  
> session 是另一种记录客户状态的机制，不同的是 Cookie 保存在客户端浏览器中，而 session 保存在服务器上。
>
> session 运行在服务器端，当客户端第一次访问服务器时，可以将客户的登录信息保存。当客户访问其他页面时，可以判断客户的登录状态，做出提示，相当于登录拦截。  
> 
> 可与数据库等结合做持久化操作，当服务器挂掉时也不会导致某些客户信息(购物车)丢失。  

#### connect-mongo  
> 可以将 express 在进行会话管理的时候将会话数据保存在外部mongo数据库中











