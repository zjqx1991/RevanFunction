//
//  RevanQRCode.m
//  AFNetworking
//
//  Created by RevanWang on 2018/8/25.
//

#import "RevanQRCode.h"

@implementation RevanQRCode
#pragma mark - Publick
/**
 *  生成一张普通的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param imageViewWidth    图片的宽度
 */
+ (UIImage *)revanQR_defaultQRCodeWithData:(NSString *)data imageViewWidth:(CGFloat)imageViewWidth {
    // 获得滤镜输出的图像
    CIImage *outputImage = [self createCIImageWithData:data];
    return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:imageViewWidth];
}

/**
 *  生成一张带有logo的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param logoImage    logo的image
 *  @param scale    logo相对于父视图的缩放比（取值范围：0-1，0，代表不显示，1，代表与父视图大小相同）
 */
+ (UIImage *)revanQR_logoQRCodeWithData:(NSString *)data logoImage:(UIImage *)logoImage scale:(CGFloat)scale {
    // 1.获得滤镜输出的图像
    CIImage *outputImage = [self createCIImageWithData:data];
    
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    // 2、将CIImage类型转成UIImage类型
    UIImage *start_image = [UIImage imageWithCIImage:outputImage];
    return [self mergeSuperImage:start_image subImage:logoImage scale:scale];
}

/**
 *  生成一张彩色的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param backgroundColor    背景色
 *  @param mainColor    主颜色
 */
+ (UIImage *)revanQR_colorQRCodeWithData:(NSString *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor {
    // 1、获得滤镜输出的图像
    CIImage *outputImage = [self createCIImageWithData:data];
    
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
    
    // 4、创建彩色过滤器(彩色的用的不多)
    CIFilter * color_filter = [CIFilter filterWithName:@"CIFalseColor"];
    
    // 设置默认值
    [color_filter setDefaults];
    
    // 5、KVC 给私有属性赋值
    [color_filter setValue:outputImage forKey:@"inputImage"];
    
    // 6、需要使用 CIColor
    [color_filter setValue:backgroundColor forKey:@"inputColor0"];
    [color_filter setValue:mainColor forKey:@"inputColor1"];
    
    // 7、设置输出
    CIImage *colorImage = [color_filter outputImage];
    
    return [UIImage imageWithCIImage:colorImage];
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
+ (UIImage *)revanQR_colorLogoQRCodeWithData:(NSString *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor logoImage:(UIImage *)logoImage scale:(CGFloat)scale; {
    UIImage *ColorImage = [self revanQR_colorQRCodeWithData:data
                                          backgroundColor:backgroundColor
                                                mainColor:mainColor];
    return [self mergeSuperImage:ColorImage subImage:logoImage scale:scale];
}

#pragma mark - Private Method

/**
 合并图片

 @param superImage 父图
 @param subImg 子图
 @param scale 子图占父图的比例
 @return 合并后的图
 */
+ (UIImage *)mergeSuperImage:(UIImage *)superImage subImage:(UIImage *)subImg scale:(CGFloat)scale {
    // 1、开启绘图, 获取图形上下文 (上下文的大小, 就是二维码的大小)
    UIGraphicsBeginImageContext(superImage.size);
    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
    [superImage drawInRect:CGRectMake(0, 0, superImage.size.width, superImage.size.height)];
    
    // 2、再把小图片画上去
    UIImage *icon_image = subImg;
    CGFloat icon_imageW = superImage.size.width * scale;
    CGFloat icon_imageH = superImage.size.height * scale;
    CGFloat icon_imageX = (superImage.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (superImage.size.height - icon_imageH) * 0.5;
    
    [icon_image drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    
    // 3、获取当前画得的这张图片
    UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4、关闭图形上下文
    UIGraphicsEndImageContext();
    return final_image;
}

/**
 获得滤镜输出的图像

 @param data 传入你要生成二维码的数据
 @return 获得滤镜输出的图像
 */
+ (CIImage *)createCIImageWithData:(NSString *)data {
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *info = data;
    // 将字符串转换成
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    
    // 通过KVC设置滤镜inputMessage数据
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    return outputImage;
}

/**
 根据CIImage生成指定大小的UIImage
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGColorSpaceRelease(cs);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    UIImage *img = [UIImage imageWithCGImage:scaledImage];
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGImageRelease(scaledImage);
    return img;
}

@end
