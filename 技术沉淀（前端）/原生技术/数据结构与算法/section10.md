# 图  
> 图是一组由**边**连接的**节点**（或**顶点**）。  

## 邻接表  
> 可以使用一种叫做邻接表的动态数据结构来表示图。邻接表由图中每个顶点的相邻顶点列表所组成。   
> ![邻接表](邻接表.jpg)  

**声明骨架**  
> 默认为无向图。  
```
class Graph {
    constructor(isDirected = false) {
        this.isDirected = isDirected;
        this.vertices = [];  // 顶点列表 
        this.adjList = new Dictionary();  // 储存邻接表
    }
}
```

**添加一个新的顶点**  
> 添加到顶点列表，并在字典中新增一项。  
```
addVertex(v) {
    if (!this.vertices.includes(v)) {
        this.vertices.push(v);
        this.adjList.set(v, []);
    }
}
```
**添加顶点之间的边**  
> 若图中无相应点，将自动创建。
```
addEdge(v,w) {
    if (!this.adjList.get(v)) {
        this.addVertex(v);
    }
    if (!this.adjList.get(w)) {
        this.addVertex(w);
    }
    this.adjList.get(v).push(w);
    if (!this.isDirected) {
        this.adjList.get(w).push(v);
    }
}
```
**返回顶点列表**  
```
getVertices() {
    return this.vertices;
}
```  
**返回邻接表**  
```
getAdjList() {
    return this.adjList;
}
```  
**创建 toString 方法**  
> 迭代顶点列表，并在每一个元素处迭代相应邻接表。  
```
toString() {
    let s = '';
    for (let i = 0; i < this.vertices.length; i++) {
        s += `${this.vertices[i]} -> `;
        const neighbors = this.adjList.get(this.vertices[i]);
        for (let j = 0; j < neighbors.length; j++) {
            s += `${neighbors[j]} `;
        }
        s += '\n';
    }
    return s;
}
```
> **关于换行**
> - `n` 适用于控制台  
> - `<br/>` 适用于 do...write();  

## 图的遍历  
> 有两种方法可以对图进行遍历：广度优先搜索和深度优先搜索。  

**算法**|**数据结构**|**描述**
:-:|:-:|:-:
广度优先搜索|队列|将顶点存入队列，最先入队列的顶点先被探索
深度优先搜索|栈|将顶点存入栈，顶点是沿着路径被探索的，存在新的相邻顶点就去访问  

**标记顶点**  
> 有助于在广度优先和深度优先算法中标记顶点。  
```
const Colors = {  // 枚举器
    WHITE: 0,  // 未访问
    GREY: 1,   // 访问了，但未探索
    BLACK: 2   // 访问且探索
};  
```  
**初始化顶点标记**  
> 将所有顶点标记为未访问（白色）。  
```
const initializeColor = vertices => {
    const color = {};
    for (let i = 0; i < vertices.length; i++) {
        color[vertices[i]] = Colors.WHITE;
    }
    return color;
};
```

## 广度优先探索  
> 先宽后深地访问顶点，就像一次访问图的一层。  

**算法思路**  
- 创建队列，将起始顶点 v 入列。
- 将顶点 u 出列，取邻点存入变量，顶点 u 变灰。
- 将 *白色邻点* 变灰入列，顶点 u 变黑，(如果队列不为空)重复 ② ③。
  
**算法实现**  
```
const breadthFirstSearch = (graph, startVertex, callback) => {
    const vertices = graph.getVertices();
    const adjList = graph.getAdjList();
    const color = initializeColor(vertices);
    const queue = new Queue();
    queue.enqueue(startVertex);
    
    while (!queue.isEmpty()) {
        const u = queue.dequeue();  // 每次的出列项
        const neighbors = adjList.get(u);
        color[u] = Colors.GREY;
        for (let i = 0; i < neighbors.length; i++) {
            const w = neighbors[i];
            if (color[w] === Colors.WHITE) {
                color[w] = Colors.GREY;
                queue.enqueue(w);
            }
        }
        color[u] = Colors.BLACK;
        
        if (callback) {
            callback(u);
        }
    }
};
```  

> 回调函数参考
> （其中 z 是顶点列表；结果将会输出被访问顶点的顺序）
> ```
> const mF = (value) => console.log('探索完成：' + value);
> breadthFirstSearch(x, z[0], mF);
> ```

### 用 BFS 寻找最短路径。
> 给出 **源顶点** 和 **每个顶点** 之间最短路径的距离（ 以边的数量计 ）。  

