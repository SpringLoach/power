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



#### 分页按钮大小调整边距调整

> 其中的图标、文字带有默认行高，由于修改了整体高度，其行高也要跟随高度进行修正，否则会不居中。


```less
//----------- 全局的分页样式 --------- 
// 需要添加类名 global-pagination 才能生效
.global-pagination.is-background .btn-next, .global-pagination.is-background .btn-prev, .global-pagination.is-background .el-pager li {
  background-color: #fff;
  border: 1px solid #D9D9D9;
  width: 32px;
  height: 32px;
  line-height: 32px;
}
// 条数
.global-pagination {
  .el-pagination__sizes {
    margin-left: 5px;
    .el-input {
      width: 82px;
      .el-input__inner {
        height: 32px;
        background: #FFFFFF;
        border-radius: 4px;
        border: 1px solid #D9D9D9;
      }
      .el-input__icon {
        line-height: 32px;
      }
    }	
  }
}

// 跳转
.global-pagination  {
  .el-pagination__jump {
    margin-left: 0;
    color: rgba(0, 0, 0, 0.65);
    .el-input {
      margin: 0 8px;
      line-height: 32px;
      width: 48px;
      .el-input__inner {
        height: 32px;
        background: #FFFFFF;
        border-radius: 4px;
        border: 1px solid #D9D9D9;
      }
    }
  }	
}
```



#### 按钮中的文字隔开

> 靠文字间加空格实现。

#### 透明背景按钮

> 默认按钮自带内灰背景，朴素类型按钮则不会。

#### 选择器高度改变

> 调整样式改变高度后，箭头图标会错位，改掉其容器的默认的行高值即可。

#### 单选框选项间排斥

> 需要使用单选框组。

#### 改变输入框的宽高

> 还需要改变标签和容器的行高，否则错位。

```less
.el-form-item__label {
  line-height: 32px;
}
.el-form-item__content {
  line-height: 32px;
  .el-input {
    width: 468px;	
    .el-input__inner {
      height: 32px;
    }
  }
}
```

#### 日期选择器图标右移

> 好像不能像输入框一样，直接更改头部和尾部图标，故通过绝对定位实现。

```less
.birth-date {
  .el-date-editor--month {
    position: relative;
    .el-input__inner {
      // 改变默认边距
      padding-left: 15px;
    }
  }
  .el-input__prefix {
    position: absolute;
    left: 435px;	
    top: -2px;  
  }
}
```







