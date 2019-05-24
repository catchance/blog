+++
title = "Spring踩坑集合"
description = "description"
keywords = ["bug", "spring"]
categories = ["bug"]
tags = ["spring"]
date = 2019-05-21T11:10:23+08:00
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
    
> spring相关踩坑系列  
<!--more-->
### 通过ClassType查询不到bean实例
---

#### 问题（坑）描述
通过ApplicationContext#getBeansOfType(Class<T> type)获取不到bean实例
但是可以通过bean的Name查询到相关实例

#### 原因
- 通过跟踪源码发现`typeToMatch.isInstance(beanInstance)`这里实际运行中的值false。
``` java 
    /** AbstractBeanFactory.java */
	@Override
	public boolean isTypeMatch(String name, ResolvableType typeToMatch) throws NoSuchBeanDefinitionException {
		String beanName = transformedBeanName(name);

		// Check manually registered singletons.
		Object beanInstance = getSingleton(beanName, false);
		if (beanInstance != null) {
			if (beanInstance instanceof FactoryBean) {
			    ...
			}
			else if (!BeanFactoryUtils.isFactoryDereference(name)) {
				if (typeToMatch.isInstance(beanInstance)) {
					// Direct match for exposed instance?
					return true;
				}
				else if (typeToMatch.hasGenerics() && containsBeanDefinition(beanName)) {
				    ...
				}
			}
			return false;
		}
		...
	}
```
- debug查询发现`beanInstance`是JDK的动态代理，所以`typeToMatch.isInstance(beanInstance)`的结果是false

#### 解决
- 修改代码，通过bean Name去获取实例

#### tips
- @Autowired 是通过类型获取bean实例
- @Resource 是通过名称获取bean实例
- Idea中调试的技巧: 计算出需要调试的地方在迭代列表中位置，[然后设置断点到指定次数时停止](https://www.cnblogs.com/shengulong/p/9332360.html)
- intellij idea调试小技巧: [条件循环调试](https://my.oschina.net/u/3777473/blog/1621646)

#### 相关参考
- [spring 的 ApplicationContext.getBean(type) 无法获取bean,报错](http://www.cnblogs.com/zhangchenglzhao/p/9337594.html)

