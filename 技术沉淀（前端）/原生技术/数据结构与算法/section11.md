# 排序算法  

## 冒泡排序  
> **冒泡排序** 比较所有相邻的两个项，如果第一个比第二个大，则交换它们。  
> 
> 从运行时间的角度来看，冒泡排序是最差的一个。  

```
function bubbleSort(array, compareFn = defaultCompare) {
    const {length} = array;
    for (let i = 0; i < length; i++) {    // 轮数和数组长度一致
        for (let j = 0; j < length -1; j++) {  // 比较 length -1 次
            if (compareFn(array[j],array[j+1]) == 2) {
                swap(array, j , j+1);
            }
        }
    }
    return array;
}
```
需要用到的方法  
```
function defaultCompare(a,b) {
    if (a < b) {
        return '1';
    } else if (a > b) {
        return '2';
    }
}

function swap(array, a, b) {
    const temp = array[a];
    array[a] = array[b];
    array[b] = temp;
}
```

创建一个选定长度的倒序数组
> 跟这个算法没有直接关系，但说不定能用上呢
```
function createNonSortedArray(size) {
    const array = [];
    for (let i = size; i > 0; i--) {
        array.push(i);
    }
    return array;
}
```
**改进后的冒泡排序**  
> 由于第 n 轮将捋清倒数 n+1 个元素的关系。
> 
> 只需要从内循环减去外循环中跑过的次数，就可以避免内循环中所有不必要的比较。
```
function modifiedBubbleSort(array, compareFn = defaultCompare) {
    const {length} = array;
    for (let i = 0; i < length; i++) {
        for (let j = 0; j < length -1 - i; j++) {
            if (compareFn(array[j],array[j+1]) == 2) {
                swap(array, j , j+1);
            }
        }
    }
    return array;
}
```

## 选择排序  
> 选择排序是一种原址比较排序算法。思路是找到最小值放置在第一位，剩下的值里继续找最小值放在第二位，以此类推。  
```
function selectionSort(array, compareFn = defaultCompare) {
    const { length } = array;
    let indexMin;
    for (let i = 0; i < length - 1; i++) {  // 共进行 length - 1 轮，最后的位置不用
        indexMin = i;
        for (let j = i; j < length; j++) {  // 比较 length - i 位数
            if (compareFn(array[indexMin], array[j]) == 2) {
                indexMin = j;
            }
        }
        if (i !== indexMin) {  // 找出最小值后交换到 i 的位置
            swap(array, i, indexMin);
        }
    }
    return array;
};
```

## 插入排序  
> 与前一项比，如自己更小，换位（技术上，自己没换过去）  
> 重复**至**自己更大，插入（自己换过去），迭代。

```
function insertionSort(array, compareFn = defaultCompare) {
    const { length } = array;
    let temp;
    for (let i = 1; i < length; i++) {
        let j = i;
        temp = array[i];
        while (j > 0 && compareFn(array[j - 1], temp) == 2) {
            array[j] = array[j - 1];
            j--;
        }
        array[j] = temp;
    }
    return array;
};
```

## 归并排序  
> 归并排序是一种分而治之算法。先将原始数组切分为较小数组，直到每个小数组只有一个位置，接着将小数组归并成较大的数组。  

**第一部分**  
> 先将一个大数组分为多个小数组并调用辅助函数。  
> 
> 对于数组长度为 1 的数组，直接返回。  
```
function mergeSort(array, compareFn = defaultCompare) {
    if (array.length > 1) {
        const { length } = array;
        const middle = Math.floor(length / 2);
        const left = mergeSort(array.slice(0, middle), compareFn);
        const right = mergeSort(array.slice(middle,length),compareFn);
        array = merge(left, right, compareFn);
    }
    return array;
}
```   
**第二部分**  
> 负责合并和排序小数组来产生大数组。  
> 
> ① 添加的剩余部分比 result 中的元素都要大，且已经排好了序（因为是从底层排起）。
```
function merge(left, right, compareFn) {
    let i = 0;
    let j = 0;
    const result = [];
    while(i < left.length && j < right.length) {   // 直至 left 或 right 遍历完
        result.push(
            compareFn(left[i], right[i]) == 1 ? left[i++] : right[j++]
        );
    }
    return result.concat(i < left.length ? left.slice(i) : right.slice(j));  // ①
}
```

## 快速排序  
> 快速排序也使用分而治之的方法，将原始数组分为较小的数组（但不是归并排序那样真正的分割，而是通过控制指针范围来控制调整范围）。

主方法  
```
function quickSort(array, compareFn = defaultCompare) {
    return quick(array, 0, array.length - 1, compareFn);
};
```

