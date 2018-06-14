//
//  Extention.h
//  BaseFoudation
//
//  Created by lin on 16/11/28.
//  Copyright © 2016年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Extention : NSObject
/**
 *  颜色 字号
 *
 *  @param textColor 颜色
 *  @param size      字号
 *
 *  @return label
 */
+ (UILabel *)labelTextColor:(UIColor *)textColor
                   fontSize:(CGFloat)size;
/**
 *  文字 字号
 *
 *  @param text 文字
 *  @param size      字号
 *
 *  @return label
 */
+ (UILabel *)labelWithText:(NSString *)text
                  fontSize:(CGFloat)size;
/*label 字色 行数 文字 字号*/
+ (UILabel *)labelWithTextColor:(UIColor *)textColor
                  numberOfLines:(NSInteger)numberLines
                           text:(NSString *)text
                       fontSize:(CGFloat)size;
/*label 背景色 字色 对其 行数 文字 字号*/
+ (UILabel *)labelWithBackGroundColor:(UIColor *)backGroudColor
                        textColor:(UIColor *)textColor
                        textAlignment:(NSTextAlignment)textAlignment
                  numberOfLines:(NSInteger)numberLines
                           text:(NSString *)text
                       fontSize:(CGFloat)size;
/*
 判断手机号是否合法
 */
+ (BOOL)phoneNumberValid:(NSString *)phoneString;

/*  判断用户输入的密码是否符合规范，符合规范的密码要求：
1. 长度大于8位
2. 密码中必须同时包含数字和字母
*/
+(BOOL)judgePassWordLegal:(NSString *)pass;
@end
