## 相对路径的特性

```elm
- src 
  + file
    - index.js
    - index2.js
```

<span style="backGround: #efe0b9">index.js</span>

```javascript
require('./index2.js')
console.log(process.cwd())
```

:octopus: 相对路径的参照为启动项目的文件夹

**正常**

```elm
node index.js
```

**报错**

> 此时引入的路径是 `src/index2.js` 

```elm
node file/index.js
```







## 学习登录凭证

> 为了解决：http的每次请求都是一个单独的请求，不知道用户是否有登录。



### cookie

#### cookie分类

- 内存Cookie

  + 没有设置过期时间（默认）。

  + 由浏览器维护，保存在内存中，关闭会话时Cookie就会消失

- 硬盘Cookie

  + 有设置过期时间，且过期时间大于0

  + 保存在硬盘中，有一个过期时间，用户手动清理或者过期时间到时，才会被清理



#### cookie常见属性

- 生命周期相关

  + expires：设置的是Date.toUTCString()
  + max-age：设置过期的秒数

- 作用域

  + Domain： 指定哪些主机可以接受cookie，默认是 origin，不包括子域名。

  + Path： 指定主机下哪些路径可以接受cookie

    ```less
    // 设置 Path=/docs，则以下地址都会匹配：
    /docs
    /docs/Web/
    /docs/Web/HTTP
    ```

    

#### 客户端设置cookie

```html
<script>
  // 关闭会话失效
  document.cookie = 'name=kobe';
  // 5s后失效
  document.cookie = 'age=18;max-age=5;';
</script>
```



#### 服务端设置cookie

```javascript
const Koa = require('koa');
const Router = require('koa-router');

const app = new Koa();

const testRouter = new Router();

testRouter.get('/test', (ctx, next) => {
  // 设置cookie
  ctx.cookies.set("name", "lilei", {
    maxAge: 50 * 1000
  })
  ctx.body = "123";
});


testRouter.get('/demo', (ctx, next) => {
  // 读取cookie
  const value = ctx.cookies.get('name');
  ctx.body = "你的cookie是" + value;
});

app.use(testRouter.routes());

app.listen(8080, () => {
  console.log("服务器启动成功~");
})
```

:turtle: 不同于客户端，在服务器 maxAge 的单位是毫秒；

:turtle: 主域名下的其它接口，默认也会携带设置好的cookie信息。



### session

> 本质也是 cookie

#### 服务端设置

```elm
npm install koa-session
```

```javascript
const Koa = require('koa');
const Router = require('koa-router');
const Session = require('koa-session');

const app = new Koa();

const testRouter = new Router();

// 创建Session的配置
const session = Session({
  key: 'sessionid',
  maxAge: 10 * 1000,
  signed: false, // 是否使用加密签名
}, app);
app.use(session);

// 登录接口
testRouter.get('/test', (ctx, next) => {
  const id = 123;
  const name = "demo";

  ctx.session.user = {id, name};
  ctx.body = 123;
});

testRouter.get('/demo', (ctx, next) => {
  console.log(ctx.session.user);
  ctx.body = 'demo';
});

app.use(testRouter.routes());

app.listen(8080, () => {
  console.log("服务器启动成功~");
})
```

:turtle: 存储在客户端的形式是 base64，但不影响服务端的设置/读取。



#### 使用加密签名

通过加密签名，可以防止用户伪造cookie信息，加盐的内容是只有服务端知道的。

```javascript
// 创建Session的配置
const session = Session({
  key: 'sessionid',
  maxAge: 10 * 1000,
  signed: true, // 是否使用加密签名
}, app);
app.keys = ["aaaa"]; // 加盐
app.use(session);
```



#### 它们的缺点

- Cookie会被附加在每个HTTP请求中，所以无形中增加了流量（事实上某些请求是不需要的）；

- Cookie是明文传递的，所以存在安全性的问题； 

- Cookie的大小限制是4KB，对于复杂的需求来说是不够的； 

- 对于浏览器外的其他客户端（比如iOS、Android），必须手动的设置cookie和session，不方便；

- 对于分布式系统和服务器集群中如何可以保证其他系统也可以正确的解析session？





### Token

#### JWT实现Token机制

>  JWT生成的Token由三部分组成

<span style="color: #f7534f;font-weight:600">signature</span> 设置一个 secretKey，并与前两个的结果合并后进行 HMACSHA256 的算法

```elm
 HMACSHA256(base64Url(header)+.+base64Url(payload), secretKey);
```



![image-20220703211859829](D:\笔记\技术沉淀（后端）\node\img\JWT)



#### 对称加密

```elm
npm install koa koa-router jsonwebtoken
```

```javascript
const Koa = require('koa');
const Router = require('koa-router');
const jwt = require('jsonwebtoken');

const app = new Koa();
const testRouter = new Router();

const SERCET_KEY = '123123';

// 登录接口
testRouter.post('/test', (ctx, next) => {
  const user = {id: 110, name: 'why'};
  // 颁发令牌
  const token = jwt.sign(user, SERCET_KEY, {
    expiresIn: 10 // 多久后过期
  });

  ctx.body = token;
});

// 验证接口
testRouter.get('/demo', (ctx, next) => {
  // 实际上token的携带方式不止这一种，视实际情况定
  const authorization = ctx.headers.authorization;
  const token = authorization.replace("Bearer ", "");

  try {
    // 校验令牌
    const result = jwt.verify(token, SERCET_KEY);
    ctx.body = result;
  } catch (error) {
    console.log(error.message);
    ctx.body = "token是无效的~";
  }
});

app.use(testRouter.routes());

app.listen(8080, () => {
  console.log("服务器启动成功~");
})
```

<span style="color: #f7534f;font-weight:600">jwt.sign</span> 接收的参数：携带的数据、密钥、其它配置。



#### 非对称加密

##### 生成私钥和公钥

> 可以借助 `openssl` 来生成私钥和对应的公钥。

```elm
- src
  + keys
```

0. 对于 Window 系统，需要使用 `git bash` 中才能使用 `openssl`（`cmd` 不行）；

1. 生成需要保存私钥、公钥的文件夹；

2. 使用 `openssl` 生成私钥和对应的公钥。

```elm
openssl
genrsa -out private.key 1024
rsa -in private.key -pubout -out public.key
```

:whale: 后面的数字代表设置私钥的长度。



##### 实现

```javascript
const Koa = require('koa');
const Router = require('koa-router');
const jwt = require('jsonwebtoken');
const fs = require('fs');

const app = new Koa();
const testRouter = new Router();

const PRIVATE_KEY = fs.readFileSync('./keys/private.key');
const PUBLIC_KEY = fs.readFileSync('./keys/public.key');

// 登录接口
testRouter.post('/test', (ctx, next) => {
  const user = {id: 110, name: 'why'};
  const token = jwt.sign(user, PRIVATE_KEY, {
    expiresIn: 10,
    algorithm: "RS256" // 采用的加密算法（非默认）
  });

  ctx.body = token;
});

// 验证接口
testRouter.get('/demo', (ctx, next) => {
  const authorization = ctx.headers.authorization;
  const token = authorization.replace("Bearer ", "");

  try {
    const result = jwt.verify(token, PUBLIC_KEY, {
      algorithms: ["RS256"]
    });
    ctx.body = result;
  } catch (error) {
    console.log(error.message);
    ctx.body = "token是无效的~";
  }
});

app.use(testRouter.routes());

app.listen(8080, () => {
  console.log("服务器启动成功~");
})
```

:ghost: 通过私钥发布令牌，通过公钥验证令牌。



