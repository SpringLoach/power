- [个人中心](#个人中心)
  + [个人中心_动态渲染信息区](#个人中心_动态渲染信息区)
- [订单查询](#订单查询)
  + [订单查询_跳转请求数据](#订单查询_跳转请求数据)
  + [订单查询_处理时间戳](#订单查询_处理时间戳)
- 其它页面补充
  + [详情页_收藏功能](#详情页_收藏功能)
  + [个人中心_显示收藏数量](#个人中心_显示收藏数量)
  + [收藏页](#收藏页)
  + [首页_导航跳转](#首页_导航跳转)
- [搜索页](#搜索页)
  + [搜索页_基础布局](#搜索页_基础布局)
  + [搜索页_搜索实现](#搜索页_搜索实现)
- [意见反馈](#意见反馈)
  + [意见反馈_静态布局](#意见反馈_静态布局)
  + [意见反馈_自定义图片组件](#意见反馈_自定义图片组件)
  + [意见反馈_上传图片](#意见反馈_上传图片)
  + [意见反馈_删除图片](#意见反馈_删除图片)
  + [意见反馈_提交功能](#意见反馈_提交功能)
- [项目发布](#项目发布)
- [默认首页](#默认首页)

### 个人中心

#### 个人中心_动态渲染信息区  

步骤 | 说明 | 解释
:-: | :-: | :-   
动态渲染 | 判断逻辑 | 根据缓存中是否有个人信息，条件渲染不同的内容
获取信息 | 先前方法 | 跳转到登录页，并提供一个获取个人信息类型的 `<button>`。将数据保存到缓存和页面后，返回先前页面  
获取信息 | 实际可以 | 可以通过点击触发 [wx.getUserInfo](https://developers.weixin.qq.com/miniprogram/dev/api/open-api/user-info/wx.getUserInfo.html) 获取个人信息
获取信息 | 其它说明 | 信息中包括头像、用户名等  

子绝父相，想要居中对齐时，还是使用 `left: 50%;`和 `transform: translateX(-50%);` ，可以设置百分比宽度来实现两边空隙  
使用 `nth-last-of-type()` 时，需要注意选项是否在同一个容器下，而不是在各自的容器中。  

### 订单查询  

#### 订单查询_跳转请求数据  

步骤 | 说明 | 解释
:-: | :-: | :-   
① | 跳转到页面 | 在我的页面通过 `<navigator url="">`，携带参数跳转
② | 选择钩子 | 由于该页面使用频率较高，故选择在 `onShow` 中请求数据等
③ | 获取令牌 | 由于请求列表数据需要 `token`，先判断缓存有无 `token`，无就请求得
④ | 获取参数 | 该钩子中，需要通过  `getCurrentPages()`，获取页面栈，取其返回数组的最后项的 `options`
⑤ | 传递索引 | 保存当前激活索引，传递给子组件用于标题的激活样式
⑤ | 获取数据 | /
⑥ | 获取数据 | 在点击回调中，请求相对应的数据  

```
onShow: function () {
  // 从页面栈中获取所需页面参数 type
  const pagesArr = getCurrentPages();
  let {type} = pagesArr[pagesArr.length-1].options;
}
```

#### 订单查询_处理时间戳  

```
// res.orders 为请求到的目标数组
let listData = res.orders.map(item => {return {...item, create_time_treat: new Date(item.create_time*1000).toLocaleString()}} )
this.setData({
  listData
})
```

----

### 其他页面补充

#### 详情页_收藏功能  

> 由于后端没有提供相应的接口，只能临时靠缓存实现。  

步骤 | 说明 | 解释
:-: | :-: | :-   
① | 钩子切换 | 猜测是考虑到从收藏页切回详情页的情况，将先前的请求[等逻辑](#订单查询_跳转请求数据)也放到了 `onShow`
② | 钩子切换 | 因为判断收藏情况需要用到商品详情数据和缓存的收藏数据，将逻辑放在请求数据后
③ | 动态渲染 | 动态渲染需要的 `icon`
④ | 点击回调 | 缓存中没有时，将商品数据添加到缓存
⑤ | 点击回调 | 否则，从缓存中移除该商品数据
⑤ | 点击回调 | 动态渲染需要的 `icon`

#### 个人中心_显示收藏数量  
> 在钩子中获取缓存保存到页面，渲染即可。同时添加链接。  

#### 收藏页  
> 缝合怪。  

#### 首页_导航跳转  
> 通过正则表达式更换路径不正确的地方。  
> 
> 对于可能提供多种可选参数的请求，均要考虑。  

```
// 通过 `url` 传参
onLoad: function (options) {
  this.queryParams.cid = options.cid || '';
  this.queryParams.query = options.query || '';
  发起请求
},
```

----

### 搜索页  

#### 搜索页_基础布局  
> 注意 `<button>` 的样式，需要通过类名设置，且它的一些默认属性干扰很大（如 `size` 会影响字体的横向排布）。  

#### 搜索页_搜索实现  
> 当用户输入完毕后，点击搜索才出现相应搜索信息，也许并不是一个好的体验。  
> 
> 注意 `<input>` 的 `value` 属性，本身只能决定初始值而没有绑定值。  

步骤 | 说明 | 解释
:-: | :- | :-   
① | 搜索实现 | 本质是将关键词发送给后端，取得相应数据进行渲染
② | 搜索实现 | 验证输入值后，即有无实际内容。通过后发起请求
③ | 清空功能 | 需要将输入值保存到本地
④ | 清空功能 | 再将输入值通过赋值到 `value` 属性上
⑤ | 清空功能 | 清除数据，重置初始值
⑤ | 防抖功能 | 微实现很简单  
⑥ | 跳转功能 | 使用 `<navigator>` 标签，添加相应路径  
⑦ | 手动清空输入框 | 此时要清空列表数据和计时器，验证时操作即可  

```
<input placeholder=".." bind:input="handleInput" value="{{inputValue}}"></input>
<button size="mini" bind:tap="clickClean">清空</button>
<view class="search_content"> 
  <navigator 
  wx:for="{{searchData}}" ...
  url="/pages/goods_detial/index?goods_id={{item.goods_id}}"
  >...</navigator>
</view>

data: {
  inputValue: '',
  searchData: []
},
timer: null,
clickClean() {
  this.setData({
    inputValue: '',
    searchData: []
  })
},
handleInput(e) {
  let inputValue = e.detail.value;
  this.setData({
    inputValue
  })
  // 验证有效性  
  if(!inputValue.trim()) {
    clearTimeout(this.timer);
    this.setData({
      searchData: []
    })  
    return
  }
  // 防抖版请求数据 
  clearTimeout(this.timer);
  this.timer = setTimeout(() => {
    this.getSearchData(inputValue);
  }, 800)
},
getSearchData(query) {
  getSearchData({data: {query}}).then(res => {
    this.setData({
      searchData: res.splice(0,10)
    })
  })
}
```

----

### 意见反馈  

#### 意见反馈_静态布局  
> 通过伸缩布局，设置项宽度为比例、margin 完成规律切行效果。  

#### 意见反馈_自定义图片组件  
> 小小的缩略图，右上角有关闭按钮。  
> 
> 其他需要的样式，可以在父组件用一个标签包围它，在标签上设置。  

```
.up_img_wrap {
  position: relative;  
  width: 90rpx;
  height: 90rpx;
  .up_img {
    background-color: #fff;
    border: 1px solid red;
    width: 100%;
    height: 100%;  
    border-radius: 12rpx;
  }  
  icon {
    position: absolute;
    top: -12rpx;
    right: -12rpx;  
  }
}
```

#### 意见反馈_上传图片  

步骤 | 说明 | 解释
:-: | :- | :-   
① | 触发时机 | 当点击默认渲染的按钮时，执行回调
② | 搜索实现 | 调用从本地选择或拍照的[接口](https://developers.weixin.qq.com/miniprogram/dev/api/media/image/wx.chooseImage.html)，保存图片地址数据
③ | 搜索实现 | 合并新旧数组，并注意 `this` 指向
④ | 父传子 | 由于 `src` 属性在子组件中，需要传递  

```
wx.chooseImage({
  count: 9,
  sizeType: ['original', 'compressed'],
  sourceType: ['album', 'camera'],
  success: res => {
    this.setData({
      upImgData: [...this.data.upImgData, ...res.tempFilePaths]
    })
  }
})
```

#### 意见反馈_删除图片  
> 子组件传递事件，页面作出反应并传递相应索引到内部操作。  

```
/* 子组件 */
<icon bind:tap="handleDelImg"></icon>

methods: {
  handleDelImg() {
    this.triggerEvent("handleDelImg")
  }
}

/* 页面 */

<view wx:for="{{}}">
  <UpImg bind:handleDelImg="handleDelImg" data-index="{{index}}"></UpImg>
</view>

handleDelImg(e) {
  let {index} = e.currentTarget.dataset;
  ...
}
```

#### 意见反馈_提交功能  

说明 | 解释
:- | :-   
输入事件 | 获取文本域的内容并保存  
点击提交 | 验证文本域的合法性（空文本）  
点击提交 | （如果有）将用户选择的图片（遍历）用接口 `wx.uploadFile` 上传到专门服务器，接收新的链接
提交到服务器 | 将文本域和新的图片路径上传到服务器  
收尾 | 提示成功、清空页面、返回上一页

```
 upImgData.forEach(v => {
  wx.uploadFile({
    // 图片上传路径，已失效
    url: 'https://images.ac.cn/Home/Index/UploadAction/',
    // 上传的文件路径
    filePath: v,
    // 上传的文件名称
    name: 'file',
    // 顺带的文本信息
    formData: {},
    success: (result) => {
      let url = JSON.parse(result.data).url;
      this.upLoadingImg.push(url);
    }
  });
})
```

### 项目发布  

步骤 | 说明 | 解释
:-: | :- | :-   
① | 开启白名单 | 不勾选 `不校验合法域名`，将需要的链接添加到白名单
② | 准备上传 | 使用个人/企业 APP，以 `上传`
③ | 准备上传 | 在以前，项目需小于 `2M`
④ | 准备上传 | 项目中用到的 `.less` 默认不会打包上传
④ | 准备发布 | 后台——版本管理——提交审核

### 默认首页  
> 用容器包围信息标签，来添加样式  

```
<!--index.wxml-->
<view class="container">
  <view class="userinfo">
    <block wx:if="{{canIUseOpenData}}">
      <view class="userinfo-avatar" bindtap="bindViewTap">
        <open-data type="userAvatarUrl"></open-data>
      </view>
      <open-data type="userNickName"></open-data>
    </block>
    <block wx:elif="{{!hasUserInfo}}">
      <button wx:if="{{canIUseGetUserProfile}}" bindtap="getUserProfile"> 获取头像昵称 </button>
      <button wx:elif="{{canIUse}}" open-type="getUserInfo" bindgetuserinfo="getUserInfo"> 获取头像昵称 </button>
      <view wx:else> 请使用1.4.4及以上版本基础库 </view>
    </block>
    <block wx:else>
      <image bindtap="bindViewTap" class="userinfo-avatar" src="{{userInfo.avatarUrl}}" mode="cover"></image>
      <text class="userinfo-nickname">{{userInfo.nickName}}</text>
    </block>
  </view>
  <view class="usermotto">
    <text class="user-motto">{{motto}}</text>
  </view>
</view>

// index.js
// 获取应用实例
const app = getApp()

Page({
  data: {
    motto: 'Hello World',
    userInfo: {},
    hasUserInfo: false,
    canIUse: wx.canIUse('button.open-type.getUserInfo'),
    canIUseGetUserProfile: false,
    canIUseOpenData: wx.canIUse('open-data.type.userAvatarUrl') && wx.canIUse('open-data.type.userNickName') // 如需尝试获取用户信息可改为false
  },
  // 事件处理函数
  bindViewTap() {
    wx.navigateTo({
      url: '../logs/logs'
    })
  },
  onLoad() {
    if (wx.getUserProfile) {
      this.setData({
        canIUseGetUserProfile: true
      })
    }
  },
  getUserProfile(e) {
    // 推荐使用wx.getUserProfile获取用户信息，开发者每次通过该接口获取用户个人信息均需用户确认，开发者妥善保管用户快速填写的头像昵称，避免重复弹窗
    wx.getUserProfile({
      desc: '展示用户信息', // 声明获取用户个人信息后的用途，后续会展示在弹窗中，请谨慎填写
      success: (res) => {
        console.log(res)
        this.setData({
          userInfo: res.userInfo,
          hasUserInfo: true
        })
      }
    })
  },
  getUserInfo(e) {
    // 不推荐使用getUserInfo获取用户信息，预计自2021年4月13日起，getUserInfo将不再弹出弹窗，并直接返回匿名的用户个人信息
    console.log(e)
    this.setData({
      userInfo: e.detail.userInfo,
      hasUserInfo: true
    })
  }
})

/**index.wxss**/
.userinfo {
  display: flex;
  flex-direction: column;
  align-items: center;
  color: #aaa;
}

.userinfo-avatar {
  overflow: hidden;
  width: 128rpx;
  height: 128rpx;
  margin: 20rpx;
  border-radius: 50%;
}

.usermotto {
  margin-top: 200px;
}
```





































