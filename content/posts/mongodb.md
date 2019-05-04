---
title: mongodb
toc: true
tags: ["mongodb"]
categories: ["mongodb"]
keywords: ["mongodb", "vim"]
description: "这是一篇关于mongod的文章"
date: 2017-07-03 10:13:45 +08:00
draft: true
---
> mongodb基础知识、概念、与关系数据库的对比  
> mongodb shell命令操作语法，控制台底层的查询语句都是用javascript脚本完成操作
> java对于mongodb操作的方式：spring boot、morphia
> 使用示例和js脚本

<!--more-->

### 概述
---
MongoDB 是一个基于分布式文件存储的数据库。由 C++ 语言编写。  
MongoDB 是一个介于关系数据库和非关系数据库之间的产品，是非关系数据库当中功能最丰富，最像关系数据库的。  
关系数据库，是建立在关系模型基础上的数据库，借助于集合代数等数学概念和方法来处理数据库中的数据。现实世界中的各种实体以及实体之间的各种联系均用关系模型来表示。关系模型由关系数据结构、关系操作集合、关系完整性约束三部分组成。当前主流的关系型数据库有Oracle、DB2、PostgreSQL、Microsoft SQL Server、Microsoft Access、MySQL  
NoSQL，指的是非关系型的数据库。NoSQL有时也称作Not Only SQL的缩写，是对不同于传统的关系型数据库的数据库管理系统的统称。分类有键值(Key-Value)存储数据库（Redis）、列存储数据库（HBase）、文档型数据库（MongoDb、SequoiaDB）、图形(Graph)数据库

#### 基本概念
**MongoDB与SQL的相关概念对比**  

|SQL术语/概念 | MongoDB术语/概念 | 解释/说明|
|:--:|:--:|:--:|
|database |	database |	数据库|
|table |	collection |	数据库表/集合|
|row |	document |	数据记录行/文档|
|column |	field |	数据字段/域|
|index |	index |	索引|
|table joins | |	 	表连接,MongoDB不支持|
|primary key |	primary key |	主键,MongoDB自动将_id字段设置为主键|

- **数据库**

一个mongodb中可以建立多个数据库。
MongoDB的默认数据库为"db"，该数据库存储在data目录中。`show dbs`命令可以显示所有数据的列表。MongoDB的单个实例可以容纳多个独立的数据库，每一个都有自己的集合和权限，不同的数据库也放置在不同的文件中。  
数据库也通过名字来标识。数据库名可以是满足以下条件的任意UTF-8字符串。
不能是空字符串（"")。  
不得含有' '（空格)、.、$、/、\和\0 (空字符)。  
应全部小写。  
最多64字节。  
admin： 从权限的角度来看，这是"root"数据库。要是将一个用户添加到这个数据库，这个用户自动继承所有数据库的权限。一些特定的服务器端命令也只能从这个数据库运行，比如列出所有的数据库或者关闭服务器。  
local: 这个数据永远不会被复制，可以用来存储限于本地单台服务器的任意集合  
config: 当Mongo用于分片设置时，config数据库在内部使用，用于保存分片的相关信息。  
```bash
$ mongo # mongo客户端命令
$ db # 显示当前数据库对象或集合
$ show dbs # 显示所有数据的列表
$ use local #  运行"use"命令，可以连接到一个指定的数据库。
```

- **文档**  

文档是一组键值(key-value)对(即BSON)。MongoDB 的文档不需要设置相同的字段，并且相同的字段不需要相同的数据类型，这与关系型数据库有很大的区别，也是 MongoDB 非常突出的特点。
```json
{
  "key1":"value1",
  "key2":"value2"
}
```
**注意：**  
文档中的键/值对是有序的。  
文档中的值不仅可以是在双引号里面的字符串，还可以是其他几种数据类型（甚至可以是整个嵌入的文档)。  
MongoDB区分类型和大小写。  
MongoDB的文档不能有重复的键。  
文档的键是字符串。除了少数例外情况，键可以使用任意UTF-8字符。

**文档键命名规范：**  
键不能含有\0 (空字符)。这个字符用来表示键的结尾。  
.和$有特别的意义，只有在特定环境下才能使用。  
以下划线"\_"开头的键是保留的(不是严格要求的)。  

- **集合**

