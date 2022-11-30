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