//
//  CALayer+RevanLayerAimate.m
//  01-modularization
//
//  Created by 紫荆秋雪 on 2017/4/16.
//  Copyright © 2017年 Revan. All rights reserved.
//

#import "CALayer+RevanLayerAimate.h"

@implementation CALayer (RevanLayerAimate)

/**
 旋转动画
 */
- (void)revan_rotationBasicAnnimationKeyPath:(NSString *)keyPath key:(NSString *)key {
    CABasicAnimation *basicAnnimation = [[CABasicAnimation alloc] init];
    basicAnnimation.keyPath = keyPath;
    basicAnnimation.fromValue = @0;
    basicAnnimation.toValue = @(M_PI * 2);
    basicAnnimation.duration = 30;
    basicAnnimation.repeatCount = MAXFLOAT;
    basicAnnimation.removedOnCompletion = NO;
    [self addAnimation:basicAnnimation forKey:key];
}

/**
 暂停动画
 */
- (void)revan_pauseAnimate {
    CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0f;
    self.timeOffset = pausedTime;
}

/**
 继续动画
 */
- (void)revan_resumeAnimate {
    CFTimeInterval pausedTime = [self timeOffset];
    self.speed = 1.0;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.beginTime = timeSincePause;
}

@end
