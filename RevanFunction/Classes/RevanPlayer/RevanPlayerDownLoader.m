//
//  RevanPlayerDownLoader.m
//  RevanFunctionModule_Example
//
//  Created by 紫荆秋雪 on 2018/3/6.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import "RevanPlayerDownLoader.h"
#import "RevanFileManager.h"


@interface RevanPlayerDownLoader ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSOutputStream *outputStream;


@property (nonatomic, strong) NSURL *url;
@end

@implementation RevanPlayerDownLoader

#pragma mark - Public
- (void)downLoadWithURL:(NSURL *)url offset:(long long)offset {
    [self cancelAndClean];
    
    self.url = url;
    self.offset = offset;
    
    // 请求的是某一个区间的数据 Range
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-", offset] forHTTPHeaderField:@"Range"];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    [task resume];
}

#pragma mark - NSURLSessionDataDelegate {

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    // 1. 从  Content-Length 取出来
    // 2. 如果 Content-Range 有, 应该从Content-Range里面获取
    self.totalSize = [response.allHeaderFields[@"Content-Length"] longLongValue];
    NSString *contentRangeStr = response.allHeaderFields[@"Content-Range"];
    if (contentRangeStr.length != 0) {
        self.totalSize = [[contentRangeStr componentsSeparatedByString:@"/"].lastObject longLongValue];
    }
    
    
    self.mimeType = response.MIMEType;
    
    
    
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:[RevanFileManager revan_tmpFilePath:self.url] append:YES];
    [self.outputStream open];
    
    completionHandler(NSURLSessionResponseAllow);
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    self.loadedSize += data.length;
    [self.outputStream write:data.bytes maxLength:data.length];
    
    if ([self.delegate respondsToSelector:@selector(revan_downLoadingWithPlayerDownLoader:)]) {
        [self.delegate revan_downLoadingWithPlayerDownLoader:self];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (error == nil) {
        NSURL *url = self.url;
        if ([RevanFileManager revan_tmpFileSize:url] == self.totalSize) {
            //            移动文件 : 临时文件夹 -> cache文件夹
            [RevanFileManager revan_moveTmpPathToCachePath:url];
        }
        
        
    }else {
        NSLog(@"有错误");
    }
    
    
}


#pragma mark - 私有方法
- (void)cancelAndClean {
    // 取消
    [self.session invalidateAndCancel];
    self.session = nil;
    // 清空本地已经存储的临时缓存
    [RevanFileManager revan_clearTmpFile:self.url];
    
    // 重置数据
    self.loadedSize = 0;
}

#pragma mark - setter
- (void)setOffset:(long long)offset {
    _offset = offset;
}

- (void)setLoadedSize:(long long)loadedSize {
    _loadedSize = loadedSize;
}

- (void)setTotalSize:(long long)totalSize {
    _totalSize = totalSize;
}

- (void)setMimeType:(NSString *)mimeType {
    _mimeType = mimeType;
}

#pragma mark - getter
- (NSURLSession *)session {
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

@end
