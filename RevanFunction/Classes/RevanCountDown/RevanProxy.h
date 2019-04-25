//
//  RevanProxy.h
//  RevanTimer
//
//  Created by Revan on 2018/7/26.
//  Copyright © 2018年 紫荆秋雪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RevanProxy : NSProxy

+(instancetype)revan_proxyTarget:(id)target;
@end