集合就是 MongoDB 文档组，类似于 RDBMS （关系数据库管理系统：Relational Database Management System)中的表格。  
集合存在于数据库中，集合没有固定的结构，这意味着你在对集合可以插入不同格式和类型的数据，但通常情况下我们插入集合的数据都会有一定的关联性。
```json
{
  "name":"xxx"
}
{
  "name":"yyy","age":"20"
}
{
  "name":"zzz","age":"30"
}
```
当第一个文档插入时，集合就会被创建。
**合法的集合名**  
集合名不能是空字符串""。  
集合名不能含有\0字符（空字符)，这个字符表示集合名的结尾。  
集合名不能以"system."开头，这是为系统集合保留的前缀。  
用户创建的集合名字不能含有保留字符。有些驱动程序的确支持在集合名里面包含，这是因为某些系统生成的集合中包含该字符。除非你要访问这种系统创建的集合，否则千万不要在名字里出现$。  
**capped collections固定大小的collection**   
它有很高的性能以及队列过期的特性(过期按照插入的顺序). 有点和 "RRD" 概念类似。  
Capped collections是高性能自动的维护对象的插入顺序。它非常适合类似记录日志的功能 和标准的collection不同，你必须要显式的创建一个capped collection， 指定一个collection的大小，单位是字节。collection的数据存储空间值提前分配的。  
要注意的是指定的存储大小包含了数据库的头信息。  
`db.createCollection("mycoll", {capped:true, size:100000})`
在capped collection中，你能添加新的对象。  
能进行更新，然而，对象不会增加存储空间。如果增加，更新就会失败 。
数据库不允许进行删除。使用drop()方法删除collection所有的行。
注意: 删除之后，你必须显式的重新创建这个collection。
在32bit机器中，capped collection最大存储为1e9( 1X109)个字节。  
判断集合是否为固定集合:`db.cappedLogCollection.isCapped()`
将已存在的集合转换为固定集合:`db.runCommand({"convertToCapped":"posts",size:10000})`  
固定集合文档按照插入顺序储存的,默认情况下查询就是按照插入顺序返回的,也可以使用$natural调整返回顺序。
`db.cappedLogCollection.find().sort({$natural:-1})`

**固定集合属性及用法**  
**属性**  
属性1:对固定集合进行插入速度极快  
属性2:按照插入顺序的查询输出速度极快  
属性3:能够在插入最新数据时,淘汰最早的数据  
**用法**  
用法1:储存日志信息  
用法2:缓存一些少量的文档  

- **元数据**

|集合命名空间 |	描述|
|:--:|:--:|
|dbname.system.namespaces |	列出所有名字空间。|
|dbname.system.indexes |	列出所有索引。|
|dbname.system.profile |	包含数据库概要(profile)信息。|
|dbname.system.users |	列出所有可访问数据库的用户。|
|dbname.local.sources |	包含复制对端（slave）的服务器信息和状态。|
在{{system.indexes}}插入数据，可以创建索引。但除此之外该表信息是不可变的(特殊的drop index命令将自动更新相关信息)。  
{{system.users}}是可修改的。 {{system.profile}}是可删除的。

- **MongoDB 数据类型**

|数据类型 |	描述|
|--|--|
|String|	字符串。存储数据常用的数据类型。在 MongoDB 中，UTF-8 编码的字符串才是合法的。|
|Integer |	整型数值。用于存储数值。根据你所采用的服务器，可分为 32 位或 64 位。|
|Boolean |	布尔值。用于存储布尔值（真/假）。|
|Double |	双精度浮点值。用于存储浮点值。|
|Min/Max keys |	将一个值与 BSON（二进制的 JSON）元素的最低值和最高值相对比。|
|Arrays |	用于将数组或列表或多个值存储为一个键。|
|Timestamp |	时间戳。记录文档修改或添加的具体时间。|
|Object |	用于内嵌文档。|
|Null |	用于创建空值。|
|Symbol |	符号。该数据类型基本上等同于字符串类型，但不同的是，它一般用于采用特殊符号类型的语言。|
|Date |	日期时间。用 UNIX 时间格式来存储当前日期或时间。你可以指定自己的日期时间：创建 Date 对象，传入年月日信息。|
|Object ID	| 对象 ID。用于创建文档的 ID。|
|Binary Data |	二进制数据。用于存储二进制数据。|
|Code |	代码类型。用于在文档中存储 JavaScript 代码。|
|Regular expression |	正则表达式类型。用于存储正则表达式。|


#### NoSQL和SQL
RDBMS
- 高度组织化结构化数据
- 结构化查询语言（SQL） (SQL)
- 数据和关系都存储在单独的表中。
- 数据操纵语言，数据定义语言
- 严格的一致性
- 基础事务
NoSQL
- 代表着不仅仅是SQL
- 没有声明性查询语言
- 没有预定义的模式
-键 - 值对存储，列存储，文档存储，图形数据库
- 最终一致性，而非ACID属性
- 非结构化和不可预知的数据
- CAP定理 指的是在一个分布式系统中， Consistency（一致性）、 Availability（可用性）、Partition tolerance（分区容错性），三者不可得兼
- BASE(解决关系数据库强一致性引起的问题而引起的可用性降低而提出的解决方案) 基本可用（Basically Available）、软状态（Soft state）、最终一致（Eventually consistent）
- 高性能，高可用性和可伸缩性

NoSQL的优点/缺点
优点:
- 高可扩展性
- 分布式计算
- 低成本
- 架构的灵活性，半结构化数据
- 没有复杂的关系
缺点:
- 没有标准化
- 有限的查询功能（到目前为止）
- 最终一致是不直观的程序

#### 使用场景
- 1、数据模型比较简单；
- 2、需要灵活性更强的IT系统；
- 3、对数据库性能要求较高；
- 4、不需要高度的数据一致性；
- 5、对于给定key，比较容易映射复杂值的环境。
- 6、事件的记录，内容管理或者博客平台

