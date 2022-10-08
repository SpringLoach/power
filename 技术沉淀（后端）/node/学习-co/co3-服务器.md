## 事件循环

### 宏任务和微任务面试题一

> 执行宏任务前，需要清空当前微任务；执行微任务前，先执行整体代码。

```javascript
setTimeout(function () {
  console.log("set1");
  new Promise(function (resolve) {
    resolve();
  }).then(function () {
    new Promise(function (resolve) {
      resolve();
    }).then(function () {
      console.log("then4");
    });
    console.log("then2");
  });
});

new Promise(function (resolve) {
  console.log("pr1");
  resolve();
}).then(function () {
  console.log("then1");
});

setTimeout(function () {
  console.log("set2");
});

console.log(2);

queueMicrotask(() => {
  console.log("queueMicrotask1")
});

new Promise(function (resolve) {
  resolve();
}).then(function () {
  console.log("then3");
});

// pr1
// 2
// then1
// queuemicrotask1
// then3
// set1
// then2
// then4
// set2
```

### 宏任务和微任务面试题二

```javascript
async function async1 () {
  console.log('async1 start')
  await async2();
  console.log('async1 end')
}
 
async function async2 () {
  console.log('async2')
}

console.log('script start')

setTimeout(function () {
  console.log('setTimeout')
}, 0)
 
async1();
 
new Promise (function (resolve) {
  console.log('promise1')
  resolve();
}).then (function () {
  console.log('promise2')
})

console.log('script end')


// script start
// async1 start
// async2
// promise1
// script end
// aysnc1 end
// promise2
// setToueout
```



### Node队列任务面试题一

```javascript
async function async1() {
  console.log('async1 start')
  await async2()
  console.log('async1 end')
}

async function async2() {
  console.log('async2')
}

console.log('script start')

setTimeout(function () {
  console.log('setTimeout0')
}, 0)

setTimeout(function () {
  console.log('setTimeout2')
}, 300)

setImmediate(() => console.log('setImmediate'));

process.nextTick(() => console.log('nextTick1'));

async1();

process.nextTick(() => console.log('nextTick2'));

new Promise(function (resolve) {
  console.log('promise1')
  resolve();
  console.log('promise2')
}).then(function () {
  console.log('promise3')
})

console.log('script end')


// script start
// async1 start
// async2
// promise1
// promise2
// script end
// nextTick1
// nextTick2
// async1 end
//  promise3
// setTimeout0
// setImmediate
// setTimeout2
```

执行顺序

```elm
main script
↓
nextTicks (process.nextTick)
↓
other microtask (promise.then、async await)
↓
timers (setTimeout、setInterval)
↓
immediate
```



### Node队列任务面试题二

> 下面的代码在输出时，顺序不是固定的。

```javascript
setTimeout(() => {
  console.log("setTimeout");
}, 0);

setImmediate(() => {
  console.log("setImmediate");
});
```

  :turtle: 这是因为在首次运行事件循环时，有可能执行到 timer 阶段，但却还没有将定时器回调放入相应回调中。它会被处理到第二轮循环中去。



### 阻塞IO和非阻塞IO

看起来 JavaScript 可以直接对一个文件进行操作，但是事实上任何程序中的文件操作都是需要进行系统调用（操作系统的文件系统）；

对文件的操作，是一个操作系统的IO操作（<span style="color: #ff0000">输入、输出</span>）；



操作系统为我们提供了阻塞式调用和非阻塞式调用：

-  阻塞式调用： 调用线程只有 在得到调用结果之后才会继续执行，否则处于阻塞态；

- 非阻塞式调用： 调用执行之后，当前线程不会停止执行，每过一段时间来检查有没有结果。



### 非阻塞IO的问题

> 为了可以知道是否读取到了完整的数据，我们需要频繁的去确定读取到的数据是否是完整的（轮询）。

那么这个轮训的工作由<span style="color: #ff0000">谁来完成</span>呢？

- 如果我们的主线程频繁的去进行轮询的工作，那么必然会大大降低性能； 
- 并且开发中我们可能不只是一个文件的读写，可能是多个文件； 
- 而且可能是多个功能：网络的IO、数据库的IO、子进程调用； 

libuv 提供了一个<span style="color: #ff0000">线程池（Thread Pool）</span>： 
- 线程池会负责所有相关的操作，并且会通过<span style="color: #ff0000">轮询</span>等方式等待结果； 
- 当获取到结果时，就可以<span style="color: #ff0000">将对应的回调放到事件循环</span>（某一个事件队列）中；



### libuv

​       浏览器中的 EventLoop 是根据 HTML5 定义的规范来实现的，不同的浏览器可能会有不同的实现，而 Node 中是由 <span style="color: #a50">libuv</span> 实现的。Libuv 采用的就是非阻塞异步IO的调用方式。

![image-20220626095617221](.\img\工作者线程)

- 阻塞和非阻塞是对于被调用者来说的；

