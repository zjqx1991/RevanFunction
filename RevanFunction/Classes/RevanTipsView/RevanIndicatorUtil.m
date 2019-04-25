//
//  RevanIndicatorUtil.m
//  AFNetworking
//
//  Created by RevanWang on 2018/8/24.
//

#import "RevanIndicatorUtil.h"

@implementation RevanIndicatorUtil

+ (void)init {
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
        [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
        [SVProgressHUD setMinimumDismissTimeInterval:60.0f];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    });
}

+ (void)showLoading
{
    [self init];
    [SVProgressHUD show];
}

+ (void)hideLoading
{
    [self init];
    [SVProgressHUD dismiss];
}

+ (void)showStringError:(NSString *)aErrorString
{
    [self init];
    [SVProgressHUD showErrorWithStatus:aErrorString];
}

+ (void)showStringInfo:(NSString *)aInfoString
{
    [self init];
    [SVProgressHUD showInfoWithStatus:aInfoString];
}

+ (void)showStringSuccess:(NSString *)aSuccessString
{
    [self init];
    [SVProgressHUD showSuccessWithStatus:aSuccessString];
}
@end
