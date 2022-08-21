## 网易云收尾

### 打包结构

| --                 | --                                    |
| ------------------ | ------------------------------------- |
|                    | 对于较小的图片资源，会被转化为 base64 |
| main.xx.chunk.css  | 自己编写的应用程序中的样式            |
| xx.chunk.css       | 第三方库/引入的 css                   |
| xx.chunk.js        | 第三方库（axios、react、redux）       |
| main.xx.chunk.js   | 自己编写的应用程序                    |
| runtime-main.xx.js | 应用程序运行依赖的代码                |

使用路由懒加载时，将会拆解 main.xx.chunk.js



### 手动构建

| 步骤               | 说明                     |
| ------------------ | ------------------------ |
| 准备服务器         | 阿里云、腾讯云           |
| 服务器安装操作系统 | 通常安装 centos          |
| 资源准备           | 打包资源移动到服务器     |
| 连接服务器         | 通过 ssh 连接远程服务器  |
| 安装 Nginx 服务    | 可以借助 yum 工具        |
| 配置 Nginx 代理    | 主配置文件会读取相关配置 |
| 配置 Nginx 代理    | 在相关配置下配置就好     |

自动化部署略（通过 Jenkins）



## SSR 和 Next.js

| --           | --                                                           |
| ------------ | ------------------------------------------------------------ |
| CSR          | 客户端渲染                                                   |
| 单页面富应用 | 请求初始的 HTML 后，执行到 JS 时，进行更多请求               |
| 单页面富应用 | 首屏显示的速度较慢；不利于SEO的优化                          |
| SSR          | 服务端渲染                                                   |
| 服务端渲染   | 在服务器端已经生成了完整的HTML页面结构                       |
| 服务端渲染   | 早期包括PHP、JSP、ASP等方式；现在可以借助 Node 运行 JavaScript |
| 同构         | 现代SSR的一种表现形式：既可以在服务端运行又可以在客户端运行的代码 |
| React SSR    | 较成熟的框架 Next.js                                         |
| Vue SSR      | 较成熟的框架 Nuxt.js                                         |



安装Next.js框架的<span style="color: #a50">脚手架</span>

```elm
npm install –g create-next-ap
```

创建Next.js项目

```elm
create-next-app next-demo
```



<span style="backGround: #efe0b9">package.json</span>

```json
"scripts": {
  "dev": "next dev",      // 运行开发环境
  "build": "next build",  // 打包
  "start": "next start"   // 执行打包的项目
}
```



### 路由映射关系

```elm
- pages
  + index.js    // 对应 /
  + about.js    // 对应 /about
  + demo
    - index.js  // 对应 /demo
```

项目下的 pages 文件夹中的组件，会自动配置路由映射关系；

pages/index.js 为默认路径。



### 跳转到其它路由



#### 通过普通链接跳转

```html
<a href="about">关于</a>
```

将会刷新页面，本质上请求了下面的路径（服务端渲染）：

```elm
http://localhost:3000/about
```



#### 通过组件链接跳转

页面不会刷新，仅加载分包内容（客户端渲染）

pages\index.js

```react
import Link from 'next/link';

export default function Home() {
  return (
    <div>
      <Link href="/about">
        <a>关于</a>
      </Link>
    </div>
  )
}
```



### 添加页面标题

pages\index.js

```react
import Head from 'next/head';

export default function Home() {
  return (
    <div>
      <Head>
        <title>网易云音乐</title>
      </Head>
    </div>
  )
}
```

仅当前路由对应的页面会有该标题。



### 共享公共头尾

#### 方案一

让不同路径对应的页面使用相同的一些部分。

```elm
- components
  + app-layout
    - index.js
```

components\app-layout\index.js

```react
import React, { memo } from 'react';
import Head from 'next/head';
import Link from 'next/link';

export default memo(function AppLayout(props) {
  return (
    <div>
      <Head>
        <title>网易云音乐</title>
      </Head>
      <header>
        <h2>Header</h2>
        <Link href="/">
          <a>首页</a>
        </Link>
        <Link href="/about">
          <a>关于</a>
        </Link>
        <hr />
      </header>
      {props.children}
      <footer>
        <hr />
        <p>网站是一个音乐网站</p>
      </footer>
    </div>
  )
})
```

pages\index.js

```react
import AppLayout from '../components/app-layout';

export default function Home() {
  return (
    <AppLayout>
      <div>首页的一些独特内容</div>
    </AppLayout>
  )
}
```



#### 方案二

```elm
- pages
  + _app.js // 整个应用程序（文档中的挂载元素部分）
  + _document.js // 整个文档
```

pages/\_app.js

```react
import '../styles/globals.css';
import Head from 'next/head';
import Link from 'next/link';

function MyApp({ Component, pageProps }) {
  return (
    <>
      <Head>
        <title>网易云音乐</title>
      </Head>
      <Component {...pageProps} />
      <footer>
        <hr />
        <p>网站是一个音乐网站</p>
      </footer>
    </>
  )
}

export default MyApp
```

