

SprilngMVC 是是基于servlet做web 开发的 request（请求） 转发分配 调用

## 准备环境

- 新建一个普通的 maven 项目

- 删除src目录

- 新增模块，使用 <span style="color: #a50">maven-archetype-webapp</span>

- 在父模块管理依赖

<span style="backGround: #efe0b9">pom.xml</span>

```html
<dependencies>
    <!--单元测试-->
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.12</version>
    </dependency>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-webmvc</artifactId>
        <version>5.1.9.RELEASE</version>
    </dependency>
    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>servlet-api</artifactId>
        <version>2.5</version>
    </dependency>
    <!--JSP依赖-->
    <dependency>
        <groupId>javax.servlet.jsp</groupId>
        <artifactId>jsp-api</artifactId>
        <version>2.2</version>
    </dependency>
    <!--JSTL表达式依赖-->
    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>jstl</artifactId>
        <version>1.2</version>
    </dependency>
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <version>1.18.12</version>
    </dependency>
</dependencies>

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



## 深入SpringMVC学习

### 准备JSP

<span style="backGround: #efe0b9">src/main/webapp/WEB-INF/jsp/test.jsp</span>

```html
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<body>
  <h2>Hello World!</h2>
  <p> ${msg} </p>
</body>
</html>
```

### 配置DispatchServlet

<span style="backGround: #efe0b9">src/main/webapp/WEB-INF/web.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
       http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">

  <!--配置DispatchServlet,这是SpringMVC的核心：请求分发器，前端控制器-->
  <servlet>
    <servlet-name>springmvc</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <!--需要连接的配置文件-->
    <init-param>
      <param-name>contextConfigLocation</param-name>
      <param-value>classpath:springmvc-servlet.xml</param-value>
    </init-param>
    <!--启动级别-->
    <load-on-startup>1</load-on-startup>
  </servlet>

  <servlet-mapping>
    <servlet-name>springmvc</servlet-name>
    <url-pattern>/</url-pattern>
  </servlet-mapping>

</web-app>
```

<span style="color: #ed5a65">启动级别</span>：目前的配置可以让服务器一启动就启动springMVC

<span style="color: #ed5a65">SpringMVC中的路径</span>：

- /  匹配所有请求，但不匹配jsp页面

- /* 匹配所有请求和jsp页面



### 配置中间链路

<span style="backGround: #efe0b9">resources/springmvc-servlet.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <!--处理器映射器-->
    <bean class="org.springframework.web.servlet.handler.BeanNameUrlHandlerMapping"/>
    <!--处理器适配器-->
    <bean class="org.springframework.web.servlet.mvc.SimpleControllerHandlerAdapter"/>
    <!--视图解析器-->
    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver" id="InternalResourceViewResolver">
        <!--匹配文件规则：前缀-->
        <property name="prefix" value="/WEB-INF/jsp/"/>
        <!--匹配文件规则：后缀-->
        <property name="suffix" value=".jsp"/>
    </bean>

    <!--需要处理的bean-->
    <bean id="/hello" class="com.master.controller.HelloController"/>

</beans>
```

| 配置         | 说明                                            |
| ------------ | ----------------------------------------------- |
| 处理器映射器 | 读取路径(bean.id)                               |
| 处理器适配器 | 读取对应路径的文件(bean.class)，该文件会返回 mv |
| 视图解析器   | 根据 mv 匹配到对应的视图层文件                  |



### 举个例子

<span style="backGround: #efe0b9">com/master/controller/HelloController.java</span>

```java
public class HelloController implements Controller {
    @Override
    public ModelAndView handleRequest(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {
    
        ModelAndView mv = new ModelAndView();

        // 业务代码
        String result = "HelloSpringMVC";
        mv.addObject("msg", result);

        // 视图跳转(这里提供给的视图解析器)
        mv.setViewName("test");

        return mv;
    }
}
```



## 使用注解开发

注解开发， SpringMVC 的三大配置，处理器映射器、处理器适配器、视图解析器，只需要处理视图解析器即可。

### 准备JSP

<span style="backGround: #efe0b9">src/main/webapp/WEB-INF/jsp/hello.jsp</span>

```html
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<body>
  <h2>Hello World!</h2>
  <p> ${msg} </p>
</body>
</html>
```

### 配置DispatchServlet

<span style="backGround: #efe0b9">src/main/webapp/WEB-INF/web.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
       http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">

  <!--1.注册servlet-->
  <servlet>
    <servlet-name>SpringMVC</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <!--需要连接的配置文件-->
    <init-param>
      <param-name>contextConfigLocation</param-name>
      <param-value>classpath:springmvc-servlet.xml</param-value>
    </init-param>
    <!--启动级别，数字越小，启动越早-->
    <load-on-startup>1</load-on-startup>
  </servlet>
    
  <!--所有请求都会被springmvc拦截-->
  <servlet-mapping>
    <servlet-name>SpringMVC</servlet-name>
    <url-pattern>/</url-pattern>
  </servlet-mapping>

</web-app>
```



### 配置中间链路

<span style="backGround: #efe0b9">resources/springmvc-servlet.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/context
       https://www.springframework.org/schema/context/spring-context.xsd
       http://www.springframework.org/schema/mvc
       https://www.springframework.org/schema/mvc/spring-mvc.xsd">

    <!-- ① -->
    <context:component-scan base-package="com.master.controller"/>
    <!-- ② -->
    <mvc:default-servlet-handler />
    <!-- ③ -->
    <mvc:annotation-driven />

    <!-- 视图解析器 -->
    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver"
          id="internalResourceViewResolver">
        <!-- 前缀 -->
        <property name="prefix" value="/WEB-INF/jsp/" />
        <!-- 后缀 -->
        <property name="suffix" value=".jsp" />
    </bean>

</beans>
```

| 配置 | 说明                                               |
| ---- | -------------------------------------------------- |
| ①    | 自动扫描包，让指定包下的注解生效,由IOC容器统一管理 |
| ②    | 让Spring MVC不处理静态资源                         |
| ③    | 支持mvc注解驱动                                    |



### 举个例子

<span style="backGround: #efe0b9">com/master/controller/HelloController.java</span>

```java
@Controller
public class HelloController {

    // localhost:8080/hello
    @RequestMapping("/hello")
    public String hello(Model model) {
        // 封装数据
        model.addAttribute("msg", "demo123");
        // 会被视图解析器处理
        return "hello";
    }
}
```

<span style="color: #f7534f;font-weight:600">@Controller</span> 代表将类注册到 Spring 中，装配Bean

<span style="color: #f7534f;font-weight:600">@Controller</span> 该注解的类下的所有方法，如果返回值是 String，且有对应的页面可跳转，就会被视图解析器解析

<span style="color: #f7534f;font-weight:600">@RequestMapping</span> 代表映射路径

```java
@Controller
@RequestMapping("/hello")
public class HelloController {

    // localhost:8080/hello/demo
    @RequestMapping("/demo")
    public String hello(Model model) {
        // 封装数据
        model.addAttribute("msg", "demo123");
        // 会被视图解析器处理
        return "hello";
    }
}
```

<span style="color: #f7534f;font-weight:600">@RequestMapping</span> 可以用于类和方法上，此时需要将路径拼接起来。



## RestFul风格

### 路径风格

```java
// 普通风格
localhost:8080/home?type=1&name=demo

// RestFul风格
localhost:8080/home/1/demo
```

### 操作资源风格

```java
/* 传统方式（方法单一，post和get）*/
// 查询（GET）
localhost:8080/item/queryItem.action?id=1   
// 新增（POST）
localhost:8080/item/saveItem.action
// 更新（POST）
localhost:8080/item/updateItem.action
// 删除（GET/POST）
localhost:8080/item/deleteItem.action?id=1

