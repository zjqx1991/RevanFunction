//
//  RevanQRCodeManager.m
//  AFNetworking
//
//  Created by RevanWang on 2018/8/25.
//

#import "RevanQRCodeManager.h"
#import <AVFoundation/AVFoundation.h>
#import "RevanQRCode.h"
#import "RevanQRCodeScanViewController.h"

@interface RevanQRCodeManager ()
/** 扫描VC */
@property (nonatomic, strong) RevanQRCodeScanViewController *qrCodeScanVC;
@end

@implementation RevanQRCodeManager


+ (instancetype)sharedManager {
    static RevanQRCodeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RevanQRCodeManager alloc] init];
    });
    return manager;
}

#pragma mark - 生成二维码
/**
 *  生成一张普通的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param imageViewWidth    图片的宽度
 */
+ (UIImage *)revan_defaultQRCodeWithData:(NSString *)data imageViewWidth:(CGFloat)imageViewWidth {
    return [RevanQRCode revanQR_defaultQRCodeWithData:data imageViewWidth:imageViewWidth];
}


/**
 *  生成一张带有logo的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param logoImage    logo的image
 *  @param scale    logo相对于父视图的缩放比（取值范围：0-1，0，代表不显示，1，代表与父视图大小相同）
 */
+ (UIImage *)revan_logoQRCodeWithData:(NSString *)data logoImage:(UIImage *)logoImage scale:(CGFloat)scale {
    return [RevanQRCode revanQR_logoQRCodeWithData:data logoImage:logoImage scale:scale];
}

/**
 *  生成一张彩色的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param backgroundColor    背景色
 *  @param mainColor    主颜色
 */
+ (UIImage *)revan_colorQRCodeWithData:(NSString *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor {
    return [RevanQRCode revanQR_colorQRCodeWithData:data backgroundColor:backgroundColor mainColor:mainColor];
}

/**
 生成一张带有logo的彩色二维码
 
 @param data 传入你要生成二维码的数据
 @param backgroundColor 背景色
 @param mainColor 主颜色
 @param logoImage logo图片
 @param scale logo相对于父视图的缩放比（取值范围：0-1，0，代表不显示，1，代表与父视图大小相同）
 @return 生成一张带有logo的彩色二维码
 */
+ (UIImage *)revan_colorLogoQRCodeWithData:(NSString *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor logoImage:(UIImage *)logoImage scale:(CGFloat)scale {
    return [RevanQRCode revanQR_colorLogoQRCodeWithData:data backgroundColor:backgroundColor mainColor:mainColor logoImage:logoImage scale:scale];
}

#pragma mark - 扫描二维码
- (void)revan_qrcodeScanVC:(UIViewController *)superVC {
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [superVC presentViewController:self.qrCodeScanVC animated:YES completion:nil];
                    });
                    // 用户第一次同意了访问相机权限
                    NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    
                }
                else {
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                }
            }];
        }
        else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            dispatch_async(dispatch_get_main_queue(), ^{
                [superVC presentViewController:self.qrCodeScanVC animated:YES completion:nil];
            });
        }
        else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"请去-> [设置 - 隐私 - %@] 打开访问开关", @"相机"] preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
            
            UIAlertAction *gotoAlert = [UIAlertAction actionWithTitle:@"去设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            [alertVC addAction:cancelAlert];
            [alertVC addAction:gotoAlert];
            [superVC presentViewController:alertVC animated:YES completion:nil];
        }
        else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    }
    else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [superVC presentViewController:alertC animated:YES completion:nil];
    }
}

#pragma mark - getter
- (RevanQRCodeScanViewController *)qrCodeScanVC {
    _qrCodeScanVC = [[RevanQRCodeScanViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    _qrCodeScanVC.completeBlock = ^(NSString *urlstr) {
        if (weakSelf.completeBlock) {
            weakSelf.completeBlock(urlstr);
        }
    };
    return _qrCodeScanVC;
}

@end
