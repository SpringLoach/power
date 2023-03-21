## 直接上传

:star2:  启动后会将整个`images` 目录直接上传

<span style="color: #3a84aa">安装依赖</span>

```shell
cnpm install ali-oss slash@3.0.0 -D -S
```

:octopus: 这里安装的 slash 需要制定版本，否则会报模块引入的错误

<span style="color: #3a84aa">安装别名依赖</span>

```shell
cnpm install module-alias -D -S
```

<span style="color: #3a84aa">配置别名</span>

<span style="backGround: #efe0b9">package.json</span>

```javascript
{
  // ...
  "_moduleAliases": {
    "@": ""
  }
}
```

<span style="color: #3a84aa">进行oss配置</span>

<span style="backGround: #efe0b9">config/config.json</span>

```json
{
  "oss": {
    "region": "",
    "accessKeyId": "",
    "accessKeySecret": "",
    "bucket": ""
  }
}
```

这里的配置项需要从阿里云的云存储服务，注册及获取方式可以参考[博客](https://github.com/a1029563229/Blogs/tree/master/Plugins/Upload)

<span style="color: #3a84aa">编写逻辑</span>

<span style="backGround: #efe0b9">src/direct-upload/index.js</span>

```javascript
// node 引入别名需要引用的包
require("module-alias/register");
const fs = require('fs');
const path = require('path');
const slash = require('slash');
const OSS = require("ali-oss");
const config = require("@/config/config.json");

const allowFile = config.oss.allowFile.split(',');

// 读取目录下的图片文件，收集在 images 中
function readDir(entry, images = []) {
  const dirInfo = fs.readdirSync(entry);
  for (let i = 0; i < dirInfo.length; i++) {
    const item = dirInfo[i];
    // 拼装出文件/文件夹的路径
    const location = path.join(entry, item);
    const isDir = fs.statSync(location).isDirectory();
    // 如果为文件夹则继续递归向下查询
    if (isDir) {
      readDir(location, images);
    // 判断是否为所允许的图片格式
    } else if (allowFile.some(allowScheme => location.endsWith(allowScheme))) {
      images.push(location);
    }
  }
  return images;
}

// 定义检索的入口文件夹（ images 文件夹）
const staticDirPath = path.join(process.cwd(), 'images');
const images = readDir(staticDirPath);

const client = new OSS(config.oss);

async function upload() {
  for (let i = 0; i < images.length; i++) {
    const local_url = slash(images[i]);
    // 获取图片相对路径，作为服务器的存储路径
    const remote_url = `images${local_url.split(staticDirPath)[1]}`;
    // 按顺序依次上传文件
    const result = await client.put(remote_url, local_url)
    console.log(`${result.url} 上传成功`);
  }
  console.log("所有文件上传成功");
}

upload();
```

<span style="color: #f7534f;font-weight:600">slash</span> 用于转换 Windows 反斜杠路径转换为正斜杠路径 \ => /

<span style="color: #3a84aa">配置脚本</span>

```json
"scripts": {
  "direct-upload": "node src/direct-upload"
}
```

<span style="color: #3a84aa">执行</span>

```shell
npm run direct-upload
```





## 观察上传

:star2: 启动后会监听`images` 目录下的变化，并自动上传变化的文件，返回对应的 url。

<span style="color: #3a84aa">实现核心</span>

```elm
- src
  + watch-upload
    - index.js     # 注册上传回调
    - watcher.js   # 监听到文件变化时，调用上传回调
- index.js         # 入口文件，用于注册自定义指令
```

<span style="color: #3a84aa">安装依赖</span>

```shell
cnpm install commander chalk@4.1.0 -D -S
```

<span style="color: #3a84aa">添加脚本</span>

```json
"scripts": {
  "watch-upload": "node index.js upload"
}
```



### 注册指令

<span style="backGround: #efe0b9">[root]/index.js</span>

```javascript
require("module-alias/register");
const fs = require("fs");
const path = require("path");
const program = require("commander");
const pkg = require("./package.json");

const isConfigExist = fs.existsSync(
  path.join(__dirname, "./config/config.json")
);
if (!isConfigExist) throw new Error("You should create config/config.json");

const config = require("@/config");

program
  .version(pkg.version, "-v --version")
  // 注册参数upload，添加描述、回调
  .command("upload")
  .description("upload file to oss")
  .action(() => {
    const OSSUploader = require(`@/src/watch-upload`);
    const oss = new OSSUploader(config.oss);
    oss.watch();
  });

// 解析参数
program.parse(process.argv);

```



### 注册上传回调

<span style="backGround: #efe0b9">src/watch-upload/index.js</span>

```javascript
const fs = require("fs");
const path = require("path");
const OSS = require("ali-oss");
const slash = require("slash");
const chalk = require("chalk");

const Watcher = require("./Watcher");

const DEFAULT_ALLOW_FILE = ["png", "jpg", "jpeg", "gif"];

class OSSUploader {
  constructor(config) {
    this.config = config;
    this.staticDirPath = path.join(__dirname, "../../images");
    this.allowFile = config.allowFile
      ? config.allowFile.split(",")
      : DEFAULT_ALLOW_FILE;
    this._init();
  }

  _init() {
    this.client = new OSS(this.config);
  }

  async putItem(image) {
    if (!fs.existsSync(image)) {
      return;
    }

    // 获取相对路径（images/..）后调用 slash
    // slash: 用于转换 Windows 反斜杠路径转换为正斜杠路径 \ => /
    const objectName = slash(`images${image.split(this.staticDirPath)[1]}`);
    const result = await this.client.put(objectName, image);
    console.log(`${result.url} 上传成功`);
  }

  watch() {
    console.log(chalk.blue("watch imageDir..."));
    const watcher = new Watcher();
    watcher.process(async (file) => {
      await this.putItem(file);
    });
  }
}

module.exports = OSSUploader;
```



### 观察文件变化

<span style="backGround: #efe0b9">src/watch-upload/watcher.js</span>

> 实现观察上传的核心：监听到文件变化时，执行回调

```javascript
const path = require("path");
const fs = require("fs");

const DEFAULT_ALLOW_FILE = ["png", "jpg", "jpeg", "gif"];

class Watcher {
  constructor() {
    this.processes = [];
    this._init();
  }

  _init() {
    const imagesDir = path.join(__dirname, "../../images");
    // 监听文件或目录的改变
    // recursive: true 表示监视所有子目录
    fs.watch(imagesDir, { recursive: true }, (eventType, filename) => {
      if (
        eventType !== "rename" ||
        !DEFAULT_ALLOW_FILE.some((suffix) => filename.endsWith(suffix))
      ) {
        return;
      }

      const file = path.join(imagesDir, filename);
      this.processes.forEach((processFn) => processFn(file));
    });
  }

  process(fn) {
    this.processes.push(fn);
  }
}

module.exports = Watcher;
```



## 附录

<span style="color: #3a84aa">参考资料</span>

- https://github.com/a1029563229/Blogs/tree/master/Plugins/Upload


<span style="color: #3a84aa">其它</span>

- 上传文件到Bucket中产的流量是[不收费](https://www.cnblogs.com/yanbian/p/16988103.html)的，OSS流量只收取公网出流量，5 GB/月的免费额度





