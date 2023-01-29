## 理论

### SpringBoot

内嵌tomcat

多数 Spring Boot 应用只需要很少的 Spring 配置，它集成了大量常用的第三方库配置（如 Redis、Jpa等）

Spring Boot 应用使用这些第三方库几乎可以零配置的开箱即用。



### 微服务架构

相当于将原本的应用拆成多个服务，每个服务提供相应的接口，可以将它们进行动态组合

**优点**

- 将服务部署到不同的服务器上，减少单个服务器的处理，减少服务器的压力；
- 每个功能元素的服务都是一个可替换、可以单独升级的软件代码；
- 而不像原来的应用，修改一些内容，需要整个应用暂停。

**缺点**

- 这种庞大的系统架构会给部署和运营带来很大的难度。





jdk1.8

maven 3.6.1

springboot 2.2.0

IDEA



## 创建项目

### 官网创建

**查看版本**

spring官网 - Projects - Spring Boot - LEARN 面板

**创建项目**

spring官网 - Projects - Spring Boot - 找到最下面的 Spring Initializr 点击

```elm
Bootstrap your application with Spring Initializr.
```

| 选项         | 选择                        | 说明              |
| ------------ | --------------------------- | ----------------- |
| Project      | Maven                       |                   |
| Language     | Java                        |                   |
| Spring Boot  | 2.7.6(视频选的是2.2.0)      | 出3.0了，怕不兼容 |
| Group        | com.master                  | 包的层级          |
| Packaging    | Jar                         | 打包方式          |
| Java         | 8                           |                   |
| Dependencies | 搜索添加一个 **Spring Web** |                   |

配置好后，点击 GENERATE，下载压缩包，解压

**打开项目**

打开IDEA，选择 Import Project，选中路径后，选中导入 Maven 项目，一路 Next 即可；

也可以在IDEA，点击 File - New - Project from Existing Sources... 导入



### IDEA自带创建

