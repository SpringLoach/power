

## 理论

mybatis 是对 jdbc 的封装，它让数据库底层操作变的透明。mybatis 的操作都是围绕一个 sqlSessionFactory 实例展开的。mybatis 通过配置文件关联到各实体类的 Mapper 文件，Mapper 文件中配置了每个类对数据库所需进行的 sql 语句映射。在每次与数据库交互时，通过 sqlSessionFactory 拿到一个 sqlSession，再执行 sql 命令。



[中文文档](https://mybatis.net.cn/)

### MyBatis

一款优秀的持久层框架

- 支持定制化SQL、存储过程以及高级映射。
- 避免了几乎所有的 JDBC 代码和手动设置参数以及获取结果集。
- 可以使用简单的 XML 或注解来配置和映射原生类型、接口和 Java 的 POJO 为数据库中的记录。



**优势**

- 灵活：不会对应用程序或者数据库的现有设计强加任何影响。 sql 写在 xml 里，便于统一管理和优化；
- 可维护性：sql 和代码的分离，提高了可维护性；
- 提供映射标签，支持对象与数据库的 ORM 字段关系映射；
- 提供对象关系映射标签，支持对象关系组建维护；
- 提供 xml 标签，支持编写动态 sql



### 持久化

- 持久化就是将程序的数据在<span style="color: #a50">持久状态</span>和<span style="color: #a50">瞬时状态</span>的转化过程
- 瞬时状态，如内存，断电即失
- 持久状态，如数据库，io文件

**优势**

- 保证一些对象不会丢失

- 内存太贵



### 持久层

- 完成持久化工作的代码块



## 搭建程序

### 新建项目

![image-20221211190335037](.\img\新建mybatis项目)



### 导包

可以在 maven [仓库](https://mvnrepository.com/)中，找到需要的版本

```html
<!--mysql驱动-->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>5.1.47</version>
</dependency>
<!--mybatis-->
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis</artifactId>
    <version>3.5.2</version>
</dependency>
<!--junt-->
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.12</version>
</dependency>
```



### 新建子模块

删除原本的 src 文件，创建子模块，子模块可以直接使用父模块的依赖。



### 配置文件

#### 配置核心文件

这段模板可以直接在[官网](https://mybatis.net.cn/getting-started.html)获取

<span style="backGround: #efe0b9">src/main/resources/mybatis-config.xml</span>

```html
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC"/>
            <dataSource type="POOLED">
                <property name="driver" value="com.mysql.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/demo?useSSl=true&amp;useUnicode=true&amp;characterEncoding=UTF-8"/>
                <property name="username" value="root"/>
                <property name="password" value="xxx"/>
            </dataSource>
        </environment>
    </environments>
    <mappers>
        <mapper resource="org/mybatis/example/BlogMapper.xml"/>
    </mappers>
</configuration>
```



![image-20221211192156408](.\img\配置核心文件)



#### 通过配置生成工厂函数

<span style="backGround: #efe0b9">com/master/utils/MybatisUtils.java</span>

```java
public class MybatisUtils {

    private static SqlSessionFactory sqlSessionFactory;

    static {
        try {
            // 通过配置初始化sqlSessionFactory对象
            String resource = "mybatis-config.xml";
            InputStream inputStream = Resources.getResourceAsStream(resource);
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    //
    public static SqlSession getSqlSession() {
        // 返回的SqlSession示例，拥有面向数据库执行SQL的方法
        return sqlSessionFactory.openSession();
    }
}
```



### 通过实例理解配置

#### 新建实体类

跟表结构对应

<span style="backGround: #efe0b9">com/master/pojo/User.java</span>

```java
public class User {
    private int id;
    private String name;
    private String pwd;

    public User() {
    }

    public User(int id, String name, String pwd) {
        this.id = id;
        this.name = name;
        this.pwd = pwd;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPwd() {
        return pwd;
    }

    public void setPwd(String pwd) {
        this.pwd = pwd;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", pwd='" + pwd + '\'' +
                '}';
    }
}
```



#### 编写Dao/Mapper层

> 本质就是 Mapper 替代了原先的 Dao 层，这里暂时用 Dao 作为后缀，规范的会改成 Mapper。

<span style="backGround: #efe0b9">com/master/dao/UserDao.java</span>

```java
public interface UserDao {
    List<User> getUserList();
}
```

<span style="backGround: #efe0b9">com/master/dao/UserMapper.xml</span>

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.master.dao.UserDao">
    <select id="getUserList" resultType="com.master.pojo.User">
        select * from demo.users
    </select>
</mapper>
```

:star2: 接口实现类由原来的 UserDaolmpl 转变为一个 Mapper 配置文件；

:turtle: resultType，现在的情况只需要返回泛型指定的类型。

| 属性       | 解释                  |
| ---------- | --------------------- |
| namespace  | 绑定 Dao(Mapper) 接口 |
| id         | 对应的方法名          |
| resultType | 对应返回类型          |
| demo.users | 对应数据库和表名      |



#### 测试

按照规范，测试文件的目录最好能映射到开发目录上

![image-20221211205027466](.\img\测试规范)

<span style="backGround: #efe0b9">com/master/dao/UserDaoTest.java</span>

```java
public class UserDaoTest {
    @Test
    public void test() {
        // 获得sqlSession对象
        SqlSession sqlSession = MybatisUtils.getSqlSession();

        UserDao userDao = sqlSession.getMapper(UserDao.class);
        List<User> userList = userDao.getUserList();

        for (User user : userList) {
            System.out.println(user);
        }

        // 关闭sqlSession
        sqlSession.close();
    }
}
```

:octopus: 注意要将后面两个步骤做了，测试才能顺利进行；

:question: 这里通过接口拿到类的映射，然后调用实例的方法。

##### 注册mapper.xml

<span style="backGround: #efe0b9">src/main/resources/mybatis-config.xml</span>

mapper.xml 需要在 mybatis 核心配置文件中注册

```html
<mappers>
    <mapper resource="com/master/dao/UserMapper.xml"/>
</mappers>
```

##### 资源导出问题

<span style="backGround: #efe0b9">pom.xml</span>

使用 Maven 的规范，会导致一些配置无法正常导出，可以添加以下代码解决。

```html
<!--在build中配置resources，来防止我们资源导出失败的问题-->
<build>
    <resources>
        <resource>
            <directory>src/main/resources</directory>
            <includes>
                <include>**/*.properties</include>
                <include>**/*.xml</include>
            </includes>
            <filtering>true</filtering>
        </resource>
        <resource>
            <directory>src/main/java</directory>
            <includes>
                <include>**/*.properties</include>
                <include>**/*.xml</include>
            </includes>
            <filtering>false</filtering>
        </resource>
    </resources>
</build>
```



## 实现增删改查

### 定义方法

<span style="backGround: #efe0b9">com/master/dao/UserDao.java</span>

```java
public interface UserDao {
    // ...
    // 根据Id查询用户
    User getUserById(int id);
    // 插入用户
    int addUser(User user);
    // 修改用户
    int updateUser(User user);
    // 删除用户
    int deleteUser(int id);
}
```

### 补充select配置

<span style="backGround: #efe0b9">com/master/dao/UserMapper.xml</span>

```html
<select id="getUserById" parameterType="int" resultType="com.master.pojo.User">
    select * from demo.users where id = #{id}
</select>

<insert id="addUser" parameterType="com.master.pojo.User">
    insert into demo.users (id, name, pwd) values (#{id}, #{name}, #{pwd});
</insert>

<update id="updateUser" parameterType="com.master.pojo.User">
    update demo.users set name=#{name}, pwd=#{pwd} where id = #{id};
</update>

<delete id="deleteUser" parameterType="int">
    delete from demo.users where id = #{id};
</delete>
```

:star2: 参数为对象时，对象中的属性可以直接提取出来

### 测试

<span style="backGround: #efe0b9">com/master/dao/UserDaoTest.java</span>

```java
@Test
public void getUserById() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();

    UserDao userDao = sqlSession.getMapper(UserDao.class);
    User user = userDao.getUserById(1);
    
    System.out.println(user);

    sqlSession.close();
}

@Test
public void addUser() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();

    UserDao userDao = sqlSession.getMapper(UserDao.class);

    int res = userDao.addUser(new User(3, "哈哈", "123121"));
    if (res > 0) {
        System.out.println("插入成功");
    }

    // 提交事务
    sqlSession.commit();
    sqlSession.close();
}

@Test
public void updateUser() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();

    UserDao userDao = sqlSession.getMapper(UserDao.class);

    userDao.updateUser(new User(1, "test", "tet"));

    // 提交事务
    sqlSession.commit();
    sqlSession.close();
}

@Test
public void deleteUser() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();

    UserDao userDao = sqlSession.getMapper(UserDao.class);

    userDao.deleteUser(3);

    // 提交事务
    sqlSession.commit();
    sqlSession.close();
}
```

:star2: 增删改的操作，都需要<span style="color: #ff0000">提交事务</span>（mybatis结合jdbc默认开启事务）。



## 分页

### 定义方法

<span style="backGround: #efe0b9">com/master/dao/UserDao.java</span>

```java
public interface UserDao {
    // ...
    // 分页
    List<User> getUserByLimit(Map<String, Integer> map);
}
```

### 补充select配置

<span style="backGround: #efe0b9">com/master/dao/UserMapper.xml</span>

```html
<select id="getUserByLimit" parameterType="map" resultType="com.master.pojo.User">
    select * from demo.users limit #{startIndex}, #{pageSize}