**改进的广度优先方法**  
> 在算法实现的基础上，加上了两个对象，用于记录每个点与源顶点的距离，以及每个点的前溯点。  
```
const BFS = (graph, startVertex) => {
    const vertices = graph.getVertices();
    const adjList = graph.getAdjList();
    const color = initializeColor(vertices);
    const queue = new Queue();
    const distances = {};
    const predecessors = {};
    queue.enqueue(startVertex);
    
    for (let i = 0; i < vertices.length; i++) {  // 初始化
        distances[vertices[i]] = 0;
        predecessors[vertices[i]] = null;
    }
    
    while (!queue.isEmpty()) {
        const u = queue.dequeue();
        const neighbors = adjList.get(u);
        color[u] = Colors.GREY;
        for (let i = 0; i < neighbors.length; i++) {
            const w = neighbors[i];
            if (color[w] === Colors.WHITE) {
                color[w] = Colors.GREY;
                distances[w] = distances[u] + 1;
                predecessors[w] = u;
                queue.enqueue(w);
            }
        }
        color[u] = Colors.BLACK;
    }
    return {
        distances,
        predecessors
    };
};
```  
**构建原溯点到其它顶点的路径**  
> 通过建立栈的方式，使最后存入的源起点最先出栈。  
```
const startVertex = z[0];

for (i = 1; i < z.length; i++) {
    const toVertex = z[i];
    const path = new Stack();
    for (
      let v = toVertex;  // 被遍历的其中一个顶点
      v !== startVertex;
      v = BFS(x, z[0]).predecessors[v]  // 赋值为自身前溯点
      ) { 
        path.push(v);
    }
    path.push(startVertex);
    let s = path.pop();
    while (!path.isEmpty()) {
        s += ' - ' + path.pop();
    }
    console.log(s);
}
```

## 深度优先探索  
> 先深度后广度地访问顶点，它的步骤是递归的。  
```
const depthFirstSearch = (graph, callback) => {
    const vertices = graph.getVertices();
    const adjList = graph.getAdjList();
    const color = initializeColor(vertices);
    
    // 实际上，在一个无向的图中，下面的方法只会被执行一次。
    for (let i = 0; i < vertices.length; i++) {
        if (color[vertices[i]] === Colors.WHITE) {
            depthFirstSearchVisit(vertices[i], color, adjList, callback);
        }
    }
};

// 本次需要探索的顶点、颜色列表、（用于找邻居的）邻接表
const depthFirstSearchVisit = (u, color, adjList, callback) => {
    color[u] = Colors.GREY;    // 开始访问
    if (callback) {
        callback(u);
    }
    const neighbors = adjList.get(u);
    for (let i = 0; i < neighbors.length; i++) {  // 遍历邻居，探索（白色）邻居
        const w = neighbors[i];
        if (color[w] === Colors.WHITE) {
            depthFirstSearchVisit(w, color, adjList, callback);
        }
    }
    color[u] = Colors.BLACK;  // 上面完成后，自身探索完成
};
```  
### 发现时间和完成探索时间  
> 需要对先前的方法进行一点改进。  
```
const DFS = graph => {
    const vertices = graph.getVertices();
    const adjList = graph.getAdjList();
    const color = initializeColor(vertices);
    const d = {};
    const f = {};
    const p = {};
    const time = {count: 0};
    for (let i = 0; i < vertices.length; i++) {
        f[vertices[i]] = 0;
        d[vertices[i]] = 0;
        p[vertices[i]] = null;
    }
    for (let i = 0; i < vertices.length; i++) {
        if (color[vertices[i]] === Colors.WHITE) {
            DFSVisit(vertices[i], color, d, f, p, time, adjList);
        }
    }
    return {
        discovery: d,
        finished: f,
        predecessors: p
    };
};
    
const DFSVisit = (u, color, d, f, p, time, adjList) => {
    color[u] = Colors.GREY;
    d[u] = ++time.count;
    const neighbors = adjList.get(u);
    for (let i = 0; i < neighbors.length; i++) {
        const w = neighbors[i];
        if (color[w] === Colors.WHITE) {
            p[w] = u;  // 追踪前溯点
            DFSVisit(w, color, d, f, p, time, adjList);
        }
    }
    color[u] = Colors.BLACK;
    f[u] = ++time.count;
    // 自身加一，且计入这次计算（表达式）
};
```  

### 拓扑排序————使用深度优先搜索  
> 拓扑排序只能应用于 **有向无环图**（ DAG ）。  
> 
> 结果将是 **众多可能性** 之一。
```
const x = new Graph(true);  // 创建有向图
......
const y = DFS(graph);   // 返回结果

const fTimes = y.finished;
s = '';
for (let count = 1; count < z.length; count++) {  // 共进行 顶点数量- 1 次操作
    let max = 0;
    let maxName = null;
    for (i = 0; i < z.length; i++) {  // 找到所需完成时间最长的顶点
        if (fTimes[z[i]] > max) {
            max = fTimes[z[i]];
            maxName = z[i];
        }
    }
    s += maxName + ' - ';
    delete fTimes[maxName];
}
s += Object.keys(fTimes)[0];  // 把剩下的顶点加进去
console.log(s);
```

## 最短路径算法  
> 介绍了 Dijkstra 算法和 Floyd-Warshall 算法。  

## Dijkstra 算法  
> 是一种计算从 **单个源到所有其他源的最短路径** 的贪心算法。  

**声明邻接矩阵**  
```
var graph = [[0,2,4,0,0,0],
             [0,0,2,4,2,0],
             [0,0,0,0,3,0],
             [0,0,0,0,0,2],
             [0,0,0,3,0,2],
             [0,0,0,0,0,0]];
```

