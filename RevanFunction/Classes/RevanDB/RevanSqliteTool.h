//
//  RevanSqliteTool.h
//  RevanFunctionModule_Example
//
//  Created by 紫荆秋雪 on 2018/3/12.
//  Copyright © 2018年 Revan. All rights reserved.
//  对 Sqlite的封装

#import <Foundation/Foundation.h>

@interface RevanSqliteTool : NSObject

// 用户机制
// uid : nil  common.db
// uid: zhangsan  zhangsan.db

/**
 Sqlite 的执行语句

 @param sql SQL语句
 @param uid 用户标识
 @return 执行是否成功
 */
+ (BOOL)revan_deal:(NSString *_Nonnull)sql uid:(NSString *_Nullable)uid;


/**
 字典(一行记录)组成的数组

 @param sql SQL语句
 @param uid 用户标识
 @return 字典(一行记录)组成的数组
 */
+ (NSMutableArray <NSMutableDictionary *>*_Nullable)revan_querySql:(NSString *_Nonnull)sql uid:(NSString *_Nullable)uid;


/**
 sqls中的语句是否都执行成功

 @param sqls SQL语句集
 @param uid 用户标识
 @return 通过事务来判断SQL集合是否都执行成功
 */
+ (BOOL)revan_dealSqls:(NSArray <NSString *>*_Nullable)sqls uid:(NSString *_Nullable)uid;
@end
