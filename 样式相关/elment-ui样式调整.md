### 删除ui框架自带的伪元素

> 某些组件自带伪元素，会影响布局且难以发现原因。

```css
.el-form-item__content::after, .el-form-item__content::before {
  display: none;
}
```



### 在表单项中两端对齐

> 需要去除其自带的伪元素。

```vue
<el-form class="target-form">
  <el-form-item class="justify-item">
    <el-button type="primary">注册</el-button>
    <span>使用已有帐户登录</span>
  </el-form-item>
</el-form>

<style lang="less" scoped>
/deep/ .target-form {
  .justify-item {
    .el-form-item__content {
      display: flex;
      justify-content: space-between;
    }
    .el-form-item__content::after,
    .el-form-item__content::before {
      display: none;
    }
  }
}
</style>
```



### 表单垂直布局与行内布局混用

#### 利用layout布局

> ！简易版，去除了绑定属性等。

```html
<el-form ref="form" label-width="50px">
   
  <!-- 单个输入框占全部宽度 -->  
  <el-form-item label="班级">
    <el-input></el-input>
  </el-form-item>
  
  <!-- 多个输入框占全部宽度 -->
  <el-row>
    <el-col :span="12">
      <el-form-item label="姓名">
        <el-input></el-input>
      </el-form-item>
    </el-col>
    <el-col :span="12">
      <el-form-item label="学号">
        <el-input></el-input>
      </el-form-item>
    </el-col>
  </el-row>
    
</el-form>
```

#### 利用原生样式

> 注意需要将表单项更改为行内块元素才能在同行出现。

```vue
<div class="father">
  <el-form ref="form" label-width="50px">
    <el-form-item label="班级">
      <el-input></el-input>
    </el-form-item>
    <el-form-item label="性别">
      <el-input></el-input>
    </el-form-item>
    <el-form-item label="学号">
      <el-input></el-input>
    </el-form-item>
  </el-form>
</div>
```

```less
.father {
  width: 400px;
}
.el-form {
  .el-form-item:nth-of-type(2) {
    width: 120px;
    display: inline-block;
  }
  .el-form-item:nth-of-type(3) {
    width: 280px;
    display: inline-block;
  }
}
```





