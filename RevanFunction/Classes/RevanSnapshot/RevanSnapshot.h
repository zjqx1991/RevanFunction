//
//  RevanSnapshot.h
//  AFNetworking
//
//  Created by RevanWang on 2018/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RevanSnapshot : NSObject

/**
 截图

 @param snapshot 截图view
 @param isSave 是否保存截图到相册
 @return 截图
 */
+ (UIImage *)revan_snapShotView:(UIView *)snapshot savePhoto:(BOOL)isSave;

@end

NS_ASSUME_NONNULL_END
