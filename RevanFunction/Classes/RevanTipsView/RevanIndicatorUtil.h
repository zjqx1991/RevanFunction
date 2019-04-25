//
//  RevanIndicatorUtil.h
//  AFNetworking
//
//  Created by RevanWang on 2018/8/24.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"

@interface RevanIndicatorUtil : NSObject

+ (void)showLoading;
+ (void)hideLoading;
+ (void)showStringError:(NSString *)aErrorString;
+ (void)showStringInfo:(NSString *)aInfoString;
+ (void)showStringSuccess:(NSString *)aSuccessString;

@end
