## 二叉搜索树   
> 二叉树的节点最多只能有两个子节点。  
> 二叉搜索树（BST）是二叉树的一种，但只允许在左侧节点存储（比父节点）小的值，在右侧节点存储（比父节点）大的值。  

### 创建 BinarySearchTree 类  


基本结构  
> 将声明一个变量以控制此数据结构的第一个节点。  
```
class BinarySearchTree {
    constructor(compareFn = defaultCompare) {
        this.compareFn = compareFn;
        this.root = null;
    }
}
```  

表示每个节点  
```
class Node {
    constructor(key) {
        this.key = key;
        this.left = null;
        this.right = null;
    }
}
```  

比较函数   
```
function defaultCompare(a,b) {
    if (a < b) {
        return '1';
    } else if (a > b) {
        return '2';
    }
}
```  

**向二叉搜索树插入一个键**  
```
insert(key) {
    if (this.root == null) {
        this.root = new Node(key);
    } else {
        this.insertNode(this.root,key);
    }
}

// 参数：当前进行比较的父节点，需要插入的子节点。
insertNode(node, key) {
    if (this.compareFn(key, node.key) == '1') {
        if (node.left == null) {
            node.left = new Node(key);
        } else {
            this.insertNode(node.left, key);
        }
    } else if (this.compareFn(key, node.key) == '2') {
        if (node.right == null) {
            node.right = new Node(key);
        } else {
            this.insertNode(node.right, key);
        }
    }
    return false;
}
```   

### 树的遍历  

**中序遍历（左中右）**  
> 以从最小到最大的顺序访问所有节点。    
```
inOrderTraverse(callback) {
    this.inOrderTraverseNode(this.root, callback);
}

inOrderTraverseNode(node, callback) {
    if (node != null) {
        this.inOrderTraverseNode(node.left,callback);
        callback(node.key);
        this.inOrderTraverseNode(node.right,callback);
    }
}
```  
> 方法接受一个**回调函数**作为参数，回调函数的参数在调用中已经给出。
> ```
> const y = (n) => document.write(n);
> x.inOrderTraverse(y);
> ```  

**先序遍历（中左右）**   
```
preOrderTraverse(callback) {
    this.preOrderTraverseNode(this.root, callback);
}

preOrderTraverseNode(node, callback) {
    if (node != null) {
        callback(node.key);
        this.preOrderTraverseNode(node.left,callback);
        this.preOrderTraverseNode(node.right,callback);
    }
}
```  
**后序遍历（左右中）**   
```
postOrderTraverse(callback) {
    this.postOrderTraverseNode(this.root, callback);
}
postOrderTraverseNode(node, callback) {
    if (node != null) {
        this.postOrderTraverseNode(node.left,callback);
        this.postOrderTraverseNode(node.right,callback);
        callback(node.key);
    }
}
```  

### 搜索树中的值  

**搜索最小值**  
> 最左侧的节点即这棵树中最小的键。
```
min() {
    return this.minNode(this.root);
}

// 我们可以使用它来找到一棵树或其子树中最小的键。
minNode(node) {
    let current = node;
    while (current != null && current.left != null) {
        current = current.left;
    }
    return current;
}
```  
**搜索最大值**  
```
max() {
    return this.maxNode(this.root);
}
maxNode(node) {
    let current = node;
    while (current != null && current.right != null) {
        current = current.right;
    }
    return current;
}
```  
**搜索一个特定的值**  
```
search(key) {
    return this.searchNode(this.root, key);
}

// 第一个参数为当前比较的父节点。
searchNode(node, key) {
    if (node == null) {
        return false;
    }
    if (this.compareFn(key, node.key) == '1') {
        return this.searchNode(node.left, key);
    } else if (this.compareFn(key, node.key) == '2') {
        return this.searchNode(node.right, key);
    } else {
        return true;
    }
}  
```  

