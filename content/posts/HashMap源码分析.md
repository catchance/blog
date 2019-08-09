+++
title = "HashMap源码分析"
description = "HashMap源码分析"
keywords = ["java", "hashmap", "map"]
categories = ["java"]
tags = ["hashmap", "map"]
date = 2019-06-18T18:05:56+08:00
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

> 深度分析HashMap的源码  
<!--more-->

### HashMap的几个参数
``` java
//默认桶16个
static final int DEFAULT_INITIAL_CAPACITY = 1 << 4; // aka 16

//默认桶最多有2^30个
static final int MAXIMUM_CAPACITY = 1 << 30;

//默认负载因子是0.75
static final float DEFAULT_LOAD_FACTOR = 0.75f;

//链表树化的阈值
static final int TREEIFY_THRESHOLD = 8;

// 把红黑树结构变回链表结构的阈值
static final int UNTREEIFY_THRESHOLD = 6;

// 链表树化的最低容量，当数组的容量小于这个的时候，不会进行树化，只会进行扩容
static final int MIN_TREEIFY_CAPACITY = 64;

//能容纳最多key_value对的个数
int threshold;

//一共key_value对个数
int size;
```

### 方法详解
#### hash
这里要注意区分三个概念：hashCode值、hash值、hash方法、数组下标
- hashCode值：是KV对中的K对象的hashCode方法的返回值（若没有重写则默认用Object类的hashCode方法的生成值）
- hash值：是在hashCode值的基础上又进行了一步运算后的结果，这个运算过程就是hash方法。
- 数组下标：根据该hash值和数组长度计算出数组下标，计算公式：hash值  &（数组长度-1）= 下标。
``` java
static final int hash(Object key) {
     int h;
     /* HashMap可以存null值，存null的时候，hash返回的值就是0 
      * key的hashCode值的高16位和低16位异或，让高16位参与hash计算
      */
     return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
}
```

