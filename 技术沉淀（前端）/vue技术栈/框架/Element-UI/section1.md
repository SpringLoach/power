## 指南

### CDN引用

> 注意要**先**引入vue才能正常使用，而且需要使用到vue挂载的元素上。

```react
<head>
  <!-- 引入样式 -->
  <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
  <!-- 引入组件库 -->
  <script src="https://cdn.staticfile.org/vue/2.6.11/vue.min.js"></script>
  <script src="https://unpkg.com/element-ui/lib/index.js"></script>
</head>
    
<script>
new Vue({
    el: '#app',
    data: function() {
    return { visible: false }
    }
})
</script>
```

------

### 快速上手

> 针对CDN引用外的其它[引入方式](https://github.com/SpringLoach/Vue/blob/main/learning/实验项.md#安装element)，可以完整引入或按需引入。

#### 按需引入

> 按需引入时，通常先导入，然后安装/添加到原型。

```react
import {Dialog, Message} from 'element-ui';

/* 安装 */
Vue.use(Dialog);

/* 添加到原型 */
Vue.prototype.$message = Message;
```

#### 全局配置

> 在导入组件后，安装组件前进行配置。

```react
// 拥有 size 属性的组件的默认尺寸均为 'small'，弹框的初始 z-index 为 3000。
Vue.prototype.$ELEMENT = { size: 'small', zIndex: 3000 };
```

------

### 内置过渡动画

> 可以[按需引入](https://element.faas.ele.me/#/zh-CN/component/transition#an-xu-yin-ru)。

#### 淡入淡出

| 类型          | name              |
| ------------- | ----------------- |
| 淡入淡出-线性 | el-fade-in-linear |
| 淡入淡出      | el-fade-in        |
| 缩放-沿中间   | el-zoom-in-center |
| 缩放-沿顶     | el-zoom-in-top    |
| 缩放-沿底     | el-zoom-in-bottom |

```react
// 控制按钮，需要初始化 show
<el-button @click="show = !show">Click Me</el-button>

<transition name="el-zoom-in-top">
  <div v-show="show">abc</div>
</transition>
```

#### 展开折叠

```react
<el-button @click="show = !show">Click Me</el-button>

<el-collapse-transition>
  <div v-show="show">abc</div>
</el-collapse-transition>
```



## Basic

### Layout布局

> 在行标签内镶嵌列标签，列标签占据的**最大**列数总合为24。

```react
import {Row, Col} from 'element-ui';

Vue.use(Row);
Vue.use(Col);
<el-row>
  <el-col :span="3"><div>abc</div></el-col>
  <el-col :span="2"><div>def</div></el-col>
</el-row>
```

| Row属性 | 说明                                                         | 类型 | 默认值 |
| ------- | ------------------------------------------------------------ | ---- | ------ |
| :gutter | 栅格间隔                                                     | num  | 0      |
| type    | 布局模式，可选 flex                                          | str  | /      |
| justify | flex-[水平排列方式](https://element.eleme.cn/#/zh-CN/component/layout) | str  | start  |
| align   | flex-垂直排列方式                                            | str  | /      |

| Col属性 | 说明                         | 类型 | 默认值 |
| ------- | ---------------------------- | ---- | ------ |
| :span   | 栅格占据的列数               | num  | 24     |
| :offset | 栅格左侧的间隔格数           | num  | 0      |
| :push   | 栅格向右移动格数（相对定位） | num  | 0      |

### Container布局容器

> 采取了 flex 布局。
>
> 当存在顶栏或低栏容器时，子元素垂直上下排列，否则水平排列。

```react
import {Container, Header, Aside, Main, Footer,} from 'element-ui';

Vue.use(Container);
Vue.use(Header);
Vue.use(Aside);
Vue.use(Main);
Vue.use(Footer);
```

| 标签             | 说明               |
| ---------------- | ------------------ |
| `<el-container>` | **必须的外层容器** |
| `<el-header>`    | 顶栏容器           |
| `<el-aside>`     | 侧边栏容器         |
| `<el-main>`      | 主要区域容器       |
| `<el-footer>`    | 底栏容器           |

| 属性   | 说明        | 类型 | 默认值 |
| ------ | ----------- | ---- | ------ |
| height | 顶/底栏高度 | str  | 60px   |
| width  | 侧边栏宽度  | str  | 300px  |

> 可以在内部嵌套 `<el-container>`，使子元素能够垂直排列。

```react
<el-container>
  <el-header>Header</el-header>
  <el-container>
    <el-aside width="200px">Aside</el-aside>
    <el-main>Main</el-main>
  </el-container>
</el-container>
```

### 字体和投影参考

字体

```less
font-family: "Helvetica Neue",Helvetica,"PingFang SC","Hiragino Sans GB","Microsoft YaHei","微软雅黑",Arial,sans-serif;
```

基础投影

```css
box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04)
```

浅色投影

```css
box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1)
```

### Icon图标

> 直接给相应标签添加类 `el-icon-iconName` 即可。

```react
// 纯图标
<i class="el-icon-loading"></i>

// 按钮组合图标
<el-button type="primary" icon="el-icon-search">搜索</el-button>
```

### Button按钮

> 可以不添加文本节点来制作图标按钮。

| 属性        | 说明       | 类型 | 默认值 | 可选值                                             |
| ----------- | ---------- | ---- | ------ | -------------------------------------------------- |
| size        | 尺寸       | str  | /      | medium / small / mini                              |
| type        | 类型       | str  | /      | primary / success / warning / danger / info / text |
| icon        | 图标类名   | str  | /      | /                                                  |
| native-type | 原生-类型  | str  | button | button / submit / reset                            |
| plain       | 朴素按钮   | boo  | false  | /                                                  |
| round       | 圆角按钮   | boo  | false  | /                                                  |
| circle      | 圆形按钮   | boo  | false  | /                                                  |
| loading     | 加载中状态 | boo  | false  | /                                                  |
| disabled    | 禁用状态   | boo  | false  | /                                                  |
| autofocus   | 默认聚焦   | boo  | false  | /                                                  |

### Link文字链接

| 属性      | 说明           | 类型 | 默认值  | 可选值                                      |
| --------- | -------------- | ---- | ------- | ------------------------------------------- |
| type      | 类型，影响颜色 | str  | default | primary / success / warning / danger / info |
| underline | 悬浮下划线     | boo  | true    | /                                           |
| icon      | 图标类名       | str  | /       | /                                           |
| disabled  | 禁用状态       | boo  | false   | /                                           |
| href      | 原生-链接      | str  | /       | /                                           |
| round     | 圆角按钮       | boo  | false   | /                                           |
| circle    | 圆形按钮       | boo  | false   | /                                           |



## Form

### Radio单选框

> 选中时，将相应的 `label` 的值赋值给绑定值。

```react
<el-radio v-model="selectFruit" label="apple">苹果</el-radio>
<el-radio v-model="selectFruit" label="peach">桃子</el-radio>
```

| 项属性   | 说明                     | 类型        | 默认值                | 可选值 |
| -------- | ------------------------ | ----------- | --------------------- | ------ |
| v-model  | 绑定值                   | str/num/boo | /                     | /      |
| label    | 单选框的值               | str/num/boo | /                     | /      |
| disabled | 禁用                     | boo         | false                 | /      |
| border   | 边框                     | boo         | false                 | /      |
| size     | 尺寸，需要 `border` 为真 | str         | medium / small / mini | /      |
| name     | 原生-name                | str         | /                     | /      |

#### 单选框组

> 适用于在多个互斥的选项中选择的场景，无需给项绑定变量。

```react
<el-radio-group  v-model="selectFruit">
  <el-radio label="apple">苹果</el-radio>
  <el-radio label="peach">桃子</el-radio>
</el-radio-group>
```

| 组属性     | 说明                              | 类型        | 默认值                | 可选值 |
| ---------- | --------------------------------- | ----------- | --------------------- | ------ |
| v-model    | 绑定值                            | str/num/boo | /                     | /      |
| disabled   | 禁用                              | boo         | false                 | /      |
| size       | 尺寸，需要 `border` 为真/按钮形式 | str         | medium / small / mini | /      |
| text-color | 按钮形式，激活文本颜色            | str         | #ffffff               | /      |
| fill       | 按钮形式，激活填充色              | str         | #409EFF               | /      |

| 项/组事件 | 说明                   | 回调参数          |
| --------- | ---------------------- | ----------------- |
| change    | 绑定值变化时触发的事件 | 选中项的 label 值 |

#### 按钮样式

> 只需替换项元素即可。

```react
<el-radio-group  v-model="selectFruit">
  <el-radio-button label="apple">苹果</el-radio-button>
  <el-radio-button label="peach">桃子</el-radio-button>
</el-radio-group>
```

按钮属性

> label、disabled、name。

### Checkbox多选框

> 单独使用可以表示两种状态之间的切换。
>
> 标签中的内容为按钮后的介绍。

```react
<el-checkbox v-model="isChecked">大西瓜</el-checkbox>
```

| 项属性   | 说明                     | 类型        | 默认值                | 可选值 |
| -------- | ------------------------ | ----------- | --------------------- | ------ |
| v-model  | 绑定值                   | str/num/boo | /                     | /      |
| label    | 需要组标签，选中项的值   | str/num/boo | /                     | /      |
| checked  | 设为勾选                 | boo         | false                 | /      |
| disabled | 禁用                     | boo         | false                 | /      |
| border   | 边框                     | boo         | false                 | /      |
| size     | 尺寸，需要 `border` 为真 | str         | medium / small / mini | /      |
| name     | 原生-name                | str         | /                     | /      |

#### 多选框组

```react
<el-checkbox-group v-model="fruitList">
  <el-checkbox label="apple"></el-checkbox>
  <el-checkbox label="peach"></el-checkbox>
  <el-checkbox label="orange"></el-checkbox>
</el-checkbox-group>
```

| 组属性     | 说明                      | 类型 | 默认值                | 可选值 |
| ---------- | ------------------------- | ---- | --------------------- | ------ |
| v-model    | 绑定值                    | arr  | /                     | /      |
| disabled   | 禁用                      | boo  | false                 | /      |
| min        | 可被勾选最小数量          | num  | /                     | /      |
| max        | 可被勾选最大数量          | num  | /                     | /      |
| size       | 尺寸，需要有边框/按钮形式 | str  | medium / small / mini | /      |
| text-color | 按钮形式，激活文本颜色    | str  | #ffffff               | /      |
| fill       | 按钮形式，激活填充色      | str  | #409EFF               | /      |

| 项/组事件 | 说明             | 回调参数   |
| --------- | ---------------- | ---------- |
| change    | 绑定值变化时触发 | 更新后的值 |

#### 按钮样式2

> 只需要把项元素替换为 `el-checkbox-button` [即可](https://github.com/SpringLoach/Vue/blob/main/plugins/Element-UI/section1.md#按钮样式)。

按钮属性

> label、disabled、name、checked...。

### Input输入框

> 需要绑定值才能正常使用。
>
> 不支持 `v-model`修饰符。

```react
<el-input v-model="variable" placeholder="请输入"></el-input>
```

| 项属性          | 说明                           | 类型    | 默认值 | 可选值                         |
| --------------- | ------------------------------ | ------- | ------ | ------------------------------ |
| type            | 类型                           | str     | text   | textarea（文本域） / 原生-type |
| v-model         | 绑定值                         | str/num | /      | /                              |
| placeholder     | 占位文本                       | str     | /      | /                              |
| disabled        | 禁用                           | boo     | false  | /                              |
| clearable       | 清空                           | boo     | false  | /                              |
| show-password   | 切换密码状态                   | boo     | false  | /                              |
| autosize        | （需文本域类型）自适应内容高度 | boo/obj | false  | /                              |
| size            | 输入框尺寸                     | str     | /      | large / small / mini           |
| maxlength       | 原生-最大输入长度              | num     | /      | /                              |
| minlength       | 原生-最小输入长度              | num     | /      | /                              |
| show-word-limit | 显示输入字数统计               | boo     | false  | /                              |

#### 复合元素使用

> 可以添加按钮、[图标](https://github.com/SpringLoach/Vue/blob/main/plugins/Element-UI/section1.md#Icon图标)、使用插槽添加文本，添加一到多个元素。

```react
// 文本
<el-input>
  <template slot="append">.com</template>
</el-input>
// 图标按钮
<el-input>
  <el-button slot="append" icon="el-icon-search"></el-button>
</el-input>
```

| slot值  | 说明     |
| ------- | -------- |
| prefix  | 头部内容 |
| suffix  | 尾部内容 |
| prepend | 前置内容 |
| append  | 后置内容 |

#### 带建议的输入框

> 在元素渲染完毕后，将请求到的数据保存到本地。
>
> 建议方法的回调参数为输入字符串、接收筛选后建议列表数组的回调。
>
> 筛选数组的每个项的 `value` 值会被输出成建议。
>
> 也可以[复合元素使用](https://github.com/SpringLoach/Vue/blob/main/plugins/Element-UI/section1.md#复合元素使用)。

```react
<el-autocomplete v-model="selectRes" :fetch-suggestions="querySearch"></el-autocomplete>

data() {
  return {
    restaurants: [],
    selectRes: ''
  };
},
methods: {
  querySearch(queryString, cb) {
    let restaurants = this.restaurants;
    let results = queryString ? restaurants.filter(this.createFilter(queryString)) : restaurants;
    // 调用建议列表的数据
    cb(results);
  },
  createFilter(queryString) {
    return (restaurant) => {
      return (restaurant.value.toLowerCase().indexOf(queryString.toLowerCase()) === 0);
    };
  },
  loadAll() {
    return [
      { value: "三全鲜食（北新泾店）" },
      { value: "Hot honey 首尔炸鸡（仙霞路）" }
    ];
  }
},
mounted() {
  this.restaurants = this.loadAll();
}
```

| 属性                   | 说明                                  | 类型                     | 默认值 | 可选值 |
| ---------------------- | ------------------------------------- | ------------------------ | ------ | ------ |
| v-model                | 绑定值                                | str/num                  | /      | /      |
| :fetch-suggestions     | 返回输入建议的方法                    | F(queryString, callback) | /      | /      |
| placeholder            | 占位文本                              | str                      | /      | /      |
| :trigger-on-focus      | 激活即列出输入建议                    | boo                      | true   | /      |
| :popper-append-to-body | 将下拉列表插入 body，可能**影响定位** | boo                      | true   | /      |
| disabled               | 禁用                                  | boo                      | false  | /      |
| :debounce              | 获取输入建议的去抖延时                | num                      | 300    | /      |

#### 自定义模板

> 可以改变建议模板，而不是只能选择 `value` 作为输出。
>
> 模板标签的 `slot-scope` 属性指向每一条建议。

```react
<el-autocomplete v-model="selectRes" :fetch-suggestions="querySearch">
  <template slot-scope="{ item }">
    <div class="name">{{ item.value }}</div>
    <span class="addr">{{ item.address }}</span>
  </template>
</el-autocomplete>
```

#### 输入长度建议

> 需要配合限制长度属性使用。

```react
<el-input v-model="any" :maxlength="12" show-word-limit></el-input>
```

### InputNumber计数器

> 可手动或通过控制器改变数值。只需绑定值即可。

```react
<el-input-number v-model="num" :min="1" :max="3"></el-input-number>
```

| 属性              | 说明                   | 类型 | 默认值    | 可选值                |
| ----------------- | ---------------------- | ---- | --------- | --------------------- |
| v-model           | 绑定值                 | num  | 0         | /                     |
| :min              | 允许的最小值           | num  | -Infinity | /                     |
| :max              | 允许的最大值           | num  | Infinity  | /                     |
| step              | 计数器步长             | num  | 1         | /                     |
| step-strictly     | 强制转换输入为步长倍数 | boo  | false     | /                     |
| disabled          | 禁用计数器             | boo  | false     | /                     |
| precision         | 数值精度               | num  | /         | /                     |
| size              | 尺寸                   | str  | /         | medium / small / mini |
| :controls         | 使用控制器             | boo  | true      | /                     |
| controls-position | 控制按钮位置           | str  | /         | right                 |
| name              | 原生                   | str  | /         | /                     |

| 事件   | 说明             | 回调参数   |
| ------ | ---------------- | ---------- |
| change | 绑定值变化时触发 | 新值，旧值 |

### Select选择器

> 即供以选择的下拉菜单。

```react
<el-select v-model="value">
  <el-option v-for="item in options" :key="item.value"
    :label="item.label" :value="item.value">
  </el-option>
</el-select>

data() {
  return {
    options: [{
      value: '选项1',
      label: '黄金糕'
    }, {
      value: '选项2',
      label: '双皮奶'
    }],
    // 绑定值、初始值
    value: ''
  };
}
```

| Select属性           | 说明                                   | 类型                  | 默认值 / 回调参 | 可选值 |
| -------------------- | -------------------------------------- | --------------------- | --------------- | ------ |
| v-model              | 绑定值                                 | num / boo / str / arr | /               | /      |
| placeholder          | 占位符                                 | str                   | 请选择          | /      |
| disabled             | 完全禁用                               | boo                   | false           | /      |
| clearable            | 提供清空按钮                           | boo                   | false           | /      |
| multiple             | 启用多选                               | boo                   | false           | /      |
| collapse-tags        | 多选时将选中值按文字的形式展示         | boo                   | false           | /      |
| filterable           | 可根据输入搜索                         | boo                   | false           | /      |
| filter-method        | 自定义搜索方法                         | func                  | 输入值          | /      |
| remote               | 远程搜索                               | boo                   | false           | /      |
| remote-method        | 远程搜索方法                           | func                  | 输入值          | /      |
| allow-create         | （需 filterable 真）允许用户创建新条目 | boo                   | false           | /      |
| default-first-option | 提供回车选择                           | boo                   | false           | /      |

| Option属性 | 说明     | 类型            | 默认值 | 可选值 |
| ---------- | -------- | --------------- | ------ | ------ |
| :value     | 选项的值 | str / num / obj | /      | /      |
| :label     | 展示值   | num / str       | /      | /      |

#### 自定义模板_Select

> 直接在项标签中插入相应内容。

```react
<el-select ...>
  <el-option v-for="item in options"...>
    <span>{{item.label}}</span>anything<span>{{item.value}}</span>
  </el-option>
</el-select>
```

#### 分组_Select

> 使用 `el-option-group` 对选项进行分组。

```react
<el-select v-model="value">
  <el-option-group v-for="group in options" :key="group.label" :label="group.label">
    <el-option v-for="item in group.options" :key="item.value" 
      :label="item.label" :value="item.value">
    </el-option>
  </el-option-group>
</el-select>

data() {
  return {
    options: [{
      label: '热门城市',
      options: [{
        value: 'Shanghai',
        label: '上海'
      }, {
        value: 'Beijing',
        label: '北京'
      }]
    }, {
      label: '城市名',
      options: [{
        value: 'Chengdu',
        label: '成都'
      }, {
        value: 'Shenzhen',
        label: '深圳'
      }]
    }],
    value: ''
  };
}
```

| Option属性 | 说明       | 类型 | 默认值 | 可选值 |
| ---------- | ---------- | ---- | ------ | ------ |
| :label     | 分组名     | str  | /      | /      |
| disabled   | 禁用该分组 | boo  | false  | /      |

#### 搜索_Select

> 给选择容器添加 `filterable` 属性，即能从选项中筛选出 `label` 属性包含输入值的项。
>
> 可以通过传入 `filter-method` 来改变搜索逻辑，在输入值改变时调用。

#### 远程搜索_Select

> 需要开启 `filterable` 和 `remote`，并传入 `remote-method`。

#### 创建条目_Select

> 需开启 `allow-create` 和 `filterable`，容器绑定对象类型时，使用 `item.value` 作为 key 值。

### Cascader级联选择器

```react
<el-cascader v-model="value" :options="options" 
  :props="casProps" ></el-cascader>

data() {
  return {
    value: '',
    casProps: { expandTrigger: 'hover' },
    options: [{
      value: 'zhinan',
      label: '指南',
      children: [{
        value: 'shejiyuanze',
        label: '设计原则',
        children: [{
          value: 'yizhi',
          label: '一致'
        }, {
          value: 'fankui',
          label: '反馈'
        }]
      }, {
        value: 'daohang',
        label: '导航',
        children: [{
          value: 'cexiangdaohang',
          label: '侧向导航'
        }]
      }]
    }]
  };
}
```

| 属性             | 说明                                                         | 类型                | 默认值 / 回调参  | 可选值 |
| ---------------- | ------------------------------------------------------------ | ------------------- | ---------------- | ------ |
| v-model          | 绑定值                                                       | /                   | /                | /      |
| options          | 选项数据源                                                   | arr                 | /                | /      |
| props            | [配置选项](https://github.com/SpringLoach/Vue/blob/main/plugins/Element-UI/section1.md#Props配置选项_Cascader) | obj                 | /                | /      |
| clearable        | 提供清空按钮                                                 | boo                 | false            | /      |
| placeholder      | 占位符                                                       | str                 | 请选择           | /      |
| :show-all-levels | 显示选中值的完整路径                                         | boo                 | true             | /      |
| filterable       | 可搜索选项                                                   | boo                 | /                | /      |
| filter-method    | 自定义搜索逻辑                                               | func(node, keyword) | 节点，搜索关键词 | /      |

#### Props配置选项_Cascader

| 属性          | 说明                                 | 类型 | 默认值     | 可选值  |
| ------------- | ------------------------------------ | ---- | ---------- | ------- |
| expandTrigger | 次级菜单的展开方式                   | str  | 'click'    | 'hover' |
| value         | 以选项对象的某属性作为**选项值**     | str  | 'value'    | /       |
| label         | 以选项对象的某属性作为**选项展示值** | str  | 'label'    | /       |
| children      | 以选项对象的某属性作为**子选项**     | str  | 'children' | /       |
| disabled      | 以选项对象的某属性作为**禁用**       | str  | 'disabled' | /       |
| checkStrictly | 可选非叶子节点                       | boo  | false      | /       |
| :emitPath     | 选中项改变时，返回各级节点值的数组   | boo  | true       | /       |
| multiple      | 开启多选                             | boo  | false      | /       |

#### 可搜索_Cascader

> 将 `filterable` 设为真即可。默认匹配所有节点的 `label`。
>
> 未开启 `show-all-levels` 时，匹配父节点的 `label`。
>
> 可以传入 `filter-method` 来自定义搜索逻辑，通过返回布尔值表示是否通过筛选。

#### 自定义节点展示内容_Cascader

> 传入的两个对象分别表示当前节点对象和数据。

```react
<el-cascader :options="options">
  <template slot-scope="{ node, data }">
    <span>{{ data.label }}</span>
    <span v-if="!node.isLeaf"> ({{ data.children.length }}) </span>
  </template>
</el-cascader>
```

### Switch开关

> 模拟开关左右滑动的组件。

```react
<el-switch v-model="value"></el-switch>

data() {
  return {
    value: true
  };
}
```

| 属性           | 说明             | 类型            | 默认值  | 可选值 |
| -------------- | ---------------- | --------------- | ------- | ------ |
| v-model        | 绑定值           | boo / str / num | /       | /      |
| width          | 宽度             | num             | 40      | /      |
| active-color   | 打开时的背景色   | str             | #409EFF | /      |
| inactive-color | 关闭时的背景色   | str             | #C0CCDA | /      |
| active-text    | 打开时的文字描述 | str             | /       | /      |
| disabled       | 禁用             | boo             | false   | /      |
| active-value   | 打开时的值       | boo / str / num | true    | /      |
| inactive-value | 关闭时的值       | boo / str / num | false   | /      |

### Slider滑块

```react
<el-slider v-model="value"></el-slider>

data() {
  return {
    value: 15
  };
}
```

| 属性            | 说明                     | 类型 | 默认值/回调参 | 可选值                        |
| --------------- | ------------------------ | ---- | ------------- | ----------------------------- |
| v-model         | 绑定值                   | num  | 0             | /                             |
| min             | 最小值                   | num  | 0             | /                             |
| max             | 最大值                   | num  | 100           | /                             |
| step            | 步长                     | num  | 1             | /                             |
| :show-tooltip   | 显示提示                 | boo  | true          | /                             |
| :format-tooltip | 格式化提醒               | func | val           | /                             |
| show-input      | （非范围选择）显示输入框 | boo  | false         | /                             |
| input-size      | 输入框尺寸               | str  | small         | large / medium / small / mini |
| vertical        | 竖向模式                 | boo  | false         | /                             |
| height          | 竖向模式高度，带单位     | str  | /             | /                             |
| disabled        | 禁用                     | boo  | false         | /                             |
| range           | 范围选择                 | boo  | false         | /                             |

### TimePicker时间选择器

#### 固定或任意时间点

```react
// 固定时间点
<el-time-select v-model="value" :picker-options="pickOpt">
</el-time-select>

// 任意时间点
<el-time-picker v-model="value2" :picker-options="pickOpt2">
</el-time-picker>

data() {
  return {
    value: '',
    pickOpt: {
      start: '08:30',
      step: '00:15',
      end: '18:30'
    },
    // 任意时间点
    value2: '',
    pickOpt2: {
      selectableRange: '18:30:00 - 20:30:00'
    }
  };
}
```

| 属性              | 说明                                                         | 类型 | 默认值 | 可选值 |
| ----------------- | ------------------------------------------------------------ | ---- | ------ | ------ |
| v-model           | 绑定值                                                       | num  | 0      | /      |
| placeholder       | 占位符                                                       | str  | /      | /      |
| :picker-options   | [时间段选项](https://github.com/SpringLoach/Vue/blob/main/plugins/Element-UI/section1.md#picker-options) | obj  | {}     | /      |
| arrow-control     | （需picker标签）使用箭头进行时间选择                         | boo  | false  | /      |
| is-range          | （需picker标签）时间范围选择                                 | boo  | false  | /      |
| start-placeholder | 范围选择时开始时间占位符                                     | str  | /      | /      |
| end-placeholder   | 范围选择时结束时间占位符                                     | str  | /      | /      |

#### picker-options

| 选项            | 说明             | 类型      | 默认值                     | 可选值 |
| --------------- | ---------------- | --------- | -------------------------- | ------ |
| start           | 开始时间         | str       | 09:00                      | /      |
| end             | 结束时间         | str       | 18:00                      | /      |
| step            | 间隔时间         | str       | 00:30                      | /      |
| minTime         | 禁用的最小时间   | str       | 00:00                      | /      |
| maxTime         | 禁用的最大时间   | str       | /                          | /      |
| selectableRange | 限制可选时间范围 | str / arr | 栗 `'18:30:00 - 20:30:00'` | /      |

#### 固定时间范围

> 设置两个[固定时间](https://github.com/SpringLoach/Vue/blob/main/plugins/Element-UI/section1.md#固定或任意时间点)，将开始时间的绑定值设置为结束时间的禁用最小时间即可。

### Upload上传

> 通过点击或者拖拽上传文件。

#### 点击上传

```react
<el-upload action="https://jsonplaceholder.typicode.com/posts/"
  multiple :file-list="fileList">
  <el-button size="small" type="primary">点击上传</el-button>
  // 可选的提示语句
  <div slot="tip" class="el-upload__tip">只能上传jpg/png文件，且不超过500kb</div>
</el-upload>
  
data() {
  return {
    fileList: [
      {name: 'a.jpeg', url: '...'}, 
      {name: 'b.jpeg', url: '...'}
    ]
  };
}
```

| 属性            | 说明                                                         | 类型                  | 默认值 | 可选值                              |
| --------------- | ------------------------------------------------------------ | --------------------- | ------ | ----------------------------------- |
| :action         | **必选**，上传的地址                                         | str                   | /      | /                                   |
| :headers        | 设置上传的请求头部                                           | obj                   | /      | /                                   |
| multiple        | 支持多选文件                                                 | boo                   | /      | /                                   |
| :limit          | 最大允许上传个数                                             | num                   | /      | /                                   |
| :file-list      | 上传的文件列表                                               | arr                   | []     | 每一项都为有 `name` 和 `url` 的对象 |
| :show-file-list | 显示已上传文件列表                                           | boo                   | true   | /                                   |
| list-type       | 文件列表的[类型](https://github.com/SpringLoach/Vue/blob/main/plugins/Element-UI/section1.md#文件列表类型) | str                   | text   | picture / picture-card              |
| drag            | 支持拖拽上传                                                 | boo                   | false  | /                                   |
| :on-preview     | 预览钩子                                                     | func(file)            | /      | /                                   |
| :before-remove  | 移除前钩子，返回 `false` 则停止删除                          | func(file, fileList)  | /      | /                                   |
| :on-remove      | 移除时钩子                                                   | func(file, fileList)  | /      | /                                   |
| :on-exceed      | 文件超出个数限制时的钩子                                     | func(files, fileList) | /      | /                                   |
| :before-upload  | 上传前钩子，返回 `false` 则停止上传                          | func(file)            | /      | /                                   |

#### 文件列表类型

> 即 `list-type` 属性。

| 值             | 说明           |
| -------------- | -------------- |
| 'fileList'     | 默认           |
| 'picture-card' | 图片列表缩略图 |
| 'picture-card' | 照片墙         |

### Rate评分

```react
// 无颜色差异
<el-rate v-model="value1"></el-rate>
// 有颜色差异
<el-rate v-model="value2" :colors="colors"></el-rate>
      
data() {
  return {
    value1: null,
    value2: null,
    colors: ['#99A9BF', '#F7BA2A', '#FF9900']  // 等同于 { 2: '#99A9BF', 4: { value: '#F7BA2A', excluded: true }, 5: '#FF9900' }
  };
}
```

| 属性           | 说明                       | 类型      | 默认值                                   | 可选值 |
| -------------- | -------------------------- | --------- | ---------------------------------------- | ------ |
| v-model        | 绑定值                     | num       | 0                                        | /      |
| :colors        | 分段颜色                   | arr / obj | ['#F7BA2A', '#F7BA2A', '#F7BA2A']        | /      |
| :max           | 最大分值                   | num       | 5                                        | /      |
| low-threshold  | **低分**和中等分数的界限值 | num       | 2                                        | /      |
| high-threshold | **高分**和中等分数的界限值 | num       | 4                                        | /      |
| disabled       | 只读                       | boo       | false                                    | /      |
| show-text      | 显示辅助文字               | boo       | false                                    | /      |
| show-score     | 显示分数，与文字冲突       | boo       | false                                    | /      |
| texts          | 辅助文字数组               | arr       | ['极差', '失望', '一般', '满意', '惊喜'] | /      |
| text-color     | 辅助文字/分数颜色          | str       | #1F2D3D                                  | /      |
| score-template | 分数显示模板               | {value}   | str                                      | /      |

#### 只读评分

> 可以提供 `score-template` 作为显示模板，`{value}` 会被解析为分值。

```react
<el-rate v-model="value" disabled show-score text-color="#ff9900" score-template="{value}分"></el-rate>

data() {
  return {
    value1: 3.7
  };
}
```

### Form表单

> 表单由一到多个表单域，表单域中可以放置各种类型的表单控件。
>
> 如输入框、选择器、开关、单选框、多选框等。

```react
<el-form ref="form" :model="form" label-width="80px">
  <el-form-item label="活动名称">
    <el-input v-model="form.name"></el-input>
  </el-form-item>
</el-form>

data() {
  return {
    form: {
      name: ''
    }
  }
}
```

| 容器属性       | 说明                                                         | 类型 | 默认值 | 可选值                |
| -------------- | ------------------------------------------------------------ | ---- | ------ | --------------------- |
| :model         | 表单数据                                                     | obj  | /      | /                     |
| :rules         | 表单[验证规则](https://github.com/SpringLoach/Vue/blob/main/plugins/Element-UI/section1.md#验证规则) | obj  | /      | /                     |
| ref            | 指向该节点                                                   | str  | /      | /                     |
| inline         | 行内表单模式，使表单元素集中到一行                           | boo  | false  | /                     |
| label-position | 表单域标签的位置                                             | str  | right  | right/left/top        |
| label-width    | 表单域标签的宽度（需单位）                                   | str  | /      | /                     |
| size           | 控制该表单内组件的尺寸                                       | str  | /      | medium / small / mini |

| 容器节点方法  | 说明                                                   | 类型           | 回调参数                        |
| ------------- | ------------------------------------------------------ | -------------- | ------------------------------- |
| validate      | 对整个表单进行校验，参数为回调函数                     | F(F(boo, obj)) | 是否校验成功， 未通过校验的字段 |
| resetFields   | 对整个表单重置：将所有字段值重置为初始值并移除校验结果 | /              | /                               |
| clearValidate | 移除表单项的校验结果                                   | /              | /                               |

| 项属性      | 说明                                  | 类型 | 默认值 | 可选值                |
| ----------- | ------------------------------------- | ---- | ------ | --------------------- |
| :label      | 标签文本                              | str  | /      | /                     |
| :prop       | 校验的字段名，与 `label` 的叶属性一致 | str  | /      | /                     |
| label-width | 表单域标签的宽度（需单位）            | str  | /      | /                     |
| size        | 控制该表单域下组件的尺寸              | str  | /      | medium / small / mini |

#### 验证规则

```react
// 验证规则可以有多个。  
// require：必填  message：错误信息  trigger：验证时机  min：最小字符数  max：最大字符数

rules: {
  name: [
    { required: true, message: '请输入活动名称', trigger: 'blur' },
    { min: 3, max: 5, message: '长度在 3 到 5 个字符', trigger: 'blur' }
  ],
  region: [
    { required: true, message: '请选择活动区域', trigger: 'change' }
  ]
}
```

#### 自定义校验规则

> 通过自定义校验规则，可以完成密码的二次验证。

#### 动态增减表单项

> 通过对数据数组使用 `v-for` 进行渲染 DOM，通过操作数据数组动态改变 DOM。
>
> 可以用 `Date.now()` 来创建 `key`，防止重复。

#### 限制输入为数字类型

> 给对应的 `v-model` 加上 `.number` 修饰符即可。但无法输入小数点。



## Data

### Table表格

> 项标签的 `prop` 属性接收数据源的项属性作为列内容。

```react
<el-table :data="tableData" style="width: 100%">
  <el-table-column type="index" label="#" width="180"></el-table-column>
  <el-table-column prop="date" label="日期" width="180"></el-table-column>
  <el-table-column prop="name" label="姓名"></el-table-column>
</el-table>

data() {
  return {
    tableData: [
      {date: 233, name: 'white'},
      {date: 567, name: 'black'}
    ]
  }
}
```

| 容器属性              | 说明                         | 类型      | 默认值 | 可选值 |
| --------------------- | ---------------------------- | --------- | ------ | ------ |
| :data                 | 数据源                       | arr       | /      | /      |
| height                | 表格高度。设置后**固定表头** | num / str | /      | /      |
| max-height            | 表格最大高度                 | num / str | /      | /      |
| stripe                | 带斑马纹                     | boo       | false  | /      |
| border                | 带纵向边框                   | boo       | false  | /      |
| :fit                  | 列宽度自撑开                 | boo       | true   | /      |
| :show-header          | 显示表头                     | boo       | true   | /      |
| highlight-current-row | 高亮选中行                   | boo       | false  | /      |

| 项属性                | 说明                             | 类型           | 默认值 | 可选值                                   |
| --------------------- | -------------------------------- | -------------- | ------ | ---------------------------------------- |
| label                 | 列标题                           | str            | /      | /                                        |
| prop                  | 列内容，选取数据源项的某个属性   | str            | /      | /                                        |
| width                 | 列宽度                           | str            | /      | /                                        |
| min-width             | 最小列宽度                       | str            | /      | /                                        |
| type                  | （可选的）列类型                 | str            | /      | selection多选框/index索引/expand展开按钮 |
| :index                | （如果有）自定义索引             | num / F(index) | /      | /                                        |
| :max                  | 最大分值                         | num            | 5      | /                                        |
| fixed                 | 列固定                           | str / boo      | /      | true / left / right                      |
| show-overflow-tooltip | 内容过多时，取消折行，以提示显示 | boo            | false  | /                                        |

#### 自定义列模板

> 通过模板标签中的 `slot-scope` 可以在内部用 `row` 取到相应项，用 `store` 取到状态管理等。

```react
<el-table :data="tableData" style="width: 100%">
  <el-table-column label="日期">
    <template slot-scope="scope">
      <i class="el-icon-time"></i>
      <span style="margin-left: 10px">{{ scope.row.date }}</span>
    </template>
  </el-table-column>
  ...
</el-table>
```

#### 展开行

> 通过设置项类型为 type="expand" 可以开启展开行功能，其内部（模板）会被渲染成为展开行的内容。

#### 自定义表头

> 通过设置 `slot="header"` 的模板实现，列内容可以使用模板也可以不使用。

```react
<el-table-column>
  <template slot="header" slot-scope="scope">..</template>
  <template>.. </template>
</el-table-column>
```

### Tag标签

```react
<el-tag>标签一</el-tag>
<el-tag type="success">标签二</el-tag>
```

| 属性     | 说明   | 类型 | 默认值 | 可选值                      |
| -------- | ------ | ---- | ------ | --------------------------- |
| type     | 类型   | str  | /      | success/info/warning/danger |
| closable | 可关闭 | boo  | false  | /                           |
| size     | 尺寸   | str  | /      | medium / small / mini       |
| effect   | 主题   | str  | light  | dark / plain                |

| 事件  | 说明     |
| ----- | -------- |
| click | 点击触发 |
| close | 关闭触发 |

#### 动态编辑标签

> 通过 `v-for` 数据源生成标签，动态添加和删除数组元素。
>
> 给输入表单项和添加标签的添加 `v-if`、`v-else` 实现动态添加效果。

### Tree树形控件

```react
<el-tree :data="data" :props="defaultProps"></el-tree>  

 data() {
  return {
    data: [{
      label: '一级 1',
      children: [{
        label: '二级 1-1',
        children: [{
          label: '三级 1-1-1'
        }]
      }]
    }, {
      label: '一级 2',
      children: [{
        label: '二级 2-1',
      }]
    }],
    defaultProps: {
      children: 'children',
      label: 'label'
    }
  }
}
```

| 属性                  | 说明                                                         | 类型 | 默认值 | 可选值 |
| --------------------- | ------------------------------------------------------------ | ---- | ------ | ------ |
| :data                 | 数据源                                                       | arr  | /      | /      |
| :props                | [配置选项](https://github.com/SpringLoach/Vue/blob/main/plugins/Element-UI/section1.md#配置选项_Tree) | obj  | /      | /      |
| show-checkbox         | 复选框                                                       | boo  | false  | /      |
| default-expand-all    | 默认展开所有节点                                             | boo  | false  | /      |
| :default-checked-keys | 包含默认勾选节点的 key 的数组，需 `node-key`                 | arr  | /      | /      |
| node-key              | 树节点的唯一标识                                             | str  | /      | /      |

| 方法            | 说明                                    | 参数                                                         |
| --------------- | --------------------------------------- | ------------------------------------------------------------ |
| getCheckedNodes | 返回目前被选中的节点所组成的数组        | 是否只是叶子节点，是否包含半选节点。默认都为 false           |
| setCheckedNodes | 设置目前勾选的节点，需 `node-key`       | 勾选节点数据的数组                                           |
| getCheckedKeys  | 返回目前被选中的节点的 key 所组成的数组 | 是否仅返回被选中的叶子节点的 keys。默认为 false              |
| setCheckedKeys  | 设置目前勾选的节点，需 `node-key`       | 勾选节点的 key 的数组，是否仅设置叶子节点的选中状态。默认为 false |

#### 配置选项_Tree

| 值       | 说明                                   | 类型                   | 默认值 | 可选值 |
| -------- | -------------------------------------- | ---------------------- | ------ | ------ |
| label    | 以节点对象的某个属性值作为**节点标签** | str / func(data, node) | /      | /      |
| children | 以节点对象的某个属性值作为**子树**     | str                    | /      | /      |
| disabled | 以节点对象的某个属性值作为**禁用**     | boo / func(data, node) | /      | /      |

#### 禁用状态_Tree

> 给节点对象添加 `disabled` 属性并设置为 `true`。

### Pagination分页

```react
<el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
  :current-page="queryInfo.page" :page-sizes="[5, 8, 10]" :total="total"
  :page-size="queryInfo.size" layout="total, sizes, prev, pager, next, jumper">
</el-pagination>

data() {
  return {
    queryInfo: {
      size: 5,
      page: 1
    },
    // 将请求到的数据保存
    total: 0,
    getData: []
  }
},
methods: {
  handleSizeChange(newSize) {/* 改变条数后发送请求 */},
  handleCurrentChange(newPage) {/* 改变页码后发送请求 */},
}
```

| 属性                | 说明                                                         | 类型 | 默认值   | 可选值                                            |
| ------------------- | ------------------------------------------------------------ | ---- | -------- | ------------------------------------------------- |
| layout              | [选用组件](https://github.com/SpringLoach/Vue/blob/main/plugins/Element-UI/section1.md#选用组件)，以逗号分隔 | str  | /        | sizes, prev, pager, next, jumper, ->, total, slot |
| :total              | 总条目数                                                     | num  | /        | /                                                 |
| :page-size          | 每页显示条目个数                                             | num  | 10       | /                                                 |
| :page-sizes         | 每页显示条目个数预设                                         | arr  | [10, 20] | /                                                 |
| :current-page       | 当前页数                                                     | num  | 1        | /                                                 |
| :pager-count        | 页码按钮的最大数量，超出时折叠                               | num  | 7        | 5-21间的奇数                                      |
| background          | 为分页按钮添加背景色                                         | boo  | false    | /                                                 |
| small               | 使用小型分页                                                 | boo  | false    | /                                                 |
| hide-on-single-page | 只有一页时隐藏                                               | boo  | false    | /                                                 |

| 事件           | 说明               | 回调参数 |
| -------------- | ------------------ | -------- |
| size-change    | 页条数改变时会触发 | 每页条数 |
| current-change | 当前页改变时会触发 | 当前页   |
| prev-click     | 点击上一页按后触发 | 当前页   |
| next-click     | 点击下一页按后触发 | 当前页   |

#### 选用组件

| 组件   | 说明                   |
| ------ | ---------------------- |
| prev   | 上一页                 |
| next   | 下一页                 |
| pager  | 页码列表               |
| jumper | 跳页元素               |
| total  | 总条目数               |
| size   | 设置每页显示的页码数量 |
| ->     | 其后的元素会靠右显示   |

### Badge标记

> 出现在按钮、图标右上角的数字或状态标记

```react
<el-badge :value="3">
  <el-button size="small">回复</el-button>
</el-badge>
```

| 属性   | 说明                                          | 类型      | 默认值 | 可选值                                      |
| ------ | --------------------------------------------- | --------- | ------ | ------------------------------------------- |
| :value | 显示值                                        | str / num | /      | /                                           |
| is-dot | 显示小圆点                                    | boo       | false  | /                                           |
| type   | 类型                                          | str       | /      | primary / success / warning / danger / info |
| :max   | （显示数值的）最大值，超出该值显示 `'{max}+'` | num       | /      | /                                           |
| hidden | 隐藏标记                                      | boo       | false  | /                                           |

### Avatar头像

```react
<el-avatar size="large" :src="circleUrl"></el-avatar>

data() {
  return {
    circleUrl: "https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png"
  }
}
```

| 属性     | 说明                     | 类型      | 默认值 | 可选值                             |
| -------- | ------------------------ | --------- | ------ | ---------------------------------- |
| size     | 头像的大小               | num / str | large  | medium / small / *num*             |
| :src     | 图片类型地址             | str       | /      | /                                  |
| icon     | 图标类型                 | str       | /      | /                                  |
| 文本节点 | 文字类型                 | /         | /      | /                                  |
| shape    | 头像的形状               | str       | circle | square                             |
| fit      | 图片类型时，适应容器方式 | str       | cover  | fill / contain / none / scale-down |

| 事件  | 说明                                            | 回调参数 |
| ----- | ----------------------------------------------- | -------- |
| error | 图片类头像加载失败的回调，返回 false 会关闭组件 | /        |

### Skeleton骨架屏

> 在需要等待加载内容的位置设置一个骨架屏，某些场景下比 Loading 的视觉效果更好。

```
<el-skeleton />
```

| 属性      | 说明                      | 类型 | 默认值 | 可选值 |
| --------- | ------------------------- | ---- | ------ | ------ |
| :rows     | 骨架屏段落数量            | num  | 4      | /      |
| :src      | 图片类型地址              | str  | /      | /      |
| animated  | 使用动画                  | boo  | false  | /      |
| :loading  | 显示骨架屏                | boo  | true   | /      |
| :count    | 渲染模板的数量，尽可能小  | num  | 1      | /      |
| :throttle | 延迟占位DOM渲染时间，毫秒 | num  | 0      | /      |

| 模板项属性 | 说明           | 类型 | 默认值 | 可选值                                                       |
| ---------- | -------------- | ---- | ------ | ------------------------------------------------------------ |
| variant    | 占位元素的样式 | str  | text   | image / p /button / circle [等](https://element.eleme.cn/#/zh-CN/component/skeleton) |

#### 切换渲染状态

```react
<el-skeleton style="width: 240px" :loading="loading">
  // 占位DOM
  <template slot="template">...</template>
  // 真实DOM
  <template>...</template>
</el-skeleton>

data() {
  return {
    loading: true
  }
}
```

### Empty空状态

```
<el-empty></el-empty>
```

| 属性        | 说明           | 类型 | 默认值   | 可选值 |
| ----------- | -------------- | ---- | -------- | ------ |
| description | 替代文本描述   | str  | 暂无数据 | /      |
| image       | 替代图片地址   | str  | /        | /      |
| image-size  | 图片大小（宽） | num  | /        | /      |

#### 底部添加内容

> 使用默认插槽。

```react
<el-empty>
  <p>(●ˇ∀ˇ●)</p>
</el-empty>
```



## Notice

### Alert警告

```
<el-alert title="请求数据成功" type="success">
</el-alert>
```

| 属性        | 说明               | 类型 | 默认值 | 可选值                |
| ----------- | ------------------ | ---- | ------ | --------------------- |
| title       | 标题               | str  | /      | /                     |
| type        | 类型               | str  | info   | success/warning/error |
| effect      | 主题               | str  | light  | dark                  |
| show-icon   | 显示图标           | boo  | false  | /                     |
| :closable   | 可关闭             | boo  | true   | /                     |
| close-text  | 关闭按钮自定义文本 | str  | /      | /                     |
| center      | 文字居中           | boo  | true   | /                     |
| description | 辅助性文字         | str  | /      | /                     |

### Loading加载

> 加载数据时显示动效。

#### 区域加载

> 在表格等容器中加载数据时显示。
>
> 默认状况下，Loading 遮罩会插入到绑定元素的子节点。

```react
<p v-loading="loading">anything</p>

// 全屏，锁定屏幕，会添加到 body 上
<p v-loading.fullscreen.lock="loading">anything</p>

data() {
  return {
    loading: true
  }
}
```

#### 自定义_Loading

> 添加到存在 `v-loading` 的元素上。

```react
<p v-loading="loading"
  element-loading-text="拼命加载中"
  element-loading-spinner="el-icon-loading"
  element-loading-background="rgba(0, 0, 0, 0.8)"
>anything</p>
```

| 额外属性                   | 说明               | 类型 | 默认值 | 可选值 |
| -------------------------- | ------------------ | ---- | ------ | ------ |
| element-loading-text       | 自定义加载文案     | str  | /      | /      |
| element-loading-spinner    | 自定义加载图标类名 | str  | /      | /      |
| element-loading-background | 遮罩背景色         | str  | /      | /      |

#### 以服务调用

> [局部引入](https://element.eleme.cn/#/zh-CN/component/loading)和全局引入使用方式不同。
>
> 默认全屏。

```react
const loading = this.$loading({
  lock: true,
  text: 'Loading',
  spinner: 'el-icon-loading',
  background: 'rgba(0, 0, 0, 0.7)'
});
setTimeout(() => {
  // 关闭遮罩
  loading.close();
}, 2000);
```

| 配置属性   | 说明               | 类型 | 默认值 | 可选值 |
| ---------- | ------------------ | ---- | ------ | ------ |
| lock       | 锁定屏幕           | boo  | false  | /      |
| text       | 自定义加载文案     | str  | /      | /      |
| spinner    | 自定义加载图标类名 | str  | /      | /      |
| background | 遮罩背景色         | str  | /      | /      |

### Message消息提示

> 常用于主动操作后的反馈提示。

```react
<el-button @click="clickBtn">提交</el-button>

methods: {
  clickBtn() {
    this.$message('这是一条消息提示');
  }
}
```

使用主题

```react
this.$message.error('错了哦，这是一条错误消息');

this.$message({
  message: '警告哦，这是一条错误消息',
  type: 'error'
});
```

| 配置属性  | 说明                 | 类型 | 默认值 | 可选值                     |
| --------- | -------------------- | ---- | ------ | -------------------------- |
| message   | 消息文字             | str  | /      | /                          |
| type      | 主题                 | str  | info   | success/warning/info/error |
| showClose | 显示关闭按钮         | boo  | false  | /                          |
| center    | 文字居中             | boo  | false  | /                          |
| :duration | 显示时间, 毫秒       | num  | 3000   | /                          |
| :offset   | 距离窗口顶部的偏移量 | num  | 20     | /                          |

### MessageBox弹框

> 模拟系统的消息提示框而实现的一套模态对话框组件，用于确认消息等。

#### 确认消息

> 点击了确定后，将执行 `then` 部分的程序。

```react
<el-button @click="open">删除</el-button>

methods: {
  open() {
    this.$confirm('此操作将永久删除该文件, 是否继续?', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(() => {
      this.$message({
        type: 'success',
        message: '删除成功!'
      });
    }).catch(() => {
      this.$message({
        type: 'info',
        message: '已取消删除'
      });          
    });
  }
}
```

| 配置属性          | 说明                   | 类型 | 默认值 | 可选值                           |
| ----------------- | ---------------------- | ---- | ------ | -------------------------------- |
| type              | 消息类型，用于显示图标 | str  | /      | success / info / warning / error |
| cancelButtonText  | 取消按钮的文本内容     | str  | 取消   | /                                |
| confirmButtonText | 确定按钮的文本内容     | str  | 确定   | /                                |

### Notification通知

> 悬浮出现在页面角落的全局通知。

```react
this.$notify({
  title: '紧急通知',
  message: '番禺区大雨蓝色预警'
});
```

| 配置属性   | 说明                                | 类型 | 默认值    | 可选值                                      |
| ---------- | ----------------------------------- | ---- | --------- | ------------------------------------------- |
| title      | 标题                                | str  | /         | /                                           |
| message    | 说明文字                            | str  | /         | /                                           |
| type       | 主题                                | str  | /         | success/warning/info/error                  |
| duration   | 显示时间, 毫秒。为 0 时不会自动关闭 | num  | 4500      | /                                           |
| position   | 弹出位置                            | str  | top-right | top-right/top-left/bottom-right/bottom-left |
| :showClose | 显示关闭按钮                        | boo  | true      | /                                           |



## Navigation

### Menu导航菜单

```react
import {Menu, Submenu, MenuItem,} from 'element-ui';

Vue.use(Menu);
Vue.use(Submenu);
Vue.use(MenuItem);
```

普通垂直导航菜单栗子

```react
<el-menu :default-active="activeIndex" mode="horizontal">
  <el-menu-item index="1">导航一</el-menu-item>
  <el-menu-item index="2">导航二</el-menu-item>
  <el-menu-item index="3">导航三</el-menu-item>
</el-menu>
```

各种项演示

```react
<el-menu :default-active="activeIndex" mode="horizontal">

  <!-- 最普通的项 -->  
  <el-menu-item index="1">导航一</el-menu-item>
  
  <!-- 带链接的项 --> 
  <el-menu-item index="2"><a href="https://www.ele.me" target="_blank">导航二</a></el-menu-item>
  
  <!-- 带图标的项 -->
  <el-menu-item index="3">
    <i class="el-icon-menu"></i>
    <span slot="title">导航三</span>
  </el-menu-item>
  
  <!-- 仅图标的项 -->
  <el-menu-item index="3">
    <i class="el-icon-bell"></i>
  </el-menu-item>
  
  <!-- 图标在后的项 -->
  <el-menu-item index="3">
    <span slot="title">导航三<i class="el-icon-bell"></i></span>
  </el-menu-item>
  
  <!-- 图像在后的项 -->
  <el-menu-item index="6">
    Spring
    <img src="~@/assets/logo.png" />
  </el-menu-item>
  
  <!-- 带了双层嵌套的项 -->
  <el-submenu index="4">
    <!-- 副容器的占位标题，视觉上与项一致，但不可点击 -->  
    <template slot="title">导航四标题</template>
    <el-menu-item index="4-1">导航四内容一</el-menu-item>
    <el-submenu index="4-2">
      <template slot="title">导航四内容二</template>
      <el-menu-item index="4-2-1">子选项1</el-menu-item>
      <el-menu-item index="4-2-2">子选项2</el-menu-item>
    </el-submenu>
  </el-submenu>
  
</el-menu>

data() {
  return {
    activeIndex: '1'
  }
}
```

| 容器属性          | 说明                                                         | 类型 | 默认值   | 可选值     |
| ----------------- | ------------------------------------------------------------ | ---- | -------- | ---------- |
| mode              | 模式                                                         | str  | vertical | horizontal |
| :default-active   | 当前激活菜单的 `index`                                       | str  | /        | /          |
| background-color  | 菜单的背景色                                                 | str  | #ffffff  | 栗 #545c64 |
| text-color        | 菜单的文字颜色                                               | str  | #303133  | 栗 #fff    |
| active-text-color | 激活菜单的文字颜色                                           | str  | #409EFF  | 栗 #ffd04b |
| collapse          | （垂直模式）[折叠菜单](https://github.com/SpringLoach/Vue/blob/main/plugins/Element-UI/section1.md#菜单折叠) | boo  | false    | /          |
| unique-opened     | 仅保持一个子菜单的展开                                       | boo  | false    | /          |
| default-openeds   | 默认打开的次级菜单的索引数组                                 | arr  | /        | /          |

| 容器事件 | 说明         | 回调参数         |
| -------- | ------------ | ---------------- |
| select   | 菜单激活回调 | index, indexPath |

| 副容器属性            | 说明                                  | 类型 | 默认值 | 可选值 |
| --------------------- | ------------------------------------- | ---- | ------ | ------ |
| index                 | 唯一标志                              | str  | /      | /      |
| disabled              | 禁用                                  | boo  | false  | /      |
| popper-append-to-body | 将弹出菜单插入至 `body`，解决定位问题 | boo  | /      | /      |

| 项属性   | 说明     | 类型 | 默认值 | 可选值 |
| -------- | -------- | ---- | ------ | ------ |
| index    | 唯一标志 | str  | /      | /      |
| disabled | 禁用     | boo  | false  | /      |

#### 菜单分组

```react
<el-menu-item-group title="罗德岛">
  <el-menu-item index="1-1">迷迭香</el-menu-item>
  <el-menu-item index="1-2">温蒂</el-menu-item>
</el-menu-item-group>
<el-menu-item-group title="彩虹小队">
  <el-menu-item index="1-3">灰烬</el-menu-item>
</el-menu-item-group>
```

| 分组属性 | 说明     | 类型 | 默认值 | 可选值 |
| -------- | -------- | ---- | ------ | ------ |
| title    | 分组标题 | str  | /      | /      |

#### 菜单折叠

> 给菜单容器添加折叠属性，并使用样式控制最小宽度。
>
> 在菜单项、副容器标题模板中添加不同标签，被添加 `slot="title"` 的标签会在被折叠时隐藏。

```react
<el-menu-item index="1">
  <span slot="title">处理中心</span><i>a</i>
</el-menu-item>
```

### Tabs标签页

> 分隔内容上有关联但属于不同类别的数据集合。
>
> 每一个标签页可以有任意多的展现。

```react
<el-tabs v-model="activeName">
  <el-tab-pane label="用户管理" name="first">内容一</el-tab-pane>
  <el-tab-pane label="配置管理" name="second">内容二</el-tab-pane>
  <el-tab-pane label="角色管理" name="third">内容三</el-tab-pane>
  <el-tab-pane label="定时任务补偿" name="fourth">内容四</el-tab-pane>
</el-tabs>
      
data() {
  return {
    activeName: 'second'
  }
}
```

| 容器属性     | 说明                                  | 类型                         | 默认值            | 可选值                               |
| ------------ | ------------------------------------- | ---------------------------- | ----------------- | ------------------------------------ |
| v-model      | 绑定值，激活选项卡的 `name`           | str                          | 首个选项卡 `name` | /                                    |
| type         | 风格类型                              | str                          | /                 | card（选项卡）/border-card（卡片化） |
| tab-position | 布局方向                              | str                          | top               | right/bottom/left                    |
| before-leave | 切换标签前的钩子，返回 `false` 会阻止 | F(activeName, oldActiveName) | /                 | /                                    |

| 项属性   | 说明         | 类型 | 默认值 | 可选值 |
| -------- | ------------ | ---- | ------ | ------ |
| name     | 选项卡标识符 | str  | 1~     | /      |
| label    | 选项卡标题   | str  | /      | /      |
| disabled | 禁用         | boo  | false  | /      |

#### 自定义标签页

> 不需要 `label`，在项标签中添加额外标签并添加 `slot="label"`。

```react
<el-tab-pane name="first">
  <span slot="label"><i class="el-icon-date"></i> 用户管理</span>
  内容一
</el-tab-pane>
```

### Breadcrumb面包屑

```react
<el-breadcrumb separator="/">
  <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
  <el-breadcrumb-item>活动管理</el-breadcrumb-item>
  <el-breadcrumb-item>活动列表</el-breadcrumb-item>
</el-breadcrumb>
```

| 容器属性        | 说明                 | 类型 | 默认值 | 可选值 |
| --------------- | -------------------- | ---- | ------ | ------ |
| separator       | 分隔符               | str  | '/'    | /      |
| separator-class | 图标分隔符，使用Icon | str  | /      | /      |

| 项属性  | 说明                                      | 类型    | 默认值 | 可选值 |
| ------- | ----------------------------------------- | ------- | ------ | ------ |
| to      | 路由跳转对象，同 `vue-router` 的 `to`     | str/obj | /      | /      |
| replace | 进行路由跳转时，不会向 history 添加新记录 | boo     | false  | /      |

### Dropdown下拉菜单

> 将菜单折叠到下拉菜单中。
>
> 大容器内的首个标签为占位符，小容器需要使用 `slot="dropdown"` 来设置下拉菜单。

```react
<el-dropdown>
  <span class="el-dropdown-link"> 
    下拉菜单<i class="el-icon-arrow-down el-icon--right"></i>
  </span>
  <el-dropdown-menu slot="dropdown">
    <el-dropdown-item>黄金糕</el-dropdown-item>
    <el-dropdown-item>狮子头</el-dropdown-item>
  </el-dropdown-menu>
</el-dropdown>
      
.el-dropdown-link {
  cursor: pointer;
  color: #409EFF;
}
.el-icon-arrow-down {
  font-size: 12px;
}      
```

| 大容器属性     | 说明                                                         | 类型 | 默认值/回调参 | 可选值                |
| -------------- | ------------------------------------------------------------ | ---- | ------------- | --------------------- |
| @command       | 点击菜单项的回调                                             | /    | 项指令        | /                     |
| size           | 菜单尺寸                                                     | str  | /             | medium / small / mini |
| split-button   | 呈现为按钮组                                                 | boo  | false         | /                     |
| type           | （需按钮组）菜单按钮类型，同[按钮](https://github.com/SpringLoach/Vue/blob/main/plugins/Element-UI/section1.md#Button按钮)组件 | str  | /             | /                     |
| :hide-on-click | 点击菜单项后隐藏菜单                                         | boo  | true          | /                     |

| 项属性   | 说明     | 类型        | 默认值 | 可选值 |
| -------- | -------- | ----------- | ------ | ------ |
| command  | 指令     | str/num/obj | /      | /      |
| disabled | 禁用     | boo         | false  | /      |
| divided  | 分割线   | boo         | false  | /      |
| icon     | 图标类名 | str         | /      | /      |

### Steps步骤条

```react
<el-steps :active="active" finish-status="success">
  <el-step title="步骤 1"></el-step>
  <el-step title="步骤 2"></el-step>
  <el-step title="步骤 3"></el-step>
</el-steps>
      
data() {
  return {
    active: 0
  }
}
```

| 容器属性      | 说明                 | 类型    | 默认值     | 可选值                           |
| ------------- | -------------------- | ------- | ---------- | -------------------------------- |
| :active       | 设置当前激活步骤     | num     | 0          | /                                |
| finish-status | 结束步骤的状态       | str     | finish     | wait / process / error / success |
| align-center  | 居中对齐             | boo     | false      | /                                |
| direction     | 显示方向             | str     | horizontal | vertical                         |
| space         | 步骤项间距           | num/str | 自适应     | /                                |
| simple        | （条件苛刻）简洁风格 | boo     | false      | /                                |

| 项属性      | 说明       | 类型 | 默认值 | 可选值 |
| ----------- | ---------- | ---- | ------ | ------ |
| title       | 标题       | str  | /      | /      |
| description | 描述性文字 | str  | /      | /      |
| icon        | 图标       | str  | /      | /      |

| 项插槽      | 说明       |
| ----------- | ---------- |
| icon        | 图标       |
| title       | 标题       |
| description | 描述性文字 |



## Other

### Dialog对话框

> 适用于表单、拟态图片等等。

#### 基本用法_Dialog

> `title` 属性用于定义标题。
>
> 向标签添加 `slot="footer"` 表示用于底部区域。

```react
<el-button @click="dialogVisible = true">点击</el-button>

<el-dialog title="标题" :visible.sync="dialogVisible" width="50%"
  :before-close="handleClose">
  <span>正文内容</span>
  <span slot="footer" class="dialog-footer">
    <el-button @click="dialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="dialogVisible = false">确 定</el-button>
  </span>
</el-dialog>
      
data() {
  return {
    dialogVisible: false
  }
},
methods: {
  handleClose() {
    this.dialogVisible = false;
  }
}
```

| 属性           | 说明                       | 类型 | 默认值 | 可选值 |
| -------------- | -------------------------- | ---- | ------ | ------ |
| title          | 对话框标题                 | str  | /      | /      |
| :visible       | 绑定是否可见               | boo  | false  | /      |
| width          | 对话框宽度                 | str  | 50%    | /      |
| :before-close  | 关闭前的回调               | /    | /      | /      |
| fullscreen     | 全屏                       | boo  | false  | /      |
| append-to-body | 插入body，嵌套的对话框必用 | boo  | false  | /      |
| center         | 标题和底部居中             | boo  | false  | /      |
| top            | 对话框到顶部距离           | str  | 15vh   | /      |
| :modal         | 添加遮罩层                 | boo  | true   | /      |
| :show-close    | 显示关闭按钮               | boo  | true   | /      |

| 插槽   | 说明       |
| ------ | ---------- |
| title  | 标题区     |
| footer | 按钮操作区 |

### Tooltip文字提示

> 鼠标悬浮时的提示信息。

```react
<el-tooltip content="提示文本" placement="top">
  <el-button>正上</el-button>
</el-tooltip>

<el-tooltip content="提示文本" placement="top-start">
  <el-button>上左</el-button>
</el-tooltip>
```

| 属性           | 说明         | 类型 | 默认值 | 可选值                                      |
| -------------- | ------------ | ---- | ------ | ------------------------------------------- |
| content        | 显示的内容   | str  | /      | /                                           |
| placement      | 布局方向     | str  | bottom | [top、left、right、bottom] - [start、、end] |
| effect         | 主题         | str  | dark   | light                                       |
| :visible       | 绑定是否可见 | boo  | false  | /                                           |
| disabled       | 禁用         | boo  | false  | /                                           |
| offset         | 偏移量       | num  | 0      | /                                           |
| :visible-arrow | 显示箭头     | boo  | true   | /                                           |
| enterable      | 鼠标可进入   | boo  | true   | /                                           |

### Popover弹出框

> 与 Tooltip 很类似。但可以有多种触发方式，像一个迷你的对话框。

```react
<el-popover placement="top-start" title="标题" width="200"
  trigger="hover" content="内容">
  <el-button slot="reference">hover 激活</el-button>
</el-popover>
```

| 属性           | 说明               | 类型    | 默认值         | 可选值                                      |
| -------------- | ------------------ | ------- | -------------- | ------------------------------------------- |
| title          | 显示的标题         | str     | /              | /                                           |
| content        | 显示的内容         | str     | /              | /                                           |
| placement      | 布局方向           | str     | bottom         | [top、left、right、bottom] - [start、、end] |
| width          | 宽度               | str/num | 最小宽度 150px | /                                           |
| trigger        | 触发方式           | str     | click          | focus/hover/manual                          |
| v-model        | 可见（配合manual） | boo     | false          | /                                           |
| disabled       | 禁用               | boo     | false          | /                                           |
| offset         | 偏移量             | num     | 0              | /                                           |
| :visible-arrow | 显示箭头           | boo     | true           | /                                           |

| 插槽      | 说明                  |
| --------- | --------------------- |
| /         | 代替 `content` 的元素 |
| reference | 占位元素              |

### Popconfirm气泡确认框

> 点击元素时弹出的气泡确认框。

```react
<el-popconfirm title="这是一段内容确定删除吗？">
  <el-button slot="reference">删除</el-button>
</el-popconfirm>
```

| 属性                | 说明         | 类型 | 默认值           | 可选值 |
| ------------------- | ------------ | ---- | ---------------- | ------ |
| title               | 显示的标题   | str  | /                | /      |
| confirm-button-text | 确认按钮文字 | str  | /                | /      |
| cancel-button-text  | 取消按钮文字 | str  | /                | /      |
| confirm-button-type | 确认按钮类型 | str  | Primary          | /      |
| cancel-button-type  | 取消按钮类型 | str  | Text             | /      |
| hide-icon           | 隐藏图标     | boo  | false            | /      |
| icon                | 图标         | str  | el-icon-question | /      |
| icon-color          | 图标颜色     | str  | #f90             | /      |

| 插槽      | 说明     |
| --------- | -------- |
| reference | 占位元素 |

| 事件    | 说明         |
| ------- | ------------ |
| confirm | 点击确认触发 |
| cancel  | 点击取消触发 |

### Card卡片

> 将信息聚合在卡片容器中展示。

```react
<el-card>
</el-card>
```

| 属性       | 说明         | 类型 | 默认值              | 可选值        |
| ---------- | ------------ | ---- | ------------------- | ------------- |
| shadow     | 阴影显示时机 | str  | always              | hover / never |
| body-style | 设置样式     | obj  | { padding: '20px' } | /             |
| header     | 头部文本     | str  | /                   | /             |

| 插槽   | 说明     |
| ------ | -------- |
| header | 头部元素 |

### Carousel走马灯

> 可以当作轮播图。

```react
<el-carousel height="150px">
  <el-carousel-item v-for="item in 4" :key="item">
    <h3>{{ item }}</h3>
  </el-carousel-item>
</el-carousel>
```

| 容器属性           | 说明               | 类型 | 默认值     | 可选值       |
| ------------------ | ------------------ | ---- | ---------- | ------------ |
| height             | 容器高度           | str  | /          | /            |
| trigger            | 自动切换间隔，毫秒 | num  | 300        | /            |
| interval           | 指示器的触发方式   | str  | hover      | click        |
| indicator-position | 指示器的位置       | str  | /          | outside/none |
| arrow              | 切换箭头的显示     | str  | hover      | always/never |
| type               | 走马灯的类型       | str  | /          | card         |
| direction          | 走马灯展示的方向   | str  | horizontal | vertical     |

| 项属性 | 说明     | 类型 | 默认值 | 可选值 |
| ------ | -------- | ---- | ------ | ------ |
| height | 容器高度 | str  | /      | /      |

### Collapse折叠面板

```
<el-collapse v-model="activeNames">
  <el-collapse-item title="某段标题" name="1">
    <div>Hello element</div>
  </el-collapse-item>
</el-collapse>
```

| 容器属性 | 说明             | 类型 | 默认值 | 可选值 |
| -------- | ---------------- | ---- | ------ | ------ |
| v-model  | 设置当前激活面板 | arr  | /      | /      |

| 项属性   | 说明       | 类型    | 默认值 | 可选值 |
| -------- | ---------- | ------- | ------ | ------ |
| name     | 唯一标志符 | str/num | /      | /      |
| title    | 面板标题   | str     | /      | /      |
| disabled | 禁用       | boo     | false  | /      |

| 项插槽 | 说明     |
| ------ | -------- |
| title  | 面板标题 |

### Timeline时间线

> 可视化地呈现**时间流**信息。

#### 基础用法

> 每一项用 `timestamp` 属性接收时间，用插槽接收内容。

```
<el-timeline-item
    v-for="(activity, index) in activities"
    :key="index"
    :timestamp="activity.timestamp">
    {{activity.content}}
  </el-timeline-item>
</el-timeline>

data() {
  return {
    activities: [{
      content: '活动按期开始',
      timestamp: '2018-04-15'
    }, {
      content: '通过审核',
      timestamp: '2018-04-13'
    }, {
      content: '创建成功',
      timestamp: '2018-04-11'
    }]
  }
}
```

| 容器属性 | 说明         | 类型  | 默认值 | 可选值 |
| -------- | ------------ | ----- | ------ | ------ |
| reverse  | 节点排序方向 | false | 正向   | /      |

| 项属性         | 说明       | 类型 | 默认值 | 可选值                                      |
| -------------- | ---------- | ---- | ------ | ------------------------------------------- |
| :timestamp     | 时间戳     | str  | /      | /                                           |
| hide-timestamp | 隐藏时间戳 | boo  | false  | /                                           |
| placement      | 时间戳位置 | str  | bottom | top                                         |
| type           | 节点类型   | str  | /      | primary / success / warning / danger / info |
| color          | 节点颜色   | str  | /      | /                                           |
| size           | 节点尺寸   | str  | normal | large                                       |
| icon           | 节点图标   | str  | /      | /                                           |

### Divider分割线

```
<el-divider></el-divider>

<el-divider>分割线</el-divider>
```

| 项属性           | 说明             | 类型 | 默认值     | 可选值       |
| ---------------- | ---------------- | ---- | ---------- | ------------ |
| content-position | 分割线文案的位置 | str  | center     | left / right |
| direction        | 分割线方向       | str  | horizontal | vertical     |

### Calendar日历

```
<el-calendar v-model="value">
</el-calendar>

data() {
  return {
    value: new Date()
  }
}
```

| 属性    | 说明                                             | 类型         | 默认值 | 可选值                            |
| ------- | ------------------------------------------------ | ------------ | ------ | --------------------------------- |
| v-model | 绑定值                                           | Date/str/num | /      | /                                 |
| :range  | 时间范围，开始必须周一，结束周日，跨度小于两个月 | arr          | /      | 栗 `['2019-03-04', '2019-03-24']` |

### Image图片

> 支持懒加载，自定义占位、加载失败等。

```react
<el-image
  style="width: 100px; height: 100px"
  src="https://fuss10.elemecdn.com/e/5d/4a731a90594a4af544c0c25941171jpeg.jpeg"
></el-image>
```

| 属性              | 说明                                | 类型 | 默认值 | 可选值                                     |
| ----------------- | ----------------------------------- | ---- | ------ | ------------------------------------------ |
| src               | 原生-图片源                         | str  | /      | /                                          |
| fit               | 图片如何适应容器框                  | str  | /      | fill / contain / cover / none / scale-down |
| alt               | 原生                                | str  | /      | /                                          |
| :preview-src-list | 开启图片预览功能，需预览图片URL列表 | arr  | /      | /                                          |
| z-index           | 图片预览的层级                      | num  | 2000   | /                                          |

| 插槽        | 说明                 |
| ----------- | -------------------- |
| placeholder | 图片未加载的占位内容 |
| error       | 加载失败的内容       |

### Backtop回到顶部

```
<el-backtop></el-backtop>
```

| 属性               | 说明             | 类型 | 默认值 | 可选值 |
| ------------------ | ---------------- | ---- | ------ | ------ |
| :visibility-height | 展现所需滚动高度 | num  | 200    | /      |
| :right             | 距离页面右边距   | num  | 40     | /      |
| :bottom            | 距离页面底部距离 | num  | 40     | /      |

### InfiniteScroll无限滚动

> 给任意元素添加 `v-infinite-scroll="load"` 以实现无限滚动。
>
> 容器元素需要有固定高度并设置 `overflow:auto`。

```react
<div style="height:100px; overflow:auto">
  <ul class="infinite-list" v-infinite-scroll="load" :infinite-scroll-immediate="false">
    <li v-for="i in count" class="infinite-list-item">{{ i }}</li>
  </ul>
</div>
      
data() {
  return {
    count: 12
  }
},
methods: {
  load () {
    this.count += 2;
  }
}
```

| 属性                       | 说明                   | 类型 | 默认值 | 可选值 |
| -------------------------- | ---------------------- | ---- | ------ | ------ |
| v-infinite-scroll          | 启用无限滚动           | func | func   | /      |
| :infinite-scroll-immediate | 立即执行加载方法       | boo  | true   | /      |
| :infinite-scroll-distance  | 触发加载的距离阈值(px) | num  | 0      | /      |
| :infinite-scroll-delay     | 节流时延(ms)           | num  | 200    | /      |
| :infinite-scroll-disabled  | 禁用                   | boo  | false  | /      |

#### 禁用加载

> 利用的技术主要有定时决定末元素是否显示，条件渲染末元素。

### Drawer抽屉

> 可以在两侧或底部展现临时文档。

```
// 需要其它元素控制开关  
<el-drawer
  title="标题"
  :visible.sync="drawer"
  direction="rtl">
  <span>内容</span>
</el-drawer>
      
data() {
  return {
    drawer: true
  }
}
```

| 属性          | 说明                     | 类型      | 默认值 | 可选值          |
| ------------- | ------------------------ | --------- | ------ | --------------- |
| visible       | 是否显示                 | boo       | false  | /               |
| direction     | 打开的方向               | str       | rtl    | ltr / ttb / btt |
| :before-close | 关闭前的回调             | func      | /      | /               |
| size          | 窗体的大小               | str / num | '30%'  | /               |
| :withHeader   | 显示头部区域（包括标题） | boo       | true   | /               |
| title         | 标题                     | str       | /      | /               |
