## 介绍

它是 MyBatis 的增强工具，在 MyBatis 的基础上只做增强不做改变，为简化开发、提高效率而生。

官方链接 https://baomidou.com/pages/24112f/



## 快速开始

### 建表

执行官方给出的 sql 建表

### 建项目

新建 springboot 项目，勾选依赖：

- Spring Web

### 导入依赖

```html
<!--lombok-->
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
</dependency>
<!--mybatis-plus-->
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-boot-starter</artifactId>
    <version>3.5.2</version>
</dependency>
<!--数据库驱动-->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
</dependency>
```

:octopus: 尽量不要同时导入 mybatis 和 mybatis-plus，避免版本差异。

### 配置-数据库连接

<span style="backGround: #efe0b9">resources/application.properties</span>

```properties
# mysql5，使用驱动 com.mysql.jdbc.Driver
spring.datasource.username=root
spring.datasource.password=xxx
spring.datasource.url=jdbc:mysql://localhost:3306/ssmbuild?useSSL=true&useUnicode=true&characterEncoding=utf8
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# mysql8，使用驱动 com.mysql.cj.jdbc.Driver，需要指定时区
spring.datasource.username=root
spring.datasource.password=xxx
spring.datasource.url=jdbc:mysql://localhost:3306/ssmbuild?serverTimezone=UTC&useSSL=true&useUnicode=true&characterEncoding=utf8
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

### 扫描Mapper

在 Spring Boot 启动类中添加 `@MapperScan` 注解，扫描 Mapper 文件夹

<span style="backGround: #efe0b9">主入口</span>

```java
@SpringBootApplication
@MapperScan("com.master.mapper")
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

}
```

### 编写实体类

<span style="backGround: #efe0b9">com/master/pojo/User.java</span>

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {
    private Long id;
    private String name;
    private Integer age;
    private String email;
}
```

### 编写接口

编写 Mapper 包下的 `UserMapper`接口

<span style="backGround: #efe0b9">com/master/mapper/UserMapper.java</span>

```java
public interface UserMapper extends BaseMapper<User> {
}
```

### 测试

```java
@SpringBootTest
class MybatisPlusApplicationTests {
    
    @Autowired
    private UserMapper userMapper;

    @Test
    void contextLoads() {
        List<User> userList = userMapper.selectList(null);
        userList.forEach(System.out::println);
    }
}
```



## 配置日志输出

<span style="backGround: #efe0b9">resources/application.properties</span>

```properties
# 配置日志
mybatis-plus.configuration.log-impl=org.apache.ibatis.logging.stdout.StdOutImpl
```

这里选用的是标准输出（内置），用其他的还需要导入依赖。



### 测试

```java
@Slf4j
@SpringBootTest
class MybatisPlusApplicationTests {
    
    @Test
    public void testLog() {
        log.info("abcdefg");
    }
}
```

<span style="color: #f7534f;font-weight:600">@Slf4j</span> 用于日志输出，需要添加到类上



## CRUD扩展

### 插入测试

```java
@SpringBootTest
class MybatisPlusApplicationTests {
    
    @Autowired
    private UserMapper userMapper;
    //...
    
    @Test
    public void testInsert() {
        User user = new User();
        user.setName("demo");
        user.setAge(6);
        user.setEmail("123@qq.com");

        int result = userMapper.insert(user); // 会自动生成id
        System.out.println(result); // 受影响的行数
        System.out.println(user); // 可以发现id自动回填
    }
}
```



#### 配置id插入策略

<span style="backGround: #efe0b9">com/master/pojo/User.java</span>

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {

    @TableId(type=IdType.NONE)
    private Long id;
    private String name;
    private Integer age;
    private String email;
}
```

<span style="color: #f7534f;font-weight:600">@TableId</span> 可以通过 type 属性配置 id 的设置策略，接收 IdType 下的枚举值。

| IdType属性  | 说明                                   |
| ----------- | -------------------------------------- |
| NONE        | 不去设置主键                           |
| ASSIGN_ID   | 全局唯一id                             |
| ASSIGN_UUID | 全局唯一id                             |
| AUTO        | 数据库id自增，需要表中设置该字段为自增 |
| INPUT       | 需要手动输入                           |



### 修改操作

```java
@SpringBootTest
class MybatisPlusApplicationTests {
    
