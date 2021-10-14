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



## tree 树控件

#### 模拟区块背景色

> 树控件不存在同时包含图标和文字区域的（即单一选项）的元素，故想让它实现Menu的激活背景色效果，只能投机取巧。这里用伪元素来模拟背景色。

```
.ant-tree-treenode-selected::after {
  content: '';
  position: absolute;
  top: 5px;
  right: 0;
  /* 宽高与选项一致 */
  width: 240px;
  height: 44px;
  background: rgba(81, 135, 255, .1);
}
.ant-tree-treenode-selected::before {
  content: '';
  position: absolute;
  top: 5px;
  right: 0;
  width: 3px;
  height: 44px;
  background:rgba(81,135,255,1);
}
```









