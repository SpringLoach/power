从 "Websites" 表中选取所有记录

```sql
SELECT * FROM Websites;
```

> SQL 对大小写不敏感：SELECT 与 select 是相同的。



某些数据库系统要求在每条 SQL 语句的末端使用分号。

分号是在数据库系统中分隔每条 SQL 语句的标准方法，这样就可以在对服务器的相同请求中执行一条以上的 SQL 语句。



### 重要的SQL命令

- **SELECT** - 从数据库中提取数据
- **UPDATE** - 更新数据库中的数据
- **DELETE** - 从数据库中删除数据
- **INSERT INTO** - 向数据库中插入新数据
- **CREATE DATABASE** - 创建新数据库
- **ALTER DATABASE** - 修改数据库
- **CREATE TABLE** - 创建新表
- **ALTER TABLE** - 变更（改变）数据库表
- **DROP TABLE** - 删除表
- **CREATE INDEX** - 创建索引（搜索键）
- **DROP INDEX** - 删除索引



### SELECT

> 提取数据。

从表中获取指定列

```sql
SELECT column_name,column_name
FROM table_name;
```

从表中获取所有列（即所有数据）

```sql
SELECT * FROM table_name;
```



### SELECT DISTINCT

> 提取去重值。

```sql
SELECT DISTINCT column_name,column_name
FROM table_name;
```



示例

```less
+----+--------------+---------------------------+-------+---------+
| id | name         | url                       | alexa | country |
+----+--------------+---------------------------+-------+---------+
| 1  | Google       | https://www.google.cm/    | 1     | USA     |
| 2  | 淘宝          | https://www.taobao.com/   | 13    | CN      |
| 3  | 菜鸟教程      | http://www.runoob.com/    | 4689  | CN      |
| 4  | 微博          | http://weibo.com/         | 20    | CN      |
| 5  | Facebook     | https://www.facebook.com/ | 3     | USA     |
```

```sql
SELECT DISTINCT country FROM Websites;
```

```less
+---------+
| country |
+---------+
|   USA   |
|    CN   |
```



### WHERE

> WHERE 子句用于提取那些满足指定条件的记录。

```sql
SELECT column_name,column_name
FROM table_name
WHERE column_name operator value;
```



示例

```sql
SELECT * FROM Websites WHERE country='CN';
```

![image-20220625103340387](D:/娱乐休闲/Wechat/Wechat文件管理/WeChat Files/wxid_sa4inldgv2gj22/FileStorage/File/2022-08/img2/image-20220625103340387.png)



#### 指定数值字段

> 使用单引号（大部分数据库系统也接受双引号）来环绕文本；如果是数值字段，请不要使用引号。

```sql
SELECT * FROM Websites WHERE id=1;
```

![image-20220625104935576](D:/娱乐休闲/Wechat/Wechat文件管理/WeChat Files/wxid_sa4inldgv2gj22/FileStorage/File/2022-08/img2/image-20220625104935576.png)



#### WHERE 子句中的运算符

| 运算符  | 描述                                                       |
| :------ | :--------------------------------------------------------- |
| =       | 等于                                                       |
| <>      | 不等于。**注释：**在 SQL 的一些版本中，该操作符可被写成 != |
| >       | 大于                                                       |
| <       | 小于                                                       |
| >=      | 大于等于                                                   |
| <=      | 小于等于                                                   |
| BETWEEN | 在某个范围内                                               |
| LIKE    | 搜索某种模式                                               |
| IN      | 指定针对某个列的多个可能值                                 |



#### 拓展

##### Where +条件（筛选行）

条件：列，比较运算符，值

比较运算符包涵：= > < >= ,<=, !=,<> 表示（不等于）

```
Select * from emp where ename='SMITH';
```

例子中的 SMITH 用单引号引起来，表示是字符串，字符串要区分大小写。

##### 逻辑运算

And:与 同时满足两个条件的值。

```
Select * from emp where sal > 2000 and sal < 3000;
```

查询 EMP 表中 SAL 列中大于 2000 小于 3000 的值。

Or:或 满足其中一个条件的值

```
Select * from emp where sal > 2000 or comm > 500;
```

查询 emp 表中 SAL 大于 2000 或 COMM 大于500的值。

Not:非 满足不包含该条件的值。

```
select * from emp where not sal > 1500;
```