    @Autowired
    private UserMapper userMapper;
    //...
    
    @Test
    public void testUpdate() {
        User user = new User();
        user.setId(3L);
        user.setName("master");

        userMapper.updateById(user);
    }
}
```



### 自动填充功能

> 除去数据库本身的默认值功能，也可以用代码实现。

#### 1、自定义实现类

<span style="backGround: #efe0b9">com/master/handler/MyMetaObjectHandler.java</span>

```java
@Slf4j
@Component
public class MyMetaObjectHandler implements MetaObjectHandler {

    @Override
    public void insertFill(MetaObject metaObject) {
        log.info("start insert fill ....");
        this.strictInsertFill(metaObject, "createTime", () -> LocalDateTime.now(), LocalDateTime.class);
        this.strictInsertFill(metaObject, "updateTime", () -> LocalDateTime.now(), LocalDateTime.class);
    }

    @Override
    public void updateFill(MetaObject metaObject) {
        log.info("start update fill ....");
        this.strictUpdateFill(metaObject, "updateTime", () -> LocalDateTime.now(), LocalDateTime.class);
    }
}
```

<span style="color: #f7534f;font-weight:600">@Component</span> 注入 IOC 容器，交给 spring 管理。



#### 2、使用策略

> 这里用的是一个模拟的类。

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {

    private Long id;
    private String name;
    @TableField(fill = FieldFill.INSERT)
    private Date createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private Date updateTime;
}
```

<span style="color: #f7534f;font-weight:600">@TableField</span> 注解填充字段

| FieldFill属性 | 说明               |
| ------------- | ------------------ |
| DEFAULT       | 默认不处理         |
| INSERT        | 插入填充字段       |
| UPDATE        | 更新填充字段       |
| INSERT_UPDATE | 插入和更新填充字段 |



### 乐观锁

```
乐观锁：总认为不会出现问题，不上锁；如果出了问题，就再次更新值
悲观锁：总认为会出现问题，上锁，再执行操作
```

乐观锁实现方式：

>  当要更新一条记录时，希望这条记录没被别人更新。

- 取出记录，获取到 version 作为 oldVersion

- 更新这条记录时，语句带上判断版本，并更新版本值

  ```sql
  update user set name = "demo", version = version + 1
  where id = 2 and version = 1
  ```

  

#### 添加表字段

![image-20221227163059829](.\img\添加乐观锁字段)

#### 补充标注乐观锁字段

<span style="backGround: #efe0b9">com/master/pojo/User.java</span>

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {

    private Long id;
    private String name;
    private Integer age;
    private String email;
    
    @Version
    private Integer version;
}
```

<span style="color: #f7534f;font-weight:600">@Version</span> 乐观锁注解

#### 配置插件

<span style="backGround: #efe0b9">com/master/config/MyBatisPlusConfig.java</span>

```java
@EnableTransactionManagement
@Configuration
public class MyBatisPlusConfig {
    
    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        // 乐观锁
        interceptor.addInnerInterceptor(new OptimisticLockerInnerInterceptor());
        return interceptor;
    }
}
```

<span style="color: #f7534f;font-weight:600">@Configuration</span> 继承自 <span style="color: #a50">@Component</span>，表示是一个配置类；

<span style="color: #f7534f;font-weight:600">@EnableTransactionManagement</span> springBoot专有，表示开启事务支持



#### 测试-乐观锁成功

```java
@SpringBootTest
class MybatisPlusApplicationTests {
    
    @Autowired
    private UserMapper userMapper;
    //...
    
    @Test
    public void testOptimisticLocker1(){
        //1、查询用户信息
        User user = userMapper.selectById(1L);
        //2、修改用户信息
        user.setAge(18);
        user.setEmail("2803708553@qq.com");
        //3、执行更新操作
        userMapper.updateById(user);
    }
}
```

#### 测试-乐观锁失败

```java
@SpringBootTest
class MybatisPlusApplicationTests {
    
    @Autowired
    private UserMapper userMapper;
    //...
    