### 安装
---
#### ubuntu安装
```bash
# Ubuntu 16.04的安装
$ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
$ echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
$ sudo apt-get update
$ sudo apt-get install -y mongodb-org
# Run MongoDB Community Edition
# /var/log/mongodb/mongod.log 日志文件
# /var/lib/mongodb data files
# /etc/mongod.conf 配置文件, 27017为默认端口
# Start MongoDB.
$ sudo service mongod start
# Stop MongoDB.
$ sudo service mongod stop
# Restart MongoDB.
$ sudo service mongod restart
# Uninstall MongoDB Community Edition
# Stop MongoDB.
$ sudo service mongod stop
# Remove Packages.
$ sudo apt-get purge mongodb-org*
# Remove Data Directories.
$ sudo rm -r /var/log/mongodb
$ sudo rm -r /var/lib/mongodb
```

### 基础操作
---
#### MongoDB - 连接
```
> mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]
> mongodb://localhost
# 通过 shell 连接 MongoDB 服务：
> mongo
> mongodb://admin:123456@localhost/
> mongodb://admin:123456@localhost/test
```
mongodb:// 这是固定的格式，必须要指定。  
username:password@ 可选项，如果设置，在连接数据库服务器之后，驱动都会尝试登陆这个数据库  
host1 必须的指定至少一个host, host1 是这个URI唯一要填写的。它指定了要连接服务器的地址。如果要连接复制集，请指定多个主机地址。  
portX 可选的指定端口，如果不填，默认为27017  
/database 如果指定username:password@，连接并验证登陆指定数据库。若不指定，默认打开 test 数据库。  
?options 是连接选项。如果不使用/database，则前面需要加上/。所有连接选项都是键值对name=value，键值对之间通过&或;（分号）隔开  

#### MongoDB 数据库操作
```bash
# MongoDB 创建数据库的语法格式如下：
# use DATABASE_NAME
$ use xxx
$ db.xxx.insert({"key":"xxx"})

# MongoDB 删除数据库的语法格式如下：
# db.dropDatabase()
$ db.dropDatabase()

# 集合删除语法格式如下：db.collection.drop()
$ show tables 显示集合
$ db.xxx.drop()
```

#### 数据导入导出和备份
- 导入cvs
```cmd
"C:\Program Files\MongoDB\Server\3.2\bin\mongoimport" /d drugOrg /c testtest /type:csv /headerline  /file D:\assign.csv
"C:\Program Files\MongoDB\Server\3.2\bin\mongoimport" /d drugOrg /c t_signed /type:csv /headerline  /file D:\t_signed.csv
```

- 导出cvs
```cmd
"C:\Program Files\MongoDB\Server\3.2\bin\mongoexport"  --csv -d drugOrg -c t_signed -o D:\t_signed.csv
"C:\Program Files\MongoDB\Server\3.2\bin\mongoexport"  --csv -f _id,userId,companyId,time,singedTagId,department,day,orgId,userName,deviceId,tagNameList,treePath,headPicUrl,addressName,coordinate,address,visitId,country,province,city -d drugOrg -c t_signed -o D:\t_signed.csv
```

- 还原数据库
```cmd
"C:\Program Files\MongoDB\Server\3.2\bin\mongorestore" -d drugOrg --drop D:\drugOrg\drugOrg
```

#### ObjectId
ObjectId 是一个12字节 BSON 类型数据，有以下格式：
- 前4个字节表示时间戳
- 接下来的3个字节是机器标识码
- 紧接的两个字节由进程id组成（PID）
- 最后三个字节是随机数。
MongoDB中存储的文档必须有一个"\_id"键。这个键的值可以是任何类型的，默认是个ObjectId对象。
在一个集合里面，每个文档都有唯一的"\_id"值，来确保集合里面每个文档都能被唯一标识。
MongoDB采用ObjectId，而不是其他比较常规的做法（比如自动增加的主键）的主要原因，因为在多个 服务器上同步自动增加主键值既费力还费时。
```js
> newObjectId = ObjectId()
> myObjectId = ObjectId("5349b4ddd2781d08c09890f4")
> ObjectId("5349b4ddd2781d08c09890f4").getTimestamp() // 获取时间戳
> new ObjectId().str // ObjectId 转换成字符串
```

#### MongoDB  插入文档
```json
# 插入文档
# db.COLLECTION_NAME.insert(document)
> db.col.insert({
  "title": "MongoDB 教程",
  "description": "MongoDB 是一个 Nosql 数据库",
  "by": "菜鸟教程",
  "url": "http://www.runoob.com",
  "tags": ["mongodb", "database", "NoSQL"],
  "likes": 100
})
> db.col.find()
> document=({
  "title": "MongoDB 教程",
  "description": "MongoDB 是一个 Nosql 数据库",
  "by": "菜鸟教程",
  "url": "http://www.runoob.com",
  "tags": ["mongodb", "database", "NoSQL"],
  "likes": 100
});
> document
> db.col.insert(document)
# 插入文档你也可以使用 db.col.save(document) 命令。
# 如果指定 _id 字段，则会更新该 _id 的数据。
# 3.2 版本后添加的方法
#db.collection.insertOne():向指定集合中插入一条文档数据
#db.collection.insertMany():向指定集合中插入多条文档数据
> var document = db.col.insertOne({"a": 3})
> var res = db.col.insertMany([{"b": 3}, {"c": 4}])
```

