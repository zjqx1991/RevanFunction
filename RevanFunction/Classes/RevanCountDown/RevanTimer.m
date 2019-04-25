//
//  RevanTimer.m
//  RevanTimer
//
//  Created by 紫荆秋雪 on 2018/7/26.
//  Copyright © 2018年 紫荆秋雪. All rights reserved.
//
/*
 引入RevanProxy中间代理来解决target循环引用
 */

#import "RevanTimer.h"
#import "RevanGCDTimer.h"
#import "RevanProxy.h"

@implementation RevanTimer

#pragma mark - 创建任务
/**
 自定义定时器:block block会强引用self
 
 @param start 开始时间
 @param interval 时间间隔
 @param repeats 是否重复
 @param async 是否异步执行
 @param block 任务block
 @return 这个任务对应的一个唯一标识
 */
+ (NSString *)revan_timerWithTimeStart:(NSTimeInterval)start
                              interval:(NSTimeInterval)interval
                               repeats:(BOOL)repeats
                                 async:(BOOL)async
                               nameKey:(NSString *)nameKey
                                 block:(void (^)(void))block {
    return [RevanGCDTimer gcd_timerWithTimeStart:start
                                        interval:interval
                                         repeats:repeats
                                           async:async
                                         nameKey:nameKey
                                           block:block];
}

/**
 自定义定时器:target
 
 @param start 开始时间
 @param interval 时间间隔
 @param aTarget target
 @param aSelector 执行方法
 @param repeats 是否重复
 @param async 是否异步执行
 @return 这个任务对应的一个唯一标识
 */
+ (NSString *)revan_timerWithTimeStart:(NSTimeInterval)start
                              interval:(NSTimeInterval)interval
                                target:(id)aTarget
                              selector:(SEL)aSelector
                               repeats:(BOOL)repeats
                                 async:(BOOL)async
                               nameKey:(NSString *)nameKey {
    return [RevanGCDTimer gcd_timerWithTimeStart:start
                                        interval:interval
                                          target:[RevanProxy revan_proxyTarget:aTarget]
                                        selector:aSelector
                                         repeats:repeats
                                           async:async
                                         nameKey:nameKey];
}


#pragma mark - 取消任务
/**
 通过name唯一标识来取消任务
 
 @param name 唯一标识
 */
+ (void)revan_timerCancelWithIdentity:(NSString *)name {
    [RevanGCDTimer gcd_timerCancelWithIdentity:name];
}


/**
 任务完成时必须调用此方法销毁定时器
 
 @param name 唯一标识
 */
+ (void)revan_invalidateWithIdentity:(NSString *)name {
    [RevanGCDTimer gcd_invalidateWithIdentity:name];
}

@end
