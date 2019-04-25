//
//  RevanFileManager.m
//  RevanFunctionModule_Example
//
//  Created by 紫荆秋雪 on 2018/3/6.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import "RevanFileManager.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
#define kTmpPath NSTemporaryDirectory()

@implementation RevanFileManager

+ (NSString *)revan_contentType:(NSURL *)url {
    NSString *path = [self revan_cacheFilePath:url];
    NSString *fileExtension = path.pathExtension;
    
    CFStringRef contentTypeCF = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef _Nonnull)(fileExtension), NULL);
    NSString *contentType = CFBridgingRelease(contentTypeCF);
    
    return contentType;
}

+ (void)revan_moveTmpPathToCachePath:(NSURL *)url {
    NSString *tmpPath = [self revan_tmpFilePath:url];
    NSString *cachePath = [self revan_cacheFilePath:url];
    [[NSFileManager defaultManager] moveItemAtPath:tmpPath toPath:cachePath error:nil];
}

#pragma mark - 关于cache下的操作
+ (NSString *)revan_cacheFilePath:(NSURL *)url {
    return [kCachePath stringByAppendingPathComponent:url.lastPathComponent];
}

+ (BOOL)revan_cacheFileExists:(NSURL *)url {
    NSString *path = [self revan_cacheFilePath:url];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (long long)revan_cacheFileSize:(NSURL *)url {
    // 1.2 计算文件路径对应的文件大小
    if (![self revan_cacheFileExists:url]) {
        return 0;
    }
    // 1.1 获取文件路径
    NSString *path = [self revan_cacheFilePath:url];
    NSDictionary *fileInfoDic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    return  [fileInfoDic[NSFileSize] longLongValue];
}

#pragma mark - 关于tmp下的操作
+ (NSString *)revan_tmpFilePath:(NSURL *)url {
    return [kTmpPath stringByAppendingPathComponent:url.lastPathComponent];
}

+ (BOOL)revan_tmpFileExists:(NSURL *)url {
    NSString *path = [self revan_tmpFilePath:url];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (long long)revan_tmpFileSize:(NSURL *)url {
    // 1.2 计算文件路径对应的文件大小
    if (![self revan_tmpFileExists:url]) {
        return 0;
    }
    // 1.1 获取文件路径
    NSString *path = [self revan_tmpFilePath:url];
    NSDictionary *fileInfoDic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    return  [fileInfoDic[NSFileSize] longLongValue];
}

+ (void)revan_clearTmpFile:(NSURL *)url {
    NSString *tmpPath = [self revan_tmpFilePath:url];
    BOOL isDirectory = YES;
    BOOL isEx = [[NSFileManager defaultManager] fileExistsAtPath:tmpPath isDirectory:&isDirectory];
    if (isEx && !isDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
    }
}

@end