也可以创建 _document.js 文件，从文档维度添加公共的东西。



### 使用样式

#### 全局样式

```elm
- 项目
  + pages
    - _app.js
  + styles 
    - globals.css      // 自带，全局样式
    - app.css          // 自建，另外的全局样式
    - Home.module.css  // 自带，局部样式
```



pages\_app.js

```
import '../styles/globals.css';
import '../styles/app.css';
```

引入该文件中的样式，将成为全局样式



#### 局部样式

##### 方式一

定义

styles\Home.module.css

```css
.title {
  font-size: 50px;
  text-decoration: underline;
}
```

使用

pages\index.js

```react
import styles from '../styles/Home.module.css';

export default function Home() {
  return (
    <div>
      <h1 className={styles.title}>Home页面</h1>
    </div>
  )
}
```



##### 方式二

pages\about.js

```react
import React, { memo } from 'react';
import AppLayout from '../components/app-layout';

export default memo(function About() {
  return (
    <div>
      <h2 className="title">About</h2>
      <p>公司成立于2000年, 拥有悠久的历史!</p>

      <style>{`
        p {
          color: blue;
          text-decoration: underline;
        }
      `}</style>
    </div>
  )
})
```

Next.js 自带 styled-jsx，这是一种 css in js 的技术





##### 方式三

使用 styled-components

```
yarn add styled-components
```

要进行额外的配置，否则在服务端渲染时（刷新页面），会有问题。

```
yarn add babel-plugin-styled-components
```

.babelrc

```javascript
{
  "presets": [
    "next/babel"
  ],
  "plugins": [
    ["styled-components"]
  ]
}
```

```elm
- pages
  + profile
    - index.js
    - style.js
- .babelrc
```



pages\profile\index.js

```react
import React, { memo } from 'react';

import { ProfileWrapper } from './style';

export default memo(function Profile() {
  return (
    <ProfileWrapper>
      <h2>Profile</h2>
      <span>demo</span>
    </ProfileWrapper>
  )
})

```

pages\profile\style.js

```less
import styled from 'styled-components';

export const ProfileWrapper = styled.div`
  span {
    color: orange;
    font-size: 20px;
  }
`
```



### 嵌套路由

```elm
- pages
  + profile
    - info
      + index.js	// 孙路由
    - settings
      + index.js    // 孙路由
    - layout
      + index.js    // 布局，控制孙路由的展示
    - index.js      // 子路由
```



布局组件

pages\profile\layout\index.js

```react
import React, { memo } from 'react';

import Link from 'next/link';

export default memo(function ProfileLayout(props) {
  return (
    <div>
      <h2>Profile</h2>
      <Link href="/profile/info">
        <a>信息</a>
      </Link>
      <Link href="/profile/settings">
        <a>设置</a>
      </Link>
      {props.children}
    </div>
  )
})
```

子路由页面

pages\profile\index.js

```react
import React, { memo } from 'react';

import Layout from './layout';

export default memo(function Profile() {
  return (
    <Layout></Layout>
  )
})
```

孙路由页面

pages\profile\settings\index.js

```react
import React, { memo } from 'react';

import Layout from '../layout';

export default memo(function ProfileSettings() {
  return (
    <Layout>
      <h2>Settings</h2>
    </Layout>
  )
})
```



### 路由跳转传参

#### 通过组件跳转

```react
export default function Home() {
  const item = 123
  return (
    <div>
      <Link href={`/recommend?id=${item}`}>
        <span>推荐数据id:{item}</span>
      </Link>
    </div>
  )
}
```

#### 通过代码跳转

```react
import Router from 'next/router';

export default function Home() {
  const recommentItemClick = (item) => {
    Router.push({
      pathname: "/recommend",
      query: {
        id: item
      }
    })
  }
  return (
    <div>
      <span onClick={e => recommentItemClick(123)}>点击跳转</span>
    </div>
  )
}
```

#### 接收参数

```react
import React, { memo } from 'react';

import { useRouter } from 'next/router';

export default memo(function Recommend() {
  const router = useRouter();
  console.log(router);

  return (
    <div>
      <h2>Recommend: {router.query.id}</h2>
    </div>
  )
})
```



### 网络请求

```elm
yarn add axios
```

```react
import axios from 'axios';

const Home = function (props) {
  const { name, banners, recommends } = props;

  return (
    <div>
      <h2>name: {name}</h2>
    </div>
  )
}

Home.getInitialProps = async (props) => {
  const res = await axios({ url: "http://123.207.32.32:8000/home/multidata" });

  return {
    name: "why",
    banners: res.data.data.banner.list,
    recommends: res.data.data.recommend.list
  }
}

export default Home;
```

不能在 <span style="color: #a50">useEffect</span> 中进行网络请求，这在服务端渲染时会导致问题；

组件有一个 <span style="color: #ff0000">getInitialProps</span> 属性，可以在这里异步的给组件添加初始化数据。
