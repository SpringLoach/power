## css预处理器

### 应对环境命名风格

```react
<view class="tabs-container" :class="{ 'tabs-container--fixed': stickyFixed, 'tabs-container--nopadding': isNotPadding }"></view>

<style lang="scss" scoped>
.tabs-container {
  padding: 0 30rpx;
  &--fixed {
    position: fixed;
  }
  &--nopadding {
    padding: 0;
  }
}
</style>
```



## 解除疑惑



### 调整窗口时元素莫名移动

> 往往是因为ui库添加了相应布局，如span、offset，其设定的值为百分比形式；不排除组件自带这些属性。
>
> 可以设置具体宽度解决。