- 同步和异步是对于调用者来说的。

:whale: 对于 Java 等语言来说，由于存在线程安全问题（多线程同时操作同一空间），会有加锁的概念；Node.js 通过消息队列，避免了这个冲突。



## HTTP

### 初体验

```javascript
const http = require('http');

// 创建一个web服务器
const server = http.createServer((req, res) => {
  res.write("[1, 2, 3]");
  res.end("Hello Server");
});

// 启动服务器,并且制定端口号和主机
server.listen(8888, '0.0.0.0', () => {
  console.log("服务器启动成功~");
  console.log(server.address().port); // 服务器所在的端口号
});
```

<span style="color: #f7534f;font-weight:600">res.end</span> 添加输出参数，并断开连接。

<span style="color: #f7534f;font-weight:600">server.listen</span> 三个参数均可选，默认的端口会选择一个未被占用的端口。



### 更新重启

> 可以在每次修改代码后，自动重启执行。

```elm
npm install -g nodemon
```

**启动**

> 启动的时候将 <span style="color: #a50">node </span>替换为 <span style="color: #a50">nodemon</span> 即可。

```elm
nodemon fileName
```



### 创建服务器的方式

```javascript
const http = require('http');

/* 方式一 */
const server1 = http.createServer((req, res) => {
  res.end("Server1");
});

server1.listen(8000, () => {
  console.log("server1启动成功~");
});

/* 方式二：等价 */
const server2 = new http.Server((req, res) => {
  res.end("Server2");
});

server2.listen(8001, () => {
  console.log("server2启动成功~");
});
```

:whale: 可以同时创建并启动多个服务器。



### request对象分析

```javascript
const http = require('http');

const server = http.createServer((req, res) => {
  // request对象中封装了客户端给我们服务器传递过来的所有信息
  console.log(req.url);
  console.log(req.method);
  console.log(req.headers);

  res.end("Hello Server");
});

server.listen(8888, '0.0.0.0', () => {
  console.log("服务器启动成功~");
});
```

:whale: 如果响应没有结束（res.end），浏览器中相应的页面会一直转圈圈。



### request对象-url

```javascript
const http = require('http');
const url = require('url');
const qs = require('querystring');

const server = http.createServer((req, res) => {

  /* 最基本的使用方式(不存在查询参数的理想情况) */
  if (req.url === '/login') {
    res.end("欢迎回来~");
  } else if (req.url === '/users') {
    res.end("用户列表~");
  } else {
    res.end("错误请求, 检查~");
  }

  /* 格式如 login?username=why&password=123 */
  const { pathname, query } = url.parse(req.url);
  if (pathname === '/login') {
    console.log(query);           // username=why&password=123
    console.log(qs.parse(query)); // { username: 'why', password: '123' }
    const { username, password } = qs.parse(query);
    res.end("请求结果~");
  }
});

server.listen(8888, '0.0.0.0', () => {
  console.log("服务器启动成功~");
});
```