</select>
```

### 测试

<span style="backGround: #efe0b9">com/master/dao/UserDaoTest.java</span>

```java
@Test
public void getUserByLimit() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    UserDao userDao = sqlSession.getMapper(UserDao.class);

    HashMap<String, Integer> map = new HashMap<String, Integer>();
    map.put("startIndex", 0);
    map.put("pageSize", 2);

    List<User> userList = userDao.getUserByLimit(map);
    for (User user : userList) {
        System.out.println(user);
    }

    sqlSession.close();
}
```





## 使用map

- 使用 Map 传递参数，直接在 sql 取出 key

- 使用对象传递参数，直接在 sql 取出同名属性

- 只有一个基本类型参数时，可以直接在 sql 获取

<span style="backGround: #efe0b9">com/master/dao/UserDao.java</span>

```java
public interface UserDao {
    // ...
    // 使用Map插入用户
    int addUser2(Map<String, Object> map);
}
```

<span style="backGround: #efe0b9">com/master/dao/UserMapper.xml</span>

```html
<insert id="addUser2" parameterType="map">
    insert into demo.users (id, name, pwd) values (#{u_id}, #{u_name}, #{u_pwd});
</insert>
```

<span style="backGround: #efe0b9">com/master/dao/UserDaoTest.java</span>

```java
@Test
public void addUser2() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();

    UserDao userDao = sqlSession.getMapper(UserDao.class);

    Map<String, Object> map = new HashMap<String, Object>();

    map.put("u_id", 5);
    map.put("u_name", "hello");
    map.put("u_pwd", "23");

    userDao.addUser2(map);

    // 提交事务
    sqlSession.commit();
    sqlSession.close();
}
```



## 模糊查询

<span style="backGround: #efe0b9">com/master/dao/UserDao.java</span>

```java
public interface UserDao {
    // ...
    // 模糊查询
    List<User> getUserLike(String value);
}
```

<span style="backGround: #efe0b9">com/master/dao/UserMapper.xml</span>

```html
<select id="getUserLike" resultType="com.master.pojo.User">
    select * from demo.users where name like #{value}
