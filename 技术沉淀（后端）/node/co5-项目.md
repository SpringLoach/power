## 项目框架搭建

**初始化包管理**

```elm
npm init -y
```

**基于Koa开发**

```elm
npm install koa
```

```elm
npm install nodemon -D
```

**配置快捷键**

<span style="backGround: #efe0b9">package.json</span>

```json
"scripts": {
  "start": "nodemon ./src/main.js"
}
```

<span style="backGround: #efe0b9">目录结构</span>

```elm
- src
  + app    		// 全局相关
  + controller  // 控制器
  + router      // 路由
  + service     // 数据库
  + utils       // 工具
  + main.js     // 入口
```

<span style="backGround: #efe0b9">main.js</span>

```javascript
const Koa = require('koa');

const app = new Koa();

app.listen(8000, () => {
  console.log(`服务器启动成功~`);
});
```



### 将配置信息写入环境变量

```elm
- 项目
  + src
    - app
      + config.js
      + index.js
    - main.js
  + .env
```

**将配置信息抽离**

<span style="backGround: #efe0b9">src\app\index.js</span>

```javascript
const Koa = require('koa');

const app = new Koa();

module.exports = app;
```

**编写环境变量文件**

<span style="backGround: #efe0b9">.env</span>

```elm
APP_PORT=8000
```

:turtle: 需要将该文件添加到 `.gitignore` 中，每个设备的配置应该是不同的，且保密的。

**配置环境变量**

```elm
npm install dotenv
```

:turtle: 借助该库可以将 `.env` 中的配置添加到环境变量中

<span style="backGround: #efe0b9">src\app\config.js</span>

```javascript
const dotenv = require('dotenv');

dotenv.config();

module.exports = {
  APP_PORT
} = process.env;
```

**重构入口文件**

<span style="backGround: #efe0b9">main.js</span>

```javascript
const app = require('./app');
const config = require('./app/config');

app.listen(config.APP_PORT, () => {
  console.log(`服务器在${config.APP_PORT}端口启动成功~`);
});
```



### 配置路由-组织架构

```elm
npm install koa-router
```

#### 添加路由（预封装）

<span style="backGround: #efe0b9">src\app\index.js</span>

> 实际开发中，要将下面的逻辑进行抽离。

```javascript
const Koa = require('koa');

const Router = require('koa-router');

const app = new Koa();

// 创建路由实例，添加处理
const userRouter = new Router({prefix: '/users'});

userRouter.post('/', (ctx, next) => {
  ctx.body = "创建用户成功"；
})

// 注册路由
app.use(userRouter.routes());
 // 对不支持的方法提醒
app.use(userRouter.allowedMethods());

module.exports = app;
```

#### 封装架构

```elm
- 项目
  + src
    - app
      + index.js
    - controller            // 实现处理逻辑
      + user.controller.js
    - router                // 抽离出对路由的配置
      + user.router.js      // 具体业务层（只负责注册接口，不实现处理逻辑）
    - service               // 补充处理逻辑（补充实现查询数据的部分）
      +user.service.js
```

#### 注册接口

<span style="backGround: #efe0b9">src\router\user.router.js</span>

>  只负责注册接口，不实现处理逻辑

```javascript
const Router = require('koa-router');
const {
  create
} = require('../controller/user.controller');

const userRouter = new Router({prefix: '/users'});

userRouter.post('/', create);

module.exports = userRouter;
```

#### 实现处理逻辑

<span style="backGround: #efe0b9">src\controller\user.controller.js</span>

>  实现处理逻辑，但不会去实现查询数据的部分

```javascript
const userService = require('../service/user.service');

class UserController {
  async create(ctx, next) {
    // 获取用户请求传递的参数
    const user = ctx.request.body;
  
    // 查询数据
    const result = await userService.create(user);
  
    // 返回数据
    ctx.body = result;
  }
}

module.exports = new UserController();
```

#### 实现查询逻辑

<span style="backGround: #efe0b9">src\service\user.service.js</span>

> 实现查询数据的部分

```javascript
class UserService {
  async create(user) {
    console.log("将user存储到数据库中", user);
    // 将user存储到数据库中
    return "创建用户成功";
  }
}

module.exports = new UserService();
```

#### 添加解析JSON

<span style="backGround: #efe0b9">src\app\index.js</span>

```elm
npm install koa-bodyparser
```

```javascript
const Koa = require('koa');
const bodyParser = require('koa-bodyparser');
const userRouter = require('../router/user.router');

const app = new Koa();

app.useRoutes = useRoutes;

app.use(bodyParser()); // 添加，用于解析JSON
app.use(userRouter.routes());
app.use(userRouter.allowedMethods());

module.exports = app;
```

:ghost: `bodyParser()` 需要在注册路由前调用，才能保证生效。



## 用户表

#### **创建用户表**

```sql
CREATE TABLE `user` (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(30) NOT NULL UNIQUE,
  password VARCHAR(50) NOT NULL,
  createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```



#### 连接数据库

```sql
npm install mysql2 
```

```elm
- src
  + app
    - databse.js // 数据库连接相关
```

**添加数据库登录信息到环境变量**

<span style="backGround: #efe0b9">.env</span>

```elm
APP_PORT=8000

MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_DATABASE=xxx
MYSQL_USER=root
MYSQL_PASSWORD=xxx
```

<span style="backGround: #efe0b9">src\app\config.js</span>

```javascript
const dotenv = require('dotenv');

dotenv.config();

module.exports = {
  APP_PORT,
  MYSQL_HOST,
  MYSQL_PORT,
  MYSQL_DATABASE,
  MYSQL_USER,
  MYSQL_PASSWORD,
} = process.env;
```

<span style="backGround: #efe0b9">src\app\database.js</span>

```javascript
const mysql = require('mysql2');

const config = require('./config');

const connections = mysql.createPool({
  host: config.MYSQL_HOST,
  port: config.MYSQL_PORT,
  database: config.MYSQL_DATABASE,
  user: config.MYSQL_USER,
  password: config.MYSQL_PASSWORD
});

connections.getConnection((err, conn) => {
  conn.connect((err) => {
    if (err) {
      console.log("连接失败:", err);
    } else {
      console.log("数据库连接成功~");
    }
  })
});

module.exports = connections.promise(); // 直接导出它的期约形式，供其它地方使用
```

**添加到入口以实现加载**

<span style="backGround: #efe0b9">main.js</span>

```javascript
require('./app/database');
```



#### 实现添加账号记录

<span style="backGround: #efe0b9">src\service\user.service.js</span>

```javascript
const connection = require('../app/database'); // 导入的是期约形式

class UserService {
  // 创建账号，插入到数据库
  async create(user) {
    const { name, password } = user;
    const statement = `INSERT INTO user (name, password) VALUES (?, ?);`;
    const result = await connection.execute(statement, [name, password]);

    return result;
  }
}

module.exports = new UserService();
```



### 非空校验

```elm
- src
  + app
    - error-handle.js // 错误事件处理
    - index.js        // 配置服务器实例
  + constants
    - error-types.js  // 错误常量
  + middleware		  // 实现中间件逻辑
    - user.middleware.js
```

#### 添加校验中间件

<span style="backGround: #efe0b9">src\router\user.router.js</span>

```javascript
const Router = require('koa-router');
const {
  create
} = require('../controller/user.controller');
const {
  verifyUser
} = require('../middleware/user.middleware');

const userRouter = new Router({prefix: '/users'});

userRouter.post('/', verifyUser, create); // 添加一个校验中间件

module.exports = userRouter;
```

:point_down: 校验中间件的逻辑在其它地方实现。

<span style="backGround: #efe0b9">src\middleware\user.middleware.js</span>

```javascript
const errorTypes = require('../constants/error-types');

const verifyUser = async (ctx, next) => {
  // 1.获取用户名和密码
  const { name, password } = ctx.request.body;

  // 2.判断用户名或者密码不能空
  if (!name || !password) {
    const error = new Error(errorTypes.NAME_OR_PASSWORD_IS_REQUIRED);
    return ctx.app.emit('error', error, ctx); // 触发事件（错误事件）
  }

  // 3.判断这次注册的用户名是没有被注册过

  await next(); // 不执行这一步的话，就不会执行下一个中间件
}

module.exports = {
  verifyUser
}
```

:point_down: 将错误类型定义为常量，并保存在其它文件。

#### 保存错误常量

<span style="backGround: #efe0b9">src\constants\error-types.js</span>

```javascript
const NAME_OR_PASSWORD_IS_REQUIRED = 'name_or_password_is_required';

module.exports = {
  NAME_OR_PASSWORD_IS_REQUIRED
}
```

#### 注册错误事件

<span style="backGround: #efe0b9">src\app\index.js</span>

```javascript
const Koa = require('koa');
const bodyParser = require('koa-bodyparser');
const errorHandler = require('./error-handle'); // 添加
const useRoutes = require('../router');

const app = new Koa();

app.useRoutes = useRoutes;

app.use(bodyParser());
app.useRoutes();
app.on('error', errorHandler); // 添加

module.exports = app;
```

#### 处理错误事件

<span style="backGround: #efe0b9">src\app\error-handle.js</span>

