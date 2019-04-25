//
//  RevanTipsViewHeader.h
//  Pods
//
//  Created by RevanWang on 2018/8/24.
//

#ifndef RevanTipsViewHeader_h
#define RevanTipsViewHeader_h
#import <pthread.h>

static inline void zy_safe_async_main(void (^block)()) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

// 包含热点栏的状态栏高度  普通机型为20，iPhone X为44，连接热点时都增加20
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//系统状态栏高度：普通机型为20，iPhone X为44
#define kSysStatusBarHeight (IS_IPhone_X?44.f:20.f)
//热点栏高度20
#define kHotspotStatusBarHeight  20.f
//是否开启了热点
#define KIsHotspotConnected   (kStatusBarHeight==(kSysStatusBarHeight+kHotspotStatusBarHeight)?YES:NO)

// 导航栏高度
#define kNavBarHeight 44.0
// tabbar高度
#define kTabBarHeight (IS_IPhone_X?83:49)
// 状态栏+导航栏高度 如果开启了热点，需要减去热点栏高度20
#define kTopHeight  (KIsHotspotConnected?(kStatusBarHeight+kNavBarHeight-kHotspotStatusBarHeight):(kStatusBarHeight + kNavBarHeight))

// 自定义NavBar高度
#define kCustomNavBarHeight (IS_IPhone_X?88.f:64.f)
// 自定义tabbar高度
#define kCustomTabBarHeight (IS_IPhone_X?104.f:70.f)
// 快速开始距离底部间距
#define kQuickStartBottomMargin (IS_IPhone_X?-31:7)
// 个人中心距离顶部距离
#define kMineStatusMargin (IS_IPhone_X?24.f:0.f)


/**
 国际化
 */
#define ZYLocalizedStringFromLogin(String) NSLocalizedStringFromTable(String, @"Login", nil)
#define ZYLocalizedStringFromConfig(String) NSLocalizedStringFromTable(String, @"Config", nil)
#define ZYLocalizedStringFromLocalizable(String) NSLocalizedStringFromTable(String, @"Localizable", nil)
#define ZYLocalizedStringFromLive(String) NSLocalizedStringFromTable(String, @"Live", nil)
#define ZYLocalizedStringFromUser(String) NSLocalizedStringFromTable(String, @"User", nil)
#define ZYLocalizedStringFromNimKit(String) NSLocalizedStringFromTable(String, @"NimKit", nil)


/**
 *  屏幕高度
 */
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define screenViewHeight (ScreenHeight-kTopHeight)

/**
 *  屏幕宽度
 */
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenScale [UIScreen mainScreen].scale

//按iPhone6尺寸适配
#define ADAPTATION_Six_W(w)  (float)(w)*ScreenWidth/375
#define ADAPTATION_Six_H(h) (float)ScreenHeight*(h)/667

//如果是iOS7以及之后的版本
#define NLSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define IOS7_OR_LATER NLSystemVersionGreaterOrEqualThan(7.0)
//ios8
#define IOS8_OR_LATER NLSystemVersionGreaterOrEqualThan(8.0)
//ios9
#define IOS9_OR_LATER NLSystemVersionGreaterOrEqualThan(9.0)
//ios10
#define IOS10_OR_LATER NLSystemVersionGreaterOrEqualThan(10.0)
//ios11
#define IOS11_OR_LATER NLSystemVersionGreaterOrEqualThan(11.0)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPhone_X  (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)
/** 高:宽 */
#define ZYHeightScale(height, width) (((height) * 1.0 / width) * ScreenWidth)


#endif /* RevanTipsViewHeader_h */
