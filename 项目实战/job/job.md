## captain.apply.helper.js

```javascript
// 提供返回服务器根路径的方法，不一定用的上
import baseConfig from "../../config.js";
// 提供深拷贝表单和验证文件类型的方法，直接在最后导出
import basicFormHelper from "../basic.form.helper.js";

// 放相关的子路径
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
	name:"",
	post:"",
	cardNumber:"",
	contactPhone:"",
	contactEmail:"",
	state:""
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
	cardNumber:[{
        required: true,
        message: "请输入证件号码",
        trigger: "blur"
		}],
	phone:[{
        required: true,
        message: "请输入联系电话",
        trigger: "blur"
		}],
	email:[{
		required: true,
		message: "请输入联系邮箱",
		trigger: "change"
	}]
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


/**
 * 深拷贝本页面定义的form数据
 */
const copyNewForm = function() {
	let jsonStr = JSON.stringify(form);
	let newForm = JSON.parse(jsonStr);
	return newForm;
};

/**
 * 把本地页面data中定义的form转换接口所需的数据格式
 * @param {Object} pageForm
 */
const convertDbForm = function(pageForm) {
	let dbForm = {
		...{},
		...pageForm
	};
	return dbForm;
};

/**
 * 把通过查询返回的数据格式塞入到页面data的from属性中
 * @param {Object} dbFrom
 * @param {Object} contextForm
 */
const dbToForm = function(dbFrom, contextForm) {
	//赋值
	let newForm = {};
	for (let p in contextForm) {
		if (dbFrom[p] !== undefined) {
			newForm[p] = dbFrom[p];
		}
	}
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

