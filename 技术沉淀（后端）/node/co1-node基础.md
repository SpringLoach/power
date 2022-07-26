## 基本概念

### 运行JS

> 类似与在浏览器的控制台，我们可以借助 Node 环境执行一些 JavaScript 代码。

命令行

```elm
- node
- let a = 2
- let b = 3
- a + b
```

![image-20220617213301206](.\img\命令行1)



### 运行JS文件

> 浏览器中可以执行 JavaScript 脚本，Node 也可以运行。

```elm
- srcName 
  + demo.js
```

<span style="backGround: #efe0b9">srcName/demo.js</span>

```javascript
const a = 3;
const b = 6;
console.log(a * b);
setTimeout(() => {
  console.log(666)
}, 1000)
```

在 <span style="backGround: #efe0b9">srcName </span>下

```elm
node demo.js
```



### 传递参数

<span style="backGround: #efe0b9">demo.js</span>

```javascript
// process.argv 是个数组，首参为 Node 路径，第二个参数为文件的绝对路径，剩余参数由外部传递进来
console.log(process.argv)
```

<span style="backGround: #efe0b9">命令行</span>

```elm
node demo.js hellow name=master
```



### 全局对象

#### 与浏览器的差异

| 环境        | 部分全局对象     |
| ----------- | ---------------- |
| 浏览器      | window、document |
| Node        | global、process  |
| 浏览器/Node | console          |

:whale: 不同于浏览器，在顶级的 var 声明，不会使变量挂载到全局对象上，这与模块化有关。



#### 特殊的全局对象

> 被归纳到文档的全局对象中，它们可以在模块中任意使用，但是在命令行交互中是不可以使用。

__<span style="color: #f7534f;font-weight:600">包括</span>  __

- \_\_dirname、 __filename、
- exports、module、require()

```javascript
/* 所在文件夹 - 获取当前文件所在的路径 */
console.log(__dirname)
// D:\项目相关\node\src

/* 所在文件 - 获取当前文件所在的路径和文件名称 */
console.log(__filename)
// D:\项目相关\node\src\demo.js
```



#### 常见的全局对象

| 名称       | 描述                                                    |
| ---------- | ------------------------------------------------------- |
| process    | 提供进程相关的信息：如Node的运行环境、参数信息          |
| console    | 简单的调试控制器                                        |
| 定时器函数 | setTimeout、setInterval、setImmediate、process.nextTick |
| global     | 全局对象，其它的全局对象都有挂载到它上面                |

:whale: 执行 Node 相当于开启了一个进程，process 对象会反映相关的信息。



## 模块化开发

### CommonJS

> Node 实现 CommonJS 的本质就是对象的引用赋值。

#### export

<span style="backGround: #efe0b9">bar.js</span>

```javascript
const name = 'demo';
function hey(e) {
  console.log('hey' + e)
}

export.name = name
export.hey = hey
```

:whale: 每个模块都有 exports 属性，默认为 `{}`

<span style="backGround: #efe0b9">main.js</span>

```javascript
// 相当于 bar = exports
const bar = require('./bar');

// 故也可以用结构写法
const { name, age } = require('./bar');
```

:turtle: 引入的其实是 exports 对象的地址，故如果在引入文件中修改它的属性，这可以影响到导出文件中的对象。



#### module.exports

内部机制帮助我们做了这么一件事

```javascript
// 在模块的一开始进行赋值
module.exports = export
```

:whale: 对于每个 js 文件来说，其内部都会调用 `new Model()` 来生成一个实例 `module`。

**情况一**

> 没有对 module.exports 进行直接赋值，此时导出值即为 export。

**情况二**

> 进行重新赋值，导出值将会是另一份内存地址（区别于 export 所在的内存地址）

```javascript
module.exports = {}
```

:turtle: 如果 module.exports 不再引用 export 对象了，那么（在导出文件中）修改 export 也就没有意义了。



#### require

> require是一个函数(方法)，用于引入其它模块中导出的对象。

##### 查找路径

<span style="color: #ff0000">情况一</span>

