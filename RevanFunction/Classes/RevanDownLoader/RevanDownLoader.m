//
//  RevanDownLoader.m
//  RevanFunctionModule_Example
//
//  Created by 紫荆秋雪 on 2018/2/8.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import "RevanDownLoader.h"
#import "RevanDownLoadFileTool.h"
#import "NSString+MD5.h"

//沙盒cache路径
#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject

//沙盒Tmp路径
#define kTmpPath NSTemporaryDirectory()


@interface RevanDownLoader ()<NSURLSessionDataDelegate> {
    long long _tmpSize;
    long long _totalSize;
}

@property (nonatomic, strong) NSURLSession *session;
/** 资源下载完在沙盒cache路径 */
@property (nonatomic, copy) NSString *downLoadedPath;
/** 资源正在下载在沙盒Tmp路径 */
@property (nonatomic, copy) NSString *downLoadingPath;
@property (nonatomic, strong) NSOutputStream *outputStream;
/** 下载任务 */
@property (nonatomic, weak) NSURLSessionDataTask *dataTask;

@property (nonatomic, weak) NSURL *url;
@end


@implementation RevanDownLoader

#pragma mark - public

- (void)downLoaderWithUrl:(NSURL *)url downLoaderInfo:(RevanDownLoaderInfoBlock)infoBlock statusChange:(RevanDownLoaderStatusChangeBlock)statusChangeBlock progress:(RevanDownLoaderProgressBlock)progressBlock success:(RevanDownLoaderSuccessBlock)successBlock faild:(RevanDownLoaderFaildBlock)faildBlock {
    [self downLoaderWithUrl:url];
    
    self.infoBlock = infoBlock;
    self.statusChangeBlock = statusChangeBlock;
    self.progressBlock = progressBlock;
    self.successBlock = successBlock;
    self.faildBlock = faildBlock;
}

/**
 下载资源
 
 @param url 资源路径
 */
- (void)downLoaderWithUrl:(NSURL *)url {
    self.url = url;
    // 1. 文件的存放
    // 下载ing => temp + 名称
    // MD5 + URL 防止重复资源
    // a/1.png md5 -
    // b/1.png
    // 下载完成 => cache + 名称
    NSString *fileName = url.lastPathComponent;
    //正在下载资源的路径
    self.downLoadingPath = [kTmpPath stringByAppendingPathComponent:fileName];
    //下载完成资源的路径
    self.downLoadedPath = [kCachePath stringByAppendingPathComponent:fileName];
    
    //1.1 判断 url对应的资源，是否下载完毕（下载完毕的目录中存在这个文件）
    // 告诉外界, 下载完毕, 并且传递相关信息(本地的路径, 文件的大小)
    if ([RevanDownLoadFileTool fileExists:self.downLoadedPath]) {
        // UNDO: 告诉外界, 已经下载完成;
        NSLog(@"已经下载完成");
        return;
    }
    
    // 2. 检测临时文件是否存在
    // 2.1 不存在，从 0 字节开始下载
    if (![RevanDownLoadFileTool fileExists:self.downLoadingPath]) {
        //从 0 开始下载
        [self downLoadWithURL:url offset:0];
        return;
    }
    
    // 2.2 存在, : 直接, 以当前的存在文件大小, 作为开始字节, 去网络请求资源
    //     HTTP: rang: 开始字节-
    //    正确的大小 1000   1001
    
    //   本地大小 == 总大小  ==> 移动到下载完成的路径中
    //    本地大小 > 总大小  ==> 删除本地临时缓存, 从0开始下载
    //    本地大小 < 总大小 => 从本地大小开始下载
    // 临时下载文件大小
    _tmpSize = [RevanDownLoadFileTool fileSize:self.downLoadingPath];
    [self downLoadWithURL:url offset:_tmpSize];
}


/** url资源文件，沙盒文件路径 */
+ (NSString *)downLoadedFileWithURL: (NSURL *)url {
    NSString *cacheFilePath = [kCachePath stringByAppendingPathComponent:url.lastPathComponent];
    
    if([RevanDownLoadFileTool fileExists:cacheFilePath]) {
        return cacheFilePath;
    }
    return nil;
}

/** url资源文件，临时文件中的大小 */
+ (long long)tmpCacheSizeWithURL: (NSURL *)url {
    NSString *tmpFileMD5 = [url.absoluteString revan_md5];
    NSString *tmpPath = [kTmpPath stringByAppendingPathComponent:tmpFileMD5];
    return  [RevanDownLoadFileTool fileSize:tmpPath];
}
/** 清空url资源文件 */
+ (void)clearCacheWithURL: (NSURL *)url {
    NSString *cachePath = [kCachePath stringByAppendingPathComponent:url.lastPathComponent];
    [RevanDownLoadFileTool removeFile:cachePath];
}


/**
 暂停任务
 注意:
 - 如果调用了几次继续
 - 调用几次暂停, 才可以暂停
 - 解决方案: 引入状态
 */
- (void)pauseCurrentTask {
    if (self.status == RevanDownLoadStatusDownLoading) {
        self.status = RevanDownLoadStatusPause;
        [self.dataTask suspend];
    }
}

/**
 取消任务
 */
- (void)cancelCurrentTask {
    self.status = RevanDownLoadStatusPause;
    [self.session invalidateAndCancel];
    self.session = nil;
}

