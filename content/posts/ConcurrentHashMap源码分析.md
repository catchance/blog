+++
title = "ConcurrentHashMap源码分析"
description = "description"
keywords = ["java", "map", "hashmap"]
categories = ["java"]
tags = ["map","hashmap"]
date = 2019-08-13T13:58:18+08:00
draft = true
# CJKLanguage: Chinese, Japanese, Korean
isCJKLanguage = true
# 排序你的文章
weight = 40

# 这里还可以自定义任何参数，这些参数可以在模板中使用
toc = true
comments = false
# 精选图片
featured_image = ""
+++

> ConcurrentHashMap源码分析  
<!--more-->

### 几个重要参数
---
``` java
// 表的最大容量(满足2的N次方的最大值)
private static final int MAXIMUM_CAPACITY = 1 << 30;
// 默认表的大小
private static final int DEFAULT_CAPACITY = 16;
// 最大数组大小
static final int MAX_ARRAY_SIZE = Integer.MAX_VALUE - 8;
// 默认并发数
private static final int DEFAULT_CONCURRENCY_LEVEL = 16;
// 装载因子
private static final float LOAD_FACTOR = 0.75f;
// 转化为红黑树的阈值
static final int TREEIFY_THRESHOLD = 8;
// 由红黑树转化为链表的阈值
static final int UNTREEIFY_THRESHOLD = 6;
// 转化为红黑树的表的最小容量
static final int MIN_TREEIFY_CAPACITY = 64;
// 每次进行转移的最小值
private static final int MIN_TRANSFER_STRIDE = 16;
// 生成sizeCtl所使用的bit位数
private static int RESIZE_STAMP_BITS = 16;
// 进行扩容所允许的最大线程数
private static final int MAX_RESIZERS = (1 << (32 - RESIZE_STAMP_BITS)) - 1;
// 记录sizeCtl中的大小所需要进行的偏移位数
private static final int RESIZE_STAMP_SHIFT = 32 - RESIZE_STAMP_BITS;   

static final int MOVED     = -1; // 表示正在转移
static final int TREEBIN   = -2; // 表示已经转换成树
static final int RESERVED  = -3; // hash for transient reservations
static final int HASH_BITS = 0x7fffffff; // usable bits of normal node hash

/** Number of CPUS, to place bounds on some sizings */
// 获取可用的CPU个数
static final int NCPU = Runtime.getRuntime().availableProcessors();
// 
/** For serialization compatibility. */
// 进行序列化的属性
private static final ObjectStreamField[] serialPersistentFields = {
    new ObjectStreamField("segments", Segment[].class),
    new ObjectStreamField("segmentMask", Integer.TYPE),
    new ObjectStreamField("segmentShift", Integer.TYPE)
};

// 默认为null，初始化发生在第一次插入操作，默认大小为16的数组，用来存储Node节点数据，扩容时大小总是2的幂次方。
transient volatile Node<K,V>[] table;

// 默认为null，扩容时新生成的数组，其大小为原数组的两倍。
private transient volatile Node<K,V>[] nextTable;

// 基本计数
private transient volatile long baseCount;

/**
 * 用来控制表初始化和扩容的，默认值为0，当在初始化的时候指定了大小，这会将这个大小保存在sizeCtl中，大小为数组的0.75
 * 当为负的时候，说明表正在初始化或扩张，
 *     -1表示初始化
 *     -(1+n) n:表示活动的扩张线程
 *其余情况：
 *  1、如果table未初始化，表示table需要初始化的大小。
 *  2、如果table初始化完成，表示table的容量，默认是table大小的0.75倍，居然用这个公式算0.75（n - (n >>> 2)）。
 **/
private transient volatile int sizeCtl;

/**
 * The next table index (plus one) to split while resizing.
 */
// 扩容下另一个表的索引
private transient volatile int transferIndex;

/**
 * Spinlock (locked via CAS) used when resizing and/or creating CounterCells.
 */
// 旋转锁
private transient volatile int cellsBusy;

/**
 * Table of counter cells. When non-null, size is a power of 2.
 */
// counterCell表
private transient volatile CounterCell[] counterCells;

// views
// 视图
private transient KeySetView<K,V> keySet;
private transient ValuesView<K,V> values;
private transient EntrySetView<K,V> entrySet;

// Unsafe mechanics
private static final sun.misc.Unsafe U;
private static final long SIZECTL;
private static final long TRANSFERINDEX;
private static final long BASECOUNT;
private static final long CELLSBUSY;
private static final long CELLVALUE;
private static final long ABASE;
private static final int ASHIFT;

static {
    try {
        U = sun.misc.Unsafe.getUnsafe();
        Class<?> k = ConcurrentHashMap.class;
        SIZECTL = U.objectFieldOffset
            (k.getDeclaredField("sizeCtl"));
        TRANSFERINDEX = U.objectFieldOffset
            (k.getDeclaredField("transferIndex"));
        BASECOUNT = U.objectFieldOffset
            (k.getDeclaredField("baseCount"));
        CELLSBUSY = U.objectFieldOffset
            (k.getDeclaredField("cellsBusy"));
        Class<?> ck = CounterCell.class;
        CELLVALUE = U.objectFieldOffset
            (ck.getDeclaredField("value"));
        Class<?> ak = Node[].class;
        ABASE = U.arrayBaseOffset(ak);
        int scale = U.arrayIndexScale(ak);
        if ((scale & (scale - 1)) != 0)
            throw new Error("data type scale not a power of two");
        ASHIFT = 31 - Integer.numberOfLeadingZeros(scale);
    } catch (Exception e) {
        throw new Error(e);
    }
}

```