```javascript
const errorTypes = require('../constants/error-types');

const errorHandler = (error, ctx) => {
  let status, message;

  switch (error.message) {
    case errorTypes.NAME_OR_PASSWORD_IS_REQUIRED:
      status = 400; // Bad Request
      message = "用户名或者密码不能为空~";
      break;
    default:
      status = 404;
      message = "NOT FOUND";
  }

  ctx.status = status;
  ctx.body = message;
}

module.exports = errorHandler;
```



### 账号重复校验

> 相关逻辑可以在校验中间件中补充。

#### 实现账号校验逻辑

<span style="backGround: #efe0b9">src\service\user.service.js</span>

```javascript
const connection = require('../app/database');

class UserService {
  // 插入记录
  async create(user) {
    const { name, password } = user;
    const statement = `INSERT INTO user (name, password) VALUES (?, ?);`;
    const result = await connection.execute(statement, [name, password]);

    return result[0];
  }

  // 查询记录-防重（添加）
  async getUserByName(name) {
    const statement = `SELECT * FROM user WHERE name = ?;`;
    const result = await connection.execute(statement, [name]);

    return result[0];
  }
}

module.exports = new UserService();
```



#### 添加账号检验逻辑

<span style="backGround: #efe0b9">src\middleware\user.middleware.js</span>

```javascript
const errorTypes = require('../constants/error-types');
const service = require('../service/user.service');

const verifyUser = async (ctx, next) => {
  // 1.获取用户名和密码
  const { name, password } = ctx.request.body;

  // 2.判断用户名或者密码不能空
  if (!name || !password) {
    const error = new Error(errorTypes.NAME_OR_PASSWORD_IS_REQUIRED);
    return ctx.app.emit('error', error, ctx);
  }

  // 3.判断这次注册的用户名是没有被注册过（添加）
  const result = await service.getUserByName(name);
  if (result.length) {
    const error = new Error(errorTypes.USER_ALREADY_EXISTS);
    return ctx.app.emit('error', error, ctx);
  }

  await next(); // 调用才会执行下一个中间件
}

module.exports = {
  verifyUser
}
```



#### 补充错误处理

<span style="backGround: #efe0b9">src\constants\error-types.js</span>

```javascript
const NAME_OR_PASSWORD_IS_REQUIRED = 'name_or_password_is_required';
const USER_ALREADY_EXISTS = 'user_already_exists';

module.exports = {
  NAME_OR_PASSWORD_IS_REQUIRED,
  USER_ALREADY_EXISTS
}
```

<span style="backGround: #efe0b9">src\app\error-handle.js</span>

```javascript
const errorTypes = require('../constants/error-types');

const errorHandler = (error, ctx) => {
  let status, message;

  switch (error.message) {
    case errorTypes.NAME_OR_PASSWORD_IS_REQUIRED:
      status = 400; // Bad Request
      message = "用户名或者密码不能为空~";
      break;
    case errorTypes.USER_ALREADY_EXISTS:
      status = 409; // conflict
      message = "用户名已经存在~";
      break;
    default:
      status = 404;
      message = "NOT FOUND";
  }

  ctx.status = status;
  ctx.body = message;
}

module.exports = errorHandler;
```



### 入库前加密

```elm
- src
  + utils
    - password-handle.js // 加密方法
```

#### 注册加密

可以在校验中间件后，额外添加一个处理密码的中间件。

```javascript
const Router = require('koa-router');
const {
  create
} = require('../controller/user.controller');
const {
  verifyUser,
  handlePassword
} = require('../middleware/user.middleware');

const userRouter = new Router({prefix: '/users'});

userRouter.post('/', verifyUser, handlePassword, create); // 修改

module.exports = userRouter;
```



#### 实现加密中间件

<span style="backGround: #efe0b9">src\middleware\user.middleware.js</span>

```javascript
const errorTypes = require('../constants/error-types');
const service = require('../service/user.service');
const md5password = require('../utils/password-handle');

const verifyUser = async (ctx, next) => {
  // ...
}

// 加密中间件
const handlePassword = async (ctx, next) => {
  const { password } = ctx.request.body;
  ctx.request.body.password = md5password(password)

  await next();
}

module.exports = {
  verifyUser,
  handlePassword
}
```



#### 实现加密方法

<span style="backGround: #efe0b9">src\utils\password-handle.js</span>

```javascript
const crypto = require('crypto');

const md5password = (password) => {
  const md5 = crypto.createHash('md5'); // 选择加密方式
  const result = md5.update(password).digest('hex');
  return result;
}

module.exports = md5password;
```

:turtle: `digest()` 用于取出加密结果，默认是 Buffer 形式，设置为 `hex` 即为十六进制。



### 实现登录结构

> 先实现大体的架构，没有校验等环节。

#### 注册接口

<span style="backGround: #efe0b9">src\router\auth.router.js</span>

```javascript
const Router = require('koa-router');

const authRouter = new Router();

const {
  login
} = require('../controller/auth.controller');

authRouter.post('/login', login);

module.exports = authRouter;
```

#### 实现处理逻辑

<span style="backGround: #efe0b9">src\controller\auth.controller.js</span>

```javascript
class AuthController {
  async login(ctx, next) {
    const { name } = ctx.request.body;
    ctx.body = `登录成功，欢迎${name}回来~`
}

module.exports = new AuthController();
```

#### 添加注册的接口

<span style="backGround: #efe0b9">src\app\index.js</span>

```javascript
const Koa = require('koa');
const bodyParser = require('koa-bodyparser');

const userRouter = require('../router/user.router');
const authRouter = require('../router/auth.router');
const errorHandler = require('./error-handle'); 

const app = new Koa();

app.useRoutes = useRoutes;

app.use(bodyParser());
app.use(userRouter.routes());
app.use(userRouter.allowedMethods());
app.use(authRouter.routes());
app.use(authRouter.allowedMethods());

app.on('error', errorHandler);

module.exports = app;
```





### 登录校验

#### 添加校验中间件

<span style="backGround: #efe0b9">src\router\auth.router.js</span>

```javascript
const Router = require('koa-router');

const authRouter = new Router();

const {
  login
} = require('../controller/auth.controller');
const {
  verifyLogin
} = require('../middleware/auth.middleware');

authRouter.post('/login', verifyLogin, login); // 添加验证登录中间件

module.exports = authRouter;
```

#### 实现校验逻辑

<span style="backGround: #efe0b9">src\middleware\auth.middleware.js</span>

```javascript
const errorTypes = require('../constants/error-types');
const userService = require('../service/user.service');
const md5password = require('../utils/password-handle');

const verifyLogin = async (ctx, next) => {
  // 1.获取用户名和密码
  const { name, password } = ctx.request.body;

  // 2.判断用户名和密码是否为空
  if (!name || !password) {
    const error = new Error(errorTypes.NAME_OR_PASSWORD_IS_REQUIRED);
    return ctx.app.emit('error', error, ctx);
  }

  // 3.判断用户是否存在的
  const result = await userService.getUserByName(name);
  const user = result[0]; // 取出查询结果的第一个
  if (!user) {
    const error = new Error(errorTypes.USER_DOES_NOT_EXISTS);
    return ctx.app.emit('error', error, ctx);
  }

  // 4.判断密码加密后是否和数据库中的密码一致
  if (md5password(password) !== user.password) {
    const error = new Error(errorTypes.PASSWORD_IS_INCORRENT);
    return ctx.app.emit('error', error, ctx);
  }

  ctx.user = user;
  await next();
}

module.exports = {
  verifyLogin
}
```



#### 处理错误事件

<span style="backGround: #efe0b9">src\constants\error-types.js</span>

```javascript
const NAME_OR_PASSWORD_IS_REQUIRED = 'name_or_password_is_required';
const USER_ALREADY_EXISTS = 'user_already_exists';
const USER_DOES_NOT_EXISTS = 'user_does_not_exists';
const PASSWORD_IS_INCORRENT = 'password_is_incorrent';

module.exports = {
  NAME_OR_PASSWORD_IS_REQUIRED,
  USER_ALREADY_EXISTS,
  USER_DOES_NOT_EXISTS,
  PASSWORD_IS_INCORRENT
}
```

<span style="backGround: #efe0b9">src\app\error-handle.js</span>

```javascript
const errorTypes = require('../constants/error-types');

const errorHandler = (error, ctx) => {
  let status, message;

  switch (error.message) {
    case errorTypes.NAME_OR_PASSWORD_IS_REQUIRED:
      status = 400; // Bad Request
      message = "用户名或者密码不能为空~";
      break;
    case errorTypes.USER_ALREADY_EXISTS:
      status = 409; // conflict
      message = "用户名已经存在~";
      break;
    case errorTypes.USER_DOES_NOT_EXISTS:
      status = 400; // 参数错误
      message = "用户名不存在~";
      break;
    case errorTypes.PASSWORD_IS_INCORRENT:
      status = 400; // 参数错误
      message = "密码是错误的~";
      break;
    default:
      status = 404;
      message = "NOT FOUND";
  }

  ctx.status = status;
  ctx.body = message;
}

module.exports = errorHandler;
```



### 抽离路由注册入口

```elm
- src
  + router
    - auto.router.js
    - user.router.js
    - index.js       // 入口文件
```

<span style="backGround: #efe0b9">src\router\index.js</span>