    @Test
    public void testOptimisticLocker2(){
        //线程1
        User user1 = userMapper.selectById(1L);
        user1.setAge(1);
        user1.setEmail("2803708553@qq.com");
        //模拟另外一个线程执行了插队操作
        User user2 = userMapper.selectById(1L);
        user2.setAge(2);
        user2.setEmail("2803708553@qq.com");
        userMapper.updateById(user2);
        //理论上需要使用自旋锁来多次尝试提交！
        userMapper.updateById(user1);
    }
}
```



### 查询操作

```java
@SpringBootTest
class MybatisPlusApplicationTests {
    
    @Autowired
    private UserMapper userMapper;
    //...
    
    // 通过id查询单个用户
    @Test
    public void testSelectById(){
        User user = userMapper.selectById(1L);
        System.out.println(user);
    }

    // 通过id查询多个用户
    @Test
    public void testSelectBatchIds(){
        List<User> users = userMapper.selectBatchIds(Arrays.asList(1L, 2L, 3L));
        users.forEach(System.out::println);
    }

    // 使用map实现单/多条件查询
    @Test
    public void testMap(){
        HashMap<String, Object> map = new HashMap<>();
        map.put("name","Billie");
        map.put("age",24);
        List<User> users = userMapper.selectByMap(map);
        users.forEach(System.out::println);
    }
}
```



### 分页查询

#### 配置插件

<span style="backGround: #efe0b9">com/master/config/MyBatisPlusConfig.java</span>

```java
@EnableTransactionManagement
@Configuration
public class MyBatisPlusConfig {
    
    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        // 乐观锁
        interceptor.addInnerInterceptor(new OptimisticLockerInnerInterceptor());
        // 添加分页(以MYSQL类型为例)
        interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.MYSQL));
        return interceptor;
    }
}
```

#### 测试

```java
@SpringBootTest
class MybatisPlusApplicationTests {
    
    @Autowired
    private UserMapper userMapper;
    //...
    
    @Test
    public void testPage(){
        // 当前页,页面大小
        Page<User> page = new Page<>(1,5);
        userMapper.selectPage(page,null);
        page.getRecords().forEach(System.out::println);
        System.out.println("总页数==>"+page.getTotal());
    }
}
```



### 删除操作

```java
@SpringBootTest
class MybatisPlusApplicationTests {
    
    @Autowired
    private UserMapper userMapper;
    //...
    
    // 根据id删除
    @Test
    public void testDeleteById(){
        userMapper.deleteById(1L);
    }
    
    // 根据id批量删除
    @Test
    public void testDeleteBatchIds(){
      userMapper.deleteBatchIds(Arrays.asList(2L, 2L));
    }
    
    // 使用map实现多条件删除
    @Test
    public void testD(){
        HashMap<String, Object> map = new HashMap<>();
        map.put("age","18");
        map.put("name","lol");
        userMapper.deleteByMap(map);
    }
}
```



### 逻辑删除

使用逻辑删除，可以防止数据直接丢失，作用有点像回收站

> 物理删除：从数据库中直接移除
>
> 逻辑删除：通过一个字段记录状态

#### 添加表字段

![image-20221227180716864](.\img\添加逻辑删字段)

#### 补充标注乐观锁字段

<span style="backGround: #efe0b9">com/master/pojo/User.java</span>

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {

    private Long id;
    private String name;
    private Integer age;
    private String email;

    @Version
    private Integer version;
    
    @TableLogic
    private Integer deleted;
}
```

<span style="color: #f7534f;font-weight:600">@TableLogic</span> 逻辑删除注解

#### 配置逻辑删除值

<span style="backGround: #efe0b9">resources/application.properties</span>

```properties
# 配置逻辑删除
mybatis-plus.global-config.db-config.logic-delete-value=1
mybatis-plus.global-config.db-config.logic-not-delete-value=0
```

#### 测试

- 现在进行删除操作时，实际上执行的是更新语句；

- 而在执行查询操作时，会字段过滤掉逻辑删除为真的记录。



### 条件构造器

```java
@SpringBootTest
class MybatisPlusApplicationTests {
    
    @Autowired
    private UserMapper userMapper;
    //...
    
    @Test
    public void testWrapper1() {
        // 查询name不为空，email不为空，age大于18的用户
        QueryWrapper<User> wrapper = new QueryWrapper<>();
        wrapper
                .isNotNull("name")
                .isNotNull("email")
                .ge("age",18);
        List<User> userList = userMapper.selectList(wrapper);
        userList.forEach(System.out::println);
    }
}
```

