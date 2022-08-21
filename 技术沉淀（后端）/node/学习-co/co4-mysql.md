## 常见的数据库

<span style="color: #f7534f;font-weight:600">关系型数据库</span> MySQL、Oracle、SQL Server

- 关系型数据库通常我们会创建很多个二维数据表； 

- 数据表之间相互关联起来，形成一对一、一对多、多对对等关系； 

- 之后可以利用SQL语句在多张表中查询我们所需的数据； 

- 支持事务，对数据的访问更加的安全。

<span style="color: #f7534f;font-weight:600">非关系型数据库</span> MongoDB

- 相对来说简单，存储数据也会更加自由（可以直接将复杂的json对象直接塞入到数据库中）；

- 基于Key-Value的对应关系，并且查询的过程中不需要经过SQL解析，所以性能更高；

- 通常不支持事务，需要在自己的程序中来保证一些原子性的操作。



### 认识MySQL

可以将 MySQL 看作一个软件（程序），用于管理多个数据库。每个数据库中可以有多张表，每个表可以有多条数据。

![image-20220701105701182](.\img\MySQL)



### 安装MySQL

打开[官网](https://www.mysql.com/)

![image-20220701140218376](.\img\mysql1)



![image-20220701142224741](D:\笔记\技术沉淀（后端）\node\img\mysql2)



![image-20220701142259908](D:\笔记\技术沉淀（后端）\node\img\mysql3)



![image-20220701140454768](D:\笔记\技术沉淀（后端）\node\img\mysql4)



![image-20220701142957635](D:\笔记\技术沉淀（后端）\node\img\mysql5)



![image-20220701143113039](D:\笔记\技术沉淀（后端）\node\img\mysql6)



![image-20220701143155127](D:\笔记\技术沉淀（后端）\node\img\mysql7)

![image-20220701143212681](D:\笔记\技术沉淀（后端）\node\img\mysql8)

![image-20220701143449451](D:\笔记\技术沉淀（后端）\node\img\mysql9)

![image-20220701143607776](D:\笔记\技术沉淀（后端）\node\img\mysql10)

![image-20220701143726908](D:\笔记\技术沉淀（后端）\node\img\mysql11)

![image-20220701143756492](D:\笔记\技术沉淀（后端）\node\img\mysql12)

![image-20220701144000281](C:\Users\86186\AppData\Roaming\Typora\typora-user-images\image-20220701144000281.png)

等待完成后点击下一步

![image-20220701144040184](D:\笔记\技术沉淀（后端）\node\img\mysql13)

步骤完成后，可以在菜单搜索服务，找到对应的程序，确认是否开启了服务。

![image-20220701144244625](D:\笔记\技术沉淀（后端）\node\img\mysql14)



### 连接MySQL

#### 配置环境变量

> 将安装目录下的 `bin` 文件夹添加到环境变量，默认的安装路径如下。

![image-20220701153559821](D:\笔记\技术沉淀（后端）\node\img\连接mysql)

**验证**

```elm
mysql --version	
```



#### 部分命令

| 操作                   | 命令                  | 说明             |
| ---------------------- | --------------------- | ---------------- |
| 登录程序               | mysql -uroot -pmima   | mima：实际密码   |
| 查看所有数据库         | show databases;       |                  |
| 创建数据库             | create database name; | name：数据库名称 |
| 查看所在数据库         | select database();    |                  |
| 切换到某个数据库       | use name;             | name：数据库名称 |
| 查看数据库的所有表     | show tables;          |                  |
| 创建表并指定表的字段   |                       |                  |
| 查看某个表中的所有数据 | select * from name;   | name：表名       |
| 往表中加数据           |                       |                  |

:whale: 这里为了容易读懂，暂时都用小写（也有效）。



**在当前数据库中创建表并指定表的字段**

```sql
create table table_name(
  -> nick varchar(10),
  -> age int,
  -> height double);
```

:trident: table_name 为表名；

:turtle: 用分号结尾，并敲下回车，表示语句结束。



**往表中加数据**

```sql
insert into table_name  (nick, age, height) values ('demo', 18, 1.88);
```

:turtle: 第一个括号中的内容表示给表的哪些属性赋值。



#### 默认的数据库

<span style="color: #f7534f;font-weight:600"> infomation_schema</span> 信息数据库，其中包括MySQL在维护的其他数据库、表、 列、访问权限等信息； 

<span style="color: #f7534f;font-weight:600">performance_schema</span> 性能数据库，记录着程序运行中的一些<span style="color: #ff0000">资源消耗</span>相关的信息； 

<span style="color: #f7534f;font-weight:600">mysql</span> 用于存储数据库管理者的用户信息、权限信息以及一些日志信息等； 

<span style="color: #f7534f;font-weight:600">sys</span> 简易版的 <span style="color: #ed5a65">performance_schema</span>，将性能数据库中的数据汇总成更容易理解的形式。



### 使用Navicat

> 一个图形化操作数据库的工具，收费很贵，可以走[捷径](https://www.bilibili.com/read/cv15128680)下载。

![image-20220701171106455](D:\笔记\技术沉淀（后端）\node\img\Navicat)





![image-20220701171202675](D:\笔记\技术沉淀（后端）\node\img\Navicat打开链接)

#### 手动编辑数据

![image-20220701171301745](D:\笔记\技术沉淀（后端）\node\img\Navicat修改数据)

#### 编写SQL语句

![image-20220701171417545](D:\笔记\技术沉淀（后端）\node\img\Navicat写SQL1)



![image-20220701171434586](D:\笔记\技术沉淀（后端）\node\img\Navicat写SQL2)





#### 保存查询结果

![image-20220701175027311](D:\笔记\技术沉淀（后端）\node\img\Navicat保存sql)

:whale: 也可以打开外部查询，使用其它文件中的语句。



#### 修改字符集

![image-20220701175406654](D:\笔记\技术沉淀（后端）\node\img\Navicat字符集)

:turtle: utf8mb4 可以支持 emoji 表情，这是 utf8 做不到的。



#### 刷新获取执行结果

执行 SQL 语句后，可能会出现没更新的情况，可以在左侧列表手动刷新。



#### 编辑表结构

选中表，右键 -> 设计表。

:turtle: 在键列出现🔑的为主键。



## MYSQL语句

#### 操作数据库

```sql
# 查看所有的数据库
SHOW DATABASES;

# 选择某一个数据库
USE bili;

### 创建新的数据库
# 创建数据库（不够严谨，可能在执行时报错）
CREATE DATABASE douyu;
# 创建数据库（常规）
CREATE DATABASE IF NOT EXISTS douyu;
# 创建数据库（并设置字符集和排序方式）
CREATE DATABASE IF NOT EXISTS huya DEFAULT CHARACTER SET utf8mb4
 				COLLATE utf8mb4_0900_ai_ci;

# 删除数据库
DROP DATABASE IF EXISTS douyu;

# 查看当前正在使用的数据库
SELECT DATABASE();

# 修改数据库的编码
ALTER DATABASE huya CHARACTER SET = utf8 
				COLLATE = utf8_unicode_ci;
```



#### 操作数据表

```sql
# 查看所有的表
SHOW TABLES;

# 新建表
CREATE TABLE IF NOT EXISTS `students` (
	`name` VARCHAR(10) NOT NULL,
	`age` int,
	`score` int,
	`height` DECIMAL(10,2),
	`birthday` YEAR,
	`phoneNum` VARCHAR(20) UNIQUE
);
# 完整的创建表的语法（这里用id作为主键且自增）
CREATE TABLE IF NOT EXISTS `users`(
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(20) NOT NULL,
	age INT DEFAULT 0,
	phoneNum VARCHAR(20) UNIQUE DEFAULT '',
	createTime TIMESTAMP
);

# 删除表
DROP TABLE IF EXISTS `moment`;

# 查看表的结构
DESC students;
# 查看创建表用到的SQL语句
SHOW CREATE TABLE `students`;


# 修改表
# 1.修改表的名字
ALTER TABLE `users` RENAME TO `user`;
# 2.添加一个字段
ALTER TABLE `user` ADD `updateTime` TIMESTAMP;
# 3.修改字段的名称
ALTER TABLE `user` CHANGE `phoneNum` `telPhone` VARCHAR(20);
# 4.修改字段的类型
ALTER TABLE `user` MODIFY `name` VARCHAR(30);
# 5.删除某一个字段
ALTER TABLE `user` DROP `age`;

# 补充
# 根据一个表结构去创建另外一张表（包含主键等）
CREATE TABLE `user2` LIKE `user`;
# 根据另外一个表中的所有内容，创建一个新的表（不包含主键）
CREATE TABLE `user3` (SELECT * FROM `user`); 
```

:ghost: 如果遇到<span style="color: #ff0000">关键字</span>作为表名或者字段名称，可以使用 `` 包裹该名称。



#### 记录-增删改

```sql
# 插入数据（不指定字段添加）
INSERT INTO `user` VALUES (110, 'why', '020-110110', '2020-10-20', '2020-11-11');

# 插入数据（指定字段添加）
INSERT INTO `user` (name, telPhone, createTime, updateTime)
						VALUES ('kobe', '000-1111111', '2020-10-10', '2030-10-20');
						
# 插入数据（存在默认值的字段可以不设置）
INSERT INTO `user` (name, telPhone)
						VALUES ('lilei', '000-1111112');

# 需求：createTime和updateTime的默认值为当前时间，且在修改记录时更新updateTime字段
ALTER TABLE `user` MODIFY `createTime` TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `user` MODIFY `updateTime` TIMESTAMP DEFAULT CURRENT_TIMESTAMP                                                              ON UPDATE CURRENT_TIMESTAMP;

INSERT INTO `user` (name, telPhone)
						VALUES ('lucy', '000-1121212');


# 删除数据
# 删除所有的记录
DELETE FROM `user`;
# 删除符合条件的记录
DELETE FROM `user` WHERE id = 110;

# 更新数据
# 更新所有的记录
UPDATE `user` SET name = 'lily', telPhone = '010-110110';
# 更新符合条件的记录
UPDATE `user` SET name = 'lily', telPhone = '010-110110' WHERE id = 115;
```



#### 记录-查

```sql
# 创建products的表
CREATE TABLE IF NOT EXISTS `products` (
	id INT PRIMARY KEY AUTO_INCREMENT,
	brand VARCHAR(20),
	title VARCHAR(100) NOT NULL,
	price DOUBLE NOT NULL,
	score DECIMAL(2,1),
	voteCnt INT,
	url VARCHAR(100),
	pid INT
);

# 1.基本查询
# 查询表中所有的字段以及所有的数据
SELECT * FROM `products`;
# 查询指定的字段
SELECT title, price FROM `products`;
# 对字段结果起别名
SELECT title as phoneTitle, price as currentPrice FROM `products`;


# 2.where条件
# 2.1. 条件判断语句
# 案例：查询价格小于1000的手机
SELECT title, price FROM `products` WHERE price < 1000;
# 案例二：价格等于999的手机
SELECT * FROM `products` WHERE price = 999;
# 案例三：价格不等于999的手机
SELECT * FROM `products` WHERE price != 999;
SELECT * FROM `products` WHERE price <> 999;

# 2.2. 逻辑运算语句
# 案例一：查询1000到2000之间的手机
SELECT * FROM `products` WHERE price > 1000 AND price < 2000;
SELECT * FROM `products` WHERE price > 1000 && price < 2000;
# BETWEEN AND 包含等于
SELECT * FROM `products` WHERE price BETWEEN 1099 AND 2000;

# 案例二：价格在5000以上或者是品牌是华为的手机
SELECT * FROM `products` WHERE price > 5000 || brand = '华为';

# 查询字段为NULL
SELECT * FROM `products` WHERE url IS NULL;
# 查询字段不为NULL
SELECT * FROM `products` WHERE url IS NOT NULL;

# 2.3.模糊查询
# 包含M
SELECT * FROM `products` WHERE title LIKE '%M%';
# 第二个字符为M
SELECT * FROM `products` WHERE title LIKE '_M%';


# 3.字段符合多个条件之一
SELECT * FROM `products` WHERE brand = '华为' || brand = '小米' || brand = '苹果';
SELECT * FROM `products` WHERE brand IN ('华为', '小米', '苹果') 

# 4.对结果进行排序
# 按价格升序，相同价格的记录按评分降序
SELECT * FROM `products` WHERE brand IN ('华为', '小米', '苹果') 
												 ORDER BY price ASC, score DESC;

# 5.分页查询
# LIMIT limit OFFSET offset;
SELECT * FROM `products` LIMIT 20 OFFSET 0;
SELECT * FROM `products` LIMIT 20 OFFSET 20;
# Limit offset, limit;
SELECT * FROM `products` LIMIT 40, 20;
```

:point_down: 可以通过下面一节的方式来将准备好的数据嵌入到表格中。



#### 辅助-添加记录

引入准备好的 `json` 文件后，用 node 执行下面代码即可向对应表插入数据。

```elm
npm install mysql2
```

```javascript
const mysql = require('mysql2');
 
const connection = mysql.createConnection({
  host: 'localhost',
  port: 3306,
  user: 'root',
  password: 'xxxx',
  database: 'xxxx'
});

const statement = `INSERT INTO products SET ?;`
const phoneJson = require('./phone.json');

for (let phone of phoneJson) {
  connection.query(statement, phone);
}
```



#### 聚合函数

```sql
# 1.聚合函数的使用
# 求所有手机的价格的总和
SELECT SUM(price) FROM `products`;
# 求所有手机的价格的总和，输出别名
SELECT SUM(price) AS totalPrice FROM `products`;
SELECT SUM(price) totalPrice FROM `products`;
# 求一下华为手机的价格的总和
SELECT SUM(price) FROM `products` WHERE brand = '华为';
# 求华为手机的平均价格
SELECT AVG(price) FROM `products` WHERE brand = '华为';
# 最高手机的价格和最低手机的价格
SELECT MAX(price) FROM `products`;
SELECT MIN(price) FROM `products`;

# 求苹果手机的记录条数
SELECT COUNT(*) FROM `products` WHERE brand = '苹果';
# 求url字段不为NULL的，苹果手机的记录条数
SELECT COUNT(url) FROM `products` WHERE brand = '苹果';

# 求价格去重后的记录条数
SELECT COUNT(DISTINCT price) FROM `products`;
```

#### 聚合函数-分组

```sql
# 2.GROUP BY的使用
# 按照品牌分组，获取品牌名、平均价格、条数、平均分数
SELECT brand, AVG(price), COUNT(*), AVG(score) FROM `products` GROUP BY brand;

# 3.HAVING的使用
# 按照品牌分组，获取品牌名、平均价格、条数、平均分数，并且只要平均价格在2000以上的
SELECT brand, AVG(price) avgPrice, COUNT(*), AVG(score) FROM `products` GROUP BY brand HAVING avgPrice > 2000;

# 4.区别于WHERE
# 筛选平均分大于7.5的手机，按照品牌分组，获取品牌名、平均价格
SELECT brand, AVG(price) FROM `products` WHERE score > 7.5 GROUP BY brand;
```

:ghost: 查询语句加上分组条件后，可以拼接分组字段，但其它的字段如果存在多个不同的值就不能拼上去了。

:ghost: `WHERE` 语句只能应用在 `GROUP BY` 前面，要想对分组结果继续筛选，要用 `HAVING` 字段；

:question: `WHERE` 语句后似乎不能跟聚合函数，也不能跟对其起的别名。



### 多表

#### 多表的设计和约束

> 当表中的某个字段有较多的关联信息时（如品牌，可以有品牌名称，网站，排名等等），再将这些信息添加到同一个表中，会导致表臃肿而又冗余，这时可以新建一个表来存储相关的信息。

```sql
# 1.创建brand的表和插入数据
CREATE TABLE IF NOT EXISTS `brand`(
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(20) NOT NULL,
	website VARCHAR(100),
	phoneRank INT
);
# 自行加一些数据
INSERT INTO `brand` (name, website, phoneRank) VALUES ('华为', 'www.huawei.com', 2);

# 2. 给表1添加字段，引用表brand中的id作为外键约束
# 添加一个brand_id字段
ALTER TABLE `products` ADD `brand_id` INT;
# 修改brand_id为外键
ALTER TABLE `products` ADD FOREIGN KEY(brand_id) REFERENCES brand(id);

# 设置brand_id的值
UPDATE `products` SET `brand_id` = 1 WHERE `brand` = '华为';
```

:turtle: 也可以在建表时，就指定外键。

:ghost: 字段一旦被外键约束，它的值就只能设置为 NULL 或另一表中外键已存在的值。



#### 修改外键

```sql
# 1.默认情况下，如果直接修改和删除外键引用的id，会报错
UPDATE `brand` SET `id` = 100 WHERE `id` = 1;


# 2.修改brand_id关联外键时的action
# 2.1.获取到目前的外键的名称
SHOW CREATE TABLE `products`;

-- CREATE TABLE `products` (
--   ...
--   `brand_id` int DEFAULT NULL,
--   PRIMARY KEY (`id`),
--   KEY `brand_id` (`brand_id`),
--   CONSTRAINT `products_ibfk_1` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`id`)
-- ) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

# 2.2.根据名称将外键删除掉
ALTER TABLE `products` DROP FOREIGN KEY products_ibfk_1;

# 2.2.重新添加外键约束
ALTER TABLE `products` ADD FOREIGN KEY (brand_id) REFERENCES brand(id)
							ON UPDATE CASCADE
							ON DELETE RESTRICT;

# 2.3.再次修改外键引用的id，成功~
UPDATE `brand` SET `id` = 100 WHERE `id` = 1;
```

| 更新/删除外键    | 配置值                                                       |
| ---------------- | ------------------------------------------------------------ |
| RESTRICT（默认） | 会检查该记录是否有关联的外键记录，有的话不允许更新或删除     |
| NO ACTION        | 同上，在SQL标准中定义                                        |
| CASCADE          | 会检查该记录是否有关联的外键记录，更新-更新记录、删除-删除关联记录 |
| SET NULL         | 会检查该记录是否有关联的外键记录，将对应的值设为 NULL        |

:octopus: 删除时设置为 CASCADE，会导致记录也删除，慎用。





#### 多表查询

```sql
# 1.获取到的是笛卡尔乘积(x*y)
SELECT * FROM `products`, `brand`;
# 将结果进行筛选
SELECT * FROM `products`, `brand` WHERE products.brand_id = brand.id;
```

:turtle: 相当于将表A的记录于表B的记录一一合并后，再进行筛选；

:turtle: 开发时不会这么操作，性能方面没那么好。可以用<span style="color: #a50">内连接</span>替代，查询出来的结果相同。

```sql
# 2.左连接
# 2.1. 查询所有的手机（包括没有品牌信息的手机）以及对应的品牌 null
SELECT * FROM `products` LEFT JOIN `brand` ON products.brand_id = brand.id;
SELECT * FROM `products` LEFT OUTER JOIN `brand` ON products.brand_id = brand.id;

# 2.2. 查询没有对应品牌数据的手机
SELECT * FROM `products` LEFT JOIN `brand` ON products.brand_id = brand.id WHERE brand.id IS NULL;


# 3.右连接
# 3.1. 查询所有的品牌（没有对应的手机数据，品牌也显示）以及对应的手机数据；
SELECT * FROM `products` RIGHT OUTER JOIN `brand` ON products.brand_id = brand.id;

# 3.2. 查询没有对应手机的品牌信息
SELECT * FROM `products` RIGHT JOIN `brand` ON products.brand_id = brand.id WHERE products.brand_id IS NULL;


# 4.内连接
SELECT * FROM `products` JOIN `brand` ON products.brand_id = brand.id;
# 4.1 内连接后添加筛选条件
SELECT * FROM `products` JOIN `brand` ON products.brand_id = brand.id WHERE price = 8699;

# 5.全连接
# 5.1
(SELECT * FROM `products` LEFT OUTER JOIN `brand` ON products.brand_id = brand.id)
UNION
(SELECT * FROM `products` RIGHT OUTER JOIN `brand` ON products.brand_id = brand.id)

# 5.2
(SELECT * FROM `products` LEFT OUTER JOIN `brand` ON products.brand_id = brand.id WHERE brand.id IS NULL)
UNION
(SELECT * FROM `products` RIGHT OUTER JOIN `brand` ON products.brand_id = brand.id WHERE products.brand_id IS NULL)
```

:octopus: MySQL 不支持 `FULL OUTER JOIN` 来进行全连接，但可以用联合来实现该效果。

![image-20220702135925784](D:\笔记\技术沉淀（后端）\node\img\连接)



#### 多对多的关系

> 场景：如学生选课，学生可以选择多个课程，一个课程又可能对应多个学生。

准备学生表，课程表

```sql
# 1.基本数据的模拟
CREATE TABLE IF NOT EXISTS students(
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(20) NOT NULL,
	age INT
);

CREATE TABLE IF NOT EXISTS courses(
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(20) NOT NULL,
	price DOUBLE
);

INSERT INTO `students` (name, age) VALUES('why', 18);
INSERT INTO `students` (name, age) VALUES('tom', 22);
INSERT INTO `students` (name, age) VALUES('lilei', 25);
INSERT INTO `students` (name, age) VALUES('lucy', 16);
INSERT INTO `students` (name, age) VALUES('lily', 20);

INSERT INTO `courses` (name, price) VALUES ('英语', 100);
INSERT INTO `courses` (name, price) VALUES ('语文', 666);
INSERT INTO `courses` (name, price) VALUES ('数学', 888);
INSERT INTO `courses` (name, price) VALUES ('历史', 80);
INSERT INTO `courses` (name, price) VALUES ('物理', 888);
INSERT INTO `courses` (name, price) VALUES ('地理', 333);
```

建立关系表

> 设计到多对多关系时，可以添加一个中间的关系表，通过设置多个外键来约束。

```sql
# 2.建立关系表
CREATE TABLE IF NOT EXISTS `students_select_courses`(
	id INT PRIMARY KEY AUTO_INCREMENT,
	student_id INT NOT NULL,
	course_id INT NOT NULL,
	FOREIGN KEY (student_id) REFERENCES students(id) ON UPDATE CASCADE,
	FOREIGN KEY (course_id) REFERENCES courses(id) ON UPDATE CASCADE
);

# 3.学生选课
# why选择了英文、数学、历史
INSERT INTO `students_select_courses` (student_id, course_id) VALUES (1, 1);
INSERT INTO `students_select_courses` (student_id, course_id) VALUES (1, 3);
INSERT INTO `students_select_courses` (student_id, course_id) VALUES (1, 4);


INSERT INTO `students_select_courses` (student_id, course_id) VALUES (3, 2);
INSERT INTO `students_select_courses` (student_id, course_id) VALUES (3, 4);

INSERT INTO `students_select_courses` (student_id, course_id) VALUES (5, 2);
INSERT INTO `students_select_courses` (student_id, course_id) VALUES (5, 3);
INSERT INTO `students_select_courses` (student_id, course_id) VALUES (5, 4);
```

:turtle: 这种情况下使用联合主键会更加合理，这可以避免多次插入相同的数据，如插入两次why选择数学。



##### 查询案例

```sql
# 4.查询的需求
# 4.1. 查询所有有选课的学生，选择了哪些课程(在内连接的结果上，再次内连接)
SELECT stu.id id, stu.name stuName, stu.age stuAge, cs.id csId, cs.name csName, cs.price csPrice
FROM `students` stu
JOIN `students_select_courses` ssc ON stu.id = ssc.student_id
JOIN `courses` cs ON ssc.course_id = cs.id;

# 4.2. 查询所有的学生的选课情况
SELECT stu.id id, stu.name stuName, stu.age stuAge, cs.id csId, cs.name csName, cs.price csPrice
FROM `students` stu
LEFT JOIN `students_select_courses` ssc ON stu.id = ssc.student_id
LEFT JOIN `courses` cs ON ssc.course_id = cs.id;

# 4.3. 哪些学生是没有选课
SELECT stu.id id, stu.name stuName, stu.age stuAge, cs.id csId, cs.name csName, cs.price csPrice
FROM `students` stu
LEFT JOIN `students_select_courses` ssc ON stu.id = ssc.student_id
LEFT JOIN `courses` cs ON ssc.course_id = cs.id
WHERE cs.id IS NULL;

# 4.4. 查询哪些课程是没有被选择的
SELECT stu.id id, stu.name stuName, stu.age stuAge, cs.id csId, cs.name csName, cs.price csPrice
FROM `students` stu
RIGHT JOIN `students_select_courses` ssc ON stu.id = ssc.student_id
RIGHT JOIN `courses` cs ON ssc.course_id = cs.id
WHERE stu.id IS NULL;;

# 4.5. 查询某一个学生的选课情况
SELECT stu.id id, stu.name stuName, stu.age stuAge, cs.id csId, cs.name csName, cs.price csPrice
FROM `students` stu
LEFT JOIN `students_select_courses` ssc ON stu.id = ssc.student_id
LEFT JOIN `courses` cs ON ssc.course_id = cs.id
WHERE stu.id = 2;
```

:turtle: 别名语法中间的 `AS` 在大部分情况都可以省略；

:turtle: 使用 `WHERE` 条件筛选时，条件内容不能包含别名。



#### 对象和数组类型

```sql
# 将联合查询到的数据转成对象（适合于一对多）
SELECT 
	products.id id, products.title title, products.price price,
	JSON_OBJECT('id', brand.id, 'name', brand.name, 'website', brand.website) brand
FROM `products`
LEFT JOIN `brand` ON products.brand_id = brand.id;

# 将查询到的多条数据，组织成对象，放入到一个数组中(适合于多对多)
SELECT 
	stu.id, stu.name, stu.age,
	JSON_ARRAYAGG(JSON_OBJECT('id', cs.id, 'name', cs.name, 'price', cs.price)) courses
FROM `students` stu
JOIN `students_select_courses` ssc ON stu.id = ssc.student_id
JOIN `courses` cs ON ssc.course_id = cs.id
GROUP BY stu.id;
```

:ghost:  `JSON_OBJECT` 接收参数的形式：键、值、键、值...

:ghost: 第二个例子，用于将同一分组下，所有的记录合并为一条，同一记录下的指定字段合并到对象中，最终组成对象数组。

![image-20220702164556623](D:\笔记\技术沉淀（后端）\node\img\数组类型)





## Node中使用MYSQL

```elm
npm intall mysql2
```

> mysql2：在mysql的基础之上，进行了很多的优化、改进；

- 更高的性能
- 预编译语句
  - 将语句模块发送给MySQL，让它编译（解析、优化、转换）语句模块，<span style="color: #ff0000">再次执行</span>语句时就不用编译；
  - 防止SQL注入。如插入 `or 1 = 1`  来得到需要正确账号密码才能进行的查询；
  - 支持 promise



### mysql2-基本使用

#### 普通语法

```javascript
const mysql = require('mysql2');

// 1.创建数据库连接
const connection = mysql.createConnection({
  host: 'localhost',
  port: 3306,
  database: 'xxx',
  user: 'root',
  password: 'xxx'
});

// 2.执行SQL语句
const statement = `
  SELECT * FROM products WHERE price > 6000;
`

connection.query(statement, (err, results, fields) => {
  console.log(results);
  connection.end() // 可以关闭对数据库的连接
})
```

<span style="color: #f7534f;font-weight:600">connection.query</span> 接收三个参数：错误对象、结果、字段名



#### 编译语法

```javascript
// 2.执行SQL语句
const statement = `
  SELECT * FROM products WHERE price > ? AND score > ?;
`

connection.execute(statement, [6000, 7], (err, results, fields) => {
  console.log(results);
})
```

:ghost: <span style="color: #a50">execute</span> 相当于在内部同时执行了 prepare 和 query 方法。

 

#### 期约形式

```javascript
// 2.执行SQL语句
const statement = `
  SELECT * FROM products WHERE price > ? AND score > ?;
`

connection.promise.execute(statement, [6000, 7]).then([result, fields]) => {
  console.log(result);
})
```



#### 连接池

> 前面我们是创建了一个连接（connection），但是如果我们有多个请求的话，该连接很有可能正在被占用。
>
> 连接池可以在需要的时候自动创建连接，并且创建的连接<span style="color: #ff0000">不会被销毁</span>，会放到连接池中，<span style="color: #ff0000">后续可以继续使用</span>

```javascript
const mysql = require('mysql2');

// 1.创建数据库连接
const connections = mysql.createPool({
  host: 'localhost',
  port: 3306,
  database: 'xxx',
  user: 'root',
  password: 'xxx',
  connectionLimit: 10 // 最多建立的连接数量
});

// 2.使用连接池
const statement = `
  SELECT * FROM products WHERE price > ? AND score > ?;
`

connections.execute(statement, [6000, 7], (err, results, fields) => {
  console.log(result);
})
```

:turtle: 连接池可以直接像连接一样直接使用，它会找到空闲的连接，继续接下来的操作。



### ORM

![](D:\笔记\技术沉淀（后端）\node\img\orm)



### sequelize-基本使用

```elm
npm install mysql2 sequelize
```

>  sequelize 的使用于依赖 mysql2

```javascript
const { Sequelize } = require('sequelize');

const sequelize = new Sequelize('kuming', 'root', 'mima', {
  host: 'localhost',
  dialect: 'mysql'
})

sequelize.authenticate().then(() => {
  console.log("连接数据库成功");
}).catch(err => {
  console.log("连接数据库失败", err)
})
```

> `kuming` 对应数据库的名称，`mima` 对应相应的密码。 



#### 单表操作

```javascript
const { Sequelize, DataTypes, Model, Op } = require('sequelize');

const sequelize = new Sequelize("xxx", 'root', 'xxx', {
  host: 'localhost',
  dialect: 'mysql'
})

// 创建一个类，用于映射到一个表上
class Product extends Model {}
// 根据表的字段配置，初始化这个类
Product.init({
  id: {
    type: DataTypes.INTEGER, // 对应字段类型
    primaryKey: true,
    autoIncrement: true
  },
  title: {
    type: DataTypes.STRING,
    allowNotNull: false
  },
  price: DataTypes.DOUBLE,
  score: DataTypes.DOUBLE
}, {
  tableName: 'products', // 对应的表名
  createdAt: false, // 默认表中会有一个 createdAt，如果没有，需要这样配置
  updatedAt: false, // 默认表中会有一个 updatedAt，如果没有，需要这样配置
  sequelize
});


async function queryProducts() {
  // 0.查询所有记录
  const result = await Product.findAll();
    
  // 1.查询价格大于5000的记录
  const result1 = await Product.findAll({
    where: {
      price: {
        [Op.gte]: 5000
      }
    }
  });

  // 2.插入数据
  const result2 = await Product.create({
    title: "三星Nova",
    price: 8888,
    score: 5.5
  });

  // 3.更新数据
  const result3 = await Product.update({
    price: 3688
  }, {
    where: {
      id: 1
    }
  });
}

queryProducts(); // 执行方法
```



#### 一对多操作

```javascript
const { Sequelize, DataTypes, Model, Op } = require('sequelize');

const sequelize = new Sequelize("xxx", 'root', 'xxx', {
  host: 'localhost',
  dialect: 'mysql'
});

class Brand extends Model {};
Brand.init({
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  name: {
    type: DataTypes.STRING,
    allowNotNull: false
  },
  website: DataTypes.STRING,
  phoneRank: DataTypes.INTEGER
}, {
  tableName: 'brand',
  createdAt: false,
  updatedAt: false,
  sequelize
});

class Product extends Model {}
Product.init({
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  title: {
    type: DataTypes.STRING,
    allowNotNull: false
  },
  price: DataTypes.DOUBLE,
  score: DataTypes.DOUBLE,
  brandId: {
    field: 'brand_id', // 映射表的该字段
    type: DataTypes.INTEGER,
    references: {
      model: Brand, // 关联的表
      key: 'id'
    }
  }
}, {
  tableName: 'products',
  createdAt: false,
  updatedAt: false,
  sequelize
});

// 将两张表联系在一起（主从关系）
Product.belongsTo(Brand, {
  foreignKey: 'brandId'
});

async function queryProducts() {
  // 获取所有记录，同时包含从表的信息（联合）
  const result = await Product.findAll({
    include: {
      model: Brand
    }
  });
  console.log(result);
}

queryProducts();
```



#### 多对多操作

```javascript
const { Sequelize, DataTypes, Model, Op } = require('sequelize');

const sequelize = new Sequelize("xxx", 'root', 'xxx', {
  host: 'localhost',
  dialect: 'mysql'
});

// Student
class Student extends Model {}
Student.init({
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  name: {
    type: DataTypes.STRING,
    allowNotNull: false
  },
  age: DataTypes.INTEGER
}, {
  tableName: 'students',
  createdAt: false,
  updatedAt: false,
  sequelize
});

// Course
class Course extends Model {}
Course.init({
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  name: {
    type: DataTypes.STRING,
    allowNotNull: false
  },
  price: DataTypes.DOUBLE
}, {
  tableName: 'courses',
  createdAt: false,
  updatedAt: false,
  sequelize
});

// StudentCourse
class StudentCourse extends Model {}
StudentCourse.init({
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  studentId: {
    type: DataTypes.INTEGER,
    references: {
      model: Student,
      key: 'id'
    },
    field: 'student_id'
  },
  courseId: {
    type: DataTypes.INTEGER,
    references: {
      model: Course,
      key: 'id'
    },
    field: 'course_id'
  }
}, {
  tableName: 'students_select_courses',
  createdAt: false,
  updatedAt: false,
  sequelize
});

/* 多对多关系的联系 */
Student.belongsToMany(Course, {
  through: StudentCourse, // 关联表
  foreignKey: 'studentId',
  otherKey: 'courseId'
});

Course.belongsToMany(Student, {
  through: StudentCourse, // 关联表
  foreignKey: 'courseId',
  otherKey: 'studentId'
});

async function queryProducts() {
  const result = await Student.findAll({
    include: {
      model: Course
    }
  });
  console.log(result);
}

queryProducts();
```



## MYSQL

### MYSQL语句的常用规范 

- 通常关键字是大写的，如CREATE、TABLE； 

- 语句以 `;` 结尾； 

- 如果遇到关键字作为表名或者字段名称，可以使用 `` 包裹;



### MYSQL常用数据类型

| 数字类型 | 字段            | 说明                                        |
| -------- | ------------- | ----------------------------------------- |
| 整数     | TINYINT，SMALLINT，MEDIUMINT，<span style="color: #ff0000">INT</span>，BIGINT |  |
| 浮点数   | FLOAT，DOUBLE | 4字节，8字节                              |
| 精确数   | DECIMAL，NUMERIC | DECIMAL更常用 |

| 日期类型            | 字段                                          | 说明                                       |
| ------------------- | --------------------------------------------- | ------------------------------------------ |
| YYYY                | YEAR                                          |                                            |
| YYYY-MM-DD          | DATE                                          |                                            |
| YYYY-MM-DD hh:mm:ss | DATETIME                                      | 1000-01-01 00:00:00 到 9999-12-31 23:59:59 |
| YYYY-MM-DD hh:mm:ss | <span style="color: #ff0000">TIMESTAMP</span> | 1970-01-01 00:00:01 到 2038-01-19 03:14:07 |

:whale: DATETIME 或 TIMESTAMP 值也可以包括微秒（6位）精度。

| 字符串类型                  | 字段                                        | 说明                           |
| --------------------------- | ------------------------------------------- | ------------------------------ |
| 固定长度（0-255）           | CHAR                                        | 在被查询时，会删除后面的空格   |
| 可变长度的字符串（0-65535） | <span style="color: #ff0000">VARCHAR</span> | 在被查询时，不会删除后面的空格 |
| 存储大的字符串类型          | TEXT                                        |                                |
| 存储二进制字符串            | BINARY，VARBINARY                           | 少用，一般存储在文件系统       |
| 存储大的二进制类型          | BLOB                                        | 少用，一般存储在文件系统       |



### MYSQL表约束

| 说明     | 关键字         | 说明                                 |
| -------- | -------------- | ------------------------------------ |
| 主键     | PRIMARY KEY    | 用于表示记录的唯一性，不重复且不为空 |
| 唯一     | UNIQUE         | 不会重复，但允许为多个NULL           |
| 非空     | NOT NULL       |                                      |
| 默认值   | DEFAULT        |                                      |
| 自动递增 | AUTO_INCREMENT |                                      |

:turtle: 主键也可以是多列索引，即联合主键；

:turtle: 可以同时设置 `UNIQUE` 和 `NOT NULL`，表示值必须设置且不能重复。



### MYSQL查询格式

```sql
SELECT select_expr [, select_expr]...  // 查询字段
    [FROM table_references]            // 从哪个表
    [WHERE where_condition]            // 条件
    [ORDER BY expr [ASC | DESC]]       // 升序或降序
    [LIMIT {[offset,] row_count | row_count OFFSET offset}]  // 偏移量及数量
    [GROUP BY expr]
    [HAVING where_condition]
```





