</select>
```

<span style="backGround: #efe0b9">com/master/dao/UserDaoTest.java</span>

```java
@Test
public void getUserLike() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();

    UserDao userDao = sqlSession.getMapper(UserDao.class);

    List<User> userList = userDao.getUserLike("%t%");

    for (User user : userList) {
        System.out.println(user);
    }

    sqlSession.close();
}
```



## 配置

### 使用文件配置连接信息

1、可以通过 properties 标签引入外部文件，提供变量

<span style="backGround: #efe0b9">resources/mybatis-config.xml</span>

```elm
driver=com.mysql.jdbc.Driver
url=jdbc:mysql://localhost:3306/demo?useSSl=false&useUnicode=true&characterEncoding=UTF-8
username=root
password=xxx
```

<span style="backGround: #efe0b9">resources/mybatis-config.xml</span>

```html
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <properties resource="db.properties" />

    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC"/>
            <dataSource type="POOLED">
                <property name="driver" value="${driver}"/>
                <property name="url" value="${url}"/>
                <property name="username" value="${username}"/>
                <property name="password" value="${password}"/>
            </dataSource>
        </environment>
    </environments>
    <mappers>
        <mapper resource="com/master/dao/UserMapper.xml"/>
    </mappers>
</configuration>
```

:ghost: 由于资源在 resources 目录下，可以直接引入；

:octopus: 注意 properties 标签需放在顶部，否则会报错。

2、也可以在标签中定义变量

<span style="backGround: #efe0b9">resources/mybatis-config.xml</span>

```html
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <properties resource="db.properties">
        <property name="ddd" value="com.mysql.jdbc.Driver"/>
    </properties>

    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC"/>
            <dataSource type="POOLED">
                <property name="driver" value="${ddd}"/>
                <property name="url" value="${url}"/>
                <property name="username" value="${username}"/>
                <property name="password" value="${password}"/>
            </dataSource>
        </environment>
    </environments>
    <mappers>
        <mapper resource="com/master/dao/UserMapper.xml"/>
    </mappers>
</configuration>
```

3、如果外部配置文件，内部定义存在相同属性，优先使用外部配置文件的值



### 别名

#### 1. 替换为特定名称

<span style="backGround: #efe0b9">resources/mybatis-config.xml</span>

```html
...
<configuration>
    <properties resource="db.properties" />

    <typeAliases>
        <typeAlias type="com.master.pojo.User" alias="User" />
    </typeAliases>

    ...
</configuration>
```

:octopus: 注意 typeAliases标签需要放置在固定位置，否则会报错。

<span style="backGround: #efe0b9">com/master/dao/UserMapper.xml</span>

```html
<select id="getUserById" parameterType="int" resultType="com.master.pojo.User">
    select * from demo.users where id = #{id}
</select>

## 替换为下面的，程序依旧可以执行
<select id="getUserById" parameterType="int" resultType="User">
    select * from demo.users where id = #{id}
</select>
```



#### 2. 扫描包-类名作别名

<span style="backGround: #efe0b9">resources/mybatis-config.xml</span>

```html
...
<configuration>
    <properties resource="db.properties" />

    <typeAliases>
        <package name="com.master.pojo" />
    </typeAliases>

    ...
</configuration>
```

<span style="backGround: #efe0b9">com/master/dao/UserMapper.xml</span>

```html
<select id="getUserById" parameterType="int" resultType="com.master.pojo.User">
    select * from demo.users where id = #{id}
</select>

## 替换为下面的，程序依旧可以执行
<select id="getUserById" parameterType="int" resultType="user">
    select * from demo.users where id = #{id}
</select>
```

可以扫描包含实体类的包，它的默认别名就是类的类名，推荐使用别名时用小驼峰格式。



#### 3. 扫描包-注解特定名称

<span style="backGround: #efe0b9">resources/mybatis-config.xml</span>

```html
...
<configuration>
    <properties resource="db.properties" />

    <typeAliases>
        <package name="com.master.pojo" />
    </typeAliases>

    ...
</configuration>
```

<span style="backGround: #efe0b9">com/master/pojo/User.java</span>

```java
@Alias("hey")
public class User {...}
```

<span style="backGround: #efe0b9">com/master/dao/UserMapper.xml</span>

```html
<select id="getUserById" parameterType="int" resultType="com.master.pojo.User">
    select * from demo.users where id = #{id}
</select>

## 替换为下面的，程序依旧可以执行
<select id="getUserById" parameterType="int" resultType="hey">
    select * from demo.users where id = #{id}
</select>
```

:ghost: 可以使用 @Alias 配合扫描指定别名，优先级更高。



#### 4.映射器

1.使用相对于类路径的资源引用

```html
<mappers>
    <mapper resource="com/master/dao/UserMapper.xml"/>
</mappers>
```

2.使用class绑定注册

```html
<mappers>
    <mapper class="com.master.dao.UserMapper"/>
</mappers>
```

:hammer_and_wrench: 接口与对应的 mapper 配置文件必须同名，且处于同一包下

3.使用扫描包进行注入绑定

```html
<mappers>
    <package class="com.master.dao"/>
