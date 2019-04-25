//
//  RevanFileManager.h
//  RevanFunction_Example
//
//  Created by 紫荆秋雪 on 2018/3/6.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RevanFileManager : NSObject



/**
 根据URL，获取资源contentType
 
 @param url 资源URL
 @return URL contentType
 */
+ (NSString *)revan_contentType:(NSURL *)url;

/**
 根据url, 从【沙盒tmp文件夹】移动到【沙盒cache文件夹】下
 
 @param url 资源URL
 */
+ (void)revan_moveTmpPathToCachePath:(NSURL *)url;

#pragma mark - 关于cache下的操作
/**
 根据url, 获取缓存文件在【沙盒cache文件夹】的路径

 @param url 资源URL
 @return 缓存文件在【沙盒cache文件夹】的路径
 */
+ (NSString *)revan_cacheFilePath:(NSURL *)url;

/**
 根据URL，获取资源在【沙盒cache文件夹】下是否存在
 
 @param url 资源URL
 @return 资源在【沙盒cache文件夹】下是否存在
 */
+ (BOOL)revan_cacheFileExists:(NSURL *)url;

/**
 根据URL，获取资源在【沙盒cache文件夹】下的大小

 @param url 资源URL
 @return 资源在【沙盒cache文件夹】下的大小
 */
+ (long long)revan_cacheFileSize:(NSURL *)url;

#pragma mark - 关于tmp下的操作
/**
 根据url, 获取缓存文件在【沙盒tmp文件夹】的路径
 
 @param url 资源URL
 @return 缓存文件在【沙盒tmp文件夹】的路径
 */
+ (NSString *)revan_tmpFilePath:(NSURL *)url;

/**
 根据URL，获取资源在【沙盒tmp文件夹】下是否存在
 
 @param url 资源URL
 @return 资源在【沙盒tmp文件夹】下是否存在
 */
+ (BOOL)revan_tmpFileExists:(NSURL *)url;

/**
 根据URL，获取资源在【沙盒tmp文件夹】下的大小
 
 @param url 资源URL
 @return 资源在【沙盒tmp文件夹】下的大小
 */
+ (long long)revan_tmpFileSize:(NSURL *)url;

/**
 根据URL，清除在【沙盒tmp文件夹】下的内容

 @param url 资源URL
 */
+ (void)revan_clearTmpFile:(NSURL *)url;


@end
