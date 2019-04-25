//
//  CALayer+RevanLayerAimate.h
//  01-modularization
//
//  Created by 紫荆秋雪 on 2017/4/16.
//  Copyright © 2017年 Revan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (RevanLayerAimate)

/**
 旋转动画

 @param keyPath 旋转时所参考的轴
 @param key     动画key
 */
- (void)revan_rotationBasicAnnimationKeyPath:(NSString *)keyPath key:(NSString *) key;

/**
 暂停动画
 */
- (void)revan_pauseAnimate;

/**
 继续动画
 */
- (void)revan_resumeAnimate;

@end
