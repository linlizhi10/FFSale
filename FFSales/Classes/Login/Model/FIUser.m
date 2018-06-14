//
//  FIUser.m
//  finance
//
//  Created by 汤军 on 17/5/8.
//  Copyright © 2017年 李传政. All rights reserved.
//

#import "FIUser.h"

@implementation FIUser
static FIUser *user = nil;
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"userTypeT" : @"userType"
             };
}
+ (NSString *)propertyKey:(NSString *)propertyName{
    NSString *key;
    if ([self respondsToSelector:@selector(replacedKeyFromPropertyName)]) {
        key = [self replacedKeyFromPropertyName][propertyName];
    }
    return key?:propertyName;
}
- (id)init{
    self = [super init];
    if (self) {

        self.phone = @""; //手机号
        
        self.userType = UserTypeVisiter;
    }
    return self;
}
+ (instancetype)shareUser{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[FIUser alloc] init];
    });
    return user;
}




- (void)dataSet:(FIUser *)user{
    [FIUser shareUser].phone = user.phone;
    [FIUser shareUser].loginStatus = user.loginStatus;
    [FIUser shareUser].salesName = user.salesName;
    [FIUser shareUser].salesNo = user.salesNo;
    [FIUser shareUser].shopName = user.shopName;
    [FIUser shareUser].serviceLvL = user.serviceLvL;
    [FIUser shareUser].exclusiveMemberNum = user.exclusiveMemberNum;
    [FIUser shareUser].imgUrl = user.imgUrl;
    [FIUser shareUser].qrCode = user.qrCode;
    [FIUser shareUser].shopAddress = user.shopAddress;
    [FIUser shareUser].role = user.role;
    [FIUser shareUser].longitude = user.longitude;
    [FIUser shareUser].latitude = user.latitude;
    [FIUser shareUser].rateType = user.rateType;

/*
    [FIUser shareUser].provinceName = user.provinceName;
    [FIUser shareUser].provinceCode = user.provinceCode;
    [FIUser shareUser].cityName = user.cityName;
    [FIUser shareUser].cityCode = user.cityCode;
    [FIUser shareUser].areaName = user.areaName;
    [FIUser shareUser].areaCode = user.areaCode;
    [FIUser shareUser].shopID = user.shopID;
    [FIUser shareUser].salesID = user.salesID;

*/
    //lcz add 4.23
    [FIUser shareUser].shopID = user.shopID;
    [FIUser shareUser].shopNo = user.shopNo;
    [FIUser shareUser].provinceCode = user.provinceCode;
    [FIUser shareUser].salesID = user.salesID;
    [FIUser shareUser].cityCode = user.cityCode;
    [FIUser shareUser].areaCode = user.areaCode;

    
}
+ (void)clearUerInfo{
//    [FIUser shareUser].phone = @"";
    [FIUser shareUser].loginStatus = NO;
    [FIUser shareUser].phone = @"";
    [FIUser shareUser].salesName = @"";
    [FIUser shareUser].salesNo = @"";
    [FIUser shareUser].shopName = @"";
    [FIUser shareUser].serviceLvL = @"";
    [FIUser shareUser].exclusiveMemberNum = @"";
    [FIUser shareUser].imgUrl = @"";
    [FIUser shareUser].qrCode = @"";
    [FIUser shareUser].shopAddress = @"";
    [FIUser shareUser].longitude = @"";
    [FIUser shareUser].latitude = @"";
    [FIUser shareUser].rateType = @"";

/*    [FIUser shareUser].provinceName = @"";
    [FIUser shareUser].provinceCode = @"";
    [FIUser shareUser].cityName = @"";
    [FIUser shareUser].cityCode = @"";
    [FIUser shareUser].areaName = @"";
    [FIUser shareUser].areaCode = @"";
    [FIUser shareUser].shopID = @"";
    [FIUser shareUser].salesID = @"";
*/    //lcz add 4.23
    [FIUser shareUser].shopID = @"";
    [FIUser shareUser].shopNo = @"";
    [FIUser shareUser].provinceCode = @"";
    [FIUser shareUser].salesID = @"";
    [FIUser shareUser].cityCode = @"";
    [FIUser shareUser].areaCode = @"";
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loginStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [[NSNotificationCenter defaultCenter] postNotificationName:UserLogOutNotification object:nil];
}
@end
