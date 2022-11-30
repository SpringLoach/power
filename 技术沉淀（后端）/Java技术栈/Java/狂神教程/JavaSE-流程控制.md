## 获取用户输入

java.util.Scanner 是 Java5 的新特性，可以通过 Scanner 类来获取用户输入。

### Scanner 类

| 实例方法      | 说明                   |
| ------------- | ---------------------- |
| next()        | 获取输入的字符串       |
| nextLine()    | 获取输入的字符串       |
| hasNext()     | 判断是否还有输入的数据 |
| hasNextLine() | 判断是否还有输入的数据 |

**next()**

- 读取到有效字符后才结束输入，会让程序等待接收；
- 忽略前面的空格，字符间的空格会被视作结束符。

**nextLine()**

- 以 Enter 作为结束符，可以获得空格。



### 读取键盘输入-next

```java
import java.util.Scanner;

public class Demo {
    public static void main(String[] args) {

        // 创建一个扫描器对象，用于接收键盘数据
        Scanner scanner = new Scanner(System.in);

        System.out.println("使用next方式接收：");

        // 使用 next 方法接收
        String str = scanner.next();
        System.out.println("输出的内容为："+str);


        // 凡是属于IO流的类如果不关闭会一直占用资源
        scanner.close();

    }
}
```

:hammer_and_wrench: 使用内置类时，IDEA 会有智能提示，并自动引入。



### 读取键盘输入-nextLine

```java
public class NextLine {
    public static void main(String[] args) {

        Scanner scanner = new Scanner(System.in);

        // 使用 nextLine 方法接收
        String str = scanner.nextLine();
        System.out.println("输出的内容为："+str);

        scanner.close();
    }
}
```



### 案例-判断输入值类型

```java
public static void main(String[] args) {
    Scanner scanner = new Scanner(System.in);

    int i = 0;
    float f = 0.0f;

    System.out.println("请输入整数：");

    if (scanner.hasNextInt()){
        i = scanner.nextInt();
        System.out.println("整数数据：" + i);
    } else {
        System.out.println("输入的不是整数");
    }

    System.out.println("请输入小数：");

    if (scanner.hasNextFloat()){
        f = scanner.nextFloat();
        System.out.println("小数数据：" + i);
    } else {
        System.out.println("输入的不是小数");
    }

    scanner.close();
}
```

:question: 如果是按照 next 方法能使程序暂停等待输入的说法，这里的流程判断有点奇怪。



### 案例-读取多个输入

> 输入多个数字，求和、平均数，数字通过回车确认，输入了非数字时结束并返回结果

```java
public static void main(String[] args) {
    Scanner scanner = new Scanner(System.in);

    double sum = 0;
    int count = 0;

    // 通过循环判断是否还有输入
    while (scanner.hasNextDouble()){
        double x = scanner.nextDouble();
        count++;
        sum += x;
    }

    System.out.println("数量：" + count);
    System.out.println("平均数：" + (sum/count));
        
    scanner.close(); 
}
```



## for循环

`示例`

```java
for (int i = 0; i < 10; i++) {
    System.out.println(i);
}
```

### 案例-输出格式

输出能被 5 整除的数，每行最多输出 3 个

```java
for (int i = 0; i <= 1000; i++){
    if (i%5==0) {
        System.out.print(i+"\t"); 
    }
    if (i%15==0){
        System.out.println("\n");
    }
}
```

<span style="color: #f7534f;font-weight:600">print </span>输出完不会换行

<span style="color: #f7534f;font-weight:600">println </span>输出完会换行



### 案例-输出乘法表

```java
for (int i = 1; i <= 9; i++) {
    for (int j = 1; j <= i; j++) {
        System.out.print(i+"*"+j+"="+(i*j) + "\t");
    }
    System.out.println();
}
```



### 增强for循环

> 用于数组或集合类型

```java
int[] demo = {1,2,3};

// 遍历数组元素
for(int i: demo) {
    System.out.println(i);
}
```



### 案例-打印三角形