查询EMP表中 sal 小于等于 1500 的值。

逻辑运算的优先级：

```
()    not        and         or
```

##### 特殊条件

**1.空值判断： is null**

```
Select * from emp where comm is null;
```

查询 emp 表中 comm 列中的空值。

**2.between and (在 之间的值)**

```
Select * from emp where sal between 1500 and 3000;
```

查询 emp 表中 SAL 列中大于 1500 的小于 3000 的值。

注意：大于等于 1500 且小于等于 3000， 1500 为下限，3000 为上限，下限在前，上限在后，查询的范围包涵有上下限的值。

**3.In**

```
Select * from emp where sal in (5000,3000,1500);
```

查询 EMP 表 SAL 列中等于 5000，3000，1500 的值。

**4.like**

Like模糊查询

```
Select * from emp where ename like 'M%';
```

查询 EMP 表中 Ename 列中有 M 的值，M 为要查询内容中的模糊信息。

-  **%** 表示多个字值，**_** 下划线表示一个字符；
-  **M%** : 为能配符，正则表达式，表示的意思为模糊查询信息为 M 开头的。
-  **%M%** : 表示查询包含M的所有内容。
-  **%M_** : 表示查询以M在倒数第二位的所有内容。

##### 不带比较运算符的子句

WHERE 子句并不一定带比较运算符，当不带运算符时，会执行一个隐式转换。当 0 时转化为 false，1 转化为 true。例如：

```
SELECT studentNO FROM student WHERE 0
```

则会返回一个空集，因为每一行记录 WHERE 都返回 false。

```
SELECT  studentNO  FROM student WHERE 1
```

返回 student 表所有行中 studentNO 列的值。因为每一行记录 WHERE 都返回 true。





### AND & OR 

AND 运算符：如果第一个条件和第二个条件都成立，则显示该记录。

OR 运算符：如果第一个条件和第二个条件中任一成立，则显示该记录。



示例

从 "Websites" 表中选取国家为 "CN" 且alexa排名大于 "50" 的所有网站：

```sql
SELECT * FROM Websites
WHERE country='CN'
AND alexa > 50;
```



从 "Websites" 表中选取国家为 "USA" 或者 "CN" 的所有客户：

```sql
SELECT * FROM Websites
WHERE country='USA'
OR country='CN';
```



从 "Websites" 表中选取 alexa 排名大于 "15" 且国家为 "CN" 或 "USA" 的所有网站：

```sql
SELECT * FROM Websites
WHERE alexa > 15
AND (country='CN' OR country='USA');
```



### ORDER BY

ORDER BY 关键字用于对结果集按照一个列或者多个列进行排序（默认升序）

```sql
SELECT column_name,column_name
FROM table_name
ORDER BY column_name,column_name ASC|DESC;
```



#### 升序

```sql
SELECT * FROM Websites
ORDER BY alexa;
```



#### 降序

```sql
SELECT * FROM Websites
ORDER BY alexa DESC;
```



#### 根据多列

> 先根据 country 排序，对于 country  相同的值，再根据 alexa 排序。

```sql
SELECT * FROM Websites
ORDER BY country,alexa;
```





### INSERT INTO

> INSERT INTO 语句用于向表中插入新记录。

形式一无需指定要插入数据的列名，只需提供被插入的值即可：

```sql
INSERT INTO table_name
VALUES (value1,value2,value3,...);
```

> 需要列出插入行的每一列数据。

形式二需要指定列名及被插入的值：

```sql
INSERT INTO table_name (column1,column2,column3,...)
VALUES (value1,value2,value3,...);
```



实例

向 "Websites" 表中插入一个新行

```sql
INSERT INTO Websites (name, url, alexa, country)
VALUES ('百度','https://www.baidu.com/','4','CN');
```

> 我们没有向 id 字段插入任何数字：id 列是自动更新的，表中的每条记录都有一个唯一的数字。



#### 在指定的列插入数据

```sql
INSERT INTO Websites (name, url, country)
VALUES ('stackoverflow', 'http://stackoverflow.com/', 'IND');
```



### UPDATE

> UPDATE 语句用于更新表中的记录。

```sql
UPDATE table_name
SET column1=value1,column2=value2,...
WHERE some_column=some_value;
```

