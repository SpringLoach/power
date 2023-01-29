## 基本认识

Java虚拟机允许应用程序同时执行多个执行线程。

![image-20221128001034803](.\img\多线程)



### 程序与进程的关系

<span style="color: #f7534f;font-weight:600">程序</span> 指令和数据的有序集合，本身没有运行的含义，是静态的概念；

<span style="color: #f7534f;font-weight:600">进程</span> 执行程序的依次执行过程，是动态的概念。



### 核心概念

在一个进程中，如果存在多个线程，线程的运行由调度器安排，调度器与操作系统紧密相关，先后顺序无法认为干预；

操作相同的资源时，会存在资源抢夺的问题，需要加入并发控制；

线程会带来额外开销，如cpu调度时间，并发控制开销；

就像是同时有 5 个人买两张票，不控制会使得总票数变为负数，而这个控制本身也有成本。



## 实现方案

### 实现的三种方案

- <span style="color: #f7534f;font-weight:600">Thread类</span>           ==>  继承Thread类（重点）
- <span style="color: #f7534f;font-weight:600">Runnable接口</span>  ==>  实现Runnable接口（重点）
- <span style="color: #f7534f;font-weight:600">Callable接口</span>     ==>  实现Callable接口（了解）

:whale: 其中 Thread 类本身就实现了 Runnable 接口。

:ghost: 不建议使用 <span style="color: #a50">Thread类</span>：存在单继承局限性；

:ghost: 推荐使用 <span style="color: #a50">Runnable接口</span>：避免单继承局限性，方便同个对象被多个线程使用。



### 实现-Thread类

1. 自定义线程类，特点是继承 <span style="color: #a50">Thread类</span>；
2. 重写该线程类的 <span style="color: #a50">run</span> 方法，即线程的执行体；
3. 创建线程类的实例，调用 <span style="color: #a50">start</span> 方法启动线程。

```java
public class Demo extends Thread {
    @Override
    public void run() {
        System.out.println("通过start启动另一线程");
    }

    public static void main(String[] args) {
        // main，即主线程入口
        Demo demo = new Demo();
        // 这里启动另一线程
        demo.start();

        System.out.println("主线程");
    }
}
```

:ghost: 若直接调用实例的 <span style="color: #a50">run</span> 方法，将不会启动线程；

:star2: 线程开启后，不一定立即执行，由CPU调度执行。



#### 下载网络图片

**准备**

