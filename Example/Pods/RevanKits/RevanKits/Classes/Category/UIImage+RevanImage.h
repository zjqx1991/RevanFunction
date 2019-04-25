//
//  UIImage+RevanImage.h
//  01-modularization
//
//  Created by 紫荆秋雪 on 2017/4/16.
//  Copyright © 2017年 Revan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RevanImage)

/**
 使图片原图显示
 */
+ (UIImage *)revan_originImageWithName:(NSString *)name;

/**
 图片切圆
 */
- (UIImage *)revan_circleImage;


/**
 通过路径加载组件中的图片资源(使用.xcassets存储图片资源 !!!推荐使用)
 
 @param imageName 图片名称
 @param bundleName 图片所在bundle(RRR.bundle,只需传RRR)
 @param Class 图片所在类
 @return 图片
 */
+ (instancetype)revan_assetImageName:(NSString *)imageName inDirectoryBundleName:(NSString *)bundleName commandClass:(Class)Class;

/**
 通过路径加载组件中的图片资源

 @param imageName 图片名称
 @param bundleName 图片所在bundle(RRR.bundle,只需传RRR)
 @param Class 图片所在类
 @return 图片
 */
+ (instancetype)revan_imageName:(NSString *)imageName inDirectoryBundleName:(NSString *)bundleName commandClass:(Class)Class;


/** 返回一张不超过屏幕尺寸的 image */
+ (UIImage *)revan_imageSizeWithScreenImage:(UIImage *)image;


/**
 使用颜色生成图片

 @param color 颜色
 @return 生成图片
 */
+ (UIImage *)revan_imageWithColor:(UIColor *)color;
@end
