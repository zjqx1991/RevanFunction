//
//  RevanDownLoaderManager.h
//  RevanFunctionModule_Example
//
//  Created by 紫荆秋雪 on 2018/2/10.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RevanDownLoader.h"

@interface RevanDownLoaderManager : NSObject

/**
 下载器管理工具类
 */
+ (instancetype)instanceDownLoaderManager;

/** 根据URL下载资源 */
- (RevanDownLoader *)revan_downLoadWithURL: (NSURL *)url;

/** 获取url对应的downLoader */
- (RevanDownLoader *)revan_fetchDownLoaderWithURL: (NSURL *)url;

/**
 下载资源
 
 @param url 资源路径
 @param infoBlock 资源大小
 @param statusChangeBlock 下载器状态改变
 @param progressBlock 进度条改变
 @param successBlock 成功Block
 @param faildBlock 失败Block
 */
- (void)revan_downLoaderWithUrl:(NSURL *)url
                 downLoaderInfo:(RevanDownLoaderInfoBlock)infoBlock
                   statusChange:(RevanDownLoaderStatusChangeBlock)statusChangeBlock
                       progress:(RevanDownLoaderProgressBlock)progressBlock
                        success:(RevanDownLoaderSuccessBlock)successBlock
                          faild:(RevanDownLoaderFaildBlock)faildBlock;


/**
 暂停对应url下载

 @param url url
 */
- (void)revan_pauseWithURL:(NSURL *)url;
/**
 继续下载对应url

 @param url url
 */
- (void)revan_resumeWithURL:(NSURL *)url;
/**
 取消对应url下载

 @param url url
 */
- (void)revan_cancelWithURL:(NSURL *)url;

/**
 暂停所有下载
 */
- (void)revan_pauseAll;
/**
 继续全部下载
 */
- (void)revan_resumeAll;

@end