### 移除一个节点  
```
remove(key) {
    this.root = this.removeNode(this.root, key);
}

removeNode(node, key) {
    if (node == null) {
        return null;
    }
    if (this.compareFn(key, node.key) == '1') {
        node.left = this.removeNode(node.left, key);
        return node;
    } else if (
            this.compareFn(key, node.key) == '2'
        ) {
        node.right = this.removeNode(node.right, key);
        return node;
    } else {
        // 键等于 node.key
        // 第一种情况：移除一个叶节点
        if (node.left == null && node.right == null) {
            node = null;
            return node;
        }
        // 第二种情况：带一个子节点
        if (node.left == null) {
            node = node.right;
            return node;
        } else if (node.right == null) {
            node = node.left;
            return node;
        }
        // 第三种情况：带两个子节点
        const aux = this.minNode(node.right);
        node.key = aux.key;
        node.right = this.removeNode(node.right, aux.key);
        return node;
    }
}
```

## 自平衡树  
> AVL 树是一种自平衡二叉搜索树，任何一个节点左右两侧子树的高度只差最多为 1 。
> 
> 添加或移除节点时，AVL 树会尝试保持自平衡。  

骨架  
```
class AVLTree extends BinarySearchTree {
    constructor (compareFn = defaultCompare) {
        super(compareFn);
        this.compareFn = compareFn;
        this.root = null;
    }
}
```  

**节点的高度**  
> 用于计算平衡因子，叶节点的高度为 0。  
```
getNodeHeight(node) {
    if (node == null) {  // 叶子节点下的“虚空”节点的高度
        return -1;
    }
    return Math.max(
       this.getNodeHeight(node.left),this.getNodeHeight(node.right)
       ) + 1;  // 实际高度 = （左/右）测子树的较高值 + 1
}
```

**平衡因子**  
> 值：右子树高度-左子树高度，结果若不为-1、0、1，则需平衡该 AVL 树。
```
getBalanceFactor(node) {
    const heightDifference = this.getNodeHeight(node.left) - 
this.getNodeHeight(node.right);
    switch (heightDifference) {
        case -2:
            return BalanceFactor.UNBALANCED_RIGHT;
        case -1:
            return BalanceFactor.SLIGHTLY_UNBALANCED_RIGHT;
        case 1:
            return BalanceFactor.SLIGHTLY_UNBALANCED_LEFT;
        case 2:
            return BalanceFactor.UNBALANCED_LEFT;
        default:
            return BalanceFactor.BALANCED;
    }
}
```
**作为计数器的 Javascript 常量**  
> 作用是为了避免直接在代码中处理平衡因子的数值。。需要添加到类外。  
```
const BalanceFactor = {
    UNBALANCED_RIGHT: 1,
    SLIGHTLY_UNBALANCED_RIGHT: 2,
    BALANCED: 3,
    SLIGHTLY_UNBALANCED_LEFT: 4,
    UNBALANCED_LEFT: 5
}; 
```  

### 平衡操作—— AVL旋转  
> 在对 AVL 树添加或移除节点后，若不平衡，可以执行旋转的平衡操作。  

**左-左（LL）**  
> 向右的单旋转。节点的左侧子节点的高度大于右侧子节点的高度，且左侧子节点也是平衡或左侧较重。  
> 
> 左侧子节点成为中，保留它的左子节点，将它的右子节点送到原中的左子节点，再将原中送到它的右子节点。  
```
rotationLL(node) {
    const tmp = node.left;
    node.left = tmp.right;
    tmp.right = node;
    return tmp;
}
```  
**右-右（RR）**  
```
rotationRR(node) {
    const tmp = node.right;
    node.right = tmp.left;
    tmp.left = node;
    return tmp;
}
```
**左-右（LR）**  
>  向右的双旋转。节点的左侧子节点的高度大于右侧子节点的高度，且左侧子节点右侧较重。  
> 
> 先对节点的左侧子节点向左旋转，再自身右旋转。  
```
rotationLR(node) {
    node.left = this.rotationRR(node.left);
    return this.rotationLL(node);
}
```  
**右-左（RL）**   
```
rotationRL(node) {
    node.right = this.rotationLL(node.right);
    return this.rotationRR(node);
}
```
**向 AVL 树插入节点**  
```
insert(key) {
    this.root = this.insertNode(this.root, key);
}
    
insertNode(node, key) {
    // 像在BST树中一样插入节点
    if (node == null) {
        return new Node(key);
    } else if (this.compareFn(key, node.key) == 1) {
        node.left = this.insertNode(node.left, key);
    } else if (this.compareFn(key, node.key) == 2) {
        node.right = this.insertNode(node.right, key);
    } else {
        return node;
    }
    // 如果需要，将对树进行平衡操作
    const balanceFactor = this.getBalanceFactor(node);
    if (balanceFactor === BalanceFactor.UNBALANCED_LEFT) {
        if (this.compareFn(key, node.left.key) == 1) {
            node = this.rotationLL(node);
        } else {
            return this.rotationLR(node);
        }
    }
    if (balanceFactor === BalanceFactor.UNBALANCED_RIGHT) {
        if (this.compareFn(key, node.left.key) == 2) {
            node = this.rotationRR(node);
        } else {
            return this.rotationRL(node);
        }
    }
    return node;
}
```  