/* RestFul风格 */
// 查询（GET）
localhost:8080/item/1
// 新增（POST）
localhost:8080/item
// 更新（PUT）
localhost:8080/item
// 删除（DELETE）
localhost:8080/item/1
```

### 程序中的体现

<span style="backGround: #efe0b9">com/master/controller/RestFulController.java</span>

```java
@Controller
public class RestFulController {
    @RequestMapping("/add")
    public String test1(int a, int b, Model model) {
        System.out.println(a + b);
        return "test";
    }
    
    @RequestMapping("/add/{a}/{b}")
    public String test2(@PathVariable int a, @PathVariable int b, Model model) {
        System.out.println(a + b);
        return "test";
    }
}
```

<span style="color: #f7534f;font-weight:600">@PathVariable</span> 可以改变获取参数的方式，从路径获取

```java
// test1
http://localhost:8080/add?a=1&b=2

// test2
http://localhost:8080/add/1/2
```

### 指定请求方法

其它请求方法是类似的

```java
// 能匹配所有方法
@RequestMapping("/add/{a}/{b}")

// 下面两个注解都可以添加到方法上，且等价
@RequestMapping(value="/add/{a}/{b}", method = RequestMethod.GET)
    
@GetMapping("/add/{a}/{b}")
```



## 重定向和转发

1. 将视图解析器注释（会拼接前后缀）

<span style="backGround: #efe0b9">resources/springmvc-servlet.xml</span>

2. 写方法

<span style="backGround: #efe0b9">com/master/controller/ModelTest.java</span>

```java
@Controller
public class ModelTest {
    // 转发
    @RequestMapping("/demo")
    public String test1() {
        return "/WEB-INF/jsp/test.jsp";
    }
    // 转发
    @RequestMapping("/demo2")
    public String test2() {
        return "forward:/WEB-INF/jsp/test.jsp";
    }
    // 重定向
    @RequestMapping("/demo3")
    public String test3() {
        return "redirect:/index.jsp";
    }
}
```



## 接收请求参数&传参给前端

### 转换参数名

```elm
http://localhost:8080/user/t1?username=demo
```

<span style="backGround: #efe0b9">com/master/controller/UserController.java</span>

```java
@Controller
@RequestMapping("/user")
public class UserController {
    @GetMapping("/t1")
    public String test1(@RequestParam("username") String name, Model model) {
        System.out.println(name);
        // 传参给前端
        model.addAttribute("msg", name);
        return "test";
    }
}
```

@RequestParam 表面该参数从前端获取，可以转别名，并在错误响应给出提醒。



### 对象接收参数

#### 新建类

<span style="backGround: #efe0b9">com/master/pojo/User.java</span>

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {
    private int id;
    private String name;
    private int age;
}
```

#### 控制层

<span style="backGround: #efe0b9">com/master/controller/UserController.java</span>

```java
@Controller
@RequestMapping("/user")
public class UserController {

    @GetMapping("/t2")
    public String test2(User user) {
        System.out.println(user);
        return "test";
    }
}
```

#### 测试

```less
http://localhost:8080/user/t2?id=1&name=demo&age=3

// 后台输出结果
User(id=1, name=demo, age=3)
```

```less
http://localhost:8080/user/t2?id=1&username=demo&age=3

// 后台输出结果
User(id=1, name=null, age=3)
```