> 测试二

```java
@Test
public void testWrapper2() {
    //查询name=wsk的用户
    QueryWrapper<User> wrapper = new QueryWrapper<>();
    wrapper.eq("name","wsk");
    // selectOne: 期待查询出一条记录，若查询出多个会报错
    User user = userMapper.selectOne(wrapper);
    System.out.println(user);
}
```

> 测试三

```java
@Test
public void testWrapper3() {
    //查询age在10-20之间的用户
    QueryWrapper<User> wrapper = new QueryWrapper<>();
    wrapper.between("age", 10, 20);// 区间
    Integer count = userMapper.selectCount(wrapper);
    System.out.println(count);
}
```

> 测试四

```java
@Test
public void testWrapper4() {
    //模糊查询
    QueryWrapper<User> wrapper = new QueryWrapper<>();
    wrapper
        .notLike("name","s")
        .likeRight("email","t");//qq%  左和右？
    List<Map<String, Object>> maps = userMapper.selectMaps(wrapper);
    maps.forEach(System.out::println);
}
```

> 测试五

```java
@Test
public void testWrapper6() {
    QueryWrapper<User> wrapper = new QueryWrapper<>();
    //通过id进行降序排序
    wrapper.orderByDesc("id");
    List<User> userList = userMapper.selectList(wrapper);
    userList.forEach(System.out::println);
}
```

#### 总结

| Mapper方法  | 说明         | 示例类型                  |
| ----------- | ------------ | ------------------------- |
| selectList  | 返回实例数组 | List<User>                |
| selectMaps  | 返回实例map  | List<Map<String, Object>> |
| selectOne   | 返回实例     | User                      |
| selectCount | 返回记录数量 | Integer                   |

:question: 这个方案不利于维护，涉及多表查询时，最好自己写SQL；

