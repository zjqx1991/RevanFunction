//
//  RevanPlayer.m
//  RevanFunction_Example
//
//  Created by 紫荆秋雪 on 2018/2/16.
//  Copyright © 2018年 Revan. All rights reserved.
//

#import "RevanPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+RevanTimeFormat.h"
#import "RevanResourceLoaderDelegate.h"
#import "NSURL+Revan.h"


@interface RevanPlayer ()
/** AVPlayer播放器 */
@property (nonatomic, strong) AVPlayer *player;

/** 资源加载代理
    处理缓存，可以实现边缓冲边播放
 */
@property (nonatomic, strong) RevanResourceLoaderDelegate *resourceLoaderDelegate;
@end

static RevanPlayer *_shareInstance;

@implementation RevanPlayer {
    BOOL _isManualPause; 
}

- (void)dealloc {
    //移除 KVO 监听
    [self removeobserverKVO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public

/**
 播放 远程url资源
 
 @param url 远程资源
 */
- (void)revan_playWithURL:(NSURL *)url isCache:(BOOL)isCache {
    
    if ([self.URL isEqual:url]) {
        
        if (self.status == RevanPlayerStatusPlaying) {
            return;
        }
        if (self.status == RevanPlayerStatusPause) {
            [self revan_resume];
            return;
        }
        if (self.status == RevanPlayerStatusLoading) {
            
            return;
        }
        
    }
    
    //判断是否是同一个资源
    NSURL *URL = [(AVURLAsset *)self.player.currentItem.asset URL];
    if ([URL isEqual:url]) {
        NSLog(@"当前播放任务已经存在");
        [self revan_resume];
        return;
    }
    //更换资源
    if (self.player.currentItem) {
        [self removeobserverKVO];
    }
    // 创建一个播放器对象
    // 如果我们使用这样的方法, 去播放远程音频
    // 这个方法, 已经帮我们封装了三个步骤
    // 1. 资源的请求
    // 2. 资源的组织
    // 3. 给播放器, 资源的播放
    // 如果资源加载比较慢, 有可能, 会造成调用了play方法, 但是当前并没有播放音频
    
    self.URL = url;
    if (isCache) {
        url = [url revan_streamingURL];
    }
    //1.资源的请求
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    
    // 关于网络音频的请求, 是通过这个对象, 调用代理的相关方法, 进行加载的
    // 拦截加载的请求, 只需要, 重新修改它的代理方法就可以
    self.resourceLoaderDelegate = [[RevanResourceLoaderDelegate alloc] init];
    [asset.resourceLoader setDelegate:self.resourceLoaderDelegate queue:dispatch_get_main_queue()];
    
    //2.资源的组织
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    //当资源的组织者，告诉我们资源准备好之后，我们在播放
    
    //AVPlayerItemStatus status
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
    //播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playFinish) name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    //播放被打断
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playInterupt)
                                                 name:AVPlayerItemPlaybackStalledNotification
                                               object:nil];
    
    //3.播放资源
    self.player = [AVPlayer playerWithPlayerItem:item];
}

/**
 暂停
 */
- (void)revan_pause {
    //手动暂停
    _isManualPause = YES;
    [self.player pause];
    if (self.player) {
        self.status = RevanPlayerStatusPause;
    }
}

/**
 继续
 */
- (void)revan_resume {
    //手动暂停
    _isManualPause = NO;
    [self.player play];
    //表示播放器存在 并且 数据组织者里的数据准备好，已经足够播放了
    if (self.player && self.player.currentItem.playbackLikelyToKeepUp) {
        self.status = RevanPlayerStatusPlaying;
    }
}
/**
 停止
 */
- (void)revan_stop {
    [self.player pause];
    self.player = nil;
    if (self.player) {
        self.status = RevanPlayerStatusStopped;
    }
}

/**
 快进后退
 
 @param timeDiffer 快进后退时间
 */
- (void)revan_seekWithTimeDiffer:(NSTimeInterval)timeDiffer {
    //1.当前音频资源总时长
    CMTime totalTime = self.player.currentItem.duration;
    // CMTime --> NSTimeInterval
    NSTimeInterval totalTimeSec = CMTimeGetSeconds(totalTime);
    
    //2.当前音频，已经播放时长
    CMTime currentTime = self.player.currentItem.currentTime;
    // CMTime --> NSTimeInterval
    NSTimeInterval currentTimeSec = CMTimeGetSeconds(currentTime);
    currentTimeSec += timeDiffer;
    [self revan_seekWithProgress:currentTimeSec / totalTimeSec];
}
/**
 拖拽进度条
 
 @param progress 拖拽进度条
 */
- (void)revan_seekWithProgress:(CGFloat)progress {
    if (progress < 0 || progress > 1) {
        return;
    }
    
    // 可以指定时间节点播放
    // 时间：CMTime ：影片时间
    // 影片时间 -> 秒
    // 秒 -> 影片时间
    
    // 1.当前音频资源的总长度
    CMTime totalTime = self.player.currentItem.duration;
    // CMTime -> NSTimeInterval
    NSTimeInterval totalSec = CMTimeGetSeconds(totalTime);
    // 根据进度条比例来计算当前播放时间
    NSTimeInterval currentSec = totalSec * progress;
    CMTime currentTime = CMTimeMake(currentSec, 1);
    [self.player seekToTime:currentTime
          completionHandler:^(BOOL finished) {
              if (finished) {
                  NSLog(@"确定加载这个时间点的音频资源");
              }
              else {
                  NSLog(@"取消加载这个时间点的音频资源");
              }
          }];
}

