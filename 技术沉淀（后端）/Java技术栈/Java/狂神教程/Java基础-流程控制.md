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

### Arrays类

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

