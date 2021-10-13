## Radio 单选框

### 去除点击放大效果

> 该效果由边框阴影产生，找到相应类后复写即可。

```css
.ant-radio-button-wrapper-checked {
  box-shadow: none; 
}
```



## Button 按钮

### 去除按钮的闪烁效果

> 往往发生在自定义按钮背景色后。
>
> 产生的原因是组件自带的过渡效果。

```css
demo {
  transition: none;
}
```



## Input 输入框

#### InputSearch 带搜索按钮的输入框