WHERE 子句规定哪条记录或者哪些记录需要更新。如果您省略了 WHERE 子句，所有的记录都将被更新！



实例

把 "菜鸟教程" 的 alexa 排名更新为 5000，country 改为 USA

```sql
UPDATE Websites 
SET alexa='5000', country='USA' 
WHERE name='菜鸟教程';
```

![image-20220625114700795](D:/娱乐休闲/Wechat/Wechat文件管理/WeChat Files/wxid_sa4inldgv2gj22/FileStorage/File/2022-08/img2/image-20220625114700795.png)





### DELETE

> DELETE 语句用于删除表中的记录。

```sql
DELETE FROM table_name
WHERE some_column=some_value;
```

WHERE 子句规定哪条记录或者哪些记录需要删除。如果您省略了 WHERE 子句，所有的记录都将被删除！



示例

从 "Websites" 表中删除网站名为 "Facebook" 且国家为 USA 的网站。

```sql
DELETE FROM Websites
WHERE name='Facebook' AND country='USA';
```



#### 删除所有数据

```sql
DELETE FROM table_name;

// 或
DELETE * FROM table_name;
```

在不删除表的情况下，删除表中所有的行。这意味着表结构、属性、索引将保持不变



## SQL语句高级

### SELECT TOP

> SELECT TOP 子句用于规定要返回的记录的数目。
>
> 并非所有的数据库系统都支持 SELECT TOP 语句：*MySQL 支持 LIMIT 语句来选取指定的条数数据*。



### MySQL 语法

```sql
SELECT column_name(s)
FROM table_name
LIMIT number;
```



示例

从 "Websites" 表中选取头两条记录

```sql
SELECT * FROM Websites LIMIT 2;
```





## LIKE

LIKE 操作符用于在 WHERE 子句中搜索列中的指定模式。



```sql
SELECT column_name(s)
FROM table_name
WHERE column_name LIKE pattern;
```



示例

选取 name 以字母 "G" 开始的所有客户

```sql
SELECT * FROM Websites
WHERE name LIKE 'G%';
```



选取 name 以字母 "k" 结尾的所有客户

```sql
SELECT * FROM Websites
WHERE name LIKE '%k';
```



选取 name 包含模式 "oo" 的所有客户

```sql
SELECT * FROM Websites
WHERE name LIKE '%oo%';
```



选取 name 不包含模式 "oo" 的所有客户

```sql
SELECT * FROM Websites
WHERE name NOT LIKE '%oo%';
```



## 通配符

| 通配符                         | 描述                       |
| :----------------------------- | :------------------------- |
| %                              | 替代 0 个或多个字符        |
| _                              | 替代一个字符               |
| [*charlist*]                   | 字符列中的任何单一字符     |
| [^*charlist*] 或 [!*charlist*] | 不在字符列中的任何单一字符 |



选取 url 以字母 "https" 开始的所有网站

```
SELECT * FROM Websites
WHERE url LIKE 'https%';
```



选取 url 包含模式 "oo" 的所有网站

```
SELECT * FROM Websites
WHERE url LIKE '%oo%';
```



选取 name 以一个任意字符开始，然后是 "oogle" 的所有客户

```
SELECT * FROM Websites
WHERE name LIKE '_oogle';
```



选取 name 以 "G" 开始，然后是一个任意字符，然后是 "o"，然后是一个任意字符，然后是 "le" 的所有网站

```
SELECT * FROM Websites
WHERE name LIKE 'G_o_le';
```



选取 name 以 "G"、"F" 或 "s" 开始的所有网站

```
SELECT * FROM Websites
WHERE name REGEXP '^[GFs]';
```



选取 name 以 A 到 H 字母开头的网站

```
SELECT * FROM Websites
WHERE name REGEXP '^[A-H]';
```



选取 name 不以 A 到 H 字母开头的网站

```
SELECT * FROM Websites
WHERE name REGEXP '^[^A-H]';
```



## IN

IN 操作符允许您在 WHERE 子句中规定多个值。

```
SELECT column_name(s)
FROM table_name
WHERE column_name IN (value1,value2,...);
```



选取 name 为 "Google" 或 "菜鸟教程" 的所有网站

```sql
SELECT * FROM Websites
WHERE name IN ('Google','菜鸟教程');
```



## BETWEEN