:whale: 更多操作见[官方手册](https://baomidou.com/pages/10c804/#notlike)。

#### 实际拓展

>  除了 QueryWrapper，还有 LambdaQueryWrapper 这一操作。

```java
@RestController
public class UserController {
    @Autowired
    private UserMapper userMapper;

    @GetMapping("/queryByName")
    public User queryByName(@RequestParam("name") String name) {
        LambdaQueryWrapper<User> queryWrapper = new LambdaQueryWrapper<>();
        // 通过名字查询用户详情
        queryWrapper.eq(User::getName,name);
        User user = userMapper.selectOne(queryWrapper);
        return user;
    }
}
```

```less
http://localhost:8080/queryByName?name=master
```





## 代码生成

### 所需依赖 

```html
<!--代码生成器-->
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-generator</artifactId>
    <version>最新版本</version>
</dependency>
<!--代码生成器引擎-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-freemarker</artifactId>
</dependency>
<!--swagger相关-->
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
    <version>2.9.2</version>
</dependency>
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger-ui</artifactId>
    <version>2.9.2</version>
</dependency>
```

### 测试例子

```java
@Test
public void test() {
    String finalProjectPath = System.getProperty("user.dir");//获取当前目录

    FastAutoGenerator.create("jdbc:mysql://localhost:3306/ssmbuild?useSSL=true&useUnicode=true&characterEncoding=utf8", "root", "这里输入库密码")
            .globalConfig(builder -> {
                builder.author("master") // 设置作者
                        .enableSwagger() // 开启 swagger 模式
                        .fileOverride() // 覆盖已生成文件
                        .disableOpenDir() //禁止打开输出目录
                        .outputDir(finalProjectPath + "/src/main/java"); // 指定输出目录
            })
            .packageConfig(builder -> {
                builder.parent("com.master") // 设置父包名
                        .moduleName("demo") // 设置父包模块名
                        .entity("entity") //设置entity包名
                        .service("entity")
                        .controller("controller")
                        .pathInfo(Collections.singletonMap(OutputFile.xml, finalProjectPath + "/src/main/resources/mapper")); // 设置mapperXml生成路径
            })
            .strategyConfig(builder -> {
                builder.addInclude("user") // 设置需要生成的表名
                        .addTablePrefix("t_", "c_"); // 设置过滤表前缀
            })
            .templateEngine(new FreemarkerTemplateEngine()) // 使用Freemarker引擎模板，默认的是Velocity引擎模板
            .execute();
}
```

参考官方的[例子一](https://baomidou.com/pages/779a6e/#%E4%BD%BF%E7%94%A8)和[例子二](https://baomidou.com/pages/981406/#freemarker%E6%A8%A1%E7%89%88%E6%94%AF%E6%8C%81-dto-vo%E7%AD%89-%E9%85%8D%E7%BD%AE)以及狂神的[笔记](https://www.kuangstudy.com/bbs/1366329082232467457)



## PageHelper 

辅助分页的插件。

### 导入依赖

> [maven](https://mvnrepository.com/artifact/com.github.pagehelper/pagehelper-spring-boot-starter/1.4.6) 搜索 PageHelper Spring Boot Starter 下载依赖

```html
<!--pageHelper-->
<dependency>
    <groupId>com.github.pagehelper</groupId>
    <artifactId>pagehelper-spring-boot-starter</artifactId>
    <version>1.4.6</version>
</dependency>
```

### 原来测试

```java
@SpringBootTest
class MybatisPlusApplicationTests {
    
    @Autowired
    private UserMapper userMapper;

    @Test
    void contextLoads() {
        List<User> userList = userMapper.selectList(null);
        userList.forEach(System.out::println);
    }
}
```

### 使用测试

`PageHelper.startPage(int pageNum, int pageSize)`相当于开启分页，通过拦截 MySQL 的方式，把查询语句拦截下来加上 limit 语句

```java
@SpringBootTest
class MybatisPlusApplicationTests {
    
    @Autowired
    private UserMapper userMapper;

    @Test
    void contextLoads() {
        PageHelper.startPage(1, 3);
        List<User> userList = userMapper.selectList(null);

        // 遍历结果数组
        userList.forEach(System.out::println);

        PageInfo<User> pageInfo = new PageInfo<>(userList);
        // 打印分页相关信息
        System.out.println(pageInfo);
        // 总记录数
        System.out.println(pageInfo.getTotal());
    }
}
```

### 基础使用

<span style="backGround: #efe0b9">com/master/controller/UserController.java</span>

```java
package com.master.controller;

import java.util.List;

@RestController
public class UserController {
    @Autowired
    private UserMapper userMapper;

    @GetMapping("/wangdazhu")
    public List<User> contextLoads() {
        PageHelper.startPage(1, 3);
        List<User> userList = userMapper.selectList(null);

        PageInfo<User> pageInfo = new PageInfo<>(userList);
        // 返回记录
        return pageInfo.getList();
    }
}
```

### 分页信息封装

#### 封装

<span style="backGround: #efe0b9">com/master/help/RestPageInfo.java</span>

```java
/**
 * 返回给前端的分页信息
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RestPageInfo<T> {
    /**当前页*/
    private int pageNum;
    /**每页的数量*/
    private int pageSize;
    /**当前页的数量*/
    private int size;
    /**总页数*/
    private int pages;
    /**前一页*/
    private int prePage;
    /**下一页*/
    private int nextPage;
    /**数据总数*/
    private long total;
    /**是否有前一页*/
    @Builder.Default
    private boolean hasPreviousPage = false;
    /**是否有下一页*/
    @Builder.Default
    private boolean hasNextPage = false;
    private List<T> list;

    public static <T> RestPageInfo<T> buildRestPageInfo(PageInfo<T> pageInfo) {
        return RestPageInfo.<T>builder()
                .pageNum(pageInfo.getPageNum())
                .pageSize(pageInfo.getPageSize())
                .size(pageInfo.getSize())
                .pages(pageInfo.getPages())
                .prePage(pageInfo.getPrePage())
                .nextPage(pageInfo.getNextPage())
                .hasPreviousPage(pageInfo.isHasPreviousPage())
                .hasNextPage(pageInfo.isHasNextPage())
                .total(pageInfo.getTotal())
                .list(pageInfo.getList())
                .build();
    }
}
```

#### 使用

<span style="backGround: #efe0b9">com/master/controller/UserController.java</span>

```java
@RestController
public class UserController {
    @Autowired
    private UserMapper userMapper;

    @GetMapping("/wangdazhu")
    public RestPageInfo<User> contextLoads() {
        PageHelper.startPage(1, 3);
        List<User> userList = userMapper.selectList(null);
        PageInfo<User> pageInfo = new PageInfo<>(userList);

        return RestPageInfo.buildRestPageInfo(pageInfo);
    }
}
```

```less
http://localhost:8080/wangdazhu?name=a
```



### 封装&查询&排序&分页

有name参数时，模糊查询；

根据age排序；

获取第一页，十条数据；

<span style="backGround: #efe0b9">com/master/controller/UserController.java</span>

```java
@RestController
public class UserController {
    @Autowired
    private UserMapper userMapper;

    @GetMapping("/wangdaniu")
    public RestPageInfo<User> contextLoads2(User requestInfo) {

        PageInfo<User> pageInfo = PageMethod.startPage(1, 10)
            .doSelectPageInfo(() -> userMapper.selectList(Wrappers.<User>lambdaQuery()
                    .like(com.baomidou.mybatisplus.core.toolkit.StringUtils.isNotEmpty(requestInfo.getName()), User::getName, requestInfo.getName())
                    .orderByDesc(User::getAge)
            ));

        return RestPageInfo.buildRestPageInfo(pageInfo);
    }
}
```

```less
http://localhost:8080/wangdaniu?name=a
```

:trident: 获取前端传参的方式见 SpringMVC 的 接收请求参数&传参给前端。



### 完整响应架构

#### 响应结果封装

<span style="backGround: #efe0b9">com/master/help/RestResult.java</span>

```java
package com.master.help;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.*;

@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@ApiModel(value = "响应信息主体")
public class RestResult<T> {

    @ApiModelProperty(value = "返回标记：成功标记=200，失败标记=500")
    private int errcode;

    @ApiModelProperty(value = "返回信息")
    private String errmsg;

    @ApiModelProperty(value = "数据")
    private T data;

    @AllArgsConstructor
    public enum CodeEnum {
        SUCCESS(200, "ok"),
        ERROR(500, "error");
        @Getter
        private final int value;
        @Getter
        private final String description;
    }

    public static <T> RestResult<T> success() {
        return restResult(CodeEnum.SUCCESS.value, CodeEnum.SUCCESS.description, null);
    }

    public static <T> RestResult<T> success(T data) {
        return restResult(CodeEnum.SUCCESS.value, CodeEnum.SUCCESS.description, data);
    }

    public static <T> RestResult<T> success(String msg, T data) {
        return restResult(CodeEnum.SUCCESS.value, msg, data);
    }

    public static <T> RestResult<T> error(String msg) {
        return restResult(CodeEnum.ERROR.value, msg, null);
    }

    public static <T> RestResult<T> error(int code, String msg, T data) {
        return restResult(code, msg, data);
    }

    public static <T> RestResult<T> error(int code, String msg) {
        return restResult(code, msg, null);
    }


    private static <T> RestResult<T> restResult(int code, String msg, T data) {
        return RestResult.<T>builder()
                .errcode(code)
                .errmsg(msg)
                .data(data)
                .build();
    }
}
```

#### 使用

<span style="backGround: #efe0b9">com/master/controller/UserController.java</span>

```java
@RestController
public class UserController {
    @PostMapping("/cepost2")
    public RestResult<RestPageInfo<User>> contextLoads3(@RequestBody User requestInfo) {

        PageInfo<User> pageInfo = PageMethod.startPage(1, 10)
                .doSelectPageInfo(() -> userMapper.selectList(Wrappers.<User>lambdaQuery()
                        .like(com.baomidou.mybatisplus.core.toolkit.StringUtils.isNotEmpty(requestInfo.getName()), User::getName, requestInfo.getName())
                        .orderByDesc(User::getAge)
                ));

        RestPageInfo<User> data = RestPageInfo.buildRestPageInfo(pageInfo);


        return RestResult.success(data);
    }
}
```



## 业务实际拓展

### 前提

<span style="backGround: #efe0b9">com/master/controller/UserController.java</span>

```java
@RestController
public class UserController {
    @Autowired
    private UserMapper userMapper;

    // 基于这里写方法，可能会用到前面的一些封装工具类
}
```



### 添加&前置条件&或条件

> 添加用户，需要先校验字段的非空性，以及名称、邮箱不能跟数据库里重复。

<span style="backGround: #efe0b9">com/master/controller/UserController.java</span>

```java
@PostMapping("/testAdd")
public String testAdd(@RequestBody User requestInfo) {
    QueryWrapper<User> wrapper = new QueryWrapper<>();
    if(StringUtils.isBlank(requestInfo.getName())){
        System.out.println("名称不能为空");
        return "名称不能为空";
    }
    if(StringUtils.isBlank(requestInfo.getEmail())){
        System.out.println("邮箱不能为空");
        return "邮箱不能为空";
    }
    if(requestInfo.getAge() == null){
        System.out.println("年龄不能为空");
        return "年龄不能为空";
    }
    wrapper.eq("name", requestInfo.getName())
            .or()
            .eq("age", requestInfo.getAge());

    List<User> userList = userMapper.selectList(wrapper);
    if(userList.size() > 0){
        System.out.println("年龄或名称重复");
        return "年龄或名称重复";
    }
    userMapper.insert(requestInfo);
    return "成功";
}
```



### 多情况判断&新增

在上一个例子的基础上，给出更具体地报错信息；

通过再次创建对象，手动重置 id，允许前端在新建时传递 id。。又好像没什么用

<span style="backGround: #efe0b9">com/master/pojo/User.java</span>

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class User {

    @TableId(type=IdType.NONE)
    private Long id;
    private String name;
    private Integer age;
    private String email;

    @Version
    private Integer version;

    @TableLogic
    private Integer deleted;

    // 添加
    public static User buildUser(User user) {
        return User.builder().id(user.getId())
                .name(user.getName())
                .age(user.getAge())
                .email(user.getEmail())
                .build();
    }
}
```

<span style="backGround: #efe0b9">com/master/controller/UserController.java</span>

```java
@PostMapping("/testAdd2")
public String testAdd2(@RequestBody User requestInfo) {
    QueryWrapper<User> wrapper = new QueryWrapper<>();
    QueryWrapper<User> wrapper2 = new QueryWrapper<>();
    if(StringUtils.isBlank(requestInfo.getName())){
        System.out.println("名称不能为空");
        return "名称不能为空";
    }
    if(StringUtils.isBlank(requestInfo.getEmail())){
        System.out.println("邮箱不能为空");
        return "邮箱不能为空";
    }
    if(requestInfo.getAge() == null){
        System.out.println("年龄不能为空");
        return "年龄不能为空";
    }
    wrapper.eq("name", requestInfo.getName());
    List<User> userList = userMapper.selectList(wrapper);
    if(userList.size() > 0){
        System.out.println("名称重复");
        return "名称重复";
    }

    wrapper2.eq("age", requestInfo.getAge());
    List<User> userList2 = userMapper.selectList(wrapper2);
    if(userList2.size() > 0){
        System.out.println("年龄重复");
        return "年龄重复";
    }
    User user = User.buildUser(requestInfo);
    user.setId(null);
    userMapper.insert(user);
    return "成功";
}
```



### 多情况判断&编辑

<span style="backGround: #efe0b9">com/master/controller/UserController.java</span>

```java
@PostMapping("/testEdit")
public String testEdit(@RequestBody User requestInfo) {
    QueryWrapper<User> wrapper = new QueryWrapper<>();
    QueryWrapper<User> wrapper2 = new QueryWrapper<>();
    if(StringUtils.isBlank(requestInfo.getName())){
        System.out.println("名称不能为空");
        return "名称不能为空";
    }
    if(StringUtils.isBlank(requestInfo.getEmail())){
        System.out.println("邮箱不能为空");
        return "邮箱不能为空";
    }
    if(requestInfo.getAge() == null){
        System.out.println("年龄不能为空");
        return "年龄不能为空";
    }
    // 先排除本条记录
    wrapper.ne("id", requestInfo.getId());
    wrapper.eq("name", requestInfo.getName());
    List<User> userList = userMapper.selectList(wrapper);
    if(userList.size() > 0){
        System.out.println("名称重复");
        return "名称重复";
    }

    // 先排除本条记录
    wrapper2.ne("id", requestInfo.getId());
    wrapper2.eq("age", requestInfo.getAge());
    List<User> userList2 = userMapper.selectList(wrapper2);
    if(userList2.size() > 0){
        System.out.println("年龄重复");
        return "年龄重复";
    }
    User user = User.buildUser(requestInfo);
    user.setId(null);
    userMapper.insert(user);
    return "成功";
}
```



### 分页&转lambda

>  将 QueryWrapper 和 lambda 结合使用。

```java
@GetMapping("/wangdaniu5")
public List<User> contextLoads5(User requestInfo) {

    PageHelper.startPage(1, 3);
    QueryWrapper<User> wrapper = new QueryWrapper<>();
    wrapper.lambda()
            .like((com.baomidou.mybatisplus.core.toolkit.StringUtils.isNotEmpty(requestInfo.getName())), User::getName, requestInfo.getName())
            .orderByDesc(User::getAge);

    List<User> userList = userMapper.selectList(wrapper);

    return userList;
}
```



### 判断是否存在相同名称项目

> 在满足状态的项目中进行查找

```java
@Resource
private ProjectMapper projectMapper;

@Override
public boolean checkName(String name){
    List<String> status = new ArrayList<>();
    boolean isExist = false;
    status.add(ProjectInfo.Status.INITIATED.getValue());
    status.add(ProjectInfo.Status.PROCESSING.getValue());
    status.add(ProjectInfo.Status.APPROVED.getValue());
    if (!CollectionUtils.isEmpty(projectMapper.selectList
            (Wrappers.<ProjectInfo>lambdaQuery()
                    .eq(ProjectInfo::getProjectName, projectName)
                    .in(ProjectInfo::getStatus, status)))) {
        isExist = true;
    }
    return isExist;
}
```



### 多条件分页查询

```java
@Resource
private DemoMapper demoMapper;

@Override
public RestPageInfo<DonateOrder> search(Request request) {
    // (略)根据查询条件获取到oid
    Integer oid = null;

    //构建查询条件
    QueryWrapper<DonateOrder> wrapper = new QueryWrapper<>();
    wrapper.lambda()
            .eq(Objects.nonNull(sid), DonateOrder::getSomeId, sid)
            .like(StringUtils.isNotBlank(request.getDonorName()), DonateOrder::getDonorName, request.getDonorName())
            .like(StringUtils.isNotBlank(request.getMobile()), DonateOrder::getMobile, request.getMobile())
            .ge(request.getCreateTimeStart() != null, DonateOrder::getCreateTime, request.getCreateTimeStart())
            .le(request.getCreateTimeEnd() != null, DonateOrder::getCreateTime, request.getCreateTimeEnd())
            .eq(StringUtils.isNotBlank(request.getPayChannelCode()), DonateOrder::getPayChannelCode, request.getPayChannelCode())
            .eq(StringUtils.isNotBlank(request.getOrderStatus()), DonateOrder::getOrderStatus, request.getOrderStatus())
            .like(StringUtils.isNoneBlank(request.getProjectName()), DonateOrder::getProjectName, request.getProjectName())
            .orderByDesc(DonateOrder::getCreateTime);

    // 分页查询
    PageInfo<DonateOrder> pageInfo = PageMethod.startPage(request.getPage(), request.getPageSize())
            .doSelectPageInfo(() -> demoMapper.selectList(wrapper));
    return RestPageInfo.buildRestPageInfo(pageInfo);
}
```

| 查询方法 | 说明                                         |
| -------- | -------------------------------------------- |
| 参数一   | 布尔值，是否生效                             |
| 参数二   | 非 lambda 时，为表字段名，lambada 时格式固定 |
| 参数三   | 输入的值，一般就是传参的某个属性             |

| 其它方法                       | 说明                                              | 属于       |
| ------------------------------ | ------------------------------------------------- | ---------- |
| Objects.nonNull                | 非空时返回 true                                   | 自带工具类 |
| StringUtils.isNotBlank         | 判断某字符串是否不为空且长度不为0且不由空白符构成 | 自带工具类 |
| StringUtils.isNotEmpty         | 判断某字符串是否非空                              | 自带工具类 |
| RestPageInfo.buildRestPageInfo | 用于包装成分页响应结构                            | 自己写的   |



  