打开[官网](https://commons.apache.org/proper/commons-io/download_io.cgi)下载，直接点击 `commons-io-2.x.x-bin.zip`，这个是 windows 版本

```elm
- src
  + com
    - lib // 新建
```

将解压文件夹下的 `commons-io-2.x.x.jar` 拷贝到 lib 文件夹下，然后将 lib 添加到 library

![image-20221128111748668](.\img\library)

添加成功后可以在这里看到

![image-20221128111948338](.\img\library2)

**定义并调用**

1. 先准备好下载类；
2. 创建线程类，通过构造函数初始化实例成员；
3. 重写 run 方法；
4. 实例化线程类，并开启线程。

```java
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;
import java.net.URL;

public class Demo extends Thread {

    private String url; // 网络图片地址
    private String name; // 保存的文件名

    public Demo(String url, String name) {
        this.url = url;
        this.name = name;
    }

    @Override
    public void run() {
        WebDownloader webDownloader = new WebDownloader();
        webDownloader.downloader(url, name);
        System.out.println("下载文件：" + name);
    }

    public static void main(String[] args) {
        Demo demo1 = new Demo("https://xx", "1.png");
        Demo demo2 = new Demo("https://xx", "2.png");
        Demo demo3 = new Demo("https://xx", "3.png");

        demo1.start();
        demo2.start();
        demo3.start();
    }
}

// 下载器
class WebDownloader {
    // 下载方法
    public void downloader(String url, String name) {
        try {
            FileUtils.copyURLToFile(new URL(url), new File(name));
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("IO异常：downloader方法出错");
        }
    }
}
```

:hammer_and_wrench: 输入 new URL、new File、FileUtils 等配合提示，可以自动引入相应的包。



### 实现-Runnable接口

1. 创建一个实现了 <span style="color: #a50">Runnable接口</span> 的特殊类；
2. 重写该线程类的 <span style="color: #a50">run</span> 方法，即线程的执行体；
3. 创建特殊类的实例，将其作为参数实例化<span style="color: #a50">Thread类</span>，调用 <span style="color: #a50">start</span> 方法启动线程。

```java
public class Demo implements Runnable {
    @Override
    public void run() {
        System.out.println("通过start启动另一线程");
    }

    public static void main(String[] args) {
        // main，即主线程入口
        Demo demo = new Demo();
        // 创建线程对象，通过线程对象来开启线程（代理）
        Thread thread = new Thread(demo);
        thread.start();

        // 也可以省略中间变量
        // new Thread(demo).start(); 

        System.out.println("主线程");
    }
}
```



#### 多线程操作同一对象

```java
public class Demo implements Runnable {
    // 剩余票数
    private int nums = 10;

    @Override
    public void run() {
        while(true) {
            if (nums <= 0) {
                break;
            }
            // 模拟延时: 200ms
            try {
                Thread.sleep(200);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            System.out.println(Thread.currentThread().getName() + "拿到了第" + nums-- + "张票");
        }
    }

    public static void main(String[] args) {
        Demo demo = new Demo();

         new Thread(demo, "wang").start();
         new Thread(demo, "fan").start();
         new Thread(demo, "liu").start();
    }
}
```

:ghost: <span style="color: #a50">new Thread</span> 的第二个参数将作为线程名；

:ghost: 通过 <span style="color: #a50">Thread.currentThread().getName()</span> 可以获取当前线程的名；

:octopus: 这里会存在问题，多线程操作同一资源，导致线程不安全，数据紊乱。



#### 龟兔赛跑

1. 多名参赛者参与，相当于开启多条线程；
2. 参赛者会有特殊的行为，在 run 方法中判断操作；
3. 由于胜利者只有一个，使用静态属性表示；
4. 有人胜出时，选出胜利者，且线程可以停止。

```java
package com.baidu.Thread;

// 模拟龟兔赛跑
public class Race implements Runnable {
    // 胜利者，只有一个，可以使用静态成员
    private static String winner;

    @Override
    public void run() {
        for(int i = 0; i <= 100; i++) {

            // 模拟兔子休息：兔子在中途休息
            if(Thread.currentThread().getName().equals("兔子") && i==50){
                try {
                    Thread.sleep(1);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }

            // 比赛结束时，停止程序
            boolean flag = gameOver(i);
            if (flag) {
                break;
            }

            System.out.println(Thread.currentThread().getName() + "跑了" + i);
        }
    }

    // 判断比赛是否完成
    private boolean gameOver(int steps) {
        // 已经存在胜利者
        if (winner != null) {
            return true;
        } else {
            if (steps == 100) {
                winner = Thread.currentThread().getName();
                System.out.println("胜出者:" + winner);
                return true;
            }
        }
        return false;
    }

    public static void main(String[] args) {
        Race race = new Race();

        new Thread(race, "兔子").start();
        new Thread(race, "乌龟").start();
    }
}
```

:flipper: 这里属性写成私有的，能够保证线程安全。



### 实现-Callable接口

>  好处是可以定义返回值，且能够抛出异常。

#### 下载网络图片

**定义并调用**

1. 先准备好下载类；
2. 创建一个实现了 <span style="color: #a50">Callable接口</span> 的特殊类，通过构造函数初始化实例成员；
3. 重写该特殊类的 <span style="color: #a50">call</span> 方法，且<span style="color: #ff0000">必须提供返回值</span>；
4. 实例化特殊类，创建服务，将特殊类提交执行，需要抛出异常；
5. 获取结果后，关闭服务。

```java
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.concurrent.*;

public class Demo implements Callable<Boolean> {

    private String url; // 网络图片地址
    private String name; // 保存的文件名

    public Demo(String url, String name) {
        this.url = url;
        this.name = name;
    }

    @Override
    public Boolean call() {
        WebDownloader webDownloader = new WebDownloader();
        webDownloader.downloader(url, name);
        System.out.println("下载文件：" + name);
        return true;
    }

    public static void main(String[] args) throws ExecutionException, InterruptedException {
        Demo demo1 = new Demo("https://xx", "1.png");
        Demo demo2 = new Demo("https://xx", "2.png");
        Demo demo3 = new Demo("https://xx", "3.png");

        // 1.创建服务：开启3个线程
        ExecutorService ser = Executors.newFixedThreadPool(3);

        // 2.提交执行
        Future<Boolean> r1 = ser.submit(demo1);
        Future<Boolean> r2 = ser.submit(demo2);
        Future<Boolean> r3 = ser.submit(demo3);

        // 3.获取结果
        boolean rs1 = r1.get();
        boolean rs2 = r2.get();
        boolean rs3 = r3.get();

        // 4.关闭服务
        ser.shutdownNow();
    }
}

// 下载器
class WebDownloader {
    // 下载方法
    public void downloader(String url, String name) {
        try {
            FileUtils.copyURLToFile(new URL(url), new File(name));
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("IO异常：downloader方法出错");
        }
    }
}
```



## 静态代理模式

>  本质就是两个类都实现了同一个接口，静态代理类能够在被代理类的行为上进行增强。

```java
// 婚庆公司的结婚，能给个人的结婚带来更多的修饰
public class StaticProxy {
    public static void main(String[] args) {
        WeddingCompany company = new WeddingCompany(new Master());
        company.HappyMarry();
    }
}

interface Marry {
    void HappyMarry();
}

class Master implements Marry {
    @Override
    public void HappyMarry() {
        System.out.println("master要结婚了，开心");
    }
}

class WeddingCompany implements Marry {
    private Marry people;

    public WeddingCompany(Marry people) {
        this.people = people;
    }

    @Override
    public void HappyMarry() {
        System.out.println("婚庆公司布置现场，热闹气氛");
        people.HappyMarry();
        System.out.println("婚庆公司收取费用");
    }
}
```

:whale: <span style="color: #a50">Runnable接口</span>实现线程，就是用的这个方法；



## Lambda表达式

使用 lambda 表达式，可以避免匿名内部类过多，使代码变得更简介；

- <span style="color: #ed5a65">函数式接口</span> 只包含一个抽象方法的接口；

- 可以使用 lambda 表达式创建函数式接口的对象



### 简化过程

```java
package com.baidu.Thread;

// 0.定义函数式接口
interface ILike {
    void lambda();
}

// 1.实现类
class Like implements ILike {
    @Override
    public void lambda() {
        System.out.println("lambda--1");
    }
}

public class TestLambda {
    // 2.静态内部类
    static class Like2 implements ILike {
        @Override
        public void lambda() {
            System.out.println("lambda--2");
        }
    }

    public static void main(String[] args) {
        ILike like = new Like();
        like.lambda();

        like = new Like2();
        like.lambda();

        // 3.局部内部类
        class Like3 implements ILike {
            @Override
            public void lambda() {
                System.out.println("lambda--3");
            }
        }
        like = new Like3();
        like.lambda();

        // 4.匿名内部类：没有类的名称，必须借助接口或父类
        like = new ILike() {
            @Override
            public void lambda() {
                System.out.println("lambda--4");
            }
        };
        like.lambda();

        // 5.用lambda简化
        like = () -> {
            System.out.println("lambda--5");
        };
        like.lambda();

    }
}
```



### 简化写法

```java
interface ILove {
    void dos(int a);
}

public class TestLambda2 {
    public static void main(String[] args) {
        ILove love = null;

        love = (int a) -> {
            System.out.println(a);
        };

        love = a -> System.out.println(a);

        love.dos(6);
    }
}
```

:star2: 可以省略参数类型，一旦省略，所有参数都要省略；

:star2: 只有一个参数时，可以省略 `()`

:star2: 只有一个语句时，可以省略 `{}`



## 线程状态

![image-20221128210319286](.\img\线程状态1)



![image-20221128210425558](.\img\线程状态2)

## 线程操作

| 线程方法                       | 说明                               |
| ------------------------------ | ---------------------------------- |
| setPriority(int newPriority)   | 更改线程的优先级                   |
| static void sleep(long millis) | 让当前线程休眠指定毫秒             |
| void join()                    | 等待当前线程终止                   |
| static void yield()            | 暂停当前的线程对象，并执行其它线程 |
| void interrupt()               | 中断线程，不建议使用               |
| boolean isAlive()              | 判断线程是否处于活动状态           |



### 停止线程

![image-20221128210917450](.\img\停止线程)



### 线程休眠

- sleep 方法能够指定线程阻塞的毫秒数；

- sleep 方法存在异常 InterruptedException；

- sleep 阻塞结束后，线程进入就绪状态；

- 使用 sleep 模拟网络延时，可以使潜在问题更易暴露；

- 每个对象都有一个锁，sleep 不会释放锁。



### 线程礼让

- 让当前正在执行的线程暂停，但不阻塞；
- 将线程由运行状态转为就绪状态；
- 需要cpu调度，<span style="color: #ff0000">礼让不一定成功</span>。

```java
public class TestYield {
    public static void main(String[] args) {
        MyYield myYield = new MyYield();

        new Thread(myYield, "a").start();
        new Thread(myYield, "b").start();
    }
}

class MyYield implements Runnable {
    @Override
    public void run() {
        System.out.println(Thread.currentThread().getName());
        // 线程礼让
        Thread.yield();
        System.out.println(Thread.currentThread().getName());
    }
}
// 结果可能是 abba，也可能礼让失败，为 aabb
```



### 线程强制执行

- 待此线程执行完毕后，再执行其它线程，此时其它线程阻塞，相当于插队。

```java
public class TestJoin implements Runnable {
    @Override
    public void run() {
        System.out.println("vip");
    }

    public static void main(String[] args) throws InterruptedException {
        TestJoin testJoin = new TestJoin();

        Thread thread = new Thread(testJoin);
        thread.start();

        System.out.println("普通人1");
        thread.join(); // 让该线程先执行
        System.out.println("普通人2");
        System.out.println("普通人3");
    }
}
```



## 观测线程状态

- Thread.State：JDK中有枚举值定义

| 枚举值        | 线程状态                           |
| ------------- | ---------------------------------- |
| NEW           | 尚未启动                           |
| RUNNABLE      | 在Java虚拟机中执行                 |
| BLOCKED       | 被阻塞等待监听器锁定               |
| WAITING       | 等待另一个线程执行特定动作         |
| TIMED_WAITGIN | 等待另一个线程执行特定达到指定时间 |
| TERMINATED    | 已退出                             |

```java
public class TestState {
    public static void main(String[] args) throws InterruptedException {
        Thread thread = new Thread(() -> {
            for (int i = 0; i < 5; i++) {
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        });

        // 观察状态
        Thread.State state = thread.getState();
        System.out.println(state);

        // 启动后
        thread.start();
        state = thread.getState();
        System.out.println(state);

        // 只要线程不终止，就一直输出状态
        while(state != Thread.State.TERMINATED) {
            Thread.sleep(300);
            state = thread.getState();
            System.out.println(state);
        }
    }
}
```

:octopus: 线程一旦执行完毕，无法再通过 <span style="color: #a50">start</span> 来启动。



## 线程的优先级

优先级只是一个权重，并不能保证它就能决定线程执行的次序。

| 方法               | 说明                           |
| ------------------ | ------------------------------ |
| getPriority()      | 获取当前线程的优先级，默认 5   |
| setPriority(int i) | 设置当前线程的优先级（1 - 10） |

```java
package com.baidu.Thread;

public class TestPriority {
    public static void main(String[] args) {
        // 主线程无论优先级多少，都先跑
        System.out.println(Thread.currentThread().getName());
        System.out.println(Thread.currentThread().getPriority());

        MyPriority myPriority = new MyPriority();
        Thread thread1 = new Thread(myPriority, "a");
        Thread thread2 = new Thread(myPriority, "b");
        Thread thread3 = new Thread(myPriority, "c");

		// 先设置优先级，再启动线程，否则无效
        thread1.setPriority(8);
        thread2.setPriority(Thread.MAX_PRIORITY); // 10

        thread1.start();
        thread2.start();
        thread3.start();

    }
}

class MyPriority implements Runnable {
    @Override
    public void run() {
        System.out.println(Thread.currentThread().getName());
        System.out.println(Thread.currentThread().getPriority());
    }
}
```



## 守护线程

- 线程分为<span style="color: #ff0000">用户线程</span>和<span style="color: #ff0000">守护线程</span>；

- 虚拟机必须确保用户线程执行完毕，<span style="color: #ff0000">不需要等到守护线程执行完毕</span>；

- 守护线程，如后台记录操作日志，监控内存，垃圾回收等待..

```java
public class TestDeamon {
    public static void main(String[] args) {
        God god = new God();
        Lucy lucy = new Lucy();

        Thread thread = new Thread(god);
        // 默认值为false，表示用户线程，true表示守护线程
        thread.setDaemon(true);

        thread.start();
        new Thread(lucy).start();

    }
}

class God implements Runnable {
    @Override
    public void run() {
        while (true) {
            System.out.println("上帝保佑");
        }
    }
}

class Lucy implements Runnable {
    @Override
    public void run() {
        for (int i = 0; i < 80; i++) {
            System.out.println("开心地活着");
        }
        System.out.println("寿寝正终");
    }
}
```



## 线程同步

> 为了保证线程的同步安全，需要使用队列+锁

<span style="color: #f7534f;font-weight:600">线程同步</span> 是一种等待机制，多个线程需要同时访问同一对象时，这些线程会进入这个 <span style="color: #ff0000">对象的等待池</span> 形成队列，等待前面线程使用完毕，下一个线程再使用

<span style="color: #f7534f;font-weight:600">并发</span> 同一对象被多个线程同时操作

<span style="color: #f7534f;font-weight:600">锁机制 synchronized</span> 当一个线程获得对象的排它锁，独占资源，其它线程必须等待，使用后释放锁即可

- 一个线程持有锁会导致其它所有需要此锁的线程挂起；
- 在多线程竞争下，枷锁，释放锁会导致比较多的上下文切换 和 调度延时，引起性能问题；
- 如果一个优先级高的线程等待一个优先级低的线程释放锁，会导致优先级倒置，引起性能问题。



## 线程不安全示例

### 模拟取款

```java
public class UnSafeBank {
    public static void main(String[] args) {
        // 账户
        Account account = new Account(100, "旅游基金");

        Drawing master = new Drawing(account, 50, "master");
        Drawing wang = new Drawing(account, 100, "wang");

        master.start();
        wang.start();
    }
}

// 个人账号
class Account {
    int money;   // 卡内余额
    String name; // 卡号

    public Account(int money, String name) {
        this.money = money;
        this.name = name;
    }
}

// 模拟银行取款
class Drawing extends Thread {
    Account account; // 账号
    int drawingMoney; // 取了多少钱
    int nowMoney; // 现在手上有多少钱

    public Drawing(Account account, int drawingMoney, String name) {
        super(name);
        this.account = account;
        this.drawingMoney = drawingMoney;
    }

    @Override
    public void run() {
        if (account.money - drawingMoney < 0) {
            System.out.println("余额不足，取款失败");
            return;
        }

        // 模拟延时
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        // 卡内余额
        account.money = account.money - drawingMoney;
        // 取出的现金
        nowMoney = nowMoney + drawingMoney;

        System.out.println(account.name + "余额：" + account.money);
        System.out.println(this.getName() + "取出" +  nowMoney);
    }
}
```

:ghost: 对于继承了 <span style="color: #a50">Thread</span> 的类， <span style="color: #a50">this</span>.getName() 等价于 <span style="color: #a50">Thread.currentThread</span>.getName()， 该方法是从父类继承下来的。



### 不安全的线程集合

```java
import java.util.ArrayList;
import java.util.List;

public class UnsafeList {
    public static void main(String[] args) {
        List<String> list = new ArrayList<String>();
        for (int i = 0; i < 10000; i++) {
            new Thread(() -> {
                list.add(Thread.currentThread().getName());
            }).start();
        }
        System.out.println(list.size());
    }
}
```

:octopus: 这里最终打印出来的数量达不到 10000，途中会有些线程名字被插入到同个位置。



## 同步方法及同步块

> 通过 <span style="color: #a50">synchronized</span> 关键字可以实现同步方法或同步块

- 在普通方法前添加 <span style="color: #a50">synchronized </span>关键字，可以监视方法所在的类，改变其属性的行为都需要锁才能执行；

- 将 <span style="color: #a50">synchronized</span> 作为方法使用时，将监视参数对象，改变其属性的行为需要锁才能执行；

- 作为关键字，方法所在的类会有一把锁，派发到某个实例，实例下的方法，必须要实例获得这把锁才能执行，否则线程会阻塞；

- 方法里面需要修改的内容才需要锁，锁的太多，浪费资源。

```less
/* 只需要给需要修改的内容上锁 */
方法 {
  只读的代码a
  修改的代码b
}
```



### 多线程操作同一对象-解

```java
public class Demo implements Runnable {
    // 剩余票数
    private int nums = 10;

    @Override
    /* 改动：添加 synchronized 关键字 */
    public synchronized void run() {
        while(true) {
            if (nums <= 0) {
                break;
            }
            // 模拟延时: 200ms
            try {
                Thread.sleep(200);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            System.out.println(Thread.currentThread().getName() + "拿到了第" + nums-- + "张票");
        }
    }

    public static void main(String[] args) {
        Demo demo = new Demo();

        new Thread(demo, "wang").start();
        new Thread(demo, "fan").start();
        new Thread(demo, "liu").start();
    }
}
```





### 模拟取款-解

```java
package com.baidu.syn;

public class UnSafeBank {
    public static void main(String[] args) {
        // 账户
        Account account = new Account(100, "旅游基金");

        Drawing master = new Drawing(account, 50, "master");
        Drawing wang = new Drawing(account, 100, "wang");

        master.start();
        wang.start();
    }
}

// 个人账号
class Account {
    int money;   // 卡内余额
    String name; // 卡号

    public Account(int money, String name) {
        this.money = money;
        this.name = name;
    }
}

// 模拟银行取款
class Drawing extends Thread {
    Account account; // 账号
    int drawingMoney; // 取了多少钱
    int nowMoney; // 现在手上有多少钱

    public Drawing(Account account, int drawingMoney, String name) {
        super(name);
        this.account = account;
        this.drawingMoney = drawingMoney;
    }

    @Override
    public void run() {
        /* 把原本的代码用 synchronized 包围 */
        synchronized (account) {
            if (account.money - drawingMoney < 0) {
                System.out.println("余额不足，取款失败");
                return;
            }

            // 模拟延时
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            // 卡内余额
            account.money = account.money - drawingMoney;
            // 取出的现金
            nowMoney = nowMoney + drawingMoney;

            System.out.println(account.name + "余额：" + account.money);
            System.out.println(this.getName() + "取出" +  nowMoney);
        }
    }
}
```



### 不安全的线程集合-解

```java
import java.util.ArrayList;
import java.util.List;

public class UnsafeList {
    public static void main(String[] args) throws InterruptedException {
        List<String> list = new ArrayList<String>();
        for (int i = 0; i < 10000; i++) {
            new Thread(() -> {
                /* 把原本的代码用 synchronized 包围 */
                synchronized (list) {
                    list.add(Thread.currentThread().getName());
                }
            }).start();
        }
        // 不添加这里，最终会达不到 10000
        Thread.sleep(3000);
        System.out.println(list.size());
    }
}
```

:octopus: 这里不加睡眠，执行的结果仍然达不到10000，为什么？



## JUC

JUC是 <span style="color: #a50">java.util.concurrent</span> 包的简称，目的就是为了更好的支持高并发任务，让开发者进行多线程编程时减少竞争条件和死锁的问题。

### CopyOnWriteArrayList

```java
// 测试 CopyOnWriteArrayList
import java.util.concurrent.CopyOnWriteArrayList;

public class TestJUC {
    public static void main(String[] args) throws InterruptedException {
        CopyOnWriteArrayList<String> list = new CopyOnWriteArrayList<String>();
        for (int i = 0; i < 10000; i++) {
            new Thread(() -> {
                list.add(Thread.currentThread().getName());
            }).start();
        }
        Thread.sleep(3000);
        System.out.println(list.size());
    }
}
```

:ghost: 使用 <span style="color: #a50">CopyOnWriteArrayList</span> 代替 <span style="color: #a50">ArrayList</span>，不需借助 <span style="color: #a50">synchronized </span>关键字就能保证线程安全；

:octopus: 但是为什么不加睡眠还是达不到 10000 呢



## 死锁

多个线程各自占有一些共享资源，并且互相需要等到其它线程占有的资源释放才能继续执行，就会形成死锁。

某<span style="color: #ff0000">同步块</span>同时拥有两个以上对象的锁时，就可能发生死锁。



### 争夺化妆品

> 存在唯一的资源口红和镜子，一个人持有镜子，另一人持有口红，在使用完毕后，她们都想用对方的东西，但都不肯放下自己手上的。

```java
public class DeadLock {
    public static void main(String[] args) {
        new Makeup(1, "灰姑娘").start();
        new Makeup(2, "李逍遥").start();
    }
}

// 口红
class Lipstick { }

// 镜子
class Mirror { }

class Makeup extends Thread {
    // 通过 static 保证资源只有一份
    static Lipstick lipstick = new Lipstick();
    static Mirror mirror = new Mirror();

    int choice; // 选择（1-口红、2-梳子）
    String name; // 使用者

    public Makeup(int choice, String name) {
        this.choice = choice;
        this.name = name;
    }

    @Override
    public void run() {
        try {
            makeup();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    private  void makeup() throws InterruptedException {
        if (choice == 1) {
            synchronized (lipstick) {
                System.out.println(this.name + "获得口红");
                Thread.sleep(1000);
                synchronized (mirror) {
                    System.out.println(this.name + "获得镜子");
                }
            }
        }
        if (choice == 2) {
            synchronized (mirror) {
                System.out.println(this.name + "获得镜子");
                Thread.sleep(2000);
                synchronized (lipstick) {
                    System.out.println(this.name + "获得口红");
                }
            }
        }
    }
}
```

<span style="color: #a50">:ghost: synchronized</span> 方法内的是同步块，执行时，其参数对象会被上锁，必须执行方法完毕后，才会释放锁。



### 争夺化妆品-解

只需要使用完自己的物品后立即放下，就能避免该问题。

```java
public class DeadLock {
    public static void main(String[] args) {
        new Makeup(1, "灰姑娘").start();
        new Makeup(2, "李逍遥").start();
    }
}

// 口红
class Lipstick { }

// 镜子
class Mirror { }

class Makeup extends Thread {
    // 通过 static 保证资源只有一份
    static Lipstick lipstick = new Lipstick();
    static Mirror mirror = new Mirror();

    int choice; // 选择（1-口红、2-梳子）
    String name; // 使用者

    public Makeup(int choice, String name) {
        this.choice = choice;
        this.name = name;
    }

    @Override
    public void run() {
        try {
            makeup();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    private  void makeup() throws InterruptedException {
        if (choice == 1) {
            synchronized (lipstick) {
                System.out.println(this.name + "获得口红");
                Thread.sleep(1000);
            }
            // 修改
            synchronized (mirror) {
                System.out.println(this.name + "获得镜子");
            }
        }
        if (choice == 2) {
            synchronized (mirror) {
                System.out.println(this.name + "获得镜子");
                Thread.sleep(2000);
            }
            // 修改
            synchronized (lipstick) {
                System.out.println(this.name + "获得口红");
            }
        }
    }
}
```



## Lock锁

- 可以通过<span style="color: #ff0000">显式</span>定义同步锁对象（Lock对象）来实现同步；

- java.util.concurrent.locks.Lock 接口是控制多个线程对共享资源进行访问的工具。锁提供了对共享资源的独占访问，每次只能有一个线程对 Lock 对象加锁，线程开始访问共享资源之前应先获得 Lock 对象；

- <span style="color: #a50">ReentrantLock类</span>实现了 Lock，拥有与 <span style="color: #a50">synchronized</span> 相同的并发性和内存语义，且可以<span style="color: #ff0000">显式加锁、释放锁</span>

  

> 只需要定义锁，加锁 -- 解锁即可使用。

```java
import java.util.concurrent.locks.ReentrantLock;

public class TestLock {
    public static void main(String[] args) {
        Test test = new Test();

        new Thread(test).start();
        new Thread(test).start();
        new Thread(test).start();
    }
}

class Test implements Runnable {
    int nums = 10;

    // 定义lock锁
    private final ReentrantLock lock = new ReentrantLock();

    @Override
    public void run() {
        while (true) {
            try {
                lock.lock(); // 加锁
                if (nums > 0) {
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    System.out.println(nums--);
                } else {
                    break;
                }
            } finally {
                lock.unlock(); // 解锁
            }
        }
    }
}
```

:hammer_and_wrench: 一般使用锁操作会将语句放到 <span style="color: #a50">try-finally</span> 中。



## 生产消费者问题

### 问题定义

生产者生产了产品，需要通知消费者消费；

消费者消费后，需要通知生产者生产。

仅有 <span style="color: #a50">synchronized</span> 是不够的，它可以组织并发更新同一资源，但不能实现线程间的通信。

| 方法名             | 作用                                                         |
| ------------------ | ------------------------------------------------------------ |
| wait()             | 线程一直等待，直到其它线程通知，与 sleep 不同，会释放锁      |
| wait(long timeout) | 指定等待的毫秒数                                             |
| notify()           | 唤醒一个处于等待状态的线程                                   |
| notifyAll()        | 唤醒同个对象上所有调用 wait() 方法的线程，优先级高的线程优先调度 |

:ghost: 这些都是 <span style="color: #a50">Object</span> 类的方法，但只能在同步方法/同步块中使用，否则会抛出异常。



### 管程法

利用缓冲区

```java
package com.baidu.syn;

public class TestPC {
    public static void main(String[] args) {
        SynContainer container = new SynContainer();
        new Producer(container).start();
        new Consumer(container).start();
    }
}

// 生产者
class Producer extends Thread {
    SynContainer container;

    public Producer(SynContainer container) {
        this.container = container;
    }

    // 生产
    @Override
    public void run() {
        for (int i = 1; i <= 100; i++) {
            container.push(new Chicken(i));
            System.out.println("生产了" + i + "只鸡");
        }
    }
}

// 消费者
class Consumer extends Thread {
    SynContainer container;

    public Consumer(SynContainer container) {
        this.container = container;
    }

    // 消费
    @Override
    public void run() {
        for (int i = 1; i <= 100; i++) {
            System.out.println("消费第" + container.pop().id + "只鸡");
        }
    }
}

// 产品
class Chicken {
    int id; // 产品编号

    public Chicken(int id) {
        this.id = id;
    }
}

// 缓冲区
class SynContainer {
    // 需要一个容器
    Chicken[] chickens = new Chicken[10];
    // 容器计数器
    int count = 0;

    // 生产者放入产品
    public synchronized void push(Chicken chicken) {
        // 容器满时，等待消费者消费
        while (count==chickens.length) {
            try {
                this.wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        // 没有满，则放入产品
        chickens[count]=chicken;
        count++;
        
        // 通知消费者消费
        this.notifyAll();

    }

    // 消费者消费产品
    public synchronized Chicken pop() {
        // 判断能够消费
        while (count==0) {
            // 等待生产者生产
            try {
                this.wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        // 如果有剩，可以消费
        count--;
        Chicken chicken = chickens[count];

        // 通知生产者生产
        this.notifyAll();

        return chicken;
    }
}
```

:whale: 这里将原本的 if 判断改为了 while 判断：if 语句中醒来的线程 不会再一次进行判断了 而 while 会重新再判断；

:question: println 应该放在 pop 和 push 方法体里面，因为可能正要打印的时候，线程切换了，要保证增改操作和打印是一气呵成的（原子操作）



### 信号灯法

>  通过标志位判断

手能够在盘子上生产食物，口需要进食盘子上的食物。

```java
public class TestPC2 {
    public static void main(String[] args) {
        Dish dish = new Dish();
        new Hand(dish).start();
        new Mouth(dish).start();
    }
}

// 手——>生产食物
class Hand extends Thread {
    Dish dish;
    public Hand(Dish dish) {
        this.dish = dish;
    }

    @Override
    public void run() {
        for (int i = 0; i < 20; i++) {
            if (i%2==0) {
                this.dish.produce("红烧牛肉面");
            } else {
                this.dish.produce("咖喱鱼蛋");
            }
        }
    }
}

// 口——>吃食物
class Mouth extends Thread {
    Dish dish;
    public Mouth(Dish dish) {
        this.dish = dish;
    }
    @Override
    public void run() {
        for (int i = 0; i < 20; i++) {
            this.dish.eat();
        }
    }
}

class Dish {
    String food; // 食物
    boolean flag; // true: 吃食物 false: 生产食物

    // 生产食物
    public synchronized void produce(String food) {
        // 存在食物时不需要生产，生产了食物通知进食
        if (flag) {
            try {
                this.wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        System.out.println("生产了食物：" + food);
        // 通知口吃食物
        this.notifyAll();
        this.food = food;
        this.flag = !this.flag;
    }

    // 吃食物
    public synchronized void eat() {
        // 不存在食物时等待，进食了就通知生产
        if (!flag) {
            try {
                this.wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        System.out.println("吃掉了食物：" + food);
        // 通知手生产食物
        this.notifyAll();
        this.flag = !this.flag;
    }

}
```



## 线程池

背景：线程频繁创建和销毁，需要时间，且会对性能造成很大影响；

使用线程池，可以解决这个问题

**案例一**，见[下载网络图片](#实现-Callable接口)

**案例二**：

```java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class TestPool {
    public static void main(String[] args) {
        // 1.创建服务，指定线程池的大小
        ExecutorService ser = Executors.newFixedThreadPool(10);

        // 2.执行
        ser.execute(new MyThread());
        ser.execute(new MyThread());
        ser.execute(new MyThread());
        ser.execute(new MyThread());

        // 3. 关闭链接
        ser.shutdown();
    }
}

class MyThread implements Runnable {
    @Override
    public void run() {
        System.out.println(Thread.currentThread().getName());
    }
}
```