</mappers>
```

:hammer_and_wrench: 接口与对应的 mapper 配置文件必须同名，且处于同一包下



如果想分离，只需要在 resource 下建和接口所在相同的包

因为这样编译后 class 文件就会和 xml 在同一个包下

而 mybatis 的 resource 是通过 classpath 来找文件的



#### 5.生命周期和作用域

**SqlSessionFactoryBuilder**

- 用于根据配置创建 SqlSessionFactory，创建后即失去作用；
- 最好写成局部变量

**SqlSessionFactory**

- 创建后，就应该在应用的运行期间一直存在；
- 最佳作用域是应用作用域；
- 最简单的就是使用单例模式

**SqlSession**

- 不是线程安全的，不能共享；
- 最佳作用域是请求/方法作用域；
- 每次收到HTTP请求，就可以打开一个SqlSession，返回一个响应，就(在finally中)关闭它

**Mapper**

- SqlSession 可以创建一到多个 Mapper；
- 往往对应一个表



## 结果集映射

实体类的属性不能与表字段一一对应时，如果通过查询实例化，会导致这些属性被赋空值

```elm
// 数据库字段
id name pwd
// 实体类属性
id name password
```

**直接使用**

会导致创建出来的类的 password 属性为 null

```html
<select id="getUserById" resultType="com.master.pojo.User">
    select * from demo.users where id = #{id}
</select>
```

**修改SQL**

简单暴力的方式，但也有效

```html
<select id="getUserById" resultType="com.master.pojo.User">
    select id, name, pwd as password from demo.users where id = #{id}
</select>
```

**使用结果集映射**

只需要配置需要修改的映射即可

```html
<resultMap id="UserMap" type="User">
    <result column="pwd" property="password" />
</resultMap>
<select id="getUserById" resultMap="UserMap">
    select * from demo.users where id = #{id}
</select>
```

:ghost: result 标签的 <span style="color: #a50">column</span> 对应数据库字段，<span style="color: #a50">property</span> 对应需要映射的实体类的属性。

:ghost: resultMap 标签的 <span style="color: #a50">id</span> 属性与对应 select 标签的 <span style="color: #a50">resultMap</span> 属性对应；

:turtle: 注意这时 select 标签可以去掉 <span style="color: #a50">resultType</span> 属性了。



## 日志

### 设置日志

可以使用 logImpl 字段进行配置，具体需要的日志实现。

- STDOUT_LOGGING 标准日志输出
- LOG4J

<span style="backGround: #efe0b9">resources/mybatis-config.xml</span>

```html
<configuration>
    <properties >...</properties>
    
    <settings>
        <setting name="logImpl" value="STDOUT_LOGGING"/>
    </settings>

    <typeAliases>...</typeAliases>
</configuration>
```

:octopus: 注意 settings标签需要放置在固定位置，否则会报错。

![image-20221212213642900](.\img\日志详情)



## 注解

使用注解来映射简单语句会使代码显得更加简洁，然而对于稍微复杂一点的语句，Java注解就力不从心了，并且会显得更加混乱。因此，如果需要完成很复杂的事情，那么最好使用XML来映射语句。

实际开发中不会使用注解开发，因为难以维护。

本质：反射机制



### 简单示例

#### 定义方法

<span style="backGround: #efe0b9">com/master/dao/UserDao.java</span>

```java
public interface UserDao {
    // ...
    // 注解查询
    @Select("select * from user")
    List<User> getUsers();
}
```

#### 注册绑定接口

<span style="backGround: #efe0b9">resources/mybatis-config.xml</span>

```html
<mappers>
    <mapper class="com.master.dao.UserDao"/>
</mappers>
```

#### 测试

<span style="backGround: #efe0b9">com/master/dao/UserDaoTest.java</span>

```java
@Test
public void getUsers() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    // 底层主要应用反射
    UserDao userDao = sqlSession.getMapper(UserDao.class);

    List<User> userList = userDao.getUsers();
    for (User user : userList) {
        System.out.println(user);
    }

    sqlSession.close();
}
```



### 增删改查

#### 定义方法

<span style="backGround: #efe0b9">com/master/dao/UserDao.java</span>

```java
public interface UserDao {
    // ...
    @Select("select * from users where id = #{id}")
    User getUserById(@Param("id") int id);

    @Insert("insert into users(id, name, pwd) values (#{id}, #{name}, #{password})")
    int addUser(User user);

    @Update("update users set name=#{name}, pwd=#{password} where id = #{id}")
    int updateUser(User user);

    @Delete("delete from users where id = #{uid}")
    int deleteUser(@Param("uid") int id);
}
```

:star2: <span style="color: #a50">@Param</span> 注解与 <span style="color: #a50">@Select</span> 注解中的 `#{}` 参数对应起来

关于@Param

- 参数为基本类型/String类型，需要加上；
- 引用类型不用加；
- 如果只有一个基本类型，可以忽略，但最好加。

#### 测试

<span style="backGround: #efe0b9">com/master/dao/UserDaoTest.java</span>

```java
@Test
public void test1() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    UserDao userDao = sqlSession.getMapper(UserDao.class);

    User userById = userDao.getUserById(1);
    System.out.println(userById);

    sqlSession.close();
}

@Test
public void test2() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    UserDao userDao = sqlSession.getMapper(UserDao.class);

    userDao.addUser(new User(6, "hey", "hey123"));

    sqlSession.commit();
    sqlSession.close();
}

@Test
public void test3() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    UserDao userDao = sqlSession.getMapper(UserDao.class);

    userDao.updateUser(new User(5, "to", "222"));

    sqlSession.commit();
    sqlSession.close();
}

@Test
public void test4() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    UserDao userDao = sqlSession.getMapper(UserDao.class);

    userDao.deleteUser(5);

    sqlSession.commit();
    sqlSession.close();
}
```



