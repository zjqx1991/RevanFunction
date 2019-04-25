//
//  NSString+RevanString.h
//  RevanBaseModule
//
//  Created by RevanWang on 2018/8/27.
//

#import <Foundation/Foundation.h>

@interface NSString (RevanString)


#pragma mark - 富文本
/**
 设置UILabel文字富文本
 @param color 颜色
 @param font 字体大小
 */
- (NSMutableAttributedString *)revan_labelTextWithColor:(UIColor *)color font:(UIFont *)font;

#pragma mark - 字符串正则表达式
/**
 判断手机号码格式是否正确
 */
- (BOOL)revan_isPhoneNumber;
/**
 输入是否为中文
 */
- (BOOL)revan_isChinese;
/**
 判断全数字
 */
- (BOOL)revan_isNumber;

/**
 判断全字母
 */
- (BOOL)revan_isEnglish;
/**
 判断仅输入字母或数字
 */
- (BOOL)revan_isEnglishAndNumber;

/**
 判断仅输入字母或数字或中文
 */
- (BOOL)revan_isChineseAndEnglishAndNumber;
/**
 是否为以太坊地址
 */
- (BOOL)revan_isETH;

#pragma mark - 富文本

/**
 设置UILabel文字富文本
 @param color 颜色
 @param font 字体大小
 */
- (NSMutableAttributedString *)revan_attributedWithColor:(UIColor *)color font:(UIFont *)font;

/**
 UILabel带有图片的富文本
 
 @param imgName 拼接文本图片名称
 @param point 调整图片位置
 @param front 图片是否在文本之前
 @return 带有图片的富文本
 */
- (NSMutableAttributedString *)revan_attributedWithImageName:(NSString *)imgName point:(CGPoint)point imgFrontString:(BOOL)front;


#pragma mark - 判断是否是HTTP:// HTTPS://

/**
 判断字符串是否是 https:// 或 http:// 开头
 */
- (BOOL)revan_isHTTP_OR_HTTPS;

/**
 判断字符串是否是 http:// 开头
 */
- (BOOL)revan_isHTTP;

/**
 判断字符串是否是 https:// 开头
 */
- (BOOL)revan_isHTTPS;

@end
