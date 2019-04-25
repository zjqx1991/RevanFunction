//
//  RevanGCDTimer.m
//  RevanTimer
//
//  Created by Revan on 2018/7/26.
//  Copyright © 2018年 紫荆秋雪. All rights reserved.
//

#import "RevanGCDTimer.h"

@implementation RevanGCDTimer

static NSMutableDictionary *timerDic;
//信号量加锁
dispatch_semaphore_t signalLock;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timerDic = [NSMutableDictionary dictionary];
        signalLock = dispatch_semaphore_create(1);
    });
}

#pragma mark - 创建任务
/**
 自定义定时器:block
 */
+ (NSString *)gcd_timerWithTimeStart:(NSTimeInterval)start
                            interval:(NSTimeInterval)interval
                             repeats:(BOOL)repeats
                               async:(BOOL)async
                             nameKey:(NSString *)nameKey
                               block:(void (^)(void))block {
    if (!block) {
        return nil;
    }
    
    if (start < 0) {
        start = 0;
    }
    
    if (interval <= 0) {
        interval = 0.1;
    }
    
    //1.队列
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    //2.创建定时器
    dispatch_source_t gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //3.设置时间
    dispatch_source_set_timer(gcdTimer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    
    //加锁
    dispatch_semaphore_wait(signalLock, DISPATCH_TIME_FOREVER);
    //定时器的唯一标识
    NSString *name = nameKey;
    //存储到字典中
    [timerDic setObject:gcdTimer forKey:name];
    //解锁
    dispatch_semaphore_signal(signalLock);
    
    //4.设置回调
    dispatch_source_set_event_handler(gcdTimer, ^{
        if (block) {
            block();
        }
        //不重复任务
        if (!repeats) {
            [self gcd_timerCancelWithIdentity:name];
        }
    });
    //5.启动定时器
    dispatch_resume(gcdTimer);
    
    return name;
}

/**
 自定义定时器:target
 */
+ (NSString *)gcd_timerWithTimeStart:(NSTimeInterval)start
                            interval:(NSTimeInterval)interval
                              target:(id)aTarget
                            selector:(SEL)aSelector
                             repeats:(BOOL)repeats
                               async:(BOOL)async
                             nameKey:(NSString *)nameKey {
    return [self gcd_timerWithTimeStart:start
                               interval:interval
                                repeats:repeats
                                  async:async
                                nameKey:nameKey block:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                                    [aTarget performSelector:aSelector];
#pragma clang diagnostic pop
                                }];
}


#pragma mark - 取消任务
/**
 通过name唯一标识来取消任务
 
 @param name 唯一标识
 */
+ (void)gcd_timerCancelWithIdentity:(NSString *)name {
    if (name.length == 0) {
        return;
    }
    //加锁
    dispatch_semaphore_wait(signalLock, DISPATCH_TIME_FOREVER);
    
    dispatch_source_t gcdTimer = [timerDic objectForKey:name];
    if (gcdTimer) {
        //取消
        dispatch_source_cancel(gcdTimer);
        //从字典中移除
        [timerDic removeObjectForKey:name];
    }
    //解锁
    dispatch_semaphore_signal(signalLock);
}


/**
 任务完成时必须调用此方法销毁定时器
 
 @param name 唯一标识
 */
+ (void)gcd_invalidateWithIdentity:(NSString *)name {
    [self gcd_timerCancelWithIdentity:name];
}


@end