**算法实现**  
> 顶点的处理：尝试去能去的点，如 C→E ，然后将 **A→C→E** 和最短路径（之前已计算出：如 **A→B→E**）比较，如果它更短，取代最短路径。
> 其中的 **A→C** 为 A 到 C 的最短距。
```
const INF = Number.MAX_SAFE_INTEGER;

const dijkstra = (graph, src) => {
    const dist = [];
    const visited = [];
    const s = {0:'0'}; 
    const { length } = graph;    // 获取数组长度到 length 变量
    for (let i = 0; i < length; i++) {
        dist[i] = INF;        // 初始化（到源点的）最短距
        visited[i] = false;   // 初始化处理状态
    }
    dist[src] = 0;
    for (let i = 0; i < length - 1; i++) {
        const u = minDistance(dist, visited);
        visited[u] = true;
        for (let v = 0; v < length; v++) {
            if (!visited[v] &&         // 需要未处理的（中）点 
                graph[u][v] !== 0 &&   // 能走通的路径
                dist[u] !== INF &&     
                dist[u] + graph[u][v] < dist[v]) {   // 比原最短路径更短的路径进行替代
              dist[v] = dist[u] + graph[u][v];
              s[v] = v + ' ' + s[u]; 
            }
        }
    }
    return {
        s,
        dist
    }   
};
```

**选出适宜顶点**  
> 将从 **尚未处理** 的顶点中选出 **距离源点最近** 的顶点。  
```
const minDistance = (dist, visited) => {
    let min = INF;
    let minIndex = -1;
    for (let v = 0; v < dist.length; v++) {
        if (visited[v] === false && dist[v] <= min) {
            min = dist[v];
            minIndex = v;
        }
    }
    return minIndex;
};
```

## Floyd-Warshall 算法  
> 是一种计算图中所有最短路径的动态规划算法，可以找出从 **所有源到所有顶点的最短路径**。  
```
const floydWarshall = graph => {
    const dist = [];
    const { length } = graph;
    for (let i = 0; i < length; i++) {
        dist[i] = [];
        for (let j = 0; j < length; j++) {  // ①
            if (i === j) {
                dist[i][j] = 0;             // 每个顶点到自身的权值为 0
            } else if (graph[i][j] === 0) {
                dist[i][j] = Infinity;
            } else {
                dist[i][j] = graph[i][j];
            }
        }
    }
    for (let k = 0; k < length; k++) {     // ②
        for (let i = 0; i < length; i++) {
            for (let j = 0; j < length; j++) {
                if (dist[i][k] + dist[k][j] < dist[i][j]) {
                    dist[i][j] = dist[i][k] + dist[k][j]
                }
            }
        }
    }
    return dist;
};
```
> ①：把 dist 数组初始化为每个顶点之间的权值。  
> 
> ②：将顶点 k 作为中间点，连通 ij。   
> 在每个 i 迭代中，j 都进行了迭代。同样的，在每个 k 迭代中，i、j都进行了迭代。保证了所有可能。  
> 三个迭代参数互换位置，也能得到一样的结果。  

## 最小生成树 ( MST )  
> 设想在 n 个岛屿之间建造桥梁，想用最低的成本实现所有岛屿相互连通。  
> 
> 岛屿可以表示为图中的一个顶点，边代表成本。  

## Prim 算法  
> 是一种求解 **加权无向连通图** 的 MST 问题的贪心算法。构成的树包含图中的所有顶点，且边的权值之和最小。  
```
const INF = Number.MAX_SAFE_INTEGER;

const prim = graph => {
    const parent = [];
    const key = [];
    const visited = [];
    const { length } = graph;
    for (let i = 0; i < length; i++) {  // 初始化
        key[i] = INF;
        visited[i] = false;
    }
    key[0] = 0;  // 根节点
    parent[0] = -1;
    for (let i = 0; i < length - 1; i++) {
        const u = minKey(graph, key, visited);
        visited[u] = true;
        for (let v = 0; v < length; v++) {   // 保留能到 v 点中与其距离最短的一点 u
            if (graph[u][v] && !visited[v] && graph[u][v] < key[v]) { 
                parent[v] = u;
                key[v] = graph[u][v];
            }
        }
    }
    return {
        parent,
        key
    }
};

const minKey = (graph, key, visited) => {
    let min = INF;
    let minIndex = -1;
    for (let v = 0; v < key.length; v++) {
        if (visited[v] === false && key[v] <= min) {
            min = key[v];
            minIndex = v;
        }
    }
    return minIndex;
};
```
一个输出栗子
```
const y = (a,b) => {
    let str = '';
    for (i = 1; i < a.length; i++) {
        str = str + '索引 ' + i + ' 连接到索引 ' + a[i] + ' => 权值为 ' + b[i] + '<br/>'
    }
    document.write(str);
}
y(x.parent, x.key);  // x 保存了算法执行后的返回值
```

## Kruskal 算法  
> 学习&测试失败，后面有时间再回来看。