```java
for (int i = 1; i <= 5; i++) {
    for (int j = 5; i < j; j--) {
        System.out.print(" ");
    }
    for (int j = 1; j <= i; j++) {
        System.out.print("*");
    }
    for (int j = 1; j < i; j++) {
        System.out.print("*");
    }
    System.out.println();
}

// 可以视作如下
    *
   **|* 
  ***|** 
 ****|***
*****|****
```



## --方法--



### 方法返回值

```java
public static int max(int a, int b) {
    int result;

    if (a == b) {
        return -1;
    }

    if (a > b) {
        result = a;
    } else {
        result = b;
    }
    return result;
}
```

:star2: 方法的返回值类型非 void 时，必须在最外层显性返回对应类型的值；

:turtle: 判断语句中的 return 依旧能退出方法。



## --数组--

### Arrays工具类

| 方法            | 说明                       |
| --------------- | -------------------------- |
| Arrays.fill     | 填充数组                   |
| Arrays.sort     | 对数组进行升序排列         |
| Arrays.toString | 将数组转化为字符串         |
| Arrays.equals   | 比较数组中得元素值是否相等 |

```java
int[] arr = {2,3};

System.out.println(arr);                  // [I@1b6d3586
System.out.println(Arrays.toString(arr)); // [2, 3]
```



## 面向对象

### 面向对象&面向过程

<span style="color: #f7534f;font-weight:600">面向过程</span>

步骤<span style="color: #ff0000">清晰</span>简单，第一步做什么，第二步做什么...，适合处理一些简单的问题；

<span style="color: #f7534f;font-weight:600">面向对象</span>

将问题先进行<span style="color: #ff0000">宏观分析</span>，像将大象放入冰箱，只需要打开门，放进冰箱就好；

<span style="color: #f7534f;font-weight:600">面向对象编程的本质</span> 

以类的方式组织代码，以对象的方式组织(封装)数据。

:whale: 对于较为复杂的事物，为了从宏观上把握、从整体上合理分析，需要使用面向对象的思想来分析系统。但是具体到微观操作，仍需要以面向过程的思路处理。



### 静态vs实例方法

`定义方法`

```java
package com.baidu.www;

public class Way1 {
    public void hey() {
        System.out.println("hey");
    }
    public static void say() {
        System.out.println("say");
    }
}
```

`调用方法`

```java
package com.baidu.www;

public class Way2 {
    public static void main(String[] args) {
        // 调用静态方法
        Way1.say();
        // 调用实例方法
        Way1 demo = new Way1();
        demo.hey();
    }
}
```

:ghost: 类的静态方法内部无法使用实例方法。



### 访问实例变量

```java
public class Way2 {
    int age = 2;
    public void dos() {
        System.out.println(age);
        System.out.println(this.age);
    }

    public static void main(String[] args) {
        Way2 demo = new Way2();
        demo.dos(); // 2 2
    }
}
```

用 this 不用 this 都可以，为什么？



### static关键字详解

#### 实例的访问

```java
public class Way2 {
    static int age = 6;

    public static void main(String[] args) {
        System.out.println(Way2.age);

        Way2 demo = new Way2();
        System.out.println(demo.age);
    }
}
```

:star2: 实例上也能访问到静态成员。



#### 代码块

```java
public class Demo {

	{
		System.out.println('匿名代码块');
	}
    
    static {
		System.out.println('静态代码块');
	}
    
    public Person() {
		System.out.println('构造方法');
	}
    
    public static void main(String[] args) {
        Demo demo = new Deom();
        Demo demo2 = new Deom();
    }
}
// 调用顺序： 静态代码块 -> 匿名代码块 -> 构造方法
// 创建多实例时， 静态代码块只有首次会调用
```



#### 静态导入包

```java
// 静态导入包
import static java.lang.Math.random;

public class Test {
    public static void main(String[] args) {
        System.out.println(random());
    }
}
```

:whale: 使用该技术，可以直接调用外部包的方法，很少用到。



### 内部类

`定义`