### post-接收参数

```java
@PostMapping("/cepost")
public void contextLoads3(@RequestBody User user) {
	System.out.println(user.getName());
}
```

:whale: 可以用 postman 测试，发送 json 格式；

:ghost: 与 get 请求接收对象的反应类似，没有传递的某个参数，对应的对象属性为 null。





## 解决乱码问题

<span style="backGround: #efe0b9">src/main/webapp/WEB-INF/web.xml</span>

```html
<!--解决SpringMVC的中文乱码问题-->
<filter>
    <filter-name>encoding</filter-name>
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
    <init-param>
        <param-name>encoding</param-name>
        <param-value>utf-8</param-value>
    </init-param>
</filter>
<filter-mapping>
    <filter-name>encoding</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```



## Json

### 返回json&解决乱码

#### 导入依赖

<span style="backGround: #efe0b9">pom.xml</span>

```html
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.10.0</version>
</dependency>
```

#### 新建类

<span style="backGround: #efe0b9">com/master/pojo/User.java</span>

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {
    private int id;
    private String name;
    private int age;
}
```

#### 控制层

<span style="backGround: #efe0b9">com/master/controller/UserController.java</span>

```java
@Controller
public class UserController {

    @RequestMapping(value = "/j1", produces = "application/json;charset=utf-8")
    @ResponseBody
    public String json1() throws JsonProcessingException {
        // 新建工具类
        ObjectMapper mapper = new ObjectMapper();
        // 创建对象
        User user = new User(2, "demo", 3);
        // 将值转化为json格式
        String str = mapper.writeValueAsString(user);
        return str;
    }
}
```

<span style="color: #f7534f;font-weight:600">@ResponseBody</span> 在方法上使用后，表示不会走视图解析器，方法将直接返回字符串；

<span style="color: #f7534f;font-weight:600">@RequestMapping</span> 可以传入produces参数来解决中文乱码问题。

```java
@RestController
public class UserController {

    @RequestMapping(value = "/j1", produces = "application/json;charset=utf-8")
    public String json1() throws JsonProcessingException {
        // 新建工具类
        ObjectMapper mapper = new ObjectMapper();
        // 创建对象
        User user = new User(2, "demo", 3);
        // 将值转化为json格式
        String str = mapper.writeValueAsString(user);
        return str;
    }
}
```

<span style="color: #f7534f;font-weight:600">@RestController</span> 在类上使用后，表示它的方法不会走视图解析器，方法将直接返回字符串；



#### 统一解决乱码

逐个增加注解参数会很麻烦，可以给 SpringMVC 设置统一处理的配置。

<span style="backGround: #efe0b9">resources/springmvc-servlet.xml</span>

```html
<beans ...>   
    <!-- ... ->  
	<!--解决json乱码问题-->
    <mvc:annotation-driven>
        <mvc:message-converters register-defaults="true">
            <bean class="org.springframework.http.converter.StringHttpMessageConverter">
                <constructor-arg value="UTF-8"/>
            </bean>
            <bean class="org.springframework.http.converter.json.MappingJackson2HttpMessageConverter">
                <property name="objectMapper">
                    <bean class="org.springframework.http.converter.json.Jackson2ObjectMapperFactoryBean">
                        <property name="failOnEmptyBeans" value="false"/>
                    </bean>
                </property>
            </bean>
        </mvc:message-converters>
    </mvc:annotation-driven>
<beans/>
```



### 返回日期示例

```java
@RequestMapping("/j3")
public String json3() throws JsonProcessingException {
    ObjectMapper mapper = new ObjectMapper();
    return mapper.writeValueAsString(new Date());
}

@RequestMapping("/j4")
public String json4() throws JsonProcessingException {
    ObjectMapper mapper = new ObjectMapper();

    Date date = new Date();
    // 自定义日期格式
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    return mapper.writeValueAsString(mapper.writeValueAsString(sdf.format(date)));
}

@RequestMapping("/j5")
public String json5() throws JsonProcessingException {
    ObjectMapper mapper = new ObjectMapper();
    mapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);

    Date date = new Date();

    return mapper.writeValueAsString(date);
}
```

- j3：对应时间戳
- j4：原生Java转格式 "yyyy-MM-dd HH:mm:ss"
- j4：工具类转格式 "yyyy-MM-dd HH:mm:ss"



### FastJson三方工具

**导包**

<span style="backGround: #efe0b9">pom.xml</span>

```html
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>fastjson</artifactId>
    <version>1.2.60</version>
</dependency>
```

**使用**

```java
/* Java对象 => JSON字符串 */
String str1 = JSON.toJSONString(target)
    
/* JSON字符串 => Java对象 */
User user = JSON.parseObject(target, User.class)
    
/* Java对象 => JavaScript对象 */
JSONObject jsonObject = (JSONObject) JSON.toJSON(user);
    
/* JavaScript对象 => Java对象 */
User user = JSON.toJavaObject(target, User.class);
```



## 整合SSM框架

### Mybatis层

#### 数据库环境

创建一个存放书籍数据的数据库表

```sql
CREATE DATABASE `ssmbuild`;

USE `ssmbuild`;

DROP TABLE IF EXISTS `books`;

CREATE TABLE `books` (
`bookID` INT(10) NOT NULL AUTO_INCREMENT COMMENT '书id',
`bookName` VARCHAR(100) NOT NULL COMMENT '书名',
`bookCounts` INT(11) NOT NULL COMMENT '数量',
`detail` VARCHAR(200) NOT NULL COMMENT '描述',
KEY `bookID` (`bookID`)
) ENGINE=INNODB DEFAULT CHARSET=utf8

