//
//  UIView+RevanView.h
//  01-modularization
//
//  Created by 紫荆秋雪 on 2017/4/16.
//  Copyright © 2017年 Revan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RevanView)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  size;        ///< Shortcut for frame.size.


/**
 *  1.添加边框
 *
 *  @param color <#color description#>
 */
- (void)revan_addBorderColor:(UIColor *)color;

/**
 *  2.UIView 的点击事件
 *
 *  @param target   目标
 *  @param action   事件
 */

- (void)revan_addTarget:(id)target
           action:(SEL)action;


/**
 给UIView切圆角
 
 @param corners 圆角类型
 @param rect view的frame
 @param cornerRadii 圆角大小
 */
- (void)revan_circlePathByRoundingCorners:(UIRectCorner)corners rect:(CGRect)rect corner:(CGSize)cornerRadii;

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
                                bottomRight:(BOOL)bottomRight;

/**
 UIView背景渐变颜色
 
 @param colors 渐变颜色（必须是id类型）
 @param startPoint 渐变开始
 @param endPoint 渐变结束
 */
- (void)revan_viewAddGradientRampWithColors:(NSArray *)colors rect:(CGRect)rect startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/**
 UIView背景透明度渐变
 
 @param colors 渐变颜色（必须是id类型）
 @param startPoint 渐变开始
 @param endPoint 渐变结束
 */
- (void)revan_viewAddAlphaGradientRampWithColors:(NSArray *)colors rect:(CGRect)rect startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/**
 UIView添加圆角
 
 @param corners 圆角位置
 @param cornerRadii 圆角半角
 */
- (void)revan_viewCirclePathByRoundingCorners:(UIRectCorner)corners corner:(CGSize)cornerRadii;
/**
 UIView添加圆角
 
 @param corners 圆角位置
 @param cornerRadii 圆角半角
 @param rect   控件frame
 */
- (void)revan_viewCirclePathByRoundingCorners:(UIRectCorner)corners rect:(CGRect)rect corner:(CGSize)cornerRadii;


@end