#### treeifyBin
把容器里的元素变成树结构,当HashMap的内部元素数组中某个位置上存在多个hash值相同的键值对，这些Node已经形成了一个链表，当该链表的长度大于等于9的时候，会调用该方法来进行一个特殊处理。
``` java
/**
 * tab：元素数组，
 * hash：hash值（要增加的键值对的key的hash值）
 */
final void treeifyBin(Node<K,V>[] tab, int hash) {
 
    int n, index; Node<K,V> e;
    /*
     * 如果元素数组为空 或者 数组长度小于 树结构化的最小限制
     * MIN_TREEIFY_CAPACITY 默认值64，对于这个值可以理解为：如果元素数组长度小于这个值，没有必要去进行结构转换
     * 当一个数组位置上集中了多个键值对，那是因为这些key的hash值和数组长度取模之后结果相同。（并不是因为这些key的hash值相同）
     * 因为hash值相同的概率不高，所以可以通过扩容的方式，来使得最终这些key的hash值在和新的数组长度取模之后，拆分到多个数组位置上。
     */
    if (tab == null || (n = tab.length) < MIN_TREEIFY_CAPACITY)
        resize(); // 扩容，可参见resize方法解析
 
    // 如果元素数组长度已经大于等于了 MIN_TREEIFY_CAPACITY，那么就有必要进行结构转换了
    // 根据hash值和数组长度进行取模运算后，得到链表的首节点
    else if ((e = tab[index = (n - 1) & hash]) != null) { 
        TreeNode<K,V> hd = null, tl = null; // 定义首、尾节点
        do { 
            TreeNode<K,V> p = replacementTreeNode(e, null); // 将该节点转换为 树节点
            if (tl == null) // 如果尾节点为空，说明还没有根节点
                hd = p; // 首节点（根节点）指向 当前节点
            else { // 尾节点不为空，以下两行是一个双向链表结构
                p.prev = tl; // 当前树节点的 前一个节点指向 尾节点
                tl.next = p; // 尾节点的 后一个节点指向 当前节点
            }
            tl = p; // 把当前节点设为尾节点
        } while ((e = e.next) != null); // 继续遍历链表
 
        // 到目前为止 也只是把Node对象转换成了TreeNode对象，把单向链表转换成了双向链表
 
        // 把转换后的双向链表，替换原来位置上的单向链表
        if ((tab[index] = hd) != null)
            hd.treeify(tab);//此处单独解析
    }
}
```
#### treeify
treeify方法是TreeNode类的一个实例方法，通过TreeNode对象调用，实现该对象打头的链表转换为树结构。
``` java
/**
 * 参数为HashMap的元素数组
 */
final void treeify(Node<K,V>[] tab) {
    TreeNode<K,V> root = null; // 定义树的根节点
    for (TreeNode<K,V> x = this, next; x != null; x = next) { // 遍历链表，x指向当前节点、next指向下一个节点
        next = (TreeNode<K,V>)x.next; // 下一个节点
        x.left = x.right = null; // 设置当前节点的左右节点为空
        if (root == null) { // 如果还没有根节点
            x.parent = null; // 当前节点的父节点设为空
            x.red = false; // 当前节点的红色属性设为false（把当前节点设为黑色）
            root = x; // 根节点指向到当前节点
        }
        else { // 如果已经存在根节点了
            K k = x.key; // 取得当前链表节点的key
            int h = x.hash; // 取得当前链表节点的hash值
            Class<?> kc = null; // 定义key所属的Class
            for (TreeNode<K,V> p = root;;) { // 从根节点开始遍历，此遍历没有设置边界，只能从内部跳出
                // GOTO1
                int dir, ph; // dir 标识方向（左右）、ph标识当前树节点的hash值
                K pk = p.key; // 当前树节点的key
                if ((ph = p.hash) > h) // 如果当前树节点hash值 大于 当前链表节点的hash值
                    dir = -1; // 标识当前链表节点会放到当前树节点的左侧
                else if (ph < h)
                    dir = 1; // 右侧
 
                /*
                 * 如果两个节点的key的hash值相等，那么还要通过其他方式再进行比较
                 * 如果当前链表节点的key实现了comparable接口，并且当前树节点和链表节点是相同Class的实例，那么通过comparable的方式再比较两者。
                 * 如果还是相等，最后再通过tieBreakOrder比较一次
                 */
                else if ((kc == null &&
                            (kc = comparableClassFor(k)) == null) ||
                            (dir = compareComparables(kc, k, pk)) == 0)
                    dir = tieBreakOrder(k, pk);
 
                TreeNode<K,V> xp = p; // 保存当前树节点
 
                /*
                 * 如果dir 小于等于0 ： 当前链表节点一定放置在当前树节点的左侧，但不一定是该树节点的左孩子，也可能是左孩子的右孩子 或者 更深层次的节点。
                 * 如果dir 大于0 ： 当前链表节点一定放置在当前树节点的右侧，但不一定是该树节点的右孩子，也可能是右孩子的左孩子 或者 更深层次的节点。
                 * 如果当前树节点不是叶子节点，那么最终会以当前树节点的左孩子或者右孩子 为 起始节点  再从GOTO1 处开始 重新寻找自己（当前链表节点）的位置
                 * 如果当前树节点就是叶子节点，那么根据dir的值，就可以把当前链表节点挂载到当前树节点的左或者右侧了。
                 * 挂载之后，还需要重新把树进行平衡。平衡之后，就可以针对下一个链表节点进行处理了。
                 */
                if ((p = (dir <= 0) ? p.left : p.right) == null) {
                    x.parent = xp; // 当前链表节点 作为 当前树节点的子节点
                    if (dir <= 0)
                        xp.left = x; // 作为左孩子
                    else
                        xp.right = x; // 作为右孩子
                    root = balanceInsertion(root, x); // 重新平衡
                    break;
                }
            }
        }
    }
 
    // 把所有的链表节点都遍历完之后，最终构造出来的树可能经历多个平衡操作，根节点目前到底是链表的哪一个节点是不确定的
    // 因为我们要基于树来做查找，所以就应该把 tab[N] 得到的对象一定根节点对象，而目前只是链表的第一个节点对象，所以要做相应的处理。
    moveRootToFront(tab, root); // 单独解析
}
```
#### comparableClassFor
``` java
/**
* 如果对象x的类是C，如果C实现了Comparable<C>接口，那么返回C，否则返回null
*/
static Class<?> comparableClassFor(Object x) {
    if (x instanceof Comparable) {
        Class<?> c; Type[] ts, as; Type t; ParameterizedType p;
        if ((c = x.getClass()) == String.class) // 如果x是个字符串对象
            return c; // 返回String.class
        /*
         * 为什么如果x是个字符串就直接返回c了呢 ? 因为String  实现了 Comparable 接口，可参考如下String类的定义
         * public final class String implements java.io.Serializable, Comparable<String>, CharSequence
         */ 
 
        // 如果 c 不是字符串类，获取c直接实现的接口（如果是泛型接口则附带泛型信息）    
        if ((ts = c.getGenericInterfaces()) != null) {
            for (int i = 0; i < ts.length; ++i) { // 遍历接口数组
                // 如果当前接口t是个泛型接口 
                // 如果该泛型接口t的原始类型p 是 Comparable 接口
                // 如果该Comparable接口p只定义了一个泛型参数
                // 如果这一个泛型参数的类型就是c，那么返回c
                if (((t = ts[i]) instanceof ParameterizedType) &&
                    ((p = (ParameterizedType)t).getRawType() ==
                        Comparable.class) &&
                    (as = p.getActualTypeArguments()) != null &&
                    as.length == 1 && as[0] == c) // type arg is c
                    return c;
            }
            // 上面for循环的目的就是为了看看x的class是否 implements  Comparable<x的class>
        }
    }
    return null; // 如果c并没有实现 Comparable<c> 那么返回空
}
```