INSERT  INTO `books`(`bookID`,`bookName`,`bookCounts`,`detail`)VALUES
(1,'Java',1,'从入门到放弃'),
(2,'MySQL',10,'从删库到跑路'),
(3,'Linux',5,'从进门到进牢');
```



#### 基本环境搭建

创建 maven 项目，新建子模块添加web的支持

##### 导入依赖

<span style="backGround: #efe0b9">pom.xml</span>

```html
<dependencies>
   <!--Junit-->
   <dependency>
       <groupId>junit</groupId>
       <artifactId>junit</artifactId>
       <version>4.12</version>
   </dependency>
   <!--数据库驱动-->
   <dependency>
       <groupId>mysql</groupId>
       <artifactId>mysql-connector-java</artifactId>
       <version>5.1.47</version>
   </dependency>
   <!-- 数据库连接池 -->
   <dependency>
       <groupId>com.mchange</groupId>
       <artifactId>c3p0</artifactId>
       <version>0.9.5.2</version>
   </dependency>

   <!--Servlet - JSP -->
   <dependency>
       <groupId>javax.servlet</groupId>
       <artifactId>servlet-api</artifactId>
       <version>2.5</version>
   </dependency>
   <dependency>
       <groupId>javax.servlet.jsp</groupId>
       <artifactId>jsp-api</artifactId>
       <version>2.2</version>
   </dependency>
   <dependency>
       <groupId>javax.servlet</groupId>
       <artifactId>jstl</artifactId>
       <version>1.2</version>
   </dependency>

   <!--Mybatis-->
   <dependency>
       <groupId>org.mybatis</groupId>
       <artifactId>mybatis</artifactId>
       <version>3.5.2</version>
   </dependency>
   <dependency>
       <groupId>org.mybatis</groupId>
       <artifactId>mybatis-spring</artifactId>
       <version>2.0.2</version>
   </dependency>

   <!--Spring-->
   <dependency>
       <groupId>org.springframework</groupId>
       <artifactId>spring-webmvc</artifactId>
       <version>5.1.9.RELEASE</version>
   </dependency>
   <dependency>
       <groupId>org.springframework</groupId>
       <artifactId>spring-jdbc</artifactId>
       <version>5.1.9.RELEASE</version>
   </dependency>
    <!--lombok-->
   <dependency>
       <groupId>org.projectlombok</groupId>
       <artifactId>lombok</artifactId>
       <version>1.18.12</version>
   </dependency>
</dependencies>
```

##### 资源过滤设置

<span style="backGround: #efe0b9">pom.xml</span>

```html
<build>
   <resources>
       <resource>
           <directory>src/main/java</directory>
           <includes>
               <include>**/*.properties</include>
               <include>**/*.xml</include>
           </includes>
           <filtering>false</filtering>
       </resource>
       <resource>
           <directory>src/main/resources</directory>
           <includes>
               <include>**/*.properties</include>
               <include>**/*.xml</include>
           </includes>
           <filtering>false</filtering>
       </resource>
   </resources>
</build>
```

##### 基本结构和配置框架

- com.master.pojo

- com.master.dao

- com.master.service

- com.master.controller

- resources/mybatis-config.xml

  ```html
  <?xml version="1.0" encoding="UTF-8" ?>
  <!DOCTYPE configuration
         PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
         "http://mybatis.org/dtd/mybatis-3-config.dtd">
  <configuration>
  
  </configuration>
  ```

- resources/applicationContext.xml

  ```html
  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.springframework.org/schema/beans
         http://www.springframework.org/schema/beans/spring-beans.xsd">
  
  </beans>
  ```



#### Mybatis层编写

##### 数据库配置文件

<span style="backGround: #efe0b9">resources/database.properties</span>

```elm
jdbc.driver=com.mysql.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/ssmbuild?useSSL=true&useUnicode=true&characterEncoding=utf8
jdbc.username=root
jdbc.password=xxx
```

:octopus: 如果使用的是 MySQL8.0+，<span style="color: #a50">jdbc.url</span>后还需要添加时区配置，如 `&serverTimezone=Asia/Shanghai`



##### 配置别名

<span style="backGround: #efe0b9">resources/mybatis-config.xml</span>

```html
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    
    <settings>
        <setting name="logIml" value="STDOUT_LOGGING"/>
    </settings>
    
    <typeAliases>
        <package name="com.master.pojo"/>
    </typeAliases>

</configuration>
```

这个文件注意负责配置别名，注册 mapper，也能配日志等。



##### 新建实体类

<span style="backGround: #efe0b9">com/master/pojo/Books.java</span>

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Books {
    private int bookID;
    private String bookName;
    private int bookCounts;
    private String detail;
}
```



##### Dao-接口

<span style="backGround: #efe0b9">com/master/dao/BookMapper.java</span>

```java
public interface BookMapper {
    // 增加一本书
    int addBook(Books books);
    // 删除一本书
    int deleteBookById(@Param("bookId") int id);
    // 更新一本书
    int updateBook(Books books);
    // 查询一本书
    Books queryBookById(@Param("bookId") int id);
    // 查询全部的书
    List<Books> queryAllBook();
}
```



##### Dao-xml

<span style="backGround: #efe0b9">com/master/dao/BookMapper.xml</span>