#### MongoDB 更新文档
```bash
> db.collection.update(
   <query>,
   <update>,
   {
     upsert: <boolean>,
     multi: <boolean>,
     writeConcern: <document>
   }
)
```
参数说明：
query : update的查询条件，类似sql update查询内where后面的。  
update : update的对象和一些更新的操作符（如$,$inc...）等，也可以理解为sql update查询内set后面的  
upsert : 可选，这个参数的意思是，如果不存在update的记录，是否插入objNew,true为插入，默认是false，不插入。  
multi : 可选，mongodb 默认是false,只更新找到的第一条记录，如果这个参数为true,就把按条件查出来多条记录全部更新。  
writeConcern :可选，抛出异常的级别。  
```bash
> db.col.update({'title':'MongoDB 教程'},{$set:{'title':'MongoDB'}})
> db.col.find().pretty()
# save() 方法通过传入的文档来替换已有文档
> db.col.save({
	"_id" : ObjectId("596dfe19914215fcb553bfab"),
    "title" : "MongoDB",
    "description" : "MongoDB 是一个 Nosql 数据库",
    "by" : "Runoob",
    "url" : "http://www.runoob.com",
    "tags" : [
            "mongodb",
            "NoSQL"
    ],
    "likes" : 110
})
```

#### MongoDB 删除文档
```bash
db.collection.remove(
   <query>,
   {
     justOne: <boolean>,
     writeConcern: <document>
   }
)
# 参数说明：
# query :（可选）删除的文档的条件。
# justOne : （可选）如果设为 true 或 1，则只删除一个文档。
# writeConcern :（可选）抛出异常的级别。
```
```bash
> db.col.remove({'title':'MongoDB 教程'}) # 删除查询到的数据
> db.col.remove({}) #删除所有数据
> db.col.remove({'title':'MongoDB'},1)
```

#### MongoDB 查询文档
```bash
db.collection.find(query, projection)
# query ：可选，使用查询操作符指定查询条件
# projection ：可选，使用投影操作符指定返回的键。查询时返回文档中所有键值， 只需省略该参数即可（默认省略）。指定那些列显示和不显示（0表示不显示1表示显示)
# pretty() 方法以格式化的方式来显示所有文档。
db.col.find().pretty()
# 除了 find() 方法之外，还有一个 findOne() 方法，它只返回一个文档。
```
```bash
> db.col.find().pretty()
> db.col.find({},{"k1":0,"k2":2}).pretty()
```
- MongoDB AND 条件
```js
// WHERE k1='v1' AND k2='v2'
db.col.find({"k1":"v1", "k2":"v2"}).pretty()
```
- MongoDB OR 条件
```js
// WHERE k1=v1 OR k2 = v2
> db.col.find({
      $or: [
	     {k1: v1}, {k2:v2}
      ]
   }).pretty()
```
- AND 和 OR 联合使用
```js
// WHERE k1 > 50 AND (k2 = v2 OR k3 = v3)
> db.col.find({
    "k1": {$gt:50},
    $or: [{"k2": "v2"},{"k3": "v3"}]
  }).pretty()
```

- 使用 explain() 查询分析
```js
db.users.find({gender:"M"},{user_name:1,_id:0}).explain()
```
现在，我们看看这个结果集的字段：
  - indexOnly: 字段为 true ，表示我们使用了索引。
  - cursor：因为这个查询使用了索引，MongoDB 中索引存储在B树结构中，所以这是也使用了 BtreeCursor 类型的游标。如果没有使用索引，游标的类型是 BasicCursor。这个键还会给出你所使用的索引的名称，你通过这个名称可以查看当前数据库下的system.indexes集合（系统自动创建，由于存储索引信息，这个稍微会提到）来得到索引的详细信息。
  - n：当前查询返回的文档数量。
  - nscanned/nscannedObjects：表明当前这次查询一共扫描了集合中多少个文档，我们的目的是，让这个数值和返回文档的数量越接近越好。
  - millis：当前查询所需时间，毫秒数。
  - indexBounds：当前查询具体使用的索引。

```js
// 可以使用 hint 来强制 MongoDB 使用一个指定的索引。
db.users.find({gender:"M"},{user_name:1,_id:0}).hint({gender:1,user_name:1}).explain()
```

#### MongoDB 正则表达式
- 正则表达式是使用单个字符串来描述、匹配一系列符合某个句法规则的字符串。
- 许多程序设计语言都支持利用正则表达式进行字符串操作。
- MongoDB 使用 $regex 操作符来设置匹配字符串的正则表达式。
- MongoDB使用PCRE (Perl Compatible Regular Expression) 作为正则表达式语言。
- 不同于全文检索，我们使用正则表达式不需要做任何配置。
```js
db.posts.find({post_text:{$regex:"runoob",$options:"$i"}})
```
**数组元素使用正则表达式**  
我们还可以在数组字段中使用正则表达式来查找内容。

**优化正则表达式查询**
- 如果你的文档中字段设置了索引，那么使用索引相比于正则表达式匹配查找所有的数据查询速度更快。
- 如果正则表达式是前缀表达式，所有匹配的数据将以指定的前缀字符串为开始。例如： 如果正则表达式为 ^tut ，查询语句将查找以 tut 为开头的字符串。

