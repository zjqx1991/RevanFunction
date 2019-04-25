//
//  RevanDownLoaderManager.m
//  RevanFunction_Example
//
//  Created by 紫荆秋雪 on 2018/2/10.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import "RevanDownLoaderManager.h"
#import "NSString+MD5.h"

@interface RevanDownLoaderManager ()<NSCopying, NSMutableCopying>
/** 多任务下载字典 */
@property (nonatomic, strong) NSMutableDictionary *downLoaderInfo;
@end

static RevanDownLoaderManager *_shareInstance;

@implementation RevanDownLoaderManager

+ (instancetype)instanceDownLoaderManager {
    if (!_shareInstance) {
        _shareInstance = [[self alloc] init];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _shareInstance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _shareInstance;
}


/**
 暂停对应url下载
 
 @param url url
 */
- (void)revan_pauseWithURL:(NSURL *)url {
    [[self achieveDownLoaderWithURL:url] pauseCurrentTask];
}
/**
 继续下载对应url
 
 @param url url
 */
- (void)revan_resumeWithURL:(NSURL *)url {
    [[self achieveDownLoaderWithURL:url] resumeCurrentTask];
}
/**
 取消对应url下载
 
 @param url url
 */
- (void)revan_cancelWithURL:(NSURL *)url {
    [[self achieveDownLoaderWithURL:url] cancelCurrentTask];
}

/**
 暂停所有下载
 */
- (void)revan_pauseAll {
    [self.downLoaderInfo.allValues makeObjectsPerformSelector:@selector(pauseCurrentTask)];
}
/**
 继续全部下载
 */
- (void)revan_resumeAll {
    [self.downLoaderInfo.allValues makeObjectsPerformSelector:@selector(resumeCurrentTask)];
}


// 根据URL下载资源
- (RevanDownLoader *)revan_downLoadWithURL: (NSURL *)url {
    NSString *md5 = [url.absoluteString revan_md5];
    
    RevanDownLoader *downLoader = self.downLoaderInfo[md5];
    if (downLoader) {
        [downLoader resumeCurrentTask];
        return downLoader;
    }
    //新建下载器
    downLoader = [[RevanDownLoader alloc] init];
    [self.downLoaderInfo setValue:downLoader forKey:md5];
    
    __weak typeof(self) weakSelf = self;
    [downLoader downLoaderWithUrl:url downLoaderInfo:nil statusChange:nil progress:nil success:^(NSString *downLoadPath) {
        [weakSelf.downLoaderInfo removeObjectForKey:md5];
    } faild:^{
        [weakSelf.downLoaderInfo removeObjectForKey:md5];
    }];
    
    return downLoader;
}

// 获取url对应的downLoader
- (RevanDownLoader *)revan_fetchDownLoaderWithURL: (NSURL *)url {
    NSString *md5 = [url.absoluteString revan_md5];
    RevanDownLoader *downLoader = self.downLoaderInfo[md5];
    return downLoader;
}

- (void)revan_downLoaderWithUrl:(NSURL *)url downLoaderInfo:(RevanDownLoaderInfoBlock)infoBlock statusChange:(RevanDownLoaderStatusChangeBlock)statusChangeBlock progress:(RevanDownLoaderProgressBlock)progressBlock success:(RevanDownLoaderSuccessBlock)successBlock faild:(RevanDownLoaderFaildBlock)faildBlock {
    //1.获取 URL --> md5
    NSString *url_md5 = [url.absoluteString revan_md5];
    //2.判断下载器中是否存在url 对应的下载器
    RevanDownLoader *downLoader = self.downLoaderInfo[url_md5];
    if (downLoader == nil) {
        //2.1 创建下载器
        downLoader = [[RevanDownLoader alloc] init];
        //2.2 记录下载器
        [self.downLoaderInfo setValue:downLoader forKey:url_md5];
    }
    //3.开始下载
    __weak typeof(self) weakSelf = self;
    [downLoader downLoaderWithUrl:url
                   downLoaderInfo:infoBlock statusChange:statusChangeBlock
                         progress:progressBlock
                          success:^(NSString *downLoadPath) {
                              //拦截下载成功block
                              //下载成功后移除记录
                              [weakSelf.downLoaderInfo removeObjectForKey:url_md5];
                              if (successBlock) {
                                  successBlock(downLoadPath);
                              }
                          } faild:^{
                              [weakSelf.downLoaderInfo removeObjectForKey:url_md5];
                              if (faildBlock) {
                                  faildBlock();
                              }
                          }];
}

#pragma mark - 私有方法
/**
 获取下载器

 @param URL URL
 */
- (RevanDownLoader *)achieveDownLoaderWithURL:(NSURL *)URL {
    //1.获取 URL --> md5
    NSString *url_md5 = [URL.absoluteString revan_md5];
    //2.判断下载器中是否存在url 对应的下载器
    return self.downLoaderInfo[url_md5];
}

#pragma mark - getter
- (NSMutableDictionary *)downLoaderInfo {
    if (!_downLoaderInfo) {
        _downLoaderInfo = [NSMutableDictionary dictionary];
    }
    return _downLoaderInfo;
}

@end