对于社区版，需要额外安装插件 [Spring Assistant](https://baijiahao.baidu.com/s?id=1729872515894299563&wfr=spider&for=pc)，才能在新建项目时出现对应选项；

如果还没有，再安装插件 Spring Boot Helper。



![image-20221211162402887](.\img\IDEA自带创建)

添加一下 Spring Web 相关配置

![image-20221211162524518](.\img\IDEA自带创建2)



**使用阿里云加速**

IDEA 自带的 maven 使用的是国外的地址，下载会很慢，要改成之前自己配好的。

![image-20221222104000227](.\img\使用阿里云加速)



### 端口占用解决

**kill 端口**

1、window+R，输入cmd，回车启动

2、查找端口的 pid（这里是8080，其它端口就改一下）

```elm
netstat -ano | findstr 8080
```

结果

```
TCP    0.0.0.0:8080    0.0.0.0.0    LISTENING    91112
```

3、杀进程  （这个19112是对应上一条语句搜索出来的PID）

```elm
taskkill /pid 19112 /f
```



**自定义启动端口号**

<span style="backGround: #efe0b9">resources/application.properties</span>

```
server.port=8083
```



### 默认结构介绍

| 文件                                  | 说明                         |
| ------------------------------------- | ---------------------------- |
| com/example/demo/DemoApplication.java | 主函数、可直接运行、不能删改 |
| resources/application.properties      | springboot 的核心配置文件    |
| pom.xml                               | 暴露父依赖、引入核心依赖等   |

<span style="backGround: #efe0b9">com/example/demo/DemoApplication.java</span>

```java
@SpringBootApplication
public class DemoApplication {
	public static void main(String[] args) {
        // 启动应用
		SpringApplication.run(DemoApplication.class, args);
	}
}
```

<span style="color: #f7534f;font-weight:600">@SpringBootApplication</span> 表示这个类是一个springboot应用；

:turtle: springboot 所有的自动配置都会在启动时扫描并加载，前提时导入对应的 start 以获得启动器。

<span style="backGround: #efe0b9">pom.xml</span>

```html
<!-- 父依赖 -->
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.7.6</version>
    <relativePath/> <!-- lookup parent from repository -->
</parent>

<properties>
    <java.version>1.8</java.version>
</properties>
<dependencies>
    <!-- web场景启动器：tomacat、dispatcherServlet、xml... -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
	<!-- springboot单元测试 -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>

<build>
    <plugins>
        <!-- 打包插件 -->
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```



#### 测试接口

注意包的位置要建在 DemoApplication.java 的同级下，否则会导致跑不起来

<span style="backGround: #efe0b9">com/example/demo/controller/Demo.java</span>

```java
public class Demo {

    @RequestMapping("/hello")
    public String hello() {
        return "hello, world!";
    }
}
```

启动项目后：

```elm
http://localhost:8080/hello
```



#### 打包

![image-20221222102739494](.\img\打包)



自定义启动端口号

<span style="backGround: #efe0b9">resources/application.properties</span>

```
server.port=8083
```



自定义启动标识

找到想要的[标识](https://www.bootschool.net/ascii-art/cartoons?pageNO=5)后，存到目录里即可。

<span style="backGround: #efe0b9">resources/banner.txt</span>



## yaml语法

比起通过 <span style="color: #a50">resources/application.properties</span> 配置，官方更推荐使用 <span style="color: #a50">resources/application.yaml</span>

<span style="backGround: #efe0b9">demo.yaml</span>

```yaml
# 普通
name: demo

# 对象
obj1:
  name: demo
  age: 3
  
obj2: {name: demo,age: 3}

# 数组
arr1:
  - cat
  - dog
  
arr2: [cat, dog]
```

:octopus: `.yaml` 文件中，键值对之间的空格不能省略，空格严格控制；

:ghost: `.properties` 只能存字符串，`.yaml` 还可以存对象或数组



### 给属性赋值

#### 1、普通方式

<span style="backGround: #efe0b9">com/example/demo/pojo/Dog.java</span>

```java
@Data
@Component
public class Dog {
    @Value("旺财")
    private String name;
    @Value("3")
    private Integer age;
}
```

<span style="color: #f7534f;font-weight:600">@Component</span> 代表将类注册到 Spring 中，装配 Bean

<span style="color: #f7534f;font-weight:600">@Value</span> 装配 Bean 是给相应属性赋值，可以放在属性/属性对应的set方法上

<span style="color: #f7534f;font-weight:600">@Data</span> 需要引入lombok依赖，生成 get/set/toString/无参构造

**测试**

<span style="backGround: #efe0b9">src/test/java/com/example/demo/DemoApplicationTests.java</span>

```java
@SpringBootTest
class DemoApplicationTests {

	@Autowired
	private Dog dog;

	@Test
	void contextLoads() {
		System.out.println(dog);
	}
}
```

<span style="color: #f7534f;font-weight:600">@Autowired</span> 可以添加到属性/对应的set方法上，它会先根据 byType，如果不行再根据 byName 规则去匹配 bean；



#### 2、通过yaml

<span style="backGround: #efe0b9">com/example/demo/pojo/Person.java</span>

```java
@Data
@Component
@ConfigurationProperties(prefix = "person")
public class Person {
    private String smallName;
    private Integer age;
    private Boolean happy;
    private Date birth;
    private Map<String, Object> maps;
    private List<Object> lists;
    private Dog dog;
}
```

<span style="color: #f7534f;font-weight:600">@ConfigurationProperties</span> 绑定 <span style="color: #a50">application.yaml</span> 中相应的值

<span style="backGround: #efe0b9">resources/application.yaml</span>

```yaml
person:
  small-name: demo
  age: 3
  happy: true
  birth: 2022/12/22
  maps: {k1: v1,k2: v2}
  lists: [cat, dog]
  dog:
    name: 旺财
    age: 3
```

<span style="color: #f7534f;font-weight:600">松散绑定</span> 这里的短横线分隔的组合能映射到小驼峰上。

**测试**

```java
@SpringBootTest
class DemoApplicationTests {

	@Autowired
	private Person person;
    
	@Test
	void contextLoads() {
		System.out.println(person);
	}
}
```



#### 3、通过properties

首先避免中文乱码问题

![image-20221222163204502](.\img\通过properties)

<span style="backGround: #efe0b9">resources/abc.properties</span>

```yaml
name: demo
```

<span style="backGround: #efe0b9">com/example/demo/pojo/Person.java</span>

```java
@Data
@Component
@PropertySource(value="classpath:abc.properties")
public class Person {
    private String name;
    private Integer age;
    private Boolean happy;
    private Date birth;
    private Map<String, Object> maps;
    private List<Object> lists;
    private Dog dog;
}
```

**测试**

同通过yaml。



### 其它用法

<span style="backGround: #efe0b9">resources/application.yaml</span>

```yaml
person:
  name: man${random.uuid}
  age: ${random.int}
  dog:
    name: ${person.tip:hey}_旺财
# person.name 将输出 hey_旺财，因为 person.tip 不存在
```



## JSR303校验

```java
@Data
@Component
@Validated
public class Dog {
    @Email(message="邮件格式错误")
    private String name;
    private Integer age;
}
```

<span style="color: #f7534f;font-weight:600">@Validated</span> 表示开启数据校验

<span style="color: #f7534f;font-weight:600">@Email</span> 具体的数据校验，邮箱，更多搜[jsr303](https://blog.csdn.net/HongYu012/article/details/123255351)

:question: 据说较高版本要使用，需要主动导入 <span style="color: #a50">spring-boot-starter-validation</span> 依赖

**常见参数**

```less
@NotNull(message="名字不能为空")
private String userName;
@Max(value=120,message="年龄最大不能查过120")
private int age;
@Email(message="邮箱格式错误")
private String email;

空检查
@Null       验证对象是否为null
@NotNull    验证对象是否不为null, 无法查检长度为0的字符串
@NotBlank   检查约束字符串是不是Null还有被Trim的长度是否大于0,只对字符串,且会去掉前后空格.
@NotEmpty   检查约束元素是否为NULL或者是EMPTY.
    
Booelan检查
@AssertTrue     验证 Boolean 对象是否为 true  
@AssertFalse    验证 Boolean 对象是否为 false  
    
长度检查
@Size(min=, max=) 验证对象（Array,Collection,Map,String）长度是否在给定的范围之内  
@Length(min=, max=) string is between min and max included.

日期检查
@Past       验证 Date 和 Calendar 对象是否在当前时间之前  
@Future     验证 Date 和 Calendar 对象是否在当前时间之后  
@Pattern    验证 String 对象是否符合正则表达式的规则
```



## 多环境切换

### 配置文件位置

1. `file:./config/`

2. `file:./`

3. `classpath:/config/`

4. `classpath:/`

:turtle: 存在多个文件时，匹配优先级由上往下，越下优先级越低。

```elm
- 项目
  + config
    - application.yaml          # 位置1
  + application.yaml            # 位置2
  + src
    - main
      + resources
        - config
          + application.yaml    # 位置3
        - application.yaml      # 位置4
```



### 多环境配置-properties

```elm
- 项目
  + src
    - main
      + resources
        - application.properties     
        - application-dev.properties    
        - application-test.properties    
```

<span style="backGround: #efe0b9">resources/application.properties</span>

```properties
# 激活test
spring.profiles.active=test
```

:hammer_and_wrench: 可以自定义需要激活的环境配置

<span style="backGround: #efe0b9">application-dev.properties</span>

```properties
server.port=8081
```

<span style="backGround: #efe0b9">application-test.properties</span>

```properties
server.port=8082
```



### 多环境配置-yaml

```elm
- 项目
  + src
    - main
      + resources
        - application.yaml  
```

<span style="backGround: #efe0b9">application.yaml</span>

```yaml
server:
  port: 8081
#选择要激活那个环境块
spring:
  profiles:
    active: prod

---
server:
  port: 8083
spring:
  profiles: dev #配置环境的名称


---

server:
  port: 8084
spring:
  profiles: prod  #配置环境的名称
```

:hammer_and_wrench: 使用 `.yml`，就可以在一个文件中实现配置，切换环境。



## 自动装配原理

### 精髓

1、SpringBoot 启动会加载大量的自动配置类；

2、自动装配类中包含了很多的功能，组件（如果本身有，就不需手动配置了）；

3、给容器中自动配置类添加组件时，会从properties类中获取某些属性，可以在配置文件中指定属性值；

<span style="color: #f7534f;font-weight:600">xxxxAutoConfigurartion</span> 自动配置类，给容器中添加组件

<span style="color: #f7534f;font-weight:600">xxxxProperties</span> 封装配置文件中相关属性；

<span style="color: #f7534f;font-weight:600">配置文件</span> properties、yaml



### 生效条件

只有 <span style="color: #a50">@Conditional</span> 指定的条件成立，才会给容器中添加组件，<span style="color: #a50">自动配置类</span>里面的内容才生效。

![图片](.\img\自动配置类)



## 静态资源导入

### 默认查找路径

```elm
"classpath:/META-INF/resources/"
"classpath:/resources"
"classpath:/static/"
"classpath:/public/"
```

多个目录下存在相同资源时，优先使用靠前的目录资源

<span style="backGround: #efe0b9">src/main/resources/static</span>

```elm
resources
  - resources  // 对应二级
    + demo.js
  - static	   // 对应三级
  - public     // 对应四级
```

**访问资源**

可以通过该路径访问资源

```less
http://localhost:8080/demo.js
```



### 自定义资源路径

<span style="backGround: #efe0b9">resources/application.properties</span>

```properties
spring.mvc.static-path-pattern=/demo/**
```

:hammer_and_wrench: 可以自定义静态资源的路径，此时默认路径失效。



### 存放首页

可以将 `index.html` 存放在上面提到的资源路径下，可以被查找到。



## thymeleaf模板引擎

### 导入依赖

```html
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-thymeleaf</artifactId>
    <version>2.7.6</version>
</dependency>
```

:ghost: 添加依赖后，查找模板时，会自动添加前缀 `classpath:/templates/` ，后缀 `.html` 

### 创建模板

<span style="backGround: #efe0b9">resources/templates/test.html</span>

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<h1>test123</h1>
<!-- 原样输出 -->
<p th:text="${msg}"></p>
<!-- 相当于v-html -->
<p th:utext="${msg}"></p>

<!-- 遍历数组的两种方式 -->
<h3 th:each="user:${users}">[[ ${user} ]]</h3>

<h3 th:each="user:${users}" th:text="${user}"></h3>

</body>
</html>
```

### 路径指向模板

<span style="backGround: #efe0b9">com/example/demo/controller/IndexController.java</span>

```java
@Controller
public class IndexController {

    @RequestMapping("/abc")
    public String test(Model model) {
        model.addAttribute("msg", "<h1>hello</h1>");
        model.addAttribute("users", Arrays.asList("dog", "cat"));
        return "test";
    }
}
```

```elm
http://localhost:8080/abc
```



## 扩展SpringMVC

这个例子，输入 `http://localhost:8080/abcd`，将会跳转到 `test.html` 上

<span style="backGround: #efe0b9">com/example/demo/config/MyMvConfig.java</span>

```java
@Configuration
public class MyMvConfig implements WebMvcConfigurer {

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/abcd").setViewName("test");
    }
}
```

:turtle: 编写一个 @Configuration 注解类，并且实现 WebMvcConfigurer，还不能标注 @EnableWebMvc 注解



## 员工管理系统

### 准备工作

#### 准备静态资源

```elm
- resources
  + static
    - css
    - img
    - js
  + templates
    - 404.html
    - index.html
    - ....html
```



#### 准备实体类

<span style="backGround: #efe0b9">com/example/demo/pojo/Employee.java</span>

```java
// 员工表
@Data
@NoArgsConstructor
public class Employee {
    private Integer id;
    private String lastName;
    private String email;
    private Integer gender;
    private Department department;
    private Date birth;

    public Employee(Integer id, String lastName, String email, Integer gender, Department department) {
        this.id = id;
        this.lastName = lastName;
        this.email = email;
        this.gender = gender;
        this.department = department;
        this.birth = new Date();
    }
}
```

<span style="backGround: #efe0b9">com/example/demo/pojo/Department.java</span>

```java
// 部门表
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Department {
    private Integer id;
    private String departmentName;
}
```



#### 准备dao层

<span style="backGround: #efe0b9">com/example/demo/dao/DepartmentDao.java</span>

```java
@Repository
public class DepartmentDao {
    // 模拟数据(部门表)
    private static Map<Integer, Department> departments = null;
    static {
        departments = new HashMap<Integer, Department>();

        departments.put(101, new Department(101, "教学部"));
        departments.put(102, new Department(102, "市场部"));
        departments.put(103, new Department(103, "教研部"));
        departments.put(104, new Department(104, "运营部"));
        departments.put(105, new Department(105, "后勤部"));
    }

    // 获得所有部门
    public Collection<Department> getDepartments() {
        return departments.values();
    }

    // 通过id获取部门
    public Department getDepartmentById(Integer id) {
        return departments.get(id);
    }
}
```

**衍生注解**

| 注解        | 习惯用于用于分层 |
| ----------- | ---------------- |
| @Repository | dao/mapper       |
| @Service    | service          |
| @Controller | controller       |

:hammer_and_wrench: 这几个注解的作用与 <span style="color: #a50">@Component</span> 一样，都代表将类注册到 Spring 中，装配Bean。

<span style="backGround: #efe0b9">com/example/demo/dao/EmployeeDao.java</span>

```java
@Repository
public class EmployeeDao {
    // 模拟数据（员工表）
    private static Map<Integer, Employee> employees = null;
    @Autowired
    private DepartmentDao departmentDao;
    static {
        employees = new HashMap<Integer, Employee>();

        employees.put(1001, new Employee(1001, "AA", "12@qq.com", 0, new Department(101, "教学部")));
        employees.put(1002, new Employee(1002, "AA", "12@qq.com", 1, new Department(102, "市场部")));
        employees.put(1003, new Employee(1003, "AA", "12@qq.com", 0, new Department(103, "教研部")));
        employees.put(1004, new Employee(1004, "AA", "12@qq.com", 1, new Department(104, "运营部")));
        employees.put(1005, new Employee(1005, "AA", "12@qq.com", 0, new Department(105, "后勤部")));
    }

    // 模拟自增主键
    private static Integer initId = 1006;

    // 添加员工
    public void save(Employee employee) {
        if (employee.getId()==null) {
            employee.setId(initId++);
        }
        employee.setDepartment(departmentDao.getDepartmentById(employee.getDepartment().getId()));

        employees.put(employee.getId(), employee);
    }

    // 查询全部员工
    public Collection<Employee> getAll() {
        return employees.values();
    }

    // 通过id获取员工
    public Employee getEmployeeById(Integer id) {
        return employees.get(id);
    }

    // 删除员工
    public void delete(Integer id) {
        employees.remove(id);
    }

}
```



### 首页实现

<span style="backGround: #efe0b9">com/example/demo/config/MyMvConfig.java</span>

```java
@Configuration
public class MyMvConfig implements WebMvcConfigurer {

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/").setViewName("index");
        registry.addViewController("/index.html").setViewName("index");
    }
}
```

### 登录退出功能

<span style="backGround: #efe0b9">com/example/demo/controller/LoginController.java</span>

```java
@Controller
public class LoginController {

    @RequestMapping("/user/login")
    public String login(@RequestParam("username") String username, @RequestParam("password") String password, Model model, HttpSession session) {
        if (StringUtils.isEmpty(username) || StringUtils.isEmpty(password)) {
            model.addAttribute("msg", "登录失败");
            return "index";
        }
        session.setAttribute("loginUser", username);
        return "redirect:/main.html";
    }
    
    @RequestMapping("/user/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/index.html";
    }
}
```

:point_down: 这里添加的 session 为下一节做准备。



### 登录拦截器

#### 编写拦截器

<span style="backGround: #efe0b9">com/example/demo/config/LoginHandlerInterceptor.java</span>

```java
public class LoginHandlerInterceptor implements HandlerInterceptor {

	@Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ServletException, IOException {
        // 登录成功后，会存在用户的session
        Object loginUser = request.getSession().getAttribute("loginUser");

        if (loginUser==null) {
            request.setAttribute("msg", "没有权限,请先登录");
            request.getRequestDispatcher("/index.html").forward(request, response);
            return false;
        } else {
            return true;
        }
    }
}
```

:ghost: 实现了 <span style="color: #a50">HandlerInterceptor</span> 接口的类，便能成为拦截类



#### 注册配置

<span style="backGround: #efe0b9">com/example/demo/config/MyMvConfig.java</span>

```java
@Configuration
public class MyMvConfig implements WebMvcConfigurer {

    // ...
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LoginHandlerInterceptor())
                .addPathPatterns("/**")
                .excludePathPatterns("index.html", "/", "/user/login", "/static/*");
    }
}
```



### 展示员工列表

<span style="backGround: #efe0b9">com/example/demo/controller/EmployeeController.java</span>

```java
@Controller
public class EmployeeController {
    @Autowired
    EmployeeDao employeeDao;

    // 跳转到展示列表页
    @RequestMapping("/emps")
    public String list(Model model) {
        Collection<Employee> employees = employeeDao.getAll();
        model.addAttribute("emps", employees);
        return "emp/list";
    }
}
```



### 添加员工

<span style="backGround: #efe0b9">com/example/demo/controller/EmployeeController.java</span>

```java
@Controller
public class EmployeeController {
    @Autowired
    DepartmentDao departmentDao;

    //...
    // 跳转到添加员工页
    @GetMapping("/emp")
    public String toAddpage(Model model) {
        // 获取全部部门信息
        Collection<Department> departments = departmentDao.getDepartments();
        model.addAttribute("departments", departments);
        return "emp/add";
    }

    // 添加员工
    @PostMapping("/emp")
    public String addEmp(Employee employee) {
        employeeDao.save(employee);
        return "redirect:/emps";
    }
}
```



### 修改员工

<span style="backGround: #efe0b9">com/example/demo/controller/EmployeeController.java</span>

```java
@Controller
public class EmployeeController {
    
    // ...
    // 前往修改员工页面
    @GetMapping("/emp/{id}")
    public String toUpdateEmp(@PathVariable("id") Integer id, Model model) {
        // 查该员工的数据
        Employee employee = employeeDao.getEmployeeById(id);
        model.addAttribute("emp", employee);
        // 查出所有部门数据
        Collection<Department> departments = departmentDao.getDepartments();
        model.addAttribute("departments", departments);

        return "emp/update";
    }

    // 修改员工信息
    @PostMapping("updateEmp")
    public String updateEmp(Employee employee) {
        employeeDao.save(employee);
        return "redirect:/emps";
    }
}
```



### 删除员工

<span style="backGround: #efe0b9">com/example/demo/controller/EmployeeController.java</span>

```java
@Controller
public class EmployeeController {

	// ...
    // 删除员工
    @GetMapping("/delemp/{id}")
    public String deleEmp(@PathVariable("id") int id) {
        employeeDao.delete(id);
        return "redirect:/emps";
    }
}
```



### 错误请求匹配页面

按照规范存放文件，触发相应网络错误时，将会自动跳转到相应页面。

```elm
- resources
  + templates
    - error
      + 404.html
      + 500.html
```



## 整合JDBC使用

### 创建springboot项目

![image-20221223204835080](.\img\整合JDBC创建项目)



### 配置数据库信息

<span style="backGround: #efe0b9">resources/application.yaml</span>

```yaml
spring:
  datasource:
    username: root
    password: xxx
    url: jdbc:mysql://localhost:3306/demo?serverTimezone=UTC&useSSL=true&useUnicode=true&characterEncoding=utf8
    driver-class-name: com.mysql.cj.jdbc.Driver
```

可能是版本的关系，这里的 Driver 如果照课程使用 `com.mysql.jdbc.Driver` 会有警告。



### 测试数据库连接

<span style="backGround: #efe0b9">com/example/springbootjdbc/SpringbootJdbcApplicationTests.java</span>

```java
@SpringBootTest
class SpringbootJdbcApplicationTests {
    @Autowired
    DataSource dataSource;

    @Test
    void contextLoads() throws SQLException {
        System.out.println(dataSource.getClass());
        // 获得数据库链接
        Connection connection = dataSource.getConnection();
        // 关闭
        connection.close();
    }
}
```



### 测试操作数据库

<span style="backGround: #efe0b9">com/example/springbootjdbc/controller/JDBCController.java</span>

```java
@RestController
public class JDBCController {
    @Autowired
    JdbcTemplate jdbcTemplate;

    @GetMapping("/userL")
    public List<Map<String, Object>> userList() {
        String sql = "select * from user";
        List<Map<String, Object>> listMaps = jdbcTemplate.queryForList(sql);
        return listMaps;
    }
    
    @GetMapping("/addUser")
    public String addUser() {
        String sql = "insert into users(id, name, pwd) values (4, 'ddemo', '123456')";
        jdbcTemplate.update(sql);
        return "update-ok";
    }

    @GetMapping("/updateUser/{id}")
    public String updateUser(@PathVariable("id") int id) {
        String sql = "update users set name=?, pwd=? where id="+id;

        // 数据
        Object[] objects = new  Object[2];
        objects[0] = "小明";
        objects[1] = "zz";
        jdbcTemplate.update(sql, objects);
        return "updateUser-ok";
    }
    
    @GetMapping("/deleteUser/{id}")
    public String deleteUser(@PathVariable("id") int id) {
        String sql = "delete from users where id = ?";
        jdbcTemplate.update(sql, id);
        return "deleteUser-ok";
    }
}
```



## 整合Druid数据源

### 配置数据源

#### 添加依赖

<span style="backGround: #efe0b9">pom.xml</span>

```html
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>druid</artifactId>
    <version>1.1.21</version>
</dependency>
```



#### 切换数据源

<span style="backGround: #efe0b9">resources/application.yaml</span>

```yaml
spring:
  datasource:
    username: root
    password: xxx
    url: jdbc:mysql://localhost:3306/demo?serverTimezone=UTC&useSSL=true&useUnicode=true&characterEncoding=utf8
    driver-class-name: com.mysql.cj.jdbc.Driver
    type: com.alibaba.druid.pool.DruidDataSource # 自定义数据源
```

:whale: Spring Boot 2.0 以上默认使用 `com.zaxxer.hikari.HikariDataSource` 数据源，可以通过 <span style="color: #a50">spring.datasource.type</span> 指定数据源。



#### 配置数据源

<span style="backGround: #efe0b9">resources/application.yaml</span>

```yaml
spring:
  datasource:
    username: root
    password: xxx
    url: jdbc:mysql://localhost:3306/demo?serverTimezone=UTC&useSSL=true&useUnicode=true&characterEncoding=utf8
    driver-class-name: com.mysql.cj.jdbc.Driver
    type: com.alibaba.druid.pool.DruidDataSource # 自定义数据源
    
    #druid 数据源专有配置
    initialSize: 5
    minIdle: 5
    maxActive: 20
    maxWait: 60000
    timeBetweenEvictionRunsMillis: 60000
    minEvictableIdleTimeMillis: 300000
    validationQuery: SELECT 1 FROM DUAL
    testWhileIdle: true
    testOnBorrow: false
    testOnReturn: false
    poolPreparedStatements: true
    #配置监控统计拦截的filters，stat:监控统计、log4j：日志记录、wall：防御sql注入
    filters: stat,wall,log4j
    maxPoolPreparedStatementPerConnectionSize: 20
    useGlobalDataSourceStat: true
    connectionProperties: druid.stat.mergeSql=true;druid.stat.slowSqlMillis=500
```

##### 添加依赖

<span style="backGround: #efe0b9">pom.xml</span>

```html
<dependency>
    <groupId>log4j</groupId>
    <artifactId>log4j</artifactId>
    <version>1.2.17</version>
</dependency>
```

:octopus: 据说该依赖后面被曝出有bug，会被远程使用。

##### 绑定配置

<span style="backGround: #efe0b9">com/example/springbootjdbc/config/DruidConfig.java</span>

```java
@Configuration
public class DruidConfig {
    // 绑定配置
    @ConfigurationProperties(prefix = "spring.datasource")
    @Bean
    public DataSource druidDataSource() {
        return new DruidDataSource();
    }
}
```

##### 测试

```java
@SpringBootTest
class SpringbootJdbcApplicationTests {
    @Autowired
    DataSource dataSource;

    @Test
    void contextLoads() throws SQLException {
        // 获得数据库链接
        Connection connection = dataSource.getConnection();
        System.out.println(dataSource.getClass());

        DruidDataSource druidDataSource = (DruidDataSource) dataSource;
        System.out.println("druidDataSource 数据源最大连接数：" + druidDataSource.getMaxActive());
        System.out.println("druidDataSource 数据源初始化连接数：" + druidDataSource.getInitialSize());
        // 关闭
        connection.close();
    }
}
```



#### 配置监控

<span style="backGround: #efe0b9">com/example/springbootjdbc/config/DruidConfig.java</span>

```java
// 配置 Druid 监控管理后台的Servlet；
@Bean
public ServletRegistrationBean statViewServlet() {
    ServletRegistrationBean bean = new ServletRegistrationBean(new StatViewServlet(), "/druid/*");

    Map<String, String> initParams = new HashMap<>();
    initParams.put("loginUsername", "admin"); //后台管理界面的登录账号
    initParams.put("loginPassword", "123456"); //后台管理界面的登录密码

    //后台允许谁可以访问
    //initParams.put("allow", "localhost")：表示只有本机可以访问
    //initParams.put("allow", "")：为空或者为null时，表示允许所有访问
    initParams.put("allow", "");

    //设置初始化参数
    bean.setInitParameters(initParams);
    return bean;
}
```

**访问**

```elm
http://localhost:8080/druid
```

**示例**

![image-20221223225419713](.\img\druid监控)



#### 配置监听过滤

<span style="backGround: #efe0b9">com/example/springbootjdbc/config/DruidConfig.java</span>

```java
// 配置 Druid 监控的 filter
@Bean
public FilterRegistrationBean webStatFilter() {
    FilterRegistrationBean bean = new FilterRegistrationBean();
    bean.setFilter(new WebStatFilter());

    //exclusions：设置哪些请求进行过滤排除掉，从而不进行统计
    Map<String, String> initParams = new HashMap<>();
    initParams.put("exclusions", "*.js,*.css,/druid/*,/jdbc/*");
    bean.setInitParameters(initParams);

    //"/*" 表示过滤所有请求
    bean.setUrlPatterns(Arrays.asList("/*"));
    return bean;
}
```

<span style="color: #ed5a65">WebStatFilter</span> 用于配置 Web 和 Druid 数据源之间的管理关联监控统计。



## 整合Mybatis框架

### 环境准备

新建 springboot 项目，勾选依赖：

- Spring Web
- JDBC API
- MySQL Driver

#### 导入依赖

```html
<dependency>
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter</artifactId>
    <version>2.1.1</version>
</dependency>
<!-- 偷懒 -->
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>1.18.12</version>
</dependency>
```

:whale: SpringBoot官方的依赖，通常使用 spring-boot 作为开头，而这个明显不是官方的。

#### 配置数据库连接

<span style="backGround: #efe0b9">resources/application.properties</span>

```properties
spring.datasource.username=root
spring.datasource.password=xxx
spring.datasource.url=jdbc:mysql://localhost:3306/demo?serverTimezone=UTC&useSSL=true&useUnicode=true&characterEncoding=utf8
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

#### 测试

<span style="backGround: #efe0b9">com/example/SpringbootMybatisApplicationTests.java</span>

```java
@SpringBootTest
class SpringbootMybatisApplicationTests {
    @Autowired
    DataSource dataSource;

    @Test
    void contextLoads() throws SQLException {
        System.out.println(dataSource.getClass());
        System.out.println(dataSource.getConnection());
    }
}
```



### 进行增删查改

为了迅速实现效果，这里省略了业务层service。

#### 实体类

<span style="backGround: #efe0b9">com/example/pojo/User.java</span>

```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    private int id;
    private String name;
    private String pwd;
}
```

#### mapper-接口

<span style="backGround: #efe0b9">com/example/mapper/UserMapper.java</span>

```java
@Mapper
@Repository
public interface UserMapper {

    List<User> queryUserList();

    User queryUserById(int id);

    int addUser(User user);

    int updateUser(User user);

    int deleteUser(int id);
}
```

<span style="color: #f7534f;font-weight:600">@Mapper</span> 表示这个类是 mybatis 的 mapper 类。

#### mapper-xml

<span style="backGround: #efe0b9">src/main/resources/mybatis/mapper/UserMapper.xml</span>

```html
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.example.mapper.UserMapper">
    <select id="queryUserList" resultType="User">
        select * from users
    </select>

    <select id="queryUserById" resultType="User">
        select * from users where id = #{id}
    </select>

    <insert id="addUser" parameterType="User">
        insert into users (id, name, pwd) values (#{id}, #{name}, #{pwd})
    </insert>

    <update id="updateUser" parameterType="User">
        update users set name=#{name}, pwd=#{pwd} where id = #{id}
    </update>

    <delete id="deleteUser" parameterType="int">
        delete from users where id = #{id}
    </delete>
</mapper>
```

#### 整合mybatis

<span style="backGround: #efe0b9">resources/application.properties</span>

```properties
spring.datasource.username=root
spring.datasource.password=xxx
spring.datasource.url=jdbc:mysql://localhost:3306/demo?serverTimezone=UTC&useSSL=true&useUnicode=true&characterEncoding=utf8
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# 整合mybatis
mybatis.type-aliases-package=com.example.pojo
mybatis.mapper-locations=classpath:mybatis/mapper/*.xml
```

#### 控制层

> 请求相应的接口路径，即可增删查改。

<span style="backGround: #efe0b9">com/example/controller/UserController.java</span>

```java
@RestController
public class UserController {
    @Autowired
    private UserMapper userMapper;

    // 查询列表
    @GetMapping("/queryUserList")
    public List<User> queryUserList() {
        List<User> userList = userMapper.queryUserList();
        for (User user : userList) {
            System.out.println(user);
        }
        return userList;
    }

    // 添加用户
    @GetMapping("/addUser")
    public String addUser() {
        userMapper.addUser(new User(5, "demo", "123"));
        return "ok";
    }

    // 修改用户
    @GetMapping("/updateUser")
    public String updateUser() {
        userMapper.updateUser(new User(5, "demo", "456"));
        return "ok";
    }

    // 根据id删除用户
    @GetMapping("/deleteUser")
    public String deleteUser() {
        userMapper.deleteUser(5);
        return "ok";
    }
}
```



## SpringSecurity

与 Shrio 相似，用于身份认证、权限控制等的一个框架。

### 页面环境搭建

新建 springboot 项目，勾选依赖：

- Spring Web

#### 导入依赖

```html
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-thymeleaf</artifactId>
    <version>2.7.6</version>
</dependency>
```

#### 准备页面

#### 控制层

<span style="backGround: #efe0b9">com/example/controller/RouterController.java</span>

```java
@Controller
public class RouterController {

    @RequestMapping({"/","/index"})
    public String index(){
        return "index";
    }

    @RequestMapping("/toLogin")
    public String toLogin(){
        return "views/login";
    }

    @RequestMapping("/level1/{id}")
    public String level1(@PathVariable("id") int id){
        return "views/level1/"+id;
    }

    @RequestMapping("/level2/{id}")
    public String level2(@PathVariable("id") int id){
        return "views/level2/"+id;
    }

    @RequestMapping("/level3/{id}")
    public String level3(@PathVariable("id") int id){
        return "views/level3/"+id;
    }
}
```



### 认证和授权

#### 导入依赖

```html
<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

#### 编写基础配置类

<span style="backGround: #efe0b9">com/example/config/SecurityConfig.java</span>

```java
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        // 定制请求的授权规则
        // 首页所有人可以访问
        http.authorizeRequests().antMatchers("/").permitAll()
                .antMatchers("/level1/**").hasRole("vip1")
                .antMatchers("/level2/**").hasRole("vip2")
                .antMatchers("/level3/**").hasRole("vip3");

        // 开启自动配置的登录功能
        // 会进行 /login 请求来到登录页
        http.formLogin();
        
        // 开启注销功能，跳去首页
        http.logout().logoutUrl("/");
        
        // 开启保持登录功能
        http.rememberMe();
    }

    //定义认证规则
    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {

        // 这里定义了加密方式，并对密码使用
        auth.inMemoryAuthentication().passwordEncoder(new BCryptPasswordEncoder())
                .withUser("kuangshen").password(new BCryptPasswordEncoder().encode("123456")).roles("vip2","vip3")
                .and()
                .withUser("root").password(new BCryptPasswordEncoder().encode("123456")).roles("vip1","vip2","vip3")
                .and()
                .withUser("guest").password(new BCryptPasswordEncoder().encode("123456")).roles("vip1","vip2");
    }
}
```

<span style="color: #f7534f;font-weight:600">@EnableWebSecurity</span> 表示开启 WebSecurity 模式



## Swagger

### Swagger集成

新建 springboot 项目，勾选依赖：

- Spring Web

#### 导入依赖

```html
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

:octopus: 高版本 spring-boot 走流程，会导致空指针报错，需要将 <span style="color: slategray">spring-boot-starter-parent</span> 的版本降为 2.5.6

#### 配置swagger

<span style="backGround: #efe0b9">com/master/config/SwaggerConfig.java</span>

```java
@Configuration
@EnableSwagger2
public class SwaggerConfig {
}
```

<span style="color: #f7534f;font-weight:600">@Configuration</span> 继承自 @Component 表示被 spring 接管，为配置类

#### 编写测试接口

<span style="backGround: #efe0b9">com/master/controller/HelloController.java</span>

```java
@RestController
public class HelloController {

    @RequestMapping(value="hello")
    public String hello() {
        return "hello";
    }
}
```

#### 访问swagger

```elm
http://localhost:8080/swagger-ui.html
```



### 配置信息

<span style="backGround: #efe0b9">com/master/config/SwaggerConfig.java</span>

```java
@Configuration
@EnableSwagger2
public class SwaggerConfig {

    // 配置swagger的docket的bean实例
    @Bean
    public Docket docket() {
        return new Docket(DocumentationType.SWAGGER_2).apiInfo(apiInfo());
    }

    //配置文档信息
    private ApiInfo apiInfo() {
        // 联系信息
        Contact contact = new Contact("master", "http://xxx.xxx.com/", "xx@qq.com");
        return new ApiInfo(
                "商品模块", // 标题
                "商品模块相关api", // 描述
                "v1.0", // 版本
                "http://xxx.com/", // 组织链接
                contact, // 联系人信息
                "Apach 2.0 许可", // 许可
                "http://xxx.com/", // 许可连接
                new ArrayList()// 扩展
        );
    }
}
```



### 配置如何扫描

只有扫描到的接口，才会出现在 swagger 文档中。

<span style="backGround: #efe0b9">com/master/config/SwaggerConfig.java</span>

```java
@Configuration
@EnableSwagger2
public class SwaggerConfig {

    @Bean
    public Docket docket() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                .select()
   				.apis(RequestHandlerSelectors.basePackage("com.master.controller"))
            	// 只扫描请求以/master开头的接口
                .paths(PathSelectors.ant("/master/**"))
                .build();
    }
	//...
}
```

<span style="color: #f7534f;font-weight:600">RequestHandlerSelectors</span> 配置要扫描接口的方法

| RequestHandlerSelectors属性 | 说明           |
| --------------------------- | -------------- |
| basePackage()               | 指定要扫描的包 |
| any()                       | 扫描全部       |
| none()                      | 不扫描         |

<span style="color: #f7534f;font-weight:600">PathSelectors</span> 根据接口路径，配置要扫描的

| PathSelectors属性             | 说明               |
| ----------------------------- | ------------------ |
| ant(final String antPattern)  | 通过ant()控制      |
| regex(final String pathRegex) | 通过正则表达式控制 |
| any()                         | 任何请求都扫描     |
| none()                        | 任何请求都不扫描   |



### 配置是否启用

<span style="backGround: #efe0b9">com/master/config/SwaggerConfig.java</span>

```java
@Configuration
@EnableSwagger2
public class SwaggerConfig {

    @Bean
    public Docket docket() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
            	.enable(false)
                .select()
   				.apis(RequestHandlerSelectors.basePackage("com.master.controller"))
            	// 只扫描请求以/master开头的接口
                .paths(PathSelectors.ant("/master/**"))
                .build();
    }
	//...
}
```

:turtle: 通过 enable() 方法配置是否启用 swagger，如果是 false，swagger 将不能在浏览器中访问。



**进阶-通过环境判断是否启用**

<span style="backGround: #efe0b9">application.properties</span>

```properties
spring.profiles.active=dev
```

<span style="backGround: #efe0b9">com/master/config/SwaggerConfig.java</span>

```java
@Configuration
@EnableSwagger2
public class SwaggerConfig {

    @Bean
    public Docket docket(Environment environment) {
    
    	// 判断环境是否满足条件
        Profiles profiles = Profiles.of("dev", "test");
        boolean flag = environment.acceptsProfiles(profiles);
        
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
            	.enable(flag)
                .select()
   				.apis(RequestHandlerSelectors.basePackage("com.master.controller"))
            	// 只扫描请求以/master开头的接口
                .paths(PathSelectors.ant("/master/**"))
                .build();
    }
	//...
}
```



### 配置分组

文档多团队开发时，可以存在多个配置信息实例，在文档右上角用组名作筛选。

<span style="backGround: #efe0b9">com/master/config/SwaggerConfig.java</span>

```java
@Configuration
@EnableSwagger2
public class SwaggerConfig {

    // 配置swagger的docket的bean实例
    @Bean
    public Docket docket() {
        return new Docket(DocumentationType.SWAGGER_2).apiInfo(apiInfo())
            .groupName("group1") // 配置分组
       		// 省略其它配置....
    }
    @Bean
	public Docket docket1(){
  	    return new Docket(DocumentationType.SWAGGER_2).groupName("group2");
	}
    // ...
    
}
```



### 接口注释

#### model注释

<span style="backGround: #efe0b9">com/master/controller/HelloController.java</span>

```java
@RestController
public class HelloController {

    @GetMapping("/hello")
    public String hello() {
        return "hello";
    }

	// 返回实体类User
    @PostMapping("/user")
    public User user() {
        return new User();
    }
}
```

:ghost: 只要在接口中返回实体类，这个实体类就会被添加到 swagger 文档的 models 中；

:octopus: 如果不指定具体的请求方法，文档会给出所有类型的方法的api。



<span style="backGround: #efe0b9">com/master/pojo/User.java</span>

```java
@ApiModel("用户类")
public class User {
    @ApiModelProperty("用户名")
    public String username;
    @ApiModelProperty("密码")
    public String password;
}
```

<span style="color: #f7534f;font-weight:600">@ApiModel</span> 实体类解释，会出现在 swagger 文档中；

<span style="color: #f7534f;font-weight:600">@ApiModelProperty</span> 实体类属性解释，会出现在 swagger 文档中;

:question: 对于 private 修饰的私有属性，需要提供 get/set 才能出现在文档中。



#### 接口注释

<span style="backGround: #efe0b9">com/master/pojo/User.java</span>

```java
@RestController
@Api(tags="问候模块", description="早上好")
public class HelloController {

    // ...

    @ApiOperation("获取用户额外信息")
    @GetMapping("/hello2")
    public String hello2(@ApiParam("用户名") String username) {
        return "hello" + username;
    }
}
```

<span style="color: #f7534f;font-weight:600">@RestController</span> 返回json格式的数据，相当于早期的 <span style="color: #a50">@Controller + @ResponseBody</span>;

<span style="color: #f7534f;font-weight:600">@Api</span> 控制器模块解释，会出现在 swagger 文档中；

<span style="color: #f7534f;font-weight:600">@ApiOperation</span> 接口解释，会出现在 swagger 文档中；

<span style="color: #f7534f;font-weight:600">@ApiParam</span> 接口参数解释，会出现在 swagger 文档中



## 任务

### 异步任务

#### 简单示例

<span style="backGround: #efe0b9">com/master/service/AsyncService.java</span>

```java
@Service
public class AsyncService {

    public void hello() {
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("数据正在处理...");
    }
}
```

<span style="backGround: #efe0b9">com/master/controller/AsyncController.java</span>

```java
@RestController
public class AsyncController {
    
    @Autowired
    AsyncService asyncService;
    
    @RequestMapping("/hey")
    public String hello() {
        asyncService.hello(); // 停止三秒
        return "OK";
    }
}
```

**访问**

> 页面会有 3s 的空白，左上角显示加载图标

```elm
http://localhost:8080/hey
```



#### 解释异步

<span style="backGround: #efe0b9">com/master/service/AsyncService.java</span>

```java
@Service
public class AsyncService {

    @Async
    public void hello() {
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("数据正在处理...");
    }
}
```

<span style="color: #f7534f;font-weight:600">@Async</span> 告诉spring这是个异步方法

<span style="backGround: #efe0b9">com/master/SwaggerApplication.java</span>

```java
// 开启异步注解功能
@EnableAsync
@SpringBootApplication
public class Swagger2Application {

    public static void main(String[] args) {
        SpringApplication.run(Swagger2Application.class, args);
    }

}
```

<span style="color: #f7534f;font-weight:600">@EnableAsync</span> 开启异步注解功能

**访问**

> 页面不有空白间隙

```elm
http://localhost:8080/hey
```



### 邮件任务

#### 环境准备

##### 添加依赖

<span style="backGround: #efe0b9">pom.xml</span>

```html
<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-mail</artifactId>
</dependency>
```

##### 获取授权码

qq邮件网页 - 设置 - 账户 - 开启服务：POP3/SMTP服务 - 点击开启 - 操作后获取<span style="color: #a50">授权码</span>

##### 邮件配置

<span style="backGround: #efe0b9">resources/application.properties</span>

```properties
spring.mail.username=1007xxxxxx@qq.com
# 邮箱授权码
spring.mail.password=xxx
spring.mail.host=smtp.qq.com
# 开启加密验证
spring.mail.properties.mail.smtp.ssl.enable=true
```



#### 发送简单邮件

<span style="backGround: #efe0b9">com/master/SwaggerApplicationTests.java</span>

```java
@SpringBootTest
class Swagger2ApplicationTests {

    @Autowired
    JavaMailSenderImpl mailSender;

    @Test
    void contextLoads() {

        // 简单邮件对象
        SimpleMailMessage mailMessage = new SimpleMailMessage();

        mailMessage.setSubject("笨蛋");
        mailMessage.setText("你玩蛋仔派对拿不了mvp，mvp是我~");

        mailMessage.setFrom("xxx@qq.com");
        mailMessage.setTo("xxx@qq.com");

        mailSender.send(mailMessage);
    }
}
```

| SimpleMailMessage实例方法 | 说明       |
| ------------------------- | ---------- |
| setSubject                | 邮件标题   |
| setText                   | 邮件内容   |
| setFrom                   | 发送人邮件 |
| setTo                     | 接收人邮件 |



#### 发送复杂邮件

<span style="backGround: #efe0b9">com/master/SwaggerApplicationTests.java</span>

```java
@SpringBootTest
class Swagger2ApplicationTests {

    @Autowired
    JavaMailSenderImpl mailSender;

    @Test
    void contextLoads2() throws MessagingException {

        // 复杂邮件对象
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        // 组装
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true);

        helper.setSubject("亲爱的王小姐");
        helper.setText("<p style='color: red'>玩躲猫猫，你怎么这么容易被抓</p>", true);

        // 附件
        helper.addAttachment("11abc.jpg", new File("C:\\Users\\86186\\Desktop\\1.jpg"));
        helper.addAttachment("22def.jpg", new File("C:\\Users\\86186\\Desktop\\2.jpg"));

        helper.setFrom("xxxx@qq.com");
        helper.setTo("xxx@qq.com");

        mailSender.send(mimeMessage);
    }
}
```

<span style="color: #a50">new MimeMessageHelper</span> 第二个参数表示是否发送多个附件；

<span style="color: #a50">helper.setText</span> 第二个参数表示是否为 html；

<span style="color: #a50">helper.addAttachment</span> 首参为文件名，第二个参数表示文件路径。



### 定时任务

#### 编写

<span style="backGround: #efe0b9">com/master/service/ScheduledService.java</span>

```java
@Service
public class ScheduledService {

    // 秒 分 时 日 月 周几
    @Scheduled(cron = "0 2 14 * * ?")
    public void hello() {
        System.out.println("输出hello");
    }
}
```

<span style="color: #f7534f;font-weight:600">@Scheduled</span> 可以接收 [cron](https://help.aliyun.com/document_detail/64769.html) 表达式，用以控制执行时间。

#### 测试

<span style="backGround: #efe0b9">com/master/SwaggerApplication.java</span>

```java
// 开启定时任务
@EnableScheduling
@SpringBootApplication
public class SwaggerApplication {

    public static void main(String[] args) {
        SpringApplication.run(Swagger2Application.class, args);
    }

}
```

<span style="color: #f7534f;font-weight:600">@EnableScheduling</span> 开启定时任务功能



## Zookeeper

### Zookeeper安装配置

参考[菜鸟教程](https://www.runoob.com/w3cnote/zookeeper-setup.html)

**注意**

在执行 exe 步骤时，如果 8080 的端口号被占用时，会导致失败（表现为执行程序马上关闭）

**查看错误**

可以通过修改 `zkServer.cmd` 文件，在执行 `endlocal` 前添加语句暂停

```cmd
pause
```



### 服务提供者

1、启动zookeeper

启动目录下，bin 文件夹中的 <span style="backGround: #efe0b9">zkServer.cmd</span>

2、创建一个空的 maven 项目

3、新建模块，模块只需引入 Spring Web

4、导入依赖

```html
<!-- Dubbo Spring Boot Starter -->
<dependency>
    <groupId>org.apache.dubbo</groupId>
    <artifactId>dubbo-spring-boot-starter</artifactId>
    <version>2.7.3</version>
</dependency>
<!-- https://mvnrepository.com/artifact/com.github.sgroschupf/zkclient -->
<dependency>
    <groupId>com.github.sgroschupf</groupId>
    <artifactId>zkclient</artifactId>
    <version>0.1</version>
</dependency>
<!-- 引入zookeeper -->
<dependency>
    <groupId>org.apache.curator</groupId>
    <artifactId>curator-framework</artifactId>
    <version>2.12.0</version>
</dependency>
<dependency>
    <groupId>org.apache.curator</groupId>
    <artifactId>curator-recipes</artifactId>
    <version>2.12.0</version>
</dependency>
<dependency>
    <groupId>org.apache.zookeeper</groupId>
    <artifactId>zookeeper</artifactId>
    <version>3.4.14</version>
    <!--排除这个slf4j-log4j12-->
    <exclusions>
        <exclusion>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-log4j12</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

5、配置

<span style="backGround: #efe0b9">resources/application.properties</span>

```properties
server.port=8001

#服务应用名字
dubbo.application.name=provider-server
#注册中心地址
dubbo.registry.address=zookeeper://127.0.0.1:2181
#扫描指定包下服务，用于注册
dubbo.scan.base-packages=com.kuang.provider.service
```

6、配置服务

<span style="backGround: #efe0b9">com/master/service/TicketService.java</span>

```java
public interface TicketService {
    public String getTicker();
}
```

<span style="backGround: #efe0b9">com/master/service/TicketServiceImpl.java</span>

```java
import org.apache.dubbo.config.annotation.Service;
import org.springframework.stereotype.Component;

@Service //将服务发布出去
@Component //放在容器中
public class TicketServiceImpl implements TicketService {
    @Override
    public String getTicker() {
        return "abc";
    }
}
```



### 服务消费者

1、新建模块，模块只需引入 Spring Web

2、导入依赖

```html
<!--dubbo-->
<!-- Dubbo Spring Boot Starter -->
<dependency>
   <groupId>org.apache.dubbo</groupId>
   <artifactId>dubbo-spring-boot-starter</artifactId>
   <version>2.7.3</version>
</dependency>
<!--zookeeper-->
<!-- https://mvnrepository.com/artifact/com.github.sgroschupf/zkclient -->
<dependency>
   <groupId>com.github.sgroschupf</groupId>
   <artifactId>zkclient</artifactId>
   <version>0.1</version>
</dependency>
<!-- 引入zookeeper -->
<dependency>
   <groupId>org.apache.curator</groupId>
   <artifactId>curator-framework</artifactId>
   <version>2.12.0</version>
</dependency>
<dependency>
   <groupId>org.apache.curator</groupId>
   <artifactId>curator-recipes</artifactId>
   <version>2.12.0</version>
</dependency>
<dependency>
   <groupId>org.apache.zookeeper</groupId>
   <artifactId>zookeeper</artifactId>
   <version>3.4.14</version>
   <!--排除这个slf4j-log4j12-->
   <exclusions>
       <exclusion>
           <groupId>org.slf4j</groupId>
           <artifactId>slf4j-log4j12</artifactId>
       </exclusion>
   </exclusions>
</dependency>
```

3、配置

<span style="backGround: #efe0b9">resources/application.properties</span>

```properties
#当前应用名字
dubbo.application.name=consumer-server
#注册中心地址
dubbo.registry.address=zookeeper://127.0.0.1:2181
```

4、准备相同路径的接口服务：com/master/service/TicketService.java

5、准备服务类

```java
package com.master.service;

import com.kuang.provider.service.TicketService;
import org.apache.dubbo.config.annotation.Reference;
import org.springframework.stereotype.Service;

@Service //注入到容器中
public class UserService {

   @Reference //远程引用指定的服务，他会按照全类名进行匹配，看谁给注册中心注册了这个全类名
   TicketService ticketService;

   public void bugTicket(){
       String ticket = ticketService.getTicket();
       System.out.println("在注册中心买到"+ticket);
  }
}
```

6、测试

```java
@SpringBootTest
public class ConsumerServerApplicationTests {

   @Autowired
   UserService userService;

   @Test
   public void contextLoads() {
       userService.bugTicket();
  }
}
```