**划分两半**  
> 一半是比主元小的值，一半是比主元大的值，主元只会出现在其中的一半。  
> 
> 将依据划分条件（ index ），继续划分，对于被划分到 **可操作的** 长度为 1 的部分，将不进行任何操作（过不了下面两个 if 条件）。
```
function quick(array, left, right, compareFn) {
    let index;
    if (array.length > 1) {  //  第一次调用时，筛选
        index = partition(array, left, right, compareFn);
        if (left < index - 1) {
            quick(array, left, index - 1, compareFn);  // 处理完，再往下
        }
        if (index < right) {
            quick(array, index, right, compareFn);
        }
    }
    return array;
};
```

**划分过程**   
> 将操作数组并返回下一次的划分依据。  
```
function partition(array, left, right, compareFn) {
    const pivot = array[Math.floor((right + left) / 2)];  // 选择中间值作为主元
    let i = left;
    let j = right;
    
    while (i <= j) {
        while (compareFn(array[i], pivot) == 1) {  // 直到大于等于主元
            i++;
        }
        while (compareFn(array[j], pivot) == 2) {  // 直到小于等于主元
            j--;
        }
        if (i <= j) {  // 若此时...，才交换i、j 位置的值并移动指针
            swap(array, i, j);
            i++;
            j--;
        }
    }
    return i;  // 将赋值到 index
}
```

# 搜索算法  

## 顺序搜索  
> **顺序** 或 **线性搜索** 是最基本的搜索算法。它的机制是，将每一个数据结构中的元素和我们要找的元素作比较。   
```
function sequentialSearch(array, value, equalsFn = defaultEquals) {
    for (let i = 0; i < array.length; i++) {
        if (equalsFn(value, array[i])) {
            return i;  // 将返回索引，也可以返回其他的
        }
    }
    return false;
}

function defaultEquals(a,b) {
    return a === b;
}
```

## 二分搜索  
> 要求被搜索的数据结构已排序。
> 
> 选择数组的中间值，如果待搜索值比选中值要小，在左边的子数组中寻找中间值。  
```
function binarySearch(array, value, compareFn = defaultCompare) {
    const sortedArray = quickSort(array);  // 需要先排序
    let low = 0;
    let high = sortedArray.length - 1;
    while (lesserOrEquals(low, high, compareFn)) {
        const mid = Math.floor((low + high) / 2);
        const element = sortedArray[mid];
        if (compareFn(element, value) == 1) {
            low = mid + 1;   // 子数组的 [
        } else if (compareFn(element, value) == 2) {
            high = mid - 1;  // 子数组 ]
        } else {
            return mid;
        }
    }
    return false;
}
```

**判断是否需要继续比较**  
> 当子数组数量大于等于 1 时，都会返回 true；  
> 否则即 low > high，意味着最后一个值已经比较完成且不为搜索值，将返回 false
```
function lesserOrEquals(a, b, compareFn) {
    const comp = compareFn(a, b);
    return comp == 1 || comp == 3;
}

function defaultCompare(a,b) {
    if (a < b) {
        return '1';
    } else if (a > b) {
        return '2';
    } else if (a = b) {
        return '3';
    }
}
```

## 内插搜索  
> 是改良版的二分搜索，每次进行对比的的不一定是中间值。
> 
> 当数组中的值均匀分布时，性能最好，否则，运算次数可能比二分搜索还多。  
```
function interpolationSearch(array, value, compareFn = defaultCompare, equalsFn =defaultEquals, diffFn = defaultDiff) {
    const sortedArray = quickSort(array);  // 需要先排序
    const { length } = array;
    let low = 0;
    let high = length - 1;
    let positon = -1;
    let delta = -1;
    while (
        low <= high &&
        biggerOrEquals(value, array[low], compareFn) &&
        lesserOrEquals(value, array[high], compareFn) 
    ) {
        delta = diffFn(value, array[low]) / diffFn(array[high], array[low]);
        position = low + Math.floor((high - low) * delta);
        if (equalsFn(array[position], value)) {
            return position;
        }
        if (compareFn(array[position], value) == 1){
            low = position + 1;
        } else {
            high = position - 1;
        }
    }
    return false;
}
```  
**判断是否继续比较**  
```
// 需要 value 小于等于 [high]
function lesserOrEquals(a, b, compareFn) {
    const comp = compareFn(a,b);
    return comp == 1 || comp == 3;
}

function biggerOrEquals(a, b, compareFn) {
    const comp = compareFn(a,b);
    return comp == 2 || comp == 3;
}

// 求差值
function defaultDiff(a,b) {
    return a - b;
}
```

## Fisher - Yates 随机  
> 迭代数组，从最后一位开始并将当前位置和一个随机位置进行交换。这个随机位置小于等于当前位置。  
```
function shuffle(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const randomIndex = Math.floor(Math.random() * (i + 1));  // 将会是 [0,i] 中的随机值
        swap(array, i, randomIndex);
    }
    return array;
}
```