用于选取介于两个值之间的数据范围内的值。这些值可以是数值、文本或者日期。

```sql
SELECT column_name(s)
FROM table_name
WHERE column_name BETWEEN value1 AND value2;
```



选取 alexa 介于 1 和 20 之间的所有网站

```
SELECT * FROM Websites
WHERE alexa BETWEEN 1 AND 20;
```



显示不在上面实例范围内的网站

```
SELECT * FROM Websites
WHERE alexa NOT BETWEEN 1 AND 20;
```



选取 alexa 介于 1 和 20 之间但 country 不为 USA 和 IND 的所有网站

```
SELECT * FROM Websites
WHERE (alexa BETWEEN 1 AND 20)
AND country NOT IN ('USA', 'IND');
```



### 带有文本值

选取 name 以介于 'A' 和 'H' 之间字母开始的所有网站

```
SELECT * FROM Websites
WHERE name BETWEEN 'A' AND 'H';
```

选取 name 不介于 'A' 和 'H' 之间字母开始的所有网站

```
SELECT * FROM Websites
WHERE name NOT BETWEEN 'A' AND 'H';
```



### 带有日期值

```less
+-----+---------+-------+------------+
| aid | site_id | count | date       |
+-----+---------+-------+------------+
|   1 |       1 |    45 | 2016-05-10 |
|   2 |       3 |   100 | 2016-05-13 |
|   3 |       1 |   230 | 2016-05-14 |
|   4 |       2 |    10 | 2016-05-14 |
|   5 |       5 |   205 | 2016-05-14 |
|   6 |       4 |    13 | 2016-05-15 |
|   7 |       3 |   220 | 2016-05-15 |
|   8 |       5 |   545 | 2016-05-16 |
|   9 |       3 |   201 | 2016-05-17 |
+-----+---------+-------+------------+
```



选取 date 介于 '2016-05-10' 和 '2016-05-14' 之间的所有访问记录

```
SELECT * FROM access_log
WHERE date BETWEEN '2016-05-10' AND '2016-05-14';
```



在某些数据库中，BETWEEN 选取介于两个值之间但不包括两个测试值的字段。
在某些数据库中，BETWEEN 选取介于两个值之间且包括两个测试值的字段。
在某些数据库中，BETWEEN 选取介于两个值之间且包括第一个测试值但不包括最后一个测试值的字段。



## 别名

通过使用 SQL，可以为表名称或列名称指定别名，使可读性更强。

**列的 SQL 别名语法**

```sql
SELECT column_name AS alias_name
FROM table_name;
```

**表的 SQL 别名语法**

```sql
SELECT column_name(s)
FROM table_name AS alias_name;
```



### 列的别名实例

指定了两个别名，一个是 name 列的别名，一个是 country 列的别名

```sql
SELECT name AS n, country AS c
FROM Websites;
```

**提示：**如果列名称包含空格，要求使用双引号或方括号

输出数据时，以别名形式输出？



把三个列（url、alexa 和 country）结合在一起，并创建一个名为 "site_info" 的别名

```sql
SELECT name, CONCAT(url, ', ', alexa, ', ', country) AS site_info
FROM Websites;
```



### 表的别名实例

选取 "菜鸟教程" 的所有访问记录。我们使用 "Websites" 和 "access_log" 表，并分别为它们指定表别名 "w" 和 "a"（通过使用别名让 SQL 更简短）：

```sql
SELECT w.name, w.url, a.count, a.date
FROM Websites AS w, access_log AS a
WHERE a.site_id=w.id and w.name="菜鸟教程";
```

```sql
// 等价于
SELECT Websites.name, Websites.url, access_log.count, access_log.date
FROM Websites, access_log
WHERE Websites.id=access_log.site_id and Websites.name="菜鸟教程";
```



## UNION

UNION 操作符用于合并两个或多个 SELECT 语句的结果集。

**SQL UNION 语法**

```sql
SELECT column_name(s) FROM table1
UNION
SELECT column_name(s) FROM table2;
```

**注释：**默认地，UNION 操作符选取不同的值。如果允许重复的值，请使用 UNION ALL。

**SQL UNION ALL 语法**

```sql
SELECT column_name(s) FROM table1
UNION ALL
SELECT column_name(s) FROM table2;
```

**注释：**UNION 结果集中的列名总是等于 UNION 中第一个 SELECT 语句中的列名。