:whale: 使用 [URLSearchParams](http://www.qiutianaimeili.com/html/page/2019/05/ly9elo7w9bn.html) 代替 querystring 模块解析请求参数；

:whale: [解决](https://blog.csdn.net/bnzjxbsjjdnnxj/article/details/123970816)服务器返回中文乱码问题。



### request对象-method

```javascript
const http = require('http');
const url = require('url');
const qs = require('querystring');

const server = http.createServer((req, res) => {

  const { pathname } = url.parse(req.url);
  if (pathname === '/login') {
    if (req.method === 'POST') {
      // 获取 body 中的数据，并告知编码格式
      req.setEncoding('utf-8');
      req.on('data', (data) => {
        const {username, password} = JSON.parse(data);
        console.log(username, password);
      });

      res.end("Hello World");
    }
  }
});

server.listen(8888, '0.0.0.0', () => {
  console.log("服务器启动成功~");
});
```

:ghost: 可以提前通过 <span style="color: #a50">req.setEncoding</span> 指定数据的编码格式，也可以通过 data.toString 的方式进行 utf-8 的解码。



### request对象-headers

![image-20220627202207920](.\img\头部)

<span style="color: #f7534f;font-weight:600">content-type</span> 请求携带的数据的类型

- application/json表示是一个json类型； 
-  text/plain表示是文本类型； 
- application/xml表示是xml类型； 
- multipart/form-data表示是上传文件。

 <span style="color: #f7534f;font-weight:600">content-length</span> 文件的大小和长度

<span style="color: #f7534f;font-weight:600">keep-alive</span> 在进行一次请求和响应结束后要继续保持连接

- 需要浏览器和服务器都在头部添加 connection: keep-alive

- 当客户端再次发起请求时，就会使用同一个连接，直至一方中断连接；

<span style="color: #f7534f;font-weight:600">accept-encoding</span> 告知服务器，客户端支持的文件压缩格式，能够自动解压，如 `.gz`；

<span style="color: #f7534f;font-weight:600">accept</span> 告知服务器，客户端可接受文件的格式类型；

<span style="color: #f7534f;font-weight:600">user-agent</span> 客户端（代理）相关的信息；



### response对象-响应结果

```javascript
const http = require('http');

const server = http.createServer((req, res) => {
  // 响应结果
  res.write("响应结果一");
  res.end("Hello World");
});

server.listen(8888, '0.0.0.0', () => {
  console.log("服务器启动成功~");
});
```

:octopus: 注意区分于 <span style="color: #a50">stream</span>，不存在 `res.close` 方法。



### response对象-[响应码](https://www.koajs.com.cn/#response)

```javascript
const http = require('http');

const server = http.createServer((req, res) => {
  /* 设置状态码 */
  // 方式一: 直接给属性赋值
  res.statusCode = 400;

  res.end("Hello World");
});

server.listen(8888, '0.0.0.0', () => {
  console.log("服务器启动成功~");
});
```

```javascript
// 方式二: 和Head一起设置
res.writeHead(503)
```



### response对象-响应header

```javascript
const http = require('http');

const server = http.createServer((req, res) => {
  /* 设置响应的header */
  // 方式一
  res.writeHead(200, {
    "Content-Type": "text/html;charset=utf8" // 后面可以跟编码类型
  });

  // 响应结果
  res.end("<h2>Hello Server</h2>");
});

server.listen(8888, '0.0.0.0', () => {
  console.log("服务器启动成功~");
});
```

<span style="color: #f7534f;font-weight:600">res.writeHead</span> 同时写入 header 和 status。

> 也可以一次写入一个头部信息

```javascript
// 方式二
res.setHeader("Content-Type", "text/plain;charset=utf8");
```

**Content-Type**

```javascript
// 当作文本，直接显示
"Content-Type": "text/plain;charset=utf8"

// 当作应用，触发下载
"Content-Type": "application/html;charset=utf8"

// 当作 html 文件
"Content-Type": "text/html;charset=utf8"
```



### http中发送网络请求

**发送get请求**

```javascript
const http = require('http');

// http发送请求-get
http.get('http://localhost:8888', (res) => {
  res.on('data', (data) => {
    console.log(data.toString());
  });

  res.on('end', () => {
    console.log("获取到了所有的结果");
  })
})
```

**发送其它请求**

```javascript
const http = require('http');

// http发送请求-post
const req = http.request({
  method: 'POST',
  hostname: 'localhost',
  port: 8888
}, (res) => {
  res.on('data', (data) => {
    console.log(data.toString());
  });

  res.on('end', () => {
    console.log("获取到了所有的结果");
  })
});

req.end();
```

:turtle: 不同于上面的 <span style="color: #ff0000">http.get</span>，发送其它类型的请求需要用到 <span style="color: #ff0000">http.request</span>，而且在末尾调用对应的 <span style="color: #ff0000">end</span> 方法表示配置完成。

 

### http文件上传-错误的做法

```javascript
const http = require('http');
const fs = require('fs');

const server = http.createServer((req, res) => {
  if (req.url === '/upload') {
    if (req.method === 'POST') {
      const fileWriter = fs.createWriteStream('./foo.png', {flags: 'a+'});

      req.on('data', (data) => {
        console.log(data);
        fileWriter.write(data);
      });

      req.on('end', () => {
        console.log("文件上传成功~");
        res.end("文件上传成功~");
      })
    }
  }
});

server.listen(8000, () => {
  console.log("文件上传服务器开启成功~");
})
```

:octopus: 写入的字节流中包含图片信息和其它信息（编码、键、文件名、类型），非纯图片，无法正常打开；

:octopus: 用 pipe 的方式也是一样的结果。



### http文件上传-正确的做法

> 操作起来特别复杂，真实开发一般用框架。

```javascript
const http = require('http');
const fs = require('fs');
const qs = require('querystring');

const server = http.createServer((req, res) => {
  if (req.url === '/upload') {
    if (req.method === 'POST') {
      // 0. 告知数据的编码类型
      req.setEncoding('binary');

      let body = '';
      const totalBoundary = req.headers['content-type'].split(';')[1];
      const boundary = totalBoundary.split('=')[1];

      req.on('data', (data) => {
        body += data;
      });

      req.on('end', () => {
        console.log(body);
        // 1.获取image/png的位置
        const payload = qs.parse(body, "\r\n", ": ");
        const type = payload["Content-Type"];

        // 2.开始在image/png的位置进行截取
        const typeIndex = body.indexOf(type);
        const typeLength = type.length;
        let imageData = body.substring(typeIndex + typeLength);

        // 3.将中间的两个空格去掉
        imageData = imageData.replace(/^\s\s*/, '');

        // 4.将最后的boundary去掉
        imageData = imageData.substring(0, imageData.indexOf(`--${boundary}--`));

        fs.writeFile('./foo.png', imageData, 'binary', (err) => {
          res.end("文件上传成功~");
        })
      })
    }
  }
});

server.listen(8000, () => {
  console.log("文件上传服务器开启成功~");
})
```

<span style="color: #ff0000">qs.parse</span> 的第二、三个参数默认值为 &、=，表示分隔的字符，及组成键值对的分隔符。

![image-20220627233721985](.\img\上传图片)

boundary序列号示例

![image-20220627233825934](.\img\上传图片2)



### 补充-断点调试

![image-20220627234145239](.\img\断点调试)



## Express

搭建Web服务器，除了使用http内置模块外，还可以使用框架。在URL判断、Method判断、参数处理等方面会更加方便。目前在Node中比较流行的<span style="color: #a50">Web服务器框架</span>是express、koa。



### 使用的两种方式

#### 安装express-generator

安装脚手架

```elm
npm install -g express-generator
```

创建项目

```elm
express express-demo
```

安装依赖

```elm
npm install
```

启动项目

```elm
node bin/www
```

发送请求

```elm
localhost:3000
```

:whale: 默认启动的端口号为 3000



#### 从零搭建

初始化包管理

```elm
npm init -y
```

安装到局部

```elm
npm install express
```



### express初体验

```javascript
const express = require('express'); // 导出的本质是函数 createApplication

// 调用函数返回app
const app = express();

// 监听默认路径-get (如在网址中直接访问)
app.get('/', (req, res, next) => {
  res.end("Hello Express");
})

// 监听默认路径-post (如postman中调用)
app.post('/', (req, res, next) => {
  
})

// 监听子路径-post
app.post('/login', (req, res, next) => {
  res.end("Welcome Back~");
})

// 开启监听
app.listen(8000, () => {
  console.log("express初体验服务器启动成功~");
});
```

:whale: 不同于 http 模块，express 实例有相应的 post 方法。



### 中间件-普通中间件

- 执行任何代码；

- 更改请求（request）和响应（response）对象； 
-  结束请求-响应周期（返回数据）； 
- 调用栈中的下一个中间件

![image-20220628225612874](.\img\中间件)

```javascript
const express = require('express');

const app = express();

// use注册一个普通中间件(回调函数)
app.use((req, res, next) => {
  console.log("匹配所有请求");
  res.end("结束响应并输出该信息");
});

app.listen(8000, () => {
  console.log("普通中间件服务器启动成功~");
});
```

  :ghost: 普通中间件可以<span style="color: #ff0000">匹配所有的请求</span>（忽略方法和路径）

  :ghost: 可以在中间件中结束请求-响应周期。

```javascript
const express = require('express');

const app = express();

app.use((req, res, next) => {
  console.log("注册了第01个普通的中间件~");
  next();
});

app.use((req, res, next) => {
  console.log("注册了第02个普通的中间件~");
  next();
});

app.use((req, res, next) => {
  console.log("注册了第03个普通的中间件~");
  res.end("Hello Middleware");
});

app.listen(8000, () => {
  console.log("普通中间件服务器启动成功~");
});
```

:ghost: 可以存在多个中间件，会先执行最前面的匹配项，调用 `next` 将执行下一个匹配项；

:ghost: 在一个中间件中结束请求响应周期后，不影响其执行后面的逻辑，仍可调用 `next` 执行下一个匹配项。

:octopus: 对于已经结束请求响应周期的逻辑，后面<span style="color: #ff0000">再调用</span> res.end 会导致报错。



### 中间件-路径中间件

```javascript
const express = require('express');

const app = express();

app.use((req, res, next) => {
  console.log("common middleware01");
  next();
})

app.use('/home', (req, res, next) => {
  console.log("home middleware 02");
});

app.listen(8000, () => {
  console.log("express初体验服务器启动成功~");
});
```

:ghost: <span style="color: #f7534f;font-weight:600">app.use</span> 实际上可以接受一个路径参数（忽略方法）

:whale: 匹配规则依旧是由前往后。



### 中间件-路径方法中间件

```javascript
const express = require('express');

const app = express();

// 路径和方法匹配的中间件
app.get('/home', (req, res, next) => {
  console.log("home path and method middleware01");
});

app.post('/login', (req, res, next) => {
  console.log("login path and method middleware01");
})

app.listen(8000, () => {
  console.log("express初体验服务器启动成功~");
});
```



### 中间件-连续注册中间件

```javascript
const express = require('express');

const app = express();

app.get("/home", (req, res, next) => {
  console.log("home path and method middleware 02");
  next();
}, (req, res, next) => {
  console.log("home path and method middleware 03");
  next();
}, (req, res, next) => {
  console.log("home path and method middleware 04");
  res.end("home page");
});

app.listen(8000, () => {
  console.log("express初体验服务器启动成功~");
});
```

:whale: 可以接受任意多个函数作为后续的中间件。



### 应用-json/urlencoded解析

> 这里将公共的解析部分进行了抽离。

```javascript
const express = require('express');

const app = express();

// 自己编写的json解析
app.use((req, res, next) => {
  if (req.headers["content-type"] === 'application/json') {
    req.on('data', (data) => {
      const info = JSON.parse(data.toString());
      req.body = info;
    })
  
    req.on('end', () => {
      next();
    })
  } else {
    next();
  }
})

app.post('/login', (req, res, next) => {
  console.log(req.body);
  res.end("Coderwhy, Welcome Back~");
});

app.listen(8000, () => {
  console.log("express初体验服务器启动成功~");
});
```

:ghost: 可以通过给请求对象添加属性的方式来给下一个中间件传递参数。

:octopus: 注意不能在 `next()` 中添加参数，会视作错误。



**使用内置方法解析**

> 实际开发的首选方案。

```javascript
const express = require('express');

const app = express();

// 解析 application/json 格式
app.use(express.json());
// 解析 urlencoded 格式
app.use(express.urlencoded({extended: true}));

app.post('/login', (req, res, next) => {
  console.log(req.body);
  res.end("Coderwhy, Welcome Back~");
});

app.post('/products', (req, res, next) => {
  console.log(req.body);
  res.end("Upload Product Info Success~");
});

app.listen(8000, () => {
  console.log("express初体验服务器启动成功~");
});
```

<span style="color: #ff0000">body-parser</span> 在  express3.x 中框架内置；在 express4.x 中被分离；相似功能在 express4.16.x 中内置为函数

<span style="color: #ff0000">express.urlencoded</span> 的 extended，值为 true 时使用第三方库 qs 解析；否则使用Node内置模块 querystring



### 应用-form-data解析

```elm
npm install multer
```

> form-data 通常用于上传文件，当然也可以不携带文件。

```javascript
const express = require('express');
const multer = require('multer');

const app = express();

const upload = multer();

app.use(upload.any());

app.post('/login', (req, res, next) => {
  console.log(req.body);
  res.end("用户登录成功~")
});

app.listen(8000, () => {
  console.log("form-data解析服务器启动成功~")
});
```



### 应用-form-data上传文件

#### 上传单文件

```javascript
const path = require('path');

const express = require('express');
const multer = require('multer');

const app = express();

const upload = multer({
  dest: './uploads/'
});

// 额外添加中间件来处理
app.post('/upload', upload.single('file'), (req, res, next) => {
  console.log(req.files); // 文件信息
  res.end("文件上传成功~");
});

app.listen(8000, () => {
  console.log("form-data解析服务器启动成功~")
});
```

:turtle: 执行时就会根据 dest 的配置，动态创建文件夹；

:turtle: <span style="color: green">upload.single</span> 用于处理单个文件的上传，接收相应的键，以告知要处理的属性。

![image-20220629214341637](.\img\上传文件)

#### 自定义保存的文件名

> 时间戳加原文件名称的后缀。

```javascript
const path = require('path');

const multer = require('multer');

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, './uploads/'); // 错误、文件存储的路径
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname)); // 错误、文件名
  }
})

const upload = multer({
  storage
});
```

<span style="color: #a50">multer</span> 方法也可以接收一个 storage 属性，用于自定义名字、存储路径。

#### 上传多文件

```javascript
const path = require('path');

const express = require('express');
const multer = require('multer');

const app = express();

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, './uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  }
})

const upload = multer({
  storage
});

// 作为局部中间件使用，解析非文件的键值对
app.post('/login', upload.any(), (req, res, next) => {
  console.log(req.body);
  res.end("用户登录成功~")
});

app.post('/upload', upload.array('file'), (req, res, next) => {
  console.log(req.files);
  res.end("文件上传成功~");
});

app.listen(8000, () => {
  console.log("form-data解析服务器启动成功~")
});
```

:ghost: 使用 <span style="color: #ed5a65">upload.array</span> 作为中间件，可以处理相同键下的多个文件。

:octopus: 永远不要将 multer 作为全局中间件使用。



### 应用-保存日志信息

```elm
npm install morgan
```

```javascript
const fs = require('fs');

const express = require('express');
const morgan = require('morgan');

const app = express();

// 参数：写入路径、追加
const writerStream = fs.createWriteStream('./logs/access.log', {
  flags: "a+"
})

app.use(morgan("combined", {stream: writerStream}));

app.get('/home', (req, res, next) => {
  res.end("Hello World");
})

app.listen(8000, () => {
  console.log("express初体验服务器启动成功~");
});
```

:turtle: morgan 的首参代表写入的格式，第二个配置参数接收写入流。



### get请求参数-params/query

```javascript
const express = require('express');

const app = express();

// 解析 params
app.get('/products/:id/:name', (req, res, next) => {
  console.log(req.params);
  res.end("商品的详情数据~");
})

// 解析 query
app.get('/login', (req, res, next) => {
  console.log(req.query);
  res.end("用户登录成功~");
})

app.listen(8000, () => {
  console.log("普通中间件服务器启动成功~");
});
```

```elm
http://localhost:80000/products/1dasdad/lucy
```

```elm
http://localhost:80000/login?username=admin&password=123
```



### 响应结果

```javascript
const express = require('express');
const router = require('./routers/users');

const app = express();

app.get('/login', (req, res, next) => {
  // 设置响应吗
  res.status(204);

  // 设置返回内容，并规定返回格式
  res.json({name: "why", age: 18})
  // 也可以用数组作参
  res.json(["abc", "cba", "abc"]);
});

app.listen(8000, () => {
  console.log("普通中间件服务器启动成功~");
});
```

:whale: 响应的返回值类型只能为 string、Buffer 或 Uint8Array。

> 不设置请求头直接返回时，会被当作字符串处理

```javascript
res.end(JSON.stringify({name: "why", age: 18}));
```

> 其实示例就相当于下面的语法糖。

```javascript
res.type("application/json");
res.end(JSON.stringify({name: "why", age: 18}));
```



### 路由的使用

> 如果将所有逻辑都交给app来处理，会变得非常复杂；通过路由，可以将某个模块（具有关联性）的处理<span style="color: #ff0000">抽离</span>，一个 Router 实例拥有完整的中间件和路由系统，也被称为 mini-app。

```elm
- 项目
  + routers
    - users.js
    - xxx.js
```

```javascript
const express = require('express');
const userRouter = require('./routers/users');

const app = express();

app.use("/users", userRouter);

app.listen(8000, () => {
  console.log("路由服务器启动成功~");
});
```

:ghost: 注册路由的首参传入子路径前缀后，路由部分就不需要再写一遍了。

<span style="backGround: #efe0b9">routers\users.js</span>

```javascript
/**
 * 举个例子:
 *   请求所有的用户信息: get /users
 *   请求所有的某个用户信息: get /users/:id
 *   请求所有的某个用户信息: post /users body {username: passwod:}
 */

const express = require('express');

const router = express.Router();

router.get('/', (req, res, next) => {
  res.json(["why", "kobe", "lilei"]);
});

router.get('/:id', (req, res, next) => {
  res.json(`${req.params.id}用户的信息`);
});

router.post('/', (req, res, next) => {
  res.json("create user success~");
});

module.exports = router;
```



### 作为静态服务器

```javascript
const express = require('express');

const app = express();

app.use(express.static('./build'));

app.listen(8000, () => {
  console.log("路由服务器启动成功~");
});
```

:turtle: 这里的 `./build'` 为文件相对路径。



### 错误处理

```javascript
const express = require('express');

const app = express();

const USERNAME_DOES_NOT_EXISTS = "USERNAME_DOES_NOT_EXISTS";
const USERNAME_ALREADY_EXISTS = "USERNAME_ALREADY_EXISTS";

app.post('/login', (req, res, next) => {
  // 加入在数据中查询用户名时, 发现不存在
  const isLogin = false;
  if (isLogin) {
    res.json("user login success~");
  } else {
    next(new Error(USERNAME_DOES_NOT_EXISTS));
  }
})

app.post('/register', (req, res, next) => {
  // 加入在数据中查询用户名时, 发现不存在
  const isExists = true;
  if (!isExists) {
    res.json("user register success~");
  } else {
    next(new Error(USERNAME_ALREADY_EXISTS));
  }
});

app.use((err, req, res, next) => {
  let status = 400;
  let message = "";
  console.log(err.message);

  switch(err.message) {
    case USERNAME_DOES_NOT_EXISTS:
      message = "username does not exists~";
      break;
    case USERNAME_ALREADY_EXISTS:
      message = "username already exists~"
      break;
    default: 
      message = "NOT FOUND~"
  }

  res.status(status);
  res.json({
    errCode: status,
    errMessage: message
  })
})

app.listen(8000, () => {
  console.log("路由服务器启动成功~");
});
```

:turtle: 可以通过向 next 添加参数，执行后面的错误中间件；

:turtle: 中间件如果接收 4 个参数，会被视为处理错误的中间件。



## Koa

### koa初体验

```elm
npm init -y
```

```elm
npm install koa
```

```javascript
const Koa = require('koa'); // 导出的是一个类

const app = new Koa();

app.use((ctx, next) => {
  // 用于结束响应的内容
  ctx.response.body = "Hello World";
});

app.listen(8000, () => {
  console.log("koa初体验服务器启动成功~");
});
```

:ghost: Express 如果没有结束响应，会保持连接；而 Koa 则会自动返回 Not Found。

:ghost: 首参 context 对象中，有 resquest 和 response 属性。



### 中间件-注册方式

```javascript
const Koa = require('koa');

const app = new Koa();

// use注册中间件
app.use((ctx, next) => {
  if (ctx.request.url === '/login') {
    if (ctx.request.method === 'GET') {
      console.log("来到了这里~");
      ctx.response.body = "Login Success~";
    }
  } else {
    ctx.response.body = "other request~";
  }
});

// 没有提供下面的注册方式
// methods方式: app.get()/.post
// path方式: app.use('/home', (ctx, next) => {})
// 连续注册: app.use((ctx, next) => {
// }, (ctx, next) => {
// })

app.listen(8000, () => {
  console.log("koa初体验服务器启动成功~");
});
```

:ghost: Express 允许用路径、方法等方式注册中间件，但 Koa 不行，它只能用条件判断绝对程序是否执行。

:octopus: Express 一旦结束响应，就不允许再次结束响应。对于 Koa，后面的响应会把前面的<span style="color: #ff0000">覆盖</span>掉。





### 使用路由

```elm
npm install koa-router
```

```javascript
const Koa = require('koa');

const userRouter = require('./router/user');

const app = new Koa();

app.use(userRouter.routes());
app.use(userRouter.allowedMethods());

app.listen(8000, () => {
  console.log("koa路由服务器启动成功~");
});
```

:ghost: 中间件中调用路由实例的 <span style="color: #a50">allowedMethods</span> 方法，可以在通过不支持的方法访问路径时，给出对应提示。

<span style="backGround: #efe0b9">router\user.js</span>

```javascript
const Router = require('koa-router');

// 创建时传入前缀，后面定义方法就不需要子路径了
const router = new Router({prefix: "/users"});

router.get('/', (ctx, next) => {
  ctx.response.body = "User Lists~";
});

router.put('/', (ctx, next) => {
  ctx.response.body = "put request~";
});

module.exports = router;
```



### get请求参数-params/query

```javascript
const Koa = require('koa');

const app = new Koa();

app.use((ctx, next) => {
  console.log(ctx.request.url);
  console.log(ctx.request.query);
  console.log(ctx.request.params); // undefined
  ctx.response.body = "Hello World";
});

app.listen(8000, () => {
  console.log("参数处理服务器启动成功~");
});
```

:octopus: 默认只能获取到 query，拿不到 params

```javascript
const Koa = require('koa');

const app = new Koa();
const Router = require('koa-router');

const userRouter = new Router({prefix: '/users'});

userRouter.get('/:id', (ctx, next) => {
  console.log(ctx.request.params);
  console.log(ctx.request.query);
})

app.use(userRouter.routes());

app.listen(8000, () => {
  console.log("参数处理服务器启动成功~");
});
```

:turtle: 借助路由插件，可以获取到 query 和 params。



### json/urlencoded解析

需要借助第三方库来帮助解析这两种格式。

```elm
npm install koa-bodyparser
```

```javascript
const Koa = require('koa');
const bodyParser = require('koa-bodyparser');

const app = new Koa();

app.use(bodyParser());

app.use((ctx, next) => {
  console.log(ctx.request.body);
  ctx.response.body = "Hello World";
});

app.listen(8000, () => {
  console.log("koa初体验服务器启动成功~");
});
```

:turtle: 在中间件调用 <span style="color: #a50">bodyParser</span> 后，就可以在 `ctx.request.body` 中获取到 json/urlencoded 解析后的结果了。



### form-data解析

```elm
npm install koa-multer
```

```javascript
const Koa = require('koa');
const multer = require('koa-multer');

const app = new Koa();

const upload = multer();

app.use(upload.any());

app.use((ctx, next) => {
  console.log(ctx.req.body);
  ctx.response.body = "Hello World";
});

app.listen(8000, () => {
  console.log("koa初体验服务器启动成功~");
});
```

:octopus: 需要注意，解析后的结果要在 `ctx.req.body` 中才能获取。

:whale: form-data 一般用于文件上传，很少直接通过键值对传递数据。



### form-data上传文件

```javascript
const Koa = require('koa');
const Router = require('koa-router');
const multer = require('koa-multer');

const app = new Koa();
const uploadRouter = new Router({prefix: '/upload'});

const upload = multer({
  dest: './uploads/'
});

uploadRouter.post('/avatar', upload.single('avatar'), (ctx, next) => {
  console.log(ctx.req.file);
  ctx.response.body = "上传头像成功~";
});

app.use(uploadRouter.routes());

app.listen(8000, () => {
  console.log("koa初体验服务器启动成功~");
});
```

:turtle: 借助 <span style="color: #a50">koa-multer</span>，上传文件的方式与 express 类似。



### 响应内容

```javascript
const Koa = require('koa');

const app = new Koa();

app.use((ctx, next) => {
  ctx.response.status = 404;
  ctx.response.body = "Hello Koa~";
});

app.listen(8000, () => {
  console.log("koa初体验服务器启动成功~");
});
```

#### 响应内容的类型

```javascript
// 响应内容也可以是这些
ctx.response.body = "Hello world~"
ctx.response.body = {
  name: "coderwhy",
  age: 18,
  avatar_url: "https://abc.png"
};
ctx.response.body = ["abc", "cba", "nba"];
```

:turtle: 响应主体的类型：string、Buffer、Stream、Object、Array、null；

:turtle: 如果 `response.status` 尚未设置，Koa会自动将状态设置为 200 或 204。

#### 设置响应内容的其它方式

```javascript
app.use((ctx, next) => {
  ctx.status = 404;
  ctx.body = "Hello Koa~";
});
```

:turtle: 之所以能够设置成功，是因为内部的代理机制，将部分属性特殊处理了。



### 部署静态资源

```elm
npm install koa-static
```

```javascript
const Koa = require('koa');
const staticAssets = require('koa-static');

const app = new Koa();

app.use(staticAssets('./build'));

app.listen(8000, () => {
  console.log("koa初体验服务器启动成功~");
});
```

:turtle: 这里的 `./build'` 为文件相对路径。



### 错误处理

```javascript
const Koa = require('koa');

const app = new Koa();

app.use((ctx, next) => {
  const isLogin = false;
  if (!isLogin) {
    ctx.app.emit('error', new Error("您还没有登录~"), ctx);
  }
});

app.on('error', (err, ctx) => {
  ctx.status = 401;
  ctx.body = err.message;
})

app.listen(8000, () => {
  console.log("koa初体验服务器启动成功~");
});
```

:whale: 可以通过 `ctx.app` 直接获取到 app 实例，对于用路由等方式开发时，经常需要用到。



## Koa对比Express

- Express 更加地完整，可以方便地限制中间件的范围，也内置了很多功能；
- Koa 只包含核心功能，不会限制中间件，甚至连 get、post 方法都没有提供；

- 它们的核心都是<span style="color: #ff0000">中间件</span>，但执行机制不同。



### express实现-同步数据

**需求**

- 在middleware1中，在req.message中添加一个字符串 aaa；
- 在middleware2中，在req.message中添加一个 字符串bbb；
- 在middleware3中，在req.message中添加一个 字符串ccc；
- 当所有内容添加结束后，在middleware1中，通过res返回最终的结果；

```javascript
const express = require('express');

const app = express();

const middleware1 = (req, res, next) => {
  req.message = "aaa";
  next();
  res.end(req.message);
}

const middleware2 = (req, res, next) => {
  req.message += "bbb";
  next();
}

const middleware3 = (req, res, next) => {
  req.message += "ccc";
}

app.use(middleware1, middleware2, middleware3); // 注册三个中间件

app.listen(8000, () => {
  console.log("服务器启动成功~");
})
```

:ghost: 可以将 express 的 `next()` 视作为执行下一个中间件：执行栈需要弹出最顶层的函数后，才执行栈底的函数。



### express实现-异步数据

```elm
npm install axios
```

```javascript
/******* 错误的结果 *********/
const express = require('express');
const axios = require('axios');

const app = express();

const middleware1 = async (req, res, next) => {
  req.message = "aaa";
  await next();
  res.end(req.message);
}

const middleware2 = async (req, res, next) => {
  req.message += "bbb";
  await next();
}

const middleware3 = async (req, res, next) => {
  const result = await axios.get('http://123.207.32.32:9001/lyric?id=167876');
  req.message += result.data.lrc.lyric;
}

app.use(middleware1, middleware2, middleware3);

app.listen(8000, () => {
  console.log("服务器启动成功~");
})
```

:octopus:由于 express 中的 `next()` 是同步执行的，内部遇到异步方法也不会暂停，没法将其写成期约的形式。



### koa实现-同步数据

```javascript
const Koa = require('koa');

const app = new Koa();

const middleware1 = (ctx, next) => {
  ctx.message = "aaa";
  next();
  ctx.body = ctx.message;
}

const middleware2 = (ctx, next) => {
  ctx.message += "bbb";
  next();
}

const middleware3 = (ctx, next) => {
  ctx.message += "ccc";
}

app.use(middleware1);
app.use(middleware2);
app.use(middleware3);

app.listen(8000, () => {
  console.log("服务器启动成功~");
})
```

:trident: 这个过程与 express 的实现是相似的。



### koa实现-异步数据

```javascript
const Koa = require('koa');
const axios = require('axios');

const app = new Koa();

const middleware1 = async (ctx, next) => {
  ctx.message = "aaa";
  await next();
  ctx.body = ctx.message;
}

const middleware2 = async (ctx, next) => {
  ctx.message += "bbb";
  await next();
}

const middleware3 = async (ctx, next) => {
  const result = await axios.get('http://123.207.32.32:9001/lyric?id=167876');
  ctx.message += result.data.lrc.lyric;
  next();
}

app.use(middleware1);
app.use(middleware2);
app.use(middleware3);

app.listen(8000, () => {
  console.log("服务器启动成功~");
})
```

:ghost: koa 中调用的 `next()` 会返回一个 promise，利用这一点可以很方便地控制时序。