**注意：**
- 正则表达式中使用变量。一定要使用eval将组合的字符串进行转换，不能直接将字符串拼接后传入给表达式。否则没有报错信息，只是结果为空！实例如下：
```js
var name=eval("/" + 变量值key +"/i");
title:eval("/"+title+"/i")    // 等同于 title:{$regex:title,$Option:"$i"}   
```

#### MongoDB 条件操作符

|操作|	格式 |	范例 |	RDBMS中的类似语句 |
|--|--|--|--|
|等于 |	{<key>:<value>} |	db.col.find({"by":"菜鸟教程"}).pretty() |	where by = '菜鸟教程'|
|小于 |	{<key>:{$lt:<value>}} |	db.col.find({"likes":{$lt:50}}).pretty() |	where likes < 50 |
|小于或等于 |	{<key>:{$lte:<value>}}	| db.col.find({"likes":{$lte:50}}).pretty() |	where likes <= 50|
|大于 |	{<key>:{$gt:<value>}} |	db.col.find({"likes":{$gt:50}}).pretty() |	where likes > 50|
|大于或等于	| {<key>:{$gte:<value>}} |	db.col.find({"likes":{$gte:50}}).pretty() |	where likes >= 50|
|不等于 |	{<key>:{$ne:<value>}} |	db.col.find({"likes":{$ne:50}}).pretty() |	where likes != 50

#### MongoDB $type 操作符
```js
// 查询col集合中 title 值类型为字符串的所有数据
db.col.find({"title" : {$type : 2}})
```

#### MongoDB简单查询操作符
| 操作 | 说明 | 示例 |
|--|--|--|
|$eq |  用来等值条件过滤某一个key的值 | db.col.find({"name":{$eq:"steven"}}) |
|$gt |  用来判断某个key值大于某个指定的值 | db.col.find({"age":{$gt:19}}) |
|$gte |  用来判断某个key值大于等于某个指定的值 | db.col.find({"age":{$gte:19}}) |
|$lt |  用来判断某个key值小于某个指定的值 | db.col.find({"age":{$lt:20}}) |
|$lte |  用来判断某个key值小于等于某个指定的值 | db.col.find({"age":{$lte:20}}) |
|$ne |  用来不等值条件过滤某一个key的值。 | db.col.find({"name":{$ne:"steven"}}) |
|$in |  用来指定某个key的值在指定的离散的值域内 | db.col.find({"name":{$in:["steven","jack"]}}) |
|$nin |  用来指定key值不存在某个指定的离散值域内 | db.col.find({"name":{$nin:["steven","jack"]}}) |
|$or |  任意组合不同的查询条件（可以针对任意key的限制条件），只要满足任意组合条件中的一个即可。 | db.col.find({"$or" : [{"name":"steven"},{"age":20}]}) |
|$and |  任意组合不同的查询条件（可以针对任意key的限制条件），并且必须同时满足所有条件。 | db.col.find({"$and" : [{"name":"steven"},{"age":20}]}) |
|$not |  元条件语句，需要和其他条件语句组合使用。 | db.col.find({"age":{"$not":{"$lt":20}}}) |
|$nor |  表示所有条件均不能满足则返回 | db.col.find({"$nor" : [{"name":"steven"},{"age":20}]}) 凡是 name 为 steven 或者 age 为 20 的全部过滤掉 |
|$exists |  查询不包含某一个属性（key）的文档 | db.col.find({"name":{"$exists":true}}) |
|$mod |  取余操作符，筛选经过区域操作后，结果符合条件的文档。 | db.col.find({"age" : {"$mod" : [4,0]}}) 返回age的值和 4 求余后 结果为 0 的数据 |
|$regex |  筛选值满足正则表达式的文档。 | db.col.find({"name" : {$regex:"stev*",$options:"i"}}) |
|$text |  针对建立了全文索引的字段，实施全文检索匹配。 | db.col.find({"$text":{$search:"steven",$language:"en"}}) |
|$where |  强大的查询关键字，但性能较差，可以传入js表达式或js函数来筛选数据。 | 见下面 |
|$all |  数组查询操作符，查询条件是一个数组，被查询的字段也是一个数组，要求被查询的数组类型的字段要是查询条件数组的超集（即大数组要包含小数组） | db.col.find({"values":{$all:["a","b"]}}) |
|$elemMatch |  数组查询操作符，用来指定数组的每一个元素同时满足所罗列的条件，如果不指定，则条件会是或的关系 | db.blog.find({"comments":{"$elemMatch":{"author":"joe","score":{"$gte":5}}}}) 查joe发表的5分以上的评论，注意comments为二维数组 |
|$size |  用于某个数组类型的key对应值的数量满足要求。 | db.col.find({"values":{$size : 3}}) |
|$comment |  在查询、更新或其他操作执行过程中，可以通过添加$comment操作符添加评论。改评论会被记录在日志中，用于后续分析。 | db.col.find( { <query>, $comment: <comment> } ) |
|$geoWithin |  这个操作符基于2d 空间索引，首先要针对文档的某个字段建立一个2d的空间索引，然后利用此操作符，可以在一个2d空间范围内指定一个多变形，$geoWithin操作符就是查询出包含在多变形范围内的点。 | |
|$geoIntersects |  同样基于2d空间索引，计算当前的空间范围和指定的geo多变形取交集。 |  |
|$near |  基于2d空间索引，指定一个点，返回该点有近及远的所有的点。 |  |
|$nearSphere |   基于2d空间索引，指定一个点，由近及远的返回所有的点，和$near操作符不同的是计算距离的方式 $nearSphere计算的是球面距离。$near计算的是坐标距离。 | |
| $  |  如果文档中某个value是数组类型，通过 $ 操作符可以指定数组字段的投影，返回数组字段中第一个匹配的那个元素，相当于截断了原来的整个数组，只返回第一个值。 | db.col.find({"values":{$eq:"a"}},{"values.$":1}) 会返回values数组中，第一个和"a"相等的元素，也就是返回"a" |
|$meta |  和全文索引 text index 组合使用，针对一个带有全文索引的元素，指定改操作符，可以返回和查询条件相似的分数，分数越高，匹配度越高。 | |
|$slice |  数组类型字段的投影操作，返回原来数据的一个子集.针对一个数组，其有如下几种返回子集的方式： | 示例如下 |
|$cond |  聚合管道 | 示例如下 |
```js
// $where
db.op_test.find({"$where":function(){
  for(var index in this) {
      if(this[index] == "steven") {
            return true;
      }
    }
    return false;
}})

// $slice
db.blog.find({"comments":{"$slice":[10,5]}})

// $cond
{ "_id" : 1, "item" : "abc1", qty: 300 }  
{ "_id" : 2, "item" : "abc2", qty: 200 }  
{ "_id" : 3, "item" : "xyz1", qty: 250 }
db.inventory.aggregate(   
[  
  {  
     $project:  
       {  
         item: 1,  
         discount:  
           {  
             $cond: { if: { $gte: [ "$qty", 250 ] }, then: 30, else: 20 }  
           }  
       }  
  }  
 ]  
 )  
 { "_id" : 1, "item" : "abc1", "discount" : 30 }  
 { "_id" : 2, "item" : "abc2", "discount" : 20 }  
 { "_id" : 3, "item" : "xyz1", "discount" : 30 }   
```

