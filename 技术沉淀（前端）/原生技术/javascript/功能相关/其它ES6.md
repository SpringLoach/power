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
      console.log('获取门店收件人信息', res.data.data)
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



