## 示例

```elm
npm install echarts
```

<span style="backGround: #efe0b9">views/main/analysis/dashboard/dashboard.vue</span>

```react
<template>
  <div class="dashboard">
    <div ref="divRef" :style="{ width: '600px', height: '500px' }"></div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue'

import * as echarts from 'echarts'

export default defineComponent({
  name: 'dashboard',
  setup() {
    const divRef = ref<HTMLElement>()
    onMounted(() => {
      // 1.初始化echarts的实例(DOM, 主题， 某些配置)
      const echartInstance = echarts.init(divRef.value!, 'light', {
        renderer: 'svg'
      })
      // 2.编写配置文件
      const option = {
        title: {
          text: 'ECharts 入门示例'
        },
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'cross'
          }
        },
        legend: {
          data: ['销量']
        },
        xAxis: {
          data: ['衬衫', '羊毛衫', '雪纺衫', '裤子', '高跟鞋', '袜子']
        },
        yAxis: {},
        series: [
          {
            name: '销量',
            type: 'bar',
            data: [18, 20, 36, 10, 10, 20]
          }
        ]
      }
      // 3.设置配置,并且开始绘制
      echartInstance.setOption(option)
    })

    return {
      divRef
    }
  }
})
</script>
```

:ghost: 为了保证 <span style="color: #a50">ref</span> 能够引用到元素，在 <span style="color: #a50">onMounted</span> 勾子中进行相关操作。

:european_castle: 非空断言使用 `!` ，表示确定某个标识符是有值的，<span style="color: #ff0000">跳过</span>ts在编译阶段对它的<span style="color: #ff0000">检测</span>。

:turtle: 如果去除引用元素的默认类型，可以不使用非空断言，此时为 any 类型。

:whale: 创建 echart 需要依赖一个元素，且要给它设置宽高才能展示绘制出来的图片。



### canvas vs svg

一般来说，Canvas 更适合绘制图形元素数量非常大（这一般是由数据量大导致）的图表（如热力图、地理坐标 系或平行坐标系上的大规模线图或散点图等），也利于实现某些视觉特效； 

但是，在不少场景中，SVG 具有重要的优势：它的内存占用更低（这对移动端尤其重要）、渲染性能略高、并 且用户使用浏览器内置的缩放功能时不会模糊



### 性能测试

ECharts在不同的设备上，进行了性能的测试： 

从图片来看，在这些场景中，SVG 渲染器相比 Canvas 渲染器在移动端的总体表现更好； 

当然，这个实验并非是全面的评测，在另一些数据量较大或者有图表交互动画的场景中，目前的 SVG 渲染器的 性能还比不过 Canvas 渲染器

![image-20220405205206794](D:\笔记\技术沉淀（前端）\vue技术栈\vue3\后台项目\img\canvasVSsvg)





## 示例2

### 数据保存

**新建模块存储图像相关数据**

<span style="backGround: #efe0b9">store/main/analysis/dashboard.ts</span>

```react
import { Module } from 'vuex'

import { IDashboardState } from './types'
import { IRootState } from '../../types'

const dashboardModule: Module<IDashboardState, IRootState> = {
  namespaced: true,
  state() {
    return {
      categoryGoodsCount: [],
      categoryGoodsSale: [],
      categoryGoodsFavor: [],
      addressGoodsSale: []
    }
  },
  mutations: {},
  actions: {}
}

export default dashboardModule
```

<span style="backGround: #efe0b9">store/main/analysis/types.ts</span>

```javascript
export interface IDashboardState {
  categoryGoodsCount: any[]
  categoryGoodsSale: any[]
  categoryGoodsFavor: any[]
  addressGoodsSale: any[]
}
```

**根状态中注册模块**

<span style="backGround: #efe0b9">store/index.ts</span>

```react
import dashboard from './main/analysis/dashboard'

const store = createStore<IRootState>({
  ...,
  modules: {
    ...,
    dashboard
  }
})
```

<span style="backGround: #efe0b9">store/types.ts</span>

```javascript
import { IDashboardState } from './main/analysis/types'

export interface IRootWithModule {
  login: ILoginState
  system: ISystemState
  dashboard: IDashboardState
}
```



### 数据请求

<span style="backGround: #efe0b9">service/main/analysis/dashboard.ts</span>

