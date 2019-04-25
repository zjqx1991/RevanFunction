//
//  RevanDownLoadFileTool.m
//  RevanFunction_Example
//
//  Created by 紫荆秋雪 on 2018/2/8.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import "RevanDownLoadFileTool.h"

@implementation RevanDownLoadFileTool

/**
 文件在这个路径下是否存在
 
 @param filePath 存储文件的路径
 @return 文件在这个路径下是否存在
 */
+ (BOOL)fileExists:(NSString *)filePath {
    if (filePath.length == 0) {
        return NO;
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}


/**
 filePath路径下文件的大小
 
 @param filePath 存储文件的路径
 @return filePath路径下文件的大小
 */
+ (long long)fileSize:(NSString *)filePath {
    if (![self fileExists:filePath]) {
        return 0.0f;
    }
    NSDictionary *dictInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    return [dictInfo[NSFileSize] longLongValue];
}

/**
 移动文件
 
 @param fromPath 当前路径
 @param toPath 目标路径
 @return 移动是否成功
 */
+ (BOOL)moveFile:(NSString *)fromPath toPath:(NSString *)toPath {
    
    if (![self fileExists:fromPath]) {
        return NO;
    }
    return [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:nil];
}

/**
 删除文件
 
 @param filePath 删除 filePath 路径下的文件
 */
+ (BOOL)removeFile:(NSString *)filePath {
    
    if (![self fileExists:filePath]) {
        return NO;
    }
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

@end
