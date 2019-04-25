//
//  RevanVerifyButton.h
//  RevanFunctionModule
//
//  Created by RevanWang on 2018/8/27.
//

#import <UIKit/UIKit.h>

typedef void(^RevanTimeBlock)(NSInteger time);

@interface RevanVerifyButton : UIButton

/** 剩余时间 */
@property (nonatomic, copy) RevanTimeBlock residueTimeBlock;

/** 验证码倒计时时间 */
@property (nonatomic, assign) CGFloat countDownduration;
/** 文字 */
@property (nonatomic, copy) NSString *placeTitle;
/** 倒计时问题颜色 */
@property (nonatomic, strong) UIColor *countDownColor;

/**
 开始倒计时
 */
- (void)revan_startDownAnimation;
/**
 结束倒计时
 */
- (void)revan_stopDownAnimation;

@end