```javascript
const fs = require('fs');

const useRoutes = function() {
  fs.readdirSync(__dirname).forEach(file => {
    if (file === 'index.js') return;
    const router = require(`./${file}`);
    this.use(router.routes()); // 注册到服务器实例
    this.use(router.allowedMethods()); // 恰当不支持方法
  })
}

module.exports = useRoutes;
```

:turtle: 文件夹下除了入口文件，剩余的导出一个路由实例。

<span style="backGround: #efe0b9">src\app\index.js</span>

```javascript
const Koa = require('koa');
const bodyParser = require('koa-bodyparser');
const errorHandler = require('./error-handle');
const useRoutes = require('../router');

const app = new Koa();

app.useRoutes = useRoutes;

app.use(bodyParser());
app.useRoutes();
app.on('error', errorHandler);

module.exports = app;
```

:turtle: 对象调用时，方法中的 `this` 指向该对象。



### 发布登录凭证

> 在登录成功后，给用户返回 token 相关的信息。

```elm
- src
  + app
    - keys // 保存公钥和密钥
      + private.key
      + public.key
    - config.js // 全局配置
```

#### 将钥匙添加到配置

<span style="backGround: #efe0b9">src\app\config.js</span>

```javascript
const dotenv = require('dotenv');
const fs = require('fs');
const path = require('path');

dotenv.config();

const PRIVATE_KEY = fs.readFileSync(path.resolve(__dirname, './keys/private.key'));
const PUBLIC_KEY = fs.readFileSync(path.resolve(__dirname, './keys/public.key'));

module.exports = {
  APP_HOST,
  APP_PORT,
  MYSQL_HOST,
  MYSQL_PORT,
  MYSQL_DATABASE,
  MYSQL_USER,
  MYSQL_PASSWORD,
} = process.env;

module.exports.PRIVATE_KEY = PRIVATE_KEY;
module.exports.PUBLIC_KEY = PUBLIC_KEY;
```

<span style="backGround: #efe0b9">src\middleware\auth.middleware.js</span>

```javascript
const verifyLogin = async (ctx, next) => {
  // 1.获取用户名和密码
  // 2.判断用户名和密码是否为空
  // 3.判断用户是否存在的
  // 获取到user
  // 4.判断密码是否和数据库中的密码是一致(加密)

  ctx.user = user; // 添加
  await next();
}


module.exports = {
  verifyLogin
}
```

:point_down: 可以将已经获取到的信息添加到 `ctx` 中，传递给下一个中间件使用。



#### 实现发布

```elm
npm install jsonwebtoken
```

<span style="backGround: #efe0b9">src\controller\auth.controller.js</span>

```javascript
const jwt = require('jsonwebtoken');
const { PRIVATE_KEY } = require('../app/config');

class AuthController {
  async login(ctx, next) {
    const { id, name } = ctx.user; // 从上一个中间件传递过来
    const token = jwt.sign({ id, name }, PRIVATE_KEY, {
      expiresIn: 60 * 60 * 24,
      algorithm: 'RS256'
    });

    ctx.body = { id, name, token }
  }

  async success(ctx, next) {
    ctx.body = "授权成功~";
  }
}

module.exports = new AuthController();
```



### 验证授权

#### 注册接口

<span style="backGround: #efe0b9">src\router\auth.router.js</span>

```javascript
const Router = require('koa-router');

const authRouter = new Router();

const {
  login,
  success
} = require('../controller/auth.controller');
const {
  verifyLogin,
  verifyAuth
} = require('../middleware/auth.middleware');

authRouter.post('/login', verifyLogin, login);
authRouter.get('/test', verifyAuth, success); // 添加

module.exports = authRouter;
```



#### 实现中间件

<span style="backGround: #efe0b9">src\middleware\auth.middleware.js</span>

```javascript
const jwt = require('jsonwebtoken');

const errorTypes = require('../constants/error-types');
const { PUBLIC_KEY } = require('../app/config');

// ...

const verifyAuth = async (ctx, next) => {
  console.log("验证授权的middleware~");
  // 1.获取token
  const authorization = ctx.headers.authorization;
  if (!authorization) {
    const error = new Error(errorTypes.UNAUTHORIZATION);
    return ctx.app.emit('error', error, ctx);
  }
  const token = authorization.replace('Bearer ', '');

  // 2.验证token(id/name/iat/exp)
  try {
    const result = jwt.verify(token, PUBLIC_KEY, {
      algorithms: ["RS256"]
    });
    ctx.user = result;
    await next();
  } catch (err) {
    const error = new Error(errorTypes.UNAUTHORIZATION);
    ctx.app.emit('error', error, ctx);
  }
}
```

:european_castle: 这里验证授权通过后，会将相关信息保存到 `ctx` 中，供后面的中间件使用。

<span style="backGround: #efe0b9">src\controller\auth.controller.js</span>

```javascript
// ...
class AuthController {
  // 添加
  async success(ctx, next) {
    ctx.body = "授权成功~";
  }
}

module.exports = new AuthController();
```



#### 处理错误事件

<span style="backGround: #efe0b9">src\constants\error-types.js</span>

```javascript
const UNAUTHORIZATION = 'UNAUTHORIZATION';

module.exports = {
  //...
  UNAUTHORIZATION,
}
```

<span style="backGround: #efe0b9">src\app\error-handle.js</span>

```javascript
// ...
switch (error.message) {
  // ...
  case errorTypes.UNAUTHORIZATION:
    status = 401; // 参数错误
    message = "无效的token~";
    break;
  // ...
}
```



## 消息动态模块

### 创建动态表

```sql
CREATE TABLE IF NOT EXISTS `moment` (
  id INT PRIMARY KEY AUTO_INCREMENT,
  content VARCHAR(1000) NOT NULL,
  user_id INT NOT NULL,
  createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES user (id)
);
```



### 发表动态功能

#### 注册接口

<span style="backGround: #efe0b9">src\router\moment.router.js</span>

```javascript
const Router = require('koa-router');

const momentRouter = new Router({prefix: '/moment'});

const {
  create
} = require('../controller/moment.controller.js');
const {
  verifyAuth
} = require('../middleware/auth.middleware');

momentRouter.post('/', verifyAuth, create);

module.exports = momentRouter;
```



#### 实现中间件

<span style="backGround: #efe0b9">src\controller\moment.controller.js</span>

```javascript
const momentService = require('../service/moment.service');

class MomentController {
  async create(ctx, next) {
    // 1.获取数据(user_id, content)
    const userId = ctx.user.id;
    const content = ctx.request.body.content;

    // 2.将数据插入到数据库
    const result = await momentService.create(userId, content);
    ctx.body = result;
  }
}

module.exports = new MomentController();
```

:trident: 授权中间件，会传递包含用户Id的信息给后面的中间件使用。

<span style="backGround: #efe0b9">src\service\moment.service.js</span>

```javascript
const connection = require('../app/database');

class MomentService {
  async create(userId, content) {
    const statement = `INSERT INTO moment (content, user_id) VALUES (?, ?);`;
    const [result] = await connection.execute(statement, [content, userId]);
    return result;
  }
}

module.exports = new MomentService();
```



### 查询单个动态

#### 注册接口

<span style="backGround: #efe0b9">src\router\moment.router.js</span>

```javascript
const Router = require('koa-router');

const momentRouter = new Router({prefix: '/moment'});

const {
  create,
  detail
} = require('../controller/moment.controller.js');
const {
  verifyAuth
} = require('../middleware/auth.middleware');
const {
  verifyLabelExists
} = require('../middleware/label.middleware');

momentRouter.post('/', verifyAuth, create);
momentRouter.get('/:momentId', detail); // 添加

module.exports = momentRouter;
```



#### 实现中间件

<span style="backGround: #efe0b9">src\controller\moment.controller.js</span>

```javascript
const momentService = require('../service/moment.service');

class MomentController {
  // ...
  async detail(ctx, next) {
    // 1.获取数据(momentId)
    const momentId = ctx.params.momentId;

    // 2.根据id去查询这条数据
    const result = await momentService.getMomentById(momentId);
    ctx.body = result;
  }
}

module.exports = new MomentController();
```

<span style="backGround: #efe0b9">src\service\moment.service.js</span>

```javascript
const connection = require('../app/database');

class MomentService {
  // ...
  async getMomentById(id) {
    const statement = `
      SELECT 
        m.id id, m.content content, m.createAt createTime, m.updateAt updateTime,
        JSON_OBJECT('id', u.id, 'name', u.name) author
      FROM moment m
      LEFT JOIN user u ON m.user_id = u.id
      WHERE m.id = ?;
    `;
    const [result] = await connection.execute(statement, [id]);
    return result[0];
    }
}

module.exports = new MomentService();
```



### 分页查询动态

> 需要传入偏移量和条数。

#### 注册接口

<span style="backGround: #efe0b9">src\router\moment.router.js</span>

```javascript
const Router = require('koa-router');

const momentRouter = new Router({prefix: '/moment'});

const {
  create,
  detail,
  list
} = require('../controller/moment.controller.js');
const {
  verifyAuth
} = require('../middleware/auth.middleware');
const {
  verifyLabelExists
} = require('../middleware/label.middleware');

momentRouter.post('/', verifyAuth, create);

momentRouter.get('/:momentId', detail);
momentRouter.get('/', list); // 添加

module.exports = momentRouter;
```



