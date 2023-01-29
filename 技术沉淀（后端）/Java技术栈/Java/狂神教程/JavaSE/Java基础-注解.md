## 注解(Annotation)的定义

<span style="color: #f7534f;font-weight:600">定义</span>

注解不是程序本身，但可以像注释一样对程序作出解释，还可以被其它程序，如编译器读取；

<span style="color: #f7534f;font-weight:600">形式</span>

形式为 <span style="color: #a50">@注释名</span>，可以添加参数值 <span style="color: #a50">@注释名(value=xx)</span>；

<span style="color: #f7534f;font-weight:600">位置</span>

可以附加在 package , class , method , field 等上面，添加额外的辅助信息，通过反射可以访问这些元数据

```java
class Demos {
    @Override
    public String toString() {
        return super.toString();
    }
}
```

:whale: @Override 重写，当拼写错误时，能给出提示



## 内置注解

| 示例                     | 使用范围         | 说明                              | 定义位置                   |
| ------------------------ | ---------------- | --------------------------------- | -------------------------- |
| @Override                | 方法             | 打算重写超类中的方法声明          | java.lang.Override         |
| @Deprecated              | 方法、属性、类   | 不推荐使用，很危险/存在更好的选择 | java.lang.Deprecated       |
| @SuppressWarnings("all") | 方法、属性、类等 | 抑制编译时的警告信息              | java.lang.SuppressWarnings |



## 元注解

元注解(meta-annotation)的作用就是负责注解其他注解，他们被定义在 java.lang.annotation 包中。

| 元注解     | 说明                            |
| ---------- | ------------------------------- |
| @Target    | 表示注解能够用于哪些类型        |
| @Retention | 表示在哪些周期保存注释信息      |
| @Document  | 将注解保存到文档注释（javadoc） |
| @Inherited | 说明子类可以继承父类中的该注解  |

:whale: <span style="color: #a50">@Retention</span> 可选 SOURCE-源码、CLASS-编译、RUNTIME-运行时三个级别，后面的会包含前面的；

:whale: <span style="color: #a50">@Retention</span> 定义自定义注解时，基本都使用 RUNTIME。

`例子`

```java
import java.lang.annotation.*;

@MyAnnotation
class Dod {
    @MyAnnotation
    public void doss() {
        System.out.println(123);
    }
}

// 自定义注解
@Target(value = {ElementType.METHOD,ElementType.TYPE})
@Retention(value = RetentionPolicy.RUNTIME)
@Documented
@Inherited
@interface MyAnnotation{

}
```

:turtle: <span style="color: #a50">@Target</span> 也可以只匹配一个值，不一定是多个。



## 自定义注解

可以使用 <span style="color: #a50">@interface</span> 自定义注解，它会自动继承 <span style="color: #a50">java.lang.annotation.Annotation</span> 接口。

`例子`

```java
@Other(name="demo")
@Night("demo")
class Dod {
    public void doss() {
        System.out.println(123);
    }
}

@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@interface Other{
    // 注解参数
    String name();
    int[] ids() default {1,2};
}

@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@interface Night{
    // 注解参数
    String value();
}
```

:star2: 注解可以有参数，它的类型可以是基本类型，类，字符串，枚举；

:star2: 注解参数的格式为 <span style="color: #a50">类型 名称()</span>

:star2: 使用注解时，必须对没提供默认值的注解参数进行赋值；

:star2: 如果注解只有一个参数，可以将其定义为 <span style="color: #a50">value</span>，此时赋值可以用<span style="color: #ff0000">简写</span>。



## 反射(Reflection)的概念

区别于在运行时能够改变结构的动态语言，如 JavaScript，Java 本身是静态语言；

借助反射机制，Java 能成为<span style="color: slategray">准动态语言</span>，可以获取任何类的内部信息，直接操作对象的内部属性/方法。

### Class类

