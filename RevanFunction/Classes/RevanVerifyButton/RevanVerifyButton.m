//
//  RevanVerifyButton.m
//  RevanFunctionModule
//
//  Created by RevanWang on 2018/8/27.
//

#import "RevanVerifyButton.h"
#import "RevanTimer.h"


@interface RevanVerifyButton ()
/**
 倒计时标识
 */
@property (nonatomic, copy) NSString *timerId;

/** 倒计时时间呢 */
@property (nonatomic, assign) CGFloat duration;
//倒计时
@property (nonatomic, strong) UILabel *downLabel;

@end

@implementation RevanVerifyButton

- (void)dealloc {
    NSLog(@"%s", __func__);
    [RevanTimer revan_invalidateWithIdentity:self.timerId];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

/**
 初始化UI界面
 */
- (void)setupUI {
    //倒计时
    self.downLabel = [[UILabel alloc] init];
    self.downLabel.font = self.titleLabel.font;
    self.downLabel.textAlignment = NSTextAlignmentCenter;
    self.downLabel.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.downLabel.frame = self.bounds;
}

- (void)revan_startDownAnimation {
    if (self.timerId) {
        [RevanTimer revan_invalidateWithIdentity:self.timerId];
    }
    if (self.residueTimeBlock) {
        self.residueTimeBlock(self.duration);
    }
    [self startAnimation];
    [self addSubview:self.downLabel];
    self.downLabel.text = [NSString stringWithFormat:@"%.0fs%@", self.duration, self.placeTitle];
    __weak typeof(self) weakSelf = self;
    
    self.timerId = [RevanTimer revan_timerWithTimeStart:0.0 interval:1.0 repeats:YES async:NO nameKey:@"RevanVerifyButtonTimerID" block:^{
        weakSelf.duration--;
        if (weakSelf.residueTimeBlock) {
            weakSelf.residueTimeBlock(weakSelf.duration);
        }
        if (weakSelf.duration > 0) {
            weakSelf.downLabel.text = [NSString stringWithFormat:@"%.0fs%@", self.duration, self.placeTitle];
        }
        else {
            weakSelf.downLabel.text = weakSelf.titleLabel.text;
            [weakSelf stopAnimation];
        }
    }];
}


/**
 开始
 */
- (void)startAnimation {
    self.downLabel.textColor = self.countDownColor ?: self.titleLabel.textColor;
    self.enabled = NO;
}

/**
 结束倒计时
 */
- (void)revan_stopDownAnimation {
    [self stopAnimation];
}

- (void)stopAnimation {
    self.enabled = YES;
    [self.downLabel removeFromSuperview];
    self.duration = self.countDownduration;
    [RevanTimer revan_invalidateWithIdentity:self.timerId];
}


#pragma mark - getter && setter
- (void)setCountDownduration:(CGFloat)countDownduration {
    _countDownduration = countDownduration;
    self.duration = countDownduration;
}

@end