#### 模拟插入数据

```sql
INSERT INTO moment (content, user_id) VALUES ('我说错了，C语言才是最好的语言~', 1);
INSERT INTO moment (content, user_id) VALUES ('曾几何时', 2);
INSERT INTO moment (content, user_id) VALUES ('不要告诉我', 3);
INSERT INTO moment (content, user_id) VALUES ('在世间万物', 2);
INSERT INTO moment (content, user_id) VALUES ('限定目的', 1);
INSERT INTO moment (content, user_id) VALUES ('翅膀长在', 4);
INSERT INTO moment (content, user_id) VALUES ('一个人至', 3);
INSERT INTO moment (content, user_id) VALUES ('不乱于心', 5);
INSERT INTO moment (content, user_id) VALUES ('如果你给我的', 4);
INSERT INTO moment (content, user_id) VALUES ('别人的是', 2);
INSERT INTO moment (content, user_id) VALUES ('心之所向', 2);
INSERT INTO moment (content, user_id) VALUES ('木兰从军', 2);
INSERT INTO moment (content, user_id) VALUES ('五花马', 2);
```



#### 实现中间件

<span style="backGround: #efe0b9">src\controller\moment.controller.js</span>

```javascript
const momentService = require('../service/moment.service');

class MomentController {
  // ...
  async list(ctx, next) {
    // 1.获取数据(offset/size)
    const { offset, size } = ctx.query;

    // 2.查询列表
    const result = await momentService.getMomentList(offset, size);
    ctx.body = result;
  }
}

module.exports = new MomentController();
```

<span style="backGround: #efe0b9">src\service\moment.service.js</span>

```javascript
const connection = require('../app/database');

class MomentService {
  // ...
  async getMomentList(offset, size) {
    const statement = `
      SELECT 
        m.id id, m.content content, m.createAt createTime, m.updateAt updateTime,
        JSON_OBJECT('id', u.id, 'name', u.name) author
      FROM moment m
      LEFT JOIN user u ON m.user_id = u.id
      LIMIT ?, ?;
    `;
    const [result] = await connection.execute(statement, [offset, size]);
    return result;
  }
}

module.exports = new MomentService();
```



### 修改动态

#### 注册接口

<span style="backGround: #efe0b9">src\router\moment.router.js</span>

```javascript
const Router = require('koa-router');

const momentRouter = new Router({prefix: '/moment'});

const {
  create,
  detail,
  list,
  update
} = require('../controller/moment.controller.js');
const {
  verifyAuth,
  verifyPermission
} = require('../middleware/auth.middleware');

momentRouter.post('/', verifyAuth, create);

momentRouter.get('/', list);
momentRouter.get('/:momentId', detail);

// 修改的两个前提：1.用户必须登录 2.用户具备权限
momentRouter.patch('/:momentId', verifyAuth, verifyPermission, update); // 添加

module.exports = momentRouter;
```



#### 实现中间件

##### 验证用户权限

<span style="backGround: #efe0b9">src\middleware\auth.middleware.js</span>

```javascript
// ...
const errorTypes = require('../constants/error-types');
const authService = require('../service/auth.service');

// ...
const verifyPermission = async (ctx, next) => {
  console.log("验证权限的middleware~");

  // 1.获取参数
  const { momentId } = ctx.params;
  const { id } = ctx.user;

  // 2.查询是否具备权限
  try {
    const isPermission = await authService.checkResource(momentId, id);
    if (!isPermission) throw new Error();
    await next();
  } catch (err) {
    const error = new Error(errorTypes.UNPERMISSION);
    return ctx.app.emit('error', error, ctx);
  }
}

module.exports = {
  verifyLogin,
  verifyAuth,
  verifyPermission
}
```

<span style="backGround: #efe0b9">src\service\auth.service.js</span>

```javascript
const connection = require('../app/database');

class AuthService {
  async checkResource(momentId, userId) {
    const statement = `SELECT * FROM moment WHERE id = ? AND user_id = ?;`;
    const [result] = await connection.execute(statement, [momentId, userId]);
    return result.length === 0 ? false: true;
  }
}

module.exports = new AuthService();
```

:ghost: 查询是否有符合条件的记录，帮助判断用户权限（评论是否属于当前用户）

:ghost: 由于这种涉及到用户权限的需求很多，把它单独抽离到一个文件中，后面可以封装，更通用。



##### 验证权限封装

> 这里将上一节的内容封装一下，使其具备公用性。

<span style="backGround: #efe0b9">src\middleware\auth.middleware.js</span>

```javascript
// ...
const errorTypes = require('../constants/error-types');
const authService = require('../service/auth.service');

// ...
const verifyPermission = async (ctx, next) => {
  console.log("验证权限的middleware~");

  // 1.获取参数 { commentId: '1' }  （修改）
  const [resourceKey] = Object.keys(ctx.params);
  const tableName = resourceKey.replace('Id', ''); // comment
  const resourceId = ctx.params[resourceKey];      // 1
  const { id } = ctx.user;

  // 2.查询是否具备权限
  try {
    // （修改）下一行
    const isPermission = await authService.checkResource(tableName, resourceId, id);
    if (!isPermission) throw new Error();
    await next();
  } catch (err) {
    const error = new Error(errorTypes.UNPERMISSION);
    return ctx.app.emit('error', error, ctx);
  }
}

module.exports = {
  verifyLogin,
  verifyAuth,
  verifyPermission
}
```

:ghost: 这种封装的前提是，接口定义规范，如 `:momentId`，中间包含的就是表名。

:whale: 也可以将 <span style="color: slategray">verifyPermission</span> 封装成闭包，从上一层传入表名。

 

<span style="backGround: #efe0b9">src\service\auth.service.js</span>

```javascript
const connection = require('../app/database');

class AuthService {
  async checkResource(tableName, id, userId) {
    const statement = `SELECT * FROM ${tableName} WHERE id = ? AND user_id = ?;`;
    const [result] = await connection.execute(statement, [id, userId]);
    return result.length === 0 ? false: true;
  }
}

module.exports = new AuthService();
```

:ghost: 增加函数的一个传参 <span style="color: slategray">tableName</span>，就可以实现不同情况下的权限判断了。



##### 实现修改动态

<span style="backGround: #efe0b9">src\controller\moment.controller.js</span>

```javascript
const momentService = require('../service/moment.service');

class MomentController {
  // ...
  async update(ctx, next) {
    // 1.获取参数
    const { momentId } = ctx.params;
    const { content } = ctx.request.body;

    // 2.修改内容
    const result = await momentService.update(content, momentId);
    ctx.body = result;
  }
}

module.exports = new MomentController();
```

<span style="backGround: #efe0b9">src\service\moment.service.js</span>

```javascript
const connection = require('../app/database');

class MomentService {
  // ...
  async update(content, momentId) {
    const statement = `UPDATE moment SET content = ? WHERE id = ?;`;
    const [result] = await connection.execute(statement, [content, momentId]);
    return result;
  }
}

module.exports = new MomentService();
```



#### 处理错误事件

<span style="backGround: #efe0b9">src\constants\error-types.js</span>

```javascript
const UNAUTHORIZATION = 'UNPERMISSION';

module.exports = {
  //...
  UNPERMISSION,
}
```

<span style="backGround: #efe0b9">src\app\error-handle.js</span>

```javascript
// ...
switch (error.message) {
  // ...
  case errorTypes.UNPERMISSION:
    status = 401; // 参数错误
    message = "您不具备操作的权限";
    break;
  // ...
}
```



### 删除动态

#### 注册接口

<span style="backGround: #efe0b9">src\router\moment.router.js</span>

```javascript
const Router = require('koa-router');

const momentRouter = new Router({prefix: '/moment'});

const {
  create,
  detail,
  list,
  update,
  remove
} = require('../controller/moment.controller.js');
const {
  verifyAuth,
  verifyPermission
} = require('../middleware/auth.middleware');

momentRouter.post('/', verifyAuth, create);

momentRouter.get('/', list);
momentRouter.get('/:momentId', detail);

// 修改的两个前提：1.用户必须登录 2.用户具备权限
momentRouter.patch('/:momentId', verifyAuth, verifyPermission, update);
momentRouter.delete('/:momentId', verifyAuth, verifyPermission, remove); // 添加

module.exports = momentRouter;
```



#### 实现中间件

<span style="backGround: #efe0b9">src\controller\moment.controller.js</span>

```javascript
const momentService = require('../service/moment.service');

class MomentController {
  // ...
  async remove(ctx, next) {
    // 1.获取momentId
    const { momentId } = ctx.params;

    // 2.删除内容
    const result = await momentService.remove(momentId);
    ctx.body = result;
  }
}

module.exports = new MomentController();
```

<span style="backGround: #efe0b9">src\service\moment.service.js</span>

```javascript
const connection = require('../app/database');

class MomentService {
  // ...
  async remove(momentId) {
    const statement = `DELETE FROM moment WHERE id = ?`;
    const [result] = await connection.execute(statement, [momentId]);
    return result;
  }
}

module.exports = new MomentService();
```

​	

## 评论模块

