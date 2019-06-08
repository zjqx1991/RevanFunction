//
//  RevanQRCodeScanViewController.m
//  RevanFunction
//
//  Created by RevanWang on 2018/8/25.
//

#import "RevanQRCodeScanViewController.h"
#import "RevanQRCodeScanView.h"
#import "RevanQRCodePhotoManager.h"
#import "RevanQRCodeScanManager.h"
#import "UIImage+RevanImage.h"

@interface RevanQRCodeScanViewController ()<RevanQRCodePhotoManagerDelegate, RevanQRCodeScanManagerDelegate>
@property (nonatomic, strong) RevanQRCodeScanView *scanningView;
@property (nonatomic, strong) RevanQRCodeScanManager *manager;
@property (nonatomic, strong) UIButton *flashlightBtn;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) BOOL isSelectedFlashlightBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *photoBtn;
@end

@implementation RevanQRCodeScanViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
    [_manager revan_resetSampleBufferDelegate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
    [self removeFlashlightBtn];
    [_manager revan_cancelSampleBufferDelegate];
}

- (void)dealloc {
    NSLog(@"SGQRCodeScanningVC - dealloc");
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupNavigationBar];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scanningView];
    [self setupQRCodeScanning];
    [self.view addSubview:self.promptLabel];
    /// 为了 UI 效果
    [self.view addSubview:self.bottomView];
}

- (void)setupNavigationBar {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.photoBtn];
}


- (void)setupQRCodeScanning {
    self.manager = [RevanQRCodeScanManager revan_sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [_manager revan_setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    //    [manager cancelSampleBufferDelegate];
    _manager.delegate = self;
}

- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}

- (void)rightBarButtonItenAction {
    RevanQRCodePhotoManager *manager = [RevanQRCodePhotoManager sharedManager];
    [manager readQRCodeFromAlbumWithCurrentController:self];
    manager.delegate = self;
    if (manager.isPHAuthorization == YES) {
        [self.scanningView removeTimer];
    }
}


#pragma mark - RevanQRCodePhotoManagerDelegate 代理
/**
 取消从相册中获取图片
 */
- (void)cancelQRCodePhotoManager:(RevanQRCodePhotoManager *)photoManager {
    if (self.scanningView.superview == nil) {
        [self.view addSubview:self.scanningView];
    }
}

/**
 从二维码图片中获取内容
 */
- (void)qrCodePhotoManager:(RevanQRCodePhotoManager *)photoManager didFinishPickingMediaWithResult:(NSString *)result {
    [self qrCodeComplete:result];
}

#pragma mark - RevanQRCodeScanManagerDelegate
/**
 获取亮度
 */
- (void)revan_QRCodeScanManager:(RevanQRCodeScanManager *)scanManager brightnessValue:(CGFloat)brightnessValue {
    if (brightnessValue < 0) {
        [self.view addSubview:self.flashlightBtn];
    }
    else {
        if (self.isSelectedFlashlightBtn == NO) {
            [self removeFlashlightBtn];
        }
    }
}

/**
 扫描获取二维码内容
 */
- (void)revan_QRCodeScanManager:(RevanQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    NSLog(@"metadataObjects - - %@", metadataObjects);
    if (metadataObjects != nil && metadataObjects.count > 0) {
        [scanManager revan_palySoundName:@"sound.caf"];
        [scanManager revan_stopRunning];
        [scanManager revan_videoPreviewLayerRemoveFromSuperlayer];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        [self qrCodeComplete:[obj stringValue]];
    }
    else {
        NSLog(@"暂未识别出扫描的二维码");
    }
}

/**
 扫描二维码获取内容

 @param urlstr 内容
 */
- (void)qrCodeComplete:(NSString *)urlstr {
    if (self.completeBlock) {
        self.completeBlock(urlstr);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickCloseBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - - - 闪光灯按钮
- (UIButton *)flashlightBtn {
    if (!_flashlightBtn) {
        // 添加闪光灯按钮
        _flashlightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        CGFloat flashlightBtnW = 30;
        CGFloat flashlightBtnH = 30;
        CGFloat flashlightBtnX = 0.5 * (self.view.frame.size.width - flashlightBtnW);
        CGFloat flashlightBtnY = 0.55 * self.view.frame.size.height;
        _flashlightBtn.frame = CGRectMake(flashlightBtnX, flashlightBtnY, flashlightBtnW, flashlightBtnH);
        [_flashlightBtn setBackgroundImage:[UIImage revan_assetImageName:@"QRCodeFlashlightOpenImage" inDirectoryBundleName:@"RevanQRCode" commandClass:[self class]] forState:(UIControlStateNormal)];
        [_flashlightBtn setBackgroundImage:[UIImage revan_assetImageName:@"QRCodeFlashlightCloseImage" inDirectoryBundleName:@"RevanQRCode" commandClass:[self class]] forState:(UIControlStateSelected)];
        [_flashlightBtn addTarget:self action:@selector(flashlightBtn_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashlightBtn;
}

- (void)flashlightBtn_action:(UIButton *)button {
    if (button.selected == NO) {
        [RevanQRCodeScanManager revan_openFlashlight];
        self.isSelectedFlashlightBtn = YES;
        button.selected = YES;
    } else {
        [self removeFlashlightBtn];
    }
}

- (void)removeFlashlightBtn {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [RevanQRCodeScanManager revan_CloseFlashlight];
        self.isSelectedFlashlightBtn = NO;
        self.flashlightBtn.selected = NO;
        [self.flashlightBtn removeFromSuperview];
    });
}


#pragma mark - getter && setter
- (RevanQRCodeScanView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[RevanQRCodeScanView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.9 * self.view.frame.size.height)];
//                _scanningView.scanningImageName = @"QRCodeScanningLineGrid";
//                _scanningView.scanAnimationStyle = RevanScanAnimationStyleGrid;
//                _scanningView.cornerColor = [UIColor orangeColor];
    }
    return _scanningView;
}


- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scanningView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.scanningView.frame))];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _bottomView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 40)];
        _titleLabel.text = @"Scan";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _closeBtn.frame = CGRectMake(20, 20, 30, 30);
        [_closeBtn setImage:[UIImage revan_assetImageName:@"close" inDirectoryBundleName:@"RevanQRCode" commandClass:[self class]] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(onClickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}


- (UIButton *)photoBtn {
    if (!_photoBtn) {
        _photoBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _photoBtn.frame = CGRectMake(self.view.bounds.size.width - 80, 20, 80, 30);
        [_photoBtn setTitle:@"photo" forState:UIControlStateNormal];
        [_photoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_photoBtn addTarget:self action:@selector(rightBarButtonItenAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoBtn;
}

@end