```react
import baseRequest from '@/service'

enum DashboardAPI {
  categoryGoodsCount = '/goods/category/count',
  categoryGoodsSale = '/goods/category/sale',
  categoryGoodsFavor = '/goods/category/favor',
  addressGoodsSale = '/goods/address/sale'
}

export function getCategoryGoodsCount() {
  return baseRequest.request({
    method: 'get',
    url: DashboardAPI.categoryGoodsCount
  })
}

export function getCategoryGoodsSale() {
  return baseRequest.request({
    method: 'get',
    url: DashboardAPI.categoryGoodsSale
  })
}

export function getCategoryGoodsFavor() {
  return baseRequest.request({
    method: 'get',
    url: DashboardAPI.categoryGoodsFavor
  })
}

export function getAddressGoodsSale() {
  return baseRequest.request({
    method: 'get',
    url: DashboardAPI.addressGoodsSale
  })
}
```

<span style="backGround: #efe0b9">store/main/analysis/dashboard.ts</span>

```react
import {
  getCategoryGoodsCount,
  getCategoryGoodsSale,
  getCategoryGoodsFavor,
  getAddressGoodsSale
} from '@/service/main/analysis/dashboard'

const dashboardModule: Module<IDashboardState, IRootState> = {
  namespaced: true,
  state() {
    return { ... }
  },
  mutations: {
    changeCategoryGoodsCount(state, list) {
      state.categoryGoodsCount = list
    },
    changeCategoryGoodsSale(state, list) {
      state.categoryGoodsSale = list
    },
    changeCategoryGoodsFavor(state, list) {
      state.categoryGoodsFavor = list
    },
    changeAddressGoodsSale(state, list) {
      state.addressGoodsSale = list
    }
  },
  actions: {
    async getDashboardDataAction({ commit }) {
      const categoryCountResult = await getCategoryGoodsCount()
      commit('changeCategoryGoodsCount', categoryCountResult.data)
      const categorySaleResult = await getCategoryGoodsSale()
      commit('changeCategoryGoodsSale', categorySaleResult.data)
      const categoryFavorResult = await getCategoryGoodsFavor()
      commit('changeCategoryGoodsFavor', categoryFavorResult.data)
      const addressGoodsResult = await getAddressGoodsSale()
      commit('changeAddressGoodsSale', addressGoodsResult.data)
    }
  }
}

export default dashboardModule
```

<span style="backGround: #efe0b9">views/main/analysis/dashboard/dashboard.vue</span>

```react
import { useStore } from '@/store'

setup() {
  const store = useStore()
  // 请求数据
  store.dispatch('dashboard/getDashboardDataAction')

  return {}
}
```



## 卡片及布局

```elm
- commom
  + card
    - src
      + card.vue
    - index.ts
```

<span style="backGround: #efe0b9">commom/card/src/card.vue</span>

```react
<el-card class="box-card">
  <template #header>
    <div class="card-header">
      <span>{{ title }}</span>
    </div>
  </template>
  <div class="item">
    <slot></slot>
  </div>
</el-card>
```

<span style="backGround: #efe0b9">views/main/analysis/dashboard/dashboard.vue</span>

```react
<div class="dashboard">
  <el-row :gutter="10">
    <el-col :span="7">
      <hd-card title="分类商品数量(饼图)"> </hd-card>
    </el-col>
    <el-col :span="10">
      <hd-card title="不同城市商品销量"> </hd-card>
    </el-col>
    <el-col :span="7">
      <hd-card title="分类商品数量(玫瑰图)"> </hd-card>
    </el-col>
  </el-row>

  <el-row :gutter="10" class="content-row">
    <el-col :span="12">
      <hd-card title="分类商品的销量"> </hd-card>
    </el-col>
    <el-col :span="12">
      <hd-card title="分类商品的收藏"> </hd-card>
    </el-col>
  </el-row>
</div>
```

:ghost: 通过 gutter 属性，可以在行的每列之间，产生均等间距。



## 基础图像

### setup特性的版本更新

由于当初特性刚出，需要较新的 vue 版本上才能使用。

```elm
npm install vue@next
```

同时更新相关的配置

```elm
npm install @vue/compiler-sfc
```



### 示例

```css
- commom
  + echart
    - src
      + base-echart.vue
    - index.ts
```



<span style="backGround: #efe0b9">commom/echart/src/base-echart.vue</span>

```html
<template>
  <div class="base-echart">
    <div ref="echartDivRef" :style="{ width: width, height: height }"></div>
  </div>
</template>

<script lang="ts" setup>
import { ref, onMounted, defineProps, withDefaults, watchEffect } from 'vue'
import { EChartsOption } from 'echarts'
import useEchart from '../hooks/useEchart'

// 定义props及默认值
const props = withDefaults(
  defineProps<{
    options: EChartsOption
    width?: string
    height?: string
  }>(),
  {
    width: '100%',
    height: '360px'
  }
)

const echartDivRef = ref<HTMLElement>()

onMounted(() => {
  const { setOptions } = useEchart(echartDivRef.value!)

  watchEffect(() => {
    setOptions(props.options)
  })
})
</script>
```

