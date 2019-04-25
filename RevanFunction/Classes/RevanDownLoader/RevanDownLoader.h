//
//  RevanDownLoader.h
//  RevanFunctionModule_Example
//
//  Created by 紫荆秋雪 on 2018/2/8.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 状态变化通知 */
#define kRevanDownLoadURLOrStateChangeNotification @"downLoadURLOrStateChangeNotification"
/** 下载器URL */
#define kRevanDownLoad_URL @"downLoadURL"
/** 下载器状态 */
#define kRevanDownLoad_STATUS @"downLoadSTATUS"

typedef NS_ENUM(NSUInteger, RevanDownLoadStatus) {
    RevanDownLoadStatusPause,
    RevanDownLoadStatusDownLoading,
    RevanDownLoadStatusSuccess,
    RevanDownLoadStatusFailed
};

/** 资源大小 */
typedef void(^RevanDownLoaderInfoBlock)(long long totalSize);
/** 下载器状态Block */
typedef void(^RevanDownLoaderStatusChangeBlock)(RevanDownLoadStatus status);
/** 下载器下载进度Block */
typedef void(^RevanDownLoaderProgressBlock)(CGFloat progress);
/** 下载成功Block */
typedef void(^RevanDownLoaderSuccessBlock)(NSString *downLoadPath);
/** 下载失败 */
typedef void(^RevanDownLoaderFaildBlock)();


@interface RevanDownLoader : NSObject
#pragma mark - public 接口
/**
 下载资源

 @param url 资源路径
 @param infoBlock 资源大小
 @param statusChangeBlock 下载器状态改变
 @param progressBlock 进度条改变
 @param successBlock 成功Block
 @param faildBlock 失败Block
 */
- (void)downLoaderWithUrl:(NSURL *)url downLoaderInfo:(RevanDownLoaderInfoBlock) infoBlock statusChange:(RevanDownLoaderStatusChangeBlock) statusChangeBlock progress:(RevanDownLoaderProgressBlock) progressBlock success:(RevanDownLoaderSuccessBlock) successBlock faild:(RevanDownLoaderFaildBlock) faildBlock;
/**
 下载资源
 
 @param url 资源路径
 */
- (void)downLoaderWithUrl:(NSURL *)url;

/** url资源文件，沙盒文件路径 */
+ (NSString *)downLoadedFileWithURL: (NSURL *)url;
/** url资源文件，临时文件中的大小 */
+ (long long)tmpCacheSizeWithURL: (NSURL *)url;
/** 清空url资源文件 */
+ (void)clearCacheWithURL: (NSURL *)url;


/**
 暂停任务
 注意:
 - 如果调用了几次继续
 - 调用几次暂停, 才可以暂停
 - 解决方案: 引入状态
 */
- (void)pauseCurrentTask;
/**
 继续任务
 - 如果调用了几次暂停, 就要调用几次继续, 才可以继续
 - 解决方案: 引入状态
 */
- (void)resumeCurrentTask;

/**
 取消任务
 */
- (void)cancelCurrentTask;

/**
 取消任务, 并清理资源
 */
- (void)cancelAndClean;

#pragma mark - 数据
/** 下载器状态 */
@property (nonatomic, assign, readonly) RevanDownLoadStatus status;
/** 下载器进度 */
@property (nonatomic, assign, readonly) CGFloat progress;

/** 资源大小 */
@property (nonatomic, copy) RevanDownLoaderInfoBlock infoBlock;
/** 下载器状态 */
@property (nonatomic, copy) RevanDownLoaderStatusChangeBlock statusChangeBlock;
/** 下载器进度 */
@property (nonatomic, copy) RevanDownLoaderProgressBlock progressBlock;
/** 下载成功 */
@property (nonatomic, copy) RevanDownLoaderSuccessBlock successBlock;
/** 下载失败 */
@property (nonatomic, copy) RevanDownLoaderFaildBlock faildBlock;

@end