> 可以对动态进行评论，也可以对他人的评论进行评论。

### 创建评论表

```sql
CREATE TABLE IF NOT EXISTS `comment` (
  id INT PRIMARY KEY AUTO_INCREMENT,
  content VARCHAR(1000) NOT NULL,
  moment_id INT NOT NULL,
  user_id INT NOT NULL,
  comment_id INT DEFAULT NULL,
  createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
  FOREIGN KEY(moment_id) REFERENCES moment(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(user_id) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(comment_id) REFERENCES comment(id) ON DELETE CASCADE ON UPDATE CASCADE
)
```

:ghost: 这里对删除操作配置了 <span style="color: #a50">CASCADE</span> 类型，因为删除动态的时候，对应评论也会跟着一起删除。



### 创建评论

#### 注册接口

<span style="backGround: #efe0b9">src\router\comment.router.js</span>

```javascript
const Router = require('koa-router');

const {
  verifyAuth
} = require('../middleware/auth.middleware');
const {
  create
} = require('../controller/comment.controller.js')

const commentRouter = new Router({prefix: '/comment'});

// 发表评论
commentRouter.post('/', verifyAuth, create);

module.exports = commentRouter;
```



#### 实现中间件

<span style="backGround: #efe0b9">src\controller\comment.controller.js</span>

```javascript
const service = require('../service/comment.service.js');

class CommentController {
  async create(ctx, next) {
    const { momentId, content } = ctx.request.body;
    const { id } = ctx.user;
    const result = await service.create(momentId, content, id);
    ctx.body = result;
  }
}

module.exports = new CommentController();
```

<span style="backGround: #efe0b9">src\service\comment.service.js</span>

```javascript
const connection = require('../app/database');

class CommentService {
  async create(momentId, content, userId) {
    const statement = `INSERT INTO comment (content, moment_id, user_id) VALUES (?, ?, ?);`;
    const [result] = await connection.execute(statement, [content, momentId, userId]);
    return result;
  }
}

module.exports = new CommentService();
```



### 回复评论

#### 注册接口

`url`

```javascript
{{baseURL}}/commomt/1/reply
```

`body`

```javascript
{
  "momentId": 1,
  "content": "你的评论好有趣"
}
```

<span style="backGround: #efe0b9">src\router\comment.router.js</span>

```javascript
const Router = require('koa-router');

const {
  verifyAuth
} = require('../middleware/auth.middleware');
const {
  create,
  reply
} = require('../controller/comment.controller.js')

const commentRouter = new Router({prefix: '/comment'});

// 发表评论
commentRouter.post('/', verifyAuth, create);
commentRouter.post('/:commentId/reply', verifyAuth, reply); // 添加

module.exports = commentRouter;
```



#### 实现中间件

<span style="backGround: #efe0b9">src\controller\comment.controller.js</span>

```javascript
const service = require('../service/comment.service.js');

class CommentController {
  // ...
  async reply(ctx, next) {
    const { momentId, content } = ctx.request.body;
    const { commentId } = ctx.params;
    const { id } = ctx.user;
    const result = await service.reply(momentId, content, id, commentId);
    ctx.body = result;
  }
}

module.exports = new CommentController();
```

<span style="backGround: #efe0b9">src\service\comment.service.js</span>

```javascript
const connection = require('../app/database');

class CommentService {
  // ...
  async reply(momentId, content, userId, commentId) {
    const statement = `INSERT INTO comment (content, moment_id, user_id, comment_id) VALUES (?, ?, ?, ?);`;
    const [result] = await connection.execute(statement, [content, momentId, userId, commentId]);
    return result;
  }
}

module.exports = new CommentService();
```



### 修改评论

#### 注册接口

<span style="backGround: #efe0b9">src\router\comment.router.js</span>

```javascript
const Router = require('koa-router');

const {
  verifyAuth,
  verifyPermission
} = require('../middleware/auth.middleware');
const {
  create,
  reply,
  update
} = require('../controller/comment.controller.js')

const commentRouter = new Router({prefix: '/comment'});

commentRouter.post('/', verifyAuth, create);
commentRouter.post('/:commentId/reply', verifyAuth, reply);

// 修改评论
commentRouter.patch('/:commentId', verifyAuth, verifyPermission, update); // 新增

module.exports = commentRouter;
```



#### 实现中间件

<span style="backGround: #efe0b9">src\controller\comment.controller.js</span>

```javascript
const service = require('../service/comment.service.js');

class CommentController {
  // ...
  async update(ctx, next) {
    const { commentId } = ctx.params;
    const { content } = ctx.request.body;
    const result = await service.update(commentId, content);
    ctx.body = result;
  }
}

module.exports = new CommentController();
```

<span style="backGround: #efe0b9">src\service\comment.service.js</span>

```javascript
const connection = require('../app/database');

class CommentService {
  // ...
  async update(commentId, content) {
    const statement = `UPDATE comment SET content = ? WHERE id = ?`;
    const [result] = await connection.execute(statement, [content, commentId]);
    return result;
  }
}

module.exports = new CommentService();
```



### 删除评论

#### 注册接口

<span style="backGround: #efe0b9">src\router\comment.router.js</span>

```javascript
const Router = require('koa-router');

const {
  verifyAuth,
  verifyPermission
} = require('../middleware/auth.middleware');
const {
  create,
  reply,
  update,
  remove
} = require('../controller/comment.controller.js')

const commentRouter = new Router({prefix: '/comment'});

//...
// 删除评论
commentRouter.delete('/:commentId', verifyAuth, verifyPermission, remove); // 新增

module.exports = commentRouter;
```



#### 实现中间件

<span style="backGround: #efe0b9">src\controller\comment.controller.js</span>

```javascript
const service = require('../service/comment.service.js');

class CommentController {
  // ...
  async remove(ctx, next) {
    const { commentId } = ctx.params;
    const result = await service.remove(commentId);
    ctx.body = result;
  }
}

module.exports = new CommentController();
```

<span style="backGround: #efe0b9">src\service\comment.service.js</span>

```javascript
const connection = require('../app/database');

class CommentService {
  // ...
  async remove(commentId) {
    const statement = `DELETE FROM comment WHERE id = ?`;
    const [result] = await connection.execute(statement, [commentId]);
    return result;
  }
}

module.exports = new CommentService();
```



### 增强-分页查询动态

<span style="backGround: #efe0b9">src\service\moment.service.js</span>

```javascript
const connection = require('../app/database');

class MomentService {
  // ...
  async getMomentList(offset, size) {
    const statement = `
      SELECT 
        m.id id, m.content content, m.createAt createTime, m.updateAt updateTime,
        JSON_OBJECT('id', u.id, 'name', u.name) author
        (SELECT COUNT(*) FROM commemt c WHERE c.moment_id = m.id) commentCount
      FROM moment m
      LEFT JOIN user u ON m.user_id = u.id
      LIMIT ?, ?;
    `;
    const [result] = await connection.execute(statement, [offset, size]);
    return result;
  }
}

module.exports = new MomentService();
```

:whale: 返回的字段中新增评论个数 <span style="color: slategray">commentCount</span>



### 获取评论列表

> 需求为获取动态和对应评论，有两种写法：①分开两个接口写 ②将数据用一个接口返回。后者实现起来更复杂，且不能让客户端先拿到动态数据再拿评论数据，加载效果没那么好。



#### 注册接口

<span style="backGround: #efe0b9">src\router\comment.router.js</span>

```javascript
const Router = require('koa-router');

const {
  verifyAuth,
  verifyPermission
} = require('../middleware/auth.middleware');
const {
  create,
  reply,
  update,
  remove,
  list
} = require('../controller/comment.controller.js')

const commentRouter = new Router({prefix: '/comment'});

// ...

// 获取评论列表
commentRouter.get('/', list); // 新增

module.exports = commentRouter;
```



#### 实现中间件

<span style="backGround: #efe0b9">src\controller\comment.controller.js</span>

```javascript
const service = require('../service/comment.service.js');

class CommentController {
  // ...
  async list(ctx, next) {
    const { momentId } = ctx.query;
    const result = await service.getCommentsByMomentId(momentId);
    ctx.body = result;
  }
}

module.exports = new CommentController();
```

<span style="backGround: #efe0b9">src\service\comment.service.js</span>

```javascript
const connection = require('../app/database');

class CommentService {
  // ...
  async getCommentsByMomentId(momentId) {
    const statement = `
      SELECT 
        m.id, m.content, m.comment_id commendId, m.createAt createTime,
        JSON_OBJECT('id', u.id, 'name', u.name) user
      FROM comment m
      LEFT JOIN user u ON u.id = m.user_id
      WHERE moment_id = ?;
    `;
    const [result] = await connection.execute(statement, [momentId]);
    return result;
  }
}

module.exports = new CommentService();
```



### 增强-查询单个动态

> 这个为对应的单个接口，返回多数据方案。

<span style="backGround: #efe0b9">src\service\moment.service.js</span>