```html
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.master.dao.BookMapper">

    <insert id="addBook" parameterType="Books">
        insert into ssmbuild.books (bookName, bookCounts, detail)
        values (#{bookName}, #{bookCounts}, #{detail});
    </insert>

    <delete id="deleteBookById" parameterType="int">
        delete from ssmbuild.books
        where bookID = #{bookId}
    </delete>

    <update id="updateBook" parameterType="Books">
        update ssmbuild.books
        set bookName=#{bookName}, bookCounts=#{bookCounts}, detail=#{detail}
        where bookId=#{bookId};
    </update>

    <select id="queryBookById" resultType="Books">
        select * from ssmbuild.books
        where bookID = #{bookId}
    </select>

    <select id="queryAllBook" resultType="Books">
        select * from ssmbuild.books
    </select>

</mapper>
```



##### 注册xml

<span style="backGround: #efe0b9">resources/mybatis-config.xml</span>

```html
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    
    <typeAliases>
        <package name="com.master.pojo"/>
    </typeAliases>
    
    <mappers>
        <mapper class="com.master.dao.BookMapper"/>
    </mappers>

</configuration>
```



##### Service-接口

<span style="backGround: #efe0b9">com/master/service/BookService.java</span>

```java
public interface BookService {
    // 增加一本书
    int addBook(Books books);
    // 删除一本书
    int deleteBookById(int id);
    // 更新一本书
    int updateBook(Books books);
    // 查询一本书
    Books queryBookById(int id);
    // 查询全部的书
    List<Books> queryAllBook();
}
```



##### Service-类实现

<span style="backGround: #efe0b9">com/master/service/BookServiceImpl.java</span>

```java
public class BookServiceImpl implements BookService {

    private BookMapper bookMapper;
    public BookServiceImpl(BookMapper bookMapper) {
        this.bookMapper = bookMapper;
    }

    public int addBook(Books books) {
        return bookMapper.addBook(books);
    }

    public int deleteBookById(int id) {
        return bookMapper.deleteBookById(id);
    }

    public int updateBook(Books books) {
        return bookMapper.updateBook(books);
    }

    public Books queryBookById(int id) {
        return bookMapper.queryBookById(id);
    }

    public List<Books> queryAllBook() {
        return bookMapper.queryAllBook();
    }
}
```

:hammer_and_wrench: 业务层，直接调用 Dao 层。



### Spring层编写

#### 连接池相关

<span style="backGround: #efe0b9">resources/spring-dao.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/context
       https://www.springframework.org/schema/context/spring-context.xsd">

    <!-- 配置整合mybatis -->
    <!-- 1.关联数据库文件 -->
    <context:property-placeholder location="classpath:database.properties"/>

    <!-- 2.数据库连接池 -->
    <bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource">
        <!-- 配置连接池属性 -->
        <property name="driverClass" value="${jdbc.driver}"/>
        <property name="jdbcUrl" value="${jdbc.url}"/>
        <property name="user" value="${jdbc.username}"/>
        <property name="password" value="${jdbc.password}"/>

        <!-- c3p0连接池的私有属性 -->
        <property name="maxPoolSize" value="30"/>
        <property name="minPoolSize" value="10"/>
        <!-- 关闭连接后不自动commit -->
        <property name="autoCommitOnClose" value="false"/>
        <!-- 获取连接超时时间 -->
        <property name="checkoutTimeout" value="10000"/>
        <!-- 当获取连接失败重试次数 -->
        <property name="acquireRetryAttempts" value="2"/>
    </bean>

    <!-- 3.配置SqlSessionFactory对象 -->
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <!-- 注入数据库连接池 -->
        <property name="dataSource" ref="dataSource"/>
        <!-- 配置MyBaties全局配置文件:mybatis-config.xml -->
        <property name="configLocation" value="classpath:mybatis-config.xml"/>
    </bean>

    <!-- 4.配置扫描Dao接口包，动态实现Dao接口注入到spring容器中 -->
    <!--解释 ：https://www.cnblogs.com/jpfss/p/7799806.html-->
    <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
        <!-- 注入sqlSessionFactory -->
        <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory"/>
        <!-- 给出需要扫描Dao接口包 -->
        <property name="basePackage" value="com.master.dao"/>
    </bean>

</beans>
```

数据源使用c3p0连接池

#### 整合service层

<span style="backGround: #efe0b9">resources/spring-service.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:context="http://www.springframework.org/schema/context"
      xsi:schemaLocation="http://www.springframework.org/schema/beans
   http://www.springframework.org/schema/beans/spring-beans.xsd
   http://www.springframework.org/schema/context
   http://www.springframework.org/schema/context/spring-context.xsd">

   <!--1.扫描service下的包-->
   <context:component-scan base-package="com.master.service" />

   <!--2.将业务类注入到Spring中-->
   <bean id="BookServiceImpl" class="com.master.service.BookServiceImpl">
       <property name="bookMapper" ref="bookMapper"/>
   </bean>

   <!-- 3.配置事务管理器 -->
   <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
       <!-- 注入数据库连接池 -->
       <property name="dataSource" ref="dataSource" />
   </bean>

</beans>
```

#### 整合两个配置

这样可以让不同的配置产生联系

<span style="backGround: #efe0b9">resources/applicationContext.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd">

    <import resource="classpath:spring-dao.xml"/>
    <import resource="classpath:spring-service.xml"/>