从 "Websites" 和 "apps" 表中选取所有的country（去重值）

```sql
SELECT country FROM Websites
UNION
SELECT country FROM apps
ORDER BY country;
```

![image-20220625163949109](D:/娱乐休闲/Wechat/Wechat文件管理/WeChat Files/wxid_sa4inldgv2gj22/FileStorage/File/2022-08/img2/image-20220625163949109.png)



从 "Websites" 和 "apps" 表中选取所有的country（允许重复）

```sql
SELECT country FROM Websites
UNION ALL
SELECT country FROM apps
ORDER BY country;
```



从 "Websites" 和 "apps" 表中选取**所有的**中国(CN)的数据（允许重复）

```sql
SELECT country, name FROM Websites
WHERE country='CN'
UNION ALL
SELECT country, app_name FROM apps
WHERE country='CN'
ORDER BY country;
```



## 约束

用于规定表中的数据规则。如果存在违反约束的数据行为，行为会被约束终止。

```sql
CREATE TABLE table_name
(
column_name1 data_type(size) constraint_name,
column_name2 data_type(size) constraint_name,
column_name3 data_type(size) constraint_name,
....
);
```

约束可以在创建表时规定，也可以在表创建之后[进行规定](https://www.runoob.com/sql/sql-notnull.html)（通过 ALTER TABLE 语句）



### 约束汇总

- **NOT NULL** - 指示某列不能存储 NULL 值。
- **UNIQUE** - 保证某列的每行必须有唯一的值。
- **PRIMARY KEY** - NOT NULL 和 UNIQUE 的结合。确保某列（或两个列多个列的结合）有唯一标识，有助于更容易更快速地找到表中的一个特定的记录。
- **FOREIGN KEY** - 保证一个表中的数据匹配另一个表中的值的参照完整性。
- **CHECK** - 保证列中的值符合指定的条件。
- **DEFAULT** - 规定没有给列赋值时的默认值。

相关的创建、撤销、具体说明见[文档](https://www.runoob.com/sql/sql-notnull.html)





## CREATE INDEX

CREATE INDEX 语句用于在表中创建索引。

在不读取整个表的情况下，索引使数据库应用程序可以更快地查找数据。更新一个包含索引的表需要比更新一个没有索引的表花费更多的时间，这是由于索引本身也需要更新。因此，理想的做法是仅仅在常常被搜索的列（以及表）上面创建索引。



**SQL CREATE INDEX 语法**

在表上创建一个简单的索引。允许使用重复的值

```sql
CREATE INDEX index_name
ON table_name (column_name)
```

**SQL CREATE UNIQUE INDEX 语法**

在表上创建一个唯一的索引。不允许使用重复的值。

```sql
CREATE UNIQUE INDEX index_name
ON table_name (column_name)
```

创建索引的语法在不同的数据库中不一样



示例

在 "Persons" 表的 "LastName" 列上创建一个名为 "PIndex" 的索引

```sql
CREATE INDEX PIndex
ON Persons (LastName)
```

如果您希望索引不止一个列，您可以在括号中列出这些列的名称，用逗号隔开

```sql
CREATE INDEX PIndex
ON Persons (LastName, FirstName)
```



## 删除索引、表、库

### 删除索引 - MySQL

```sql
ALTER TABLE table_name DROP INDEX index_name
```

### 删除表

```
DROP TABLE table_name
```

### 删除表数据

删除表内的数据，但并不删除表本身

```
TRUNCATE TABLE table_name
```

### 删除库

```
DROP DATABASE database_name
```



## 修改列

ALTER TABLE 语句用于在已有的表中添加、删除或修改列。

### 在表中添加列

```sql
ALTER TABLE table_name
ADD column_name datatype
```

### 删除表中的列

```sql
ALTER TABLE table_name
DROP COLUMN column_name
```

请注意，某些数据库系统不允许这种在数据库表中删除列的方式

### 改变列的数据类型 - MySQL

```sql
ALTER TABLE table_name
MODIFY COLUMN column_name datatype
```



## AUTO INCREMENT

Auto-increment 会在新记录插入表中时生成一个唯一的数字。

### -MySQL

下面的 SQL 语句把 "Persons" 表中的 "ID" 列定义为 auto-increment 主键字段：

```sql
CREATE TABLE Persons
(
ID int NOT NULL AUTO_INCREMENT,
LastName varchar(255) NOT NULL,
FirstName varchar(255),
Address varchar(255),
City varchar(255),
PRIMARY KEY (ID)
)
```

MySQL 使用 AUTO_INCREMENT 关键字来执行 auto-increment 任务。

默认地，AUTO_INCREMENT 的开始值是 1，每条新记录递增 1。

要让 AUTO_INCREMENT 序列以其他的值起始，请使用下面的 SQL 语法：

```sql
ALTER TABLE Persons AUTO_INCREMENT=100
```

要在 "Persons" 表中插入新记录，我们不必为 "ID" 列规定值（会自动添加一个唯一的值）：

```sql
INSERT INTO Persons (FirstName,LastName)
VALUES ('Lars','Monsen')
```



## NULL值

为了测试 NULL 值，我们必须使用 IS NULL 和 IS NOT NULL 操作符。



示例

选取在 "Address" 列中带有 NULL 值的记录

```sql
SELECT LastName,FirstName,Address FROM Persons
WHERE Address IS NULL
```

选取在 "Address" 列中不带有 NULL 值的记录

```sql
SELECT LastName,FirstName,Address FROM Persons
WHERE Address IS NOT NULL
```



## NULL函数



### 处理null-MySQL

假如 "UnitsOnOrder" 是可选的，而且可以包含 NULL 值

| P_Id | ProductName | UnitPrice | UnitsInStock | UnitsOnOrder |
| :--- | :---------- | :-------- | :----------- | :----------- |
| 1    | Jarlsberg   | 10.45     | 16           | 15           |
| 2    | Mascarpone  | 32.56     | 23           |              |
| 3    | Gorgonzola  | 15.67     | 9            | 20           |

```sql
SELECT ProductName,UnitPrice*(UnitsInStock+UnitsOnOrder)
FROM Products
```

在上面的实例中，如果有 "UnitsOnOrder" 值是 NULL，那么结果是 NULL。



下面，如果 "UnitsOnOrder" 是 NULL，则不会影响计算，因为如果值是 NULL 则结果返回 0：

```sql
SELECT ProductName,UnitPrice*(UnitsInStock+IFNULL(UnitsOnOrder,0))
FROM Products
```

```sql
SELECT ProductName,UnitPrice*(UnitsInStock+COALESCE(UnitsOnOrder,0))
FROM Products
```



# SQL函数

## SQL函数

### SQL Aggregate 函数

计算从列中取得的值，返回一个单一的值。

- AVG() - 返回平均值
- COUNT() - 返回行数
- FIRST() - 返回第一个记录的值
- LAST() - 返回最后一个记录的值
- MAX() - 返回最大值
- MIN() - 返回最小值
- SUM() - 返回总和

------

### SQL Scalar 函数

基于输入值，返回一个单一的值。

- UCASE() - 将某个字段转换为大写
- LCASE() - 将某个字段转换为小写
- MID() - 从某个文本字段提取字符，MySql 中使用
- SubString(字段，1，end) - 从某个文本字段提取字符
- LEN() - 返回某个文本字段的长度
- ROUND() - 对某个数值字段进行指定小数位数的四舍五入
- NOW() - 返回当前的系统日期和时间
- FORMAT() - 格式化某个字段的显示方式



## AVG

函数返回数值列的平均值。

```sql
SELECT AVG(column_name) FROM table_name
```



示例

从 "access_log" 表的 "count" 列获取平均值

```sql
SELECT AVG(count) AS CountAverage FROM access_log;
```

选择访问量高于平均访问量的 "site_id" 和 "count"

```sql
SELECT site_id, count FROM access_log
WHERE count > (SELECT AVG(count) FROM access_log);
```



## UCASE

函数把字段的值转换为大写。

```sql
SELECT UCASE(column_name) FROM table_name;
```



示例

从 "Websites" 表中选取 "name" 和 "url" 列，并把 "name" 列的值转换为大写

```sql
SELECT UCASE(name) AS site_title, url
FROM Websites;
```

![image-20220628092902833](D:/娱乐休闲/Wechat/Wechat文件管理/WeChat Files/wxid_sa4inldgv2gj22/FileStorage/File/2022-08/img2/image-20220628092902833.png)



