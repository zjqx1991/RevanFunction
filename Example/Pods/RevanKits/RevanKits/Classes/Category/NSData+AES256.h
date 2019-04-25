//
//  NSData+AES256.h
//  RevanBaseModule
//
//  Created by RevanWang on 2018/8/30.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)
/**
 Data数据加密

 @param key 加密key
 @return 加密后的Data数据
 */
-(NSData *)revan_aes256_encrypt:(NSString *)key;

/**
 Data数据解密

 @param key 解密key
 @return 解密后的Data数据
 */
-(NSData *)revan_aes256_decrypt:(NSString *)key;

@end
