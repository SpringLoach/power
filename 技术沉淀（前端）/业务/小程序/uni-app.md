### 购买校验是否登录

> 允许用户浏览商品列表和活动大厅，但在加购/购买时，需要校验用户的登录信息。如果没有登录，跳转到登录页完成登录逻辑后跳转回到当前页。

<span style="backGround: #efe0b9">加购组件、购买组件</span>

引入信息组件，信息组件将以按钮形式存在，并暴露文字插槽。

```html
<text>数量：5</text>
<user-info @success="toOrder">立即购买</user-info>
```



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
  ...mapState(['user', 'app', 'member']),

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



<span style="backGround: #efe0b9">login/index.vue</span>

```javascript
dos() {
  /* 成功执行登录逻辑后，返回页面 */
  uni.navigateBack()
}
```

