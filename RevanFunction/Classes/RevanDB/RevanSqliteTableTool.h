//
//  RevanSqliteTableTool.h
//  RevanFunction_Example
//
//  Created by 紫荆秋雪 on 2018/3/14.
//  Copyright © 2018年 Revan. All rights reserved.
//


/** 说明
    处理数据库，把已有的数据库中的表的每一列元素取出
 */

#import <Foundation/Foundation.h>

@interface RevanSqliteTableTool : NSObject

/**
 获取cls表中的所有列的元素

 @param cls 模型类
 @param uid 用户唯一标识
 @return 排好序的表的所有列的元素
 */
+ (NSArray *)revan_fetchSqliteTableSortedColumnNamesWithClass:(Class)cls uid:(NSString *)uid;

/**
 判断本地表格是否存在

 @param cls 模型类
 @param uid 用户标识（数据库）
 @return 表格是否存在数据库中
 */
+ (BOOL)revan_isTableExists:(Class)cls uid:(NSString *)uid;
@end
