#### 列表、下拉项页面规范

> 这里 query 里的数据使用undefined，才能显示出placeholder。
>
> 当前页面可以根据 query 进行多条件搜索。  

| 索引 | 属性     | 说明                                          |
| :--: | :------- | :-------------------------------------------- |
|  ①   | query    | 对应下拉菜单、输入框的绑定值                  |
|  ②   | pageData | 下拉菜单的选项                                |
|  ③   | pager    | 当前页面的列表信息，default表示首个列表的信息 |

```
query: any = {
	model: "",
	period: "",
	subject:"",
	experiClassify:"",
	teachingName: ""
};

pageData: any = {
	modeList: [],
	periodList:[],
	subjectList: [],
	experiClassifyList:[],
	courseList:{
		rows:[]
	}
};

pager:any = {
	default: {
		pagesize: (listRequest.pagesize as number),
		pagenum: 1,
		total: 10,
		// 存放数据
		rows: []
	}
};
```

### 数据转化

#### 将数组的JSON数据转化为数组

> 转化后的 subject 为多个对象组成的数组，每个对象上有一个 source 属性，其值为标签（HTML）形式，需要展示。

```vue
<div>
    <div v-for="i in item.subject" v-html="i.source"></div>
</div>

labApi.getList({
  ...
  prepareRender(data: any) {
    for(let i=0;i<data.data.list.length;i++){
      let row = data.data.list[i];
      row.subject = JSON.parse(row.subject);
    }
  }
})                                         
```



#### 多种格式数据统一转化为数组

> 数据有可能是数组、数组的JSON数据（字符串）、空字符串。
>
> 不能对空字符串和数组使用 `JSON.parse`，否则报错。

```javascript
let subject = item.subject;
if(typeof subject === "string"){
    if(subject===""){
        subject = "[]";
    }
    subject = JSON.parse(subject);
}
cellData.content =  subject;   
```

### 权限管理

#### 进入相同页面（组件）

> 从父组件传入自定义属性，根据传入的值，可以条件渲染某些模块，或执行不同的方法。  

