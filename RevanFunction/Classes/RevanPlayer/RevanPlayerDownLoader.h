//
//  RevanPlayerDownLoader.h
//  RevanFunctionModule_Example
//
//  Created by 紫荆秋雪 on 2018/3/6.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RevanPlayerDownLoader;

@protocol RevanPlayerDownLoaderDelegate <NSObject>

- (void)revan_downLoadingWithPlayerDownLoader:(RevanPlayerDownLoader *)downLoader;

@end


@interface RevanPlayerDownLoader : NSObject

@property (nonatomic, weak) id<RevanPlayerDownLoaderDelegate> delegate;

@property (nonatomic, assign, readonly) long long totalSize;
@property (nonatomic, assign, readonly) long long loadedSize;
@property (nonatomic, assign, readonly) long long offset;
@property (nonatomic, strong, readonly) NSString *mimeType;


- (void)downLoadWithURL:(NSURL *)url offset:(long long)offset;

@end