## Lombok插件

### 安装插件

对于较新版本的 IDEA，已经内置了该插件，如果没有就搜索装一下

![image-20221213192613648](.\img\Lombok插件)



### 添加依赖

![image-20221213192857826](.\img\Lombok插件2)

<span style="backGround: #efe0b9">pom.xml</span>

这里将 scope 标签去掉

```html
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>1.18.12</version>
</dependency>
```



### 使用示例

```java
@Data
public class Demo {
    private int id;
    private String name;
}
```

:star2: 通过添加 <span style="color: #a50">@Data</span>，就能够自动根据属性生成 get/set/toString 等，点左下角的 Structure 可以查看。

| 常用注解            | 说明                                                   |
| ------------------- | ------------------------------------------------------ |
| @Data               | 生成 get/set/toString/无参构造                         |
| @Getter、@Setter    | 生成属性的 getter、setter；可用于类/属性               |
| @ToString           | 生成 toString 方法                                     |
| @EqualsAndHashCode  | 生成 canEqual 和 hashCode 方法                         |
| @NoArgsConstructor  | 生成无参构造器                                         |
| @AllArgsConstructor | 生成所有属性作为参数的构造器；使用它会丢失默认无参构造 |

:turtle: 也可以手动加上自定义参数构造。



## 复杂查询

### 环境搭建

#### 1.准备关联表

```sql
CREATE TABLE `teacher` (
  `id` INT(10) NOT NULL,
  `name` VARCHAR(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8

INSERT INTO teacher(`id`, `name`) VALUES (1, '秦老师'); 

CREATE TABLE `student` (
  `id` INT(10) NOT NULL,
  `name` VARCHAR(30) DEFAULT NULL,
  `tid` INT(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fktid` (`tid`),
  CONSTRAINT `fktid` FOREIGN KEY (`tid`) REFERENCES `teacher` (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8

INSERT INTO `student` (`id`, `name`, `tid`) VALUES ('1', '小明', '1'); 
INSERT INTO `student` (`id`, `name`, `tid`) VALUES ('2', '小红', '1'); 
INSERT INTO `student` (`id`, `name`, `tid`) VALUES ('3', '小张', '1'); 
INSERT INTO `student` (`id`, `name`, `tid`) VALUES ('4', '小李', '1'); 
INSERT INTO `student` (`id`, `name`, `tid`) VALUES ('5', '小王', '1');
```



#### 2.准备实体类

<span style="backGround: #efe0b9">com/master/pojo/Teacher.java</span>

```java
@Data
public class Teacher {
    private int id;
    private String name;
}
```

<span style="backGround: #efe0b9">com/master/pojo/Student.java</span>

```java
@Data
public class Student {
    private int id;
    private String name;
    // 学生需要关联一个老师
    private Teacher teacher;
}
```



#### 3.准备Mapper接口

<span style="backGround: #efe0b9">com/master/dao/TeacherMapper.java</span>

```java
public interface TeacherMapper {
    @Select("select * from teacher where id = #{tid}")
    Teacher getTeacher(@Param("tid") int id);
}
```

<span style="backGround: #efe0b9">com/master/dao/StudentMapper.java</span>

```java
public interface StudentMapper {
}
```



#### 4.准备对应的XML

注意这两个文件建在了 resources 目录下，且保持路径与接口一致。

<span style="backGround: #efe0b9">src/main/resources/com/master/dao/TeacherMapper.xml</span>

```html
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.master.dao.TeacherMapper">

</mapper>
```

<span style="backGround: #efe0b9">src/main/resources/com/master/dao/StudentMapper.xml</span>

```html
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.master.dao.StudentMapper">

</mapper>
```



#### 5.注册XML

<span style="backGround: #efe0b9">resources/mybatis-config.xml</span>

```html
<mappers>
    <mapper class="com.master.dao.TeacherMapper"/>
    <mapper class="com.master.dao.StudentMapper"/>
</mappers>
```



#### 6.测试

```java
@Test
public void test1() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    TeacherMapper mapper = sqlSession.getMapper(TeacherMapper.class);

    Teacher teacher = mapper.getTeacher(1);
    System.out.println(teacher);

    sqlSession.close();
}
```



### 多对一的处理

#### 按照查询嵌套处理

##### 补充接口方法

<span style="backGround: #efe0b9">com/master/dao/StudentMapper.java</span>

```java
public interface StudentMapper {
    // 查询所有的学生信息，以及对应老师的信息
    public List<Student> getStudent();
}
```

##### 补充接口实现

<span style="backGround: #efe0b9">src/main/resources/com/master/dao/StudentMapper.xml</span>

```html
<select id="getStudent" resultMap="StudentTeacher">
    select * from student
</select>

<resultMap id="StudentTeacher" type="com.master.pojo.Student">
    <result property="id" column="id" />
    <result property="name" column="name" />
    <association property="teacher" column="tid" javaType="com.master.pojo.Teacher" select="getTeacher" />
</resultMap>

<select id="getTeacher" resultType="com.master.pojo.Teacher">
    select * from teacher where id = #{tid}