#### compareComparables
``` java
/**
* 如果x所属的类是kc，返回k.compareTo(x)的比较结果
* 如果x为空，或者其所属的类不是kc，返回0
*/
@SuppressWarnings({"rawtypes","unchecked"}) // for cast to Comparable
static int compareComparables(Class<?> kc, Object k, Object x) {
    return (x == null || x.getClass() != kc ? 0 :
            ((Comparable)k).compareTo(x));
}
```
#### tieBreakOrder
``` java
/**
* 用这个方法来比较两个对象，返回值要么大于0，要么小于0，不会为0
* 也就是说这一步一定能确定要插入的节点要么是树的左节点，要么是右节点，不然就无法继续满足二叉树结构了
* 
* 先比较两个对象的类名，类名是字符串对象，就按字符串的比较规则
* 如果两个对象是同一个类型，那么调用本地方法为两个对象生成hashCode值，再进行比较，hashCode相等的话返回-1
*/
static int tieBreakOrder(Object a, Object b) {
    int d;
    if (a == null || b == null ||
        (d = a.getClass().getName().
            compareTo(b.getClass().getName())) == 0)
        d = (System.identityHashCode(a) <= System.identityHashCode(b) ?
                -1 : 1);
    return d;
}
```

#### moveRootToFront
``` java
/**
 * Ensures that the given root is the first node of its bin.
 * 确保把给定的root节点设为桶中的第一个元素
 */
static <K,V> void moveRootToFront(Node<K,V>[] tab, TreeNode<K,V> root) {
    int n;
    if (root != null && tab != null && (n = tab.length) > 0) {
        int index = (n - 1) & root.hash;
        // first指向链表第一个节点
        TreeNode<K,V> first = (TreeNode<K,V>)tab[index];
        if (root != first) {
            // 当root节点不是first节点的时候
            Node<K,V> rn;
            // 设置桶的第一个元素为root元素
            tab[index] = root;
            TreeNode<K,V> rp = root.prev;
            if ((rn = root.next) != null)
                // 将root的后一个节点的prev指向root的前一个节点
                ((TreeNode<K,V>)rn).prev = rp;
            if (rp != null)
                // 将root的前一个节点的next指向root的后一个节点
                rp.next = rn;
            if (first != null)
                // 将first节点的prev指向root
                first.prev = root;
            // 将root的next节点执行first
            root.next = first;
            // 将root的prev节点置null
            root.prev = null;
        }
        //这里是防御性编程，校验更改后的结构是否满足红黑树和双链表的特性
        //因为HashMap并没有做并发安全处理，可能在并发场景中意外破坏了结构
        assert checkInvariants(root);
    }
}

```

