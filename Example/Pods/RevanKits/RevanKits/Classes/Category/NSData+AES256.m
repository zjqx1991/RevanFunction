//
//  NSData+AES256.m
//  RevanBaseModule
//
//  Created by RevanWang on 2018/8/30.
//

#import "NSData+AES256.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (AES256)

/**
 Data数据加密
 
 @param key 加密key
 @return 加密后的Data数据
 */
-(NSData *)revan_aes256_encrypt:(NSString *)key {
    NSData * data = nil;
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        data = [NSData dataWithBytes:buffer length:numBytesEncrypted];
    }
    if (buffer != NULL) {
        free(buffer);
    }
    return data;
}

/**
 Data数据解密
 
 @param key 解密key
 @return 解密后的Data数据
 */
-(NSData *)revan_aes256_decrypt:(NSString *)key {
    NSData * data = nil;
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        data = [NSData dataWithBytes:buffer length:numBytesDecrypted];
        
    }
    if (buffer != NULL) {
        free(buffer);
    }
    return data;
}

@end
