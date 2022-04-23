# 算法设计与技巧  

## 二分搜索————分而治之
```
function binarySearch(array, value, compareFn = defaultCompare) {
    const sortedArray = quickSort(array);    // 先排序
    const low = 0;
    const high = sortedArray.length - 1;
    
    return binarySearchRecursive(array, value, low, high, compareFn);
}

function binarySearchRecursive(array, value, low, high, compareFn = defaultCompare) {
    if (low <= high) {  // 基线条件
        const mid = Math.floor((low + high) / 2);
        const element = array[mid];
        
        if(compareFn(element, value) == 1) {
            return binarySearchRecursive(array, value, mid + 1, high, compareFn);
        } else if (compareFn(element, value) == 2) {
            return binarySearchRecursive(array, value, low, mid - 1, compareFn);
        } else {
            return mid;
        }
    }
    return false;
}
```

## 最少硬币找零问题————动态规划  
> 总额 = 第一张纸币（用 for 遍历所有种类） + 剩余总额  
> 
> 需将面额数组以正序排列，最后一个输出结果即所求解。  
> tip: 将 ④ 删去，并将面额数组以倒序排列，可得所有找零结果。  
```
function minCoinChange(coins, amount) {  // 面额数组，找零的总额
    const cache = [];
    const makeChange = (value) => {  // 函数声明
        if (!value) {
            return [];
        }
        if (cache[value]) {    
            return cache[value];
        }
        let min = [];
        let newMin;
        let newAmount;
        for (let i = 0; i < coins.length; i++) {
            const coin = coins[i];
            newAmount = value - coin;
            if (newAmount >= 0) {
                newMin = makeChange(newAmount);
            }
            if (
              newAmount >= 0 &&
              (newMin.length + 1 < min.length || !min.length) &&  // ④
              (newMin.length || !newAmount)
            ) {
                min = [coin].concat(newMin);
                console.log('new Min' + min + ' for ' + value);
            }
        }
        return (cache[value] = min);
    };
    return makeChange(amount);  // 执行函数
}
```  
> ① value 为本轮需要凑到的总额；  
> ② netAmount 则是为了达成 ① 所需凑到的总额（新目标）；  
> ③ coin 为本次( for )使用的零钱。 

## 背包问题————动态规划    
> 给定一个能携带重量 W 的背包，以及一组有价值和重量的物品，找出一个最佳解决方案，使得装入背包的物品总重量不超过 W 的同时总价值最大。  
> 
> 动态规划只能解决 0-1 版本，即每种物品只有一个。  
```
function knapSack(capacity, weights, value, n) {
    const kS = [];
    for (let i = 0; i <= n; i++) {
        kS[i] = [];
    }
    
    for (let i = 0; i <= n; i++) {
        for (let w = 0; w <= capacity; w++) {
            if (i === 0 || w === 0) {
                kS[i][w] = 0;
            } else if (weights[i - 1] <= w) {
                const a = values[i -1] + kS[i -1][w - weights[i -1 ]];
                const b = kS[i - 1][w];
                kS[i][w] = a > b ? a : b;
            } else {
                kS[i][w] = kS[i - 1][w];
            }
        }
    }
    findValues(n, capacity, kS, weights, values);
    console.log(`总价值:  ${kS[n][capacity]}`);
}

// 列出实际物品
function findValues(n, capacity, kS, weights, values) {
    let i = n;
    let k = capacity;
    console.log('构成解的物品： ');
    while (i > 0 && k > 0) {
        if (kS[i][k] !== kS[i - 1][k]) {  // 判断物品 i 有没有加入方案
            console.log(`物品 ${i} 可以是解的一部分 w,v: ${weights[i - 1]}, ${values[i - 1]}`);
            i--;
            k -= weights[i - 1];  // 剩余重量
        } else {
            i--;
        }
    }
}
```
**举个栗子**  
> 对应重量和价值的参数要以数组形式传入。
```
const values = [3,4,5],
      weights = [2,3,4],
      capacity = 5,
      n = values.length;
knapSack(capacity, weights, values, n);
```

## 最少硬币找零问题————贪心算法  
> 贪心算法期盼通过每个阶段的局部最优选择，从而达到全局的最优。  
> 
> 从最大面额的硬币开始，拿尽可能多的这种硬币找零。当无法再拿更多这种价值的硬币时，开始拿第二大价值的硬币，依次继续。  
```
function minCoinChange(coins, amount) {
    const change = [];
    let total = 0;
    for (let i = coins.length - 1; i >= 0; i--) {
        const coin = coins[i];
        while (total + coin <= amount) {
            document.write(coin); //
            change.push(coin);
            total += coin;
        }
    }
    return change;
}
```
> 虽然比起 DP 方法，它更快更简单，但它并不总是能得到最优答案，甚至可能凑不满（如用 \[2, 3, 4] 面额凑总额 5 ）  

## 分数背包问题————贪心算法  
> 每种物品至多 1 件，且可以以百分比取。  
> 
> 输入的物品顺序，需要性价比为降序进行排序，否则将得出错误的解。    
```
function knapSack(capacity, weights, values) {
    const n = values.length;
    let load = 0;    // 已用重量
    let val = 0;     // 已有价值
    for (let i = 0; i < n && load < capacity; i++) {
        if (weights[i] + load <= capacity) {
            val += values[i];
            load += weights[i];
        } else {
            const r = (capacity - load) / weights[i];
            val += r * values[i];
            load += weights[i];
        }
    }
    return val;
}
```

