## 将某个元素下载为PDF

> 需要用到的第三方库文档： [html2canvas](https://html2canvas.hertzen.com/documentation) 和 [jsPDF](http://raw.githack.com/MrRio/jsPDF/master/docs/jsPDF.html#addPage)，github上也有一些栗子。



1. 拷贝文件 `htmlToPdf.js` 
2. 引入到目标组件，（当点击按钮时）执行相应逻辑

3. 安装对应依赖，完成

4. 如果在PDF中有些字体错位，给其加上一个 `<span>` 包裹即可。

```javascript
import htmlToPdf from '../../../js/htmlToPdf.js';

// 下载简历
handleExportPDF() {
  setTimeout(() => {
    /* 首参为要生成PDF的DOM元素（容器），第二个参数为PDF文件生成后的文件名字 */
    htmlToPdf.downloadPDF(document.querySelector(".resume"), this.userInfo.name); 
  }, 500);
}
```

```elm
cnpm install html2canvas@1.3.2 -D
cnpm install jspdf@2.4.0 -D
```



### 打开对话框后下载其元素

> 需要确保子元素中的内容渲染完毕。

```javascript
downloadResume(id) {
  // 该属性将传递给子组件作为请求参数
  this.resumeId = id;
  this.resumeVisible = true;
  this.$nextTick(() => {
    // 不渲染子组件内的某些内容
    this.$refs.resume.isPreview = false;
    this.$refs.resume.handleExportPDF();
  })
},
```



### html2canvas打印丢失图片

> 是跨域政策导致的，[资料](https://blog.csdn.net/qq_39045645/article/details/115690019)和[原因](https://developer.mozilla.org/zh-CN/docs/Web/HTML/CORS_enabled_image)。还有转pdf的更多[补充](https://blog.csdn.net/github_36704158/article/details/73929775/)。另外的疑似[方案](https://www.jb51.net/article/150740.htm)和[原理讲解](https://juejin.cn/post/6844903725744521223)部分[介绍](https://old.xhcss.com/xh/js/question/239.html)。

```javascript
<img src="" alt="" crossorigin="anonymous" class="imgs" />

// 成功请求到数据后
.then(data => {
  this.userInfo = data;
  /* 将图片转化为允许跨域的形式，能够在html2canvas中使用 */
  /* 将图片转化为base64格式后，再进行绘图，这样就不会污染画布 */
  this.getBase64Image(this.userInfo.relativeIamge, document.querySelector('.imgs'));
})

getBase64Image(url, ref) {
  let me = this;
  var image = new Image();
  image.src = url + "?v=" + Math.random(); // 处理缓存
  image.crossOrigin = "*"; // 支持跨域图片

  image.onload = function () {
    var base64 = me.drawBase64Image(image);
    ref.src = base64;
  };
},
drawBase64Image(img) {
    var canvas = document.createElement("canvas");
    canvas.width = img.width;
    canvas.height = img.height;
    var ctx = canvas.getContext("2d");
    ctx.drawImage(img, 0, 0, img.width, img.height);
    var dataURL = canvas.toDataURL("image/png");
    return dataURL;
  }
},
```



### 下载为PDF后执行回调

> 给该方法增加第三个参数，作为回调，在内部的打印完成后执行回调。

`目标组件`

```javascript
htmlToPdf.downloadPDF(document.querySelector(".resume"), this.userInfo.name, function(){
  me.isPreview = true;
});
```

`htmlToPdf.js`

```javascript
function downloadPDF(ele, pdfName, callback){
  ...
  pdf.save(pdfName + ".pdf");
  /* 在下载 PDF 后执行 */
  if(callback!=''&& typeof callback == "function"){
    callback();
  }
}
```

### 防截断

> 添加了防止在文字或图片处截断的功能，见 `htmlToPdf_2.js`。
>
> 需要注意的是，火狐在执行其中的 `getImageData` 时比其他浏览器慢了许多倍。



## 调用浏览器原生打印

> 需要用户决定是否显示页眉页脚，输出PDF以及打印背景。
>
> 可以[自定义](https://www.npmjs.com/package/vue-print-nb#print-local-range-more)标题以及打印前后的回调。

```elm
npm install vue-print-nb --save
```

```javascript
import Print from 'vue-print-nb'
Vue.use(Print);
```

```vue
<el-button plain v-print="'#resume'">下载简历</el-button>
<div id="resume">我要被打印啦</div>
```



## 小程序海报插件

> 原生小程序插件见 [Github](https://github.com/jasondu/wxa-plugin-canvas)。实现思路见[掘金](https://juejin.cn/post/6844903663840788493)

> uni-app 相关[插件](https://ext.dcloud.net.cn/plugin?id=586)



其它资料：动态[计算](https://www.jb51.net/article/152438.htm)海报在页面的宽高
