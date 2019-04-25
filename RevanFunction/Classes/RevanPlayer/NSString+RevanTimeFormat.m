//
//  NSString+RevanTimeFormat.m
//  RevanFunction_Example
//
//  Created by 紫荆秋雪 on 2018/2/16.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import "NSString+RevanTimeFormat.h"

@implementation NSString (RevanTimeFormat)

/**
 输出格式：23:01:01
 
 @return 输出时间格式：23:01:01
 */
- (NSString *)revan_timeFormat {
    int time = [self intValue];
    if (time >= 60 * 60) {
        int hour = time / 60 * 60;
        int min = (time % (60 * 60)) / 60;
        int second = (time % (60 * 60)) % 60;
        return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, second];
    }
    int min = time / 60;
    int second = time % 60;
    return [NSString stringWithFormat:@"%02d:%02d", min, second];
}

@end
