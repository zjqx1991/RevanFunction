//
//  RevanTipsView.h
//  AFNetworking
//
//  Created by RevanWang on 2018/8/24.
//

#import <UIKit/UIKit.h>

@interface RevanTipsView : UIWindow

+ (void)revan_showInfoWithStatus:(NSString *)string;
+ (void)revan_showInfoWithStatus:(NSString *)string duration:(NSTimeInterval)duration;
+ (void)revan_showSuccessWithStatus:(NSString*)string;
+ (void)revan_showErrorWithStatus:(NSString *)string;

#pragma mark - sv HUD
+ (void)revan_showLoading;
+ (void)revan_hideLoading;


#pragma mark - add 集中不同类型的大小的 提醒
+ (void)revan_showNomalStatus:(NSString *)string;
+ (void)revan_showBigStatus:(NSString *)string;

@end
