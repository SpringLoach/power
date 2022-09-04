### 权限校验

参考自 RuoYi-Vue3 的 utils/permission.js

```javascript
// 使用pinia保存当前用户权限信息
import useUserStore from '@/store/modules/user'

/**
 * 字符权限校验
 * @param {Array} value 校验值
 * @returns {Boolean}
 */
export function checkPermi(value) {
  if (value && value instanceof Array && value.length > 0) {
    const permissions = useUserStore().permissions
    const permissionDatas = value
    const all_permission = "*:*:*";

    const hasPermission = permissions.some(permission => {
      return all_permission === permission || permissionDatas.includes(permission)
    })

    if (!hasPermission) {
      return false
    }
    return true
  } else {
    console.error(`need roles! Like checkPermi="['system:user:add','system:user:edit']"`)
    return false
  }
}

/**
 * 角色权限校验
 * @param {Array} value 校验值
 * @returns {Boolean}
 */
export function checkRole(value) {
  if (value && value instanceof Array && value.length > 0) {
    const roles = useUserStore().roles
    const permissionRoles = value
    const super_admin = "admin";

    const hasRole = roles.some(role => {
      return super_admin === role || permissionRoles.includes(role)
    })

    if (!hasRole) {
      return false
    }
    return true
  } else {
    console.error(`need roles! Like checkRole="['admin','editor']"`)
    return false
  }
}
```



### h5在ios的分享

| 限制     | 说明                                                         |
| -------- | ------------------------------------------------------------ |
| 跳转限制 | 正常的路由跳转方式，对于安卓来说，其 url 可以直接用于 wx.config 配置 |
| 跳转限制 | 但 ios 不可以，对于需要分享的页面，需要通过 location.href / location.replace 的方式来到 |
| API限制  | 对于分享给好友/分享到朋友圈，需要使用旧的 API                |
| API限制  | 因为在 ios 使用新的 API 时，会出现各种奇怪的配置报错         |
| 分享配置 | 每个需要分享的页面都需要先使用 wx.config 配置，然后在 wx.ready 中初始化相关配置 |
| 分享配置 | 配置路径的处理：1. 要取需要的部分；2.路径中文编码的问题，需要后端配合 |

```javascript
const currentLink = window.location.href.split("#")[0]; // 注意：当前网页的 URL，不包含#及其后面的部分
const { data, err } = await api.getWechatShareConfigs({
  url: encodeURIComponent(currentLink),
});
```



### 生产/开发兼容跳转

生产模式使用 location.href 主要为了解决 ios 的分享问题；但该方法在开发模式行不通

```javascript
if (process.env.NODE_ENV === "production") {
  const donationInfoUrl = `https://${window.location.host}/prm/fr/mobile/index/#/personalCenter`;
  location.href = donationInfoUrl;
} else {
  router.push({ name: 'personalCenter' })
}
```



### 返回列表页保留查询条件

从编辑页返回列表页保留查询条件

1. 跳转到编辑页时，将查询条件保存到路由参数中
2. 从编辑页点击返回时，将路由参数带上，跳转到列表页
3. 在列表页组件的 mounted 钩子中，检查路由是否存在相应参数，有就初始化查询条件