:european_castle: 在 <span style="color: #a50">onMounted</span> 中才能确保获取到 DOM。

<span style="backGround: #efe0b9">commom/echart/hooks/useEchart.ts</span>

```react
import * as echarts from 'echarts'

import chinaMapData from '../data/china.json'

// 使用特殊的图像时，需要仅一次的注册
echarts.registerMap('china', chinaMapData)

export default function (el: HTMLElement) {
  // 暴露出初始化的方法
  const echartInstance = echarts.init(el)

  // 暴露出更改配置的方法
  const setOptions = (options: echarts.EChartsOption) => {
    echartInstance.setOption(options)
  }
  
  // 暴露出调整图像大小的方法
  const updateSize = () => {
    echartInstance.resize()
  }

  window.addEventListener('resize', () => {
    echartInstance.resize()
  })

  return {
    echartInstance,
    setOptions,
    updateSize
  }
}
```



### 定义props

**普通定义，能定义js类型**

```html
<script lang="ts" setup>
import { defineProps } from 'vue'
    
defineProps({
  width: '100%',
  height: '360px'
}),
</script>
```

**允许定义ts类型**

```html
<script lang="ts" setup>
import { defineProps } from 'vue'
    
defineProps<{
  width?: string
  height: string
}>,
</script>
```

**添加默认值**

```html
<script lang="ts" setup>
import { defineProps, withDefaults } from 'vue'
import { EChartsOption } from 'echarts'

withDefaults(
  defineProps<{
    options: EChartsOption
    width?: string
    height?: string
  }>(),
  {
    width: '100%',
    height: '360px'
  }
)
</script>
```



## 封装

### 封装中间层

> 配置基本一致，用于复用；通过自定义属性，动态决定部分配置。

```css
- components
  + page-echarts
    - src                    # 不同的图像类型
      + pie-echart.vue
      + bar-echart.vue
    - types
      + index.ts
    - index.ts               # 统一导出
```

<span style="backGround: #efe0b9">components/page-echarts/src/pie-echart.vue</span>

```html
<template>
  <div class="pie-echart">
    <base-echart :options="options"></base-echart>
  </div>
</template>

<script setup lang="ts">
import { defineProps, computed } from 'vue'
import BaseEchart from '@/commom/echart'
import { IDataType } from '../types'

const props = defineProps<{
  pieData: IDataType[]
}>()

const options = computed(() => {
  return {
    tooltip: {
      trigger: 'item'
    },
    legend: {
      orient: 'horizontal',
      left: 'left'
    },
    series: [
      {
        name: '分类数据',
        type: 'pie',
        radius: '50%',
        data: props.pieData,
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.5)'
          }
        }
      }
    ]
  }
})
</script>
```

<span style="backGround: #efe0b9">components/page-echarts/types/index.ts</span>

```javascript
export interface IDataType {
  name: string
  value: any
}
```

<span style="backGround: #efe0b9">components/page-echarts/index.ts</span>

```javascript
import PieEchart from './src/pie-echart.vue'
import RoseEchart from './src/rose-echart.vue'

export { PieEchart, RoseEchart }
```

### 使用

<span style="backGround: #efe0b9">views/main/analysis/dashboard/dashboard.vue</span>

```react
<template>
  <div class="dashboard">
    <el-row :gutter="10">
      <el-col :span="7">
        <hd-card title="分类商品数量(饼图)">
          <pie-echart :pieData="categoryGoodsCount"></pie-echart>
        </hd-card>
      </el-col>
      ...
    </el-row>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from '@/store'

import HdCard from '@/commom/card'
import {
  PieEchart
} from '@/components/page-echarts'

export default defineComponent({
  name: 'dashboard',
  components: {
    HdCard,
    PieEchart,
  },
  setup() {
    const store = useStore()
    // 请求数据
    store.dispatch('dashboard/getDashboardDataAction')

    // 获取数据
    const categoryGoodsCount = computed(() => {
      return store.state.dashboard.categoryGoodsCount.map((item: any) => {
        return { name: item.name, value: item.goodsCount }
      })
    })

    return { categoryGoodsCount }
  }
})
</script>
```

:european_castle: 需要将请求到的配置数据，传递给子组件；由于数据在 vuex 中，可以使用 computed 处理，将最新数据传递给子组件。







