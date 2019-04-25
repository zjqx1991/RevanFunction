//
//  RevanDBProtocol.h
//  RevanFunctionModule_Example
//
//  Created by 紫荆秋雪 on 2018/3/13.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RevanDBProtocol <NSObject>
@required
/**
 告诉要存储的模型的主键

 @return 主键
 */
+ (NSString *)revan_primaryKey;


@optional
/**
 忽略模型中的成员变量

 @return 不希望存储的成员变量
 */
+ (NSArray *)revan_ignoreColumnNames;


/**
 修改属性名称需要遵守的协议
 新字段名称-> 旧的字段名称的映射表格
 
 @return 映射表格
 */
+ (NSDictionary *)revan_newMemberToOldMemberDic;

@end