</beans>
```



### SpringMVC层编写

#### 请求分发

<span style="backGround: #efe0b9">src/main/webapp/WEB-INF/web.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">

  <!--DispatcherServlet-->
  <servlet>
    <servlet-name>DispatcherServlet</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
      <param-name>contextConfigLocation</param-name>
      <!--加载的是总的配置文件-->
      <param-value>classpath:applicationContext.xml</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
  </servlet>
  <servlet-mapping>
    <servlet-name>DispatcherServlet</servlet-name>
    <url-pattern>/</url-pattern>
  </servlet-mapping>

  <!--乱码过滤-->
  <filter>
    <filter-name>encodingFilter</filter-name>
    <filter-class>
      org.springframework.web.filter.CharacterEncodingFilter
    </filter-class>
    <init-param>
      <param-name>encoding</param-name>
      <param-value>utf-8</param-value>
    </init-param>
  </filter>
  <filter-mapping>
    <filter-name>encodingFilter</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>

  <!--Session过期时间-->
  <session-config>
    <session-timeout>15</session-timeout>
  </session-config>

</web-app>
```

#### 配置SpringMVC

<span style="backGround: #efe0b9">resources/spring-mvc.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
   http://www.springframework.org/schema/beans/spring-beans.xsd
   http://www.springframework.org/schema/context
   http://www.springframework.org/schema/context/spring-context.xsd
   http://www.springframework.org/schema/mvc
   https://www.springframework.org/schema/mvc/spring-mvc.xsd">

    <!-- 1.开启SpringMVC注解驱动 -->
    <mvc:annotation-driven />
    <!-- 2.静态资源过滤-->
    <mvc:default-servlet-handler/>
    <!-- 3.扫描包：controller -->
    <context:component-scan base-package="com.master.controller" />

    <!-- 4.视图解析器 -->
    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="prefix" value="/WEB-INF/jsp/" />
        <property name="suffix" value=".jsp" />
    </bean>

</beans>
```

#### 配置目录

WEB-INF/jsp

#### 整合配置

<span style="backGround: #efe0b9">resources/applicationContext.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd">

    <import resource="classpath:spring-dao.xml"/>
    <import resource="classpath:spring-service.xml"/>
    <import resource="classpath:spring-mvc.xml"/>

</beans>
```



### 查询书籍功能

#### 控制层

<span style="backGround: #efe0b9">com/master/controller/BookController.java</span>

```java
@Controller
@RequestMapping("/book")
public class BookController {
    @Autowired
    @Qualifier("BookServiceImpl")
    private BookService bookService;

    // 查询全部书籍，并返回到书籍展示页面
    @RequestMapping("/allBook")
    public String list(Model model) {
        List<Books> list = bookService.queryAllBook();
        model.addAttribute("list", list);
        return "allBook";
    }
}
```

controller 调用 service 层

#### 页面准备

<span style="backGround: #efe0b9">src/main/webapp/WEB-INF/jsp/allBook.jsp</span>

```html
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
   <title>书籍展示</title>
</head>
<body>
    <h1>书籍展示</h1>
</body>
</html>
```

<span style="backGround: #efe0b9">src/main/webapp/index.jsp</span>

```html
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
   <title>首页<title>
</head>
<body>
    <h3>
        <a href="${pageContext.request.contextPath}/book/allBook">进入书籍页面</a>
    </h3>
</body>
</html>
```

#### 测试功能

```java
@Test
public void test() {
    ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
    BookService bookServiceImpl = (BookService) context.getBean("BookServiceImpl");
    for (Books books : bookServiceImpl.queryAllBook()) {
        System.out.println(books);
    }
}
```



### 添加书籍功能

<span style="backGround: #efe0b9">com/master/controller/BookController.java</span>

```java
@Controller
@RequestMapping("/book")
public class BookController {
    // ...
    // 跳转到增加书籍页面
    @RequestMapping("/toAddBook")
    public String toAddPaper() {
        return "addBook";
    }
    // 添加书籍的请求
    @RequestMapping("/addBook")
    public String addBook(Books books) {
        bookService.addBook(books);
        return "redirect:/book/allBook";
    }
}
```



### 修改/删除书籍功能

<span style="backGround: #efe0b9">com/master/controller/BookController.java</span>

```java
@Controller
@RequestMapping("/book")
public class BookController {
    // ...
    // 跳转到修改书籍页面
    @RequestMapping("/toUpdate")
    public String toUpdatePaper(int id, Model model) {
        Books books = bookService.queryBookById(id);
        model.addAttribute("QBook", books);
        return "updateBook";
    }
    // 修改书籍
    @RequestMapping("/updateBook")
    public String updateBook(Books books) {
        bookService.updateBook(books);
        return "redirect:/book/allBook";
    }
    // 删除书籍
    @RequestMapping("/deleteBook/{bookId}")
    public String deleteBook(@PathVariable("bookId") int id) {
        bookService.deleteBookById(id);
        return "redirect:/book/allBook";
    }
}
```



### 搜索书籍功能

#### Dao-接口

<span style="backGround: #efe0b9">com/master/dao/BookMapper.java</span>

```java
public interface BookMapper {
    // ...
	// 根据名称搜索书籍
    Books queryBookByName(@Param("bookId") String bookName);
}
```

#### Dao-xml

<span style="backGround: #efe0b9">com/master/dao/BookMapper.xml</span>

```html
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.master.dao.BookMapper">

    // ...
    <select id="queryBookByName" resultType="Books">
        select * from ssmbuild.books where bookName = #{bookName}
    </select>

</mapper>
```

#### Service-接口

<span style="backGround: #efe0b9">com/master/service/BookService.java</span>

```java
public interface BookService {
    // ...
    // 根据名称查询书
    Books queryBookByName(String bookName);
}
```

#### Service-类实现

<span style="backGround: #efe0b9">com/master/service/BookServiceImpl.java</span>