#### checkInvariants
``` java
/**
* Recursive invariant check
* 递归检查结构是否满足红黑树和双链表的特性
*/
static <K,V> boolean checkInvariants(TreeNode<K,V> t) {
    TreeNode<K,V> tp = t.parent, tl = t.left, tr = t.right,
        tb = t.prev, tn = (TreeNode<K,V>)t.next;
    if (tb != null && tb.next != t)
        // 当t的前一个节点不等于null的时候，校验前一个节点的next是否指向t
        return false;
    if (tn != null && tn.prev != t)
        // 当t的后一个节点不等于null的时候，校验后一个节点的prev是否指向t
        return false;
    if (tp != null && t != tp.left && t != tp.right)
        // 当t的父节点不等于null的时候，校验t是否是父节点左孩子节点或者右孩子节点
        return false;
    if (tl != null && (tl.parent != t || tl.hash > t.hash))
        // t的左节点不为null的时候，判断左节点的父节点是否指向t，并且tl的hash值是否大于t的hash值
        return false;
    if (tr != null && (tr.parent != t || tr.hash < t.hash))
        // t的右节点不为null的时候，判断右节点的父节点是否指向t，并且tr的hash值是否小于t的hash值
        return false;
    if (t.red && tl != null && tl.red && tr != null && tr.red)
        // 当t是红的时候，判断tl不等于null，并且tl是红的，tr 不等于null 并且 tr是红的
        // 判断满不满足红黑树的红色节点的特性
        return false;
    if (tl != null && !checkInvariants(tl))
        // 当tl不等于null的时候，递归调用
        return false;
    if (tr != null && !checkInvariants(tr))
        // 当tl不等于null的时候，递归调用
        return false;
    // 校验通过
    return true;
}
```

