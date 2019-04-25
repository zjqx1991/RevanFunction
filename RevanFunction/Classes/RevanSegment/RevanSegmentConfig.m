//
//  RevanSegmentConfig.m
//  Pods-RevanFunction_Example
//
//  Created by 紫荆秋雪 on 2018/1/1.
//

#import "RevanSegmentConfig.h"

@implementation RevanSegmentConfig

+ (instancetype)segmentDefaultConfig {
    RevanSegmentConfig *config = [[RevanSegmentConfig alloc] init];
    config.backgroundColor = [UIColor whiteColor];
    config.itemfont = [UIFont systemFontOfSize:15];
    config.itemnormalColor = [UIColor lightGrayColor];
    config.itemselectColor = [UIColor redColor];
    config.itemheight = 45.0;
    
    config.indicatorColor = [UIColor redColor];
    config.indicatorHeight = 2;
    config.indicatorExtensionWidth = 10;
    config.indicatorbottomMargin = 0;
    
    config.markcolor = [UIColor redColor];
    config.markradius = 5.0;
    config.marktopMargin = 0.0;
    
    config.segmentTopLine_frame = CGRectMake(0, 0, 0, 0);
    config.segmentTopLine_color = [UIColor darkGrayColor];
    config.segmentBottomLine_frame = CGRectMake(0, 0, 0, 0);
    config.segmentBottomLine_color = [UIColor darkGrayColor];
    
    return config;
}

/** 背景颜色 */
- (RevanSegmentConfigColorBlack)backGroundColor {
    return ^(UIColor *bgcolor){
        self.backgroundColor = bgcolor;
        return self;
    };
}

/** 默认Item文字颜色 */
- (RevanSegmentConfigColorBlack)itemNormalColor {
    return ^(UIColor *normalcolor){
        self.itemnormalColor = normalcolor;
        return self;
    };
}

/** 选中Item文字颜色 */
- (RevanSegmentConfigColorBlack)itemSelectColor {
    return ^(UIColor *selectcolor){
        self.itemselectColor = selectcolor;
        return self;
    };
}

/** 字体大小 */
- (RevanSegmentConfigFontBlack)itemFont {
    return ^(UIFont *font){
        self.itemfont = font;
        return self;
    };
}

/** item高度 */
- (RevanSegmentConfigFloatBlack)itemHeight {
    return ^(CGFloat itemH){
        self.itemheight = itemH;
        return self;
    };
}

/** indicator颜色 */
- (RevanSegmentConfigColorBlack)indicatColor {
    return ^(UIColor *indicatcolor){
        self.indicatorColor = indicatcolor;
        return self;
    };
}

/** indicator高度 */
- (RevanSegmentConfigFloatBlack)indicatHeight {
    return ^(CGFloat height){
        self.indicatorHeight = height;
        return self;
    };
}

/** indicator扩展宽度 */
- (RevanSegmentConfigFloatBlack)indicatExtensionWidth {
    return ^(CGFloat extensionWidth){
        self.indicatorExtensionWidth = extensionWidth;
        return self;
    };
}

/** indicator距离底部的间距 */
- (RevanSegmentConfigFloatBlack)indicatBottomMargin {
    return ^(CGFloat indicatBottomMargin) {
        self.indicatorbottomMargin = indicatBottomMargin;
        return self;
    };
}

/** 角标颜色 */
- (RevanSegmentConfigColorBlack)markColor {
    return ^(UIColor *markColor) {
        self.markcolor = markColor;
        return self;
    };
}

/** 角标半径 */
- (RevanSegmentConfigFloatBlack)markRadius {
    return ^(CGFloat markRadius) {
        self.markradius = markRadius;
        return self;
    };
}

/** 角标距离顶部距离 */
- (RevanSegmentConfigFloatBlack)markTopMargin {
    return ^(CGFloat topMargin) {
        self.marktopMargin = topMargin;
        return self;
    };
}

/** segment 上分割线frame */
- (RevanSegmentConfigCGRectBlack)segmentTopLineFrame {
    return ^(CGRect rect) {
        self.segmentTopLine_frame = rect;
        return self;
    };
}

/** segment 上分割线颜色 */
- (RevanSegmentConfigColorBlack)segmentTopLineColor {
    return ^(UIColor *color) {
        self.segmentTopLine_color = color;
        return self;
    };
}

/** segment 下分割线frame */
- (RevanSegmentConfigCGRectBlack)segmentBottomLineFrame {
    return ^(CGRect rect) {
        self.segmentBottomLine_frame = rect;
        return self;
    };
}

/** segment 下分割线颜色 */
- (RevanSegmentConfigColorBlack)segmentBottomLineColor {
    return ^(UIColor *color) {
        self.segmentBottomLine_color = color;
        return self;
    };
}

@end