X是一个核心模块，比如path、http。那么直接返回核心模块，并且停止查找。

```javascript
require(X)
```

<span style="color: #ff0000">情况二</span>

X不是一个核心模块，会沿着路径找 <span style="color: #a50">node_modules</span> 文件，找不到会去上级文件找，直至顶层。

```reStructuredText
require(X)
```

:whale: 这些路径可以通过 <span style="color: #a50">module.paths</span> 查看。

<span style="color: #ff0000">情况三</span>

X前带有路径，即以 `./` 或 `../` 或 `/`（根目录）开头。

```less
第一步：将X当做一个文件在对应的目录下查找；
  1.如果有后缀名，按照后缀名的格式查找对应的文件
  2.如果没有后缀名，会按照如下顺序：
    (1). 直接查找文件X
    (2). 查找X.js文件
    (3). 查找X.json文件
    (4). 查找X.node文件
第二步：没有找到对应的文件，将X作为一个目录
  查找目录下面的index文件
    (1). 查找X/index.js文件
    (2). 查找X/index.json文件
    (3). 查找X/index.node文件
如果没有找到，那么报错：not found
```



##### 特性

1. 引入即执行

   <span style="backGround: #efe0b9">bar.js</span>

   ```javascript
   console.log(123)
   ```

   <span style="backGround: #efe0b9">main.js</span>

   ```javascript
   require(./bar); // 123
   ```

2. 加载过程是同步的

   ```javascript
   require(./bar);
   console.log('afterBar')
   ```

3. 多次被引入，只执行一次

   <span style="backGround: #efe0b9">main.js</span>

   ```javascript
   require(./bar);
   ```

   <span style="backGround: #efe0b9">foo.js</span>

   ```javascript
   require(./bar);
   ```

4. 循环引用时，采用深度优先算法遍历图

   ```elm
   main -> aaa -> ccc -> ddd -> eee -> bbb
   ```

![image-20220619214256012](.\img\遍历图)



#### CommonJS的缺点

由于 CommonJS 加载模块是同步的，意味着只有等到对应的模块加载完毕，当前模块中的内容才能被运行。

如果是在服务器中，由于加载的都是本地文件，这不会有什么问题；但浏览器需要先下载再加载运行，会阻塞后面的 js 代码。

我们可以放心地在 webpack 中使用 CommonJS，它会将我们的代码转成浏览器可以直接执行的代码。



### ES Module

> 不同于 CommonJS，ES 中使用的 export 和 import 是关键字，而非函数（require）。

#### 导出

```javascript
// 方式一：正常地加上 export 前缀
export const a = 2;
export const b = function() {}

// 方式二：在 {} 中统一导出，注意这个 {} 是语法而非对象
export { a, b }

// 方式三：导出时起别名
export {
  a as A,
  b as B
}
```

#### 导入

```javascript
// 方式一：
import { a, b } from 'bar.js';

// 方式二：导入时起别名
import { a as A, b as B } from 'bar.js';

// 方式三：全部导入到一个对象上
import * as moduleA from 'bar.js';
console.log(moduleA.a)
```



#### default用法

默认导出 export 时可以不需要指定名字，在导入时可以自己来指定名字。

```javascript
export default function() {
  console.log('格式化');
}
```

```javascript
import format from './bar.js'
```

:ghost: 在一个模块中，只能有一个默认导出。



#### 导出和导入结合

在开发和封装一个功能库时，通常会将暴露的所有接口放到一个文件中。方便指定统一的接口规范，也方便阅读。

```javascript
export { name, age } from './bar.js'
```

:whale: 通常将  <span style="backGround: #efe0b9">index.js</span> 作为该出口。



### 两者的差异

#### 解析与运行

```javascript
let condition = true;
if (condition) {
  // 写法一
  import format from './bar.js'
  // 写法二
  require('bar')
  console.log('next')
  // 写法三
  import(./bar.js)
}
```

