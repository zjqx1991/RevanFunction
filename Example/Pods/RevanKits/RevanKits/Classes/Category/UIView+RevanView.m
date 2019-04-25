//
//  UIView+RevanView.m
//  01-modularization
//
//  Created by 紫荆秋雪 on 2017/4/16.
//  Copyright © 2017年 Revan. All rights reserved.
//

#import "UIView+RevanView.h"
#import <objc/runtime.h>

static NSString * maskLayerKey;
@implementation UIView (RevanView)


-(CGFloat)x{
    return self.frame.origin.x;
}

-(void)setX:(CGFloat)x {
    CGRect temp = self.frame;
    temp.origin.x = x;
    self.frame = temp;
}

-(CGFloat)y{
    return self.frame.origin.y;
}

-(void)setY:(CGFloat)y {
    CGRect temp = self.frame;
    temp.origin.y = y;
    self.frame = temp;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


- (void)revan_addTarget:(id)target
           action:(SEL)action;
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target
                                                                         action:action];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

- (void)revan_addBorderColor:(UIColor *)color{
    [self.layer setBorderColor:color.CGColor];
    [self.layer setBorderWidth:0.5];
    [self.layer setCornerRadius:4];
}

/**
 给UIView切圆角

 @param corners 圆角类型
 @param rect view的frame
 @param cornerRadii 圆角大小
 */
- (void)revan_circlePathByRoundingCorners:(UIRectCorner)corners rect:(CGRect)rect corner:(CGSize)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}



/**
 切带有圆角的图片

 @param rect frame
 @param color 填充颜色
 @param borderColor 边框颜色
 @param radius 圆角半径
 @param topLeft topLeft 圆角
 @param topRight topRight 圆角
 @param bottomLeft bottomLeft 圆角
 @param bottomRight bottomRight 圆角
 */
- (UIImage *)revan_createImageViewWithFrame:(CGRect)rect
                        background:(CGColorRef)color
                        borderColor:(CGColorRef)borderColor
                             radius:(CGFloat)radius
                              topLeft:(BOOL)topLeft
                             topRight:(BOOL)topRight
                           bottomLeft:(BOOL)bottomLeft
                          bottomRight:(BOOL)bottomRight {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    UIGraphicsBeginImageContext(imageView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();   // 设置上下文
    CGContextSetLineWidth(context, 1);                  // 边框大小
    CGContextSetStrokeColorWithColor(context, borderColor);   // 边框颜色
    CGContextSetFillColorWithColor(context, color);     // 填充颜色
    
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGContextMoveToPoint(context, x+width, y+radius/2);
    CGContextAddArcToPoint(context, x+width, y+height, x+width-radius/2, y+height, bottomRight ? radius : 0);//BottomRight
    CGContextAddArcToPoint(context, x, y+height, x, y+height-radius/2, bottomLeft ? radius : 0);//BottomLeft
    CGContextAddArcToPoint(context, x, y, x+radius/2, y, topLeft ? radius : 0);//TopLeft
    CGContextAddArcToPoint(context, x+width, y, x+width, y+radius/2, topRight ? radius : 0);//TopRight
    CGContextDrawPath(context, kCGPathFillStroke);
    
    return UIGraphicsGetImageFromCurrentImageContext();;
}


/**
 UIView背景渐变颜色
 
 @param colors 渐变颜色（必须是id类型）
 @param startPoint 渐变开始
 @param endPoint 渐变结束
 */

- (void)revan_viewAddGradientRampWithColors:(NSArray *)colors rect:(CGRect)rect startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    
    id gralayer = objc_getAssociatedObject(self, &maskLayerKey);
    if (gralayer) {
        [(CALayer *)gralayer  removeFromSuperlayer];
    }
    //在后面添加渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = rect;
    gradientLayer.colors = colors;
    //渐变的方向（0，0） （0，1） （1，0）（1，1）为四个顶点方向
    //(I.e. [0,0] is the bottom-left
    // corner of the layer, [1,1] is the top-right corner.) The default values
    // are [.5,0] and [.5,1]
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    [self.layer insertSublayer:gradientLayer atIndex:0];
    objc_setAssociatedObject(self, &maskLayerKey, gradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)revan_viewAddAlphaGradientRampWithColors:(NSArray *)colors rect:(CGRect)rect startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    
    id gralayer = objc_getAssociatedObject(self, &maskLayerKey);
    if (gralayer) {
        [(CALayer *)gralayer  removeFromSuperlayer];
    }
    
    //为透明度设置渐变效果
    if (colors == nil) {
        UIColor *colorOne = [UIColor colorWithRed:(0/255.0)  green:(0/255.0)  blue:(0/255.0)  alpha:0.0];
        UIColor *colorTwo = [UIColor colorWithRed:(0/255.0)  green:(0/255.0)  blue:(0/255.0)  alpha:0.0];
        UIColor *colorThree = [UIColor colorWithRed:(0/255.0)  green:(0/255.0)  blue:(0/255.0)  alpha:0.0];
        UIColor *colorFire = [UIColor colorWithRed:(0/255.0)  green:(0/255.0)  blue:(0/255.0)  alpha:0.0];
        UIColor *colorSix = [UIColor colorWithRed:(0/255.0)  green:(0/255.0)  blue:(0/255.0)  alpha:0.2];
        UIColor *colorSeven = [UIColor colorWithRed:(0/255.0)  green:(0/255.0)  blue:(0/255.0)  alpha:0.4];
        colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFire.CGColor, colorSix.CGColor, colorSeven.CGColor, nil];
    }
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置开始和结束位置(设置渐变的方向)
    gradient.startPoint = startPoint;
    gradient.endPoint = endPoint;
    gradient.colors = colors;
    gradient.frame = rect;
    [self.layer insertSublayer:gradient atIndex:0];
    
    objc_setAssociatedObject(self, &maskLayerKey, gradient, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 UIView添加圆角
 
 @param corners 圆角位置
 @param cornerRadii 圆角半角
 */
- (void)revan_viewCirclePathByRoundingCorners:(UIRectCorner)corners corner:(CGSize)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/**
 UIView添加圆角
 
 @param corners 圆角位置
 @param cornerRadii 圆角半角
 @param rect   控件frame
 */
- (void)revan_viewCirclePathByRoundingCorners:(UIRectCorner)corners rect:(CGRect)rect corner:(CGSize)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