#### 红黑树的左旋：rotateLeft
[![二叉树的左旋](https://i.postimg.cc/qMFsrRRW/image.png)](https://postimg.cc/2V4bFCnx)
``` java
static <K,V> TreeNode<K,V> rotateLeft(TreeNode<K,V> root,
                                      TreeNode<K,V> p) {
    // 这里的p即上图的A节点，r指向右孩子即C，rl指向右孩子的左孩子即D，pp为p的父节点
    TreeNode<K,V> r, pp, rl;
    if (p != null && (r = p.right) != null) {
        // 将p的右节点指向r的左节点即rl
        if ((rl = p.right = r.left) != null)
            // 设置rl的父节点等于p
            rl.parent = p;
        // 设置r的父节点等于p的父节点，即pp
        if ((pp = r.parent = p.parent) == null)
            // pp等于null的时候，即p是根节点，则变换新的根节点r的颜色为黑色
            (root = r).red = false;
        else if (pp.left == p)
            // 当pp不等于null p是pp的左节点 设置pp的左节点等于r
            pp.left = r;
        else
            // 当pp不等于null p是pp的右节点 设置pp的右节点等于r
            pp.right = r;
        //设置r的左节点等于p
        r.left = p;
        // p的父节点指向r
        p.parent = r;
    }
    return root;
}

```

#### 红黑树的右旋：rotateLeft
[![二叉树的右旋](https://i.postimg.cc/tCJ38PXh/image.png)](https://postimg.cc/nC89DX9z)
``` java
static <K,V> TreeNode<K,V> rotateRight(TreeNode<K,V> root,
                                       TreeNode<K,V> p) {

    //这里的p即上图的A节点，l指向左孩子即C，lr指向左孩子的右孩子即E，pp为p的父节点
    TreeNode<K,V> l, pp, lr;
    if (p != null && (l = p.left) != null) {
        // 将p的左节点指向l的右节点即lr
        if ((lr = p.left = l.right) != null)
            // 将lr的父节点指向p
            lr.parent = p;
        // 将l的父节点指向p的父节点，即pp
        if ((pp = l.parent = p.parent) == null)
            // pp等于null的时候，即p是根节点，则变换新的根节点l的颜色为黑色
            (root = l).red = false;
        else if (pp.right == p)
            // pp 不等于null， p是pp的右节点 将pp的右节点设置成l
            pp.right = l;
        else
            // pp 不等于null， p是pp的左节点 将pp的左节点设置成l
            pp.left = l;
        // 将l的右节点设置成p
        l.right = p;
        // 将p的父节点指向l
        p.parent = l;
    }
    return root;
}
```

#### balanceInsertion
``` java
static <K,V> TreeNode<K,V> balanceInsertion(TreeNode<K,V> root,
                                            TreeNode<K,V> x) {
    x.red = true;
    for (TreeNode<K,V> xp, xpp, xppl, xppr;;) {
        if ((xp = x.parent) == null) { // 情况一：插入的节点N的为根节点
            x.red = false;
            return x;
        }
        else if (!xp.red || (xpp = xp.parent) == null) // 情景2，3：父节点是黑色节点或者祖父节点为null
            return root;
        if (xp == (xppl = xpp.left)) {  // 情景4：插入的节点父节点和祖父节点都存在，并且其父节点是祖父节点的左节点
            if ((xppr = xpp.right) != null && xppr.red) { // 情景4i：插入节点的叔叔节点是红色
                xppr.red = false; // 设置叔叔节点为黑色，
                xp.red = false;   // 设置父节点为黑色，
                xpp.red = true;   // 设置祖父节点是红色
                x = xpp;          
            }
            else {                      // 情景4ii：插入节点的叔叔节点是黑色、或者不存在
                if (x == xp.right) {    // 情景4iia：插入节点是其父节点的右孩子
                    root = rotateLeft(root, x = xp);    // 
                    xpp = (xp = x.parent) == null ? null : xp.parent;
                }
                if (xp != null) {       // 情景4iib：插入节点是其父节点的左孩子
                    xp.red = false;
                    if (xpp != null) {
                        xpp.red = true;
                        root = rotateRight(root, xpp);
                    }
                }
            }
        }
        else { // 情景5：插入的节点父节点和祖父节点都存在，并且其父节点是祖父节点的右节点
            if (xppl != null && xppl.red) {  // 情景5i：插入节点的叔叔节点是红色
                xppl.red = false;
                xp.red = false;
                xpp.red = true;
                x = xpp;
            }
            else {  // 情景5ii：插入节点的叔叔节点是黑色或不存在
                if (x == xp.left) { // 情景5iia：插入节点是其父节点的左孩子　
                    root = rotateRight(root, x = xp);
                    xpp = (xp = x.parent) == null ? null : xp.parent;
                }
                if (xp != null) {  // 情景5iib：插入节点是其父节点的右孩子
                    xp.red = false;
                    if (xpp != null) {
                        xpp.red = true;
                        root = rotateLeft(root, xpp);
                    }
                }
            }
        }
    }
}
```

#### removeTreeNode
``` java 
final void removeTreeNode(HashMap<K,V> map, Node<K,V>[] tab,
                          boolean movable) {
    int n;      // tab的长度
    if (tab == null || (n = tab.length) == 0) // tab等于null或者tab的长度等于0 直接返回
        return;
    int index = (n - 1) & hash; // index是索引
    TreeNode<K,V> first = (TreeNode<K,V>)tab[index], root = first, rl; //链表的第一个节点， 设置root为第一个节点
    TreeNode<K,V> succ = (TreeNode<K,V>)next, pred = prev; //  前驱 和 后继
    if (pred == null)   
        tab[index] = first = succ;
    else
        pred.next = succ; // 前置节点指向后置节点，跳过当前节点
    if (succ != null)
        succ.prev = pred;  // 后置节点不等于null的值，修改其prev指向前置，跳过当前
    if (first == null) 
        return;
    if (root.parent != null)  // 寻找树的根节点root
        root = root.root();
    if (root == null || root.right == null ||
        (rl = root.left) == null || rl.left == null) {
        tab[index] = first.untreeify(map);  // too small // 太小，将树转换成链表
        return;
    }
    // p是待删除节点，replacement用于后续的红黑树调整，指向的是p或者p的继承者。
    TreeNode<K,V> p = this, pl = left, pr = right, replacement; 
    if (pl != null && pr != null) { // p有两个孩子
        TreeNode<K,V> s = pr, sl; // s 是继承者  sl是继承者s的左孩子
        while ((sl = s.left) != null) // find successor  // 寻找继承者
            s = sl;
        boolean c = s.red; s.red = p.red; p.red = c; // swap colors // 交换p和s的颜色
        TreeNode<K,V> sr = s.right;
        TreeNode<K,V> pp = p.parent;
        if (s == pr) { // p was s's direct parent  // 如果继承者s是p的右孩子
            p.parent = s;   // 交换s和p的位置
            s.right = p;    // 交换s和p的位置
        }
        else {      // 如果继承者s不是p的右孩子
            TreeNode<K,V> sp = s.parent;
            if ((p.parent = sp) != null) {  // p的parent指向s的parent sp
                if (s == sp.left) // 如果 s是sp的左孩子
                    sp.left = p;    // sp的左孩子设置为p
                else                // 如果 s是sp的右孩子
                    sp.right = p;   // sp的右孩子设置为p
            }
            if ((s.right = pr) != null)  //设置s的右节点为pr
                pr.parent = s;      // pr的父节点设置成s
        }
        p.left = null; // p的左孩子置null
        if ((p.right = sr) != null) // 将p的右孩子设置成sr
            sr.parent = p;  // sr存在的时候，将父节点指向p
        if ((s.left = pl) != null) // 将s的左孩子设置成p的左孩子pl
            pl.parent = s;  // pl存在，则设置pl的父节点指向s
        if ((s.parent = pp) == null)    //s的父节点指向p的父节点pp
            root = s;           // 如果p为根节点，则设置s为根节点
        else if (p == pp.left)  // 如果p是左孩子
            pp.left = s;    // 设置pp的左孩子为s
        else                // p是右孩子
            pp.right = s;   // 设置 pp的右孩子为s
        if (sr != null)     // sr不等于null的话 
            replacement = sr; // replacement等于sr
        else
            replacement = p;    // replacement等于p
    }
    else if (pl != null) // p有一个孩子 其左孩子pl不等于null
        replacement = pl; 
    else if (pr != null) // p有一个孩子 其右孩子pr不等于null
        replacement = pr; 
    else                 // p是叶子节点
        replacement = p;
    // p是待删除节点，replacement用于后续的红黑树调整，指向的是p或者p的继承者。
    // 如果p是叶子节点，p==replacement，否则replacement为p的右子树中最左节点
    if (replacement != p) { // 若p不是叶子节点
        TreeNode<K,V> pp = replacement.parent = p.parent; // 则让replacement的父节点指向p的父节点
        if (pp == null)  // p是根节点
            root = replacement;
        else if (p == pp.left)  // p是左节点
            pp.left = replacement; // replacement替换p成为pp的左孩子
        else                    // p是右节点
            pp.right = replacement;  // replacement替换p成为pp的右孩子
        p.left = p.right = p.parent = null; // 断开p
    }
    
    // 若待删除的节点p时红色的，则树平衡未被破坏，无需进行调整。
    // 否则删除节点后需要进行调整
    TreeNode<K,V> r = p.red ? root : balanceDeletion(root, replacement);

    if (replacement == p) {  // detach //p为叶子节点，则直接将p从树中清除
        TreeNode<K,V> pp = p.parent;
        p.parent = null; // 断开p与其父节点pp的连接
        if (pp != null) {
            if (p == pp.left)
                pp.left = null; // p是左孩子，断开其父节点pp与p的连接
            else if (p == pp.right)
                pp.right = null; // p是右孩子，断开其父节点pp与p的连接
        }
    }
    if (movable)
        moveRootToFront(tab, r);
}
```

#### balanceDeletion
``` java
// 两个参数分别表示根节点和删除节点的继承者
static <K,V> TreeNode<K,V> balanceDeletion(TreeNode<K,V> root,
                                           TreeNode<K,V> x) {
    for (TreeNode<K,V> xp, xpl, xpr;;)  {
        if (x == null || x == root) // x为空或x为根节点，直接返回
            return root;
        else if ((xp = x.parent) == null) { // x为根节点，染成黑色，直接返回（因为调整过后，root并不一定指向删除操作过后的根节点，如果之前删除的是root节点，则x将成为新的根节点）
            x.red = false;
            return x;
        }
        else if (x.red) { // 如果x为红色，则无需调整，返回
            x.red = false;
            return root;
        } 
        else if ((xpl = xp.left) == x) { // x为黑色 x为其父节点的左孩子
            if ((xpr = xp.right) != null && xpr.red) { // 情景2i：如果它有红色的兄弟节点xpr，那么它的父亲节点xp一定是黑色节点
                xpr.red = false;  // 互换sp和spr的节点颜色：将spr染成黑色
                xp.red = true;    // 互换sp和spr的节点颜色：将sp染成红色
                root = rotateLeft(root, xp); // 对父节点xp做左旋转
                xpr = (xp = x.parent) == null ? null : xp.right; // 重新将xp指向x的父节点，xpr指向xp新的右孩子
            }
            if (xpr == null) // 如果xpr为空，则向上继续调整，将x的父节点xp作为新的x继续循环
                x = xp;
            else {
                TreeNode<K,V> sl = xpr.left, sr = xpr.right; //sl和sr分别为其近侄子和远侄子
                if ((sr == null || !sr.red) &&
                    (sl == null || !sl.red)) {
                    xpr.red = true; //若sl和sr都为黑色或者不存在，即xpr没有红色孩子，则将xpr染红
                    x = xp; //本轮结束，继续向上循环
                }
                else { //否则的话，就需要进一步调整
                    if (sr == null || !sr.red) {
                        if (sl != null) /若左孩子为红，右孩子不存在或为黑
                            sl.red = false; //左孩子染黑
                        xpr.red = true; //将xpr染红
                        root = rotateRight(root, xpr);   //右旋
                        xpr = (xp = x.parent) == null ?
                            null : xp.right; //右旋后，xpr指向xp的新右孩子，即上一步中的sl
                    }
                    if (xpr != null) {
                        xpr.red = (xp == null) ? false : xp.red; //xpr染成跟父节点一致的颜色，为后面父节点xp的左旋做准备
                        if ((sr = xpr.right) != null)
                            sr.red = false; //xpr新的右孩子染黑，防止出现两个红色相连
                    }
                    if (xp != null) {
                        xp.red = false; //将xp染黑，并对其左旋，这样就能保证被删除的X所在的路径又多了一个黑色节点，从而达到恢复平衡的目的
                        root = rotateLeft(root, xp);
                    }
                    //到此调整已经完毕，进入下一次循环后将直接退出
                    x = root;
                }
            }
        }
        else { // symmetric //x为黑色 x为其父节点的右孩子，跟上面类似
            if (xpl != null && xpl.red) {
                xpl.red = false;
                xp.red = true;
                root = rotateRight(root, xp);
                xpl = (xp = x.parent) == null ? null : xp.left;
            }
            if (xpl == null)
                x = xp;
            else {
                TreeNode<K,V> sl = xpl.left, sr = xpl.right;
                if ((sl == null || !sl.red) &&
                    (sr == null || !sr.red)) {
                    xpl.red = true;
                    x = xp;
                }
                else {
                    if (sl == null || !sl.red) {
                        if (sr != null)
                            sr.red = false;
                        xpl.red = true;
                        root = rotateLeft(root, xpl);
                        xpl = (xp = x.parent) == null ?
                            null : xp.left;
                    }
                    if (xpl != null) {
                        xpl.red = (xp == null) ? false : xp.red;
                        if ((sl = xpl.left) != null)
                            sl.red = false;
                    }
                    if (xp != null) {
                        xp.red = false;
                        root = rotateRight(root, xp);
                    }
                    x = root;
                }
            }
        }
    }
```

### Q&A
#### 任何减小hash碰撞
- 如果HashMap的hash算法越散列，那么发生hash冲突的概率越低
- 如果数组越大，那么发生hash冲突的概率也会越低，但是数组越大带来的空间开销越多，但是遍历速度越快，这就要在空间和时间上进行权衡

### 相关文档
---
- [hash函数为什么要选择对素数求余](https://blog.csdn.net/lpf463061655/article/details/85130872)
- [HashMap JDK1.8实现原理](https://www.cnblogs.com/duodushuduokanbao/p/9492952.html)
- [Hash冲突（哈希碰撞)](https://github.com/about-cloud/JavaCore/blob/master/resource/markdown/collection/HashConflictsAndResolve.md)
- [Day25 史上最详细的HashMap红黑树解析](https://www.cnblogs.com/mfrank/p/9227097.html)
- [红黑树详细分析，看了都说好](https://segmentfault.com/a/1190000012728513?utm_source=tag-newest)

