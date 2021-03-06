//
//  RevanResourceLoaderDelegate.m
//  RevanFunction_Example
//
//  Created by 紫荆秋雪 on 2018/3/6.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import "RevanResourceLoaderDelegate.h"
#import "RevanFileManager.h"
#import "RevanPlayerDownLoader.h"
#import "NSURL+Revan.h"

@interface RevanResourceLoaderDelegate ()<RevanPlayerDownLoaderDelegate>

@property (nonatomic, strong) RevanPlayerDownLoader *downLoader;

@property (nonatomic, strong) NSMutableArray *loadingRequests;

@end

@implementation RevanResourceLoaderDelegate

// 当外界, 需要播放一段音频资源是, 会跑一个请求, 给这个对象
// 这个对象, 到时候, 只需要根据请求信息, 抛数据给外界
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    NSLog(@"%@", loadingRequest);
    
    // 记录所有的请求
    [self.loadingRequests addObject:loadingRequest];
    
    // 1. 判断, 本地有没有该音频资源的缓存文件, 如果有 -> 直接根据本地缓存, 向外界响应数据(3个步骤) return
    NSURL *url = [loadingRequest.request.URL revan_httpURL];
    AVAssetResourceLoadingRequest *firstLoadingRequest = self.loadingRequests.firstObject;
    long long requestOffset = firstLoadingRequest.dataRequest.currentOffset;
    
    if ([RevanFileManager revan_cacheFileExists:url]) {
        [self handleLoadingRequest:loadingRequest];
        return YES;
    }
    // 2. 判断有没有正在下载
    if (self.downLoader.loadedSize == 0) {
        [self.downLoader downLoadWithURL:url offset:0];
        //        开始下载数据(根据请求的信息, url, requestOffset, requestLength)
        return YES;
    }
    
    // 3. 判断当前是否需要重新下载
    // 3.1 当资源请求, 开始点 < 下载的开始点
    // 3.2 当资源的请求, 开始点 > 下载的开始点 + 下载的长度 + 666
    if (requestOffset < self.downLoader.offset || requestOffset > (self.downLoader.offset + self.downLoader.loadedSize + 666)) {
        [self.downLoader downLoadWithURL:url offset:requestOffset];
        return YES;
    }
    
    // 开始处理资源请求 (在下载过程当中, 也要不断的判断)
    [self handleAllLoadingRequest];
    
    
    return YES;
}

// 取消请求
- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    NSLog(@"取消某个请求");
    [self.loadingRequests removeObject:loadingRequest];
}


#pragma mark - RevanPlayerDownLoaderDelegate代理
- (void)revan_downLoadingWithPlayerDownLoader:(RevanPlayerDownLoader *)downLoader {
    [self handleAllLoadingRequest];
}

- (void)handleAllLoadingRequest {
        AVAssetResourceLoadingRequest *loadingRequest = self.loadingRequests.firstObject;
        // 1. 填充内容信息头
        NSURL *url = loadingRequest.request.URL;
        long long totalSize = self.downLoader.totalSize;
        loadingRequest.contentInformationRequest.contentLength = totalSize;
        NSString *contentType = self.downLoader.mimeType;
        loadingRequest.contentInformationRequest.contentType = contentType;
        loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
        
        // 2. 填充数据
        NSData *data = [NSData dataWithContentsOfFile:[RevanFileManager revan_tmpFilePath:url] options:NSDataReadingMappedIfSafe error:nil];
        if (data == nil) {
            data = [NSData dataWithContentsOfFile:[RevanFileManager revan_cacheFilePath:url] options:NSDataReadingMappedIfSafe error:nil];
        }
        
        long long requestOffset = loadingRequest.dataRequest.currentOffset;
        NSInteger requestLength = loadingRequest.dataRequest.requestedLength;
        
        
        long long responseOffset = requestOffset - self.downLoader.offset;
        long long responseLength = MIN(self.downLoader.offset + self.downLoader.loadedSize - requestOffset, requestLength) ;
        
        NSData *subData = [data subdataWithRange:NSMakeRange(responseOffset, responseLength)];
        
        [loadingRequest.dataRequest respondWithData:subData];
        
        
        
        // 3. 完成请求(必须把所有的关于这个请求的区间数据, 都返回完之后, 才能完成这个请求)
        if (requestLength == responseLength) {
            [loadingRequest finishLoading];
            [self.loadingRequests removeObject:loadingRequest];
        }
}


#pragma mark - 私有方法

// 处理, 本地已经下载好的资源文件
- (void)handleLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    // 1. 填充相应的信息头信息
    // 计算总大小
    
    
    NSURL *url = loadingRequest.request.URL;
    long long totalSize = [RevanFileManager revan_cacheFileSize:url];
    loadingRequest.contentInformationRequest.contentLength = totalSize;
    
    NSString *contentType = [RevanFileManager revan_contentType:url];
    loadingRequest.contentInformationRequest.contentType = contentType;
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    
    // 2. 相应数据给外界
    NSData *data = [NSData dataWithContentsOfFile:[RevanFileManager revan_cacheFilePath:url] options:NSDataReadingMappedIfSafe error:nil];
    
    long long requestOffset = loadingRequest.dataRequest.requestedOffset;
    NSInteger requestLength = loadingRequest.dataRequest.requestedLength;
    
    NSData *subData = [data subdataWithRange:NSMakeRange(requestOffset, requestLength)];
    
    [loadingRequest.dataRequest respondWithData:subData];
    
    // 3. 完成本次请求(一旦,所有的数据都给完了, 才能调用完成请求方法)
    [loadingRequest finishLoading];
}

#pragma mark - getter
- (RevanPlayerDownLoader *)downLoader {
    if (!_downLoader) {
        _downLoader = [[RevanPlayerDownLoader alloc] init];
        _downLoader.delegate = self;
    }
    return _downLoader;
}

- (NSMutableArray *)loadingRequests {
    if (!_loadingRequests) {
        _loadingRequests = [NSMutableArray array];
    }
    return _loadingRequests;
}

@end
