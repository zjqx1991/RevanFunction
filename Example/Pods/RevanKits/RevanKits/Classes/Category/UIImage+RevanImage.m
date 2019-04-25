//
//  UIImage+RevanImage.m
//  01-modularization
//
//  Created by 紫荆秋雪 on 2017/4/16.
//  Copyright © 2017年 Revan. All rights reserved.
//

#import "UIImage+RevanImage.h"


#define SGQRCodeScreenWidth [UIScreen mainScreen].bounds.size.width
#define SGQRCodeScreenHeight [UIScreen mainScreen].bounds.size.height


@implementation UIImage (RevanImage)

+ (UIImage *)revan_originImageWithName:(NSString *)name {
    return [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)revan_circleImage {
    CGSize size = self.size;
    CGFloat drawWH = size.width < size.height ? size.width : size.height;
    
    ///开启图形上下文
    UIGraphicsBeginImageContext(CGSizeMake(drawWH, drawWH));
    ///绘制一个圆形区域，进行裁剪
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect clipRect = CGRectMake(0, 0, drawWH, drawWH);
    CGContextAddEllipseInRect(context, clipRect);
    CGContextClip(context);
    ///绘制大图片
    CGRect drawRect = CGRectMake(0, 0, size.width, size.height);
    [self drawInRect:drawRect];
    ///取出结果图片
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    ///关闭上下文
    UIGraphicsEndImageContext();
    return resultImage;
}

/**
 通过路径加载组件中的图片资源(使用.xcassets存储图片资源 !!!推荐使用)
 
 @param imageName 图片名称
 @param bundleName 图片所在bundle(RRR.bundle,只需传RRR)
 @param Class 图片所在类
 @return 图片
 */
+ (instancetype)revan_assetImageName:(NSString *)imageName inDirectoryBundleName:(NSString *)bundleName commandClass:(Class)Class {
    
    NSBundle *bundle = [NSBundle bundleForClass:Class];
    NSURL *url = [bundle URLForResource:bundleName withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:url];
    UIImage *image = [UIImage imageNamed:imageName
                                inBundle:bundle
           compatibleWithTraitCollection:nil];
    //再将图片的类型改为保持圆形
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

/**
 通过路径加载组件中的图片资源
 
 @param imageName 图片名称
 @param bundle 图片所在bundle
 @param Class 图片所在类
 @return 图片
 */
+ (instancetype)revan_imageName:(NSString *)imageName inDirectoryBundleName:(NSString *)bundleName commandClass:(Class)Class {
    /** 屏幕比 */
    NSInteger scale = (NSInteger)[[UIScreen mainScreen] scale];
    /** 当前Bundle */
    NSBundle *currentBundle = [NSBundle bundleForClass:Class];
    /** 图片完整名称 */
    NSString *name = [NSString stringWithFormat:@"%@@%zdx",imageName,scale];
    /** 图片所属bundle */
    NSString *bundleNames = [NSString stringWithFormat:@"%@.bundle",bundleName];
    /** 图片资源路径 */
    NSString *imagePath = [currentBundle pathForResource:name ofType:@"png" inDirectory:bundleNames];
    return imagePath ? [UIImage imageWithContentsOfFile:imagePath] : nil;
}


/** 返回一张不超过屏幕尺寸的 image */
+ (UIImage *)revan_imageSizeWithScreenImage:(UIImage *)image {
    {
        CGFloat imageWidth = image.size.width;
        CGFloat imageHeight = image.size.height;
        CGFloat screenWidth = SGQRCodeScreenWidth;
        CGFloat screenHeight = SGQRCodeScreenHeight;
        
        if (imageWidth <= screenWidth && imageHeight <= screenHeight) {
            return image;
        }
        
        CGFloat max = MAX(imageWidth, imageHeight);
        CGFloat scale = max / (screenHeight * 2.0);
        
        CGSize size = CGSizeMake(imageWidth / scale, imageHeight / scale);
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
}


/**
 使用颜色生成图片
 
 @param color 颜色
 @return 生成图片
 */
+ (UIImage *)revan_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 开启上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(ref, color.CGColor);
    // 渲染上下文
    CGContextFillRect(ref, rect);
    // 从上下文中获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return image;
}

@end