```java
public class Outer {
  private int id = 10;
  public void out() {
    System.out.println("外部类的方法");
  }
  // 定义成员内部类
  public class Inner {
    public void in() {
      System.out.println("内部类的方法");
      // 可以获得外部类的私有属性
      System.out.println(id);
    }
  }
}
```

:whale: 静态内部类无法访问到外部类的实例属性；

:star2: `.java` 中可以有多个 <span style="color: #a50">class</span>，但只能有一个 <span style="color: #a50">public class</span>。

`使用`

```java
public class Demo {
  public static void main(String[] args) {
    Outer outer = new Outer();
    // 通过外部类的实例，来实例化内部类
    Outer.Inner inner = outer.new Inner();
    inner.in();
  }
}
```



## 异常

### 分类

- Java把异常当作对象来处理，并定义了基类 java.lang.Throwable 作为所有异常的超类；

- 这些异常被分为两大类，<span style="color: #a50">错误Error</span> 和 <span style="color: #a50">异常Exception</span>

![image-20221127155629236](.\img\异常体系)

:ghost: Error 由 Java 虚拟机（JVM）生成并抛出，多数与代码编写无关；会导致线程终止

:ghost: Exception下的分支 RuntimeException，代表运行时异常，<span style="color: #ff0000">大多是程序逻辑错误引起</span>。

>  Error 通常是致命的，是程序无法控制和处理的， Exception 通常是程序可以处理的。



### 捕获和抛出异常

#### 捕获异常

![image-20221127173625817](.\img\捕获和抛出异常)

```java
public class Demo {
    public static void main(String[] args) {
        int a = 1;
        int b = 0;

        try {
            System.out.println(a/b);
        } catch (ArithmeticException e) {
            System.out.println("常量b不能为0");
        } finally {
            System.out.println("可选，一般用于IO流中资源的关闭");
        }
    }
}
```

:star2: 正常情况下，异常如果没有被捕获，将会被抛出到控制台上；

:star2: 更大范围的异常类，能够捕获具体的异常；

:star2: 设置的 catch 没有匹配时，对应代码不会执行，但最后的 finally 中的代码仍然会执行；

:star2: 设置多个捕获（<span style="color: #a50">catch</span>）时，只有首个匹配的捕获生效，故更大范围的异常应该放在后面。



#### 抛出异常

```java
package com.baidu.www;

public class Demo {
    public static void main(String[] args) {

        Demo demo = new Demo();
        try {
            demo.dos(0);
        } catch (ArithmeticException e) {
            System.out.println("在外层处理");
            e.printStackTrace(); // 将错误栈抛出
        }
    }

    // 如果方法处理不了异常，可以抛出
    public void dos(int a) throws ArithmeticException {
        if (a==0) {
            throw new ArithmeticException();
        }
    }
}
```

:star2: 当方法处理不了异常时，可以抛出，在更外层捕获解决。



### 自定义异常

`定义异常`

```java
public class Demo extends Exception {
    private int detail;

    public Demo(int num) {
        this.detail = num;
    }

    @Override
    public String toString() {
        return "输入的数字不能大于10: " + detail;
    }
}
```

:ghost: 创建自定义异常，其实就是创建继承了 <span style="color: #a50">Exception</span> 的类；

:ghost: 可以向它的构造参数传参，重写 toString 方法可以方便输出。

`抛出异常`

```java
public class Demo2 {
    static void test(int a) throws Demo {
        if (a > 10) {
            throw new Demo(a);
        }
    }

    public static void main(String[] args) {
        try {
            test(12);
        } catch (Demo e) {
            System.out.println(e); // 输入的数字不能大于10: 12
        }
    }
}
```

:ghost: 抛出异常就是实例化对应的类，允许传递参数来实例化。



## 待补充

- 常用类

  ```
  Object 
    - hashcode、toString、clone、getClass、notify、wait、equals
  Math 
    - 常见的数学运算
  Random
    - 生成随机数
  File
    - 创建文件
    - 查看文件
    - 修改文件
    - 删除文件
  包装类
    - 自动装箱、拆箱
  Date类
  String类
  StringBuffer
  StringBuilder
  ```

- lambda表达式

- IO流

- 多线程

- 注解和反射
