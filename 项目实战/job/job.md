## 请求参数选择

> 如果使用GET请求，只能传入params属性（会被拼接到路径），故使用data和urlQueryParmas都可以。

| POST请求  |     方式一     |  方式二  |
| :-------: | :------------: | :------: |
| 传参方式  |    拼接路径    | 传入实体 |
| 对应axios |     params     |   data   |
| 对应框架  | urlQueryParmas |   data   |



## captain.apply.helper.js

```javascript
// 提供返回服务器根路径的方法，不一定用的上
import baseConfig from "../../config.js";
// 提供深拷贝表单和验证文件类型的方法，直接在最后导出
import basicFormHelper from "../basic.form.helper.js";

// 放相关的子路径，之后可以引入组件直接作为请求框架的参数
const basicConfig = {
	fisherPath: "/cn/dmai/aibook/demo/fisher/demofather.fisher.xml",
	newUrl: "demo/father/new",
	editUrl: "demo/father/edit",
	deleteUrl: "app/json/delete",
	saveUrl: "demo/father/save",
    
    // 有的会添加这两项（这里本身没有），推测与上传头像相关
    uploadUrl: baseConfig.getServicePath() + "app/json/upload",
	allUploadTypes: ['image/jpeg', 'image/png']
};

const includeProperties = [];

// 表单绑定数据
const form = {
	id: -1,
	leaderSex:"",
    post:"",
	remark: [], //多选
};

// 表单规则
const formRules = {
	leaderSex:[{
		required: true,
		message: "请选择性别",
		trigger: "change"
	}],
	post: [{
        required: true,
        message: "请输入职务",
        trigger: "blur"
	}],
};

// 后续加的功能配件，属性为需要另行配置的属性，prefix为前缀，alias为别名
let formFormatRules = {
	userId:{
		prefix: "domain.member", // 设置的后台的命名空间前缀
		alias: "id" // 设置更改后的属性名
	},
	memberId:{
		prefix: "domain.member", 
		alias: "id" 
	}
};

const initPageRules = [{ //如果是通过getCodeItemList得到编码格式的可以不写下面的dataLoadSuccess
	name: "racePprojectList",
	loadDataUrl: "/app/json/getCodeItemList?code=sex",
	dataLoadSuccess(pageData, rule, data, vueData) {
		console.log("自定义格式>>>");
		let list = data.content;
		for (let i = 0; i < list.length; i++) {
			vueData.pageData[rule.name].push({
				name: list[i].name,
				value: list[i].value
			});
		}
	},
}];


/* 深拷贝本页面定义的form数据 */
const copyNewForm = function() {
	let jsonStr = JSON.stringify(form);
	let newForm = JSON.parse(jsonStr);
	return newForm;
};

/* 把本地页面data中定义的form转换接口所需的数据格式 */
const convertDbForm = function(pageForm) {
	let dbForm = {
		...{},
		...pageForm
	};
    // 将该属性由数组转化为字符串
    bForm.remark = dbForm.remark+"";
	return dbForm;
    
    /**
    * 后续修改，作用是起别名：默认给属性添加前缀domain，或按规则给特定属性添加特殊前缀或更名，同时将         *  includeProperties 属性添加到表单对象上。 
    *
	var postData = context.$basicRequest.getPostData({
		formData: dbForm,
		formatRules: formFormatRules,
		includeProperties
	});
	return postData;
	
	*/  
};

/* 把通过查询返回的数据格式转化后塞入到页面data的from属性中 */
const dbToForm = function(dbFrom, contextForm) {
	// 赋值
	let newForm = {};
	for (let p in contextForm) {
		if (dbFrom[p] !== undefined) {
			newForm[p] = dbFrom[p];
		}
	}
    // 将该属性由数字转化为字符串
    newForm.leaderSex = newForm.leaderSex + "";    
	return newForm;
};

export default {
	includeProperties,
	basicConfig,
	form,
	copyNewForm: basicFormHelper.copyNewForm,

	initPageRules,
	formRules,
	convertDbForm,
	dbToForm,

	allowUploadTypes: basicFormHelper.allowUploadTypes
}
```



## 请求示例（临时）

> 在Vue原型上，以 `$basicRequest` 绑定了封装好的请求方法。

```
let me = this;
let url = "app/json/sendVerification..";
me.$basicRequest.request({
    context: me,
    url: url,
    success(data, parameters) {
        me.$message({
          message: '恭喜你，发送成功',
          type: 'success'
        });
    },
    error(data,message,parameters){
        me.$alert(message, '发送失败', {
            confirmButtonText: '确定',
            callback: action => {//点击确定时执行的逻辑}
        });
    }
});


let me = this;
let url = "basic/user/bindMobile";
me.$basicRequest.request({
    context: me,
    url: url,
    data: {
        "username":me.ruleForm.username,
        "mobile":me.ruleForm.mobilephone
    },
    success(data, parameters) {}
});
```



## 编码表相关（临时）

```javascript
import pageHelper from '../../js/pageHelper.js';

data() {
  return {
    pageData: {
      learningSectionList:[],
      permissionSettingList:[],
      participationTypeList: [],
      experimentEnvironmentList:[]
    },
  }
},
created(){
  let me = this;
  pageHelper.loadCodes({
    context: me,
    multipleCodeStr: "learning_section,challenge_permission_setting,competition_type,test_platform", //grade_level,
    success(codesJson) {
      pageHelper.initPageDataItem(me.pageData.learningSectionList, codesJson, "learning_section", false);
      pageHelper.initPageDataItem(me.pageData.permissionSettingList, codesJson, "challenge_permission_setting", false);
      pageHelper.initPageDataItem(me.pageData.participationTypeList, codesJson, "competition_type",false);
      pageHelper.initPageDataItem(me.pageData.experimentEnvironmentList, codesJson, "test_platform",false);
    }
  });
}
```



## 页面data（临时）

```
/* 页面所用到的基础数据，例如select,check,radio */
pageData: {
  sexList: [],
  stateList: [],
  organizationTypeList: []
},
// 查询参数（表格或列表的？）
query: {
  name: "",
  sex:"",
  age:"",
  state:"",
  birthday:""
},
// default为首个表格（列表），rows属性将作为数据源
pager: {
  default: {
    layout: fisherRequest.layout,
    pagesize: fisherRequest.rp,
    pagenum: 1,
    total: 0,
    rows:undefined
  }
},
// 深拷贝一份出来
form: formHelper.copyNewForm(formHelper.form),
formRules: formHelper.formRules
```



## 文件功能描述（临时）

```
import baseConfig from '../../config.js'
import fisherRequest from '../../js/fisherRequest.js'
import pageHelper from '../../js/pageHelper.js'
import formHelper from '../../js/demo/demo.father.helper.js';
```



文件 | 说明
:- | :- 
baseConfig | 含有服务器根路径、上传图片或文件时需要用到
fisherRequest | 感觉就是列表请求，自动success，附带prepareRender和afterRender
pageHelper | 查询多个编码表并返回到数据中
formHelper | 提供表单原始绑定对象，验证规则
