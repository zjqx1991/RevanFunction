//
//  RevanModelTool.h
//  RevanFunction_Example
//
//  Created by 紫荆秋雪 on 2018/3/12.
//  Copyright © 2018年 Revan. All rights reserved.
//


/** 处理被存储的模型
        把模型中的成员变量以及类型拿到，然后按存储数据库的SQL语句
    拼接 成员变量及其类型
 */

#import <Foundation/Foundation.h>

@interface RevanModelTool : NSObject
/**
 获取表名

 @param cls 模型类
 @return 通过模型获得的表名
 */
+ (NSString *)revan_tableNameWithModelClass:(Class)cls;


/**
 所有的【成员变量】, 以及【成员变量】对应的类型

 @param cls 模型类
 @return 模型类所有的【成员变量】, 以及【成员变量】对应的类型
 */
+ (NSDictionary *)revan_classIvarMemberAndTypeWithModelClass:(Class)cls;

/**
 所有的成员变量, 以及成员变量映射到数据库里面对应的类型

 @param cls 模型类
 @return 所有的成员变量, 以及成员变量映射到数据库里面对应的类型
 */
+ (NSDictionary *)revan_classIvarNameSqliteTypeDicWithModelClass:(Class)cls;


/**
 把模型所有的成员变量, 以及成员变量类型映射到数据库里面对应的类型，一对一对组成一个字符串

 @param cls 模型类
 @return 把模型所有的成员变量, 以及成员变量类型映射到数据库里面对应的类型，一对一对组成一个字符串
 */
+ (NSString *)revan_columnNamesAndTypesStrWithModelClass:(Class)cls;


/**
 获取模型中排好序的成员变量名

 @param cls 模型类
 @return 模型中排好序的成员变量名
 */
+ (NSArray *)revan_allClassSortedIvarNamesWithClass:(Class)cls;

@end