#### ForwardingNode
一个特殊的Node节点，hash值为-1，其中存储nextTable的引用。

### 方法详解
---
#### initTable
``` java
private final Node<K,V>[] initTable() {
    Node<K,V>[] tab; int sc;
    while ((tab = table) == null || tab.length == 0) {
        // 如果一个线程发现sizeCtl<0，意味着另外的线程执行CAS操作成功，当前线程只需要让出cpu时间片
        // sizeCtl默认值为0
        if ((sc = sizeCtl) < 0)
            Thread.yield(); // lost initialization race; just spin
        else if (U.compareAndSwapInt(this, SIZECTL, sc, -1)) {
        // cas操作，将sizeCtl设置成-1，原子操作，只有一个线程能进入，其他线程让出CPU，等待初始化完成
            try {
                if ((tab = table) == null || tab.length == 0) {
                    int n = (sc > 0) ? sc : DEFAULT_CAPACITY;
                    @SuppressWarnings("unchecked")
                    Node<K,V>[] nt = (Node<K,V>[])new Node<?,?>[n];
                    table = tab = nt;
                    sc = n - (n >>> 2);
                }
            } finally {
                sizeCtl = sc;
            }
            break;
        }
    }
    return tab;
}
```

#### spread
``` java
static final int spread(int h) {
    // Java 8的ConcurrentHashMap作者认为引入红黑树后，即使哈希冲突比较严重，寻址效率也足够高，所以作者并未在哈希值的计算上做过多设计
    //将Key的hashCode值与其高16位作异或并保证最高位为0（从而保证最终结果为正整数）
    return (h ^ (h >>> 16)) & HASH_BITS;
}
```

#### tabAt、casTabAt、setTabAt
``` java
static final <K,V> Node<K,V> tabAt(Node<K,V>[] tab, int i) {
    //                                      arrayIndexScale   ASHIFT
    // 00000000 00000000 00000000 00000001  1                 0
    // 00000000 00000000 00000000 00000010  2                 1
    // 00000000 00000000 00000000 00000100  4                 2
    
    return (Node<K,V>)U.getObjectVolatile(tab, ((long)i << ASHIFT) + ABASE);
}

static final <K,V> boolean casTabAt(Node<K,V>[] tab, int i,
                                    Node<K,V> c, Node<K,V> v) {
    return U.compareAndSwapObject(tab, ((long)i << ASHIFT) + ABASE, c, v);
}

static final <K,V> void setTabAt(Node<K,V>[] tab, int i, Node<K,V> v) {
    U.putObjectVolatile(tab, ((long)i << ASHIFT) + ABASE, v);
}
```

#### putVal
``` java
/** Implementation for put and putIfAbsent */
final V putVal(K key, V value, boolean onlyIfAbsent) {
    if (key == null || value == null) throw new NullPointerException(); // 键或值为空，抛出异常
    int hash = spread(key.hashCode());
    int binCount = 0;
    for (Node<K,V>[] tab = table;;) {
        Node<K,V> f; int n, i, fh;
        if (tab == null || (n = tab.length) == 0)
            tab = initTable();
        else if ((f = tabAt(tab, i = (n - 1) & hash)) == null) {
            if (casTabAt(tab, i, null,
                         new Node<K,V>(hash, key, value, null)))
                break;                   // no lock when adding to empty bin
        }
        else if ((fh = f.hash) == MOVED)
            tab = helpTransfer(tab, f);
        else {
            V oldVal = null;
            synchronized (f) {
                if (tabAt(tab, i) == f) {
                    if (fh >= 0) {
                        binCount = 1;
                        for (Node<K,V> e = f;; ++binCount) {
                            K ek;
                            if (e.hash == hash &&
                                ((ek = e.key) == key ||
                                 (ek != null && key.equals(ek)))) {
                                oldVal = e.val;
                                if (!onlyIfAbsent)
                                    e.val = value;
                                break;
                            }
                            Node<K,V> pred = e;
                            if ((e = e.next) == null) {
                                pred.next = new Node<K,V>(hash, key,
                                                          value, null);
                                break;
                            }
                        }
                    }
                    else if (f instanceof TreeBin) {
                        Node<K,V> p;
                        binCount = 2;
                        if ((p = ((TreeBin<K,V>)f).putTreeVal(hash, key,
                                                       value)) != null) {
                            oldVal = p.val;
                            if (!onlyIfAbsent)
                                p.val = value;
                        }
                    }
                }
            }
            if (binCount != 0) {
                if (binCount >= TREEIFY_THRESHOLD)
                    treeifyBin(tab, i);
                if (oldVal != null)
                    return oldVal;
                break;
            }
        }
    }
    addCount(1L, binCount);
    return null;
}
```

### 相关文档
---
- [ConcurrentHashMap源码分析(1.8)](https://www.cnblogs.com/zerotomax/p/8687425.html)
- []()
- []()