**从 AVL 树中移除节点**  
```
remove(key) {
    this.root = this.removeNode(this.root, key);
}
    
removeNode(node, key) {
    node = super.removeNode(node,key);
    if (node == null) {
        return node; //null,不需要平衡
    }
    // 如果需要，将树进行平衡操作
    const balanceFactor = this.getBalanceFactor(node);
    if (balanceFactor === BalanceFactor.UNBALANCED_LEFT) {
        const balanceFactorLeft = this.getBalanceFactor(node.left);
        if  (
            balanceFactorLeft === BalanceFactor.BALANCED || 
            balanceFactorLeft === BalanceFactor.SLIGHTLY_UNBALANCED_LEFT
        ) {
            return this.rotationLL(node);
        }
        if (
            balanceFactorLeft === BalanceFactor.SLIGHTLY_UNBALANCED_RIGHT
        ) {
            return this.rotationLR(node);
        }
    }//
    if (balanceFactor === BalanceFactor.UNBALANCED_RIGHT) {
        const balanceFactorRight = this.getBalanceFactor(node.right);
        if  (
            balanceFactorRight === BalanceFactor.BALANCED || 
            balanceFactorRight === BalanceFactor.SLIGHTLY_UNBALANCED_RIGHT
        ) {
            return this.rotationRR(node);
        }
        if (
            balanceFactorRight === BalanceFactor.SLIGHTLY_UNBALANCED_LEFT
        ) {
            return this.rotationRL(node);
        }
    }
    return node;
}
```  

## 红黑树  
> 和 AVL 树一样，**红黑树**也是一个自平衡二叉搜索树。  

选择自平衡树：  
- 红黑树：需要多次插入和删除。
- AVL 树：插入和删除频率较低（更需要多次进行搜索操作）。

**红黑树的节点规则**  
1. 节点要么是黑，要么是红；
2. 树的**根节点**是**黑**的；
3. 所有叶节点都是黑的 （用 NULL 引用表示的节点）；
4. 如果一个节点是红的，那么它的两个子节点只能是黑的；
5. 不能有两个相邻的红节点，一个红节点不能有红的父节点或子节点；
6. 从给定的节点到它的后代节点（NULL 叶节点）的所有路径包含**相同数量的黑色节点**。  

**骨架**  
```
class RedBlackTree extends BinarySearchTree {
    constructor(compareFn = defaultCompare) {
        super(compareFn);
        this.compareFn = compareFn;
        this.root = null;
    }
}
```  