</select>
```

| 标签        | 属性      | 说明                                       |
| ----------- | --------- | ------------------------------------------ |
| select      | id        | 对应接口方法；或 association 标签的 select |
| select      | resultMap | 对应 resultMap 标签的 id                   |
| resultMap   | type      | 对应相应 select 的原 resultType            |
| association | javaType  | 对应自身 property 的类型                   |
| association |           | 对应对象类型                               |
| collection  |           | 对应集合类型                               |

##### 测试

```java
@Test
public void test() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    StudentMapper mapper = sqlSession.getMapper(StudentMapper.class);

    List<Student> studentList = mapper.getStudent();
    for (Student student : studentList) {
        System.out.println(student);
    }
    sqlSession.close();
}
```



#### 按照结果嵌套处理

##### 补充接口方法

<span style="backGround: #efe0b9">com/master/dao/StudentMapper.java</span>

```java
public interface StudentMapper {
    // ...
    public List<Student> getStudent2();
}
```

##### 补充接口实现

<span style="backGround: #efe0b9">src/main/resources/com/master/dao/StudentMapper.xml</span>

```html
<select id="getStudent2" resultMap="StudentTeacher2">
    select s.id sid, s.name sname, t.id tid, t.name tname
    from student s, teacher t
    where s.tid = t.id;
</select>

<resultMap id="StudentTeacher2" type="com.master.pojo.Student">
    <result property="id" column="sid" />
    <result property="name" column="sname" />
    <association property="teacher" javaType="com.master.pojo.Teacher">
        <result property="name" column="tname" />
        <result property="id" column="tid" />
    </association>
</resultMap>
```



### 一对多的处理

#### 修改实体类

<span style="backGround: #efe0b9">com/master/pojo/Teacher.java</span>

```java
@Data
public class Teacher {
    private int id;
    private String name;
    // 一个老师带多个学生
    private List<Student> students;
}
```

<span style="backGround: #efe0b9">com/master/pojo/Student.java</span>

```java
@Data
public class Student {

    private int id;
    private String name;
    private int tid;
}
```



#### 按照结果嵌套处理

##### 补充接口方法

<span style="backGround: #efe0b9">com/master/dao/TeacherMapper.java</span>

```java
public interface TeacherMapper {
    // 获取老师信息及其学生信息
    Teacher getTeacher(@Param("tid") int id);
}
```

##### 补充接口实现

<span style="backGround: #efe0b9">src/main/resources/com/master/dao/TeacherMapper.xml</span>

```html
<select id="getTeacher" resultMap="TeacherStudent">
    select s.id sid, s.name sname, t.name tname, t.id tid
    from student s, teacher t
    where s.tid = t.id and t.id = #{tid}
</select>

<resultMap id="TeacherStudent" type="com.master.pojo.Teacher">
    <result property="id" column="tid" />
    <result property="name" column="tname" />
    <collection property="students" ofType="com.master.pojo.Student">
        <result property="id" column="sid" />
        <result property="name" column="sname" />
        <result property="tid" column="tid" />
    </collection>
</resultMap>
```

集合中的泛型信息，使用 <span style="color: #a50">ofType</span> 获取

##### 测试

```java
public void test() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    TeacherMapper mapper = sqlSession.getMapper(TeacherMapper.class);

    Teacher teacher = mapper.getTeacher(1);
    System.out.println(teacher);

    sqlSession.close();
}
```



#### 按照查询嵌套处理

##### 补充接口方法

<span style="backGround: #efe0b9">com/master/dao/TeacherMapper.java</span>

```java
public interface TeacherMapper {
    // ...
    Teacher getTeacher2(@Param("tid") int id);
}
```

##### 补充接口实现

<span style="backGround: #efe0b9">src/main/resources/com/master/dao/TeacherMapper.xml</span>

```html
<select id="getTeacher2" resultMap="TeacherStudent2">
    select * from demo.teacher where id = #{tid}
</select>

<resultMap id="TeacherStudent2" type="com.master.pojo.Teacher">
    <collection property="students" javaType="ArrayList" ofType="com.master.pojo.Student" select="getStudentByTeacherId" column="id" />
</resultMap>

<select id="getStudentByTeacherId" resultType="com.master.pojo.Student">
    select * from demo.student where tid = #{tid}
