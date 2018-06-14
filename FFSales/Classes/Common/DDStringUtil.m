//
//  DDStringUtil.m
//  DaDong
//
//  Created by 李传政 on 2018/3/20.
//  Copyright © 2018年 WintrueTeam. All rights reserved.
//

#import "DDStringUtil.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/Photos.h>
#import <CommonCrypto/CommonDigest.h>


@implementation DDStringUtil


#pragma mark - 验证手机号码
+ (BOOL) IsMobile:(NSString *)mobileNum
{
    NSString *phoneRegex1=@"1[34578]([0-9]){9}";
    NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex1];
    return  [phoneTest1 evaluateWithObject:mobileNum];
}

#pragma mark - 身份证验证
+ (BOOL) IsIdentityCard:(NSString *)IDCardNumber
{
    if (IDCardNumber.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:IDCardNumber];
    //    return [self CheckIsIdentityCard:IDCardNumber];
}

#pragma mark - 银行卡号验证
+ (BOOL) IsBankCard:(NSString *)cardNumber
{
    if(cardNumber.length==0)
    {
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++)
    {
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c))
        {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
    {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo)
        {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}


#pragma mark - 判断是否为空字符串
+ (BOOL) IsBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}



//判断是否有权限访问相册
+ (BOOL) getAuthStatusFromLibrary{
    
    WS(weakSelf);
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    NSString *tipTextWhenNoPhotosAuthorization; // 提示语
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:tipTextWhenNoPhotosAuthorization message:nil preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf openAppSetting];

        }]];
        [[UIApplication sharedApplication].keyWindow.rootViewController.navigationController presentViewController:alert animated:YES completion:nil];
        

        
        
        
        return NO;
    }
    return YES;
}
//判断是否有权限访问相机
+ (BOOL) getAuthStatusFromVideo{
    
    WS(weakSelf);
    
    NSString *tipTextWhenNoPhotosAuthorization; // 提示语
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-相机\"选项中，允许%@访问你的相机", appName];
        // 展示提示语
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:tipTextWhenNoPhotosAuthorization message:nil preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf openAppSetting];
            
        }]];
        [[UIApplication sharedApplication].keyWindow.rootViewController.navigationController presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    return YES;
}

+ (void)openAppSetting {
    if (CurrentSystemVersion >=8) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }else{
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *bundleID = [mainInfoDictionary objectForKey:@"CFBundleIdentifier"];
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@",bundleID]];
        BOOL success = [application openURL:URL];
        NSLog(@"Open %@: %d",@"app",success);
    }
}


+ (float)getWidthOfText:(NSString *)text font:(UIFont *)font
{
    CGSize titleSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT,40)];
    return titleSize.width;
}
//md5加密-32位 (小写)
+ (NSString *)md5Endode32:(NSString *)str2{
    const char* str = [str2 UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}
+ (NSString *)toDateString:(long)longDate{
    NSDate*timeDate = [[NSDate alloc]initWithTimeIntervalSince1970:longDate/1000.0];
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    dateFormatter.dateFormat=@"yyyy-MM-dd";
    
    return [dateFormatter stringFromDate:timeDate];
}
+ (NSString *)toDateTimeString:(long)longDate{
    NSDate*timeDate = [[NSDate alloc]initWithTimeIntervalSince1970:longDate/1000.0];
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    
    return [dateFormatter stringFromDate:timeDate];
}

+ (NSString *)toSimpleDateString:(long)longDate{
    NSDate*timeDate = [[NSDate alloc]initWithTimeIntervalSince1970:longDate/1000.0];
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    dateFormatter.dateFormat=@"yyyyMMdd";
    
    return [dateFormatter stringFromDate:timeDate];
}
@end
