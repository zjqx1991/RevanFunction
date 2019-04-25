//
//  RevanSegmentConfig.h
//  Pods-RevanFunctionModule_Example
//
//  Created by 紫荆秋雪 on 2018/1/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RevanSegmentConfig;
/** 参数为color 的block */
typedef RevanSegmentConfig *(^RevanSegmentConfigColorBlack)(UIColor *color);
/** 参数为font 的block */
typedef RevanSegmentConfig *(^RevanSegmentConfigFontBlack)(UIFont *font);
/** 参数为CGFloat 的block */
typedef RevanSegmentConfig *(^RevanSegmentConfigFloatBlack)(CGFloat size);
/** 参数为CGRect 的block */
typedef RevanSegmentConfig *(^RevanSegmentConfigCGRectBlack)(CGRect rect);

@interface RevanSegmentConfig : NSObject

/**
 默认配置

 @return 配置对象 RevanSegmentConfig
 */
+ (instancetype)segmentDefaultConfig;


#pragma mark - 外界赋值推荐使用
/** 背景颜色 */
@property (nonatomic, copy, readonly) RevanSegmentConfigColorBlack backGroundColor;
/** 默认Item文字颜色 */
@property (nonatomic, copy, readonly) RevanSegmentConfigColorBlack itemNormalColor;
/** 选中Item文字颜色 */
@property (nonatomic, copy, readonly) RevanSegmentConfigColorBlack itemSelectColor;
/** 字体大小 */
@property (nonatomic, copy, readonly) RevanSegmentConfigFontBlack itemFont;
/** item高度 */
@property (nonatomic, copy, readonly) RevanSegmentConfigFloatBlack itemHeight;
/** indicator颜色 */
@property (nonatomic, copy, readonly) RevanSegmentConfigColorBlack indicatColor;
/** indicator高度 */
@property (nonatomic, copy, readonly) RevanSegmentConfigFloatBlack indicatHeight;
/** indicator距离底部距离 */
@property (nonatomic, copy, readonly) RevanSegmentConfigFloatBlack indicatBottomMargin;
/** indicator扩展宽度 */
@property (nonatomic, copy, readonly) RevanSegmentConfigFloatBlack indicatExtensionWidth;
/** 角标颜色 */
@property (nonatomic, copy, readonly) RevanSegmentConfigColorBlack markColor;
/** 角标半径 */
@property (nonatomic, copy, readonly) RevanSegmentConfigFloatBlack markRadius;
/** 角标距离top距离 */
@property (nonatomic, copy, readonly) RevanSegmentConfigFloatBlack markTopMargin;
/** segment 上分割线frame */
@property (nonatomic, copy, readonly) RevanSegmentConfigCGRectBlack segmentTopLineFrame;
/** segment 上分割线颜色 */
@property (nonatomic, copy, readonly) RevanSegmentConfigColorBlack segmentTopLineColor;
/** segment 下分割线frame */
@property (nonatomic, copy, readonly) RevanSegmentConfigCGRectBlack segmentBottomLineFrame;
/** segment 下分割线颜色 */
@property (nonatomic, copy, readonly) RevanSegmentConfigColorBlack segmentBottomLineColor;




/** 背景颜色 */
@property (nonatomic, strong) UIColor *backgroundColor;

#pragma mark - Item设置
/** 默认Item文字颜色 */
@property (nonatomic, strong) UIColor *itemnormalColor;
/** 选中Item文字颜色 */
@property (nonatomic, strong) UIColor *itemselectColor;
/** 字体大小 */
@property (nonatomic, strong) UIFont *itemfont;
/** item高度 */
@property (nonatomic, assign) CGFloat itemheight;

#pragma mark - indicator
/** indicator颜色 */
@property (nonatomic, strong) UIColor *indicatorColor;
/** indicator高度 */
@property (nonatomic, assign) CGFloat indicatorHeight;
/** indicator扩展宽度 */
@property (nonatomic, assign) CGFloat indicatorExtensionWidth;
/** indicator距离底部间距 */
@property (nonatomic, assign) CGFloat indicatorbottomMargin;


#pragma mark - 角标配置
/** 角标颜色 */
@property (nonatomic, strong) UIColor *markcolor;
/** 角标半径 */
@property (nonatomic, assign) CGFloat markradius;
/** 角标距离顶部距离 */
@property (nonatomic, assign) CGFloat marktopMargin;


#pragma mark - segment分割线
/** segment上分割线frame */
@property (nonatomic, assign) CGRect segmentTopLine_frame;
/** segment上分割线颜色 */
@property (nonatomic, strong) UIColor *segmentTopLine_color;

/** segment下分割线frame */
@property (nonatomic, assign) CGRect segmentBottomLine_frame;
/** segment下分割线颜色 */
@property (nonatomic, strong) UIColor *segmentBottomLine_color;

@end