</select>
```



## 动态SQL

### 环境搭建

#### 建表

```sql
CREATE TABLE `blog`(
`id` VARCHAR(50) NOT NULL COMMENT '博客id',
`title` VARCHAR(100) NOT NULL COMMENT '博客标题',
`author` VARCHAR(30) NOT NULL COMMENT '博客作者',
`create_time` DATETIME NOT NULL COMMENT '创建时间',
`views` INT(30) NOT NULL COMMENT '浏览量'
)ENGINE=INNODB DEFAULT CHARSET=utf8
```

#### 新建实体类

<span style="backGround: #efe0b9">com/master/pojo/Blog.java</span>

```java
@Data
public class Blog {
    private String id;
    private String title;
    private String author;
    private Date createTime;
    private int views;
}
```

#### 定义方法

<span style="backGround: #efe0b9">com/master/dao/BlogMapper.java</span>

```java
public interface BlogMapper {
    // 插入数据
    int addBlog(Blog blog);
}
```

#### 新建xml

<span style="backGround: #efe0b9">com/master/dao/BlogMapper.xml</span>

```html
<mapper namespace="com.master.dao.BlogMapper">

    <insert id="addBlog" parameterType="com.master.pojo.Blog">
        insert into demo.blog (id, title, author, create_time, views)
        values (#{id}, #{title}, #{author}, #{createTime}, #{views});
    </insert>

</mapper>
```

#### 注册xml

<span style="backGround: #efe0b9">resources/mybatis-config.xml</span>

```html
<mappers>
    <mapper class="com.master.dao.BlogMapper"/>
</mappers>
```

#### 开启驼峰映射

```html
<settings>
    <setting name="logImpl" value="STDOUT_LOGGING"/>
    <setting name="mapUnderscoreToCamelCase" value="true"/>
</settings>
```

| 属性                     | 含义                                                    | 默认值 |
| ------------------------ | ------------------------------------------------------- | ------ |
| mapUnderscoreToCamelCase | 开启自动驼峰命名规则映射，即数据库(A_CO) => 属性名(aCo) | false  |

#### 辅助方法

> 新建一个随机数，并且把其中的 - 去掉

<span style="backGround: #efe0b9">com/master/utils/IDutils.java</span>

```java
@SuppressWarnings("all") // 镇压警告
public class IDutils {
    public static String getId() {
        return UUID.randomUUID().toString().replaceAll("-", "");
    }
}
```

#### 测试(插入数据)

```java
@Test
public void test() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    BlogMapper mapper = sqlSession.getMapper(BlogMapper.class);
    Blog blog = new Blog();
    blog.setId(IDutils.getId());
    blog.setTitle("Mybatis");
    blog.setAuthor("狂神说");
    blog.setCreateTime(new Date());
    blog.setViews(9999);

    mapper.addBlog(blog);

    blog.setId(IDutils.getId());
    blog.setTitle("Java");
    mapper.addBlog(blog);

    blog.setId(IDutils.getId());
    blog.setTitle("Spring");
    mapper.addBlog(blog);

    blog.setId(IDutils.getId());
    blog.setTitle("微服务");
    mapper.addBlog(blog);

    sqlSession.commit();
    sqlSession.close();
}
```



### IF语句

#### 定义方法

<span style="backGround: #efe0b9">com/master/dao/BlogMapper.java</span>

```java
public interface BlogMapper {
    // ...
    // 查询博客
    List<Blog> queryBlogIF(Map map);
}
```

#### 补充xml

<span style="backGround: #efe0b9">com/master/dao/BlogMapper.xml</span>

```html
<select id="queryBlogIF" parameterType="map" resultType="com.master.pojo.Blog">
    select * from demo.blog where 1=1
    <if test="title != null">
        and title = #{title}
    </if>
    <if test="author != null">
        and author = #{author}
    </if>
</select>
```

:point_down: 这里的 `where 1=1` 特别别扭，可以通过 <span style="color: #a50">WHERE</span> 语句代替升级。

#### 测试

```java
@Test
public void test4() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    BlogMapper mapper = sqlSession.getMapper(BlogMapper.class);

    HashMap map = new HashMap();
    map.put("title", "Java如此简单");
    map.put("author", "狂神说");

    List<Blog> blogs = mapper.queryBlogIF(map);

    for (Blog blog : blogs) {
        System.out.println(blog);
    }

    sqlSession.close();
}
```



### WHERE语句

```html
<select id="queryBlogIF" parameterType="map" resultType="com.master.pojo.Blog">
    select * from demo.blog
    <where>
        <if test="title != null">
            title = #{title}
        </if>
        <if test="author != null">
            and author = #{author}
        </if>
    </where>
</select>
```

:trident: 为上面 IF 语句的升级版，且功能更强大；

:star2: where 元素只会在至少有一个子元素的条件返回SQL子句的情况下才去插入<span style="color: slategray">WHERE子句</span>。而且，若语句的开头为 <span style="color: #a50">AND</span> 或 <span style="color: #a50">OR</span>，where 元素也会将它们去除。



### CHOOSE语句

#### 定义方法

<span style="backGround: #efe0b9">com/master/dao/BlogMapper.java</span>

```java
public interface BlogMapper {
    // ...
    List<Blog> queryBlogChoose(Map map);
}
```

#### 补充xml

<span style="backGround: #efe0b9">com/master/dao/BlogMapper.xml</span>

```html
<select id="queryBlogChoose" parameterType="map" resultType="com.master.pojo.Blog">
    select * from demo.blog
    <where>
        <choose>
            <when test="title != null">
                title = #{title}
            </when>
            <when test="author != null">
                author = #{author}
            </when>
            <otherwise>
                views = #{views}
            </otherwise>
        </choose>
    </where>
</select>
```

:ghost: 类似于 <span style="color: #a50">switch</span> 语句，首个匹配到的项执行，可以提供 <span style="color: #a50">otherwise</span> 作为备用处理。

#### 测试

```java
@Test
public void test4() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    BlogMapper mapper = sqlSession.getMapper(BlogMapper.class);

    HashMap map = new HashMap();
    map.put("views", 9999);

    List<Blog> blogs = mapper.queryBlogChoose(map);

    for (Blog blog : blogs) {
        System.out.println(blog);
    }

    sqlSession.close();
}
```



### SET语句

#### 定义方法

<span style="backGround: #efe0b9">com/master/dao/BlogMapper.java</span>

```java
public interface BlogMapper {
    // ...
    // 更新博客
    int updateBlog(Map map);
}
```



#### 补充xml

<span style="backGround: #efe0b9">com/master/dao/BlogMapper.xml</span>

```html
<update id="updateBlog" parameterType="map">
    update demo.blog
    <set>
        <if test="title != null">
            title = #{title},
        </if>
        <if test="author != null">
            author = #{author},
        </if>
    </set>
    where id = #{id}
</update>
```

:ghost:set 元素会动态前置 SET 关键字，同时也会删除无关的逗号 

#### 测试

```java
@Test
public void test() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    BlogMapper mapper = sqlSession.getMapper(BlogMapper.class);

    HashMap map = new HashMap();
    map.put("title", "Java如此简单2");
    map.put("author", "狂神说");
    map.put("id", "825ae3fbb9504be88457821925563f8d");

    mapper.updateBlog(map);

    sqlSession.commit();
    sqlSession.close();
}
```



### SQL片段

<span style="backGround: #efe0b9">com/master/dao/BlogMapper.xml</span>

```html
<sql id="if-title-author">
    <if test="title != null">
        title = #{title}
    </if>
    <if test="author != null">
        and author = #{author}
    </if>
