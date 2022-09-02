## Proxy(代理)

**Proxy** 也就是代理，可以[帮助](https://www.jianshu.com/p/77eaaf34e732)我们完成很多事情，例如对数据的处理，对构造函数的处理，对数据的验证，说白了，就是在我们访问对象前添加了一层拦截，可以过滤很多[操作](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Proxy)，而这些过滤，由你来定义。



### 语法

```javascript
let p = new Proxy(target, handler);
```

<span style="color: #f7534f;font-weight:600">target  </span>需要使用 <span style="color: #a50">Proxy</span> 包装的目标对象（可以是任何类型的对象，包括原生数组，函数，甚至另一个代理）;

<span style="color: #f7534f;font-weight:600">handler </span>一个配置对象，其属性是当执行一个操作时定义代理的行为的函数（可以理解为某种触发器）。



### get函数

```javascript
let test = {
  name: "小红"
};
test = new Proxy(test, {
  get(target, key) {
    console.log('获取了getter属性');
    return target[key];
  }
});

// 获取 test 的属性时，触发 get 函数
console.log(test.name);

// 获取了getter属性
// 小红
```

:turtle: 上方的案例，我们首先创建了一个<span style="color: #e63e31">test</span>对象，里面有<span style="color: #e63e31">name</span>属性，然后我们使用<span style="color: #e63e31">Proxy</span>将其包装起来，再返回给<span style="color: #e63e31">test</span>，此时的<span style="color: #e63e31">test</span>已经成为了一个<span style="color: #e63e31">Proxy</span>实例，我们对其的操作，都会被<span style="color: #e63e31">Proxy</span>拦截。



### set函数

>  咱们再来试试使用`set`来拦截一些操作，并将`get`返回值更改。

```javascript
  let xiaohong = {
    name: "小红",
    age: 15
  };
  xiaohong = new Proxy(xiaohong, {
    get(target, key) {
      let result = target[key];
      //如果是获取 年龄 属性，则添加 岁字
      if (key === "age") result += "岁";
      return result;
    },
    set(target, key, value) {
      if (key === "age" && typeof value !== "number") {
        throw Error("age字段必须为Number类型");
      }
      return Reflect.set(target, key, value);
    }
  });
  console.log(`我叫${xiaohong.name}  我今年${xiaohong.age}了`);
  xiaohong.age = "aa";

// 我叫小红，我今年15岁了
// 报错
```



### set函数其他返回值方式

```javascript
set(target, key, value) {
  if (key === "age" && typeof value !== "number") {
    throw Error("age字段必须为Number类型");
  }
  target[key] = value;
  return true;
}
```

:ghost: `set`函数必须返回一个`boolean`值（否则会报错），只有返回值为`true`时才表示修改成功。



## 期约

### 返回连锁

`api.js`

```react
/* 1. 返回期约 2. 解决处理程序中返回值进行传递 */
getProfile(queryForm) {
  return getProfile(queryForm).then(r => r);
},
```

:ghost: 其实这里照样传递，用 `then` 没什么意义了，不省略便于理解吧。

`demo.vue`

```react
this.getProfile().then((r) => {
  console.log(r);
});
```



### then合理获参

```react
getCoupons() {
  getCouponsByIds({ ids: this.coupon.ids }).then((r) => {
    if (r && r.data && r.data.data) {
      this.coupons = r.data.data
    }
  })
},
```



### then合理收尾

```react
createPageSetting(request).then((r) => {
  this.id = r;
}).catch((e) => {
  window.console.log('create error======>', e);
});
```



### async合理收尾

```react
import { getReceiverInfo } from '@/api/orderCenter/afterSale'

async getInfo() {
  try {
    uni.showLoading({ title: '加载中...' })
    const res = await getReceiverInfo({
      storeId: this.orderData.storeId || ''
    })
    if (res.data.code == 200) {
      this.refundMerchantObj = res.data.data || {}
    } else {
      uni.showToast({ title: res.data.msg, icon: 'none' })
    }
  } catch (err) {
    console.log(err)
  } finally {
    uni.hideLoading()
  }
},
```



```javascript
async getList() {
  this.loading = true;
  try {
    const res = await goodsList(this.pager) || {};
    this.list = res.records || [];
  } catch (err) {
    window.console.error(err);
  } finally {
    this.loading = false;
  }
},
```



### 执行顺序示例

```javascript
async serviceBookPage() {
  console.log('serviceBookPage 1')
  const r = await serviceBookPage(this.data.queryData)
  console.log('serviceBookPage 2')
  // ...大量代码
  console.log('serviceBookPage 3')
},

async onShow() {
  const res = await this.serviceBookPage()
  console.log('res', res)
  console.log('onshow Next')
},
```

执行顺序

```elm
serviceBookPage 1
serviceBookPage 2
serviceBookPage 3
res undefined
onshow Next
```





## 对象解构

```react
let { top } = { top:2, height: 'a' }
console.log(top)  // 2
```



### 示例—接口

```react
async getTabsHeight() {
  let { top, height } = await getNodeInfo()
  this.filterTop = top + height
},
```



### 示例—获取函数入参

```react
onLoad(option) {
  this.getGiftcardCode(option)
},
methods: {
  async getGiftcardCode({ orderNo }) {
    const res = await generateOrderCode(orderNo)
    this.giftcardCode = res.data.data
  }
}
```



### 示例—获取事件参数

```react
// uni-app 的某些原生事件参数
change({ detail }) {
  this.current = detail.current + 1
},
```



### 示例—补充对象属性

```react
async handleGiftGoods(allGiftGoods) {
  // 补全赠品信息，这里为每个赠品发送一次请求
  allGiftGoods.forEach((item, index) => {
    allGiftGoods[index] = item
    this.completeGift(item, index)
  })
},
    
async completeGift(item, index) {
  const res = await getStoreGoodsDetail({ goodsId: item.goodsId })
  if (res.data.code == 200 && res.data.data) {
    let { barcode, iconUrl, price, storeGoodsId, weight } = res.data.data
    item = { ...item, barcode, iconUrl, price, storeGoodsId, weight }
    // 触发监听
    this.$set(this.allGiftGoods, index, item)
  }
},
```



## 展开对象



### 添加额外属性

```react
form = {...form, isSelect: false};      // 额外添加属性

form = {...form, id: form.uid};         // 拷贝自身属性
```