类加载好后，会在堆内存的方法区中产生一个 Class 类型的对象，它包含了完整的类的结构信息；

### 提供能力


- 在运行时构造类的对象
- 在运行时判断类所具有的成员变量和方法
- 在运行时判断对象所属的类
- 在运行时调用对象的成员变量和方法
- 在运行时获取泛型信息
- 在运行时处理注解
- 生成动态代理

| 相关API                       | 说明           |
| ----------------------------- | -------------- |
| java.lang.Class               | 类             |
| java.lang.reflect.Method      | 类的方法       |
| java.lang.reflect.Field       | 类的成员变量   |
| java.lang.reflect.Constructor | 类的构造器方法 |

### 例子

```java
package com.baidu.Reflection;

public class Test {
    public static void main(String[] args) throws ClassNotFoundException {
        // 通过反射获取类的Class对象
        Class c1 = Class.forName("com.baidu.Reflection.User");
        Class c2 = Class.forName("com.baidu.Reflection.User");

        System.out.println(c1.hashCode());
        System.out.println(c2.hashCode());
    }
}

class User {}
```

:ghost: 由于类的实例，对应的Class对象是同一个，所以两次输出的结果相同。



## 获取Class类

类加载好后，会在堆内存的方法区中产生一个 Class 类型的对象，它包含了完整的类的结构信息；

Class 类是 Reflection 的根源，获得相应的 Class 对象后可以动态加载、运行类；

由 JVM 生成，无法主动创建。

`例子`

```java
package com.baidu.reflection;

public class Test2 {
    public static void main(String[] args) throws ClassNotFoundException {
        Person student = new Student();

        // 1.通过对象实例获得
        Class c1 = student.getClass();

        // 2.通过路径获得
        Class c2 = Class.forName("com.baidu.reflection.Student");

        // 3.通过类的class属性获得
        Class c3 = Student.class;

        // 4.基本内置类型的包装类的TYPE属性也是Class
        Class c4 = Integer.TYPE;

        // 5.获得父类类型
        Class c5 = c1.getSuperclass();

        System.out.println(c1.hashCode());
        System.out.println(c2.hashCode());
        System.out.println(c3.hashCode());
        System.out.println(c5);

    }
}

class Person {}

class Student extends Person {}
```

> 其中的 1~3 都指向同个 Class 对象。



## 拥有Class对象的类型

- 类（外部类、成员内部类、静态内部类、局部内部类、匿名内部类）
- 接口
- 数组
- 枚举
- 注解
- 基本数据类型
- void

```java
class Test {
    public static void main( String[] args) {
        Class c1 = Object.class; //类
        Class c2 = Comparable.class; //接口
        Class c3 = String[].class; //一维数组
        Class c4 = int[][].class; //二维数组
        Class c5 = Override.class; //注解
        Class c6 = ElementType.class; //枚举
        Class c7 = Integer.class; //基本数据类型
        Class c8 = void.class;  //void
        Class c9 = Class.class; // class
            
        int[] a = new int[10];
        int[] b = new int[100];
        // 输出相同：元素类型与维度一样，就是同一个Class
        System.out.println(a.getClass().hashCode());
        System.out.println(b.getClass().hashCode());
    }
}
```



## 类加载内存分析

![image-20221201234445225](.\img\类加载内存分析)

```java
/*
  1.加载到内存，产生一个类对应的Class对象
  2.进行链接，为类变量分配变量并设初始值
  3.初始化，执行<clinit>(),合并类变量的赋值和静态代码块的语句
*/
public class Test {
    public static void main(String[] args) {
        A a = new A();
        System.out.println(A.m); // 100
    }
}

class A {
    static {
        System.out.println("静态代码块初始化");
        m = 300;
    }
    static int m = 100;

    public A() {
        System.out.println("无参构造初始化");
    }
}
```



## 类初始化时机

<span style="color: #f7534f;font-weight:600">类的主动引用-会发生类的初始化</span>

