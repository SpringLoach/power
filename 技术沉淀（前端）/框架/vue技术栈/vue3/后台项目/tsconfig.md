<span style="backGround: #efe0b9">.browserslistrc</span>

决定适配的浏览器范围，像babel转化es6->es5，css添加浏览器前缀的时候，会找到该文件作为配置范围。



<span style="backGround: #efe0b9">tsconfig.json</span>

```json
{
  "compilerOptions": {
    // 目标代码(ts -> js(es5/6/7))；由于选择了babel转化es5，这里不需要重复转化了
    "target": "esnext",
    // 目标代码需要使用的模块化方案(commonjs /es module)[es]
    "module": "esnext",
    // 严格的检查(如any)
    "strict": true,
    // 对jsx进行怎么样的处理[保留]
    "jsx": "preserve",
    // 辅助的导入功能
    "importHelpers": true,
    // 按照node的方式去解析模块 import "/index.node"
    "moduleResolution": "node",
    // 跳过一些库的类型检测 (axios -> 类型/ lodash -> @types/lodash / 其他的第三方)
    // 一般开启，防止冲突，提高性能，需要时引入
    // import { Person } from 'axios'
    "skipLibCheck": true,
    // es module 和 commonjs 能否混合使用
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    // 要不要生成映射文件(ts -> js)
    "sourceMap": true,
    // 文件路径在解析时, 基本url[当前文件]
    "baseUrl": ".",
    // 指定具体要解析使用的类型
    "types": ["webpack-env"],
    // 路径解析(类似于webpack alias)别名
    "paths": {
      "@/*": ["src/*"],
      "components/*": ["src/components/*"]
    },
    // 可以指定在项目中可以使用哪里库的 类型 (如Proxy/Window/Document)
    "lib": ["esnext", "dom", "dom.iterable", "scripthost"]
  },
  // 哪些文件需要编译解析
  "include": [
    "src/**/*.ts",
    "src/**/*.tsx",
    "src/**/*.vue",
    "tests/**/*.ts",
    "tests/**/*.tsx"
  ],
  // 排除哪些文件,仅解析引入到文件的类型,不排除会解析引入的整个文件？
  // import type { AxiosInstance } from 'axios'
  "exclude": ["node_modules"]
}
```

由于配置了 babel，会在后续进行转化（转为 es5、模块化等），这里不需要重复转化了
