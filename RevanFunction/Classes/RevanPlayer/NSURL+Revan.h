//
//  NSURL+Revan.h
//  RevanFunctionModule_Example
//
//  Created by 紫荆秋雪 on 2018/3/6.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Revan)

/**
 HTTP协议 转换成 stream协议

 @return stream协议
 */
- (NSURL *)revan_streamingURL;


/**
 stream协议 转换成 HTTP协议
 
 @return HTTP协议
 */
- (NSURL *)revan_httpURL;

@end
