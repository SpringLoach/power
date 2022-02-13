## 假数据

### 区级地区

```javascript
let arr = [
  {name: '天河区', value: '天河区'}, 
  {name: '番禺区', value: '番禺区'}, 
  {name: '南沙区', value: '南沙区'},
  {name: '荔湾区', value: '荔湾区'}, 
  {name: '白云区', value: '白云区'}, 
  {name: '海珠区', value: '海珠区'}, 
  {name: '雨花区', value: '雨花区'}, 
  {name: '平江县', value: '平江县'}, 
  {name: '南山区', value: '南山区'}, 
  {name: '龙岗区', value: '龙岗区'}];
this.areaList = [...arr, ...arr, ...arr, ...arr, ...arr, ...arr];
```



## 阿里巴巴字体下载

> https://www.iconfont.cn/webfont?spm=a313x.7781069.1998910419.d81ec59f2#!/webfont/index



## 公共搜索组件

> 使用平台为 `uni-app` 

```react
<searchStore class="search-bar" placeholder="输入门店名称或门店地址搜索" :disabled="true" @onClick="jumpToSearch" />

import searchStore from '@/components/bus/searchStore'
```



## 距离处理&防抖

```js
// 格式化距离
// 入参的单位为km，当小于0.5km时，以m作为单位进行展示，并保留0位小数
export function formatDistanceStr(distance) {
  distance = distance || 0
  if (distance < 0.1) {  // 这里感觉没有意义
    distance = `${Number(distance * 1000).toFixed(0)}m`
  } else if (distance < 0.5) {
    distance = `${Number(distance * 1000).toFixed(0)}m`
  } else {
    distance = `${Number(distance).toFixed(1)}km`
  }
  return distance
}
// 防抖动
export function throttle(func, wait = 1000) {
  let ctx, args, rtn, timeoutID // caching
  let last = 0

  return function throttled() {
    ctx = this
    args = arguments
    var delta = new Date() - last
    if (!timeoutID)
      if (delta >= wait) call()
      else timeoutID = setTimeout(call, wait - delta)
    return rtn
  }

  function call() {
    timeoutID = 0
    last = +new Date()
    rtn = func.apply(ctx, args)
    ctx = null
    args = null
  }
}

// 方便使用第一种导出方式
export default {
  throttle: throttle,
  formatDistanceStr: formatDistanceStr,
}
```



```react
// 导出使用的两种方式
import { throttle } from '@/lib/util'
const util = require('@/lib/util')

methods: {
  innerScrolltolower() {
    this.getStoreList(this.pageNo + 1)
  },
  treatDistance(item) {
    item.distance = util.formatDistanceStr(item.distance)
  },
},
onLoad(option) {
  this.innerScrolltolower = throttle(this.innerScrolltolower, 1000)
},
```