| --     | 解析                                                         |
| ------ | ------------------------------------------------------------ |
| 写法一 | 会报错：需要在解析阶段分析所有依赖，但这里只有到运行阶段才识别到它 |
| 写法二 | 可行，为函数，同步加载，会阻塞                               |
| 写法三 | 可行，为函数，返回期约                                       |



#### 导出值的差异

> 在 ES 中，导出值被记录到 <span style="color: #a50">模块环境记录</span> 中，在导入文件中获取到的都是最新值。
>
> 同样的操作在 CommonJS 中，会输出 1，因为它导出的是个对象，而 1 是个常量值。

```javascript
let a = 1;

setTimeout(() => {
  a = 2
}, 1000)

export { a }
```

```javascript
import { a } from 'bar.js'

setTimeout(() => {
  console.log(a)  // 2
}, 2000)
```



在 ES 中，导入文件从 <span style="color: #a50">模块环境记录</span> 获取到的属性是 `const` 声明的，不可以再次赋值。

```javascript
let a = 1;

setTimeout(() => {
  console.log(a)  // 报错
}, 2000)

export { a }
```

```javascript
import { a } from 'bar.js'

setTimeout(() => {
 a = 2
}, 1000)
```



### 两者的交互

通常情况下，CommonJS 不能加载 ES Module

- 因为 CommonJS 是同步加载的，但是 ES Module 必须经过静态分析等，无法在这个时候执行 JavaScript 代码。Node 中不支持。



多数情况下，ES Module 可以加载 CommonJS

-  ES Module 在加载 CommonJS 时，会将其 module.exports 导出的内容作为 default 导出方式来使用。
- 较低版本的 Node 是不支持的。



## 常见的内置模块

### path

在不同的操作系统上，路径分隔符可能是不一样的，使用 path 模块处理路径，可以实现动态支持。

```javascript
/* 获取路径的信息 */
const filePath = '/User/demo/bar.txt';

// 获取文件的父文件夹
path.dirname(filePath); // /User/demo
// 获取文件名
path.basename(filePath); // bar.txt
// 获取文件扩展名
path.extname(filePath); // txt

/* 拼接路径 */
// ①
const basePath = '/User';
const filename = 'bar.txt';

path.join(basePath, filename)     // /User/bar.txt
path.resolve(basePath, filename)  // /User/bar.txt

// ②
const basePath = 'User';
const filename = 'bar.txt';

path.join(basePath, filename)     // User/bar.txt
path.resolve(basePath, filename)  // /aa/bb/cc/dd/User/bar.txt

// ③ 与 ② 等价
const basePath = './User';
const filename = 'bar.txt';

path.join(basePath, filename)     // User/bar.txt
path.resolve(basePath, filename)  // /aa/bb/cc/dd/User/bar.txt

// ④ 会跳过一级
const basePath = '../User';
const filename = 'bar.txt';

path.join(basePath, filename)     // ../User/bar.txt
path.resolve(basePath, filename)  // /aa/bb/cc/User/bar.txt

// ⑤ 第二个路径以 / 开头
const basePath = '../User';
const filename = '/bar.txt';

path.join(basePath, filename)     // ../User/bar.txt
path.resolve(basePath, filename)  // /bar.txt
```

  :turtle: <span style="color: #a50">path.join</span> 用于路径拼接。

  :turtle: <span style="color: #a50">path.resolve</span> 将某个文件和文件夹拼接，它会判断我们拼接的路径前面是否有 / 或 ../或 ./；如果有表示是一个绝对路径，会返回对应的拼接路径；如果没有，那么会和当前执行文件所在的文件夹进行路径的拼接。



### fs

#### 三种操作方式

> 案例: 读取文件的信息。

```javascript
const fs = require('fs');

const filepath = "./abc.txt";

// 1.方式一: 同步操作
const info = fs.statSync(filepath);
console.log("后执行的代码");

// 2.方式二: 异步操作
fs.stat(filepath, (err, info) => {
  if (err) {
    console.log(err);
    return;
  }
  console.log(info);  // 包含文件大小，创建时间等信息
  console.log(info.isFile()); // 是否为文件
  console.log(info.isDirectory()); // 是否为文件夹
});
console.log("先执行的代码");

// 3.方式三: Promise
fs.promises.stat(filepath).then(info => {
  console.log(info);
}).catch(err => {
  console.log(err);
});
```

