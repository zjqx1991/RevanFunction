//
//  NSString+MD5.m
//  RevanFunction_Example
//
//  Created by 紫荆秋雪 on 2018/2/10.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)
- (NSString *)revan_md5 {
    const char *data = self.UTF8String;
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    // 作用: 把c语言的字符串 -> md5 c字符串
    CC_MD5(data, (CC_LONG)strlen(data), md);
    // 32
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", md[i]];
    }
    return result;
}
@end
