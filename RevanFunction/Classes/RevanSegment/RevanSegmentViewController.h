//
//  RevanSegmentViewController.h
//  RevanFunction_Example
//
//  Created by 紫荆秋雪 on 2017/12/26.
//  Copyright © 2017年 Revan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RevanSegmentConfig.h"
#import "UIView+RevanSegmented.h"



@interface RevanSegmentViewController : UIViewController
/** 获取将要显示vc和index */
@property (nonatomic, copy) void(^segmentViewControllerBlock)(UIViewController *subVC, NSInteger index);
/** segmentBar */
@property (nonatomic, strong, readonly) UIView *segmentBar;
/** 默认选中Item */
@property (nonatomic, assign) NSInteger selectIndex;

/**
 创建上下联动的控件

 @param childVCs 子控制器数组
 @param items 与子控制器相对应的标题
 @param selectIndex 默认选中Item
 */
- (void)revan_segmentVCWithChilds:(NSArray <UIViewController *>*)childVCs segmentItems:(NSArray <NSString *>*)items segmentViewFrame:(CGRect)rect defaultSelectIndex:(NSInteger)selectIndex;

/**
 更新SegmentConfig的配置信息

 @param configBlock segmentConfig配置信息
 */
- (void)revan_updateWithConfig:(void(^)(RevanSegmentConfig *segmentConfig)) configBlock;

/**
 segment Tab是否显示 角标
 
 @param index tab 索引
 @param isShow 是否显示
 */
- (void)revan_segmentTabIndex:(NSInteger)index showMark:(BOOL)isShow;

/** 外界自动滑动 */
- (void)revan_automaticShowChildVCViewsAtIndex:(NSInteger)index;

@end
