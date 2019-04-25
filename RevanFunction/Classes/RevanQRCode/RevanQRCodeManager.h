//
//  RevanQRCodeManager.h
//  AFNetworking
//
//  Created by RevanWang on 2018/8/25.
//

#import <Foundation/Foundation.h>

#define kRevanQRCodeManager [RevanQRCodeManager sharedManager]


typedef void(^RevanQRCodeManagerCompleteBlock)(NSString *result);

@interface RevanQRCodeManager : NSObject
/** 扫描二维码内容回调 */
@property (nonatomic, copy) RevanQRCodeManagerCompleteBlock completeBlock;

+ (instancetype)sharedManager;

#pragma mark - 生成二维码图片
/**
 *  生成一张普通的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param imageViewWidth    图片的宽度
 */
+ (UIImage *)revan_defaultQRCodeWithData:(NSString *)data imageViewWidth:(CGFloat)imageViewWidth;


/**
 *  生成一张带有logo的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param logoImage    logo的image
 *  @param scale    logo相对于父视图的缩放比（取值范围：0-1，0，代表不显示，1，代表与父视图大小相同）
 */
+ (UIImage *)revan_logoQRCodeWithData:(NSString *)data logoImage:(UIImage *)logoImage scale:(CGFloat)scale;

/**
 *  生成一张彩色的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param backgroundColor    背景色
 *  @param mainColor    主颜色
 */
+ (UIImage *)revan_colorQRCodeWithData:(NSString *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor;

/**
 生成一张带有logo的彩色二维码
 
 @param data 传入你要生成二维码的数据
 @param backgroundColor 背景色
 @param mainColor 主颜色
 @param logoImage logo图片
 @param scale logo相对于父视图的缩放比（取值范围：0-1，0，代表不显示，1，代表与父视图大小相同）
 @return 生成一张带有logo的彩色二维码
 */
+ (UIImage *)revan_colorLogoQRCodeWithData:(NSString *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor logoImage:(UIImage *)logoImage scale:(CGFloat)scale;

#pragma mark - 扫描二维码
- (void)revan_qrcodeScanVC:(UIViewController *)superVC;


@end
