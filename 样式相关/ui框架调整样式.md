## 功能实现



### 更改图标颜色

```css
.el-icon-success {
  color: #52C41A;
}
```



### 按钮中文字的垂直居中

> 如果是由于行高问题导致的位移，可以用下面这个方法尝试一下。

```vue
<button>
  <span>按钮</span>
</button>
```

```css
button {
  width: 130px;
  height: 40px;
  line-height: 0;
}
```



## 解除疑惑



### 调整窗口时元素莫名移动

> 往往是因为ui库添加了相应布局，如span、offset，其设定的值为百分比形式；不排除组件自带这些属性。
>
> 可以设置具体宽度解决。



