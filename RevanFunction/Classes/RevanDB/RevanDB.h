//
//  RevanDB.h
//  RevanFunctionModule_Example
//
//  Created by 紫荆秋雪 on 2018/3/12.
//  Copyright © 2018年 Revan. All rights reserved.
//

/** 创建表格的sql语句给拼接出来
        1.尽可能多的, 能够自己获取, 就自己获取
        2.实在判定不了用户的意图的, 只能让用户来告诉我们
        3.create table if not exists 表名(字段1 字段1类型, 字段2 字段2类型 (约束),...., primary key(字段))
 */

/** 面向对象创表 */

#import <Foundation/Foundation.h>
#import "RevanDBProtocol.h"

typedef NS_ENUM(NSUInteger, RevanDBMemberNameToValueRelationType) {
    RevanDBMemberNameToValueRelationTypeMore,
    RevanDBMemberNameToValueRelationTypeLess,
    RevanDBMemberNameToValueRelationTypeEqual,
    RevanDBMemberNameToValueRelationTypeMoreEqual,
    RevanDBMemberNameToValueRelationTypeLessEqual,
}; 

@interface RevanDB : NSObject
/**
 通过类Class来创建表

 @param cls 模型类
 @param uid 用户唯一表示
 @return 创表是否成功
 */
+ (BOOL)revan_createTable:(Class)cls uid:(NSString *)uid;


/**
 判断本地存储的数据库中的表元素和cls模型类中的元素是否不同，是否需要跟新

 @param cls 模型类
 @param uid 用户标识
 @return 判断本地存储的数据库中的表元素和cls模型类中的元素是否不同，是否需要跟新
 */
+ (BOOL)revan_isTableRequiredUpdate:(Class)cls uid:(NSString *)uid;

/**
 跟新本地存储的数据库中的表内容是否成功

 @param cls 模型类
 @param uid 用户标识
 @return 更新是否成功
 */
+ (BOOL)revan_updateTable:(Class)cls uid:(NSString *)uid;


#pragma mark - 保存更新 模型对象
/**
 保存或者更新模型对象

 @param model 模型对象
 @param uid 用户标识
 @return 保存或者更新是否成功
 */
+ (BOOL)revan_saveOrUpdateModel:(id)model uid:(NSString *)uid;

#pragma mark - 删除操作
/**
 删除指定模型对象

 @param model 模型对象
 @param uid 用户标识
 @return 删除是否成功
 */
+ (BOOL)revan_deleteModel:(id)model uid:(NSString *)uid;


/**
 删除表中指定条件内容

 @param cls 模型类
 @param name 删除属性
 @param relation 条件关系
 @param value 删除条件
 @param uid 用户标识
 @return 删除是否成功
 */
+ (BOOL)revan_deleteModelClass:(Class)cls memberName:(NSString *)name relation:(RevanDBMemberNameToValueRelationType)relation value:(id)value uid:(NSString *)uid;

/**
 自定义SQL语句来执行删除命令 （要会使用SQL语句）

 @param sql SQL的删除语句
 @param uid 用户标识
 @return 删除是否成功
 */
+ (BOOL)revan_deleteWithSql:(NSString *)sql uid:(NSString *)uid;

#pragma mark - 查询操作

/**
 查询表中所有的数据

 @param cls 模型类
 @param uid 用户标识
 @return 表中存储的信息（Class模型数组）
 */
+ (NSArray *)revan_queryAllModelsWithClass:(Class)cls uid:(NSString *)uid;

/**
 根据条件来查询表中所有的数据

 @param cls 模型类
 @param name 条件查询的属性
 @param relation 条件查询的关系
 @param value 与条件查询属性向比较的值
 @param uid 用户标识
 @return 表中存储的信息（Class模型数组）
 */
+ (NSArray *)revan_queryModelsWithClass:(Class)cls memberName:(NSString *)name relation:(RevanDBMemberNameToValueRelationType)relation value:(id)value uid:(NSString *)uid;

/**
 通过使用SQL语句查询表中所有的数据

 @param cls 模型类
 @param sql 查询的SQL语句
 @param uid 用户标识
 @return 表中存储的信息（Class模型数组）
 */
+ (NSArray *)revan_queryModelsWithClass:(Class)cls WithSql:(NSString *)sql uid:(NSString *)uid;

@end
