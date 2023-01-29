

在 Java 中，动态web资源开发的技术统称为 JavaWeb。





## tomcat

### 下载

在[官网](https://tomcat.apache.org/)进行下载，解压

![image-20221203222104037](.\img\tomcat)



### 启动、关闭

<span style="backGround: #efe0b9">解压文件夹/bin</span>

![image-20221203222527822](C:\Users\86186\AppData\Roaming\Typora\typora-user-images\image-20221203222527822.png)

启动成功后，默认在 http://localhost:8080/ 访问测试



默认网站应用模板的位置： <span style="backGround: #efe0b9">解压文件夹/webapps/ROOT/index.jsp</span>

服务器核心配置，如端口、主机名、网站应用的位置： <span style="backGround: #efe0b9">解压文件夹/conf/server.xml</span>

```html
<Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
```

```html
<Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">
```



### 访问地址规则

当在浏览器输入网址并确认时

1. 先检查本机的 hosts 配置中是否有该域名映射，有就返回对应 ip 地址

   ```elm
   # 示例
   127.0.0.1       www.demo.com
   ```

   :whale: windows 系统的这个配置文件路径为 <span style="backGround: #efe0b9">C:\Windows\System32\driversletclhosts\hosts</span>

2. 在 DNS(全世界的域名管理) 上进行域名解析，返回对应 ip 地址



### 自定义页面

```elm
- 解压文件夹
  + webapps
    - demo   // 新建
      + index.html / index.jsp
      + static      // （可选）
        - css
        - img
      + WEB-INF     // （可选）
        - classes   // java程序
        - lib       // web应用依赖的jar包
        - web.xml   // 网站的配置文件
```

| 路径                                  | 说明                       |
| ------------------------------------- | -------------------------- |
| http://localhost:8080/                | 访问 webapps/ROOT 下的页面 |
| http://localhost:8080/demo/           | 访问自定义页面             |
| http://localhost:8080/demo/index.html | 访问自定义页面             |



## Maven

是一种项目架构管理工具，主要用于方便导入 jar 包
Maven 会规定好如何去编写我们的Java代码，必须要按照这个规范来;

### 下载

在[官网](https://maven.apache.org/)下载，解压

![image-20221204105520834](.\img\maven下载)

### 配置环境变量

系统环境变量中配置:

- M2_HOME         maven目录下的bin目录 

- MAVEN_HOME maven的目录

- 在 Path 中新增  %MAVEN_HOME%\bin

  ```elm
  mvn -version
  ```

### 修改默认配置

<span style="backGround: #efe0b9">解压文件夹\conf\settings.xml</span>

#### 采用阿里云镜像

`添加`

```html
<mirror> 
  <id>alimaven</id> 
  <name>aliyun maven</name> 
  <url>http://maven.aliyun.com/nexus/content/groups/public/</url> 
  <mirrorOf>central</mirrorOf> 
</mirror> 
```

maven配置阿里云镜像

#### 配置仓库位置

```elm
- 解压文件夹
  + bin
  + maven-repo // 新增文件夹
```

`添加`

```html
<localRepository>D:\开发\环境\maven\apache-maven-3.8.6\maven-repo</localRepository>
```



### maven-创建自定义项目

![image-20221204161708064](.\img\创建自定义 maven 项目)

:octopus: 首先要修改使用 maven 的路径，注意不要从 settings 设置，否则配置不会对新项目起效果。

![image-20221204162255174](.\img\创建自定义 maven 项目2)

#### 补充目录结构

![image-20221204165354585](.\img\maven-创建自定义项目)

:hammer_and_wrench: 设置为源码目录后，才能新建 class 文件。 



### maven-创建默认项目

> 实际上 IDEA 也有自带 maven，只是不能自己配置等。

![image-20221204163642897](.\img\创建默认 maven 项目)

默认的项目结构

![image-20221204164900343](.\img\maven-创建默认项目)



### IDEA中使用 tomcat

![image-20221204174134329](.\img\IDEA中使用tomcat)

因为我找不到，所以在插件中[安装](https://blog.csdn.net/weixin_45764765/article/details/114375532) Smart Tomcat，重启编辑器

![image-20221204171653042](.\img\IDEA中使用tomcat2)

然后就能找到它，配置路径

![image-20221204174012675](.\img\IDEA中使用tomcat3)



![image-20221204174340519](.\img\IDEA中使用tomcat4)



### pom.xml

#### 文件介绍

<span style="backGround: #efe0b9">pom.xml</span>

```html
<!-- Maven版本和头文件 -->
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <!-- 新建项目时的那几个配置 -->
  <groupId>org.example</groupId>
  <artifactId>untitled2</artifactId>
  <packaging>war</packaging>
  <version>1.0-SNAPSHOT</version>
  <name>untitled2 Maven Webapp</name>
  <url>http://maven.apache.org</url>
  <!-- 项目依赖 -->
  <dependencies>
    <!-- 具体依赖的jar包配置文件 -->
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>3.8.1</version>
      <scope>test</scope>
    </dependency>
  </dependencies>
  <build>
    <finalName>untitled2</finalName>
  </build>
</project>
```

![image-20221204184006523](.\img\pom.xml)

![image-20221204184633376](.\img\pom.xml2)



#### 资源导出问题

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

可以百度搜索 maven 资源导出问题 博客园 找到一些[解决方案](https://blog.csdn.net/u013733643/article/details/124105555)。



## Servlet

Servlet 是用于开发动态 web 的技术；

实现了 Servlet 接口的 Java 程序，叫做 Servlet 程序。



### 创建自定义项目

![image-20221204205946270](.\img\创建自定义项目)



#### 添加 servlet 依赖

![image-20221204211420988](.\img\添加 servlet 依赖)

:turtle: 可以百度搜索 [maven 中添加Servlet、JSP的依赖](https://www.cnblogs.com/skygym/p/15670194.html)；

:octopus: 导入成功提示找不到依赖，要刷新才会下载;

:octopus: 据说 tomcat10+ 的版本，导入依赖要换成 jakarta.servlet.jsp-api 和 jakarta.servlet-api



**也可以在[官网](https://mvnrepository.com/)搜索最新版本的依赖**

![image-20221204211616696](.\img\添加 servlet 依赖2)



#### 新建子模块

![image-20221204212656935](.\img\新建子模块)

<span style="backGround: #efe0b9">外层的 pom.xml</span>

```html
<modules>
    <module>servlet-01</module>
</modules>	
```

<span style="backGround: #efe0b9">子模块的 pom.xml</span>

```html
<parent>
    <artifactId>untitled4</artifactId>
    <groupId>org.example</groupId>
    <version>1.0-SNAPSHOT</version>
</parent>
```

:hammer_and_wrench: 创建子模块后，配置中会自动添加上上述内容；

:ghost: 子模块能够使用父模块中存在的模块。



#### 更新web.xml

```elm
- servlet-01
  + src
    - main
      + webapp
        - WEB-INF
          + web.xml
```

<span style="backGround: #efe0b9">web.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">

</web-app>
```

>  如果路径出现 URI is not registered (Settings... 的报错：
>
>  alt+enter 选择 Fetch external resource，直至资源下载成功



#### 准备首个HelloServlet

```elm
- servlet-01
  + src
    - main
      + java     // new
        - com.master.servlet // new Package
          + HelloServlet     // new Java Class
      + resources
```

<span style="backGround: #efe0b9">HelloServlet</span>

```java
public class HelloServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("to doGet");
        PrintWriter writer = resp.getWriter();
        writer.print("hello, servlet");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
```

:ghost: 实现类继承 HttpServlet => HttpServlet  => GenericServlet  => Servlet 接口 

:whale: 如果 get / post 底层业务逻辑一致，可以只实现一个，另一个调用它。

#### 添加映射关系

这个就类似于路由映射了

<span style="backGround: #efe0b9">web.xml</span>

```html
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">

    <!--注册Servlet-->
    <servlet>
        <servlet-name>hello</servlet-name>
        <servlet-class>com.master.servlet.HelloServlet</servlet-class>
    </servlet>
    <!--映射Servlet的请求路径-->
    <servlet-mapping>
        <servlet-name>hello</servlet-name>
        <url-pattern>/hello</url-pattern>
    </servlet-mapping>
</web-app>
```

#### 配置tomcat

> [配置](#IDEA中使用 tomcat)并启动就好，由于我安装的 servlet 依赖与 tomcat10+ 不兼容，就装了个 tomcat9 的。

```less
http://localhost:8080/hello
```



### 映射规则

<span style="backGround: #efe0b9">web.xml</span>

```html
<!--注册Servlet-->
<servlet>
    <servlet-name>hello</servlet-name>
    <servlet-class>com.master.servlet.HelloServlet</servlet-class>
</servlet>
<!--映射Servlet的请求路径-->
<servlet-mapping>
    <servlet-name>hello</servlet-name>
    <url-pattern>/hello</url-pattern>
</servlet-mapping>
<servlet-mapping>
    <servlet-name>hello</servlet-name>
    <url-pattern>/hello2</url-pattern>
</servlet-mapping>
<!--使用通配符-->
<servlet-mapping>
    <servlet-name>hello</servlet-name>
    <url-pattern>/hello/*</url-pattern>
</servlet-mapping>
<!--默认请求路径-->
<servlet-mapping>
    <servlet-name>hello</servlet-name>
    <url-pattern>/*</url-pattern>
</servlet-mapping>
<!--自定义后缀-->
<servlet-mapping>
    <servlet-name>hello</servlet-name>
    <url-pattern>*.hey</url-pattern>
</servlet-mapping>
```

:ghost: 一个 servlet 可以指定一到多个映射路径，并可以使用通配符。



**例子-配置通用错误页面**

<span style="backGround: #efe0b9">ErrorServlet</span>

```java
public class ErrorServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        resp.setCharacterEncoding("utf-8");

        PrintWriter writer = resp.getWriter();
        writer.print("<h1>404</h1>");
    }
}
```

<span style="backGround: #efe0b9">web.xml</span>

```html
<!--other-->
<servlet>...</servlet>
<servlet-mapping>...</servlet-mapping>
<!--404-->
<servlet>
    <servlet-name>error</servlet-name>
    <servlet-class>com.master.servlet.ErrorServlet</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>error</servlet-name>
    <url-pattern>/*</url-pattern>
</servlet-mapping>
```

:ghost: 指定了固定的映射路径优先级最高，匹配不上固定路径就会匹配默认请求路径。





### ServletContext

web 容器启动时，会为 web 程序创建一个 <span style="color: #a50">ServletContext</span> 对象，可以通过它在不同的 servlet 之间共享数据。

#### 共享数据

<span style="backGround: #efe0b9">java/com/master/servlet/Demo1</span>

```java
public class Demo1 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ServletContext context = this.getServletContext();

        String name = "糯米";
        context.setAttribute("name", name);
    }
}
```

<span style="backGround: #efe0b9">java/com/master/servlet/Demo2</span>

```java
public class Demo2 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ServletContext context = this.getServletContext();
        String name = (String) context.getAttribute("name");

        // 解决中文乱码
        resp.setContentType("text/hml;charset=utf-8");
        resp.getWriter().print("名字" + name);
    }
}
```

<span style="backGround: #efe0b9">web.xml</span>

```html
<servlet-mapping>
    <servlet-name>demo1</servlet-name>
    <url-pattern>/demo1</url-pattern>
</servlet-mapping>
<servlet>
    <servlet-name>demo2</servlet-name>
    <servlet-class>com.master.servlet.Demo2</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>demo2</servlet-name>
    <url-pattern>/demo2</url-pattern>
</servlet-mapping>
```



#### 获取初始参数

<span style="backGround: #efe0b9">java/com/master/servlet/Demo3</span>

```java
public class Demo3 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ServletContext context = this.getServletContext();

        String url = context.getInitParameter("url");
        resp.getWriter().print(url);
    }
}
```

<span style="backGround: #efe0b9">web.xml</span>

```html
<!--配置一些web应用初始化参数-->
<context-param>
    <param-name>url</param-name>
    <param-value>jdbc:mysql://localhost:3306/mybatis/</param-value>
</context-param>
<servlet>
    <servlet-name>demo3</servlet-name>
    <servlet-class>com.master.servlet.Demo3</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>demo3</servlet-name>
    <url-pattern>/demo3</url-pattern>
</servlet-mapping>
```



#### 请求转发

<span style="backGround: #efe0b9">java/com/master/servlet/Demo3</span>

```java
public class Demo4 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ServletContext context = this.getServletContext();

        // 1.转发的路径 2.调用forward实现请求转发
        context.getRequestDispatcher("/demo3").forward(req, resp);
    }
}
```

<span style="backGround: #efe0b9">web.xml</span>

```html
<servlet>
    <servlet-name>demo4</servlet-name>
    <servlet-class>com.master.servlet.Demo4</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>demo4</servlet-name>
    <url-pattern>/demo4</url-pattern>
</servlet-mapping>
```



#### 读取资源

Properties

- 在java目录下新建properties
- 在resources目录下新建properties

发现：都被打包到了 classes 路径下 ，俗称这个路径为 <span style="color: #a50">classpath</span>



![image-20221205234645806](.\img\读取资源)

<span style="backGround: #efe0b9">db.properties</span>

```elm
username=root
password=123456
```

<span style="backGround: #efe0b9">java/com/master/servlet/Demo3</span>

```java
public class Demo5 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        InputStream is = this.getServletContext().getResourceAsStream("/WEB-INF/classes/db.properties");

        Properties prop = new Properties();
        prop.load(is);
        String user = prop.getProperty("username");
        String pwd = prop.getProperty("password");

        resp.getWriter().print(user+":"+pwd);
    }
}
```

<span style="backGround: #efe0b9">web.xml</span>

```html
<servlet>
    <servlet-name>demo5</servlet-name>
    <servlet-class>com.master.servlet.Demo5</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>demo5</servlet-name>
    <url-pattern>/demo5</url-pattern>
</servlet-mapping>
```



#### HttpServletResponse

web 服务器接收到客户端的http请求，会创建 HttpServletRequest 和 HttpServletResponse 对象

- HttpServletRequest 获取客户端请求过来的参数
- HttpServletResponse 给客户端响应一些信息



##### 内容

###### 向浏览器发送数据

```java
// 比如流
ServletOutputStream getOutputStream() throws IOException;
// 比如中文
Printwriter getWriter() throws IOException;
```

###### 修改响应头

###### 响应的状态码



##### 例子

###### 下载文件

```java
public class Demo6 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // 1.要下载的文件路径
        String realPath = "D:\\项目管理\\java\\untitled4\\servlet-01\\src\\main\\resources\\测试.jpg";
        System.out.println("路径："+realPath);
        // 2.获取下载的文件名
        String fileName = realPath.substring(realPath.lastIndexOf("\\") + 1);
        // 3.让浏览器支持下载
        resp.setHeader("Content-Disposition", "attachment;filename="+ URLEncoder.encode(fileName, "UTF-8"));
        // 4.获取下载文件的输入流
        FileInputStream in = new FileInputStream(realPath);
        // 5.创建缓冲区
        int len = 0;
        byte[] buffer = new byte[1024];
        // 6.获取OutputStream对象
        ServletOutputStream out = resp.getOutputStream();
        // 7.将FileInputStream流写入buffer缓冲区，使用OutputStream将缓冲区的数据输出到客户端
        while ((len=in.read(buffer))>0) {
            out.write(buffer,0, len);
        }

        in.close();
        out.close();
    }
}
```

:turtle: 3. 使用 <span style="color: #a50">URLEncoder.encode</span> 处理 fileName，可以解决中文文件名乱码的问题，但需要浏览器本身为 <span style="color: #a50">utf-8</span>



###### 实现重定向

过程：客户端访问web资源A，A通知客户端访问另一个web资源B

```java
public class Demo7 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        resp.sendRedirect("demo5");
        
        // 等价于
        //resp.setHeader("Location", "demo5");
        //resp.setStatus(302);
    }
}
```



重定向vs转发

- 页面都会实现跳转

- 请求转发时，url不会变化，但重定向会



#### HttpServletRequest

###### 获取参数

```java
public class Demo8 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 解决请求解析、输出到浏览器的中文乱码
        req.setCharacterEncoding("utf-8");
        resp.setCharacterEncoding("utf-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String[] hobbys = req.getParameterValues("hobbys");
        System.out.println(username);
        System.out.println(password);
        System.out.println(Arrays.toString(hobbys));
    }
}
```





## Cookie、Session

### Cookie

服务端给客户端一个标记，下次看到请求带标记，就知道是老客人了；

如果不给 cookie 设置过期时间，cookie 将在会话关闭时清除。

```java
Cookie[] cookies = req.getCookies; // 获得全部 cookie (数组)
cookie.getName();             // 获得这个cookie的key
cookie.getValue();            // 获得这个cookie的v1aue
new Cookie("demo", "master"); // 新建一个cookie
cookie.setMaxAge(24*60*60);   // 设置有效期
resp.addCookie(cookie);       // 添加到响应到客户端的cookie中
```



#### 例-是否首次登录

```java
public class Demo9 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 解决中文乱码
        req.setCharacterEncoding("utf-8");
        resp.setContentType("text/html;charset=utf-8");

        PrintWriter out = resp.getWriter();

        // 从客户端获取cookie(数组形式)
        Cookie[] cookies = req.getCookies();

        // 判断是否存在特定cookie
        if (cookies != null) {
            out.write("上次访问时间：");
            for (int i = 0; i < cookies.length; i++) {
                Cookie cookie = cookies[i];
                if (cookie.getName().equals("loginTime")) {
                    // 获取cookie中的值
                    long loginTime = Long.parseLong(cookie.getValue());
                    Date date = new Date(loginTime);
                    out.write(date.toLocaleString());
                }
            }
        } else {
            out.write("您的首次访问");
        }

        // 添加到响应到客户端的cookie中
        Cookie cookie = new Cookie("loginTime", System.currentTimeMillis()+"");
        // 给cookie设置有效期
        cookie.setMaxAge(24*60*60);

        resp.addCookie(cookie);
    }
}
```



### Session

在同一个浏览器中，在服务器对应的 SessionId 是固定的，除非关闭后再打开浏览器；

可以在服务器手动销毁 Session，它会立即重新创建一个新的 Session；

可以通过 SessionId 识别不同的浏览器对象，而 Session 本身可以存内容，这样可以区分开不同的对象。



**SessionId在浏览器的存在形式**

![image-20221207230957624](.\img\Session的Id在浏览器的存在形式)



#### D-是否首次登录

```java
public class Demo10 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 解决乱码问题
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=utf-8");

        // 获取Session
        HttpSession session = req.getSession();
        // 在Session中存东西(不仅是字符串，可以存对象)
        session.setAttribute("demo", "示例");
        // 获取Session的ID
        String sessionId = session.getId();

        // 判断是否新建的Session
        if (session.isNew()) {
            resp.getWriter().write("session新建成功，ID："+sessionId);
        } else {
            resp.getWriter().write("session已经在服务器存在，ID："+sessionId);
        }
    }
}
```

```java
// 获取Session
HttpSession session = req.getSession();
// 获取属性
String demo = (String) session.getAttribute("demo");
// 移除属性
session.removeAttribute("demo");
// 销毁当前session，会马上创建新的session
session.invalidate();
```



#### session的销毁

关闭浏览器并不会使得服务器上的 session 销毁

**自动销毁**

<span style="backGround: #efe0b9">web.xml</span>

```html
<servlet>...<servlet>
<!--session自动销毁的时间-->
<session-config>
    <session-timeout>1</session-timeout>
</session-config>
```

**手动销毁**

```java
// 销毁当前session，会马上创建新的session
session().invalidate();
```





### 两者的区别

- Cookie 的数据保存在浏览器，服务端/客户端都可以创建；
- Session 的数据保存在服务器，Session 对象由服务器创建。



## MVC架构

![image-20221208002533919](.\img\MVC架构)

Model

- 业务处理：业务逻辑 （Service）

- 数据持久层：CRUD （Dao）

View

- 展示数据

- 提供链接发起Servlet请求

Controller （Servlet）

- 接收用户的请求： (req：请求参数、Session信息....)

- 交给业务层处理对应的代码

- 控制视图的跳转

```java
登录--->接收用户的登录请求--->处理用户的请求（获取用户名和密码)---->交给业务层处理登录业务（判断用户名密码是否正确、事务)--->Dao层查询用户名和密码是否正确-->数据库
```



## 过滤器(Filter)

过滤无效请求、处理中文乱码



### D-解决中文乱码

<span style="backGround: #efe0b9">java/com/master/filter/Demo1</span>

```java
package com.master.filter;

import javax.servlet.*; // 注意是这个包下的Filter
import java.io.IOException;

public class Demo1 implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("过滤器启用");
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        servletRequest.setCharacterEncoding("utf-8");
        servletResponse.setCharacterEncoding("utf-8");
        servletResponse.setContentType("text/html;charset=UTF-8");

        filterChain.doFilter(servletRequest, servletResponse);
    }

    @Override
    public void destroy() {
        System.out.println("过滤器销毁");
    }
}
```

:ghost: 在服务器开启时，过滤器就会启用，在服务器关闭时，过滤器销毁；

:ghost: <span style="color: #a50">doFilter</span> 方法的第三个参数类似于 koa 的 next，执行才去调用下一个中间件。

<span style="backGround: #efe0b9">web.xml</span>

```html
<servlet>...<servlet>
<filter>
    <filter-name>CharacterEncodingFilter</filter-name>
    <filter-class>com.master.filter.Demo1</filter-class>
</filter>
<filter-mapping>
    <filter-name>CharacterEncodingFilter</filter-name>
    <url-pattern>/demo/*</url-pattern>
</filter-mapping>
```

通过[映射规则](#映射规则)，可以自定义需要匹配的 servlet 实例。



## 监听器

### D-统计会话人数

<span style="backGround: #efe0b9">java/com/master/listener/Demo1</span>

```java
public class Demo1 implements HttpSessionListener {
    @Override
    public void sessionCreated(HttpSessionEvent se) {
        ServletContext ctx = se.getSession().getServletContext();

        Integer onlineCount = (Integer) ctx.getAttribute("onlineCount");

        if (onlineCount == null) {
            onlineCount = 1;
        } else {
            int count = onlineCount;
            onlineCount = count+1;
        }
        ctx.setAttribute("onlineCount", onlineCount);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        ServletContext ctx = se.getSession().getServletContext();

        Integer onlineCount = (Integer) ctx.getAttribute("onlineCount");

        if (onlineCount == null) {
            onlineCount = 0;
        } else {
            int count = onlineCount;
            onlineCount = count-1;
        }
        ctx.setAttribute("onlineCount", onlineCount);
    }
}
```

<span style="backGround: #efe0b9">web.xml</span>

```html
<servlet>...<servlet>
<!--注册监听器-->
<listener>
    <listener-class>com.master.listener.Demo1</listener-class>
</listener>
```



### D-登录拦截

用户登录成功，会向session中存入信息；

这个demo在路径变化时，映射的java文件会重定向需要展示的jsp；

在需要登录的路径(页面)，会判断是否登录，拦截。

```java
public class Demo2 implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain filterChain) throws IOException, ServletException {
        // 强转是为了获取session
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;

        if (request.getSession().getAttribute("USER_SESSION")==null) {
            response.sendRedirect("/error.jsp");
        }

        filterChain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
```



## JDBC

> java 连接数据库

不同类型的数据库需要不同的驱动，使用 JDBC 可以实现同一驱动，不去关注这些细节。



### 准备工作

需要的 jar 包支持：

- java.sql
- javax.sql
- mysql-connector-java 连接驱动（必须导入）

<span style="backGround: #efe0b9">web.xml</span>

```html
<!--连接数据库-->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>5.1.47</version>
</dependency>
```



### IDEA直连数据库

先用 IDEA 的 database 连上数据库，社区版只能用[其它插件](https://blog.csdn.net/iwanttostudyc/article/details/125141926)了



### D-直接查询

效率没预编译的高，而且存在sql注入风险

```java
public class Demo {
    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        // 配置信息
        // useUnicode=true&characterEncoding=UTF-8 解决中文乱码
        String url = "jdbc:mysql://localhost:3306/demo?useUnicode=true&characterEncoding=UTF-8";
        String username = "root";
        String password = "xxx";

        // 1.加载驱动
        Class.forName("com.mysql.jdbc.Driver");
        // 2.连接数据库
        Connection connection = DriverManager.getConnection(url, username, password);

        // 3.创建向数据库发送SQL的对象
        Statement statement = connection.createStatement();

        // 4. 编写SQL
        String sql = "select * from brand";

        // 5. 执行查询SQL，返回结果集
        ResultSet rs = statement.executeQuery(sql);

        while (rs.next()) {
            System.out.println("id" + rs.getObject("id"));
            System.out.println("id" + rs.getObject("name"));
        }

        // 6.关闭连接，释放资源(先连接的最后关闭)
        rs.close();
        statement.close();
        connection.close();
    }
}
```

:ghost: `jdbc:mysql://localhost:3306/` 后紧跟着的是数据库名



### D-预编译

```java
public class Demo2 {
    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        // 配置信息
        // useUnicode=true&characterEncoding=UTF-8 解决中文乱码
        String url = "jdbc:mysql://localhost:3306/demo?useUnicode=true&characterEncoding=UTF-8";
        String username = "root";
        String password = "xxx";

        // 1.加载驱动
        Class.forName("com.mysql.jdbc.Driver");
        // 2.连接数据库
        Connection connection = DriverManager.getConnection(url, username, password);

        // 3.编写SQL
        String sql = "insert into brand(name, website, phoneRank) values (?,?,?)";


        // 4.预编译
        PreparedStatement preparedStatement = connection.prepareStatement(sql);

        preparedStatement.setString(1, "小米");
        preparedStatement.setString(2, "www.xiaomi.com");
        preparedStatement.setInt(3, 6);

        // 5. 执行SQL，返回受到影响的条数
        int i = preparedStatement.executeUpdate();

        if (i>0) {
            System.out.println("插入成功");
        }

        // 6.关闭连接，释放资源(先连接的最后关闭)
        preparedStatement.close();
        connection.close();
    }
}
```

**获取当前的时间戳**

```java
new Date(System.currentTimeMillis());
```



### 事务

#### ACID原则

<span style="color: #f7534f;font-weight:600">原子性 </span>一个事务是一个不可分割的工作单位，事务中包括的<span style="color: #ff0000">操作要么都做，要么都不做</span>。比如转账，不可能钱转出去了，别人没收到帐；

<span style="color: #f7534f;font-weight:600">一致性 </span>是指事务的运行并不改变数据库中数据的一致性。例如，完整性约束了a+b=10，一个事务改变了a，那么b也应该随之改变；

<span style="color: #f7534f;font-weight:600">独立性</span> 事务的独立性也称作隔离性，是指两个以上的事务不会出现交错执行的状态。因为这样可能会导致数据不一致，更加具体的来讲，就是事务之间的操作是独立的；

<span style="color: #f7534f;font-weight:600">持久性</span> 事务的持久性是指事务执行成功以后，该事务对数据库所作的更改便是持久的保存在数据库之中，不会无缘无故的回滚。



#### 数据库事务操作

```sql
start transaction; #开启事务

update brand set phoneRank = 5 where id = 3;

commit; # 提交

rollback; # 回滚
```

| 操作                                 | 说明                         |
| ------------------------------------ | ---------------------------- |
| 开启事务 -> 执行更新 -> 提交         | 只有提交时，表中的数据改变   |
| 开启事务 -> 执行更新 -> 回滚 -> 提交 | 表中的数据不改变             |
| 开启事务 -> 执行更新 -> 提交 -> 回滚 | 表中的数据已经改变，回滚无效 |



#### D-事务操作

在 commit 之前的查询语句都不会真正执行，这样可以避免程序中途出错导致只执行了一部分。

```java
public class Demo3 {
    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        // 配置信息
        String url = "jdbc:mysql://localhost:3306/demo?useUnicode=true&characterEncoding=UTF-8";
        String username = "root";
        String password = "xxx";

        Connection connection = null;
        try {
            // 1.加载驱动
            Class.forName("com.mysql.jdbc.Driver");
            // 2.连接数据库
            connection = DriverManager.getConnection(url, username, password);
            // 3.通知数据库开启事务
            connection.setAutoCommit(false);

            String sql = "update brand set phoneRank = 5 where id = 3;";
            connection.prepareStatement(sql).executeUpdate();

            // 制造错误
            int i = 1/0;

            String sql2 = "update brand set phoneRank = 8 where id = 2;";
            connection.prepareStatement(sql2).executeUpdate();

            connection.commit(); // 执行了这一步，才会提交事务
            System.out.println("success");

        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
```







## 拓展

超文本传输协议

- 文本：html，字符串......
- 超文本：图片，音乐，视频，定位，地图......

默认端口

- HTTP 80
- HTTPS 443



### 单元测试

<span style="backGround: #efe0b9">pom.xml</span>

```html
<!--单元测试-->
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.12</version>
</dependency>
```

**使用**

```java
public class Demo {
    @Test
    public void test() {
        System.out.println("test");
    }
}
```

:hammer_and_wrench: 只要在方法上加上该注解，就可以直接运行。









