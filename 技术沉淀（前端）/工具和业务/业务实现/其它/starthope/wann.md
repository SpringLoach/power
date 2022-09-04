## 账号资料

#### 获取前端项目

根据[账号资料](http://starthope.tpddns.cn:8443/!/#iMannings/view/head/iMannings_document/%E5%95%86%E5%8A%A1%E6%96%87%E6%A1%A3/%E8%B4%A6%E5%8F%B7%E8%B5%84%E6%96%99.txt)的第二点，进入git获取前端项目 `manning-cloud-store`，导入后，需要切换到  `feature-order` 分支进行开发

#### 前端项目的安装运行

需要将 `node_modules` 删除后，在命令行中运行 `npm install`，如果报错，再运行 `cnpm install`。运行启动命令后，如果报错，需要重复该过程。

#### 前端页面的权限获取

运行项目后，页面会要求输入 `token ` 值，根据[账号资料](http://starthope.tpddns.cn:8443/!/#iMannings/view/head/iMannings_document/%E5%95%86%E5%8A%A1%E6%96%87%E6%A1%A3/%E8%B4%A6%E5%8F%B7%E8%B5%84%E6%96%99.txt)的第四点，前往对应网页并登录，从中获取 `login` 请求的响应字段 `token` 。

#### 前端项目的拉取/修改权限

需要开启 [VPN](https://124.90.46.14:4431)

#### 开启代码检测

该项目需要开启 eslint 模式，从 HbuilderX 的插件市场搜索 `eslint`，将搜索到的两个插件下载，并配置为实时开启。需要注意每个对象的最后一个属性都要添加 `,`

#### 代码规范

对应阿里前端[开发规范](https://w3ctim.com/post/1d821dd8.html)，同时要注意git的[提交规范](http://starthope.tpddns.cn:8443/!/#iMannings/view/head/iMannings_document/%E8%AE%BE%E8%AE%A1%E6%96%87%E6%A1%A3/git%E6%8F%90%E4%BA%A4%E8%A6%81%E6%B1%82.txt)。

#### 接口文档

[跳转](https://mannings-dev.miyatech.com/api/order/swagger-ui.html#/%E4%B8%87%E5%AE%81B%E7%AB%AF%E8%AE%A2%E5%8D%95%E6%8E%A5%E5%8F%A3)。

#### 高保真

[飞书](https://f0ldzgf7pd.feishu.cn/drive/home/)、

#### 微信 AppId

wxc836213220ab21fb



#### 本地调联

```react
/* 将工程名替换为小伙伴的本地服务器 */
url: 'user/auth/member/get-logout-information',

url: 'http://192.168.0.209:8086/auth/member/get-logout-information',
```

| --       | --   |
| -------- | ---- |
| haosong  | 214  |
| shanhuan | 209  |



## 开发规范

### 页面结构

```react
- 万宁
  + src
    - pages
      + order                     // 相关主题的页面
        - list                    // 具体的页面
          + components            // 子组件
            - Edit.vue
            - List.vue
            - Search.vue
          + model
            - index.js            // 存放某些下拉框等的枚举值，使用时通过底部的方法转化为需要的格式
          + vuex
            - common.js           // 定义页面需要的全部接口，定义涉及到修改状态、接口调用的方法
            - mutations.js        // 存放了两个最常用的同步方法：设置/更新，供 common.js 使用
            - store.js            // 定义了需要用到的 state
          + index.vue             // 页面组件（父组件），由子组件组成，耦合度低
```

> 所有从接口拿到的 需要用到的 数据，都直接保存在状态中。



### 页面接口

```react
- 万宁
  + src
    - api
      + order
        - list
          + index.js
```

跳转[接口文档](https://mannings-dev.miyatech.com/api/order/swagger-ui.html#/万宁B端订单接口/pageUsingGET)，具体接口的响应，点击 Model，然后点开内部的结构，可能会有中文注释



### 状态



#### 页面状态 & 同步方法注册到全局状态管理

```
- 万宁
  + src
    - store
      + index.js
```

```javascript
import orderListState from '@/pages/order/list/vuex/store';
import orderListMutations from '@/pages/order/list/vuex/mutations';

const state = {
  orderListState,
};

const mutations = {
  ...orderListMutations,
};
```



#### 同步方法的定义

`mutation.js`

```javascript
export default {
  UPDATE_ORDER_LIST_STATE: (state, payload) => {
    state.orderListState[payload.key] = payload.value;
  },
  SET_ORDER_LIST_DATA: (state, payload) => {
    state.orderListState.listData[payload.key] = payload.value;
  },
};
```

`common.js`

```javascript
export default {
  methods: {
    /* 相当于设置状态 show 的值 */  
    setShow(value) {
      this.$store.commit('UPDATE_ORDER_LIST_STATE', {
        key: 'show',
        value,
      });
    },
  }
}
```

:star2: `mutation.js` 中的同步方法会另行注册到全局状态管理中。



#### 状态的使用

```javascript
import { mapState } from 'vuex';

export default {
  computed: {
    ...mapState(['orderListState']),
    /* 有的状态会抽出来再使用 */  
    isEdit() {
      return this.orderListState.isEdit;
    },  
  }
  methods: {
    /* 有的状态则不会 */
    demo() {
      console.log(this.orderListState.isDemo);
    }
  }
}
```

直接取到的 `orderListState` 相当于在全局状态管理中导入的，对应着 `当前页面文件夹 - vuex - store.js` 的整个模块，使用具体的状态还要再下一层。



#### 状态方法的使用

```javascript
import commonVuex from './vuex/common';
export default {
  mixins: [commonVuex],
}
```

直接在组件中通过 `this.xx()` 可以调用该文件中的方法



### 跳转到新页面/组件

|      操作位置      | 步骤                         | 补充                 |
| :----------------: | :--------------------------- | -------------------- |
| 调用 vuex 中的方法 | 发起请求，将结果保存到状态中 | 请求前后设置加载图标 |
| 调用 vuex 中的方法 | 更改状态的值                 | 该值条件渲染目标组件 |
|   跳转的目标组件   | 将状态的值保存到本地，渲染   | watch、created       |


