## 初步使用

网上有很多的封装[介绍](https://www.freesion.com/article/4357511864/)，大同小异。



### 基本使用

```vue
<template>
  <h1 @click="handleAxios">发起请求</h1>
</template>

<script setup>
import axios from 'axios'
import Mock from 'mockjs'

let mockData
function handleAxios() {
  // 生成随机数据
  mockData = Mock.mock(123)
  // 拦截请求
  Mock.mock(/\/home/, 'get', mockData)
  // 发起请求
  axios.get('http://127.0.0.1:3000/home').then(r => {
    console.log(r.data)
  })
}
</script>
```

<span style="color: #ff0000">Mock.mock</span> 接收的参数不一样，作用也不一样：

:turtle: 一个参数时生成模拟数据，一个以上参数时能够拦截请求并传递模拟数据。



### 稍微封装

```vue
<template>
  <h1 @click="handleAxios">发起请求</h1>
</template>

<script setup>
import axios from 'axios'
import { getMockData } from './mockData'

function handleAxios() {
  // 生成mock数据并拦截请求
  getMockData()
  // 发起请求
  axios.get('http://127.0.0.1:3000/home').then(r => {
    console.log(r.data)
  })
}
</script>
```

<span style="backGround: #efe0b9">mockData.js</span>

```javascript
import Mock from 'mockjs'

function _getMockData() {
  // 生成随机数据
  return Mock.mock({
    // 属性 list 的值是一个数组，其中含有 1 到 10 个元素
    'list|1-10': [{
      // 属性 id 是一个自增数，起始值为 1，每次增 1
      'id|+1': 1
    }]
  })
}

function getMockData() {
  let mockData = _getMockData()
  // 拦截请求
  Mock.mock(/\/home/, 'get', mockData)
}

export {
  getMockData
}
```

:hammer_and_wrench: 这样每次去修改生成随机数据的方法就可以验证效果了

**效果**

```javascript
{
  list: [
    { id: 1 },
    { id: 2 }
  ]
}
```



### 表单数据例子

```javascript
Mock.mock({
  id: '@id',
  name: '@name',
  email: '@email',
  time: '@time',
  date: '@date',
  randomTime: '@date @time',
  currentTime: '@now'
})

/* 结果 */
{
  date: "2010-02-11",
  email: "p.xtjbb@sie.af",
  id: "610000199106175664",
  name: "Eric White",
  randomTime: "2010-02-11 13:56:39",
  time: "13:56:39",
  currentTime: "2022-07-04 16:40:09"
}
```



## 更多配置

### 生成随机数据

```javascript
Mock.mock('@boolean')

/* 结果 */
出现 true 和 false 的几率对半
```

```javascript
Mock.mock('@boolean(2, 9, true)')

/* 结果 */
2/2+9 的可能出现 true，否则 false
```

| 字符串                           | 说明                                                         |
| -------------------------------- | ------------------------------------------------------------ |
| @boolean                         | 随机的布尔值                                                 |
| @boolean(2, 9, true)             | `2/(2+9)` 的可能出现 true                                    |
| @natural                         | 随机的自然数（0-9007199254740992）                           |
| @natural(5)                      | （5-9007199254740992）                                       |
| @natural(5, 10)                  | （5-10）                                                     |
| @integer                         | 随机的整数（-9007199254740992 - 9007199254740992）           |
| @integer(-5, 11)                 | （-5-11）                                                    |
| @float                           | 返回一个随机的浮点数                                         |
| @float(0, 9, 2, 2)               | 返回[0, 10)之间的浮点数，小数为2位                           |
| @character                       | 从内置的字符池中选取（大小写字母、数字、符号）               |
| @character('lower')              | 返回一个随机的小写字母                                       |
| @character("abc")                | 从a、b、c中随机选取一个                                      |
| @string                          | 返回一个随机字符串（3-7位，包含大小写字母、数字、符号）      |
| @string('abc', 5)                | 返回一个随机字符串（5位，随机包含a、b、c）                   |
| @range(3)                        | 返回数组 [0, 1, 2]，设置的值为结束值，不会被包含在数组中     |
| @range(3, 7)                     | 返回数组 [3, 4, 5, 6]                                        |
| @date                            | 返回随机日期字符串 yyyy-MM-dd                                |
| @date('yyyy-MM-dd HH:mm:ss')     | 返回随机日期字符串 yyyy-MM-dd HH:mm:ss                       |
| @time                            | 返回随机时间字符串 HH:mm:ss                                  |
| @time('HH:mm')                   | 返回随机时间字符串 HH:mm                                     |
| @time('H:mm')                    | 返回随机时间字符串 H:mm                                      |
| @datetime                        | 返回随机日期字符串 yyyy-MM-dd HH:mm:ss                       |
| @now                             | 返回当前的日期和时间字符串                                   |
| @now('month')                    | 返回本月第一天第一个时刻的日期和时间字符串                   |
| @image                           | 返回图片地址，宽高从内置的池子中选取                         |
| @image('200x200')                | 返回图片地址，宽高为 200*200                                 |
| @dataImage                       | 返回一段随机的 Base64 图片编码，宽高从内置的池子中选取       |
| @color                           | 返回颜色字符串，`\#RRGGBB`                                   |
| @rgb                             | 返回颜色字符串，`rgb(r, g, b)`                               |
| @rgba                            | 返回颜色字符串，`rgb(r, g, b, a)`                            |
| @paragraph                       | 返回随机的英文文本（由3-7个句子组成）                        |
| @paragraph(2， 3)                | 返回随机的英文文本（由2-3个句子组成）                        |
| @cparagraph                      | 返回随机的中文文本（由3-7个句子组成）                        |
| @cparagraph(2)                   | 返回随机的中文文本（由2个句子组成）                          |
| @cparagraph(2， 3)               | 返回随机的中文文本（由2-3个句子组成）                        |
| @sentence                        | 返回随机的大写开头的英文句子（由12-18个单词组成）            |
| @csentence                       | 返回随机的中文句子                                           |
| @csentence(1, 3)                 | 返回随机的中文句子（由1-3个中文汉字、字符组成）              |
| @word                            | 返回随机的一个单词                                           |
| @cword                           | 返回随机的一个汉字（从字符池）                               |
| @cword('王大哥', 3, 4)           | 返回随机的3-4汉字（从‘王大哥’）                              |
| @title                           | 返回随机的英文标题（由3-7个单词组成，每个单词首字母大写）    |
| @ctitle                          | 返回随机的中文标题（由3-7个汉字组成）                        |
| @name                            | 返回一个常见的英文姓名                                       |
| @first                           | 返回一个常见的英文名                                         |
| @cname                           | 返回一个常见的中文姓名                                       |
| @clast                           | 返回一个常见的中文姓                                         |
| @url                             | 返回随机的URL                                                |
| @url('http')                     | 返回随机的URL，指定协议为http                                |
| @url('http', 'www.bilibili.com') | 返回随机的URL，指定协议为http，域名和端口号为www.bilibili.com |
| @protocol                        | 返回随机的 URL 协议                                          |
| @domain                          | 返回随机的域名                                               |
| @tld                             | 返回随机的顶级域名                                           |
| @email                           | 返回随机的邮件地址                                           |
| @email('qq.com')                 | 返回随机的邮件地址，指定域名为 `qq.com`                      |
| @ip                              | 返回随机的  IP 地址                                          |
| @region                          | 返回随机的大区（如华北）                                     |
| @province                        | 返回随机的省（或直辖市、自治区、特别行政区）                 |
| @city                            | 返回随机的市                                                 |
| @city(true)                      | 返回随机的市（添加省作为前缀）                               |
| @county                          | 返回随机的县                                                 |
| @county(true)                    | 返回随机的市（添加省、市作为前缀）                           |
| @zip                             | 返回随机的邮政编码（六位数字）                               |
| @id                              | 返回随机的身份证（十八位）                                   |
| @guid                            | 返回随机的 GUID                                              |
| @pick(['a', 'b', 'c])            | 从数组中随机选取一个元素，并返回                             |
| @shuffle(['a','b','c'])          | 打乱数组中元素的顺序，并返回                                 |



### 自定义请求的响应时间

```javascript
// 2s
Mock.setup({
  timeout: 2000
})

// 0.5-1s
Mock.setup({
  timeout: '500-1000'
})
```





### 自定义随机数据

```javascript
let Random = Mock.Random
Random.extend({
  food(date) {
    var foods = ['红烧', '清蒸']
    return this.pick(foods)
  }
})
Random.food()
Mock.mock('@FOOD')

/* 结果 */
'红烧'
```



### [官网](http://mockjs.com/examples.html)更多用法

<span style="color: #c7254e; background: #f9f2f4">'name|min-max': string</span>

```
Mock.mock({
  "string|1-10": "★"
})
```

```
{
  "string": "★★★★★"
}
```

结果随机出现1-10次



<span style="color: #c7254e; background: #f9f2f4;">'name|count': string</span>

```
Mock.mock({
  "string|2": "★★★"
})
```

```
{
  "string": "★★★★★★"
}
```

结果重复2次



<span style="color: #c7254e; background: #f9f2f4;">'name|min-max': number</span>

```
Mock.mock({
  "number|1-100": 100
})
```

```
{number: 90}
```



<span style="color: #c7254e; background: #f9f2f4;">'name|min-max.dmin-dmax': number</span>

```javascript
Mock.mock({
  "number|1-100.1-2": 1
})

/*-------------------------*/
{number: 95.11}
```

```
Mock.mock({
  "number|123.1-10": 1
})

/*-------------------------*/
{number: 123.7776}
```

```
Mock.mock({
  "number|123.3": 1
})

/*-------------------------*/
{number: 123.546}
```



<span style="color: #c7254e; background: #f9f2f4;">'name|min-max': boolean</span>

```
Mock.mock({
  "boolean|1-2": true
})

/*-------------------------*/
{boolean: false}
```



<span style="color: #c7254e; background: #f9f2f4;">'name|count': object</span>

```
Mock.mock({
  "object|2": {
    "310000": "上海市",
    "320000": "江苏省",
    "330000": "浙江省",
    "340000": "安徽省"
  }
})
```

```
{
  "object": {
    "310000": "上海市",
    "320000": "江苏省"
  }
}
```



<span style="color: #c7254e; background: #f9f2f4;">随机1-10，顺序往下</span>

```
Mock.mock({
  "array|1-10": [
    {
      "name|+1": [
        "Hello",
        "Mock.js",
        "!"
      ]
    }
  ]
})
```

```
{
  "array": [
    {
      "name": "Hello"
    },
    {
      "name": "Mock.js"
    },
    {
      "name": "!"
    },
    {
      "name": "Hello"
    }
  ]
}
```



## 封装

**定义**

```javascript
import Mock from 'mockjs'
const List = []
const count = 5

for (let i = 0; i < count; i++) {
  List.push(Mock.mock({
    id: '@increment',
    'date': '@date("yyyy-MM-dd")',
    'name': '@cname',
    'province': '@province',
    'city': '@city',
    'address': '@county(true)',
    'postcode': '@zip'
  }))
}

export default [
  {
    url: '/demo',
    type: 'get',
    response: config => {
      var { limit } = config.query
      return {
        code: 200,
        data: {
          page: List.slice(0, limit),
          total: limit
        }
      }
    }
  }
]
```

>  response 的返回值将作为最终结果。

**使用**

```javascript
function handleAxios2() {
  // 发起请求
  axios.get('http://127.0.0.1:3000/demo?limit=2').then(r => {
    console.log(r.data)
  })
}
```

**结果**

```javascript
{
  code: 200
  data: {
    page: [
      {id: 1, date: "2002-01-27", name: "徐丽", province: "澳门特别行政区", city: "九龙", …},
      {id: 2, date: "2007-11-09", name: "姚平", province: "吉林省", city: "吴忠市", …}
    ],
    total: "2"
  }
}
```

>  这时多次请求的结果是一样的。