#### MongoDB Limit与Skip方法
```js
// db.COLLECTION_NAME.find().limit(NUMBER).skip(NUMBER)
// 查询第二条数据
// skip 默认为 0 limit默认为显示所有数据
// 当查询时同时使用sort,skip,limit，无论位置先后，最先执行顺序sort再skip再limit。
db.col.find({},{"title":1,_id:0}).skip(1).limit(1)
```

#### MongoDB 排序
```js
// db.COLLECTION_NAME.find().sort({KEY:1})
// 1 为升序排列，而-1是用于降序排列。
db.col.find({},{"title":1,_id:0}).sort({"likes":-1})
```

#### MongoDB 索引
索引是特殊的数据结构，索引存储在一个易于遍历读取的数据集合中，索引是对数据库表中一列或多列的值进行排序的一种结构
```js
// 建立索引的语法： db.COLLECTION_NAME.ensureIndex({KEY:1})
db.col.ensureIndex({"title":1})
db.col.ensureIndex({"title":1,"description":-1}) // 类似于关系数据库中的复合索引
db.col.ensureIndex({"k1": 1, "k2": -1}, {"background": true})
```

|Parameter |	Type |	Description |
|--|--|--|
|background |	Boolean |	建索引过程会阻塞其它数据库操作，background可指定以后台方式创建索引，即增加 "background" 可选参数。 "background" 默认值为false。 |
|unique |	Boolean |	建立的索引是否唯一。指定为true创建唯一索引。默认值为false. |
|name |	string |	索引的名称。如果未指定，MongoDB的通过连接索引的字段名和排序顺序生成一个索引名称。 |
|dropDups |	Boolean |	在建立唯一索引时是否删除重复记录,指定 true 创建唯一索引。默认值为 false. |
|sparse |	Boolean |	对文档中不存在的字段数据不启用索引；这个参数需要特别注意，如果设置为true的话，在索引字段中不会查询出不包含对应字段的文档.。默认值为 false. |
|expireAfterSeconds |	integer |	指定一个以秒为单位的数值，完成 TTL设定，设定集合的生存时间。|
|v |	index | version	索引的版本号。默认的索引版本取决于mongod创建索引时运行的版本。|
|weights |	document |	索引权重值，数值在 1 到 99,999 之间，表示该索引相对于其他索引字段的得分权重。|
|default_language |	string |	对于文本索引，该参数决定了停用词及词干和词器的规则的列表。 默认为英语 |
|language_override |	string |	对于文本索引，该参数指定了包含在文档中的字段名，语言覆盖默认的language，默认值为 language. |

**索引限制**
- 额外开销
每个索引占据一定的存储空间，在进行插入，更新和删除操作时也需要对索引进行操作。所以，如果你很少对集合进行读取操作，建议不使用索引。
- 内存(RAM)使用
由于索引是存储在内存(RAM)中,你应该确保该索引的大小不超过内存的限制。
如果索引的大小大于内存的限制，MongoDB会删除一些索引，这将导致性能下降。
- 查询限制
索引不能被以下的查询使用：
正则表达式及非操作符，如 $nin, $not, 等。
算术运算符，如 $mod, 等。
- $where 子句
所以，检测你的语句是否使用索引是一个好的习惯，可以用explain来查看。
- 索引键限制
从2.6版本开始，如果现有的索引字段的值超过索引键的限制，MongoDB中不会创建索引。
- 插入文档超过索引键限制
如果文档的索引字段值超过了索引键的限制，MongoDB不会将任何文档转换成索引的集合。与mongorestore和mongoimport工具类似。
- 最大范围
集合中索引不能超过64个
索引名的长度不能超过128个字符
一个复合索引最多可以有31个字段