</sql>

<select id="queryBlogIF" parameterType="map" resultType="com.master.pojo.Blog">
    select * from demo.blog
    <where>
        <include refid="if-title-author"></include>
    </where>
</select>
```

:trident: 为上面 IF 语句的同等实现版，通过 sql 标签定义片段，通过 include 标签引入片段。



### FOREACH语句

#### 定义方法

<span style="backGround: #efe0b9">com/master/dao/BlogMapper.java</span>

```java
public interface BlogMapper {
    // ...
    //查询特定博客
    List<Blog> queryBlogForeach(Map map);
}
```

#### 补充xml

<span style="backGround: #efe0b9">com/master/dao/BlogMapper.xml</span>

```html
<select id="queryBlogForeach" resultType="com.master.pojo.Blog">
    select * from demo.blog where id in
    <foreach collection="list" item="item" index="index"
             open="(" separator="," close=")">
        #{item}
    </foreach>
</select>
```

| foreach标签字段 | 说明               |
| --------------- | ------------------ |
| collection      | 需要进行遍历的参数 |
| item            | 当前遍历的项       |
| index           | 当前遍历的索引     |
| open            | 添加前缀           |
| close           | 分隔符             |
| separator       | 添加后缀           |

#### 测试

```java
@Test
public void test4() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    BlogMapper mapper = sqlSession.getMapper(BlogMapper.class);

    HashMap map = new HashMap();

    ArrayList<Integer> list = new ArrayList<Integer>();
    list.add(1);
    list.add(2);

    map.put("list", list);
    List<Blog> blogs = mapper.queryBlogForeach(map);

    for (Blog blog : blogs) {
        System.out.println(blog);
    }

    sqlSession.close();
}
```



## 缓存

1. 什么是缓存？
   - 存在内存中的临时数据
   - 将用户经常查询的数据放在缓存(内存)中，用户去查询数据就不用从磁盘上(关系型数据库数据文件)查询，从缓存中查询，从而提高查询效率，解决了高并发系统的性能问题
2. 为什么使用缓存？
   - 减少和数据库的交互次数，减少系统开销，提高系统效率
3. 什么数据能使用缓存？
   - 经常查询并且不经常改变的数据



### 一级缓存

mybatis 的一级缓存（即本地的会话缓存）是默认开启的；只会在同次 SqlSession 中生效。



#### 示例

```java
@Test
public void test() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    BlogMapper mapper = sqlSession.getMapper(UserMapper.class);

    User user = mapper.queryUserById(1);
    System.out.println("==========");
    User user2 = mapper.queryUserById(1);
    System.out.println(user == user2);  // true

    sqlSession.close();
}
```

开启日志，能够更具体看出复用的过程。



#### 缓存机制

- select 语句的结果将被缓存；

- insert、update 和 delete 语句会刷新缓存；

- 缓存会使用最近最少使用算法来清除不需要的缓存；
- 缓存不会定时进行刷新；
- 缓存会被保存为列表或对象的1024个引用；
- 缓存会被视为读/写缓存，即获取到的对象不是共享的，不会干扰其它线程。



#### 缓存失效的情况

1. 查询语句改变

2. 进行了增删改操作

3. 查询不同的Mapper.xml

4. 手动清理缓存

   ```java
   SqlSession sqlSession = MybatisUtils.getSqlSession();
   sqlSession.clearCache();
   ```

   

### 二级缓存

二级缓存，它的作用域是 namespace，可以认为它对于同个 Mapper.xml 下的内容生效；

但如果不同的 Mapper.xml 使用相同的 namespace，也是共享缓存的；

数据先放到一级缓存，会话提交/关闭时，会被提交到二级缓存中



#### 1.开启全局缓存

<span style="backGround: #efe0b9">resources/mybatis-config.xml</span>

```html
<settings>
    <setting name="cacheEnabled" value="true"/>
</settings>
```

#### 2.开启二级缓存

<span style="backGround: #efe0b9">com/master/dao/UserMapper.xml</span>

```html
<mapper namespace="com.master.dao.UserDao">
    <cache eviction="FIFO"
        flushInterval="60000"
        size="512"
        readOnly="true" />
</mapper>
```

添加上 cache 标签即代表在当前 Mapper.xml 中使用二级缓存;

属性含义：先进先出的缓存策略；每隔60秒刷新；最多存储512个对象/列表的引用；返回只读对象。

<span style="backGround: #efe0b9">com/master/pojo/User.java</span>

```java
@Data
public class User implements Serializable {
    private int id;
    private String name;
    private String pwd;
}
```

如果使用的缓存策略不是只读（即使用读写）的，还需要通过序列化缓存对象。

#### 测试

```java
@Test
public void test() {
    SqlSession sqlSession = MybatisUtils.getSqlSession();
    SqlSession sqlSession2 = MybatisUtils.getSqlSession();

    BlogMapper mapper = sqlSession.getMapper(UserMapper.class);
    User user = mapper.queryUserById(1);
    System.out.println(user);
    sqlSession.close();

    BlogMapper mapper2 = sqlSession.getMapper(UserMapper.class);
    User user2 = mapper2.queryUserById(1);
    System.out.println(user2);
    sqlSession2.close();

    System.out.println(user == user2);
}
```

![image-20221216230135091](.\img\缓存机制)





























