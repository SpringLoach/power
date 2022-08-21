## 实现脚手架

![image-20220622232824524](D:/笔记/技术沉淀（后端）/node/img/脚手架-目录结构)

### 自定义终端命令

<span style="backGround: #efe0b9">文件目录</span>

```elm
- learn_cli
  + index.js
```

#### 1. 自定义入口文件

```elm
npm init -y
```

<span style="backGround: #efe0b9">package.json</span>

```javascript
"main": "index.js"
```

#### 2. 根据指定环境执行文件

> 以后就不再需要使用 `node index.js` 的命令方式去执行文件。

<span style="backGround: #efe0b9">index.js</span>

```javascript
#!/usr/bin/env node

console.log("hello world")
```

#### 3. 配置指令

 <span style="backGround: #efe0b9">package.json</span>

```json
{
  "bin": {
    "gkd": "index.js"
  }
}
```

> 将上述指令与环境变量建立链接

```elm
npm link
```

#### 4. 执行

```elm
gkd
```



### 配置选项

一般借助 [commander](https://github.com/tj/commander.js/blob/master/Readme_zh-CN.md) 库来完成该功能。

#### 查看版本

```elm
npm install commander
```

```javascript
const program require('commander');

// 先定义（查看版本号）
program.version(require('./package.json').version);

// 再解析参数
program.parse(process.argv);
```

:whale: require 可以加载 js、json、node 格式的文件

**执行**

```elm
gkd --version
```



#### 增加自己的options

> 通过命令行 `gkd --help`，能看到相应信息。

```javascript
const program require('commander');

// 增加自己的options
program.option('-g --gkd', '描述信息');
// 可以要求携带参数
program.option('-d --dest <dest>', 'a destination folder，例如： -d /src/components');

program.parse(process.argv);

 // 获取传入的参数
console.log(program.dest)
```

**执行**

```elm
gkd -d /src/components
```



#### 监听指令

> 执行相应指令后，进行的回调。

```javascript
program.on('--help', function() {
  console.log("");
  console.log("Others:");
  console.log("other options");
})

program.parse(process.argv);
```



#### 封装

```elm
- learn_cli
  + lib
    - core // 核心文件
      + help.js
    - utils // 辅助
```

<span style="backGround: #efe0b9">lib/core/help.js</span>

```javascript
const program = require('commander');

const helpOptions = () => {
  // 增加自己的options
  program.option('-w --why', 'a why cli');
  program.option('-d --dest <dest>', 'a destination folder, 例如: -d /src/components')
  program.option('-f --framework <framework>', 'your frameword')

  program.on('--help', function () {
    console.log("");
    console.log("Other:")
    console.log("  other options~");
  })
}

// 只有一个函数，所以可以这样导出
module.exports = helpOptions;
```

<span style="backGround: #efe0b9">index.js</span>

```javascript
#!/usr/bin/env node
const program = require('commander');

const helpOptions = require('./lib/core/help');

// 查看版本号
program.version(require('./package.json').version);

// 帮助和可选信息
helpOptions();

program.parse(process.argv);
```



### 创建其它指令

#### 初步封装

<span style="backGround: #efe0b9">lib\core\create.js</span>

```javascript
const program = require('commander');

const createCommands = () => {
  // 创建指令，添加描述，添加回调
  program
    .command('create <project> [others...]') // [] 内的为可选参数
    .description('clone a repository into a folder')
    .action((project, others) => {
      console.log(project, others)
  });
}

module.exports = createCommands;
```

<span style="backGround: #efe0b9">index.js</span>

```javascript
#!/usr/bin/env node
const program = require('commander');

const helpOptions = require('./lib/core/help');
const createCommands = require('./lib/core/create');

// 查看版本号
program.version(require('./package.json').version);

// 帮助和可选信息
helpOptions();

// 创建其他指令
createCommands();

program.parse(process.argv);
```

**执行**

```elm
gkd create abc bad cba
```



#### 封装指令方法

由于自定义指令的方法部分逻辑过多，可以将其进行抽离。

```javascript
- learn_cli
  + lib
    - core // 核心文件
      + help.js
      + create.js  // 定义自定义指令
      + actions.js // 定义自定义指令的方法部分（添加）
    - utils // 辅助
```

<span style="backGround: #efe0b9">lib\core\actions.js</span>

```javascript
const createProjectAction = (project) => {

}

module.exports = {
  createProjectAction,
}
```

<span style="backGround: #efe0b9">lib\core\create.js</span>

```javascript
const program = require('commander');

const {
  createProjectAction
} = require('./action');

const createCommands = () => {
  // 创建指令，添加描述，添加回调
  program
    .command('create <project> [others...]') // [] 内的为可选参数
    .description('clone a repository into a folder')
    .action((project, others) => {
      console.log(project, others)
  });
}

module.exports = createCommands;
```



#### demo-创建项目

##### 克隆项目

<span style="backGround: #efe0b9">lib\core\actions.js</span>

```javascript
const createProjectAction = (project) => {
  // 1. clone 项目
  // 2. 执行 npm install
  // 3. 运行 npm run serve
  // 4. 打开浏览器
}

module.exports = {
  createProjectAction,
}
```

```elm
npm install download-git-repo
```

:whale: 该库可用于克隆项目。

###### 转化期约

<span style="backGround: #efe0b9">lib\core\actions.js</span>

```javascript
const { promisify } = require('util');

const download = promisify(require('download-git-repo'));

const createProjectAction = async (project) => {
  // 1.clone项目
  await download();
}

module.exports = {
  createProjectAction
}
```

:whale: node 自带 <span style="color: #a50">util</span> 模块中的 promisify 方法可以将回调转化成 promise 形式。

###### 抽离地址

<span style="backGround: #efe0b9">lib\config\repo-config.js</span>

```javascript
let vueRepo = 'direct:https://github.com/coderwhy/hy-vue-temp.git';

module.exports = {
  vueRepo
}
```

<span style="backGround: #efe0b9">lib\core\actions.js</span>

```javascript
const { promisify } = require('util');

const download = promisify(require('download-git-repo'));

const { vueRepo } = require('../config/repo-config');

const createProjectAction = async (project) => {
  // 1.clone项目
  await download(vueRepo, project, { clone: true });
}

module.exports = {
  createProjectAction
}
```

:turtle: 三个参数的含义：仓库地址、创建项目的路径、创建对应的 `.git` 文件；

:turtle: project 即用户输入的首个传参，这里作为路径使用。

**执行**

> 其它路径下

```elm
gkd create my-project
```



##### 自动化终端命令

```elm
- learn_cli
  + lib
    - core // 核心文件
      + help.js
      + create.js  // 定义自定义指令
      + actions.js // 定义自定义指令的方法部分
    - utils // 辅助
      + terminal.js // 终端命令相关（新增）
```



<span style="backGround: #efe0b9">lib\utils\terminal.js</span>

```javascript
/**
 * 执行终端命令相关的代码
 */
const { spawn } = require('child_process');

// npm install 
const commandSpawn = (...args) => {
  return new Promise((resolve, reject) => {
    const childProcess = spawn(...args);
    childProcess.stdout.pipe(process.stdout);
    childProcess.stderr.pipe(process.stderr);
    childProcess.on("close", () => {
      resolve();
    })
  })
}

module.exports = {
  commandSpawn
}
```

:whale: <span style="color: #a50">child_processsp</span> 模块的 spawn 方法可以帮助执行终端命令。接受的参数：构建工具、执行的具体指令、执行指令的路径。

:turtle: 执行的终端命令实际上会在创建出来的子进程中进行，它内部会有打印信息。想要将它输出到主要进程中（我们输入 `gkd create xx` 的终端），可以通过管道来进行传递。

:turtle: 可以监听进程的关闭，并用期约包装，方便控制时序。



<span style="backGround: #efe0b9">lib\core\actions.js</span>

```javascript
const { promisify } = require('util');

const download = promisify(require('download-git-repo'));

const { vueRepo } = require('../config/repo-config');
const { commandSpawn } = require('../utils/terminal');

const createProjectAction = async (project) => {
  console.log("开始构建项目")

  // 1.clone项目
  await download(vueRepo, project, { clone: true });

  // 2.执行npm install
  const command = process.platform === 'win32' ? 'npm.cmd' : 'npm';
  await commandSpawn(command, ['install'], { cwd: `./${project}` })

  // 3.运行npm run serve
  commandSpawn(command, ['run', 'serve'], { cwd: `./${project}` });
}

module.exports = {
  createProjectAction
}
```

:whale: 对于这种方式的执行终端，需要对 window 系统做兼容，即加上后缀名。



###### 打开到浏览器

```elm
npm install open
```

<span style="backGround: #efe0b9">lib\core\actions.js</span>

```javascript
const { promisify } = require('util');
const path = require('path');

const download = promisify(require('download-git-repo'));
const open = require('open');

const { vueRepo } = require('../config/repo-config');
const { commandSpawn } = require('../utils/terminal');

const createProjectAction = async (project) => {
  // 1.clone项目
  await download(vueRepo, project, { clone: true });

  // 2.执行npm install
  const command = process.platform === 'win32' ? 'npm.cmd' : 'npm';
  await commandSpawn(command, ['install'], { cwd: `./${project}` })

  // 3.运行npm run serve
  commandSpawn(command, ['run', 'serve'], { cwd: `./${project}` });

  // 4.打开浏览器
  open("http://localhost:8080/");
}

module.exports = {
  createProjectAction
}
```

:ghost: 运行 `npm run serve` 的终端不会自动关闭，所以没有采用期约的写法。



#### demo-生成模板vue

##### 组织结构

> 依据之前的封装风格，新建指令。

<span style="backGround: #efe0b9">lib\core\create.js</span>

```javascript
const program = require('commander');

const {
  createProjectAction,
  addComponentAction
} = require('./actions');

const createCommands = () => {
  program
    .command('create <project> [others...]')
    .description('clone a repository into a folder')
    .action(createProjectAction);

  // 新建模板文件：vue
  program
    .command('addcpn <name>')
    .description('add vue component, 例如: why addcpn HelloWorld [-d src/components]')
    .action((name) => {
      addComponentAction(name, program.dest || 'src/components');
    });
}

module.exports = createCommands;
```

:turtle: program.dest 通过配置选项的封装，能够获取到；注意该值可以不传。

<span style="backGround: #efe0b9">lib\core\actions.js</span>

> 思路如下

```javascript
// 添加组件的action
const addComponentAction = async (name, dest) => {
  // 1.编写对应的 ejs 模块
  // 2.编译 ejs 模板，得到 result
  // 3.将 result 写入到 .vue 文件中
  // 4.将文件放到对应的文件夹中
}

module.exports = {
  addComponentAction,
}
```



##### 编写模板

```elm
- src
  + lib
    - templates  // 模板目录
      + vue-component.ejs // 模板文件
```

<span style="backGround: #efe0b9">lib\templates\vue-component.ejs</span>

```vue
<template>
  <div class="<%= data.lowerName %>">
    <h1>{{ msg }}</h1>
  </div>
</template>

<script>
export default {
  name: '<%= data.name %>',
  props: {
    msg: String
  },
  data: function() {
    return {
      message: "<%= data.name %>"
    }
  },
  components: {},
  computed: {},
  methods: {}
  created() {},
  mounted() {},
}
</script>

<style scoped>
  .<%= data.lowerName %> {}
</style>
```

> ejs 语法可以参考[文档](https://ejs.bootcss.com/)，这里只用到了插值。



##### 编译模板

```elm
npm install ejs
```

```elm
- src
  + lib
    - utils  
      + utils.js 
```

<span style="backGround: #efe0b9">lib\utils\utils.js</span>

> 封装编译方法

```javascript
const path = require('path');

const ejs = require('ejs');

// 参数：模板名字，传入的参数
// 输出：编译后的内容
const compile = (templateName, data) => {
  // 先获取模板的绝对路径
  const templatePosition = `../templates/${templateName}`;
  const templatePath = path.resolve(__dirname, templatePosition);

  return new Promise((resolve, reject) => {
    ejs.renderFile(templatePath, { data }, {}, (err, result) => {
      if (err) {
        console.log(err);
        reject(err);
        return;
      }

      resolve(result);
    })
  })
}

module.exports = {
  compile,
}
```

<span style="color: green">:ghost: ejs.renderFile</span> 方法的参数：模板的绝对路径、传参（用于模板中的插值）、配置、处理模板后的回调。

<span style="backGround: #efe0b9">lib\core\actions.js</span>

```javascript
const { compile } = require('../utils/utils');

const addComponentAction = async (name, dest) => {
  // 1.编译ejs模板
  const result = await compile("vue-component.ejs", {name, lowerName: name.toLowerCase()});
    
  // 2.写入文件的操作
}
```



##### 写入文件

<span style="backGround: #efe0b9">lib\core\actions.js</span>

```javascript
const path = require('path');

const { compile, writeToFile } = require('../utils/utils');

// 添加组件的action
const addComponentAction = async (name, dest) => {
  // 1.编译ejs模板 result
  const result = await compile("vue-component.ejs", {name, lowerName: name.toLowerCase()});

  // 2.写入文件的操作
  const targetPath = path.resolve(dest, `${name}.vue`);
  console.log('写入路径：', targetPath);
  writeToFile(targetPath, result);
}

module.exports = {
  addComponentAction,
}
```

<span style="backGround: #efe0b9">lib\utils\utils.js</span>

```javascript
const fs = require('fs');

// 参数：写入的文件、内容
const writeToFile = (pathName, content) => {
  return fs.promises.writeFile(pathName, content);
}

module.exports = {
  writeToFile,
}
```



#### demo-生成新页面

> 每个页面会创建一个新的文件夹，有一个对应路由的js和页面vue文件。

<span style="backGround: #efe0b9">lib\core\create.js</span>

```javascript
const program = require('commander');

const {
  addPageAndRouteAction,
} = require('./actions');

const createCommands = () => {
  // 添加的其它指令

  program
    .command('addpage <page>')
    .description('add vue page and router config, 例如: why addpage Home [-d src/pages]')
    .action((page) => {
      addPageAndRouteAction(page, program.dest || 'src/pages')
    })
}

module.exports = createCommands;
```

<span style="backGround: #efe0b9">lib\core\actions.js</span>

```javascript
const path = require('path');

const { compile, writeToFile } = require('../utils/utils');

// 添加组件和路由
const addPageAndRouteAction = async (name, dest) => {
  // 1.编译ejs模板
  const data = {name, lowerName: name.toLowerCase()};
  const pageResult = await compile('vue-component.ejs', data);
  const routeResult = await compile('vue-router.ejs', data);

  // 3.写入文件
  const targetPagePath = path.resolve(targetDest, `${name}.vue`);
  const targetRoutePath = path.resolve(targetDest, 'router.js')
  writeToFile(targetPagePath, pageResult);
  writeToFile(targetRoutePath, routeResult);
}

module.exports = {
  addPageAndRouteAction,
}
```

> 此时能够创建出两个文件，但是没有将文件放到期望的文件夹中。



##### 生成文件夹

<span style="backGround: #efe0b9">lib\utils\utils.js</span>

```javascript
const path = require('path');
const fs = require('fs');

// 传入文件夹的路径，如果不存在则创建（递归）
const createDirSync = (pathName) => {
  if (fs.existsSync(pathName)) {
    return true;
  } else {
    if (createDirSync(path.dirname(pathName))) {
      fs.mkdirSync(pathName);
      return true;
    }
  }
}

module.exports = {
  createDirSync
}
```

> 递归的基线条件保证：最顶层的路径是一定存在的。

<span style="backGround: #efe0b9">lib\core\actions.js</span>

```javascript
// 添加组件和路由
const addPageAndRouteAction = async (name, dest) => {
  // 1.编译ejs模板
  const data = {name, lowerName: name.toLowerCase()};
  const pageResult = await compile('vue-component.ejs', data);
  const routeResult = await compile('vue-router.ejs', data);

  // 3.写入文件
  const targetDest = path.resolve(dest, name.toLowerCase());
  if (createDirSync(targetDest)) {
    const targetPagePath = path.resolve(targetDest, `${name}.vue`);
    const targetRoutePath = path.resolve(targetDest, 'router.js')
    writeToFile(targetPagePath, pageResult);
    writeToFile(targetRoutePath, routeResult);
  }
}
```



### 发布到npm

1. 注册 [npm](https://www.npmjs.com/) 账号

2. 登录

  ```elm
  npm login
  ```

>  接下来输入账户、密码、邮箱。

3. 调整 <span style="backGround: #efe0b9">package.json</span>

  ```json
  "keywords": ["why", "vue", "demo"], // 在官网，可以通过关键字搜索包
  "author": "demo", // 作者
  "license": "MIT", // 协议
  "homepage": "https://github.com/coderwhy/coderwhy", // 包的主页
  "repository": { // 管理包的类型和地址
    "type": "git",
    "url": "https://github.com/coderwhy/coderwhy"
  },
  ```

4. 发布

```elm
npm publish
```