/**
 设置播放速率
 
 @param rate 速率
 */
- (void)revan_setRate:(CGFloat)rate {
    [self.player setRate:rate];
}

/**
 设置 静音/非静音
 
 @param muted 是否静音
 */
- (void)revan_setMuted:(BOOL)muted {
    self.player.muted = muted;
}

/**
 改变音量
 
 @param volume 音量
 */
- (void)revan_setVolume:(CGFloat)volume {
    if (volume < 0 || volume > 1) {
        return;
    }
    
    if (volume > 0) {
        [self revan_setMuted:NO];
    }
    self.player.volume = volume;
}


#pragma mark - setter
- (void)setMuted:(BOOL)muted {
    self.player.muted = muted;
}

- (void)setVolume:(CGFloat)volume {
    if (volume < 0 || volume > 1) {
        return;
    }
    
    if (volume > 0) {
        [self revan_setMuted:NO];
    }
    [self.player setVolume:volume];
}

- (void)setRate:(CGFloat)rate {
    [self.player setRate:rate];
}

- (void)setStatus:(RevanPlayerStatus)status {
    _status = status;
    
    //通知
    if (self.URL) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRevanPlayerURLOrStateChangeNotification object:nil userInfo:@{kRevanPlayer_STATUS:@(self.status), kRevanPlayer_URL:self.URL}];
    }
}

- (void)setURL:(NSURL *)URL {
    _URL = URL;
    //通知
    if (self.URL) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRevanPlayerURLOrStateChangeNotification object:nil userInfo:@{kRevanPlayer_STATUS:@(self.status), kRevanPlayer_URL:self.URL}];
    }
}

#pragma mark - getter
/** 当前音频是否静音 */
- (BOOL)muted {
    return self.player.isMuted;
}

/** 当前音频音量 */
- (CGFloat)volume {
    return self.player.volume;
}

/** 当前音频速率 */
- (CGFloat)rate {
    return self.player.rate;
}

/** 资源总时间 */
- (NSTimeInterval)totalTime {
    CMTime totalTime = self.player.currentItem.duration;
    NSTimeInterval totalTimeSec = CMTimeGetSeconds(totalTime);
    if (isnan(totalTimeSec)) {
        return 0;
    }
    return totalTimeSec;
}

/** 总时间Format */
- (NSString *)totalTimeFormat {
    return [[@(self.totalTime) stringValue] revan_timeFormat];
}

/** 当前时间 */
- (NSTimeInterval)currentTime {
    CMTime currentTime = self.player.currentItem.currentTime;
    NSTimeInterval currentTimeSec = CMTimeGetSeconds(currentTime);
    if (isnan(currentTimeSec)) {
        return 0;
    }
    return currentTimeSec;
}

/** 当前时间Format */
- (NSString *)currentTimeFormat {
    return [[@(self.currentTime) stringValue] revan_timeFormat];
}

/** 当前进度 */
- (CGFloat)progress {
    if (self.totalTime == 0) {
        return 0.0;
    }
    return self.currentTime / self.totalTime;
}

/** 缓存进度 */
- (CGFloat)bufferProgress {
    if (self.totalTime == 0) {
        return 0;
    }
    CMTimeRange timeRange = [self.player.currentItem.loadedTimeRanges.lastObject CMTimeRangeValue];
    CMTime bufferTime = CMTimeAdd(timeRange.start, timeRange.duration);
    NSTimeInterval bufferTimeSec = CMTimeGetSeconds(bufferTime);
    return bufferTimeSec / self.totalTime;
}

#pragma mark - 实例化播放器单例start
/** 播放器实例化 */
+ (instancetype)instancePlayer {
    if (!_shareInstance) {
        _shareInstance = [[self alloc] init];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _shareInstance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _shareInstance;
}



#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //监听播放器状态
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
            {
                NSLog(@"准备完毕, 开始播放");
                [self revan_resume];
                break;
            }
            case AVPlayerItemStatusFailed:
            {
                NSLog(@"数据准备失败, 无法播放");
                self.status = RevanPlayerStatusFailed;
                break;
            }
                
            default:
            {
                NSLog(@"未知");
                self.status = RevanPlayerStatusUnknown;
                break;
            }
        }
        
    }
    
    if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        // 代表, 是否加载的可以进行播放了
        BOOL playbackLikelyToKeepUp = [change[NSKeyValueChangeNewKey] boolValue];
        if (playbackLikelyToKeepUp) {
            NSLog(@"数据加载的足够播放了");
            
            // 能调用, 播放
            // 手动暂停, 优先级 > 自动播放
            if (!_isManualPause) {
                [self revan_resume];
            }
            
        }else {
            NSLog(@"数据不够播放");
            self.status = RevanPlayerStatusLoading;
        }
    }
}

#pragma mark - 播放完成通知
- (void)playFinish {
    NSLog(@"播放完成");
    self.status = RevanPlayerStatusStopped;
}
#pragma mark - 播放被打断通知  && 资源加载跟不上
- (void)playInterupt {
    // 来电话, 资源加载跟不上
    NSLog(@"播放被打断");
    self.status = RevanPlayerStatusPause;
}

#pragma mark - remove-KVO
/**
 移除KVO
 */
- (void)removeobserverKVO {
    [self.player.currentItem removeObserver:self
                                 forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self
                                 forKeyPath:@"playbackLikelyToKeepUp"];
}

@end