- 当虚拟机启动，先初始化 main 方法所在的类

- 创建类的实例
- 调用类的静态成员/方法（除了<span style="color: #a50">final</span>常量）
- 使用 java.lang.reflect 包的方法对类进行<span style="color: #a50">反射调用</span>
- 当初始化一个类，如果其父类没有被初始化，则先会初始化它的父类



<span style="color: #f7534f;font-weight:600">类的被动引用-不会发生类的初始化</span>

- 访问一个静态域时，仅初始化声明该域的类（如：通过子类引用父类的静态变量，不会导致子类初始化）
- 通过数组定义类引用，不会触发此类的初始化
- 引用常量不会触发此类的初始化（常量在<span style="color: #a50">链接阶段</span>就存入调用类的常量池中了)

`例子`

```java
public class Test {
    public static void main(String[] args) {
        // Test -> Father -> Son
        Son son = new Son 
        // Test -> Father -> Son
        Class c = Class.forName("com.baidu.reflection.Son");
        
        // Test -> Father
        System.out.println(Son.b);
        // Test
        Son[] array = new Son[6];
        // Test
        System.out.println(Son.M);
    }
}

class Father {
    static int b = 2;
}

class Son extends Father {
    static final int M = 1;
}
```



## 类加载器的作用

<span style="color: #f7534f;font-weight:600">类加载的作用</span> 将 class 文件字节码内容<span style="color: #ff0000">加载到内存中</span>，并将这些静态数据转换成方法区的运行时数据结构，然后在堆中<span style="color: #ff0000">生成一个代表这个类的 java.lang.Class 对象</span>，作为方法区中类数据的访问入口。

<span style="color: #f7534f;font-weight:600">类缓存</span>：标准的 JavaSE 类加载器可以按要求查找类，但一旦某个类被加载到类加载器中，它将维持加载（缓存)一段时间。不过 JVM 垃圾回收机制可以回收这些 Class 对象

![image-20221202225510361](.\img\类加载器的作用)



| 类加载器的类型 | Classloader | 说明                                                         |
| -------------- | ----------- | ------------------------------------------------------------ |
| 引导类加载器   | Bootstap    | C++编写；JVM自带；装载核心类库；无法直接获取                 |
| 扩展类加载器   | Extension   | 负责 jre/lib/ext 或 java.ext.dirs 下的 jar 包装入工作        |
| 系统类加载器   | System      | 负责 java -classpath 或 java.class.path 下的 jar 包装入工作；最常用 |

:whale: 双亲委派机制：手写了同样路径的包时，如果核心包有相同的包，手写包无效。



## 获得类的运行时结构

可以获得实现的接口、继承的父类、构造器、方法、Field、注解等



| class实例方法           | 说明                       |
| ----------------------- | -------------------------- |
| getName                 | 获得包名 + 类名            |
| getSimpleName           | 获得类名                   |
| getFields               | 获得public属性             |
| getDeclaredFields       | 获得所有属性               |
| getField                | 获得指定public属性的值     |
| getDeclaredField        | 获得指定任意类型属性的值   |
| getMethods              | 获得本类和父类的public方法 |
| getDeclaredMethods      | 获得本类的所有方法         |
| getMethod               | 获得无参数/指定参数方法    |
| getConstructors         | 获得public构造器           |
| getDeclaredConstructors | 获得所有构造器             |
| getDeclaredConstructor  | 获得指定构造器             |

`例子`

