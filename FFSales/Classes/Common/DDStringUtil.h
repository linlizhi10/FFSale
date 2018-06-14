//
//  DDStringUtil.h
//  DaDong
//
//  Created by 李传政 on 2018/3/20.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDStringUtil : NSObject


//验证手机号码
+ (BOOL) IsMobile:(NSString *)mobileNum;
//身份证账号
+ (BOOL) IsIdentityCard:(NSString *)IDCardNumber;
//银行卡号验证
+ (BOOL) IsBankCard:(NSString *)cardNumber;
//判断是否为空字符串
+ (BOOL) IsBlankString:(NSString *)string;

//判断是否有权限访问相机
+ (BOOL) getAuthStatusFromVideo;
//判断是否有权限访问相册
+ (BOOL) getAuthStatusFromLibrary;

+ (float)getWidthOfText:(NSString *)text font:(UIFont *)font;
+ (NSString *)md5Endode32:(NSString *)str2;
//@"yyyy-MM-dd HH:mm:ss"
+ (NSString *)toDateTimeString:(long)longDate;
+ (NSString *)toDateString:(long)longDate;
+ (NSString *)toSimpleDateString:(long)longDate;

@end
