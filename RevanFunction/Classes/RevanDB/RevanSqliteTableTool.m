//
//  RevanSqliteTableTool.m
//  RevanFunctionModule_Example
//
//  Created by 紫荆秋雪 on 2018/3/14.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import "RevanSqliteTableTool.h"
#import "RevanSqliteTool.h"
#import "RevanModelTool.h"

@implementation RevanSqliteTableTool

/**
 获取cls表中的所有列的元素
 
 @param cls 模型类
 @param uid 用户唯一标识
 @return 排好序的表的所有列的元素
 */
+ (NSArray *)revan_fetchSqliteTableSortedColumnNamesWithClass:(Class)cls uid:(NSString *)uid {
    //1、获取表名
    NSString *tableName = [RevanModelTool revan_tableNameWithModelClass:cls];
    //2、拼接出获取表tableName的SQL语句
    NSString *queryCreateSqlStr = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'", tableName];
    //3、获取表的元素和类型组成的字典
    NSMutableDictionary *dic = [RevanSqliteTool revan_querySql:queryCreateSqlStr uid:uid].firstObject;
    
    // 注意！！！把SQL语句转化成小写字母，但是会出现bug，在和模型中的成员变量进行比对的时候，由于模型中的成员变量区分大小写，这样就会出现，大小写不同而造成取不到相应的值
//    NSString *createTableSql = [dic[@"sql"] lowercaseString];
    NSString *createTableSql = dic[@"sql"];
    
    if (createTableSql.length == 0) {
        return nil;
    }
    
    createTableSql = [createTableSql stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    
    //    [[createTableSql stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:(NSStringCompareOptions) range:<#(NSRange)#>]
    
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    createTableSql = [createTableSql stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    //4、获取元素和类型组成的字符串
    NSString *nameTypeStr = [createTableSql componentsSeparatedByString:@"("][1];
    //5、在获取一个元素和类型组成一个数组的元素
    // age integer
    // stuNum integer
    // score real
    // name text
    // primary key
    NSArray *nameTypeArray = [nameTypeStr componentsSeparatedByString:@","];
    
    //6、创建一个存储表元素的的可变数组
    NSMutableArray *namesM = [NSMutableArray array];
    for (NSString *sub_nameType in nameTypeArray) {
        if ([[sub_nameType lowercaseString] containsString:@"primary"]) {
            continue;
        }
        //去掉前面的【空格】
        NSString *nameType2 = [sub_nameType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        NSString *name = [nameType2 componentsSeparatedByString:@" "].firstObject;
        [namesM addObject:name];
    }
    //7、排序
    [namesM sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    return namesM;
}


/**
 判断本地表格是否存在
 
 @param cls 模型类
 @param uid 用户标识（数据库）
 @return 表格是否存在数据库中
 */
+ (BOOL)revan_isTableExists:(Class)cls uid:(NSString *)uid {
    //1.获取表名
    NSString *tableName = [RevanModelTool revan_tableNameWithModelClass:cls];
    //2.拼接查询本地数据库中查询某一个表名的SQL
    NSString *queryCreateSqlStr = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'", tableName];
    //3.执行SQL语句
    NSMutableArray * arrayM = [RevanSqliteTool revan_querySql:queryCreateSqlStr uid:uid];
    return arrayM.count > 0;
}

@end
