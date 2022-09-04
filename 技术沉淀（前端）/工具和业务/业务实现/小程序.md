### 购买校验是否登录

> 允许用户浏览商品列表和活动大厅，但在加购/购买时，需要校验用户的登录信息。如果没有登录，需要跳转到登录页完成登录逻辑，并自动跳转回到当前页。

**加购、购买页面**

引入信息组件，信息组件将以按钮形式存在，并暴露文字插槽。

```html
<text>数量：5</text>
<user-info @success="toOrder">立即购买</user-info>
```

> 当子组件返回 success 事件时，继续执行接下来的逻辑。

**按钮组件**

<span style="backGround: #efe0b9">components/userInfo/index.vue</span>

```react
<template>
  <button v-if="!isMember" @click.stop="toLogin">
    <slot></slot>
  </button>
  <button v-else @click.stop="handleClick">
    <slot></slot>
  </button>
</template>

computed: {
  ...mapState(['user']),

  isMember() {
    return this.user.memberId && this.user.memberId > 0
  },
},
methods: {
  toLogin() { /* 跳转到登录页 */ },
  handleClick() {
    this.$emit('success')
  }
}
```

**登录页**

<span style="backGround: #efe0b9">login/index.vue</span>

```javascript
login() {
  // ...
  /* 成功执行登录逻辑后，返回页面 */
  uni.navigateBack()
}
```



### 登录返回的处理

> 对于新用户，在登录完成后跳转到首页，否则回到上一个页面。

```javascript
getNewUserRights(memberId) {
  newUserRights({ memberId })
  .then((res) => {
    if (res.data.code === '200' && res.data.data && res.data.data.length > 0) {
      setTimeout(() => {
        uni.redirectTo({
          url: '/pages/home/index'
        })
      }, 300)
    } else {
      setTimeout(() => {
        uni.navigateBack() // 返回之前的一个页面
      }, 300)
    }
  })
  .catch((err) => {
    console.err(err)
  })
}
```



### 跳转页的时序

> 场景：通过二维码直接进入当前页面，不能保证登录的请求及相关逻辑已经处理完毕；而当前页的请求依赖于这些数据。

```javascript
computed: {
  ...mapState(['user']),
      
  memberId() {
    return this.user ? this.user.memberId : ''
  }
},
methods: {
  // 请求列表
  page() {}
},
onLoad() {
  if (this.memberId) {
    this.page()
  }
},
watch: {
  userId(newVal) {
    if (newVal) {
      this.page()
    }
  }
}
```

> 方案：在加载时尝试调用请求（从其它页面来）；在监听到值变化时也尝试调用请求（登录逻辑）。



切换分类时也会请求列表，但也需要登录状态，故为了方便起见，在请求方法内部判断是否需要请求。

```javascript
// 请求列表
page() {
  if (!this.memberId) return
  // 请求
}
```