```java
public class BookServiceImpl implements BookService {

   // ...
    public Books queryBookByName(String bookName) {
        return bookMapper.queryBookByName(bookName);
    }
}
```

#### 控制层

<span style="backGround: #efe0b9">com/master/controller/BookController.java</span>

```java
@Controller
@RequestMapping("/book")
public class BookController {
    //...
    // 查询书籍
    @RequestMapping("/queryBook")
    public String queryBook(String queryBookName, Model model) {
        Books books = bookService.queryBookByName(queryBookName);
        List<Books> list = new ArrayList<Books>();
        list.add(books);
        model.addAttribute("list", list);
        return "allBook";
    }
}
```



## Ajax

### 接收请求返回信息

**控制层**

<span style="backGround: #efe0b9">com/master/controller/AjaxController.java</span>

```java
@ResController
public class AjaxController {
    @RequestMapping("/demo")
    public String test(int a, HttpServletResponse response) throws IOException {
        response.getWriter().print(a+1);
    }
    
    @RequestMapping("/demo2")
    public List<User> test2() {
        List<User> userList = new ArrayList<User>();
        
        userList.add(new User("master", 5));
        userList.add(new User("lucy", 12));
        return userList;
    }
}
```

**<span style="color: #f7534f;font-weight:600">@RestController</span> 在类上使用后，表示它的方法不会走视图解析器，方法将直接返回字符串；**



## 拦截器

SpringMVC的处理器拦截器类似于Servlet开发中的过滤器Filter，用于对处理器进行预处理和后处理。



### 创建模块支持SpringMVC

1. 首先确保父项目的包下，已经导入了相关依赖。

2. 新建模块后，右键点击 Add Framework Support，添加 4.0 版本的 Web Application。

3. 配置一

<span style="backGround: #efe0b9">webapp/WEB-INF/web.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">

  <!--DispatcherServlet-->
  <servlet>
    <servlet-name>springmvc</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
      <param-name>contextConfigLocation</param-name>
      <param-value>classpath:applicationContext.xml</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
  </servlet>
  <servlet-mapping>
    <servlet-name>springmvc</servlet-name>
    <url-pattern>/</url-pattern>
  </servlet-mapping>

  <!--encodingFilter-->
  <filter>
    <filter-name>encodingFilter</filter-name>
    <filter-class>
      org.springframework.web.filter.CharacterEncodingFilter
    </filter-class>
    <init-param>
      <param-name>encoding</param-name>
      <param-value>utf-8</param-value>
    </init-param>
  </filter>
  <filter-mapping>
    <filter-name>encodingFilter</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>

</web-app>
```

4. 配置二

<span style="backGround: #efe0b9">resources/applicationContext.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:context="http://www.springframework.org/schema/context"
      xmlns:mvc="http://www.springframework.org/schema/mvc"
      xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/context
       https://www.springframework.org/schema/context/spring-context.xsd
       http://www.springframework.org/schema/mvc
       https://www.springframework.org/schema/mvc/spring-mvc.xsd">

   <!-- 自动扫描指定的包，下面所有注解类交给IOC容器管理 -->
   <context:component-scan base-package="com.master.controller"/>
   <!-- 静态资源过滤 -->
   <mvc:default-servlet-handler />
   <!-- 开启SpringMVC注解驱动 -->
   <mvc:annotation-driven />
   
   <!--解决json乱码问题-->
    <mvc:annotation-driven>
        <mvc:message-converters register-defaults="true">
            <bean class="org.springframework.http.converter.StringHttpMessageConverter">
                <constructor-arg value="UTF-8"/>
            </bean>
            <bean class="org.springframework.http.converter.json.MappingJackson2HttpMessageConverter">
                <property name="objectMapper">
                    <bean class="org.springframework.http.converter.json.Jackson2ObjectMapperFactoryBean">
                        <property name="failOnEmptyBeans" value="false"/>
                    </bean>
                </property>
            </bean>
        </mvc:message-converters>
    </mvc:annotation-driven>

   <!-- 视图解析器 -->
   <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver"
         id="internalResourceViewResolver">
       <!-- 前缀 -->
       <property name="prefix" value="/WEB-INF/jsp/" />
       <!-- 后缀 -->
       <property name="suffix" value=".jsp" />
   </bean>

</beans>
```

5. com.master.controller

6. 在 Project Structure 的 Artifacts 模块下导入 lib 包
7. 配置 tomcat 启动



### 配置拦截器

#### 配置拦截器

<span style="backGround: #efe0b9">com/master/config/MyInterceptor.java</span>

```java
public class MyInterceptor implements HandlerInterceptor {
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        System.out.println("==处理前==");
        return true;
    }

    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        System.out.println("==处理后==");
    }

    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        System.out.println("==清理==");
    }
}
```

:ghost: 继承了 <span style="color: #a50">HandlerInterceptor</span> 接口的类就能成为 SpringMVC 的拦截器；

:ghost: 类似于 koa 的中间件，preHandle 方法返回 true 表示放行，返回 false 则中断。

#### 注册拦截器

<span style="backGround: #efe0b9">resources/applicationContext.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:context="http://www.springframework.org/schema/context"
      xmlns:mvc="http://www.springframework.org/schema/mvc"
      xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/context
       https://www.springframework.org/schema/context/spring-context.xsd
       http://www.springframework.org/schema/mvc
       https://www.springframework.org/schema/mvc/spring-mvc.xsd">

	<!--其它配置...-->

    <!--拦截器配置-->
    <mvc:interceptors>
        <mvc:interceptor>
            <mvc:mapping path="/**"/>
            <bean class="com.master.config.MyInterceptor"/>
        </mvc:interceptor>
    </mvc:interceptor>