```java
public class Test {
    public static void main(String[] args) throws ClassNotFoundException, NoSuchFieldException, NoSuchMethodException {
        Class c1 = Class.forName("com.baidu.reflection.User");

        // 获得类的名字
        System.out.println(c1.getName());         
        System.out.println(c1.getSimpleName());    

        // 获得类的属性
        System.out.println(c1.getFields());                   
        System.out.println(c1.getDeclaredFields());           
        System.out.println(c1.getField("name"));         
        System.out.println(c1.getDeclaredField("name")); 

        // 获得类的方法
        System.out.println(c1.getMethods());              
        System.out.println(c1.getDeclaredMethods());       
        System.out.println(c1.getMethod("getName")); // 获得无参指定方法
        System.out.println(c1.getMethod("setName", String.class)); // 获得指定参数方法

        // 获得类的构造器
        System.out.println(c1.getConstructors());        
        System.out.println(c1.getDeclaredConstructors());  
        System.out.println(c1.getDeclaredConstructor(String.class, int.class, int.class)); 
    }
}
```



## 通过反射创建对象

### 创建对象

`例子`

```java
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

public class Test04 {
    public static void main(String[] args) throws {
        // 1.获得Class对象
        Class c1 = Class.forName("com.baidu.reflection.User");

        // 2.a 构建对象（调用了类的无参构造器）
        User user = (User)c1.newInstance();

        // 2.b 通过构造器构建对象
        Constructor constructor = c1.getDeclaredConstructor(String.class, int.class);
        User user2 = (User)constructor.newInstance("master", 98);
    }
}
```



### 访问实例方法/属性

```java
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class Test04 {
    public static void main(String[] args) {
        // 获得Class对象
        Class c1 = Class.forName("com.baidu.reflection.User");
        User user = (User)c1.newInstance();

        /* 通过反射调用普通方法 */
        Method setName = c1.getDeclaredMethod("setName", String.class);
        // 调用方法：首参为对象，剩余参数为方法参数
        setName.invoke(user, "master");
        System.out.println(user.getName());

        /* 通过反射操作属性 */
        Field name = c1.getDeclaredField("name");
        // 可以关闭程序的安全检测，来操作私有属性
        name.setAccessible(true);
        name.set(user, "didier");
        System.out.println(user.getName());
    }
}
```

:whale: Method、Field、Constructor对象都有 <span style="color: #a50">setAccessible</span> 方法；

:ghost: 频繁使用反射时，会降低效率。设置 <span style="color: #a50">setAccessible</span> 方法可以提高性能，并能访问私有属性。



### 性能对比分析

可以用下面的代码检测代码执行所需要的时间。

```java
long startTime = System.currentTimeMillis();
// do
long endTime = System.currentTimeMillis();
System.out.println((endTime - startTime) + "ms")
```

:whale: 正常调用方法比普通反射要快几百倍，而关闭程序的安全检测的反射比普通反射快几倍。



## 获取注解信息

```java
package com.baidu.reflection;

import java.lang.annotation.*;
import java.lang.reflect.Field;

public class test05 {
    public static void main(String[] args) throws ClassNotFoundException, NoSuchFieldException {
        Class c1 = Class.forName("com.baidu.reflection.Man");

        // 获得类的全部注解
        Annotation[] annotations = c1.getAnnotations();
        for (Annotation annotation : annotations) {
            System.out.println(annotation);
        }
        // 获得类的指定注解的值
        TableName table = (TableName) c1.getAnnotation(TableName.class);
        String value = table.value();
        System.out.println(value);
        // 获得类属性的指定注解的值
        Field name = c1.getDeclaredField("name");
        FieldObj annotation = name.getAnnotation(FieldObj.class);
        System.out.println(annotation.columnName());
        System.out.println(annotation.type());
        System.out.println(annotation.length());

    }
}

@TableName("db_user")
class Man {
    @FieldObj(columnName = "db_id", type = "int", length = 10)
    private int id;
    @FieldObj(columnName = "db_name", type = "varchar", length = 3)
    private  String name;

    public Man(int id, String name) {
        this.id = id;
        this.name = name;
    }
}

// 类名的注解
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@interface TableName{
    String value();
}

// 属性的注解
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@interface FieldObj{
    String columnName();
    String type();
    int length();
}
```