### 向红黑树中插入节点  
> 插入节点并应用后，还要验证树的颜色是否符合规则，及是否自平衡。  
```
insert(key) {
    if (this.root == null) {
        this.root = new RedBlackNode(key);
        this.root.color = Colors.BLACK;
    } else {
        const newNode = this.insertNode(this.root, key);
        this.fixTreeProperties(newNode);
    }
}
    
// 会返回被添加节点的引用，以方便后面的验证。
insertNode(node, key) {
    if (this.compareFn(key, node.key) == '1') {
        if (node.left == null) {
            node.left = new RedBlackNode(key);
            node.left.parent = node;
            return node.left;
        } else {
            return this.insertNode(node.left, key);
        }
    } else if (node.right == null) {
        node.right = new RedBlackNode(key);
        node.right.parent = node;
        return node.right;
    } else { 
        return this.insertNode(node.right, key);
    }
}
```  
**拓展属性后的 Node**  
> 插入的节点将会是红色，这样避免了与规则 6 冲突，使后续的操作简单化。
```
class RedBlackNode extends Node {
    constructor(key) {
        super(key);
        this.key = key;
        this.color = Colors.RED;
        this.parent = null;
    }
}
```

**在插入节点后验证红黑树的属性**  
> 从“底层”开始解决，再一层层检查树看有无冲突。  
```
fixTreeProperties(node) {
    while (node && node.parent && node.parent.color === Colors.RED && node.color !== Colors.BLACK) {
        let parent = node.parent;
        const grandParent = parent.parent;
        // 情景A：父节点是左侧子节点
        if (grandParent && grandParent.left === parent) {
            const uncle = grandParent.right;
            // 情景A1：叔节点也是红色——只需要重新填色
            if (uncle && uncle.color === Colors.RED) {
                grandParent.color = Colors.RED;
                parent.color = Colors.BLACK;
                uncle.color = Colors.BLACK;
                node = grandParent;
            } else {
                // 情形A2：节点是右侧子节点——左旋转
                if (node === parent.right) {
                    this.rotationRR(parent);
                    node = parent;  // 指向 parent
                    parent = node.parent; // 指向 node
                }
                // 情形A3：节点是左侧子节点——右旋转
                this.rotationLL(grandParent);
                parent.color = Colors.Black;
                grandParent.color = Colors.RED;
                node = parent;
            }
        } else { // 情形B：父节点是右侧子节点
            const uncle = grandParent.left;
            // 情形B1：叔节点也是红色——只需要重新填色
            if (uncle && uncle.color === Colors.RED) {
                grandParent.color = Colors.RED;
                parent.color = Colors.BLACK;
                uncle.color = Colors.BLACK;
                node = grandParent;
            } else {
                // 情形B2：节点是左侧子节点——右旋转
                if (node === parent.left) {
                    this.rotationLL(parent);
                    node = parent;
                    parent = node.parent;
                } 
                // 情形B3：节点是右侧子节点——左旋转
                this.rotationRR(grandParent);
                parent.color = Colors.BLACK;
                grandParent.color = Colors.RED;
                node = parent;
            }
        }
    }
    this.root.color = Colors.BLACK;
}
```

**红黑树旋转**  
> 旋转的逻辑与 AVL 树一样，但由于保存了父节点的引用，需要将引用更新为旋转后的新父节点。  
```
rotationLL(node) {
    const tmp = node.left;
    node.left = tmp.right;
    if (tmp.right && tmp.right.key) {
        tmp.right.parent = node;
    }
    tmp.parent = node.parent;
    if (!node.parent) {
        this.root = tmp;
    }
    else {
        if (node === node.parent.left) {
            node.parent.left = tmp;
        } else {
            node.parent.right = tmp;
        }
    }
    tmp.right = node;
    node.parent = tmp;
}

rotationRR(node) {
    const tmp = node.right;
    node.right = tmp.left;
    if (tmp.left && tmp.left.key) {
        tmp.left.parent = node;
    }
    tmp.parent = node.parent;
    if (!node.parent) {
        this.root = tmp;
    }
    else {
        if (node === node.parent.left) {
            node.parent.left = tmp;
        } else {
            node.parent.right = tmp;
        }
    }
    tmp.left = node;
    node.parent = tmp;
}
```

**补充：Colors 对象**  
> 不补充的话，原代码我理解不了: `Colors.RED` ，实际调试也会出错。  
```
const Colors = {
    RED:'RED',
    BLACK:'BLACK'
}
```









