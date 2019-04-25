//
//  RevanDB.m
//  RevanFunctionModule_Example
//
//  Created by 紫荆秋雪 on 2018/3/12.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import "RevanDB.h"
#import "RevanModelTool.h"
#import "RevanSqliteTool.h"
#import "RevanSqliteTableTool.h"

@implementation RevanDB
/**
 通过类Class来创建表
 
 @param cls 模型类
 @param uid 用户唯一表示
 @return 创表是否成功
 */
+ (BOOL)revan_createTable:(Class)cls uid:(NSString *)uid {
    //create table if not exists 表名(字段1 字段1类型, 字段2 字段2类型 (约束),...., primary key(字段))
    //1.获取表明
    NSString *tableName = [RevanModelTool revan_tableNameWithModelClass:cls];
    
    if (![cls respondsToSelector:@selector(revan_primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    };
    
    //获取主键
    NSString *primaryKey = [cls revan_primaryKey];
    // 1.2 获取一个模型里面所有的字段, 以及类型
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@))", tableName, [RevanModelTool revan_columnNamesAndTypesStrWithModelClass:cls], primaryKey];
    
    //2.执行
    return [RevanSqliteTool revan_deal:createTableSql uid:uid];
}


/**
 判断本地存储的数据库中的表元素和cls模型类中的元素是否不同，是否需要跟新
 
 @param cls 模型类
 @param uid 用户标识
 @return 判断本地存储的数据库中的表元素和cls模型类中的元素是否不同，是否需要跟新
 */
+ (BOOL)revan_isTableRequiredUpdate:(Class)cls uid:(NSString *)uid {
    //本地数据库中表的元素
    NSArray *tableNames = [RevanSqliteTableTool revan_fetchSqliteTableSortedColumnNamesWithClass:cls uid:uid];
    NSArray *moduleNames = [RevanModelTool revan_allClassSortedIvarNamesWithClass:cls];
    return ![tableNames isEqualToArray:moduleNames];
}


/**
 跟新本地存储的数据库中的表内容是否成功
 
 @param cls 模型类
 @param uid 用户标识
 @return 更新是否成功
 */
+ (BOOL)revan_updateTable:(Class)cls uid:(NSString *)uid {
    // 1. 创建一个拥有正确结构的临时表
    // 1.1 获取表格名称
    NSString *tmpTableName = [NSString stringWithFormat:@"%@_tmp", [RevanModelTool revan_tableNameWithModelClass:cls]];
    NSString *tableName = [RevanModelTool revan_tableNameWithModelClass:cls];
    
    if (![cls respondsToSelector:@selector(revan_primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)revan_primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    NSMutableArray *execSqls = [NSMutableArray array];
    NSString *primaryKey = [cls revan_primaryKey];
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@));", tmpTableName, [RevanModelTool revan_columnNamesAndTypesStrWithModelClass:cls], primaryKey];
    [execSqls addObject:createTableSql];
    // 2. 根据主键, 插入数据
    // insert into xmgstu_tmp(stuNum) select stuNum from xmgstu;
    NSString *insertPrimaryKeyData = [NSString stringWithFormat:@"insert into %@(%@) select %@ from %@;", tmpTableName, primaryKey, primaryKey, tableName];
    [execSqls addObject:insertPrimaryKeyData];
    // 3. 根据主键, 把所有的数据更新到新表里面
    NSArray *oldNames = [RevanSqliteTableTool revan_fetchSqliteTableSortedColumnNamesWithClass:cls uid:uid];
    NSArray *newNames = [RevanModelTool revan_allClassSortedIvarNamesWithClass:cls];
    
    // 4.获取更名字典
    NSDictionary *newMemberTo_oldMemberDic = @{};
    if ([cls respondsToSelector:@selector(revan_newMemberToOldMemberDic)]) {
        newMemberTo_oldMemberDic = [cls revan_newMemberToOldMemberDic];
    }
    
    for (NSString *columnName in newNames) {
        //寻找需要修改属性名
        NSString *oldName  = columnName;
        if ([newMemberTo_oldMemberDic[columnName] length] != 0) {
            oldName = newMemberTo_oldMemberDic[columnName];
        }
        //属性 或者 属性对应的就属性值 都不在
        BOOL contain = ![oldNames containsObject:columnName] && ![oldNames containsObject:oldName];
        //主Key
        BOOL isPrimaryKey = [columnName isEqualToString:primaryKey];
        if (contain || isPrimaryKey) {
            continue;
        }
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ = %@.%@)", tmpTableName, columnName, oldName, tableName, tmpTableName, primaryKey, tableName, primaryKey];
        [execSqls addObject:updateSql];
    }
    
    NSString *deleteOldTable = [NSString stringWithFormat:@"drop table if exists %@", tableName];
    [execSqls addObject:deleteOldTable];
    
    NSString *renameTableName = [NSString stringWithFormat:@"alter table %@ rename to %@", tmpTableName, tableName];
    [execSqls addObject:renameTableName];
    return [RevanSqliteTool revan_dealSqls:execSqls uid:uid];
}


