//
//  RevanSqliteTool.m
//  RevanFunction_Example
//
//  Created by 紫荆秋雪 on 2018/3/12.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import "RevanSqliteTool.h"
#import "sqlite3.h"


#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject


@implementation RevanSqliteTool

sqlite3 *ppDb = nil;

+ (BOOL)revan_deal:(NSString *_Nonnull)sql uid:(NSString *_Nullable)uid {
    //1.打开数据库
    if (![self openDB:uid]) {
        NSLog(@"打开数据库失败%s", __func__);
        return NO;
    }
    //2.执行语句
    BOOL result = sqlite3_exec(ppDb, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
    //3.关闭数据库
    [self closeDB];
    return result;
}


+ (NSMutableArray <NSMutableDictionary *>*_Nullable)revan_querySql:(NSString *_Nonnull)sql uid:(NSString *_Nullable)uid {
    // 1、打开数据库
    [self openDB:uid];
    // 2、准备语句(预处理语句)
    
    // 2.1、创建准备语句
    // 参数1: 一个已经打开的数据库
    // 参数2: 需要中的sql
    // 参数3: 参数2取出多少字节的长度 -1 自动计算 \0
    // 参数4: 准备语句
    // 参数5: 通过参数3, 取出参数2的长度字节之后, 剩下的字符串
    sqlite3_stmt *ppStmt = nil;
    if (sqlite3_prepare_v2(ppDb, sql.UTF8String, -1, &ppStmt, nil) != SQLITE_OK) {
        NSLog(@"准备语句编译失败");
        return nil;
    }
    
    // 3、执行
    // 3.1、创建一个数组
    NSMutableArray *arrayM = [NSMutableArray array];
    while (sqlite3_step(ppStmt) == SQLITE_ROW) {
        // 一行记录 = 字典
        // 1.获取所有列的个数
        int columnCount = sqlite3_column_count(ppStmt);
        
        // 2.创建可变数组
        NSMutableDictionary *rowDict = [NSMutableDictionary dictionary];
        [arrayM addObject:rowDict];
        
        // 3.遍历所有的列
        for (int i = 0; i < columnCount; i++) {
            //3.1 获取列名
            const char *columnName_C = sqlite3_column_name(ppStmt, i);
            NSString *columnName = [NSString stringWithUTF8String:columnName_C];
            
            //3.2 获取列值
            // 不同列的类型，使用不同的函数，进行获取
            // 3.2.1 获取列的类型
            int type = sqlite3_column_type(ppStmt, i);
            // 3.2.2 根据列的类型，使用不同的函数，进行获取
            id value = nil;
            
            switch (type) {
                case SQLITE_INTEGER:
                    value = @(sqlite3_column_int(ppStmt, i));
                    break;
                case SQLITE_FLOAT:
                    value = @(sqlite3_column_double(ppStmt, i));
                    break;
                case SQLITE_BLOB:
                    value = CFBridgingRelease(sqlite3_column_blob(ppStmt, i));
                    break;
                case SQLITE_NULL:
                    value = @"";
                    break;
                case SQLITE3_TEXT:
                    value = [NSString stringWithUTF8String: (const char *)sqlite3_column_text(ppStmt, i)];
                    break;
                    
                default:
                    break;
            }
            [rowDict setValue:value forKey:columnName];
        }
    }
    
    // 4.释放资源
    sqlite3_finalize(ppStmt);
    // 5.关闭数据库
    [self closeDB];
    return arrayM;
}

/**
 sqls中的语句是否都执行成功
 
 @param sqls SQL语句集
 @param uid 用户标识
 @return 通过事务来判断SQL集合是否都执行成功
 */
+ (BOOL)revan_dealSqls:(NSArray <NSString *>*_Nullable)sqls uid:(NSString *_Nullable)uid {
    [self beginTransaction:uid];
    
    for (NSString *sql in sqls) {
        BOOL result = [self revan_deal:sql uid:uid];
        if (result == NO) {
            [self rollBackTransaction:uid];
            return NO;
        }
    }
    
    [self commitTransaction:uid];
    return YES;
}

#pragma mark - 私有方法
+ (void)beginTransaction:(NSString *)uid {
    [self revan_deal:@"begin transaction" uid:uid];
}

+ (void)commitTransaction:(NSString *)uid {
    [self revan_deal:@"commit transaction" uid:uid];
}
+ (void)rollBackTransaction:(NSString *)uid {
    [self revan_deal:@"rollback transaction" uid:uid];
}

/**
 打开数据库

 @param uid 用户标识
 @return @return 打开数据库
 */
+ (BOOL)openDB:(NSString *)uid {
    NSString *dbName = @"common.sqlite";
    if (uid.length != 0) {
        dbName = [NSString stringWithFormat:@"%@.sqlite", uid];
    }
    NSString *dbPath = [kCachePath stringByAppendingPathComponent:dbName];
    return sqlite3_open(dbPath.UTF8String, &ppDb) == SQLITE_OK;
}

/**
 关闭数据库
 */
+ (void)closeDB {
    sqlite3_close(ppDb);
}

@end
