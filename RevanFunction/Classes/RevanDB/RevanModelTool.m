//
//  RevanModelTool.m
//  RevanFunctionModule_Example
//
//  Created by 紫荆秋雪 on 2018/3/12.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import "RevanModelTool.h"
#import <objc/runtime.h>
#import "RevanDBProtocol.h"

@implementation RevanModelTool

/**
 获取表名
 
 @param cls 模型类
 @return 通过模型获得的表名
 */
+ (NSString *)revan_tableNameWithModelClass:(Class)cls {
    return NSStringFromClass(cls);
}

/**
 所有的【成员变量】, 以及【成员变量】对应的类型
 
 @param cls 模型类
 @return 模型类所有的【成员变量】, 以及【成员变量】对应的类型
 */
+ (NSDictionary *)revan_classIvarMemberAndTypeWithModelClass:(Class)cls {
    // 获取这个类里面，所有的 成员变量 以及 类型
    //1.成员变量个数
    unsigned int outCount = 0;
    //2.通过运行时获取类里面的 成员变量
    Ivar *varList = class_copyIvarList(cls, &outCount);
    
    
    //定义存储字典
    NSMutableDictionary *name_type_dict = [NSMutableDictionary dictionary];
    //获取需要忽略的成员变量
    NSArray *ignoreArray = nil;
    if ([cls respondsToSelector:@selector(revan_ignoreColumnNames)]) {
        ignoreArray = [cls revan_ignoreColumnNames];
    }
    
    //3.通过循环遍历 varList 来获取成员变量以及其类型
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = varList[i];
        
        //3.1 获取成员变量名称
        NSString *ivar_name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        //去掉【属性】的下划线
        if ([ivar_name hasPrefix:@"_"]) {
            ivar_name = [ivar_name substringFromIndex:1];
        }
        
        //忽略字段
        if ([ignoreArray containsObject:ivar_name]) {
            continue;
        }
        
        //3.2 获取成员变量的类型
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        type = [type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        
        //3.3用 成员变量的名称 作为key 存储 成员变量的类型
        [name_type_dict setValue:type forKey:ivar_name];
    }
    return name_type_dict;
}

/**
 所有的成员变量, 以及成员变量映射到数据库里面对应的类型
 
 @param cls 模型类
 @return 所有的成员变量, 以及成员变量映射到数据库里面对应的类型
 */
+ (NSDictionary *)revan_classIvarNameSqliteTypeDicWithModelClass:(Class)cls {
    //1、获取 模型类 中 名称和类型对应的字典
    NSMutableDictionary *dictM = [[self revan_classIvarMemberAndTypeWithModelClass:cls] mutableCopy];
    //2、因为模型中的成员变量的类型，和数据库中使用的类型不一样，所以不能直接存储，需要转换
    NSDictionary *sqliteTypeDict = [self ocTypeTo_SqliteTypeDict];
    
    //3、通过遍历字典来替换字典中的OC类型
    [dictM enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        dictM[key] = sqliteTypeDict[obj];
    }];
    return dictM;
}

/**
 把模型所有的成员变量, 以及成员变量类型映射到数据库里面对应的类型，一对一对组成一个字符串
 
 @param cls 模型类
 @return 把模型所有的成员变量, 以及成员变量类型映射到数据库里面对应的类型，一对一对组成一个字符串
 */
+ (NSString *)revan_columnNamesAndTypesStrWithModelClass:(Class)cls {
    //1、获取 成员变量名 成员变量类型(数据库存储类型)的字典
    NSDictionary *name_type_dict = [self revan_classIvarNameSqliteTypeDicWithModelClass:cls];
    NSMutableArray *arrayM = [NSMutableArray array];
    [name_type_dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        //把成员变量名 和 成员变量类型 组成一个数组的元素
        NSString *name_type = [NSString stringWithFormat:@"%@ %@", key, obj];
        [arrayM addObject:name_type];
    }];
    
    //最后把数组元素用","分隔转化成为字符串
    return [arrayM componentsJoinedByString:@","];
}


/**
 获取模型中排好序的成员变量名
 
 @param cls 模型类
 @return 模型中排好序的成员变量名
 */
+ (NSArray *)revan_allClassSortedIvarNamesWithClass:(Class)cls {
    //1、获取模型中的成员变量
    NSDictionary *dic = [self revan_classIvarMemberAndTypeWithModelClass:cls];
    NSArray *keys = dic.allKeys;
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    return keys;
}

#pragma mark - 私有方法
/**
 OC中的数据类型映射到数据库中的数据类型

 @return OC中的数据类型映射到数据库中的数据类型
 */
+ (NSDictionary *)ocTypeTo_SqliteTypeDict {
    return @{
             @"d": @"real", // double
             @"f": @"real", // float
             
             @"i": @"integer",  // int
             @"q": @"integer", // long
             @"Q": @"integer", // long long
             @"B": @"integer", // bool
             
             @"NSData": @"blob",
             @"NSDictionary": @"text",
             @"NSMutableDictionary": @"text",
             @"NSArray": @"text",
             @"NSMutableArray": @"text",
             
             @"NSString": @"text"
             };
    
}

@end