/**
 保存或者更新模型对象
 
 @param model 模型对象
 @param uid 用户标识
 @return 保存或者更新是否成功
 */
+ (BOOL)revan_saveOrUpdateModel:(id)model uid:(NSString *)uid {
    //1.把模型对象转换成功类对象
    Class cls = [model class];
    //2.判断cls表是否存在
    if (![RevanSqliteTableTool revan_isTableExists:cls uid:uid]) {
        //不存在，就重新创建一个cls对应的表
        [self revan_createTable:cls uid:uid];
    }
    
    //3.检测表示是否需要更新，需要，更新
    if ([self revan_isTableRequiredUpdate:cls uid:uid]) {
        //更新表
        [self revan_updateTable:cls uid:uid];
    }
    
    //4.根据主键，判断记录是否存在
    //4.1、从表格里，按照主键 进行查找该记录
    NSString *tableName = [RevanModelTool revan_tableNameWithModelClass:cls];
    
    //判断是否实现了主键协议
    if (![cls respondsToSelector:@selector(revan_primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)revan_primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    //主键key
    NSString *primaryKey = [cls revan_primaryKey];
    //主键值
    NSString *primaryValue = [model valueForKeyPath:primaryKey];
    //
    NSString *checkSql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", tableName, primaryKey, primaryValue];
    NSArray *result = [RevanSqliteTool revan_querySql:checkSql uid:uid];
    
    //获取模型字段数组
    NSArray *columnNames = [RevanModelTool revan_classIvarMemberAndTypeWithModelClass:cls].allKeys;
    
    //获取模型值的数组
    // model keyPath:
    NSMutableArray *values = [NSMutableArray array];
    for (NSString *columnName in columnNames) {
        id value = [model valueForKeyPath:columnName];
        // 针对存储的是 数组或者字典要转化成字符串后来存储
        if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            // 在这里, 把字典或者数组, 处理成为一个字符串, 保存到数据库里面去
            
            // 字典/数组 -> data
            NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
            
            // data -> nsstring
            value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        [values addObject:value];
    }
    
    //拼接需要执行SQL语句
    NSString *execSql = @"";
    if (result.count > 0) {
        // 更新
        // 字段名称, 字段值
        // update 表名 set 字段1=字段1值,字段2=字段2的值... where 主键 = '主键值'
        NSInteger count = columnNames.count;
        NSMutableArray *setValueArray = [NSMutableArray array];
        for (int i = 0; i < count; i++) {
            NSString *name = columnNames[i];
            id value = values[i];
            NSString *setStr = [NSString stringWithFormat:@"%@='%@'", name, value];
            [setValueArray addObject:setStr];
        }
        execSql = [NSString stringWithFormat:@"update %@ set %@  where %@ = '%@'", tableName, [setValueArray componentsJoinedByString:@","], primaryKey, primaryValue];
    }
    else {
        // insert into 表名(字段1, 字段2, 字段3) values ('值1', '值2', '值3')
        // '   值1', '值2', '值3   '
        // 插入
        // text sz 'sz' 2 '2'
        execSql = [NSString stringWithFormat:@"insert into %@(%@) values('%@')", tableName, [columnNames componentsJoinedByString:@","], [values componentsJoinedByString:@"','"]];
    }
    
    return [RevanSqliteTool revan_deal:execSql uid:uid];
}


/**
 删除指定模型对象
 
 @param model 模型对象
 @param uid 用户标识
 @return 删除是否成功
 */
+ (BOOL)revan_deleteModel:(id)model uid:(NSString *)uid {
    //1.获取类对象
    Class cls = [model class];
    //2.获取表名
    NSString *tableName = [RevanModelTool revan_tableNameWithModelClass:cls];
    //3.判断主键
    if (![cls respondsToSelector:@selector(revan_primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)revan_primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    NSString *primaryKey = [cls revan_primaryKey];
    id primaryValue = [model valueForKeyPath:primaryKey];
    //4.拼接SQL语句
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'", tableName, primaryKey, primaryValue];
    return [RevanSqliteTool revan_deal:deleteSql uid:uid];
}

/**
 删除表中指定条件内容
 
 @param cls 模型类
 @param name 删除属性
 @param relation 条件关系
 @param value 删除条件
 @param uid 用户标识
 @return 删除是否成功
 */
+ (BOOL)revan_deleteModelClass:(Class)cls memberName:(NSString *)name relation:(RevanDBMemberNameToValueRelationType)relation value:(id)value uid:(NSString *)uid {
    
    NSArray *tableMemberNames = [RevanSqliteTableTool revan_fetchSqliteTableSortedColumnNamesWithClass:cls uid:uid];
    if (![tableMemberNames containsObject:name]) {
        NSLog(@"传入的%@不合法", name);
        return NO;
    }
    //1.获取表名
    NSString *tableName = [RevanModelTool revan_tableNameWithModelClass:cls];
    //2.拼接删除语句
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ %@ '%@'", tableName, name, [self memberToValueRelationTypeDic][@(relation)], value];
    return [RevanSqliteTool revan_deal:deleteSql uid:uid];
}



/**
 自定义SQL语句来执行删除命令
 
 @param sql SQL的删除语句
 @param uid 用户标识
 @return 删除是否成功
 */
+ (BOOL)revan_deleteWithSql:(NSString *)sql uid:(NSString *)uid {
    return [RevanSqliteTool revan_deal:sql uid:uid];
}


#pragma mark - 查询操作

/**
 查询表中所有的数据
 
 @param cls 模型类
 @param uid 用户标识
 @return 表中存储的信息（Class模型数组）
 */
+ (NSArray *)revan_queryAllModelsWithClass:(Class)cls uid:(NSString *)uid {
    //1.获取表名
    NSString *tableName = [RevanModelTool revan_tableNameWithModelClass:cls];
    //2.拼接查询的SQL语句
    NSString *sql = [NSString stringWithFormat:@"select * from %@", tableName];
    //3.执行查询语句
    // key value
    // 模型的属性名称, 和属性值
    NSArray <NSDictionary *>*results = [RevanSqliteTool revan_querySql:sql uid:uid];
    return [self handleResults:results withClass:cls];
}

/**
 根据条件来查询表中所有的数据
 
 @param cls 模型类
 @param name 条件查询的属性
 @param relation 条件查询的关系
 @param value 与条件查询属性向比较的值
 @param uid 用户标识
 @return 表中存储的信息（Class模型数组）
 */
+ (NSArray *)revan_queryModelsWithClass:(Class)cls memberName:(NSString *)name relation:(RevanDBMemberNameToValueRelationType)relation value:(id)value uid:(NSString *)uid {
    //1.表名
    NSString *tableName = [RevanModelTool revan_tableNameWithModelClass:cls];
    //2. 拼接sql语句
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ %@ '%@' ", tableName, name, self.memberToValueRelationTypeDic[@(relation)], value];
    
    
    // 2. 查询结果集
    NSArray <NSDictionary *>*results = [RevanSqliteTool revan_querySql:sql uid:uid];
    
    return [self handleResults:results withClass:cls];
}


/**
 通过使用SQL语句查询表中所有的数据
 
 @param cls 模型类
 @param sql 查询的SQL语句
 @param uid 用户标识
 @return 表中存储的信息（Class模型数组）
 */
+ (NSArray *)revan_queryModelsWithClass:(Class)cls WithSql:(NSString *)sql uid:(NSString *)uid {
    //1. 查询结果集
    NSArray <NSDictionary *>*results = [RevanSqliteTool revan_querySql:sql uid:uid];
    return [self handleResults:results withClass:cls];
}

#pragma mark - 私有方法

/**
 转化成模型数组
 */
+ (NSArray *)handleResults:(NSArray <NSDictionary *>*)results withClass:(Class)cls {
    
    //1. 处理查询的结果集 -> 模型数组
    NSMutableArray *models = [NSMutableArray array];
    //2.获取模型中的属性和类型组成的字典
    NSDictionary *memberNameTypeDic = [RevanModelTool revan_classIvarMemberAndTypeWithModelClass:cls];
    
    for (NSDictionary *modelDic in results) {
        id model = [[cls alloc] init];
        [models addObject:model];
        
        //处理是字典或者是数组
        [modelDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            //3.获取模型中存储的类型
            NSString *type = memberNameTypeDic[key];
            
            id resultValue = obj;
            
            // NSArray
            // NSMutableArray
            // NSDictionary
            // NSMutableDictionary
            // 3.1处理不可变数组
            if ([type isEqualToString:@"NSArray"] || [type isEqualToString:@"NSDictionary"]) {
                // 字符串 ->
                NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
                resultValue = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            }
            else if ([type isEqualToString:@"NSMutableArray"] || [type isEqualToString:@"NSMutableDictionary"]) {
                NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
                resultValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            }
            [model setValue:resultValue forKeyPath:key];
        }];
    }
    
    return models;
}

/**
 删除关系映射

 @return 删除映射的条件
 */
+ (NSDictionary *)memberToValueRelationTypeDic {
    return @{
             @(RevanDBMemberNameToValueRelationTypeMore):@">",
             @(RevanDBMemberNameToValueRelationTypeLess):@"<",
             @(RevanDBMemberNameToValueRelationTypeEqual):@"=",
             @(RevanDBMemberNameToValueRelationTypeMoreEqual):@">=",
             @(RevanDBMemberNameToValueRelationTypeLessEqual):@"<="
             };
}

@end