#### MongoDB 聚合
```js
db.COLLECTION_NAME.aggregate(AGGREGATE_OPERATION)
```

|表达式 |	描述 |	实例 |
|--|--|--|
|$sum |	计算总和。|	db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$sum : "$likes"}}}]) |
|$avg |	计算平均值 |	db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$avg : "$likes"}}}]) |
|$min |	获取集合中所有文档对应值得最小值。|	db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$min : "$likes"}}}]) |
|$max |	获取集合中所有文档对应值得最大值。 |	db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$max : "$likes"}}}]) |
|$push |	在结果文档中插入值到一个数组中。 |	db.mycol.aggregate([{$group : {_id : "$by_user", url : {$push: "$url"}}}]) |
|$addToSet |	在结果文档中插入值到一个数组中，但不创建副本。 |	db.mycol.aggregate([{$group : {_id : "$by_user", url : {$addToSet : "$url"}}}]) |
|$first |	根据资源文档的排序获取第一个文档数据。|	db.mycol.aggregate([{$group : {_id : "$by_user", first_url : {$first : "$url"}}}]) |
|$last |	根据资源文档的排序获取最后一个文档数据 |	db.mycol.aggregate([{$group : {_id : "$by_user", last_url : {$last : "$url"}}}]) |

**管道的概念**
管道在Unix和Linux中一般用于将当前命令的输出结果作为下一个命令的参数。  
MongoDB的聚合管道将MongoDB文档在一个管道处理完毕后将结果传递给下一个管道处理。管道操作是可以重复的。  
表达式：处理输入文档并输出。表达式是无状态的，只能用于计算当前聚合管道的文档，不能处理其它的文档。  
这里我们介绍一下聚合框架中常用的几个操作：  
- $project：修改输入文档的结构。可以用来重命名、增加或删除域，也可以用于创建计算结果以及嵌套文档。
- $match：用于过滤数据，只输出符合条件的文档。$match使用MongoDB的标准查询操作。
- $limit：用来限制MongoDB聚合管道返回的文档数。
- $skip：在聚合管道中跳过指定数量的文档，并返回余下的文档。
- $unwind：将文档中的某一个数组类型字段拆分成多条，每条包含数组中的一个值。
- $group：将集合中的文档分组，可用于统计结果。
- $sort：将输入文档排序后输出。
- $geoNear：输出接近某一地理位置的有序文档。

**$project实例**
```js
// 这样的话结果中就只还有_id,tilte和author三个字段了，默认情况下_id字段是被包含的，如果要想不包含_id话可以这样:
// 非0显示；0不显示
db.col.aggregate(
    { $project : {
        title : 1 ,
        author : 1 ,
    }}
 );
```

**$match实例**
```js
// 用于获取分数大于70小于或等于90记录，然后将符合条件的记录送到下一阶段$group管道操作符进行处理。
db.col.aggregate( [
                        { $match : { score : { $gt : 70, $lte : 90 } } },
                        { $group: { _id: null, count: { $sum: 1 } } }
                       ] );
```

**$skip实例**
```js
// 经过$skip管道操作符处理后，前五个文档被"过滤"掉。
db.col.aggregate(
    { $skip : 5 });
```

**$group**
```js
// select by_user as _id, count(*) as num_tutorial from mycol group by by_user
db.col.aggregate([{$group : {_id : "$by_user", num_tutorial : {$sum : 1}}}])
```

#### MongoDB 原子操作
mongodb不支持事务，所以，在你的项目中应用时，要注意这点。无论什么设计，都不要要求mongodb保证数据的完整性。
但是mongodb提供了许多原子操作，比如文档的保存，修改，删除等，都是原子操作。
所谓原子操作就是要么这个文档保存到Mongodb，要么没有保存到Mongodb，不会出现查询到的文档没有保存完整的情况。
```js
db.books.findAndModify ( {
   query: {
            _id: 123456789,
            available: { $gt: 0 }
          },
   update: {
             $inc: { available: -1 },
             $push: { checkout: { by: "abc", date: new Date() } }
           }
} )
```

**原子操作常用命令**  
$set
```js
//用来指定一个键并更新键值，若键不存在并创建。
{ $set : { "field" : "value" } }
```
$unset
```js
//用来删除一个键。
{ $unset : { field : 1} }
```

$inc
```js
//$inc可以对文档的某个值为数字型（只能为满足要求的数字）的键进行增减的操作。
{ $inc : { field : value } }
```

$push
```js
//用法：
{ $push : { field : value } }
//把value追加到field里面去，field一定要是数组类型才行，如果field不存在，会新增一个数组类型加进去。
```

$pushAll
```js
//同$push,只是一次可以追加多个值到一个数组字段内。
{ $pushAll : { field : value_array } }
```

$pull
```js
//从数组field内删除一个等于value值。
{ $pull : { field : _value } }
```