:whale: 方法一般会有前两种方式，第三种方式是后面出的，实践中用方法二的比较多。



#### 文件描述符

> 不同的系统中都会为打开的文件分配一个简单的数字标识符，供文件系统操作来标识和使用。

```javascript
const fs = require('fs');

// 用于分配新的文件描述符
fs.open("./abc.txt", (err, fd) => {
  if (err) {
    console.log(err);
    return;
  }

  // 通过描述符去获取文件的信息
  fs.fstat(fd, (err, info) => {
    console.log(info);
  })
})
```

:whale: Node.js 抽象出操作系统之间的特定差异，并为所有打开的文件分配一个数字型的文件描述符。



#### 文件的读写

```javascript
const fs = require('fs');

// 1.文件写入
const content = "你好啊,李银河";

// 末尾追加
fs.writeFile('./abc.txt', content, {flag: "a"}, err => {
  console.log(err);
});
// 覆写
fs.writeFile('./abc.txt', content, err => {
  console.log(err);
});

// 2.文件读取
fs.readFile("./abc.txt", {encoding: 'utf-8'}, (err, data) => {
  console.log(data);
});
```

对于文件写入，可以传入 [flag](https://nodejs.org/dist/latest-v14.x/docs/api/fs.html) 决定写入方式。

对于文件读取，传入的第二个可选配置项为编码类型。



#### 文件夹操作

```javascript
const fs = require('fs');
const path = require('path');

// 1.创建文件夹
const dirname = './why';
if (!fs.existsSync(dirname)) {
  fs.mkdir(dirname, err => {
    console.log(err);
  });
}

// 2.1 读取文件夹中的文件
fs.readdir(dirname, (err, files) => {
  console.log(files);
});

// 2.2 读取文件夹中的所有文件(递归)
function getFiles(dirname) {
  // 传入的配置项，文件项将不再是字符串，且其上存在 isDirectory 等方法
  fs.readdir(dirname, { withFileTypes: true }, (err, files) => {
    for (let file of files) {
      if (file.isDirectory()) {
        const filepath = path.resolve(dirname, file.name);
        getFiles(filepath);
      } else {
        console.log(file.name);
      }
    }
  });
}
getFiles(dirname);

// 3.重命名
fs.rename("./why", "./kobe", err => {
  console.log(err);
})
```

**文件夹的复制**

![image-20220620233410252](./img\文件夹的复制)



### events

#### 基本用法

```javascript
const EventEmitter = require("events");

// 1.创建发射器
const emitter = new EventEmitter();

// 2.监听某一个事件
// 别名：emitter.addListener
emitter.on('click', (args) => {
  console.log("监听1到click事件", args);
})

// 2.1 命名事件方便后续移除
const listener2 = (args) => {
  console.log("监听2到click事件", args);
}
emitter.on('click', listener2)

// 3.发出一个事件
setTimeout(() => {
  emitter.emit("click", "dos");
  // 移除特定的事件监听
  emitter.off("click", listener2);
  emitter.emit("click", "dos");
}, 2000);
```



#### 获取信息

| --                             | 描述                                                         |
| ------------------------------ | ------------------------------------------------------------ |
| emitter.eventNames()           | 返回当前 EventEmitter 实例注册的事件字符串数组               |
| emitter.getMaxListeners()      | 返回当前 EventEmitter 实例的最大监听器数量，可以通过setMaxListeners() 来修改，默认是10 |
| emitter.listenerCount(“click”) | 返回当前 EventEmitter 实例某一个事件名称，监听器的个数       |
| emitter.listeners(“click”)     | 返回当前 EventEmitter 实例某个事件监听器上所有的监听器数组(能带命名) |



#### 方法补充

| --                                      | 描述                                   |
| --------------------------------------- | -------------------------------------- |
| emitter.once(eventName, listener)       | 事件监听一次                           |
| emitter.prependListener()               | 将监听事件添加到最前面                 |
| emitter.prependOnceListener()           | 将监听事件添加到最前面，但是只监听一次 |
| emitter.removeAllListeners([eventName]) | 移除所有的监听器                       |

:whale: 包括官方文档在内，方法描述中的 `[]` 一般表示可选。



## npm

### package.json

> 管理各种依赖包的地方。

**生成文件**

```elm
npm init
```

```elm
npm init -y
```



#### main属性

 设置程序的入口。

作为依赖（包）使用时会用到，这个入口和webpack打包的入口（即开发前端项目的入口）并不冲突。

```javascript
const axios = require('axios')
```

> 实际上是找到对应的 package.json 中的 main 属性查找文件。



### 全局安装

- 通常使用npm全局安装的包都是一些工具包：yarn、webpack等；
- 并不是类似于 axios、express、koa等库文件；
- 所以全局安装了之后并不能让我们在所有的项目中使用 axios等库。



### 缓存策略

> 从npm5开始，npm支持缓存策略，在性能上有了更大的提升。

![image-20220622094604986](.\img\缓存策略)





### 使用本地命令

> 当我们同时安装了全局和局部模块（如webpack）时。

#### 应用全局

> 一般命令行工具才会全局安装 

```elm
webpack --version
```



#### 应用本地

1. 通过具体的路径指向 `node_modules`  下对应的命令

   ```elm
   ./node_modules/.bin/webpack --version
   ```

2. 在 package.json 中配置命令（优先找局部的）

   ```javascript
   "scripts": {
     "webpack": "webpack --version"
   }
   ```

3. 使用 npx

   ```elm
   npx webpack --version
   ```



## Buffer

### 数据的二进制

- 计算机的所以内容，如文字、图片、音频、视频，最终都是使用二进制来表示的。

- 在前端，可以用 JavaScript 可以处理直观的数据，如字符串，但对图片的支持很差，它只是负责将图片地址告诉浏览器，让浏览器渲染该图片。前端很少和二进制打交道。

- 对于服务端，经常需要处理图片数据，或是在TCP连接中将数据转成字节再进行传入，并且需要知道传输字节的大小（客服端需要根据大小来判断读取多少内容）。



### Buffer和二进制的关系

- Node 在全局提供了一个 Buffer 类。

- 可以将 <span style="color: #a50">Buffer</span> 看成是一个<span style="color: #ff0000">存储二进制</span>的数组，它的每个元素可以保存8位二进制（对应一个<span style="color: #ff0000">字节</span>）。

### 存储字母

```javascript
const message = "Hello";

// 创建方式一（过时）
const buffer = new Buffer(message);

// 创建方式二
const buffer = Buffer.from(message);

// 这里输出时，对应十六进制
console.log(buffer); // <Buffer 48 65 6c 6c 6f>  每个字符占用一个字节
```

若在初始化  <span style="color: #a50">Buffer</span> 时，提供参数，会将其自动编码后进行填充。



### 存储中文

```javascript
const message = "你好啊";

// 对中文进行编码: utf8
const buffer = Buffer.from(message);
console.log(buffer); // 每个中文占用三个字节

// 对字节进行解码: utf8
console.log(buffer.toString());


// 使用 utf16le 编码
const buffer2 = Buffer.from(message, 'utf16le');
console.log(buffer2); // 每个中文占用两个字节
console.log(buffer2.toString());             // 解码得到的结果是不正确的
console.log(buffer2.toString('utf16le'));    // 解码得到的结果是正确的
```

> 事实上创建Buffer时，不会频繁的向操作系统申请内存，它会默认先申请 8 * 1024 字节大小的内存（8kb）



### 通过alloc创建

```javascript
// 初始化位数
const buffer = Buffer.alloc(8);
console.log(buffer); // <Buffer 00 00 00 00 00 00 00 00>

buffer[0] = 88;
buffer[1] = 0x88;
console.log(buffer); // <Buffer 58 88 00 00 00 00 00 00>
```

<span style="backGround: #efe0b9">foo.txt</span>

```
王大妞
```

```javascript
const fs = require('fs');

fs.readFile("./foo.txt", (err, data) => {
  console.log(data); // <Buffer e7 8e 8b e5 a4 a7 e5 a6 9e>
  console.log(data.toString()); // 王大妞
})

fs.readFile("./foo.txt", {encoding: 'utf-8'}, (err, data) => {
  console.log(data); // 王大妞
})
```



### 操作图片

```javascript
const fs = require('fs');

fs.readFile("./bar.png", (err, data) => {
  console.log(data) // <Buffer e7 50 ...>
  
  // 拷贝：将 buffer（字节数组）写入到另一个文件
  fs.writeFile("./foo.png", data, err => {
    console.log(err)
  })
})
```

#### sharp

> 帮助 Node.js 处理图片的模块。

```elm
npm install sharp
```

```javascript
const sharp = require('sharp')

// 调整大小，输出图片
sharp('./bar.png')
  .resize(200, 200)
  .toFile('./baz.png')
  
// 转化为Buffer后输出
sharp('./bar.png')
  .resize(300, 300)
  .toBuffer()
  .then(data => {
    fs.writeFile('./bax.png', data, err => console.log(err));
  })
```



## Stream

> 我们可以直接通过 readFile 或者 writeFile 方式读写文件，但无法<span style="color: #ff0000">控制细节</span>：如从哪里开始读取、哪里结束、一次读多少字节、暂停读取等。

### 读取-readable

```javascript
const fs = require('fs');

/* 传统的方式 */
fs.readFile('./foo.txt', (err, data) => {
  console.log(data);
});

/* 流的方式读取 */
const reader = fs.createReadStream("./foo.txt", {
  start: 3,        // 文件读取开始的位置
  end: 10,         // 文件读取结束的位置
  highWaterMark: 2 // 一次读取字节的长度，默认是64kb
});

// 数据读取的过程
reader.on("data", (data) => {
  console.log(data);

  // 每读取一次暂停一秒，实现断续读取的效果
  reader.pause();

  setTimeout(() => {
    reader.resume();
  }, 1000);
});

reader.on('open', () => {
  console.log("文件被打开");
})

reader.on('close', () => {
  console.log("文件被关闭");
})
```

<span style="color: #f7534f;font-weight:600">open</span> 打开文件时触发；

<span style="color: #f7534f;font-weight:600">data</span> 读取数据时触发，每进行一次读取，都会执行一次；

<span style="color: #f7534f;font-weight:600">close</span> 关闭文件时触发（读取完毕后<span style="color: #ff0000">自动关闭</span>）



### 写入-writable

```javascript
const fs = require('fs');

/* 传统方式写入 */
fs.writeFile("./bar.txt", "Hello Stream", {flag: "a"}, (err) => {
  console.log(err);
});

/* 流的方式写入 */
const writer = fs.createWriteStream('./bar.txt', {
  flags: "r+",
  start: 4
});

// 写入内容
writer.write("你好啊", (err) => {
  if (err) {
    console.log(err);
    return;
  }
  console.log("写入成功");
});

// 写入内容
writer.write("李银河", (err) => {
  console.log("第二次写入");
})

// 写入内容并关闭文件（关闭流）
writer.end("Hello World");

writer.on('close', () => {
  console.log("文件被关闭");
})
```

<span style="color: #f7534f;font-weight:600">close</span> 关闭文件时触发，需要<span style="color: #ff0000">手动触发</span>。

> 流的关闭也可以用下面的方法，但无法在最后写入内容。

```javascript
writer.close();
```



### 拷贝-pipe方法

```javascript
const fs = require('fs');

/* 传统的写法 */
fs.readFile('./bar.txt', (err, data) => {
  fs.writeFile('./baz.txt', data, (err) => {
    console.log(err);
  })
})

/* Stream的写法 */
const reader = fs.createReadStream("./foo.txt");
const writer = fs.createWriteStream('./foz.txt');

reader.pipe(writer);
writer.close(); // 注意关闭文件
```