</beans>
```

这里的 `path="/**"` 表示匹配所有请求路径。

#### 控制层示例

<span style="backGround: #efe0b9">com/master/controller/TestController.java</span>

```java
@RestController
public class TestController {
    
    @GetMapping("t1")
    public String test() {
        System.out.println("test请求");
        return "OK";
    }
}
```

#### 执行顺序

```less
==处理前==
test请求
==处理后==
==清理==
```



## 文件上传和下载

### 文件上传

#### 导入依赖

<span style="backGround: #efe0b9">pom.xml</span>

```html
<!--文件上传-->
<dependency>
   <groupId>commons-fileupload</groupId>
   <artifactId>commons-fileupload</artifactId>
   <version>1.3.3</version>
</dependency>
<!--servlet-api导入高版本的-->
<dependency>
   <groupId>javax.servlet</groupId>
   <artifactId>javax.servlet-api</artifactId>
   <version>4.0.1</version>
</dependency>
```

#### 配置multipartResolver

<span style="backGround: #efe0b9">resources/applicationContext.xml</span>

```html
<!--文件上传配置-->
<bean id="multipartResolver"  class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
   <!-- 请求的编码格式，必须和jSP的pageEncoding属性一致，以便正确读取表单的内容，默认为ISO-8859-1 -->
   <property name="defaultEncoding" value="utf-8"/>
   <!-- 上传文件大小上限，单位为字节（10485760=10M） -->
   <property name="maxUploadSize" value="10485760"/>
   <property name="maxInMemorySize" value="40960"/>
</bean>
```



#### 上传方式一

<span style="backGround: #efe0b9">com/master/controller/FileController.java</span>

```java
@Controller
public class FileController {
   //@RequestParam("file") 将name=file控件得到的文件封装成CommonsMultipartFile 对象
   //批量上传CommonsMultipartFile则为数组即可
   @RequestMapping("/upload")
   public String fileUpload(@RequestParam("file") CommonsMultipartFile file , HttpServletRequest request) throws IOException {

       //获取文件名 : file.getOriginalFilename();
       String uploadFileName = file.getOriginalFilename();

       //如果文件名为空，直接回到首页！
       if ("".equals(uploadFileName)){
           return "redirect:/index.jsp";
      }
       System.out.println("上传文件名 : "+uploadFileName);

       //上传路径保存设置
       String path = request.getServletContext().getRealPath("/upload");
       //如果路径不存在，创建一个
       File realPath = new File(path);
       if (!realPath.exists()){
           realPath.mkdir();
      }
       System.out.println("上传文件保存地址："+realPath);

       InputStream is = file.getInputStream(); //文件输入流
       OutputStream os = new FileOutputStream(new File(realPath,uploadFileName)); //文件输出流

       //读取写出
       int len=0;
       byte[] buffer = new byte[1024];
       while ((len=is.read(buffer))!=-1){
           os.write(buffer,0,len);
           os.flush();
      }
       os.close();
       is.close();
       return "redirect:/index.jsp";
  }
}
```

CommonsMultipartFile 的 常用方法：

- **String getOriginalFilename()：获取上传文件的原名**
- **InputStream getInputStream()：获取文件流**
- **void transferTo(File dest)：将上传文件保存到一个目录文件中**



#### 上传方式二

采用 file.Transto 来保存上传的文件

<span style="backGround: #efe0b9">com/master/controller/FileController.java</span>

```java
@RequestMapping("/upload2")
public String  fileUpload2(@RequestParam("file") CommonsMultipartFile file, HttpServletRequest request) throws IOException {

   //上传路径保存设置
   String path = request.getServletContext().getRealPath("/upload");
   File realPath = new File(path);
   if (!realPath.exists()){
       realPath.mkdir();
  }
   //上传文件地址
   System.out.println("上传文件保存地址："+realPath);

   //通过CommonsMultipartFile的方法直接写文件（注意这个时候）
   file.transferTo(new File(realPath +"/"+ file.getOriginalFilename()));

   return "redirect:/index.jsp";
}
```



### 文件下载

确保相对路径下有资源可供下载

1、设置 response 响应头

2、读取文件 -- InputStream

3、写出文件 -- OutputStream

4、执行操作

5、关闭流 （先开后关）

<span style="backGround: #efe0b9">com/master/controller/FileController.java</span>

```java
@RequestMapping(value="/download")
public String downloads(HttpServletResponse response ,HttpServletRequest request) throws Exception{
   //要下载的图片地址
   String  path = request.getServletContext().getRealPath("/upload");
   String  fileName = "基础语法.jpg";

   //1、设置response 响应头
   response.reset(); //设置页面不缓存,清空buffer
   response.setCharacterEncoding("UTF-8"); //字符编码
   response.setContentType("multipart/form-data"); //二进制传输数据
   //设置响应头
   response.setHeader("Content-Disposition",
           "attachment;fileName="+URLEncoder.encode(fileName, "UTF-8"));

   File file = new File(path,fileName);
   //2、 读取文件--输入流
   InputStream input=new FileInputStream(file);
   //3、 写出文件--输出流
   OutputStream out = response.getOutputStream();

   byte[] buff =new byte[1024];
   int index=0;
   //4、执行 写出操作
   while((index= input.read(buff))!= -1){
       out.write(buff, 0, index);
       out.flush();
  }
   out.close();
   input.close();
   return null;
}
```

