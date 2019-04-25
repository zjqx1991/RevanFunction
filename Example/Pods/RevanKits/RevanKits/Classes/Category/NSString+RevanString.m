//
//  NSString+RevanString.m
//  RevanBaseModule
//
//  Created by RevanWang on 2018/8/27.
//

#import "NSString+RevanString.h"

@implementation NSString (RevanString)


/**
 设置UILabel文字富文本
 @param color 颜色
 @param font 字体大小
 */
- (NSMutableAttributedString *)revan_labelTextWithColor:(UIColor *)color font:(UIFont *)font {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,self.length)];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    return str;
}


#pragma mark - 字符串正则表达式
/**
 判断手机号码格式是否正确
 */
- (BOOL)revan_isPhoneNumber {
    if (self.length != 11) {
        return NO;
    }
    else {
        if ([[self substringToIndex:1] isEqualToString:@"1"]) {
            return YES;
        }
        return NO;
        //移动号段正则表达式
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        //联通号段正则表达式
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        //电信号段正则表达式
        NSString *CT_NUM = @"^((133)|(153)|(17[3,7])|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:self];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:self];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:self];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }
        else {
            return NO;
        }
    }
}

/**
 输入是否为中文
 */
- (BOOL)revan_isChinese {
    NSString *regex = @"[\u4e00-\u9fa5]+";
    return [self regularRegex:regex];
}

/**
 判断全数字
 */
- (BOOL)revan_isNumber {
    NSString *regex =@"[0-9]*";
   return [self regularRegex:regex];
}

/**
 判断全字母
 */
- (BOOL)revan_isEnglish {
    NSString *regex =@"[a-zA-Z]*";
    return [self regularRegex:regex];
}

/**
 判断仅输入字母或数字
 */
- (BOOL)revan_isEnglishAndNumber {
    NSString *regex =@"[a-zA-Z0-9]*";
    return [self regularRegex:regex];
}


/**
 判断仅输入字母或数字
 */
- (BOOL)revan_isChineseAndEnglishAndNumber {
    NSString *regex = @"[0-9a-zA-Z\u4e00-\u9fa5]+";
    //    NSString *regex =@"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    return [self regularRegex:regex];
}

/**
 是否为以太坊地址
 */
- (BOOL)revan_isETH {
    NSString *regex = @"^0x[0-9a-fA-F]{40}$";
    return [self regularRegex:regex];
}



#pragma mark - Private
/**
 正则表达式

 @param regex 规则
 */
- (BOOL)regularRegex:(NSString *)regex {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}



#pragma mark - 富文本

/**
 设置UILabel文字富文本
 @param color 颜色
 @param font 字体大小
 */
- (NSMutableAttributedString *)revan_attributedWithColor:(UIColor *)color font:(UIFont *)font {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,self.length)];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    return str;
}

/**
 UILabel带有图片的富文本

 @param imgName 拼接文本图片名称
 @param point 调整图片位置
 @param front 图片是否在文本之前
 @return 带有图片的富文本
 */
- (NSMutableAttributedString *)revan_attributedWithImageName:(NSString *)imgName point:(CGPoint)point imgFrontString:(BOOL)front {
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    UIImage *img = [UIImage imageNamed:imgName];
    attch.image = img;
    attch.bounds = CGRectMake(point.x, point.y, img.size.width, img.size.height);
    //创建带有图片的富文本
    NSAttributedString *imgAttribut = [NSAttributedString attributedStringWithAttachment:attch];
    if (front) {
        //将图片放在第一位
        [attri insertAttributedString:imgAttribut atIndex:0];
    }
    else {
        //将图片放在最后一位
        [attri appendAttributedString:imgAttribut];
    }
    return attri;
}


#pragma mark - 判断是否是HTTP:// HTTPS://
/**
 判断字符串是否是 http:// 开头
 */
- (BOOL)revan_isHTTP {
    return [self hasPrefix:@"http://"];
}

/**
 判断字符串是否是 https:// 开头
 */
- (BOOL)revan_isHTTPS {
    return [self hasPrefix:@"https://"];
}

/**
 判断字符串是否是 https:// 或 http:// 开头
 */
- (BOOL)revan_isHTTP_OR_HTTPS {
    return [self revan_isHTTP] || [self revan_isHTTPS];
}

@end