## 迷宫老鼠问题————回溯算法  
> 我们从一个可能的动作开始并试着用这个动作解决问题。如果不能解决，就回溯选择另一个动作直到问题解决。  
>   
> 迷宫为一个大小为 N\*N 的矩阵，1 代表通道，0 代表墙壁。  
> 老鼠只可以向左或向下移动，需要从 \[0,0] 移动至 \[n-1]\[n-1]。  
   
**建立答案模板**  
> 创建初始矩阵，将每个位置初始化为零。  
```
function ratInAMaze(maze) {
    const solution = [];
    for (let i = 0; i < maze.length; i++) {
        solution[i] = [];
        for (let j = 0; j < maze[i].length; j++) {  
            solution[i][j] = 0;
        }
    }
    if (findPath(maze, 0, 0, solution) === true) {
        return solution;
    }
    return 'NO PATH FOUND';
}
```  
**找路部分**  
> 对于 ①，由于使用了递归，哪怕在一条错误解上走出了很久，也能将 false 返回上去，使错解（分岔路部分）变回 0。  
```
function findPath(maze, x, y, solution) {
    const n = maze.length;
    
    if (x === n - 1 && y === n - 1) {  // 终点
         solution[x][y] = 1;
         return true;
    }
    
    if (isSafe(maze, x, y) === true) {
        solution[x][y] = 1;
        if (findPath(maze, x + 1, y, solution)) {
            return true;
        }
        
        if (findPath(maze, x, y + 1, solution)) {
            return true;
        }
        
        solution[x][y] = 0;  // ①
        return false;
    }
    return false;
}

// 判断是否为通道
function isSafe(maze, x, y) {
    const n = maze.length;
    if (x >= 0 && y >= 0 && x < n && y < n && maze[x][y] !== 0) {
        return true;
    }
    return false;
}
```
举个栗子
```
const maze = [
    [1, 0, 0, 0],
    [1, 1, 1, 1],
    [0, 0, 1, 0],
    [0, 1, 1, 1]
];

console.log(ratInAMaze(maze));

    // 结果将是  
    [1, 0, 0, 0],
    [1, 1, 1, 0],
    [0, 0, 1, 0],
    [0, 0, 1, 1]
```

## 数独解题器————回溯算法  
> 目标是用数字 1 ~ 9 填满一个 9 × 9 的矩阵，要求每行每列，以及每个 3 × 3 小矩阵中数字不重复。  
```
function sudokuSolver(matrix) {
    if (solveSudoku(matrix) === true) {
        return matrix;
    }
    return '问题无解！';
}
```  
**填格子部分**  
> ① 之前的部分，将在取到最近的一个空值后（如果有）退出。  
> 
> ② 赋值给当前控制后，检查这种填写有无正解可能，如果没有，进入 for 循环赋其他值，还是没有，则返回 false 到上一步填写。  
```
const UNASSIGNED = 0;

function solveSudoku(matrix) {
    let row = 0;
    let col = 0;
    let checkBlankSpaces = false;
    for (row = 0; row < matrix.length; row++) {
        for (col = 0; col < matrix[row].length; col++) {
            if (matrix[row][col] === UNASSIGNED) {
                checkBlankSpaces = true;
                break;
            }
        }
        if (checkBlankSpaces === true) {
            break;
        }
    }
    if (checkBlankSpaces === false) {
        return true;
    }    // ①
    for (let num = 1; num <= 9; num++) {
        if (isSafe(matrix, row, col, num)) {
            matrix[row][col] = num;
            if (solveSudoku(matrix)) {    // ②
                return true;
            }
            matrix[row][col] = UNASSIGNED;
        }
    }
    return false;
}
```  
**判断填入值是否合理**  
```
function isSafe(matrix, row, col, num) {
    return (
        !usedInRow(matrix, row, num) &&
        !usedInCol(matrix, col, num) &&
        !usedInBox(matrix, row - (row % 3), col - (col % 3), num)  // 返回所处小矩阵的左上角。
    );
}

function usedInRow(matrix, row, num) {
    for (let col = 0; col < matrix.length; col++) {
        if (matrix[row][col] === num) {      // 检查所在行有无相同数字
            return true;
        }
    }
    return false;
}

function usedInCol(matrix, col, num) {
    for (let row = 0; row < matrix.length; row++) {
        if (matrix[row][col] === num) {
            return true;
        }
    }
    return false;
}        
     
function usedInBox(matrix, boxStartRow, boxStartCol, num) {
    for (let row = 0; row < 3; row++) {
        for (let col = 0; col < 3; col++) {
            if (matrix[row + boxStartRow][col + boxStartCol] === num) {
                return true;
            }
        }
    }
    return false;
}
```  
举个栗子  
```
const x = [
    [5,3,0,0,7,0,0,0,0],
    [6,0,0,1,9,5,0,0,0],
    [0,9,8,0,0,0,0,6,0],
    [8,0,0,0,6,0,0,0,3],
    [4,0,0,8,0,3,0,0,1],
    [7,0,0,0,2,0,0,0,6],
    [0,6,0,0,0,0,2,8,0],
    [0,0,0,4,1,9,0,0,5],
    [0,0,0,0,8,0,0,7,9]
];
```





