//
//  RevanQRCodeScanView.h
//  RevanFunctionModule
//
//  Created by RevanWang on 2018/8/25.
//

#import <UIKit/UIKit.h>

/**
 默认与边框线同中心点
 */
typedef NS_ENUM (NSUInteger, RevanCornerLoactionType) {
    /// 默认与边框线同中心点
    RevanCornerLoactionTypeDefault,
    /// 在边框线内部
    RevanCornerLoactionTypeInside,
    /// 在边框线外部
    RevanCornerLoactionTypeOutside,
};

/**
 扫描样式
 */
typedef NS_ENUM (NSUInteger, RevanScanAnimationStyle) {
    /// 单线扫描样式
    RevanScanAnimationStyleDefault,
    /// 网格扫描样式
    RevanScanAnimationStyleGrid,
};

@interface RevanQRCodeScanView : UIView

/** 扫描样式，默认 ScanningAnimationStyleDefault */
@property (nonatomic, assign) RevanScanAnimationStyle scanAnimationStyle;
/** 扫描线名 */
@property (nonatomic, copy) NSString *scanningImageName;
/** 边框颜色，默认白色 */
@property (nonatomic, strong) UIColor *borderColor;
/** 边角位置，默认 CornerLoactionDefault */
@property (nonatomic, assign) RevanCornerLoactionType cornerLocation;
/** 边角颜色，默认微信颜色 */
@property (nonatomic, strong) UIColor *cornerColor;
/** 边角宽度，默认 2.f */
@property (nonatomic, assign) CGFloat cornerWidth;
/** 扫描区周边颜色的 alpha 值，默认 0.2f */
@property (nonatomic, assign) CGFloat backgroundAlpha;
/** 扫描线动画时间，默认 0.02 */
@property (nonatomic, assign) NSTimeInterval animationTimeInterval;

/** 添加定时器 */
- (void)addTimer;
/** 移除定时器(切记：一定要在Controller视图消失的时候，停止定时器) */
- (void)removeTimer;

@end
