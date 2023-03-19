## markdown-使用方法

![markdown](./img/markdown.jpg)

**markdown 是一种轻量级的标记语言，它允许人们使用易读易写的纯文本格式编写文档．**

------

### 转义

> 显示特殊字符如 # *，需要在前面加上反斜杠 `\` 进行转义

<span style="color: #3a84aa">示例</span>

显示\#和\*

<span style="color: #3a84aa">编写形式</span>

```
显示\#和\*
```



### 引用

<span style="color: #3a84aa">示例</span>

> 这是一段对 markdown 语法的介绍。

<span style="color: #3a84aa">编写形式</span>

```
> 这是一段对 markdown 语法的介绍。
```



### 标题

<span style="color: #3a84aa">示例</span>

　　# 一级标题
　　## 二级标题
　　### 三级标题
　　#### 四级标题
　　##### 五级标题
　　###### 六级标题（较浅的字体颜色）

<span style="color: #3a84aa">编写形式</span>

```
# 一级标题
## 二级标题
### 三级标题
#### 四级标题
##### 五级标题
###### 六级标题（较浅的字体颜色）
```



----



### 链接

<span style="color: #3a84aa">快捷键</span>

「Ctrl+K」

<span style="color: #3a84aa">编写形式</span>

```
[title](URL)
```

:ghost: 其中 title 为链接标题，URL 为链接



### 图片

<span style="color: #3a84aa">编写形式</span>

```
![title](URL)
```

:ghost: 其中 title 为图片的替代文字，URL 为图片的地址



### 字体效果

#### 斜体

<span style="color: #3a84aa">快捷键</span>

「Ctrl+I」

<span style="color: #3a84aa">编写形式</span>

```
*斜体文字一*
_斜体文字二_
```



#### 加粗

<span style="color: #3a84aa">快捷键</span>

「Ctrl+B」

<span style="color: #3a84aa">编写形式</span>

```
**加粗文字一**
__加粗文字二__
```



#### 粗斜体

<span style="color: #3a84aa">编写形式</span>

```
***粗斜体文字一***
\\\粗斜体字二\\\
```



#### 删除线

<span style="color: #3a84aa">编写形式</span>

```
~~删除线~~
```



#### 分割线

<span style="color: #3a84aa">编写形式</span>

```
----
```



------

### 列表

#### 无序列表

<span style="color: #3a84aa">编写形式</span>

```
* apple
+ orange
- banana
```

:turtle: 符号与文字间的空格不能省略。



#### 有序列表

<span style="color: #3a84aa">编写形式</span>

```
1. text
2. text2
3. text3
```

:turtle: 数字 + `.` + 空格 + 文本



------

### 表格

单元格的分隔符用 `|` 表示；表头的分隔符用 `-` 表示．**表格前必须空一行**

- :-或-（默认）表示表头和单元格 **左对齐**
- -:表示表头和单元格 **右对齐**
- :-:表示表头和单元格 **居中对齐**
- <span style="color: #3a84aa">示例一</span>

　　 标题1 | 标题2 | 标题3
　　 :-: | :-: | :-:
　　 内容 | 内容 | 内容
　　 内容 | 内容 | 内容

<span style="color: #3a84aa">编写形式</span>

```
标题1 | 标题2 | 标题3
:-: | :-: | :-:
内容 | 内容 | 内容
内容 | 内容 | 内容
```

<span style="color: #3a84aa">示例二</span>

| 姓名 | 学号   | 班别   |
| ---- | ------ | ------ |
| 小琴 | 202009 | 研一   |
| 小旺 | 202509 | 大黄班 |



----

### 代码

使用代码块包含的 特殊字符 不需要转义 

#### 行内代码

<span style="color: #3a84aa">示例</span>

需要接触更多的 `code`，才能更好的进步

<span style="color: #3a84aa">编写形式</span>

```
需要接触更多的 `code`，才能更好的进步
```



#### 多行代码

<span style="color: #3a84aa">示例</span>

```javascript
function power() {
  console.log("show me your code");
}
```

<span style="color: #3a84aa">编写形式</span>

````
```javascript
function power() {
  console.log("show me your code");
}
```
````

:turtle: 首行的编程语言注释是可选的，用于高亮代码。



### HTML标签

markdown 支持少数的 HTML 标签，并可以在标签上添加 style 样式

- img
- div
- br
- ...



------

### 文本规范

#### 关于符号

- **中文与英文** 之间要加上空格
- **中文与数字** 之间要加上空格
- **数字与单位** 之间要加上空格
- 中文之间的标点符号使用全角；英文之间的标点符号则使用半角．
- 数字使用半角符号
- 全角标点与其他字符之间不加空格

#### 建议

- 加粗、斜体、高亮文本前后加空格
- 对于列表：上下级间空一行，同级不空行

#### 其他

参考站点：[基于Markdown的中文文档排版规范](https://blog.csdn.net/weixin_39787089/article/details/110478337)

------



## 收起功能及目录结构

<span style="color: #3a84aa">示例</span>

<details open="" style="box-sizing: border-box; display: block; margin-top: 0px; margin-bottom: 16px; color: rgb(36, 41, 47); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Helvetica, Arial, sans-serif, &quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-style: initial; text-decoration-color: initial;"><summary style="box-sizing: border-box; display: list-item; cursor: pointer;">展开/收起</summary><br style="box-sizing: border-box;"><div class="highlight highlight-source-shell position-relative overflow-auto" style="box-sizing: border-box; position: relative !important; overflow: auto !important; margin-bottom: 16px;"><pre style="box-sizing: border-box; font-family: ui-monospace, SFMono-Regular, &quot;SF Mono&quot;, Menlo, Consolas, &quot;Liberation Mono&quot;, monospace; font-size: 13.6px; margin-top: 0px; margin-bottom: 0px; overflow-wrap: normal; padding: 16px; overflow: auto; line-height: 1.45; background-color: var(--color-canvas-subtle); border-radius: 6px; word-break: normal;">     ┌── frontend            前端代码
     ├── nginx               nginx的配置
     ├── node                后端代码
     ├── ssl                 https证书
src──├── webhooks            自动化部署设置
     ├── docker-compose.yml  docker配置
     ├── Dockerfile-next     前端next容器
     ├── Dockerfile-node     后端node容器
     ├── volumes             使用docker后的数据存放，里面会自动同步后端的日志，数据库数据，上传图片等
     └── html                一般未使用，如果使用next静态导出export后，可以放于此处</pre></div></details>


<span style="color: #3a84aa">编写形式</span>


```
## 标题  

<details open=“open”>
  <summary>展开/收起</summary> 
  <br/>

模块内容
</details> 
```



# 补充的话

在[仓库](https://github.com/SpringLoach/power)，还提供了许多<span style="color: #3a84aa">前端常见需求</span>及实现的归纳整理，欢迎客官看看~

如果这篇笔记能够帮助到你，请帮忙在 [github](https://github.com/SpringLoach/power) 上点亮 `star`，感谢！

