//
//  RevanSegmentedView.h
//  RevanFunction_Example
//
//  Created by 紫荆秋雪 on 2017/12/25.
//  Copyright © 2017年 Revan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RevanSegmentedView, RevanSegmentConfig;

@protocol RevanSegmentedViewDelegate <NSObject>
/**
 代理方法: 告诉外界, 内部的点击数据

 @param segmentedView RevanSegmentedView
 @param selectBtn 选中的Button
 @param disBtn 消失选中状态的Button
 */
- (void)revan_segmentedView:(RevanSegmentedView *_Nonnull)segmentedView didSelectButton:(UIButton *_Nullable)selectBtn disButton:(UIButton *_Nullable)disBtn;
@end


@interface RevanSegmentedView : UIView

/**
 快速创建RevanSegmentedView

 @return RevanSegmentedView
 */
+ (instancetype)instanceSegment;

/**
 更新SegmentConfig的配置信息

 @param configBlock 更新的配置信息
 */
- (void)updateSegmentConfig:(void(^)(RevanSegmentConfig *segmentConfig)) configBlock;


/**
 segment Tab是否显示 角标

 @param index tab 索引
 @param isShow 是否显示
 */
- (void)segmentTabIndex:(NSInteger)index showMark:(BOOL)isShow;



/** didSelect */
@property (nonatomic, weak) id<RevanSegmentedViewDelegate> delegate;
/** 数据源 */
@property (nonatomic, strong, nonnull) NSArray <NSString *>*itemDataSources;
/** 当前选中的索引, 双向设置 */
@property (nonatomic, assign) NSInteger selectIndex;


@end
