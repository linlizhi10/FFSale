//
//  Extention.m
//  BaseFoudation
//
//  Created by lin on 16/11/28.
//  Copyright © 2016年 lin. All rights reserved.
//

#import "Extention.h"

@implementation Extention
+ (UILabel *)labelTextColor:(UIColor *)textColor
                   fontSize:(CGFloat)size{
    return [Extention labelWithBackGroundColor:[UIColor clearColor] textColor:textColor textAlignment:NSTextAlignmentLeft numberOfLines:1 text:nil fontSize:size];
}

+ (UILabel *)labelWithText:(NSString *)text
                  fontSize:(CGFloat)size{
     return [Extention labelWithBackGroundColor:[UIColor clearColor] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft numberOfLines:1 text:text fontSize:size];

}
+ (UILabel *)labelWithTextColor:(UIColor *)textColor
                  numberOfLines:(NSInteger)numberLines
                           text:(NSString *)text
                       fontSize:(CGFloat)size{
 return [Extention labelWithBackGroundColor:[UIColor clearColor] textColor:textColor textAlignment:NSTextAlignmentLeft numberOfLines:numberLines text:text fontSize:size];
}
/*label 背景色 字色 对其 行数 文字 字号*/
+ (UILabel *)labelWithBackGroundColor:(UIColor *)backGroudColor
                            textColor:(UIColor *)textColor
                        textAlignment:(NSTextAlignment)textAlignment
                        numberOfLines:(NSInteger)numberLines
                                 text:(NSString *)text
                             fontSize:(CGFloat)size{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = backGroudColor;
    label.textColor =  textColor;
    label.textAlignment = textAlignment;
    label.numberOfLines = numberLines;
    label.text = text;
    label.font = [UIFont systemFontOfSize:size];
    return label;
}
+ (BOOL)phoneNumberValid:(NSString *)phoneString{
    if (phoneString.length == 0) {
        return NO;
    }
    NSString *mobileExp = @"^(1[3-9])\\d{9}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileExp];
    if (([regextestmobile evaluateWithObject:phoneString] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

+(BOOL)judgePassWordLegal:(NSString *)pass{
    
    return YES;
    
    BOOL result = false;
//    if ([pass length] >= 8){
//        // 判断长度大于8位后再接着判断是否同时包含数字和字符
//        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$";
//        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//        if ([pred evaluateWithObject:pass]) {
//            NSString * regex = @"^[A-Za-z0-9]{8,20}$";
//            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//            result = [pred evaluateWithObject:pass];
//        }
//        
//    }
    if ([pass length] >= 6) {
        result = YES;
    }
    return result;
}

@end
