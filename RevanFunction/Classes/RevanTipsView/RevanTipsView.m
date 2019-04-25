//
//  RevanTipsView.m
//  AFNetworking
//
//  Created by RevanWang on 2018/8/24.
//

#import "RevanTipsView.h"
#import "RevanTipsViewHeader.h"
#import "RevanIndicatorUtil.h"
#import "UIView+RevanView.h"


//20170926 统一这个高度了
#define kTipsViewFrame CGRectMake(0.0f, (IS_IPhone_X ? 44.0 :0.0f), ScreenWidth, (IS_IPhone_X ? 35.0 :30.0f))

@interface RevanTipsView ()
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end


@implementation RevanTipsView

+ (id)loadCurrentNib:(NSString *)nibName inDirectoryBundleName:(NSString *)bundleName currentClass:(Class)Class {
    /** 当前bundle */
    NSBundle *currentBundle = [NSBundle bundleForClass:Class];
    /** 资源在命名空间的路径 */
    NSString *nibNamePath = [NSString stringWithFormat:@"%@.bundle/%@", bundleName, nibName];
    return [[currentBundle loadNibNamed:nibNamePath owner:nil options:nil] lastObject];
}

+ (instancetype)sharedView {
    static RevanTipsView *_sharedView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedView = [self loadCurrentNib:@"RevanTipsView" inDirectoryBundleName:@"RevanTipsView" currentClass:self];
        _sharedView.frame = kTipsViewFrame;
        [_sharedView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin];
        [_sharedView setWindowLevel:UIWindowLevelStatusBar + 1];
        _sharedView.clipsToBounds = YES;
    });
    return _sharedView;
}

#pragma mark - Public
+ (void)showStatus:(NSString *)string frame:(CGRect)frame {
    
    if (string.length == 0) {
        return;
    }
    
    zy_safe_async_main((^{
        RevanTipsView *tipsView = [self sharedView];
        
        tipsView.transform = CGAffineTransformIdentity;
        [tipsView setFrame:frame];
        tipsView.tipsLabel.superview.frame = tipsView.bounds;
        [tipsView.tipsLabel setText:string];
        [tipsView show:YES];
    }));
}

+ (void)revan_showInfoWithStatus:(NSString *)string {
    [self showStatus:string frame:kTipsViewFrame];
}

+ (void)revan_showInfoWithStatus:(NSString *)string duration:(NSTimeInterval)duration {
    zy_safe_async_main((^{
        [self showStatus:string frame:kTipsViewFrame];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
        [[self sharedView] performSelector:@selector(dismiss) withObject:nil afterDelay:duration];
    }));
}

+ (void)revan_showSuccessWithStatus:(NSString*)string {
    if (string.length ==0) {
        string = ZYLocalizedStringFromConfig(@"操作成功");
    }
    [self showStatus:string frame:kTipsViewFrame];
}

+ (void)revan_showErrorWithStatus:(NSString *)string {
    if (string.length ==0) {
        string = ZYLocalizedStringFromConfig(@"操作失败");
    }
    [self showStatus:string frame:kTipsViewFrame];
}

+ (void)revan_showNomalStatus:(NSString *)string {
    [self showStatus:string frame:kTipsViewFrame];
}

+ (void)revan_showBigStatus:(NSString *)string {
    [self showStatus:string frame:kTipsViewFrame];
}

#pragma mark - Show Dismiss
- (void)show:(BOOL)autoDismiss {
    
    [self setHidden:NO];
    //隐藏上去
    [self configDisappear];
    [RevanTipsView cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    [UIView animateWithDuration:0.3f animations:^{
        [self configAppear];
    } completion:nil];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.0f];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3f animations:^{
        [self configDisappear];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
    }];
}

#pragma mark - Loading
+ (void)revan_showLoading {
    [RevanIndicatorUtil showLoading];
}

+ (void)revan_hideLoading {
    [RevanIndicatorUtil hideLoading];
}

#pragma mark - Screen Orientation
- (void)configDisappear {
    CGFloat minLen = MIN(self.width, (IS_IPhone_X ? 44.0 + self.height : self.height));
    UIInterfaceOrientation  orient = [UIApplication sharedApplication].statusBarOrientation;
    switch (orient)
    {
        case UIInterfaceOrientationLandscapeLeft:
        {
            //home left
            self.transform = CGAffineTransformMakeRotation(-M_PI_2);
            self.center = (CGPoint){-minLen/2.0,SCREEN_MAX_LENGTH/2.0};
            break;
        }
        case UIInterfaceOrientationLandscapeRight:
        {
            //home right
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.center = (CGPoint){SCREEN_MIN_LENGTH+minLen/2.0,SCREEN_MAX_LENGTH/2.0};
            break;
        }
        default:
            self.transform = CGAffineTransformMakeTranslation(0.0f, -minLen);
            break;
    }
}


- (void)configAppear
{
    CGFloat minLen = MIN(self.width, self.height);
    //呈现出来
    UIInterfaceOrientation  orient = [UIApplication sharedApplication].statusBarOrientation;
    switch (orient)
    {
        case UIInterfaceOrientationLandscapeLeft:
        {
            //home left
            self.center = (CGPoint){minLen/2.0,SCREEN_MAX_LENGTH/2.0};
            break;
        }
        case UIInterfaceOrientationLandscapeRight:
        {
            //home right
            self.center = (CGPoint){SCREEN_MIN_LENGTH-minLen/2.0,SCREEN_MAX_LENGTH/2.0};
            break;
        }
        default:
            self.transform = CGAffineTransformIdentity;
            break;
    }
    
    NSLog(@"zxtips - appear kewWindow %@ , keyScreen %@ self %@",NSStringFromCGRect([UIApplication sharedApplication].keyWindow.frame),NSStringFromCGRect([UIScreen mainScreen].bounds), NSStringFromCGRect(self.frame));
}


@end
