//
//  RevanSnapshot.m
//  AFNetworking
//
//  Created by RevanWang on 2018/10/26.
//

#import "RevanSnapshot.h"

@implementation RevanSnapshot


/**
 显示截图
 
 @param snapshot 截图view
 @param isSave 是否保存截图到相册
 */
+ (UIImage *)revan_snapShotView:(UIView *)snapshot savePhoto:(BOOL)isSave {
    UIImage *img = [self captureImageFromView:snapshot];
    if (isSave) {
        [self saveToPhotosAlbum:img];
    }
    return img;
}

//截图功能
+ (UIImage *)captureImageFromView:(UIView *)view{
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size,NO, 0);
    
    [[UIColor clearColor] setFill];
    
    [[UIBezierPath bezierPathWithRect:view.bounds] fill];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:ctx];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

//保存到相册
+ (void)saveToPhotosAlbum:(UIImage *)img {
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    NSLog(@"%@", msg);
}

@end
