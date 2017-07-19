---
title: mongodb
toc: true
tags:
  - mongodb
categories:
  - mongodb
date: 2017-07-03 10:13:45
---
> mongodb基础知识  
> mongodb基础操作

<!--more-->

### 概述
---
MongoDB 是一个基于分布式文件存储的数据库。由 C++ 语言编写。  
MongoDB 是一个介于关系数据库和非关系数据库之间的产品，是非关系数据库当中功能最丰富，最像关系数据库的。
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
需要注意的是：  
文档中的键/值对是有序的。  
文档中的值不仅可以是在双引号里面的字符串，还可以是其他几种数据类型（甚至可以是整个嵌入的文档)。  
MongoDB区分类型和大小写。  
MongoDB的文档不能有重复的键。  
文档的键是字符串。除了少数例外情况，键可以使用任意UTF-8字符。

文档键命名规范：  
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
NoSQL，指的是非关系型的数据库。NoSQL有时也称作Not Only SQL的缩写，是对不同于传统的关系型数据库的数据库管理系统的统称。  
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
- CAP定理
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

### 参考
- [官网](https://www.mongodb.com/)
- [runoob.com >> MongoDB 教程](http://www.runoob.com/mongodb/mongodb-tutorial.html)
-
