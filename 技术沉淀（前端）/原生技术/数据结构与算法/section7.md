## 递归  
> 递归是一种解决问题的办法，它从解决问题的各小部分开始，知道解决最初的大问题。递归通常涉及函数调用自身。  



**递归函数** 是能够直接或间接调用自身的方法或函数。  
> 间接调用：调用一个会调用自身的函数。  



每个递归函数都必须有不再递归调用的条件（**基线条件**）。  

### 阶乘  
> 数 n 的阶乘，定义为 n！，表示从 1 到 n 的整数的乘积。其中 1 和 0 的阶乘都是 1。    

**迭代阶乘**  
```
function factorialIterative(number) {
    if (number < 0) return undefined;
    let total = 1;
    for (let n = number; n > 1; n--) {
        total = total * n;
    }
    return total;
}
```
**递归阶乘**  
```
function factorial(n) {
    if (n === 1 || n === 0) {
        return 1;
    }
    return n * factorial(n - 1);  // 递归调用
}
```

### 斐波那契数列  
> 由第2个 **位置** 开始，每个位置都可由前两个位置相加得到：0 1 1 2 3 4 8 13 21  

- 位置 0 的斐波那契数是 0。
- 1 和 2 的斐波那契数是 1。
- 对于大于 2 的 n 的斐波那契数是（n-1）和（n-2）的斐波那契数相加得到。  

**迭代求斐波那契数列**  
```
function fibonacciIterative(n) {
    if (n < 1) return 0;
    if (n <= 2) return 1;
    
    let fib2 = 0;
    let fib1 = 1;
    let fibN;
    for (let i = 2; i <= n; i++) {  // 由求第二个位置开始
        fibN = fib1 + fib2;
        fib2 = fib1;  // 新循环中，充当前前一项
        fib1 = fibN;  // 新循环中，充当前一项
    }
    return fibN;
}
```
**递归求斐波那契数列**  
```
function fibonacci(n) {
    if (n < 1) return 0;
    if (n <= 2) return 1;
    return fibonacci(n - 1) + fibonacci(n - 2);  // 递归调用
}
```
**记忆化斐波那契数**  
> 没搞懂。。。
```
function fibonacciMemoization(n) {
    const memo = [0,1];
    const fibonacci = (n) => {
        if (memo[n] != null) {
            return memo[n];
        }
        return memo[n] = fibonacci(n-1, memo) + fibonacci(n-2, memo);  // 第二个参数？
    };
    return fibonacci;
}
// 看不懂的调用
fibonacciMemoization()(6);
```

