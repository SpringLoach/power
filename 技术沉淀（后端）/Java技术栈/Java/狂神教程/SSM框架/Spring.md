## 介绍

是一款轻量级的控制反转和面向切面编程的框架，用于简化开发。

- 控制反转（IOC），面向切面编程（AOP）
- 支持事务的处理，对框架整合的支持

- 弊端：发展太久后，违背了原来的理念：配置繁琐，人称配置地狱。



### 相关资料

[官方地址](https://spring.io/projects/spring-framework#overview)

[官方下载地址](https://repo.spring.io/ui/native/release/org/springframework/spring)



### 下载依赖

maven[仓库](https://mvnrepository.com/) 搜索 [Spring Web MVC](https://mvnrepository.com/artifact/org.springframework/spring-webmvc)，该依赖整合了其它相关依赖。

```html
<!-- https://mvnrepository.com/artifact/org.springframework/spring-webmvc -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
    <version>5.2.0.RELEASE</version>
</dependency>
```



### Spring七大模块

| 模块               | 特点                             |
| ------------------ | -------------------------------- |
| **Spring AOP**     | 面向切面编程                     |
| **Spring ORM**     | 类似 mybatis，实体类映射表       |
| **Spring DAO**     |                                  |
| **Spring Web**     |                                  |
| **Spring context** | 提供上下文信息                   |
| **Spring MVC**     |                                  |
| **Spring core**    | 核心容器提供spring框架的基本功能 |



## 学习准备

1. 建立普通的 maven 项目
2. 导入依赖
3. 删除原有src层，新建模块



## IOC



### IOC理论

**Demo**

Dao 层接口定义了一个方法，创建了多个 Dao 层类去继承它（方法实现不同）；

Service 层的实例，需要初始化 Dao 层类，并调用该方法；

如果每次业务变更时，就要在 Service 层更改初始化的类，不是优秀的思想；

可以在 Service 层的实例提供 set 方法，由外部决定要使用的具体 Dao 层类，即控制反转理念。



程序员可以专注于 Service 层编写，至于 Service 层需要使用哪个 Dao，由外部控制。



![image-20221217111054003](.\img\IOC理论)







### 例子-HelloSpring

对象由 Spring 来创建，管理，装配；文档见[这](https://docs.spring.io/spring-framework/docs/5.2.0.RELEASE/spring-framework-reference/core.html#spring-core)

#### 新建类

<span style="backGround: #efe0b9">com/master/pojo/Hello.java</span>

```java
public class Hello {
    private String str;

    public String getStr() {
        return str;
    }

    public void setStr(String str) {
        this.str = str;
    }

    @Override
    public String toString() {
        return "Hello{" +
                "str='" + str + '\'' +
                '}';
    }
}
```

#### 通过beans实例化、管理类

<span style="backGround: #efe0b9">resources/beans.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="hello" class="com.master.pojo.Hello">
        <property name="str" value="Spring" />
    </bean>

</beans>
```

:ghost: 使用 bean 标签相当于 new 了一个类

| 标签     | 属性  | 说明                                     |
| -------- | ----- | ---------------------------------------- |
| bean     | id    | 接收实例的变量名                         |
| bean     | class | 需要进行 new 操作的类                    |
| bean     | name  | 别名，可以用(逗号/空格/分号)分隔添加多个 |
| property | name  | 给具体的属性                             |
| property | value | 设置具体的(原始)值                       |
| property | ref   | 设置为对象，引用其它 bean 的 id          |

#### 测试

```java
@Test
public void test() {
    // 1. 获取Spring的上下文对象（容器）
    ApplicationContext context = new ClassPathXmlApplicationContext("beans.xml");
    // 2. 从上下文对象中获取需要的对象（需要什么，就直接get什么）
    Hello hello = (Hello) context.getBean("hello");

    System.out.println(hello.toString());
}
```





### IOC-创建对象方式



#### 有参构造的方式

1.通过参数名赋值

<span style="backGround: #efe0b9">resources/beans.xml</span>

```html
<bean id="user" class="com.master.pojo.User">
    <constructor-arg name="name" value="demo" >
</bean>
```

2.通过下标赋值

```html
<bean id="user" class="com.master.pojo.User">
    <constructor-arg index="0" value="demo" >
</bean>
```

3.通过类型赋值(不推荐)

```html
<bean id="user" class="com.master.pojo.User">
    <constructor-arg type="java.lang.String" value="demo" >
</bean>
```



#### 初始化机制

```java
@Test
public void test() {
    // Spring容器
    ApplicationContext context = new ClassPathXmlApplicationContext("beans.xml");
    
    // 从上下文对象中获取需要的对象
    Hello hello = (Hello) context.getBean("hello");
    Hello hello2 = (Hello) context.getBean("hello");

    System.out.println(hello == hello2); // true
}
```

:star2: 在获取 Spring 容器时，就已经把 <span style="backGround: #efe0b9">beans.xml</span> 文件下的 bean 都实例化了；

:star2: 向 <span style="color: #a50">context.getBean</span> 传入相同变量，获取到的是同个对象。





## Spring配置

### bean

<span style="backGround: #efe0b9">resources/beans.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="hello" class="com.master.pojo.Hello">
        <property name="str" value="Spring" />
    </bean>

</beans>
```

:ghost: 使用 bean 标签相当于 new 了一个类

| 标签     | 属性  | 说明                                     |
| -------- | ----- | ---------------------------------------- |
| bean     | id    | 接收实例的变量名                         |
| bean     | class | 需要进行 new 操作的类                    |
| bean     | name  | 别名，可以用(逗号/空格/分号)分隔添加多个 |
| property | name  | 给具体的属性                             |
| property | value | 设置具体的(原始)值                       |
| property | ref   | 设置为对象，引用其它 bean 的 id          |

**另一个例子**

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="mysqlImpl" class="com.master.dao.UserDaoMysqlImpl" />
    <bean id="oracleImpl" class="com.master.dao.UserDaoOracleImpl" />
    
    <bean id="userServiceImpl" class="com.master.service.UserServiceImpl">
        <property name="userDao" value="mysqlImpl" />
    </bean>

</beans>
```



### alias

用于取别名

```html
<bean id="hello" class="com.master.dao.Hello" />

<alias name="hello" alias="zxc" />
```

测试

```java
@Test
public void test() {
    ApplicationContext context = new ClassPathXmlApplicationContext("beans.xml");
    
    Hello hello = (Hello) context.getBean("hello");
    Hello hello2 = (Hello) context.getBean("zxc");

    System.out.println(hello == hello2); // true
}
```



### import

类似于前端模块化的统一导出思想(index.js)。

<span style="backGround: #efe0b9">applicationContext.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <import resource="beans.xml" />
    <import resource="beans2.xml" />

</beans>
```

测试

```java
@Test
public void test() {
    ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
    
    Hello hello = (Hello) context.getBean("hello");
}
```



## 依赖注入

### 环境准备

#### 定义类

<span style="backGround: #efe0b9">com/master/pojo/Address.java</span>

```java
public class Address {
    private String address;

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}
```

<span style="backGround: #efe0b9">com/master/pojo/Student.java</span>

```java
public class Student {
    private String name;
    private Address address;
    private String[] books;
    private List<String> hobby;
    private Map<String, String> card;
    private Set<String> games;
    private String wife;
    private Properties info;
	// ...加上对于的get/set/toString
}
```

#### 配置Bean

<span style="backGround: #efe0b9">resources/beans.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="student" class="com.master.pojo.Student">
        <property name="name" value="SpringLoach" />
    </bean>

</beans>
```

#### 测试

```java
@Test
public void test() {
    ApplicationContext context = new ClassPathXmlApplicationContext("beans.xml");

    // 可以通过第二个参数传入class，这样就不需要强转
    Student student = context.getBean("student", Student.class);

    System.out.println(student.getName());
}
```



### 1、[构造器注入](#有参构造的方式)



### 2、Set方法注入

```html
<bean id="student" class="com.master.pojo.Student">

    <!--普通值注入-->
    <property name="name" value="SpringLoach" />

    <!--数组-->
    <property name="books">
        <array>
            <value>红楼梦</value>
            <value>西游记</value>
        </array>
    </property>

    <!--List-->
    <property name="hobby">
        <list>
            <value>听歌</value>
            <value>看电影</value>
        </list>
    </property>

    <!--Map-->
    <property name="card">
        <map>
            <entry key="身份证" value="123" />
            <entry key="银行卡" value="456" />
        </map>
    </property>

    <!--Set-->
    <property name="games">
        <set>
            <value>LOL</value>
            <value>COC</value>
        </set>
    </property>

    <!--null-->
    <property name="wife">
        <null/>
    </property>

    <!--Property-->
    <property name="info">
        <props>
            <prop key="username">root</prop>
            <prop key="password">123456</prop>
        </props>
    </property>

</bean>
```



### 3、其它方式注入

#### c命名/p命名空间注入

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:p="http://www.springframework.org/schema/p"
       xmlns:c="http://www.springframework.org/schema/c"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <!--c命名控件注入，可以注入属性的值 property-->
    <bean id="user" class="com.master.pojo.User" p:name="demo" p:age="18"/>
    
    <!--c命名控件注入，可以注入构造器参数 construct-args-->
    <bean id="user" class="com.master.pojo.User" p:name="demo" p:age="18"/>

</beans>
```

注意需要现在 beans 标签添加文件约束：`xmlns:p=xx` / `xmlns:c=xx` 



### 4、Bean的作用域

| bean.scope设置值  | 说明                                |
| ----------------- | ----------------------------------- |
| singleton（默认） | 每次从容器get时，获得的是同个对象   |
| prototype         | 每次从容器get时，获得的都是新的对象 |
| request           | web开发中使用                       |
| session           | web开发中使用                       |
| application       | web开发中使用                       |

```html
<bean id="user" class="com.master.pojo.User" scope="singleton" />
```



## 自动装配Bean

### 准备环境

#### 准备类

<span style="backGround: #efe0b9">com/master/pojo/Cat.java</span>

```java
public class Cat {
    public void shout() {
        System.out.println("miao~");
    }
}
```

<span style="backGround: #efe0b9">com/master/pojo/Dog.java</span>

```java
public class Dog {
    public void shout() {
        System.out.println("wang~");
    }
}
```

<span style="backGround: #efe0b9">com/master/pojo/People.java</span>

```java
public class People {
    private Cat cat;
    private Dog dog;
    private String name;
    // get/set/toString
}
```

#### 配置xml(beans)

<span style="backGround: #efe0b9">resources/beans.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="cat" class="com.master.pojo.Cat" />
    <bean id="dog" class="com.master.pojo.Dog" />
    
    <bean id="people" class="com.master.pojo.People">
        <property name="name" value="demo" />
        <property name="dog" ref="dog" />
        <property name="cat" ref="cat" />
    </bean>
</beans>
```

#### 测试

```java
@Test
public void test() {
    ApplicationContext context = new ClassPathXmlApplicationContext("beans.xml");

    People people = context.getBean("people", People.class);
    people.getDog().shout();
    people.getCat().shout();
}
```



### byName-根据名字

<span style="backGround: #efe0b9">resources/beans.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="cat" class="com.master.pojo.Cat" />
    <bean id="dog" class="com.master.pojo.Dog" />

    <bean id="people" class="com.master.pojo.People" autowire="byName">
        <property name="name" value="demo" />
    </bean>
</beans>
```

:ghost: 会根据类的 set 方法后的属性在容器中查找 bean.id 来装配属性，要求小写，bean.id 唯一。

### byType-根据类型

<span style="backGround: #efe0b9">resources/beans.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean class="com.master.pojo.Cat" />
    <bean class="com.master.pojo.Dog" />

    <bean id="people" class="com.master.pojo.People" autowire="byType">
        <property name="name" value="demo" />
    </bean>
</beans>
```

:ghost: 会根据类属性的类型，在容器中查找对于类型的 bean，要求该类型的 bean 在容器唯一。



### 自动装配

#### 前置条件

<span style="backGround: #efe0b9">resources/beans.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        https://www.springframework.org/schema/context/spring-context.xsd">

    <context:annotation-config/>

</beans>
```

#### @Autowired

<span style="backGround: #efe0b9">com/master/pojo/People.java</span>

```java
public class People {
    @Autowired
    private Cat cat;
    @Autowired
    @Qualifier(value="dog23")
    private Dog dog;
    private String name;
    // get/set/toString
}
```

<span style="color: #f7534f;font-weight:600">@Autowired</span> 可以添加到属性/对应的set方法上，它会先根据 byType，如果不行再根据 byName 规则去匹配 bean；

<span style="color: #f7534f;font-weight:600">@Qualifier</span> 可以根据提供的值去匹配 bean 中的 id，要求该 bean 与标注属性的类型相同。

<span style="backGround: #efe0b9">resources/beans.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        https://www.springframework.org/schema/context/spring-context.xsd">
    
    <context:annotation-config/>

    <bean class="com.master.pojo.Cat" />
    <bean id="dog34" class="com.master.pojo.Dog" />
    <bean id="dog23" class="com.master.pojo.Dog" />

    <bean id="people" class="com.master.pojo.People">
        <property name="name" value="demo" />
    </bean>
</beans>
```



#### @Resource

- 默认按 name 进行注入；
- 使用 name 属性：byName 的自动注入策略，会被 Spring 解析为 bean 的名字；
- 使用 type 属性：byType 的自动注入策略，会被 Spring 解析为 bean 的类型。

默认：

- 出现重复的类名会报异常；
- 不在同一个package, 也会报异常。

**情况一**

<span style="backGround: #efe0b9">com/master/pojo/People.java</span>

```java
public class People {
    @Resource
    private Cat cat;
    @Resource
    private Dog dog;
    private String name;
    // get/set/toString
}
```

<span style="backGround: #efe0b9">resources/beans.xml</span>

```html
<bean class="com.master.pojo.Cat" />
<bean id="dog" class="com.master.pojo.Dog" />
<bean id="dog23" class="com.master.pojo.Dog" />

<bean id="people" class="com.master.pojo.People">
    <property name="name" value="demo" />
</bean>
```

:whale: 它的功能与 <span style="color: #a50">@Autowired</span> 很相似，为 jdk8 的新特性，但在高版本需要导入依赖。

:ghost: 即使出现多个匹配类型的 bean，但只要存在一个 bean.id 的值完全匹配，也能装配；

**情况二**

<span style="backGround: #efe0b9">com/master/pojo/People.java</span>

```java
public class People {
    @Resource
    private Cat cat;
    @Resource(name = "dog23")
    private Dog dog;
    private String name;
    // get/set/toString
}
```

<span style="backGround: #efe0b9">resources/beans.xml</span>

```html
<bean class="com.master.pojo.Cat" />
<bean id="dog34" class="com.master.pojo.Dog" />
<bean id="dog23" class="com.master.pojo.Dog" />

<bean id="people" class="com.master.pojo.People">
    <property name="name" value="demo" />
</bean>
```

:ghost: 可以通过注解参数实现 byName 的效果。

**情况二·拓展-注解**

```java
@Service("a")
public class ReportServiceImpl implements ReportService{
    ......
}

@Service("b")
public class ReportServiceImpl implements ReportService{
    ......
}
```

指定注入类

```java
@Resource(name = "a")
private ReportServiceImpl service;
```





## Spring注解开发

### 前提条件

1. 导入 `spring-aop` 依赖，这个在 `spring-webmvc` 中有集成。

2. 导入相关配置

   <span style="backGround: #efe0b9">resources/beans.xml</span>

   ```html
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
           https://www.springframework.org/schema/beans/spring-beans.xsd
           http://www.springframework.org/schema/context
           https://www.springframework.org/schema/context/spring-context.xsd">
   
       <!--指定需要扫描的包，该包下的注解才能生效-->
       <context:component-scan base-package="com.master.pojo" />
   
   </beans>
   ```

   

### @Component

<span style="backGround: #efe0b9">com/master/pojo/User.java</span>

```java
@Component
public class User {
    public String name = "master";
}
```

<span style="color: #f7534f;font-weight:600">@Component</span> 等价于生成 bean：`<bean id="user" class="com.master.pojo.User" />`

**测试**

```java
@Test
public void test() {
    ApplicationContext context = new ClassPathXmlApplicationContext("beans.xml");

    User user = context.getBean("user", User.class);
    System.out.println(user.name);
}
```

**衍生注解**

| 注解        | 习惯用于用于分层 |
| ----------- | ---------------- |
| @Repository | dao/mapper       |
| @Service    | service          |
| @Controller | controller       |

:hammer_and_wrench: 这几个注解的作用与 <span style="color: #a50">@Component</span> 一样，都代表将类注册到 Spring 中，装配Bean。



### @Value

<span style="backGround: #efe0b9">com/master/pojo/User.java</span>

```java
@Component
public class User {
    @Value("master")
    public String name;
}
```

<span style="color: #f7534f;font-weight:600">@Value</span> 等价于生成 property：`<property name="name" value="master" />`

:ghost: 该注解可以放在属性/属性对应的set方法上，作用是一样的；

:whale: 推荐在较为简单的赋值上使用注解，复杂类型的还是通过[依赖注入](#2、Set方法注入)。



### @Scope

<span style="backGround: #efe0b9">com/master/pojo/User.java</span>

```java
@Component
@Scope("singleton")
public class User {
    public String name = "master";
}
```

<span style="color: #f7534f;font-weight:600">@Scope</span> 等价于生成scope属性 `<bean id="user" class="com.master.pojo.User" scope="singleton" />`



xml与注解的最佳实践：

- xml 用来管理 bean
- 注解只负责完成属性的注入



## 基于JavaConfig实现配置

> 使用 Java 类的方式直接配置 Spring

### 新建类

<span style="backGround: #efe0b9">com/master/pojo/User.java</span>

```java
public class User {
    public String name;

    public String getName() {
        return name;
    }

    @Value("master")
    public void setName(String name) {
        this.name = name;
    }
}
```

### 新建配置

<span style="backGround: #efe0b9">com/master/config/masterConfig2.java</span>

```java
@Configurable
public class masterConfig {
}
```

<span style="backGround: #efe0b9">com/master/config/masterConfig.java</span>

```java
@Configurable
@ComponentScan("com.master")
@Import(masterConfig2)
public class masterConfig {

    @Bean
    public User getUser() {
        return new User();
    }
}
```

<span style="color: #f7534f;font-weight:600">@Configurable</span> 表示这个类是配置类，类似于 <span style="backGround: #efe0b9">beans.xml</span> 的作用；本身也是 @Component，会被注册到容器

<span style="color: #f7534f;font-weight:600">@Bean</span> 注册一个 bean，方法名相当于 bean.id 返回值相当于 bean.class

<span style="color: #f7534f;font-weight:600">@ComponentScan</span> 表示扫描包下的类，这样它们的注解才生效

<span style="color: #f7534f;font-weight:600">@Import</span> 引入其它的配置



### 测试

```java
@Test
public void test() {
    ApplicationContext context = new AnnotationConfigApplicationContext(masterConfig.class);

    User user = context.getBean("getUser", User.class);
    System.out.println(user.getName());
}
```



## 动态代理

静态代理通常是写死的，复用不便，而动态代理能够自动生成代理类

**好处**

- 增强能力
- 动态代理类代理的是接口，一般对应一类业务
- 动态代理类可代理多个实现了该接口的类

### 封装代理类生成

```java
public class ProxyInvocationHandler implements InvocationHandler {
  
  // 被代理的接口
  private Object target;
  
  public void setTarget(Object target) {
      this.target = target;
  }

  // 生成得到代理类
  public Object getProxy() {
    return Proxy.newProxyInstance(
      this.getClass().getClassLoader(),
      target.getClass().getInterfaces(),
      this
    );
  }
    
  // 处理代理实例，并返回结果
  public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
    log(method.getName()); // 增强代理行为
    Object result = method.invoke(target, args);
    return result;
  }
    
  public void log(String msg) {
    System.out.println("执行了方法" + msg);
  }
}
```

### 使用

```java
@Test
public void test() {
  // 真实角色
  UserServiceImpl userService = new UserServiceImpl();
  
  ProxyInvocationHandler pih = new ProxyInvocationHandler();
  // 设置要代理的对象
  pih.setTarget(userService);
  // 动态生成代理类
  UserService proxyUser = (UserService) pih.getProxy();
  // 调用代理方法(将执行真实角色的方法，并被增强)
  proxyUser.query(); 
}
```



## AOP

AOP，是借助了动态代理的机制实现的。



### 实现方式一

使用原生的 Spring API 接口

#### 导入依赖

```html
<dependency>
    <groupId>org.aspectj</groupId>
    <artifactId>aspectjweaver</artifactId>
    <version>1.9.4</version>
</dependency>
```

#### 定义接口

<span style="backGround: #efe0b9">com/master/service/UserService.java</span>

```java
public interface UserService {
    public void add();
    public void delete();
    public void update();
    public void select();
}
```

#### 接口实现类

<span style="backGround: #efe0b9">com/master/service/UserServiceImpl.java</span>

```java
public class UserServiceImpl implements UserService {
    public void add() {
        System.out.println("增加用户");
    }
    public void delete() {
        System.out.println("删除用户");
    }
    public void update() {
        System.out.println("更新用户");
    }
    public void select() {
        System.out.println("查询用户");
    }
}
```

#### 定义前置操作

<span style="backGround: #efe0b9">com/master/log/Log.java</span>

```java
public class Log implements MethodBeforeAdvice {

    public void before(Method method, Object[] args, Object target) throws Throwable {
        System.out.println(target.getClass().getName()+"的"+method.getName()+"被执行了");
    }
}
```

<span style="color: #ed5a65">method</span>：要执行的目标对象的方法

<span style="color: #ed5a65">args</span>：参数

<span style="color: #ed5a65">target</span>：目标对象

#### 定义后置操作

<span style="backGround: #efe0b9">com/master/log/AfterLog.java</span>

```java
public class AfterLog implements AfterReturningAdvice {

    public void afterReturning(Object returnValue, Method method, Object[] args, Object target) throws Throwable {
        System.out.println("执行了"+method.getName()+"方法，返回值为"+returnValue);
    }
}
```

<span style="color: #ed5a65">returnValue</span>: 返回值

#### 定义切面范围

<span style="backGround: #efe0b9">resources/applicationContext.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/aop
       http://www.springframework.org/schema/aop/spring-aop.xsd">

    <!--注册bean-->
    <bean id="userService" class="com.master.service.UserServiceImpl"/>
    <bean id="log" class="com.master.log.Log"/>
    <bean id="afterLog" class="com.master.log.AfterLog"/>

    <aop:config>
        <!--切入点-->
        <aop:pointcut id="pointcut" expression="execution(* com.master.service.UserServiceImpl.*(..))"/>
        <!--执行环绕增加-->
        <aop:advisor advice-ref="log" pointcut-ref="pointcut"/>
        <aop:advisor advice-ref="afterLog" pointcut-ref="pointcut"/>
    </aop:config>

</beans>
```

:ghost: 切入点和执行环绕增加，决定了要在什么地方，增加什么样的代码；

| 标签         | 属性         | 说明                        |
| ------------ | ------------ | --------------------------- |
| aop:pointcut | expression   | 通过 execution 决定执行位置 |
| aop:advisor  | advice-ref   | 匹配对应的 bean  标签 id    |
| aop:advisor  | pointcut-ref | 匹配对应的切入点 id         |

#### 测试

```java
@Test
public void test() {
    ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
    // 动态代理的对象是接口
    UserService userService = (UserService) context.getBean("userService");

    userService.add();
}
```



### 实现方式二

#### 定义自定义操作类

<span style="backGround: #efe0b9">com/master/diy/DiyPointCut.java</span>

```java
public class DiyPointCut {
    public void before() {
        System.out.println("=====方式执行前=====");
    }
    public void after() {
        System.out.println("=====方式执行后=====");
    }
}
```

<span style="backGround: #efe0b9">resources/applicationContext.xml</span>

```html
<bean id="diy" class="com.master.diy.DiyPointCut"/>

<aop:config>
    <!--自定义切面-->
    <aop:aspect ref="diy">
        <!--切入点-->
        <aop:pointcut id="point" expression="execution(* com.master.service.UserServiceImpl.*(..))"/>
        <!--通知-->
        <aop:before method="before" pointcut-ref="point"/>
        <aop:after method="after" pointcut-ref="point"/>
    </aop:aspect>
</aop:config>
```

:ghost: 切入点和通知，决定了要在什么地方，增加什么样的代码；

| 标签                 | 属性         | 说明                        |
| -------------------- | ------------ | --------------------------- |
| aop:aspect           | ref          | 匹配对应的 bean  标签 id    |
| aop:pointcut         | expression   | 通过 execution 决定执行位置 |
| aop:before/aop:after |              | 前置/后置通知               |
| aop:before           | method       | 匹配对应的 bean 中的方法    |
| aop:before           | pointcut-ref | 匹配对应的切入点 id         |



### 实现方式三

使用注解的方式实现

#### 注解修饰类

```java
package com.master.diy;

import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;

// 表明这个类是一个切面
@Aspect
public class AnnotationPointCut {

    @Before("execution(* com.master.service.UserServiceImpl.*(..))")
    public void before() {
        System.out.println("方法执行前");
    }
    @After("execution(* com.master.service.UserServiceImpl.*(..))")
    public void after() {
        System.out.println("方法执行后");
    }
    @Around("execution(* com.master.service.UserServiceImpl.*(..))")
    public void around(ProceedingJoinPoint jp) throws Throwable {
        System.out.println("环绕前");
        jp.proceed(); // 执行方法
        System.out.println("环绕前");
    }
}
```

<span style="color: #f7534f;font-weight:600">@Aspect</span> 表明这个类是一个切面

<span style="color: #f7534f;font-weight:600">@Before</span> 前置通知，参数决定执行位置

<span style="color: #f7534f;font-weight:600">@Around</span> 环绕增强，类似于前端的请求拦截，需要调用方法表示”放行“

<span style="backGround: #efe0b9">resources/applicationContext.xml</span>

```html
<!--注册bean-->
<bean id="userService" class="com.master.service.UserServiceImpl"/>
<bean id="log" class="com.master.log.Log"/>
<bean id="afterLog" class="com.master.log.AfterLog"/>

<!--开启注解支持-->
<aop:aspectj-autoproxy/>
<bean id="annotationPointCut" class="com.master.diy.AnnotationPointCut"/>
```



## 整合Mybatis

### 回顾Mybatis

#### 导入依赖

<span style="backGround: #efe0b9">pom.xml</span>

```html
<dependencies>
    <!-- spring模块集合 -->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-webmvc</artifactId>
        <version>5.2.0.RELEASE</version>
    </dependency>
    <!-- spring操作数据库，需要spring-jdbc -->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-jdbc</artifactId>
        <version>5.1.9.RELEASE</version>
    </dependency>
    <!--单元测试-->
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.12</version>
    </dependency>
    <!--AOP切面-->
    <dependency>
        <groupId>org.aspectj</groupId>
        <artifactId>aspectjweaver</artifactId>
        <version>1.9.4</version>
    </dependency>
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
    <!--连接mybatis和spring-->
    <dependency>
        <groupId>org.mybatis</groupId>
        <artifactId>mybatis-spring</artifactId>
        <version>2.0.2</version>
    </dependency>
    <!--lombok-->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <version>1.16.10</version>
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



#### 编写实体类

<span style="backGround: #efe0b9">com/master/pojo/User.java</span>

```java
@Data
public class User {
    private int id;
    private String name;
    private String pwd;
}
```



#### 编写接口

<span style="backGround: #efe0b9">com/master/mapper/UserMapper.java</span>

```
public interface UserMapper {
    public List<User> selectUser();
}
```



#### 编写配置文件

<span style="backGround: #efe0b9">src/main/resources/mybatis-config.xml</span>

```html
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <typeAliases>
        <package name="com.master.pojo"/>
    </typeAliases>
    
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
        <mapper class="com.master.mapper.UserMapper"/>
    </mappers>
</configuration>
```

:point_down: 这里配置了别名，并把接下来要编写的 mapper 提前注册进来了。



#### 编写xml

<span style="backGround: #efe0b9">com/master/mapper/UserMapper.xml</span>

```html
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.master.mapper.UserMapper">
    <select id="selectUser" resultType="user">
        select * from demo.users
    </select>
</mapper>
```



#### 测试

```java
@Test
public void test() throws IOException {
    String resource = "mybatis-config.xml";
    InputStream inputStream = Resources.getResourceAsStream(resource);
    SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
    SqlSession sqlSession = sqlSessionFactory.openSession(true);

    UserMapper mapper = sqlSession.getMapper(UserMapper.class);
    List<User> userList = mapper.selectUser();

    for (User user : userList) {
        System.out.println(user);
    }
}
```



### 整合方式一



#### 协调整合

其实就是将 SqlSession 工厂和 SqlSession 交给了 Spring 托管

1. 配置数据源、selSessionFactory
2. 配置 SqlSessionTemplate
3. 引入 SqlSessionTemplate 实例

<span style="backGround: #efe0b9">resources/spring-dao.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/aop
       http://www.springframework.org/schema/aop/spring-aop.xsd">

    <!--数据源-->
    <bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
        <property name="driverClassName" value="com.mysql.jdbc.Driver"/>
        <property name="url" value="jdbc:mysql://localhost:3306/demo?useSSl=true&amp;useUnicode=true&amp;characterEncoding=UTF-8"/>
        <property name="username" value="root"/>
        <property name="password" value="didier5098"/>
    </bean>

    <!--sqlSessionFactory-->
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <!--绑定数据源-->
        <property name="dataSource" ref="dataSource"/>
        <!--绑定mybatis配置文件-->
        <property name="configLocation" value="classpath:mybatis-config.xml"/>
        <property name="mapperLocations" value="classpath:com/master/mapper/*.xml"/>
    </bean>

    <!--SqlSessionTemplate:即mybatis的sqlSession-->
    <bean id="sqlSession" class="org.mybatis.spring.SqlSessionTemplate">
        <constructor-arg index="0" ref="sqlSessionFactory"/>
    </bean>

    <!--SqlSessionTemplate实例-->
    <bean id="userMapper" class="com.master.mapper.UserMapperImpl">
        <property name="sqlSession" ref="sqlSession"/>
    </bean>

</beans>
```

:turtle: 这里<span style="color: #a50">配置 SqlSessionTemplate</span> 时，使用构造器注入参数，其实就是向构造器传参，新建实例；

:point_down: 这里的 <span style="color: #a50">SqlSessionTemplate 实例</span> 在下面编写



#### 去除多余配置

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
</configuration>
```

#### sqlSessionTemplate实例

<span style="backGround: #efe0b9">com/master/mapper/UserMapperImpl.java</span>

```java
public class UserMapperImpl implements UserMapper {

    // 原本使用sqlSession执行的操作，需要改为使用sqlSessionTemplate
    private SqlSessionTemplate sqlSession;

    public void setSqlSession(SqlSessionTemplate sqlSession) {
        this.sqlSession = sqlSession;
    }

    @Override
    public List<User> selectUser() {
        UserMapper mapper = sqlSession.getMapper(UserMapper.class);
        return mapper.selectUser();
    }
}
```

#### 测试

```java
public void test() {
    ApplicationContext context = new ClassPathXmlApplicationContext("spring-dao.xml");

    UserMapper userMapper = context.getBean("userMapper", UserMapper.class);
    for (User user : userMapper.selectUser()) {
        System.out.println(user);
    }
}
```

#### 优化配置

可以将 <span style="backGround: #efe0b9">mybatis-config.xml</span> 中的 <span style="color: #a50">SqlSessionTemplate实例</span>部分抽取处来，让它成为纯配置文件。

<span style="backGround: #efe0b9">resources/applicationContext.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/aop
       http://www.springframework.org/schema/aop/spring-aop.xsd">

    <import resource="spring-dao.xml"/>

	<!--SqlSessionTemplate实例-->
    <bean id="userMapper" class="com.master.mapper.UserMapperImpl">
        <property name="sqlSession" ref="sqlSession"/>
    </bean>

</beans>
```





## 整合方式二

借助 <span style="color: #a50">SqlSessionDaoSupport</span>，可以省略掉 SqlSessionTemplate 的配置。

#### sqlSessionTemplate实例

<span style="backGround: #efe0b9">com/master/mapper/UserMapperImpl2.java</span>

```java
public class UserMapperImpl2 extends SqlSessionDaoSupport implements UserMapper {
    @Override
    public List<User> selectUser() {
        return getSqlSession().getMapper(UserMapper.class).selectUser();
    }
}
```

#### 注册实例

<span style="backGround: #efe0b9">resources/applicationContext.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/aop
       http://www.springframework.org/schema/aop/spring-aop.xsd">

    <import resource="spring-dao.xml"/>

    <bean id="userMapper2" class="com.master.mapper.UserMapperImpl2">
        <property name="sqlSessionFactory" ref="sqlSessionFactory"/>
    </bean>

</beans>
```

:ghost: 通过这种方式，可以省略掉整合方式一，协调整合中的 SqlSessionTemplate 配置。

#### 测试

```java
@Test
public void test() {
    ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");

    UserMapper userMapper = context.getBean("userMapper2", UserMapper.class);
    for (User user : userMapper.selectUser()) {
        System.out.println(user);
    }
}
```



## 事务

### 事务回顾

> 这个例子相当于准备环境，没什么新的知识点。

#### 编辑接口

<span style="backGround: #efe0b9">com/master/mapper/UserMapper.java</span>

```java
public interface UserMapper {
    public List<User> selectUser();

    // 添加用户
    public int addUser(User user);
    // 删除用户
    public int deleteUser(int id);
}
```

#### 编辑xml

<span style="backGround: #efe0b9">com/master/mapper/UserMapper.xml</span>

```html
<mapper namespace="com.master.mapper.UserMapper">
    <select id="selectUser" resultType="user">
        select * from demo.users
    </select>

    <insert id="addUser" parameterType="user">
        insert into demo.users (id, name, pwd) values (#{id}, #{name}, #{pwd});
    </insert>
    
    <delete id="deleteUser" parameterType="int">
        delete from demo.users where id=#{id}
    </delete>
</mapper>
```

#### 编辑实体类

添加了有参、无参构造

<span style="backGround: #efe0b9">com/master/pojo/User.java</span>

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {
    private int id;
    private String name;
    private String pwd;
}
```

#### sqlSessionTemplate实例

<span style="backGround: #efe0b9">com/master/mapper/UserMapperImpl2.java</span>

```java
public class UserMapperImpl2 extends SqlSessionDaoSupport implements UserMapper {

    @Override
    public List<User> selectUser() {
        UserMapper mapper = getSqlSession().getMapper(UserMapper.class);

        mapper.addUser(new User(5, "demo", "213"));
        mapper.deleteUser(5);

        return mapper.selectUser();
    }

    @Override
    public int addUser(User user) {
        return getSqlSession().getMapper(UserMapper.class).addUser(user);
    }

    @Override
    public int deleteUser(int id) {
        return getSqlSession().getMapper(UserMapper.class).deleteUser(id);
    }
}
```

#### 测试

```java
@Test
public void test3() {
    ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");

    UserMapper userMapper = context.getBean("userMapper2", UserMapper.class);

    List<User> userList = userMapper.selectUser();

    for (User user : userList) {
        System.out.println(user);
    }
}
```



### Spring声明式事务

开启方式：

1. 顶部的 beans 添加了属性

2. 添加了 配置声明式事务 及下面的部分

<span style="backGround: #efe0b9">resources/spring-dao.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:tx="http://www.springframework.org/schema/tx"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/aop
       http://www.springframework.org/schema/aop/spring-aop.xsd
       http://www.springframework.org/schema/tx
       http://www.springframework.org/schema/tx/spring-tx.xsd">

    <!--数据源-->
    <bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
        <property name="driverClassName" value="com.mysql.jdbc.Driver"/>
        <property name="url" value="jdbc:mysql://localhost:3306/demo?useSSl=true&amp;useUnicode=true&amp;characterEncoding=UTF-8"/>
        <property name="username" value="root"/>
        <property name="password" value="didier5098"/>
    </bean>

    <!--sqlSessionFactory-->
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <!--绑定数据源-->
        <property name="dataSource" ref="dataSource"/>
        <!--绑定mybatis配置文件-->
        <property name="configLocation" value="classpath:mybatis-config.xml"/>
        <property name="mapperLocations" value="classpath:com/master/mapper/*.xml"/>
    </bean>

    <!--SqlSessionTemplate:即mybatis的sqlSession-->
    <bean id="sqlSession" class="org.mybatis.spring.SqlSessionTemplate">
        <constructor-arg index="0" ref="sqlSessionFactory"/>
    </bean>

    <!--配置声明式事务-->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dataSource"/>
    </bean>

    <!--结合AOP实现事务的织入-->
    <!--配置事务通知-->
    <tx:advice id="txAdvice" transaction-manager="transactionManager">
        <!--给哪些方法配置事务-->
        <tx:attributes>
            <tx:method name="addUser" propagation="REQUIRED"/>
            <tx:method name="deleteUser" propagation="REQUIRED"/>
            <tx:method name="*" propagation="REQUIRED"/>
        </tx:attributes>
    </tx:advice>

    <!--配置事务切入-->
    <aop:config>
        <aop:pointcut id="txPointCut" expression="execution(* com.master.mapper.*.*(..))"/>
        <aop:advisor advice-ref="txAdvice" pointcut-ref="txPointCut"/>
    </aop:config>

</beans>
```



