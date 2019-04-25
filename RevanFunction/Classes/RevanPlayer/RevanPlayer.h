//
//  RevanPlayer.h
//  RevanFunction_Example
//
//  Created by 紫荆秋雪 on 2018/2/16.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 播放器状态通知 */
#define kRevanPlayerURLOrStateChangeNotification @"revanPlayerURLOrStateChangeNotification"
/** 播放器URLkey */
#define kRevanPlayer_URL @"revanPlayerURL"
/** 播放器状态key */
#define kRevanPlayer_STATUS @"revanPlayerStatus"

/**
 * 播放器的状态
 * 因为UI界面需要加载状态显示, 所以需要提供加载状态
 - RevanPlayerStatusUnknown: 未知(比如都没有开始播放音乐)
 - RevanPlayerStatusLoading: 正在加载()
 - RevanPlayerStatusPlaying: 正在播放
 - RevanPlayerStatusStopped: 停止
 - RevanPlayerStatusPause:   暂停
 - RevanPlayerStatusFailed:  失败(比如没有网络缓存失败, 地址找不到)
 */
typedef NS_ENUM(NSInteger, RevanPlayerStatus) {
    RevanPlayerStatusUnknown   = 0,
    RevanPlayerStatusLoading   = 1,
    RevanPlayerStatusPlaying   = 2,
    RevanPlayerStatusStopped   = 3,
    RevanPlayerStatusPause     = 4,
    RevanPlayerStatusFailed    = 5
};


@interface RevanPlayer : NSObject

#define kRevanPlayer [RevanPlayer instancePlayer]

//MARK: public
/**
 播放器单例
 */
+ (instancetype)instancePlayer;

/**
 播放 远程url资源
 
 @param url 远程资源
 @param isCache 是否缓存
 */
- (void)revan_playWithURL:(NSURL *)url isCache:(BOOL)isCache;;
/**
 暂停
 */
- (void)revan_pause;

/**
 继续
 */
- (void)revan_resume;
/**
 停止
 */
- (void)revan_stop;
/**
 快进后退

 @param timeDiffer 快进后退时间
 */
- (void)revan_seekWithTimeDiffer:(NSTimeInterval)timeDiffer;
/**
 拖拽进度条

 @param progress 拖拽进度条
 */
- (void)revan_seekWithProgress:(CGFloat)progress;

/**
 设置播放速率

 @param rate 速率
 */
- (void)revan_setRate:(CGFloat)rate;

/**
 设置 静音/非静音

 @param muted 是否静音
 */
- (void)revan_setMuted:(BOOL)muted;

/**
 改变音量

 @param volume 音量
 */
- (void)revan_setVolume:(CGFloat)volume;

//MARK: 数据提供

/** 静音 */
@property (nonatomic, assign) BOOL muted;
/** 音量 */
@property (nonatomic, assign) CGFloat volume;
/** 速率 */
@property (nonatomic, assign) CGFloat rate;


//MARK: 获取数据
/** 资源URL */ 
@property (nonatomic, strong, readonly) NSURL *URL;
/** 播放器状态 */
@property (nonatomic, assign, readonly) RevanPlayerStatus status;
/** 资源总时间 */
@property (nonatomic, assign, readonly) NSTimeInterval totalTime;
/** 总时间Format */
@property (nonatomic, copy, readonly) NSString *totalTimeFormat;
/** 当前时间 */
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;
/** 当前时间Format */
@property (nonatomic, copy) NSString *currentTimeFormat;
/** 当前进度 */
@property (nonatomic, assign, readonly) CGFloat progress;
/** 缓存进度 */
@property (nonatomic, assign, readonly) CGFloat bufferProgress;

@end