```sql
// getMomentById
const statement = `
  SELECT 
    m.id id, m.content content, m.createAt createTime, m.updateAt updateTime,
    JSON_OBJECT('id', u.id, 'name', u.name) author,
    JSON_ARRAYAGG(
      JSON_OBJECT('id', c.id, 'content', c.content, 'commentId', c.commentId,
        'createTime', c.createAt,
        'user', JSON_OBJECT('id', cu.id, 'name', cu.name)
      )
    ) comments
  FROM moment m
  LEFT JOIN user u ON m.user_id = u.id
  LEFT JOIN comment c ON c.moment_id = m.id
  LEFT JOIN user cu ON c.user_id = cu.id
  WHERE m.id = ?;
`;
```

:turtle: 将动态相关的评论信息，以及每个评论相关的用户信息也返回；

:turtle: 要注意评论的用户和发表动态的用户不一定是同一个人，连接了两次 <span style="color: slategray">user</span> 表。



## 标签模块

> 标签与动态是多对多的关系，而且用户一次可以选择多个标签到一个动态上。

### 创建标签表

```sql
CREATE TABLE IF NOT EXISTS `label` (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(10) NOT NULL UNIQUE,
  createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```



### 创建标签

#### 注册接口

<span style="backGround: #efe0b9">src\router\label.router.js</span>

```javascript
const Router = require('koa-router');

const {
  verifyAuth
} = require('../middleware/auth.middleware');
const {
  create
} = require('../controller/label.controller.js')

const labelRouter = new Router({prefix: '/label'});

labelRouter.post('/', verifyAuth, create);

module.exports = labelRouter;
```



#### 实现中间件

<span style="backGround: #efe0b9">src\controller\label.controller.js</span>

```javascript
const service = require('../service/label.service');

class LabelController {
  async create(ctx, next) {
    const { name } = ctx.request.body;
    const result = await service.create(name);
    ctx.body = result;
  }
}

module.exports = new LabelController();
```

<span style="backGround: #efe0b9">src\service\label.service.js</span>

```javascript
const connection = require('../app/database');

class LabelService {
  async create(name) {
    const statement = `INSERT INTO label (name) VALUES (?);`;
    const [result] = await connection.execute(statement, [name]);
    return result;
  }
}

module.exports = new LabelService();
```



### 创建动态-标签关系表

涉及到多对多的关系，故建立关系表

```sql
CREATE TABLE IF NOT EXISTS `moment_label` (
  moment_id INT NOT NULL,
  label_id INT NOT NULL,
  createAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (moment_id, label_id),
  FOREIGN KEY (moment_id) REFERENCES moment (id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (label_id) REFERENCES label (id) ON DELETE CASCADE ON UPDATE CASCADE
);
```

:ghost: 使用 <span style="color: slategray">moment_id</span> 和 <span style="color: slategray">label_id</span> 作为联合主键；

:ghost: 设置两个外键以实现联动。



### 给动态添加标签

#### 注册接口

<span style="backGround: #efe0b9">src\router\moment.router.js</span>

```javascript
const Router = require('koa-router');

const momentRouter = new Router({prefix: '/moment'});

const {
  ...,
  addLabels
} = require('../controller/moment.controller.js');
const {
  verifyAuth,
  verifyPermission
} = require('../middleware/auth.middleware');
const {
  verifyLabelExists
} = require('../middleware/label.middleware');

// ...
// 给动态添加标签
momentRouter.post('/:momentId/labels', verifyAuth, verifyPermission, verifyLabelExists, addLabels);

module.exports = momentRouter;
```



#### 预处理标签

> 对于标签表中不存在的标签，需要先创建，然后将标签表中已有标签/新建标签信息传递给下一中间件。

<span style="backGround: #efe0b9">src\middleware\label.middleware.js</span>

```javascript
const service = require('../service/label.service');

const verifyLabelExists = async (ctx, next) => {
  // 1.取出要添加的所有的标签
  const { labels } = ctx.request.body;

  // 2.判断每一个标签在label表中是否存在
  const newLabels = [];
  for (let name of labels) {
    const labelResult = await service.getLabelByName(name);
    const label = { name };
    if (!labelResult) {
      // 创建标签数据
      const result = await service.create(name);
      label.id = result.insertId;
    } else {
      label.id = labelResult.id;
    }
    newLabels.push(label);
  }
  ctx.labels = newLabels;
  await next();
}

module.exports = {
  verifyLabelExists
}
```

<span style="backGround: #efe0b9">src\service\label.service.js</span>

```javascript
const connection = require('../app/database');

class LabelService {
  // ...
  async getLabelByName(name) {
    const statement = `SELECT * FROM label WHERE name = ?;`;
    const [result] = await connection.execute(statement, [name]);
    return result[0];
  }
}

module.exports = new LabelService();
```



#### 添加标签

> 如果动态已经存在某标签的联系，不需要插入该标签。

<span style="backGround: #efe0b9">src\controller\moment.controller.js</span>

```javascript
const momentService = require('../service/moment.service');

class MomentController {
  // ...
  async addLabels(ctx, next) {
    // 1.获取标签和动态id
    const { labels } = ctx;
    const { momentId } = ctx.params;

    // 2.添加所有的标签
    for (let label of labels) {
      // 2.1.判断标签是否已经和动态有关系
      const isExist = await momentService.hasLabel(momentId, label.id);
      if (!isExist) {
        await momentService.addLabel(momentId, label.id);
      }
    }

    ctx.body = "给动态添加标签成功~";
  }
}

module.exports = new MomentController();
```

<span style="backGround: #efe0b9">src\service\moment.service.js</span>

```javascript
const connection = require('../app/database');

class MomentService {
  // ...
  async hasLabel(momentId, labelId) {
    const statement = `SELECT * FROM moment_label WHERE moment_id = ? AND label_id = ?`;
    const [result] = await connection.execute(statement, [momentId, labelId]);
    return result[0] ? true: false;
  }

  async addLabel(momentId, labelId) {
    const statement = `INSERT INTO moment_label (moment_id, label_id) VALUES (?, ?);`;
    const [result] = await connection.execute(statement, [momentId, labelId]);
    return result;
  }
}

module.exports = new MomentService();
```



### 展示标签列表

#### 注册接口

<span style="backGround: #efe0b9">src\router\label.router.js</span>

```javascript
const Router = require('koa-router');

const {
  verifyAuth
} = require('../middleware/auth.middleware');
const {
  ...,
  list
} = require('../controller/label.controller.js')

// ...
labelRouter.get('/', list);

module.exports = labelRouter;
```



#### 实现中间件

<span style="backGround: #efe0b9">src\controller\label.controller.js</span>

```javascript
const service = require('../service/label.service');

class LabelController {
  async list(ctx, next) {
    const { limit, offset } = ctx.query;
    const result = await service.getLabels(limit, offset);
    ctx.body = result;
  }
}

module.exports = new LabelController();
```

<span style="backGround: #efe0b9">src\service\label.service.js</span>

```javascript
const connection = require('../app/database');

class LabelService {
  async getLabels(limit, offset) {
    const statement = `SELECT * FROM label LIMIT ?, ?;`;
    const [result] = await connection.execute(statement, [offset, limit]);
    return result;
  }
}

module.exports = new LabelService();
```



### 增强-分页查询动态

<span style="backGround: #efe0b9">src\service\moment.service.js</span>

```javascript
const connection = require('../app/database');

class MomentService {
  // ...
  async getMomentList(offset, size) {
    const statement = `
      SELECT 
        m.id id, m.content content, m.createAt createTime, m.updateAt updateTime,
        JSON_OBJECT('id', u.id, 'name', u.name) author
        (SELECT COUNT(*) FROM commemt c WHERE c.moment_id = m.id) commentCount
        (SELECT COUNT(*) FROM moment_label ml WHERE ml.moment_id = m.id) labelCount
      FROM moment m
      LEFT JOIN user u ON m.user_id = u.id
      LIMIT ?, ?;
    `;
    const [result] = await connection.execute(statement, [offset, size]);
    return result;
  }
}

module.exports = new MomentService();
```

:whale: 返回的字段中新增评论个数 <span style="color: slategray">labelCount</span>



### 增强-查询单个动态

<span style="backGround: #efe0b9">src\service\moment.service.js</span>

```javascript
getMomentById
```

```sql
SELECT 
  m.id id, m.content content, m.createAt createTime, m.updateAt updateTime,
  JSON_OBJECT('id', u.id, 'name', u.name) author,
  IF(COUNT(l.id),JSON_ARRAYAGG(
    JSON_OBJECT('id', l.id, 'name', l.name)
  ),NULL) labels,
  (SELECT IF(COUNT(c.id),JSON_ARRAYAGG(
    JSON_OBJECT('id', c.id, 'content', c.content, 'commentId', c.comment_id,                   'createTime', c.createAt,            
      'user', JSON_OBJECT('id', cu.id, 'name', cu.name))
  ),NULL) FROM comment c LEFT JOIN user cu ON c.user_id = cu.id WHERE m.id = c.moment_id) comments
FROM moment m
LEFT JOIN user u ON m.user_id = u.id
LEFT JOIN moment_label ml ON m.id = ml.moment_id
LEFT JOIN label l ON ml.label_id = l.id
WHERE m.id = ?
GROUP BY m.id;
```

:octopus: 将 sql 语句进行一次较大调整：不能使用多次左连接来获取最终结果，因为左连接是基于之前的结果进行的；

:ghost: 为了实现互不干扰，需要用到子查询，也就是小括号内，以 SELECT 开头的部分； 

