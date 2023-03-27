### 安装使用

格式化工具，对前端的[大部分](https://www.prettier.cn/docs/index.html)语言生效

<span style="color: #3a84aa">一、安装依赖</span>

```elm
npm install prettier -S -D
```

<span style="color: #3a84aa">二、生成配置文件</span>

```elm
echo {}> .prettierrc.json
```

:octopus: 如果使用 window，需手动创建一下这个文件；默认生成的 `utf-16` 格式是有问题的。

```javascript
{}
```

<span style="color: #3a84aa">三、配置忽略文件</span>

<span style="backGround: #efe0b9">.prettierignore</span>

```
node_modules
dist
build
```

<span style="color: #3a84aa">四、测试功能</span>

检查所有文件

```elm
npx prettier --check .
```

格式化所有文件

```elm
npx prettier --write .
```

<span style="color: #3a84aa">五、拓展</span>

如果使用 vscode，安装拓展 Prettier - Code formatter 后，在文件右键格式化文档，能够使用配置好的 prettier 规则格式化当前文档。



### 案例一

```json
{
  // 不使用缩进符，而使用空格
  "useTabs": false,
  // 使用 2 个空格缩进
  "tabWidth": 2,
  // 一行最多 80 字符
  "printWidth": 80,
  // 使用单引号
  "singleQuote": true,
  // 末尾不需要逗号(对象)，如果需要改成 "all"
  "trailingComma": "none",
  // 行尾不需要有分号
  "semi": false
}
```

### 案例二

```json
{
  // 一行最多 200 字符
  "printWidth": 200,
  // 使用 2 个空格缩进
  "tabWidth": 2,
  // 行尾不需要有分号
  "semi": false,
  // 使用单引号
  "singleQuote": true,
  // 箭头函数，只有一个参数的时候，也需要括号
  "arrowParens": "always",
  // 换行符使用 lf
  "endOfLine": "lf",
  // 不使用缩进符，而使用空格
  "useTabs": false,
  // jsx 标签的反尖括号需要换行
  "jsxBracketSameLine": false
}
```



### 补充的话

在[仓库](https://github.com/SpringLoach/power)，还提供了许多<span style="color: #3a84aa">前端常见需求</span>及实现的归纳整理，欢迎客官看看~

如果这篇笔记能够帮助到你，请帮忙在 [github](https://github.com/SpringLoach/power) 上点亮 `star`，感谢！
