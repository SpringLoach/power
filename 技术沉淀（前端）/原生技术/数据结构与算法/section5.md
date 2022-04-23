# 集合  
> 集合是一组无序且**唯一**（即不能重复）的项组成的。
> 
> 实际操作中，当属性为整数时，有[自动排序的现象](https://blog.csdn.net/ccnacyq/article/details/109172104)？  

**创建集合类**  
> JavaScript 的对象不允许一个键指向两个不同的属性，也保证了集合里的元素都是唯一的。  
```
class Set {
    constructor() {
        this.items = {};
    } 
} 
```  
**检查某元素是否存在**  
```
has(element) {
    return Object.prototype.hasOwnProperty.call(this.items,element);
}
```  
**向集合添加一个新元素**  
> 如果属性值已存在，不操作。  
```
add(element) {
    if (!this.has(element)) {             
        this.items[element] = element;    // 同时作为键和值保存
        return true;
    }
    return false;
}
```  
**从集合移除一个元素**  
```
delete(element) {
    if (this.has(element)) {
        delete this.items[element];
        return true;
    }
    return false;
}
```  
**清空集合**  
```
clear() {
    this.items = {};
}
```  
**返回集合中有多少元素**  
> `for-in` 语句将迭代 items对象的所有属性，包括对象的原型所包含的额外属性。  
```
size() {
    let count = 0;
    for(let key in this.items) {    
         if(this.items.hasOwnProperty(key)) {    // 检查他们是否是对象自身的属性。
            count++;
        }
    }
    return count;
}
```   
**返回一个包含集合中所有值（元素）的数组**  
```
values() {
     let values = [];
     for(let key in this.items) {
         if(this.items.hasOwnProperty(key)) {
             values.push(key);
         }
     }
     return values;
}
```

## 集合运算  
> 在计算机科学中的主要应用之一是数据库。  

**并集**  
> 对于给定的两个集合，返回一个 **包含两个集合中所有元素** 的新集合。  
```
union(otherSet) {
    const unionSet = new Set();
    this.values().forEach(value => unionSet.add(value));    // value 参数在这个数组方法中代表每个数组元素。
    otherSet.values().forEach(value => unionSet.add(value));    
    return unionSet;
}
```  
**交集**  
> 对于给定的两个集合，返回一个包含两个集合中 **共有元素** 的新集合。  
> 
> 更少的迭代次数意味着更少的过程消耗。
```
intersection(otherSet) {
    const intersectionSet = new Set();
    const values = this.values();
    const otherValues = otherSet.values();
    let biggerSet = values;
    let smallerSet = otherValues;
    if (otherValues.length - values.length > 0) {
        biggerSet = otherValues;
        smallerSet = values;
    }                                      // 找到较小的数组，用于迭代
    smallerSet.forEach(value => {
        if (biggerSet.includes(value)) { 
            intersectionSet.add(value);
        }
    });
    return intersectionSet;
}
```  
**差集**  
> 对于给定的两个集合，返回一个包含所有存在于第一个集合且不存在于第二个集合的元素的新集合。（我有的，你没有的部分）  
```
difference(otherSet) {
    const differenceSet = new Set();
    this.values().forEach(value => {
        if(!otherSet.has(value)) {
            differenceSet.add(value);  // 因为不想修改原集合，故不用 delete()
        }
    });
    return differenceSet;
}
```  
**子集**  
> 验证一个给定集合是否是另一个集合的子集。  
```
isSubsetOf (otherSet) {
    if (this.size() > otherSet.size()) {
        return false;
    }
    let isSubset = true;
    this.values().every(values => {
        if (!otherSet.has(values)) {
            isSubset = false;
            return false;    // return 的布尔值用于判断是否该继续调用every()方法。
        }
        return true;
    });
    return isSubset;
}
```

## ES 2015————Set 类  
> ECMAScript2015 新增了 Set 类作为 JavaScript API 的一部分。
> 
> 和之前构造的 Set 不同：values 方法将返回 Iterator。  
> 而 size 变成了一个属性。  


### 使用扩展运算符   
- 将集合转化为数组；  
- 执行运算；  
- 将结果转化回集合。  

**并集**  
> 其中x，z为需要合并的集合。
```
console.log(new Set([...x,...z]));  
```  
**交集**  
> filter方法将数组的每一个元素放入到函数中执行，将返回 true 的项 **组成为新数组**。
```
console.log(new Set([...x].filter(a => z.has(a)))); 
```  
**差集**  
```
console.log(new Set([...x].filter(a => !z.has(a))));
```