:ghost: 这里用到了条件判断，首参为真时取值第二参，否则取第三参，最后赋值出去；

:octopus: 这里的条件判断避免了使用左连接时，匹配数据也包括数据项为 null 的情况。

:turtle: 在之前的增强前提下，添加了关联的标签数据。





## 头像模块



思路：

1. 实现图片（文件）上传接口，让服务器端保存图片
2. 提供接口，让用户获取到图片
3. 将url存储到用户信息中（avatarURL头像的地址）
4. 获取信息时，也获取到用户头像



### 创建头像表

```sql
CREATE TABLE IF NOT EXISTS `avatar` (
  id INT PRIMARY KEY AUTO_INCREMENT,
  filename VARCHAR(255) NOT NULL UNIQUE,
  mimetype VARCHAR(30),
  size INT,
  user_id INT,
  createAt TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updateAt TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
) ;
```



### 预先准备

#### 用户表添加头像字段

```sql
ALTER TABLE `user` ADD `avatar_url` VARCHAR(200);
```

#### 增加全局配置

<span style="backGround: #efe0b9">.env</span>

```elm
APP_HOST=http://localhost
```

<span style="backGround: #efe0b9">src\app\config.js</span>

```javascript
module.exports = {
  APP_HOST,
  ...,
} = process.env;
```



### 图片上传

```elm
npm install koa-multer
```

#### 注册接口

<span style="backGround: #efe0b9">src\router\file.router.js</span>

```javascript
const Router = require('koa-router');

const {
  verifyAuth
} = require('../middleware/auth.middleware');
const {
  avatarHandler
} = require('../middleware/file.middleware');
const {
  saveAvatarInfo
} = require('../controller/file.controller');

const fileRouter = new Router({prefix: '/upload'});

fileRouter.post('/avatar', verifyAuth, avatarHandler, saveAvatarInfo);

module.exports = fileRouter;
```

#### 实现图片上传

<span style="backGround: #efe0b9">src\middleware\file.middleware.js</span>

```javascript
const Multer = require('koa-multer');
const { AVATAR_PATH } = require('../constants/file-path');

const avatarUpload = Multer({
  dest: AVATAR_PATH
});
const avatarHandler = avatarUpload.single('avatar');

module.exports = {
  avatarHandler
}
```

:ghost: 将图像上传到服务器的指定路径。



#### 保存图片信息

<span style="backGround: #efe0b9">src\controller\file.controller.js</span>

```javascript
const userService = require('../service/user.service');
const fileService = require('../service/file.service');
const { APP_HOST, APP_PORT } = require('../app/config');

class FileController {
  async saveAvatarInfo(ctx, next) {
    // 1.获取图像相关的信息
    const { filename, mimetype, size } = ctx.req.file;
    const { id } = ctx.user;

    // 2.将图像信息数据保存到数据库(头像表)中
    const result = await fileService.createAvatar(filename, mimetype, size, id);

    // 3.将图片地址保存到user表中
    const avatarUrl = `${APP_HOST}:${APP_PORT}/users/${id}/avatar`;
    await userService.updateAvatarUrlById(avatarUrl, id);

    // 4.返回结果
    ctx.body = '上传头像成功~';
  }
}

module.exports = new FileController();
```

:ghost: 实际开发中，图片往往上传到其它服务器上，然后返回一个资源地址。

<span style="backGround: #efe0b9">src\service\file.service.js</span>

```javascript
const connection = require('../app/database');

class FileService {
  async createAvatar(filename, mimetype, size, userId) {
    const statement = `INSERT INTO avatar (filename, mimetype, size, user_id) VALUES (?, ?, ?, ?)`;
    const [result] = await connection.execute(statement, [filename, mimetype, size, userId]);
    return result;
  }
}

module.exports = new FileService();
```

<span style="backGround: #efe0b9">src\service\user.service.js</span>

```javascript
const connection = require('../app/database');

class UserService {
  // ...
  async updateAvatarUrlById(avatarUrl, userId) {
    const statement = `UPDATE user SET avatar_url = ? WHERE id = ?;`;
    const [result] = await connection.execute(statement, [avatarUrl, userId]);
    return result;
  }
}

module.exports = new UserService();
```



### 增强-查询单个动态

<span style="backGround: #efe0b9">src\service\moment.service.js</span>

```javascript
getMomentById
```

```sql
SELECT 
  m.id id, m.content content, m.createAt createTime, m.updateAt updateTime,
  JSON_OBJECT('id', u.id, 'name', u.name, 'avatarUrl', u.avatar_url) author,
  IF(COUNT(l.id),JSON_ARRAYAGG(
    JSON_OBJECT('id', l.id, 'name', l.name)
  ),NULL) labels,
  (SELECT IF(COUNT(c.id),JSON_ARRAYAGG(
    JSON_OBJECT('id', c.id, 'content', c.content, 'commentId', c.comment_id,                   'createTime', c.createAt,            
      'user', JSON_OBJECT('id', cu.id, 'name', cu.name, 'avatarUrl', cu.avatar_url))
  ),NULL) FROM comment c LEFT JOIN user cu ON c.user_id = cu.id WHERE m.id = c.moment_id) comments
FROM moment m
LEFT JOIN user u ON m.user_id = u.id
LEFT JOIN moment_label ml ON m.id = ml.moment_id
LEFT JOIN label l ON ml.label_id = l.id
WHERE m.id = ?
GROUP BY m.id;
```

:turtle: 在之前的增强前提下，给创建动态的用户和评论用户都添加了头像（<span style="color: slategray">avatarUrl</span>）字段。



### 展示图片

```elm
localhost:8000/user/4/avator
```

#### 注册接口

<span style="backGround: #efe0b9">src\router\user.router.js</span>

```javascript
const Router = require('koa-router');
const {
  create,
  avatarInfo
} = require('../controller/user.controller');
const {
  verifyUser,
  handlePassword
} = require('../middleware/user.middleware');

const userRouter = new Router({prefix: '/users'});

userRouter.post('/', verifyUser, handlePassword, create);
userRouter.get('/:userId/avatar', avatarInfo); // 新增

module.exports = userRouter;
```

#### 实现中间件

<span style="backGround: #efe0b9">src\controller\user.controller.js</span>

```javascript
const fs = require('fs');

const fileService = require('../service/file.service');
const { AVATAR_PATH } = require('../constants/file-path');

class UserController {
  // ...
  async avatarInfo(ctx, next) {
    // 1.用户的头像是哪一个文件呢?
    const { userId } = ctx.params;
    const avatarInfo = await fileService.getAvatarByUserId(userId);

    // 2.提供图像信息
    ctx.response.set('content-type', avatarInfo.mimetype);
    ctx.body = fs.createReadStream(`${AVATAR_PATH}/${avatarInfo.filename}`);
  }
}

module.exports = new UserController();
```

:ghost: 设置 content-type 字段后，图片可以正常显示在网页；不设置的话，打开链接的行为是下载。



<span style="backGround: #efe0b9">src\service\file.service.js</span>

```javascript
const connection = require('../app/database');

class FileService {
  //...
  async getAvatarByUserId(userId) {
    const statement = `SELECT * FROM avatar WHERE user_id = ?;`;
    const [result] = await connection.execute(statement, [userId]);
    return result.pop();
  }
}

module.exports = new FileService();
```

数据库会保留之前的头像，应该取最后一张。



#### 常量地址

<span style="backGround: #efe0b9">src\constants\file-path.js</span>

```javascript
const AVATAR_PATH = './uploads/avatar';

module.exports = {
  AVATAR_PATH,
}
```



## 配图模块

> 用于添加到动态上。

### 创建配图表

```sql
CREATE TABLE IF NOT EXISTS `file` (
  id INT PRIMARY KEY AUTO_INCREMENT,
  filename VARCHAR(100) NOT NULL UNIQUE,
  mimetype VARCHAR(30),
  size INT,
  moment_id INT,
  user_id INT,
  createAt TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updateAt TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (moment_id) REFERENCES moment(id) ON DELETE CASCADE ON UPDATE CASCADE
) ;
```



### 多图上传

#### 常量地址

<span style="backGround: #efe0b9">src\constants\file-path.js</span>

```javascript
const AVATAR_PATH = './uploads/avatar';
const PICTURE_PATH = './uploads/picture';

module.exports = {
  AVATAR_PATH,
  PICTURE_PATH // 增加
}
```

#### 注册接口

<span style="backGround: #efe0b9">src\router\file.router.js</span>

```javascript
const Router = require('koa-router');

const {
  verifyAuth
} = require('../middleware/auth.middleware');
const {
  avatarHandler,
  pictureHandler
} = require('../middleware/file.middleware');
const {
  saveAvatarInfo,
  savePictureInfo
} = require('../controller/file.controller');

const fileRouter = new Router({prefix: '/upload'});

fileRouter.post('/avatar', verifyAuth, avatarHandler, saveAvatarInfo);
// 上传动态配图列表
fileRouter.post('/picture', verifyAuth, pictureHandler, savePictureInfo); // 增加

module.exports = fileRouter;
```



#### 实现多图上传

<span style="backGround: #efe0b9">src\middleware\file.middleware.js</span>

