//
//  RevanProxy.m
//  RevanTimer
//
//  Created by Revan on 2018/7/26.
//  Copyright © 2018年 紫荆秋雪. All rights reserved.
//

#import "RevanProxy.h"

@interface RevanProxy ()

/** target */
@property (nonatomic, weak) id target;

@end


@implementation RevanProxy

+(instancetype)revan_proxyTarget:(id)target {
    RevanProxy *proxy = [RevanProxy alloc];
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}
@end