$addToSet
```js
//增加一个值到数组内，而且只有当这个值不在数组内才增加。
```

$pop
```js
//删除数组的第一个或最后一个元素
{ $pop : { field : 1 } }
```

$rename
```js
//修改字段名称
{ $rename : { old_field_name : new_field_name } }
```

$bit
```js
//位操作，integer类型
{$bit : { field : {and : 5}}}
```

#### MongoDB Map Reduce

#### MongoDB 全文检索

#### MongoDB GridFS
GridFS 用于存储和恢复那些超过16M（BSON文件限制）的文件(如：图片、音频、视频等)。  
GridFS 也是文件存储的一种方式，但是它是存储在MonoDB的集合中。  
GridFS 可以更好的存储大于16M的文件。  
GridFS 会将大文件对象分割成多个小的chunk(文件片段),一般为256k/个,每个chunk将作为MongoDB的一个文档(document)被存储在chunks集合中。  
GridFS 用两个集合来存储一个文件：fs.files与fs.chunks。  
每个文件的实际内容被存在chunks(二进制数据)中,和文件有关的meta数据(filename,content_type,还有用户自定义的属性)将会被存在files集合中。  

**GridFS 添加文件**
现在我们使用 GridFS 的 put 命令来存储 mp3 文件。 调用 MongoDB 安装目录下bin的 mongofiles.exe工具。
打开命令提示符，进入到MongoDB的安装目录的bin目录中，找到mongofiles.exe，并输入下面的代码：
`>mongofiles.exe -d gridfs put song.mp3`
GridFS 是存储文件的数据名称。如果不存在该数据库，MongoDB会自动创建。Song.mp3 是音频文件名。
使用以下命令来查看数据库中文件的文档：
`>db.fs.files.find()`
以上命令执行后返回以下文档数据：
```js
{
   _id: ObjectId('534a811bf8b4aa4d33fdf94d'),
   filename: "song.mp3",
   chunkSize: 261120,
   uploadDate: new Date(1397391643474), md5: "e4f53379c909f7bed2e9d631e15c1c41",
   length: 10401959
}
```
我们可以看到 fs.chunks 集合中所有的区块，以下我们得到了文件的 \_id 值，我们可以根据这个 \_id 获取区块(chunk)的数据：
`>db.fs.chunks.find({files_id:ObjectId('534a811bf8b4aa4d33fdf94d')})`
以上实例中，查询返回了 40 个文档的数据，意味着mp3文件被存储在40个区块中。

### 优化建议
---
- 在查询条件、排序条件、统计条件的字段上选择创建索引，可以显著提高查询效率。
- 用$or时把匹配最多结果的条件放在最前面，用$and时把匹配最 少 结果的条件放在最前面。
- 使用limit()限定返回结果集的大小，减少数据库服务器的资源消耗，以及网络传输的数据量。
- 尽量不用模糊匹配查询，用其它精确匹配查询代替，比如$in、$nin。
- MongoDB的智能查询优化，判断粒度为query条件，而skip和limit都不在其判断之中，当分页查询最后几页时，先用order反向排序。
- 只查询要使用的字段，而不查询所有字段。
- 更新字段的值时，使用$inc比update效率高。
- capped collections比普通collections的读写效率高。
- 必要时使用hint()强制使用某个索引查询。
- 使用explain，根据exlpain plan进行优化。
- 范围查询的时候尽量用$in、$nin代替。
- 查看数据库查询日志，具体分析的效率低的操作。
- mongodb有一个数据库优化工具database profiler，能够检测数据库操作的性能。可以发现query或者write操作中执行效率低的，从而针对这些操作进行优化。

### 常用脚本
---
- 去重复的脚本
```js
db.b_doctor.aggregate([
	{ $group: {"_id": { "doctorNum" : "$doctorNum", "name": "$name"},"countAll":{$sum:1},"dups":{$addToSet: '$_id'} }},
	{ $match:{ "countAll":{$gt:1}}}]).forEach(function(doc){
    doc.dups.shift();
    db.b_doctor.remove({_id: {$in: doc.dups}});
})
```
- 同步表中的数据
```js
db.t_qa_question_hot.find({"questionType":{$exists:false}}).forEach(function(x){
    var cursor = db.t_qa_question.find({"_id": ObjectId(x.questionId)});
    if(cursor.hasNext()){
        var q = cursor.next();
        db.t_qa_question_hot.update({"_id": x._id}, {
            $set:{"questionType" : NumberInt(q.type),"questionCreator":q.userId}},false,true)
    }
});
```
- 按照数组中的元素来进行分组统计
```js
// 如果$class_artist是数组 使用$unwind,它的功能就是把数组拆分出来，形成多条数据。
db.articles.aggregate([  
  {$match: { class_date: { $gte: date } } },  
  {$project: { _id: 0, class_artist: 1 } },  
  {$unwind: "$class_artist" },  
  {$group: { _id: "$class_artist", tags: { $sum: 1 } }},  
  {$project: { _id: 0,class_artist: "$_id", tags: 1 } },  
  {$sort: { tags: -1 } }  
])
```

### 参考
---
- [官网](https://www.mongodb.com/)
- [runoob.com >> MongoDB 教程](http://www.runoob.com/mongodb/mongodb-tutorial.html)
-