```javascript
const Multer = require('koa-multer');
const { AVATAR_PATH, PICTURE_PATH } = require('../constants/file-path');

const avatarUpload = Multer({
  dest: AVATAR_PATH
});
const avatarHandler = avatarUpload.single('avatar');

/* 增加 */
const pictureUpload = Multer({
  dest: PICTURE_PATH
});
const pictureHandler = pictureUpload.array('picture', 9);

module.exports = {
  avatarHandler,
  pictureHandler
}
```

#### 保存图片信息

<span style="backGround: #efe0b9">src\controller\file.controller.js</span>

```javascript
const fileService = require('../service/file.service');

class FileController {
  // ...
  async savePictureInfo(ctx, next) {
    // 1.获取图像信息
    const files = ctx.req.files;
    const { id } = ctx.user;
    const { momentId } = ctx.query;

    // 2.将所有的文件信息保存到数据库中
    for (let file of files) {
      const { filename, mimetype, size } = file;
      await fileService.createFile(filename, mimetype, size, id, momentId);
    }

    ctx.body = '动态配图上传完成~'
  }
}

module.exports = new FileController();
```

<span style="backGround: #efe0b9">src\service\file.service.js</span>

```javascript
const connection = require('../app/database');

class FileService {
  // ...
  async createFile(filename, mimetype, size, userId, momentId) {
    const statement = `INSERT INTO file (filename, mimetype, size, user_id, moment_id) VALUES (?, ?, ?, ?, ?)`;
    const [result] = await connection.execute(statement, [filename, mimetype, size, userId, momentId]);
    return result;
  }
}

module.exports = new FileService();
```



### 增强-查询单个动态

<span style="backGround: #efe0b9">src\service\moment.service.js</span>

```javascript
getMomentById
```

```sql
SELECT 
  m.id id, m.content content, m.createAt createTime, m.updateAt updateTime,
  JSON_OBJECT('id', u.id, 'name', u.name, 'avatarUrl', u.avatar_url) author,
  IF(COUNT(l.id),JSON_ARRAYAGG(
    JSON_OBJECT('id', l.id, 'name', l.name)
  ),NULL) labels,
  (SELECT IF(COUNT(c.id),JSON_ARRAYAGG(
    JSON_OBJECT('id', c.id, 'content', c.content, 'commentId', c.comment_id,                   'createTime', c.createAt,            
      'user', JSON_OBJECT('id', cu.id, 'name', cu.name, 'avatarUrl', cu.avatar_url))
  ),NULL) FROM comment c LEFT JOIN user cu ON c.user_id = cu.id WHERE m.id = c.moment_id)   comments
  (SELECT JSON_ARRAYAGG(CONCAT('http://localhost:8000/moment/images/', file.filename)) 
  FROM file WHERE m.id = file.moment_id) images
FROM moment m
LEFT JOIN user u ON m.user_id = u.id
LEFT JOIN moment_label ml ON m.id = ml.moment_id
LEFT JOIN label l ON ml.label_id = l.id
WHERE m.id = ?
GROUP BY m.id;
```

:turtle: 在之前的增强前提下，增加了配图 <span style="color: slategray">images</span> 字段。



### 增强-分页查询动态

<span style="backGround: #efe0b9">src\service\moment.service.js</span>

```javascript
const connection = require('../app/database');

class MomentService {
  // ...
  async getMomentList(offset, size) {
    const statement = `
      SELECT 
        m.id id, m.content content, m.createAt createTime, m.updateAt updateTime,
        JSON_OBJECT('id', u.id, 'name', u.name) author
        (SELECT COUNT(*) FROM commemt c WHERE c.moment_id = m.id) commentCount
        (SELECT COUNT(*) FROM moment_label ml WHERE ml.moment_id = m.id) labelCount
        (SELECT JSON_ARRAYAGG(CONCAT('http://localhost:8000/moment/images/',                     file.filename)) 
        FROM file WHERE m.id = file.moment_id) images
      FROM moment m
      LEFT JOIN user u ON m.user_id = u.id
      LIMIT ?, ?;
    `;
    const [result] = await connection.execute(statement, [offset, size]);
    return result;
  }
}

module.exports = new MomentService();
```

:whale: 返回的字段中新增配图 <span style="color: slategray">images</span>



### 展示图片

设计：一个动态可能存在多张图片，传递动态Id来取图片有所欠缺，故采用图片名。

```elm
http://localhost:8000/moment/images/52basr32as61a3sf1a6f1
```

#### 注册接口

<span style="backGround: #efe0b9">src\router\moment.router.js</span>

```javascript
const Router = require('koa-router');

const momentRouter = new Router({prefix: '/moment'});

const {
  ...,
  fileInfo
} = require('../controller/moment.controller.js');

// ...
// 动态配图的服务
momentRouter.get('/images/:filename', fileInfo);

module.exports = momentRouter;
```



#### 实现中间件

<span style="backGround: #efe0b9">src\controller\moment.controller.js</span>

```javascript
const fs = require('fs');

const fileService = require('../service/file.service');
const { PICTURE_PATH } = require('../constants/file-path');

class MomentController {
  // ...
  async fileInfo(ctx, next) {
    let { filename } = ctx.params;
    const fileInfo = await fileService.getFileByFilename(filename);

    ctx.response.set('content-type', fileInfo.mimetype);
    ctx.body = fs.createReadStream(`${PICTURE_PATH}/${filename}`);
  }
}

module.exports = new MomentController();
```

<span style="backGround: #efe0b9">src\service\file.service.js</span>

```javascript
const connection = require('../app/database');

class FileService {
  // ...
  async getFileByFilename(filename) {
    const statement = `SELECT * FROM file WHERE filename = ?;`;
    const [result] = await connection.execute(statement, [filename]);
    return result[0];
  }
}

module.exports = new FileService();
```



### 添加图片尺寸处理

用户上传图片后，服务器根据不同尺寸生成多份。

#### 注册接口

<span style="backGround: #efe0b9">src\router\file.router.js</span>

在上传图片的接口，增加一个 <span style="color: slategray">pictureResize</span> 的中间件

```javascript
const Router = require('koa-router');

const {
  verifyAuth
} = require('../middleware/auth.middleware');
const {
  ...,
  pictureResize
} = require('../middleware/file.middleware');
const {
  savePictureInfo
} = require('../controller/file.controller');

const fileRouter = new Router({prefix: '/upload'});

// ...
fileRouter.post('/picture', verifyAuth, pictureHandler, pictureResize, savePictureInfo);

module.exports = fileRouter;
```



#### 实现中间件

```elm
npm install jimp
```

<span style="backGround: #efe0b9">src\middleware\file.middleware.js</span>

```javascript
const path = require('path');

const Multer = require('koa-multer');
const Jimp = require('jimp');
const { AVATAR_PATH, PICTURE_PATH } = require('../constants/file-path');

/* 头像上传 */
const avatarUpload = Multer({
  dest: AVATAR_PATH
});
const avatarHandler = avatarUpload.single('avatar');

/* 图片上传 */
const pictureUpload = Multer({
  dest: PICTURE_PATH
});
const pictureHandler = pictureUpload.array('picture', 9);

/* 调整尺寸后上传 */
const pictureResize = async (ctx, next) => {
  try {
    // 1.获取所有的图像信息
    const files = ctx.req.files;

    // 2.对图像进行处理(sharp/jimp)
    for (let file of files) {
      const destPath = path.join(file.destination, file.filename);
      console.log(destPath);
      Jimp.read(file.path).then(image => { // 创建 image 对象
        image.resize(1280, Jimp.AUTO).write(`${destPath}-large`); // 固定比例，根据宽调整高
        image.resize(640, Jimp.AUTO).write(`${destPath}-middle`); // 然后根据路径写入
        image.resize(320, Jimp.AUTO).write(`${destPath}-small`);
      });
    }

    await next();
  } catch (error) {
    console.log(error);
  }
}

module.exports = {
  avatarHandler,
  pictureHandler,
  pictureResize
}
```

:whale: 对图像处理可以用三方库 sharp / jimp，后者小一点。



#### 增强-展示图片

> 需要前端在请求路径后添加 type=small 这样的信息。

<span style="backGround: #efe0b9">src\controller\moment.controller.js</span>

```javascript
const fs = require('fs');

const fileService = require('../service/file.service');
const { PICTURE_PATH } = require('../constants/file-path');

class MomentController {
  // ...
  async fileInfo(ctx, next) {
    let { filename } = ctx.params;
    const fileInfo = await fileService.getFileByFilename(filename);
    const { type } = ctx.query;
    const types = ["small", "middle", "large"];
    if (types.some(item => item === type)) {
      filename = filename + '-' + type;
    }

    ctx.response.set('content-type', fileInfo.mimetype);
    ctx.body = fs.createReadStream(`${PICTURE_PATH}/${filename}`);
  }
}

module.exports = new MomentController();
```





### 云服务器部署补充

镜像：选择 CentOS （Linux的操作系统），版本8.0.00位以上，会自带 dnf（包管理，之前是yum）

连接云服务器的地址：在阿里云找到对应服务器的公网IP

重启：服务器重启，程序跟随重启

pm2 启动并命名

自动化部署 可以定时（通过执行命令）拉取最新代码并重新部署