/**
 取消任务, 并清理资源
 */
- (void)cancelAndClean {
    [self cancelCurrentTask];
    //移除缓存
    [RevanDownLoadFileTool removeFile:self.downLoadingPath];
}

/**
 继续任务
 - 如果调用了几次暂停, 就要调用几次继续, 才可以继续
 - 解决方案: 引入状态
 */
- (void)resumeCurrentTask {
    if (self.dataTask && self.status == RevanDownLoadStatusPause) {
        [self.dataTask resume];
        self.status = RevanDownLoadStatusDownLoading;
    }
}


#pragma mark - 私有方法
/**
 根据开始字节, 请求资源

 @param url 资源URL
 @param offset 开始字节
 */
- (void)downLoadWithURL:(NSURL *)url offset:(long long)offset {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-", offset] forHTTPHeaderField:@"Range"];
    // session 分配的task, 默认情况, 挂起状态
    self.dataTask = [self.session dataTaskWithRequest:request];
    [self resumeCurrentTask];
}

#pragma mark - getter
- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

#pragma mark - setter
- (void)setStatus:(RevanDownLoadStatus)status {
    _status = status;
    
    // 监听 状态的改变
    if (self.statusChangeBlock) {
        self.statusChangeBlock(_status);
    }
    
    // 监听下载完成
    if (_status == RevanDownLoadStatusSuccess && self.successBlock) {
        self.successBlock(self.downLoadedPath);
    }
    
    // 监听下载失败
    if (_status == RevanDownLoadStatusFailed && self.faildBlock) {
        self.faildBlock();
    }
    
    //下载器状态变化
    [[NSNotificationCenter defaultCenter] postNotificationName:kRevanDownLoadURLOrStateChangeNotification object:nil userInfo:@{
                                                                                                                           kRevanDownLoad_URL: self.url,
                                                                                                                           kRevanDownLoad_STATUS: @(self.status)
                                                                                                                           }];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    if (self.progressBlock) {
        self.progressBlock(_progress);
    }
}

#pragma mark - NSURLSessionDataDelegate
/**
 当发送的请求, 第一次接受到响应的时候调用

 @param completionHandler 系统传递给我们的一个回调代码块, 我们可以通过这个代码块, 来告诉系统,如何处理, 接下来的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    //计算资源总大小
    // Content-Length 请求的大小 != 资源大小
    //        100 -
    // 总大小 19061805
    //        19061705
    // 本地缓存大小
    
    // 取资源总大小
    // 1. 从  Content-Length 取出来
    // 2. 如果 Content-Range 有, 应该从Content-Range里面获取
    
    _totalSize = [httpResponse.allHeaderFields[@"Content-Length"] longLongValue];
    NSString *contentRangeStr = httpResponse.allHeaderFields[@"Content-Range"];
    if (contentRangeStr.length != 0) {
        _totalSize = [[contentRangeStr componentsSeparatedByString:@"/"].lastObject longLongValue];
    }
    
    if (self.infoBlock) {
        self.infoBlock(_totalSize);
    }
    
    // 对比本地大小， 和 总大小
    if (_tmpSize == _totalSize) {
        NSLog(@"移动文件到下载完成");
        // 1. 移动到下载完成文件夹
        [RevanDownLoadFileTool moveFile:self.downLoadingPath toPath:self.downLoadedPath];
        // 2. 取消本次请求
        completionHandler(NSURLSessionResponseCancel);
        return;
    }
    
    // 本地大小 > 总大小
    if (_tmpSize > _totalSize) {
        
        // 1. 删除临时缓存
        NSLog(@"删除临时缓存");
        [RevanDownLoadFileTool removeFile:self.downLoadingPath];
        // 2. 取消请求
        completionHandler(NSURLSessionResponseCancel);
        // 3. 从0 开始下载
        NSLog(@"重新开始下载");
        [self downLoaderWithUrl:httpResponse.URL];
        
        return;
    }
    
    // 本地大小 < 总大小
    // 继续接受数据
    // 确定开始下载数据
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.downLoadingPath append:YES];
    [self.outputStream open];
    completionHandler(NSURLSessionResponseAllow);
}

// 当用户确定, 继续接受数据的时候调用
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    //计算当前缓存大小
    _tmpSize += data.length;
    
    self.progress = _tmpSize * 1.0 / _totalSize;
    
    [self.outputStream write:data.bytes maxLength:data.length];
    NSLog(@"在接受后续数据");
}

// 请求完成的时候调用( != 请求成功/失败)
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (error == nil) {
        NSLog(@"请求完成");
        // 不一定是成功
        // 数据是肯定可以请求完毕
        // 判断, 本地缓存 == 文件总大小 {filename: filesize: md5:xxx}
        // 如果等于 => 验证, 是否文件完整(file md5 )
        _tmpSize = [RevanDownLoadFileTool fileSize:self.downLoadingPath];
        if (_totalSize == _tmpSize) {
            [RevanDownLoadFileTool moveFile:self.downLoadingPath toPath:self.downLoadedPath];
            self.status = RevanDownLoadStatusSuccess;
        }
    }
    else {
        if (error.code == -999) {
            NSLog(@"取消");
            self.status = RevanDownLoadStatusPause;
        }
        else {
            self.status = RevanDownLoadStatusFailed;
        }
    }
    [self.outputStream close];
}

@end
